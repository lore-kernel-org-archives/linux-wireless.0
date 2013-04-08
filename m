Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2909 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175Ab3DHJLa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 05:11:30 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH] cfg80211: introduce critical protocol indication from
 user-space
Date: Mon, 8 Apr 2013 11:09:33 +0200
Message-ID: <1365412173-7428-1-git-send-email-arend@broadcom.com> (sfid-20130408_111133_780186_685AB8A8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some protocols need a more reliable connection to complete
successful in reasonable time. This patch adds a user-space
API to indicate the wireless driver that a critical protocol
is about to commence and when it is done, using nl80211 primitives
NL80211_CMD_CRIT_PROTOCOL_START and NL80211_CRIT_PROTOCOL_STOP.

There can be only on critical protocol session started per
registered cfg80211 device. The driver can support this by
implementing the cfg80211 callbacks .crit_proto_start() and
.crit_proto_stop(). Examples of protocols that can benefit from
this are DHCP, EAPOL, APIPA. Exactly how the link can/should be
made more reliable is up to the driver. Things to consider are
avoid scanning, no multi-channel operations, and alter coexistence
schemes.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
Hi Johannes,

I decided based on last comments to submit it as a patch this
time for inclusion in the mac80211-next repository. Last changes
made are mentioned in V5 below. It applies to the master branch on
top of commit "37a0116 mac80211: fix do_stop handling while suspended"

Regards, Arend

Changelog:
----------
V5:
- change return type for .crit_prot_stop() to void.
- correct limiting the duration.
V4:
- added cfg80211_crit_proto_stopped() for drivers to use.
- added back protocol identifier for drivers to use.
- reject starting critical protocol session when already started.
- critical protocol session tracked per registered device.
V3:
- remove protocol identifier.
- remove delayed work from cfg80211.
- guard maximum limit for duration.
- do .crit_proto_stop() upon netlink socket release.
V2:
- subject changed. Below previous subject is given for reference:
  [RFC] cfg80211: configuration of Bluetooth coexistence mode
- introduced dedicated nl80211 API.
V1:
- initial proposal.
---
 include/net/cfg80211.h       |   23 ++++++++++++
 include/uapi/linux/nl80211.h |   31 ++++++++++++++++
 net/wireless/core.h          |    3 ++
 net/wireless/mlme.c          |    3 ++
 net/wireless/nl80211.c       |   81 ++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      |   28 ++++++++++++++-
 net/wireless/trace.h         |   35 ++++++++++++++++++
 7 files changed, 203 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 57870b6..f75d720 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2002,6 +2002,9 @@ struct cfg80211_update_ft_ies_params {
  * @update_ft_ies: Provide updated Fast BSS Transition information to the
  *	driver. If the SME is in the driver/firmware, this information can be
  *	used in building Authentication and Reassociation Request frames.
+ * @crit_proto_start: Indicates a critical protocol needs more link reliability.
+ * @crit_proto_stop: Indicates critical protocol no longer needs increased link
+ *	reliability. This operation can not fail.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -2231,6 +2234,12 @@ struct cfg80211_ops {
 					 struct cfg80211_chan_def *chandef);
 	int	(*update_ft_ies)(struct wiphy *wiphy, struct net_device *dev,
 				 struct cfg80211_update_ft_ies_params *ftie);
+	int	(*crit_proto_start)(struct wiphy *wiphy,
+				    struct wireless_dev *wdev,
+				    enum nl80211_crit_proto_id protocol,
+				    u16 duration);
+	void	(*crit_proto_stop)(struct wiphy *wiphy,
+				   struct wireless_dev *wdev);
 };
 
 /*
@@ -2830,6 +2839,7 @@ struct cfg80211_cached_keys;
  * @p2p_started: true if this is a P2P Device that has been started
  * @cac_started: true if DFS channel availability check has been started
  * @cac_start_time: timestamp (jiffies) when the dfs state was entered.
+ * @crit_proto_started: true if crit_proto_start() has been done.
  */
 struct wireless_dev {
 	struct wiphy *wiphy;
@@ -2884,6 +2894,8 @@ struct wireless_dev {
 	bool cac_started;
 	unsigned long cac_start_time;
 
+	bool crit_proto_started;
+
 #ifdef CONFIG_CFG80211_WEXT
 	/* wext data */
 	struct {
@@ -4126,6 +4138,17 @@ void cfg80211_report_wowlan_wakeup(struct wireless_dev *wdev,
 				   struct cfg80211_wowlan_wakeup *wakeup,
 				   gfp_t gfp);
 
+/**
+ * cfg80211_crit_proto_stopped() - indicate critical protocol stopped by driver.
+ *
+ * @wdev: the wireless device for which critical protocol is stopped.
+ *
+ * This function can be called by the driver to indicate it has reverted
+ * operation back to normal. One reason could be that the duration given
+ * by .crit_proto_start() has expired.
+ */
+void cfg80211_crit_proto_stopped(struct wireless_dev *wdev);
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 79da871..16d3eb5 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -639,6 +639,13 @@
  *	with the relevant Information Elements. This event is used to report
  *	received FT IEs (MDIE, FTIE, RSN IE, TIE, RICIE).
  *
+ * @NL80211_CMD_CRIT_PROTOCOL_START: Indicates user-space will start running
+ *	a critical protocol that needs more reliability in the connection to
+ *	complete.
+ *
+ * @NL80211_CMD_CRIT_PROTOCOL_STOP: Indicates the connection reliability can
+ *	return back to normal.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -798,6 +805,9 @@ enum nl80211_commands {
 	NL80211_CMD_UPDATE_FT_IES,
 	NL80211_CMD_FT_EVENT,
 
+	NL80211_CMD_CRIT_PROTOCOL_START,
+	NL80211_CMD_CRIT_PROTOCOL_STOP,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1709,6 +1719,9 @@ enum nl80211_attrs {
 	NL80211_ATTR_MDID,
 	NL80211_ATTR_IE_RIC,
 
+	NL80211_ATTR_CRIT_PROT_ID,
+	NL80211_ATTR_MAX_CRIT_PROT_DURATION,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3682,4 +3695,22 @@ enum nl80211_protocol_features {
 	NL80211_PROTOCOL_FEATURE_SPLIT_WIPHY_DUMP =	1 << 0,
 };
 
+/**
+ * enum nl80211_crit_proto_id - nl80211 critical protocol identifiers
+ *
+ * @NL80211_CRIT_PROTO_UNSPEC: protocol unspecified.
+ * @NL80211_CRIT_PROTO_BOOTP: BOOTP protocol.
+ * @NL80211_CRIT_PROTO_EAPOL: EAPOL protocol.
+ * @NL80211_CRIT_PROTO_ARP: ARP protocol for APIPA.
+ * @NL80211_CRIT_PROTO_LAST: must be kept last.
+ */
+enum nl80211_crit_proto_id {
+	NL80211_CRIT_PROTO_UNSPEC,
+	NL80211_CRIT_PROTO_BOOTP,
+	NL80211_CRIT_PROTO_EAPOL,
+	NL80211_CRIT_PROTO_ARP,
+	/* add other protocols before this one */
+	NL80211_CRIT_PROTO_LAST
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/net/wireless/core.h b/net/wireless/core.h
index d5d06fd..2db239c 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -88,6 +88,9 @@ struct cfg80211_registered_device {
 
 	struct delayed_work dfs_update_channels_wk;
 
+	/* critical protocol operation started */
+	bool crit_proto_started;
+
 	/* must be last because of the way we do wiphy_priv(),
 	 * and it should at least be aligned to NETDEV_ALIGN */
 	struct wiphy wiphy __aligned(NETDEV_ALIGN);
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 390198b..7c42b04 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -648,6 +648,9 @@ void cfg80211_mlme_unregister_socket(struct wireless_dev *wdev, u32 nlportid)
 
 	spin_unlock_bh(&wdev->mgmt_registrations_lock);
 
+	if (rdev->ops->crit_proto_stop)
+		rdev_crit_proto_stop(rdev, wdev);
+
 	if (nlportid == wdev->ap_unexpected_nlportid)
 		wdev->ap_unexpected_nlportid = 0;
 }
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f924d45..9e126e9 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -25,6 +25,8 @@
 #include "reg.h"
 #include "rdev-ops.h"
 
+#define NL80211_MAX_CRIT_PROT_DURATION		5000 /* msec */
+
 static int nl80211_crypto_settings(struct cfg80211_registered_device *rdev,
 				   struct genl_info *info,
 				   struct cfg80211_crypto_settings *settings,
@@ -1417,6 +1419,10 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 		}
 		CMD(start_p2p_device, START_P2P_DEVICE);
 		CMD(set_mcast_rate, SET_MCAST_RATE);
+		if (split) {
+			CMD(crit_proto_start, CRIT_PROTOCOL_START);
+			CMD(crit_proto_stop, CRIT_PROTOCOL_STOP);
+		}
 
 #ifdef CONFIG_NL80211_TESTMODE
 		CMD(testmode_cmd, TESTMODE);
@@ -8196,6 +8202,55 @@ static int nl80211_update_ft_ies(struct sk_buff *skb, struct genl_info *info)
 	return rdev_update_ft_ies(rdev, dev, &ft_params);
 }
 
+static int nl80211_crit_protocol_start(struct sk_buff *skb,
+				       struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wireless_dev *wdev = info->user_ptr[1];
+	enum nl80211_crit_proto_id proto = NL80211_CRIT_PROTO_UNSPEC;
+	u16 duration;
+
+	if (!rdev->ops->crit_proto_start)
+		return -EOPNOTSUPP;
+
+	if (WARN_ON(!rdev->ops->crit_proto_stop))
+		return -EINVAL;
+
+	if (rdev->crit_proto_started)
+		return -EBUSY;
+
+	/* determine protocol if provided */
+	if (info->attrs[NL80211_ATTR_CRIT_PROT_ID])
+		proto = nla_get_u16(info->attrs[NL80211_ATTR_CRIT_PROT_ID]);
+
+	if (proto >= NL80211_CRIT_PROTO_LAST)
+		return -EINVAL;
+
+	/* timeout must be provided */
+	if (!info->attrs[NL80211_ATTR_MAX_CRIT_PROT_DURATION])
+		return -EINVAL;
+
+	duration =
+		nla_get_u16(info->attrs[NL80211_ATTR_MAX_CRIT_PROT_DURATION]);
+
+	duration = min_t(u16, duration, NL80211_MAX_CRIT_PROT_DURATION);
+
+	return rdev_crit_proto_start(rdev, wdev, proto, duration);
+}
+
+static int nl80211_crit_protocol_stop(struct sk_buff *skb,
+				      struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wireless_dev *wdev = info->user_ptr[1];
+
+	if (!rdev->ops->crit_proto_stop)
+		return -EOPNOTSUPP;
+
+	rdev_crit_proto_stop(rdev, wdev);
+	return 0;
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -8885,6 +8940,22 @@ static struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_CRIT_PROTOCOL_START,
+		.doit = nl80211_crit_protocol_start,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
+		.cmd = NL80211_CMD_CRIT_PROTOCOL_STOP,
+		.doit = nl80211_crit_protocol_stop,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	}
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
@@ -10630,6 +10701,16 @@ void cfg80211_ft_event(struct net_device *netdev,
 }
 EXPORT_SYMBOL(cfg80211_ft_event);
 
+void cfg80211_crit_proto_stopped(struct wireless_dev *wdev)
+{
+	struct cfg80211_registered_device *rdev;
+
+	rdev = wiphy_to_dev(wdev->wiphy);
+	WARN_ON(!rdev->crit_proto_started);
+	rdev->crit_proto_started = false;
+}
+EXPORT_SYMBOL(cfg80211_crit_proto_stopped);
+
 /* initialisation/exit functions */
 
 int nl80211_init(void)
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index d77e1c1..720e0c5 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -875,7 +875,7 @@ static inline void rdev_stop_p2p_device(struct cfg80211_registered_device *rdev,
 	trace_rdev_stop_p2p_device(&rdev->wiphy, wdev);
 	rdev->ops->stop_p2p_device(&rdev->wiphy, wdev);
 	trace_rdev_return_void(&rdev->wiphy);
-}					
+}
 
 static inline int rdev_set_mac_acl(struct cfg80211_registered_device *rdev,
 				   struct net_device *dev,
@@ -901,4 +901,30 @@ static inline int rdev_update_ft_ies(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int rdev_crit_proto_start(struct cfg80211_registered_device *rdev,
+					struct wireless_dev *wdev,
+					enum nl80211_crit_proto_id protocol,
+					u16 duration)
+{
+	int ret;
+
+	trace_rdev_crit_proto_start(&rdev->wiphy, wdev, protocol, duration);
+	ret = rdev->ops->crit_proto_start(&rdev->wiphy, wdev,
+					  protocol, duration);
+	rdev->crit_proto_started = !ret;
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
+static inline void rdev_crit_proto_stop(struct cfg80211_registered_device *rdev,
+				       struct wireless_dev *wdev)
+{
+	trace_rdev_crit_proto_stop(&rdev->wiphy, wdev);
+	if (rdev->crit_proto_started) {
+		rdev->ops->crit_proto_stop(&rdev->wiphy, wdev);
+		rdev->crit_proto_started = false;
+	}
+	trace_rdev_return_void(&rdev->wiphy);
+}
+
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index ccadef2..499c982 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1805,6 +1805,41 @@ TRACE_EVENT(rdev_update_ft_ies,
 		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->md)
 );
 
+TRACE_EVENT(rdev_crit_proto_start,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
+		 enum nl80211_crit_proto_id protocol, u16 duration),
+	TP_ARGS(wiphy, wdev, protocol, duration),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+		__field(u16, proto)
+		__field(u16, duration)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+		__entry->proto = protocol;
+		__entry->duration = duration;
+	),
+	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT ", proto=%x, duration=%u",
+		  WIPHY_PR_ARG, WDEV_PR_ARG, __entry->proto, __entry->duration)
+);
+
+TRACE_EVENT(rdev_crit_proto_stop,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev),
+	TP_ARGS(wiphy, wdev),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+	),
+	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT,
+		  WIPHY_PR_ARG, WDEV_PR_ARG)
+);
+
 /*************************************************************
  *	     cfg80211 exported functions traces		     *
  *************************************************************/
-- 
1.7.10.4


