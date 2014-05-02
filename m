Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:39195 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751505AbaEBNlO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 May 2014 09:41:14 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc: michal.kazior@tieto.com
Date: Fri,  2 May 2014 16:40:28 +0300
Message-Id: <1399038031-23206-1-git-send-email-luca@coelho.fi> (sfid-20140502_154119_688280_B688CF23)
Subject: [PATCH 1/4] cfg80211/nl80211: add channel switch started and failed notifications
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Add a new NL80211_CH_SWITCH_STARTED_NOTIFY message that can be sent to
the userspace when a channel switch process has started.  This allows
userspace to take action, for instance, by requesting other interfaces
to switch channel as necessary.

This patch introduces a function that allows the drivers to send this
notification.  It should be used when the driver starts processing a
channel switch initiated by a remote device (eg. when a STA receives a
CSA from the AP) and when it successfully starts a userspace-triggered
channel switch (eg. when hostapd triggers a channel swith in the AP).

Additionally, the corresponding notification and function for failure
cases were added as well.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 include/net/cfg80211.h       | 23 +++++++++++++++++++++++
 include/uapi/linux/nl80211.h | 17 +++++++++++++++++
 net/wireless/nl80211.c       | 36 +++++++++++++++++++++++++++++++++---
 net/wireless/trace.h         | 32 ++++++++++++++++++++++++++++++++
 4 files changed, 105 insertions(+), 3 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7eae46c..43c674e 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4574,6 +4574,29 @@ bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
 void cfg80211_ch_switch_notify(struct net_device *dev,
 			       struct cfg80211_chan_def *chandef);
 
