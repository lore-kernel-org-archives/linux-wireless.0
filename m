Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3427 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270Ab3DKKkU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 06:40:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH V6] cfg80211: introduce critical protocol indication
 from user-space
Date: Thu, 11 Apr 2013 12:39:54 +0200
Message-ID: <1365676794-24717-1-git-send-email-arend@broadcom.com> (sfid-20130411_124027_661567_1FBB5A0A)
In-Reply-To: <1365412173-7428-1-git-send-email-arend@broadcom.com>
References: <1365412173-7428-1-git-send-email-arend@broadcom.com>
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

I reworked the patch based on your comment in this V6. It
applies to the master branch on top of commit:

5253ffb mac80211: always pick a basic rate to tx RTS/CTS for pre-HT rates

Regards, Arend

Changelog:
----------
V6:
- added crit_proto_stopped event message.
- use nlportid as flag for critical protocol being active.
- return error when duration is over specified limit.
- remove logic from rdev_* inline wrappers.
- added more documentation.
- some renaming of identifiers.
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
 include/net/cfg80211.h       |   27 ++++++++++
 include/uapi/linux/nl80211.h |   40 +++++++++++++++
 net/wireless/core.h          |    3 ++
 net/wireless/mlme.c          |    5 ++
 net/wireless/nl80211.c       |  116 ++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      |   24 ++++++++-
 net/wireless/trace.h         |   35 +++++++++++++
 7 files changed, 249 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 57870b6..7afd1ad 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2002,6 +2002,12 @@ struct cfg80211_update_ft_ies_params {
  * @update_ft_ies: Provide updated Fast BSS Transition information to the
  *	driver. If the SME is in the driver/firmware, this information can be
  *	used in building Authentication and Reassociation Request frames.
+ *
+ * @crit_proto_start: Indicates a critical protocol needs more link reliability
+ *	for a given duration (milliseconds). The protocol is provided so the
+ *	driver can take the most appropriate actions.
+ * @crit_proto_stop: Indicates critical protocol no longer needs increased link
+ *	reliability. This operation can not fail.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -2231,6 +2237,12 @@ struct cfg80211_ops {
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
@@ -2830,6 +2842,7 @@ struct cfg80211_cached_keys;
  * @p2p_started: true if this is a P2P Device that has been started
  * @cac_started: true if DFS channel availability check has been started
  * @cac_start_time: timestamp (jiffies) when the dfs state was entered.
+ * @crit_proto_started: true if crit_proto_start() has been done.
  */
 struct wireless_dev {
 	struct wiphy *wiphy;
@@ -2884,6 +2897,8 @@ struct wireless_dev {
 	bool cac_started;
 	unsigned long cac_start_time;
 
+	bool crit_proto_started;
+
 #ifdef CONFIG_CFG80211_WEXT
 	/* wext data */
 	struct {
@@ -4126,6 +4141,18 @@ void cfg80211_report_wowlan_wakeup(struct wireless_dev *wdev,
 				   struct cfg80211_wowlan_wakeup *wakeup,
 				   gfp_t gfp);
 
+/**
+ * cfg80211_crit_proto_stopped() - indicate critical protocol stopped by driver.
+ *
+ * @wdev: the wireless device for which critical protocol is stopped.
+ *
+ * This function can be called by the driver to indicate it has reverted
+ * operation back to normal. One reason could be that the duration given
+ * by .crit_proto_start() has expired. This function must not be called
+ * in .crit_proto_stop() context.
+ */
+void cfg80211_crit_proto_stopped(struct wireless_dev *wdev, gfp_t gfp);
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 79da871..c68373b 100644
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
@@ -798,6 +805,10 @@ enum nl80211_commands {
 	NL80211_CMD_UPDATE_FT_IES,
 	NL80211_CMD_FT_EVENT,
 
+	NL80211_CMD_CRIT_PROTOCOL_START,
+	NL80211_CMD_CRIT_PROTOCOL_STOP,
+	NL80211_CMD_CRIT_PROTOCOL_STOPPED_EVENT,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1414,6 +1425,11 @@ enum nl80211_commands {
  * @NL80211_ATTR_IE_RIC: Resource Information Container Information
  *	Element
  *
+ * @NL80211_ATTR_CRIT_PROT_ID: critical protocol identifier requiring increased
+ *	reliability, see &enum nl80211_crit_proto_id (u16).
+ * @NL80211_ATTR_MAX_CRIT_PROT_DURATION: duration in milliseconds in which
+ *      the connection should have increased reliability (u16).
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1709,6 +1725,9 @@ enum nl80211_attrs {
 	NL80211_ATTR_MDID,
 	NL80211_ATTR_IE_RIC,
 
+	NL80211_ATTR_CRIT_PROT_ID,
+	NL80211_ATTR_MAX_CRIT_PROT_DURATION,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3682,4 +3701,25 @@ enum nl80211_protocol_features {
 	NL80211_PROTOCOL_FEATURE_SPLIT_WIPHY_DUMP =	1 << 0,
 };
 
+/**
+ * enum nl80211_crit_proto_id - nl80211 critical protocol identifiers
+ *
+ * @NL80211_CRIT_PROTO_UNSPEC: protocol unspecified.
+ * @NL80211_CRIT_PROTO_DHCP: BOOTP or DHCPv6 protocol.
+ * @NL80211_CRIT_PROTO_EAPOL: EAPOL protocol.
+ * @NL80211_CRIT_PROTO_APIPA: APIPA protocol.
+ * @NUM_NL80211_CRIT_PROTO: must be kept last.
+ */
+enum nl80211_crit_proto_id {
+	NL80211_CRIT_PROTO_UNSPEC,
+	NL80211_CRIT_PROTO_DHCP,
+	NL80211_CRIT_PROTO_EAPOL,
+	NL80211_CRIT_PROTO_APIPA,
+	/* add other protocols before this one */
+	NUM_NL80211_CRIT_PROTO
+};
+
+/* maximum duration for critical protocol measures */
+#define NL80211_CRIT_PROTO_MAX_DURATION		5000 /* msec */
+
 #endif /* __LINUX_NL80211_H */
diff --git a/net/wireless/core.h b/net/wireless/core.h
index d5d06fd..eac5308 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -88,6 +88,9 @@ struct cfg80211_registered_device {
 
 	struct delayed_work dfs_update_channels_wk;
 
+	/* netlink port which started critical protocol (0 means not started) */
+	u32 crit_proto_nlportid;
+
 	/* must be last because of the way we do wiphy_priv(),
 	 * and it should at least be aligned to NETDEV_ALIGN */
 	struct wiphy wiphy __aligned(NETDEV_ALIGN);
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 390198b..719c2f8 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -648,6 +648,11 @@ void cfg80211_mlme_unregister_socket(struct wireless_dev *wdev, u32 nlportid)
 
 	spin_unlock_bh(&wdev->mgmt_registrations_lock);
 
+	if (nlportid && rdev->crit_proto_nlportid == nlportid) {
+		rdev_crit_proto_stop(rdev, wdev);
+		rdev->crit_proto_nlportid = 0;
+	}
+
 	if (nlportid == wdev->ap_unexpected_nlportid)
 		wdev->ap_unexpected_nlportid = 0;
 }
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f924d45..533eccf 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1417,6 +1417,10 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 		}
 		CMD(start_p2p_device, START_P2P_DEVICE);
 		CMD(set_mcast_rate, SET_MCAST_RATE);
+		if (split) {
+			CMD(crit_proto_start, CRIT_PROTOCOL_START);
+			CMD(crit_proto_stop, CRIT_PROTOCOL_STOP);
+		}
 
 #ifdef CONFIG_NL80211_TESTMODE
 		CMD(testmode_cmd, TESTMODE);
@@ -8196,6 +8200,64 @@ static int nl80211_update_ft_ies(struct sk_buff *skb, struct genl_info *info)
 	return rdev_update_ft_ies(rdev, dev, &ft_params);
 }
 
+static int nl80211_crit_protocol_start(struct sk_buff *skb,
+				       struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wireless_dev *wdev = info->user_ptr[1];
+	enum nl80211_crit_proto_id proto = NL80211_CRIT_PROTO_UNSPEC;
+	u16 duration;
+	int ret;
+
+	if (!rdev->ops->crit_proto_start)
+		return -EOPNOTSUPP;
+
+	if (WARN_ON(!rdev->ops->crit_proto_stop))
+		return -EINVAL;
+
+	if (rdev->crit_proto_nlportid)
+		return -EBUSY;
+
+	/* determine protocol if provided */
+	if (info->attrs[NL80211_ATTR_CRIT_PROT_ID])
+		proto = nla_get_u16(info->attrs[NL80211_ATTR_CRIT_PROT_ID]);
+
+	if (proto >= NUM_NL80211_CRIT_PROTO)
+		return -EINVAL;
+
+	/* timeout must be provided */
+	if (!info->attrs[NL80211_ATTR_MAX_CRIT_PROT_DURATION])
+		return -EINVAL;
+
+	duration =
+		nla_get_u16(info->attrs[NL80211_ATTR_MAX_CRIT_PROT_DURATION]);
+
+	if (duration > NL80211_CRIT_PROTO_MAX_DURATION)
+		return -ERANGE;
+
+	ret = rdev_crit_proto_start(rdev, wdev, proto, duration);
+	if (!ret)
+		rdev->crit_proto_nlportid = info->snd_portid;
+
+	return ret;
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
+	if (rdev->crit_proto_nlportid) {
+		rdev_crit_proto_stop(rdev, wdev);
+		rdev->crit_proto_nlportid = 0;
+	}
+	return 0;
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -8885,6 +8947,22 @@ static struct genl_ops nl80211_ops[] = {
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
@@ -10630,6 +10708,44 @@ void cfg80211_ft_event(struct net_device *netdev,
 }
 EXPORT_SYMBOL(cfg80211_ft_event);
 
+void cfg80211_crit_proto_stopped(struct wireless_dev *wdev, gfp_t gfp)
+{
+	struct cfg80211_registered_device *rdev;
+	struct sk_buff *msg;
+	void *hdr;
+	u32 nlportid;
+
+	rdev = wiphy_to_dev(wdev->wiphy);
+	WARN_ON(!rdev->crit_proto_nlportid);
+	nlportid = rdev->crit_proto_nlportid;
+	rdev->crit_proto_nlportid = 0;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0,
+			     NL80211_CMD_CRIT_PROTOCOL_STOPPED_EVENT);
+	if (!hdr)
+		goto nla_put_failure;
+
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
+	    nla_put_u64(msg, NL80211_ATTR_WDEV, wdev_id(wdev)))
+		goto nla_put_failure;
+
+	genlmsg_end(msg, hdr);
+
+	genlmsg_unicast(wiphy_net(&rdev->wiphy), msg, nlportid);
+	return;
+
+ nla_put_failure:
+	if (hdr)
+		genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+
+}
+EXPORT_SYMBOL(cfg80211_crit_proto_stopped);
+
 /* initialisation/exit functions */
 
 int nl80211_init(void)
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index d77e1c1..9f15f0a 100644
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
@@ -901,4 +901,26 @@ static inline int rdev_update_ft_ies(struct cfg80211_registered_device *rdev,
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
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
+static inline void rdev_crit_proto_stop(struct cfg80211_registered_device *rdev,
+				       struct wireless_dev *wdev)
+{
+	trace_rdev_crit_proto_stop(&rdev->wiphy, wdev);
+	rdev->ops->crit_proto_stop(&rdev->wiphy, wdev);
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


