Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:48346 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752359Ab1IEMDH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Sep 2011 08:03:07 -0400
Received: by mail-gy0-f182.google.com with SMTP id 10so4282005gyd.27
        for <linux-wireless@vger.kernel.org>; Mon, 05 Sep 2011 05:03:06 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <johannes@sipsolutions.net>
Subject: [RFC 3/5] nl80211/cfg80211: adding intermediate scan result event.
Date: Mon,  5 Sep 2011 15:02:29 +0300
Message-Id: <1315224151-16552-4-git-send-email-VictorG@ti.com> (sfid-20110905_140310_871422_DEA75627)
In-Reply-To: <1315224151-16552-1-git-send-email-VictorG@ti.com>
References: <1315224151-16552-1-git-send-email-VictorG@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding intermediate scan result event by exposing new
NL80211_CMD_IM_SCAN_RESULT event, which will contain
NL80211_BSS_BSSID to specify the BSSID of received scan result and
NL80211_BSS_SIGNAL_MBM to indicate signal strength.

This event might be optionally enabled during
NL80211_CMD_TRIGGER_SCAN, with NL80211_ATTR_IM_SCAN_RESULT
flag attribute.

Signed-off-by: Victor Goldenshtein <VictorG@ti.com>
---
 include/linux/nl80211.h |   17 +++++++++++++++
 include/net/cfg80211.h  |   10 +++++++++
 net/wireless/core.h     |   10 +++++++++
 net/wireless/nl80211.c  |   51 +++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |    3 ++
 net/wireless/scan.c     |   43 +++++++++++++++++++++++++++++++++++++++
 net/wireless/util.c     |    3 ++
 7 files changed, 137 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 2fee93a..5a10ec0 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -504,6 +504,14 @@
  *	event, partial scan results will be available. Returns -ENOENT
  *	if scan is not running.
  *
+ * @NL80211_CMD_IM_SCAN_RESULT: Intermediate scan result notification event,
+ *	this event could be enabled with @NL80211_ATTR_IM_SCAN_RESULT
+ *	flag during @NL80211_CMD_TRIGGER_SCAN. This event contains
+ *	%NL80211_BSS_BSSID which is used to specify the BSSID of received
+ *	scan result and %NL80211_BSS_SIGNAL_MBM to indicate signal strength.
+ *	On reception of this notification, userspace may decide to stop earlier
+ *	currently running scan with (@NL80211_CMD_SCAN_CANCEL).
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -630,6 +638,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_SCAN_CANCEL,
 
+	NL80211_CMD_IM_SCAN_RESULT,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1049,6 +1059,11 @@ enum nl80211_commands {
  *	(Re)Association Response frames when the driver (or firmware) replies to
  *	(Re)Association Request frames.
  *
+ * @%NL80211_ATTR_IM_SCAN_RESULT: Flag attribute to enable intermediate
+ *	scan result notification event (%NL80211_CMD_IM_SCAN_RESULT)
+ *	for the %NL80211_CMD_TRIGGER_SCAN command.
+ *	When set: will notify on each new scan result in the cache.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1259,6 +1274,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_IE_PROBE_RESP,
 	NL80211_ATTR_IE_ASSOC_RESP,
 
+	NL80211_ATTR_IM_SCAN_RESULT,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7b0c31e..967d385 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2527,6 +2527,16 @@ void cfg80211_sched_scan_results(struct wiphy *wiphy);
 void cfg80211_sched_scan_stopped(struct wiphy *wiphy);
 
 /**
+ * cfg80211_send_intermediate_result - inform userspace about new
+ * scan result.
+ *
+ * @dev: network device
+ * @cbss: bss info to report.
+ */
+void cfg80211_send_intermediate_result(struct net_device *dev,
+				       struct cfg80211_bss *cbss);
+
+/**
  * cfg80211_inform_bss_frame - inform cfg80211 of a received BSS frame
  *
  * @wiphy: the wiphy reporting the BSS
diff --git a/net/wireless/core.h b/net/wireless/core.h
index af22fe3..7484255 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -76,6 +76,9 @@ struct cfg80211_registered_device {
 
 	struct cfg80211_wowlan *wowlan;
 
+	/* intermediate scan result configuration */
+	bool im_scan_result;
+
 	/* must be last because of the way we do wiphy_priv(),
 	 * and it should at least be aligned to NETDEV_ALIGN */
 	struct wiphy wiphy __attribute__((__aligned__(NETDEV_ALIGN)));
@@ -231,6 +234,7 @@ enum cfg80211_event_type {
 	EVENT_ROAMED,
 	EVENT_DISCONNECTED,
 	EVENT_IBSS_JOINED,
+	EVENT_IM_SCAN_RESULT,
 };
 
 struct cfg80211_event {
@@ -262,6 +266,10 @@ struct cfg80211_event {
 		struct {
 			u8 bssid[ETH_ALEN];
 		} ij;
+		struct {
+			u8 bssid[ETH_ALEN];
+			s32 signal;
+		} im;
 	};
 };
 
@@ -421,6 +429,8 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak);
 void __cfg80211_sched_scan_results(struct work_struct *wk);
 int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
 			       bool driver_initiated);
+void __cfg80211_send_intermediate_result(struct net_device *dev,
+					 struct cfg80211_event *ev);
 int cfg80211_scan_cancel(struct cfg80211_registered_device *rdev);
 void cfg80211_upload_connect_keys(struct wireless_dev *wdev);
 int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f9f239f..9e60b48 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -189,6 +189,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 					 .len = IEEE80211_MAX_DATA_LEN },
 	[NL80211_ATTR_IE_ASSOC_RESP] = { .type = NLA_BINARY,
 					 .len = IEEE80211_MAX_DATA_LEN },