+/*
+ * cfg80211_ch_switch_started_notify - notify channel switch start
+ * @dev: the device on which the channel switch started
+ * @chandef: the future channel definition
+ *
+ * Inform the userspace about the channel switch that has just
+ * started, so that it can take appropriate actions (eg. starting
+ * channel switch on other vifs), if necessary.
+ */
+void cfg80211_ch_switch_started_notify(struct net_device *dev,
+				       struct cfg80211_chan_def *chandef);
+
+/*
+ * cfg80211_ch_switch_failed_notify - notify channel switch failure
+ * @dev: the device on which the channel switch has failed
+ * @chandef: the channel definition to which we failed to switch
+ *
+ * Inform the userspace that a channel switch has failed after the
+ * channel switch started notification has been sent.
+ */
+void cfg80211_ch_switch_failed_notify(struct net_device *dev,
+				      struct cfg80211_chan_def *chandef);
+
 /**
  * ieee80211_operating_class_to_band - convert operating class to band
  *
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 406010d..d7c5b61 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -638,6 +638,20 @@
  *	%NL80211_ATTR_IFINDEX is now on %NL80211_ATTR_WIPHY_FREQ and the
  *	attributes determining channel width.
  *
+ * @NL80211_CMD_CH_SWITCH_STARTED_NOTIFY: Notify that a channel switch
+ *	has been started on an interface, regardless of the initiator
+ *	(ie. whether it was requested from a remote device or
+ *	initiated on our own).  It indicates that
+ *	%NL80211_ATTR_IFINDEX will be on %NL80211_ATTR_WIPHY_FREQ
+ *	after %NL80211_ATTR_CH_SWITCH_COUNT TBTT's.  The userspace may
+ *	decide to react to this indication by requesting other
+ *	interfaces to change channel as well.
+ *
+ * @NL80211_CMD_CH_SWITCH_FAILED_NOTIFY: Notify that a channel switch
+ *	has failed on %NL80211_ATTR_IFINDEX.  This notification can
+ *	only be sent after a @NL80211_CMD_CH_SWITCH_STARTED_NOTIFY has
+ *	been issued.
+ *
  * @NL80211_CMD_START_P2P_DEVICE: Start the given P2P Device, identified by
  *	its %NL80211_ATTR_WDEV identifier. It must have been created with
  *	%NL80211_CMD_NEW_INTERFACE previously. After it has been started, the
@@ -890,6 +904,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_SET_QOS_MAP,
 
+	NL80211_CMD_CH_SWITCH_STARTED_NOTIFY,
+	NL80211_CMD_CH_SWITCH_FAILED_NOTIFY,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0f1b18f2..804c3c9 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -11208,7 +11208,8 @@ EXPORT_SYMBOL(cfg80211_pmksa_candidate_notify);
 static void nl80211_ch_switch_notify(struct cfg80211_registered_device *rdev,
 				     struct net_device *netdev,
 				     struct cfg80211_chan_def *chandef,
-				     gfp_t gfp)
+				     gfp_t gfp,
+				     enum nl80211_commands notif)
 {
 	struct sk_buff *msg;
 	void *hdr;
@@ -11217,7 +11218,7 @@ static void nl80211_ch_switch_notify(struct cfg80211_registered_device *rdev,
 	if (!msg)
 		return;
 
-	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_CH_SWITCH_NOTIFY);
+	hdr = nl80211hdr_put(msg, 0, 0, 0, notif);
 	if (!hdr) {
 		nlmsg_free(msg);
 		return;
@@ -11259,10 +11260,39 @@ void cfg80211_ch_switch_notify(struct net_device *dev,
 
 	wdev->chandef = *chandef;
 	wdev->preset_chandef = *chandef;
-	nl80211_ch_switch_notify(rdev, dev, chandef, GFP_KERNEL);
+	nl80211_ch_switch_notify(rdev, dev, chandef, GFP_KERNEL,
+				 NL80211_CMD_CH_SWITCH_NOTIFY);
 }
 EXPORT_SYMBOL(cfg80211_ch_switch_notify);
 
+void cfg80211_ch_switch_started_notify(struct net_device *dev,
+			       struct cfg80211_chan_def *chandef)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
+
+	trace_cfg80211_ch_switch_started_notify(dev, chandef);
+
+	nl80211_ch_switch_notify(rdev, dev, chandef, GFP_KERNEL,
+				 NL80211_CMD_CH_SWITCH_STARTED_NOTIFY);
+}
+EXPORT_SYMBOL(cfg80211_ch_switch_started_notify);
+
+void cfg80211_ch_switch_failed_notify(struct net_device *dev,
+				      struct cfg80211_chan_def *chandef)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
+
+	trace_cfg80211_ch_switch_failed_notify(dev, chandef);
+
+	nl80211_ch_switch_notify(rdev, dev, chandef, GFP_KERNEL,
+				 NL80211_CMD_CH_SWITCH_FAILED_NOTIFY);
+}
+EXPORT_SYMBOL(cfg80211_ch_switch_failed_notify);
+
 void cfg80211_cqm_txe_notify(struct net_device *dev,
 			     const u8 *peer, u32 num_packets,
 			     u32 rate, u32 intvl, gfp_t gfp)
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index f3c13ff..1f6443b 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2259,6 +2259,38 @@ TRACE_EVENT(cfg80211_ch_switch_notify,
 		  NETDEV_PR_ARG, CHAN_DEF_PR_ARG)
 );
 
+TRACE_EVENT(cfg80211_ch_switch_started_notify,
+	TP_PROTO(struct net_device *netdev,
+		 struct cfg80211_chan_def *chandef),
+	TP_ARGS(netdev, chandef),
+	TP_STRUCT__entry(
+		NETDEV_ENTRY
+		CHAN_DEF_ENTRY
+	),
+	TP_fast_assign(
+		NETDEV_ASSIGN;
+		CHAN_DEF_ASSIGN(chandef);
+	),
+	TP_printk(NETDEV_PR_FMT ", " CHAN_DEF_PR_FMT,
+		  NETDEV_PR_ARG, CHAN_DEF_PR_ARG)
+);
+
+TRACE_EVENT(cfg80211_ch_switch_failed_notify,
+	TP_PROTO(struct net_device *netdev,
+		 struct cfg80211_chan_def *chandef),
+	TP_ARGS(netdev, chandef),
+	TP_STRUCT__entry(
+		NETDEV_ENTRY
+		CHAN_DEF_ENTRY
+	),
+	TP_fast_assign(
+		NETDEV_ASSIGN;
+		CHAN_DEF_ASSIGN(chandef);
+	),
+	TP_printk(NETDEV_PR_FMT ", " CHAN_DEF_PR_FMT,
+		  NETDEV_PR_ARG, CHAN_DEF_PR_ARG)
+);
+
 TRACE_EVENT(cfg80211_radar_event,
 	TP_PROTO(struct wiphy *wiphy, struct cfg80211_chan_def *chandef),
 	TP_ARGS(wiphy, chandef),
-- 
1.9.2

