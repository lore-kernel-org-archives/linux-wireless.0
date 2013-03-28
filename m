Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2790 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976Ab3C1MLU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Mar 2013 08:11:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "Dan Williams" <dcbw@redhat.com>,
	"Adrian Chadd" <adrian@freebsd.org>,
	"Felix Fietkau" <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [RFC V2] cfg80211: introduce critical protocol indication from
 user-space
Date: Thu, 28 Mar 2013 13:11:09 +0100
Message-ID: <1364472669-5629-1-git-send-email-arend@broadcom.com> (sfid-20130328_131126_007292_9049D2CC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some protocols need a more reliable connection to complete
successful in reasonable time. This patch adds a user-space
API to indicate the wireless driver that a critical protocol
is about to commence and when it is done, using nl80211 primitives
NL80211_CMD_CRIT_PROTOCOL_START and NL80211_CRIT_PROTOCOL_STOP.

The driver can support this by implementing the cfg80211 callbacks
.crit_proto_start() and .crit_proto_stop(). Examples of protocols
that can benefit from this are DHCP, EAPOL, APIPA. Exactly how the
link can/should be made more reliable is up to the driver. Things
to consider are avoid scanning, no multi-channel operations, and
alter coexistence schemes.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
Changes since v1:
- subject changed. Below previous subject is given for reference:
  [RFC] cfg80211: configuration of Bluetooth coexistence mode
- introduced dedicated nl80211 API.
---
 include/net/cfg80211.h       |   12 +++++++
 include/uapi/linux/nl80211.h |   13 +++++++
 net/wireless/core.c          |   18 ++++++++++
 net/wireless/core.h          |    1 +
 net/wireless/nl80211.c       |   78 ++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      |   22 ++++++++++++
 net/wireless/trace.h         |   36 +++++++++++++++++++
 7 files changed, 180 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 57870b6..e864989 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2002,6 +2002,9 @@ struct cfg80211_update_ft_ies_params {
  * @update_ft_ies: Provide updated Fast BSS Transition information to the
  *	driver. If the SME is in the driver/firmware, this information can be
  *	used in building Authentication and Reassociation Request frames.
+ * @crit_proto_start: Indicates a critical protocol needs more link reliability.
+ * @crit_proto_stop: Indicates critical protocol no longer needs increased link
+ *	reliability.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -2231,6 +2234,10 @@ struct cfg80211_ops {
 					 struct cfg80211_chan_def *chandef);
 	int	(*update_ft_ies)(struct wiphy *wiphy, struct net_device *dev,
 				 struct cfg80211_update_ft_ies_params *ftie);
+	int	(*crit_proto_start)(struct wiphy *wiphy,
+				    struct wireless_dev *wdev, u16 protocol);
+	int	(*crit_proto_stop)(struct wiphy *wiphy,
+				   struct wireless_dev *wdev, u16 protocol);
 };
 
 /*
@@ -2830,6 +2837,8 @@ struct cfg80211_cached_keys;
  * @p2p_started: true if this is a P2P Device that has been started
  * @cac_started: true if DFS channel availability check has been started
  * @cac_start_time: timestamp (jiffies) when the dfs state was entered.
+ * @crit_proto_work: delayed work guarding duration of critical protocol.
+ * @crit_proto: ethernet protocol for which delayed work is scheduled.
  */
 struct wireless_dev {
 	struct wiphy *wiphy;
@@ -2884,6 +2893,9 @@ struct wireless_dev {
 	bool cac_started;
 	unsigned long cac_start_time;
 
+	struct delayed_work crit_proto_work;
+	u16 crit_proto;
+
 #ifdef CONFIG_CFG80211_WEXT
 	/* wext data */
 	struct {
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 79da871..a9b17ff 100644
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
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 92e3fd4..e98db00 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -745,6 +745,8 @@ static void wdev_cleanup_work(struct work_struct *work)
 	wdev = container_of(work, struct wireless_dev, cleanup_work);
 	rdev = wiphy_to_dev(wdev->wiphy);
 
+	schedule_delayed_work(&wdev->crit_proto_work, 0);
+
 	cfg80211_lock_rdev(rdev);
 
 	if (WARN_ON(rdev->scan_req && rdev->scan_req->wdev == wdev)) {
@@ -771,6 +773,20 @@ static void wdev_cleanup_work(struct work_struct *work)
 	dev_put(wdev->netdev);
 }
 
+void wdev_cancel_crit_proto(struct work_struct *work)
+{
+	struct delayed_work *dwork;
+	struct cfg80211_registered_device *rdev;
+	struct wireless_dev *wdev;
+
+	dwork = container_of(work, struct delayed_work, work);
+	wdev = container_of(dwork, struct wireless_dev, crit_proto_work);
+	rdev = wiphy_to_dev(wdev->wiphy);
+
+	rdev_crit_proto_stop(rdev, wdev, wdev->crit_proto);
+	wdev->crit_proto = 0;
+}
+
 void cfg80211_unregister_wdev(struct wireless_dev *wdev)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
@@ -886,6 +902,8 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		spin_lock_init(&wdev->event_lock);
 		INIT_LIST_HEAD(&wdev->mgmt_registrations);
 		spin_lock_init(&wdev->mgmt_registrations_lock);
+		INIT_DELAYED_WORK(&wdev->crit_proto_work,
+				  wdev_cancel_crit_proto);
 
 		mutex_lock(&rdev->devlist_mtx);
 		wdev->identifier = ++rdev->wdev_id;
diff --git a/net/wireless/core.h b/net/wireless/core.h
index d5d06fd..af2eb94 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -502,6 +502,7 @@ void cfg80211_update_iface_num(struct cfg80211_registered_device *rdev,
 
 void cfg80211_leave(struct cfg80211_registered_device *rdev,
 		    struct wireless_dev *wdev);
+void wdev_cancel_crit_proto(struct work_struct *work);
 
 #define CFG80211_MAX_NUM_DIFFERENT_CHANNELS 10
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f924d45..dd0c4b7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -25,6 +25,8 @@
 #include "reg.h"
 #include "rdev-ops.h"
 
+#define NL80211_MIN_CRIT_PROT_DURATION		2500 /* msec */
+
 static int nl80211_crypto_settings(struct cfg80211_registered_device *rdev,
 				   struct genl_info *info,
 				   struct cfg80211_crypto_settings *settings,
@@ -1417,6 +1419,8 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 		}
 		CMD(start_p2p_device, START_P2P_DEVICE);
 		CMD(set_mcast_rate, SET_MCAST_RATE);
+		CMD(crit_proto_start, CRIT_PROTOCOL_START);
+		CMD(crit_proto_stop, CRIT_PROTOCOL_STOP);
 
 #ifdef CONFIG_NL80211_TESTMODE
 		CMD(testmode_cmd, TESTMODE);
@@ -2467,6 +2471,8 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 		spin_lock_init(&wdev->event_lock);
 		INIT_LIST_HEAD(&wdev->mgmt_registrations);
 		spin_lock_init(&wdev->mgmt_registrations_lock);
+		INIT_DELAYED_WORK(&wdev->crit_proto_work,
+				  wdev_cancel_crit_proto);
 
 		mutex_lock(&rdev->devlist_mtx);
 		wdev->identifier = ++rdev->wdev_id;
@@ -8196,6 +8202,62 @@ static int nl80211_update_ft_ies(struct sk_buff *skb, struct genl_info *info)
 	return rdev_update_ft_ies(rdev, dev, &ft_params);
 }
 
+static int nl80211_crit_protocol_start(struct sk_buff *skb,
+				       struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wireless_dev *wdev = info->user_ptr[1];
+	u16 proto = 0;
+	u16 duration;
+
+	if (!rdev->ops->crit_proto_start)
+		return -EOPNOTSUPP;
+
+	if (WARN_ON(!rdev->ops->crit_proto_stop))
+		return -EINVAL;
+
+	cancel_delayed_work(&wdev->crit_proto_work);
+	wdev->crit_proto = 0;
+
+	/* determine protocol if provided */
+	if (info->attrs[NL80211_ATTR_CRIT_PROT_ID])
+		proto = nla_get_u16(info->attrs[NL80211_ATTR_CRIT_PROT_ID]);
+
+	/* skip delayed work if no timeout provided */
+	if (!info->attrs[NL80211_ATTR_MAX_CRIT_PROT_DURATION])
+		goto done;
+
+	duration =
+		nla_get_u16(info->attrs[NL80211_ATTR_MAX_CRIT_PROT_DURATION]);
+
+	duration = max_t(u16, duration, NL80211_MIN_CRIT_PROT_DURATION);
+	schedule_delayed_work(&wdev->crit_proto_work,
+			      msecs_to_jiffies(duration));
+	wdev->crit_proto = proto;
+
+done:
+	return rdev_crit_proto_start(rdev, wdev, proto);
+}
+
+static int nl80211_crit_protocol_stop(struct sk_buff *skb,
+				      struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wireless_dev *wdev = info->user_ptr[1];
+	u16 proto = 0;
+
+	if (!rdev->ops->crit_proto_stop)
+		return -EOPNOTSUPP;
+
+	cancel_delayed_work(&wdev->crit_proto_work);
+	wdev->crit_proto = 0;
+
+	if (info->attrs[NL80211_ATTR_CRIT_PROT_ID])
+		proto = nla_get_u16(info->attrs[NL80211_ATTR_CRIT_PROT_ID]);
+
+	return rdev_crit_proto_stop(rdev, wdev, proto);
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
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index d77e1c1..906b92f 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -901,4 +901,26 @@ static inline int rdev_update_ft_ies(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int rdev_crit_proto_start(struct cfg80211_registered_device *rdev,
+					struct wireless_dev *wdev, u16 protocol)
+{
+	int ret;
+
+	trace_rdev_crit_proto_start(&rdev->wiphy, wdev, protocol);
+	ret = rdev->ops->crit_proto_start(&rdev->wiphy, wdev, protocol);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
+static inline int rdev_crit_proto_stop(struct cfg80211_registered_device *rdev,
+				       struct wireless_dev *wdev, u16 protocol)
+{
+	int ret;
+
+	trace_rdev_crit_proto_stop(&rdev->wiphy, wdev, protocol);
+	ret = rdev->ops->crit_proto_stop(&rdev->wiphy, wdev, protocol);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index ccadef2..43fcc60 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1805,6 +1805,42 @@ TRACE_EVENT(rdev_update_ft_ies,
 		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->md)
 );
 
+TRACE_EVENT(rdev_crit_proto_start,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
+		 u16 protocol),
+	TP_ARGS(wiphy, wdev, protocol),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+		__field(u16, proto)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+		__entry->proto = protocol;
+	),
+	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT ", proto=%x",
+		  WIPHY_PR_ARG, WDEV_PR_ARG, __entry->proto)
+);
+
+TRACE_EVENT(rdev_crit_proto_stop,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
+		 u16 protocol),
+	TP_ARGS(wiphy, wdev, protocol),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+		__field(u16, proto)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+		__entry->proto = protocol;
+	),
+	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT ", proto=%x",
+		  WIPHY_PR_ARG, WDEV_PR_ARG, __entry->proto)
+);
+
 /*************************************************************
  *	     cfg80211 exported functions traces		     *
  *************************************************************/
-- 
1.7.10.4