+	[NL80211_ATTR_IM_SCAN_RESULT] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -3557,6 +3558,11 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
+	if (info->attrs[NL80211_ATTR_IM_SCAN_RESULT])
+		rdev->im_scan_result = 1;
+	else
+		rdev->im_scan_result = 0;
+
 	request->dev = dev;
 	request->wiphy = &rdev->wiphy;
 
@@ -6296,6 +6302,31 @@ nl80211_send_sched_scan_msg(struct sk_buff *msg,
 	return -EMSGSIZE;
 }
 
+static int nl80211_send_intermediate_msg(struct sk_buff *msg,
+					struct cfg80211_registered_device *rdev,
+					struct net_device *netdev,
+					u32 pid, u32 seq, int flags,
+					struct cfg80211_event *ev, u32 cmd)
+{
+	void *hdr;
+
+	hdr = nl80211hdr_put(msg, pid, seq, flags, cmd);
+	if (!hdr)
+		return -1;
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex);
+	NLA_PUT_U32(msg, NL80211_BSS_SIGNAL_MBM, ev->im.signal);
+	if (!is_zero_ether_addr(ev->im.bssid))
+		NLA_PUT(msg, NL80211_BSS_BSSID, ETH_ALEN, ev->im.bssid);
+
+	return genlmsg_end(msg, hdr);
+
+ nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	return -EMSGSIZE;
+}
+
 void nl80211_send_scan_start(struct cfg80211_registered_device *rdev,
 			     struct net_device *netdev)
 {
@@ -6353,6 +6384,26 @@ void nl80211_send_scan_aborted(struct cfg80211_registered_device *rdev,
 				nl80211_scan_mcgrp.id, GFP_KERNEL);
 }
 
+void nl80211_send_intermediate_result(struct cfg80211_registered_device *rdev,
+				      struct net_device *netdev,
+				      struct cfg80211_event *ev)
+{
+	struct sk_buff *msg;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	if (nl80211_send_intermediate_msg(msg, rdev, netdev, 0, 0, 0, ev,
+				   NL80211_CMD_IM_SCAN_RESULT) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_scan_mcgrp.id, GFP_KERNEL);
+}
+
 void nl80211_send_sched_scan_results(struct cfg80211_registered_device *rdev,
 				     struct net_device *netdev)
 {
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index 5d69c56..e0ea1b7 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -12,6 +12,9 @@ void nl80211_send_scan_done(struct cfg80211_registered_device *rdev,
 			    struct net_device *netdev);
 void nl80211_send_scan_aborted(struct cfg80211_registered_device *rdev,
 			       struct net_device *netdev);
+void nl80211_send_intermediate_result(struct cfg80211_registered_device *rdev,
+				      struct net_device *netdev,
+				      struct cfg80211_event *ev);
 void nl80211_send_sched_scan(struct cfg80211_registered_device *rdev,
 			     struct net_device *netdev, u32 cmd);
 void nl80211_send_sched_scan_results(struct cfg80211_registered_device *rdev,
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index bb4a991..9be42c3 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -156,6 +156,49 @@ int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
 	return 0;
 }
 
+void __cfg80211_send_intermediate_result(struct net_device *dev,
+					 struct cfg80211_event *ev)
+{
+	struct wireless_dev *wdev;
+	struct cfg80211_registered_device *rdev;
+
+	if (!dev)
+		return;
+
+	wdev = dev->ieee80211_ptr;
+	rdev = wiphy_to_dev(wdev->wiphy);
+
+	if (rdev->scan_req)
+		nl80211_send_intermediate_result(rdev, dev, ev);
+}
+
+void cfg80211_send_intermediate_result(struct net_device *dev,
+				       struct cfg80211_bss *cbss)
+{
+	struct cfg80211_event *ev;
+	unsigned long flags;
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+
+	if ((!rdev->im_scan_result) || (!rdev->scan_req) || (!cbss))
+		return;
+
+	ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
+	if (!ev)
+		return;
+
+	ev->type = EVENT_IM_SCAN_RESULT;
+	ev->im.signal = cbss->signal;
+	if (cbss->bssid)
+		memcpy(ev->im.bssid, cbss->bssid, ETH_ALEN);
+
+	spin_lock_irqsave(&wdev->event_lock, flags);
+	list_add_tail(&ev->list, &wdev->event_list);
+	spin_unlock_irqrestore(&wdev->event_lock, flags);
+	queue_work(cfg80211_wq, &rdev->event_work);
+}
+EXPORT_SYMBOL(cfg80211_send_intermediate_result);
+
 int cfg80211_scan_cancel(struct cfg80211_registered_device *rdev)
 {
 	struct net_device *dev;
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 844ddb0..ad421ad 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -759,6 +759,9 @@ static void cfg80211_process_wdev_events(struct wireless_dev *wdev)
 		case EVENT_IBSS_JOINED:
 			__cfg80211_ibss_joined(wdev->netdev, ev->ij.bssid);
 			break;
+		case EVENT_IM_SCAN_RESULT:
+			__cfg80211_send_intermediate_result(wdev->netdev, ev);
+			break;
 		}
 		wdev_unlock(wdev);
 
-- 
1.7.0.4

