Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56289 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332Ab1B1Qve (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 11:51:34 -0500
Received: by bwz15 with SMTP id 15so3817800bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Feb 2011 08:51:33 -0800 (PST)
From: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 8/9] [{cfg|nl}80211] announce flag changes to userspace
Date: Mon, 28 Feb 2011 17:51:19 +0100
Cc: lrodriguez@atheros.com, nbd@openwrt.org, dubowoj@neratec.com,
	zefir.kurtisi@neratec.com, simon.wunderlich@saxnet.de
References: <201102281740.37036.bernhard.schmidt@saxnet.de>
In-Reply-To: <201102281740.37036.bernhard.schmidt@saxnet.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201102281751.19488.bernhard.schmidt@saxnet.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
---
 include/linux/nl80211.h |    3 ++
 net/wireless/nl80211.c  |   51 +++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |    2 +
 net/wireless/radar.c    |    4 +++
 4 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index e14b2dd..1355865 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -413,6 +413,8 @@
  * @NL80211_CMD_RADAR_CAC_START: Request a CAC.
  * @NL80211_CMD_RADAR_CAC_STOP: Stop a CAC early.
  * @NL80211_CMD_RADAR_CAC_DONE: Notification sent if a CAC has completed.
+ * @NL80211_CMD_RADAR_FLAGS_CHANGED: Notification sent if channel flags
+ *	have changed.
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -529,6 +531,7 @@ enum nl80211_commands {
 	NL80211_CMD_RADAR_CAC_START,
 	NL80211_CMD_RADAR_CAC_STOP,
 	NL80211_CMD_RADAR_CAC_DONE,
+	NL80211_CMD_RADAR_FLAGS_CHANGED,
 
 	/* add new commands above here */
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 20a24f4..4d6d2ad 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6205,6 +6205,57 @@ void nl80211_radar_cac_done(struct cfg80211_registered_device *rdev)
 	rcu_read_unlock();
 }
 
+static void radar_flags_changed_wdev(struct cfg80211_registered_device *rdev,
+				     struct wireless_dev *wdev,
+				     struct ieee80211_channel *chan)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_RADAR_FLAGS_CHANGED);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, wdev->netdev->ifindex);
+	NLA_PUT_U32(msg, NL80211_FREQUENCY_ATTR_FREQ, chan->center_freq);
+	if ((chan->flags & IEEE80211_CHAN_RADAR_CLEAR))
+		NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_RADAR_CLEAR);
+	if ((chan->flags & IEEE80211_CHAN_RADAR_INTERFERENCE))
+		NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_RADAR_INTERFERENCE);
+
+	if (genlmsg_end(msg, hdr) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_mlme_mcgrp.id, GFP_KERNEL);
+	return;
+
+ nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+}
+
+void nl80211_radar_flags_changed(struct cfg80211_registered_device *rdev,
+				 struct ieee80211_channel *chan)
+{
+	struct wireless_dev *wdev;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(wdev, &rdev->netdev_list, list)
+		radar_flags_changed_wdev(rdev, wdev, chan);
+
+	rcu_read_unlock();
+}
+
 static int nl80211_netlink_notify(struct notifier_block * nb,
 				  unsigned long state,
 				  void *_notify)
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index aa3c926..e7f84d8 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -99,5 +99,7 @@ nl80211_send_cqm_pktloss_notify(struct cfg80211_registered_device *rdev,
 				u32 num_packets, gfp_t gfp);
 
 void nl80211_radar_cac_done(struct cfg80211_registered_device *rdev);
+void nl80211_radar_flags_changed(struct cfg80211_registered_device *rdev,
+				 struct ieee80211_channel *chan);
 
 #endif /* __NET_WIRELESS_NL80211_H */
diff --git a/net/wireless/radar.c b/net/wireless/radar.c
index df2d03b..d8911d3 100644
--- a/net/wireless/radar.c
+++ b/net/wireless/radar.c
@@ -62,6 +62,7 @@ int radar_cac_start(struct cfg80211_registered_device *rdev)
 	}
 	chan->flags &= ~IEEE80211_CHAN_RADAR_CLEAR;
 	mutex_unlock(&radar.lock);
+	nl80211_radar_flags_changed(rdev, chan);
 
 	printk(KERN_INFO "DFS: starting CAC (%p)\n", rdev);
 
@@ -121,6 +122,7 @@ static void radar_cac(struct work_struct *work)
 			mutex_unlock(&radar.lock);
 
 			kfree(cac);
+			nl80211_radar_flags_changed(rdev, chan);
 			nl80211_radar_cac_done(rdev);
 			return;
 		}
@@ -168,6 +170,7 @@ static void close_channel(u16 freq)
 		if (chan == NULL)
 			continue;
 		chan->flags &= ~IEEE80211_CHAN_RADAR_CLEAR;
+		nl80211_radar_flags_changed(rdev, chan);
 
 		c = rdev->ops->get_channel(&rdev->wiphy);
 		if (c->center_freq != chan->center_freq)
@@ -224,6 +227,7 @@ static void update_all_interference_flags(u16 freq, bool set)
 		chan->flags &= ~IEEE80211_CHAN_RADAR_INTERFERENCE;
 		if (set)
 			chan->flags |= IEEE80211_CHAN_RADAR_INTERFERENCE;
+		nl80211_radar_flags_changed(rdev, chan);
 	}
 }
 
-- 
1.7.2.3
