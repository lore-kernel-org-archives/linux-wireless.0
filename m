Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:58030 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751603AbaKGMcF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2014 07:32:05 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Fri,  7 Nov 2014 14:31:35 +0200
Message-Id: <1415363497-8475-2-git-send-email-luca@coelho.fi> (sfid-20141107_133215_823279_B8925929)
In-Reply-To: <1415363497-8475-1-git-send-email-luca@coelho.fi>
References: <1415363497-8475-1-git-send-email-luca@coelho.fi>
Subject: [PATCH v2 1/3] cfg80211/nl80211: add channel switch started notification
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

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 include/net/cfg80211.h       | 14 ++++++++++++++
 include/uapi/linux/nl80211.h | 11 +++++++++++
 net/wireless/nl80211.c       | 28 +++++++++++++++++++++++++---
 net/wireless/trace.h         | 16 ++++++++++++++++
 4 files changed, 66 insertions(+), 3 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5c3acd0..220d5f5 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4719,6 +4719,20 @@ bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
 void cfg80211_ch_switch_notify(struct net_device *dev,
 			       struct cfg80211_chan_def *chandef);
 
+/*
+ * cfg80211_ch_switch_started_notify - notify channel switch start
+ * @dev: the device on which the channel switch started
+ * @chandef: the future channel definition
+ * @count: the number of TBTTs until the channel switch happens
+ *
+ * Inform the userspace about the channel switch that has just
+ * started, so that it can take appropriate actions (eg. starting
+ * channel switch on other vifs), if necessary.
+ */
+void cfg80211_ch_switch_started_notify(struct net_device *dev,
+				       struct cfg80211_chan_def *chandef,
+				       u8 count);
+
 /**
  * ieee80211_operating_class_to_band - convert operating class to band
  *
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 9b3025e..3541634 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -645,6 +645,15 @@
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
  * @NL80211_CMD_START_P2P_DEVICE: Start the given P2P Device, identified by
  *	its %NL80211_ATTR_WDEV identifier. It must have been created with
  *	%NL80211_CMD_NEW_INTERFACE previously. After it has been started, the
@@ -930,6 +939,8 @@ enum nl80211_commands {
 	NL80211_CMD_JOIN_OCB,
 	NL80211_CMD_LEAVE_OCB,
 
+	NL80211_CMD_CH_SWITCH_STARTED_NOTIFY,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 24549cb..24fd292 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -11653,7 +11653,9 @@ EXPORT_SYMBOL(cfg80211_pmksa_candidate_notify);
 static void nl80211_ch_switch_notify(struct cfg80211_registered_device *rdev,
 				     struct net_device *netdev,
 				     struct cfg80211_chan_def *chandef,
-				     gfp_t gfp)
+				     gfp_t gfp,
+				     enum nl80211_commands notif,
+				     u8 count)
 {
 	struct sk_buff *msg;
 	void *hdr;
@@ -11662,7 +11664,7 @@ static void nl80211_ch_switch_notify(struct cfg80211_registered_device *rdev,
 	if (!msg)
 		return;
 
-	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_CH_SWITCH_NOTIFY);
+	hdr = nl80211hdr_put(msg, 0, 0, 0, notif);
 	if (!hdr) {
 		nlmsg_free(msg);
 		return;
@@ -11674,6 +11676,10 @@ static void nl80211_ch_switch_notify(struct cfg80211_registered_device *rdev,
 	if (nl80211_send_chandef(msg, chandef))
 		goto nla_put_failure;
 
+	if ((notif == NL80211_CMD_CH_SWITCH_STARTED_NOTIFY) &&
+	    (nla_put_u32(msg, NL80211_ATTR_CH_SWITCH_COUNT, count)))
+			goto nla_put_failure;
+
 	genlmsg_end(msg, hdr);
 
 	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy), msg, 0,
@@ -11704,10 +11710,26 @@ void cfg80211_ch_switch_notify(struct net_device *dev,
 
 	wdev->chandef = *chandef;
 	wdev->preset_chandef = *chandef;
-	nl80211_ch_switch_notify(rdev, dev, chandef, GFP_KERNEL);
+	nl80211_ch_switch_notify(rdev, dev, chandef, GFP_KERNEL,
+				 NL80211_CMD_CH_SWITCH_NOTIFY, 0);
 }
 EXPORT_SYMBOL(cfg80211_ch_switch_notify);
 
+void cfg80211_ch_switch_started_notify(struct net_device *dev,
+				       struct cfg80211_chan_def *chandef,
+				       u8 count)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
+
+	trace_cfg80211_ch_switch_started_notify(dev, chandef);
+
+	nl80211_ch_switch_notify(rdev, dev, chandef, GFP_KERNEL,
+				 NL80211_CMD_CH_SWITCH_STARTED_NOTIFY, count);
+}
+EXPORT_SYMBOL(cfg80211_ch_switch_started_notify);
+
 void cfg80211_cqm_txe_notify(struct net_device *dev,
 			     const u8 *peer, u32 num_packets,
 			     u32 rate, u32 intvl, gfp_t gfp)
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 277a85d..6e25370 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2355,6 +2355,22 @@ TRACE_EVENT(cfg80211_ch_switch_notify,
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
 TRACE_EVENT(cfg80211_radar_event,
 	TP_PROTO(struct wiphy *wiphy, struct cfg80211_chan_def *chandef),
 	TP_ARGS(wiphy, chandef),
-- 
2.1.1

