Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36882 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab1B1Q6S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 11:58:18 -0500
Received: by fxm17 with SMTP id 17so3925969fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Feb 2011 08:58:17 -0800 (PST)
From: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 7/9] [cfg80211] abide channel closing time
Date: Mon, 28 Feb 2011 17:50:45 +0100
Cc: lrodriguez@atheros.com, nbd@openwrt.org, dubowoj@neratec.com,
	zefir.kurtisi@neratec.com, simon.wunderlich@saxnet.de
References: <201102281740.37036.bernhard.schmidt@saxnet.de>
In-Reply-To: <201102281740.37036.bernhard.schmidt@saxnet.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201102281750.46424.bernhard.schmidt@saxnet.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

DFS requires that if interference has been detected, transmission on
a channel is stopped latest after the channel closing time. During
this period it must still be possible to at least send beacons, e.g.
for CSAs.

Signed-off-by: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
---
 net/wireless/radar.c |   92 ++++++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/radar.h |    7 ++++
 2 files changed, 99 insertions(+), 0 deletions(-)

diff --git a/net/wireless/radar.c b/net/wireless/radar.c
index 5a1ceab..df2d03b 100644
--- a/net/wireless/radar.c
+++ b/net/wireless/radar.c
@@ -129,6 +129,89 @@ static void radar_cac(struct work_struct *work)
 }
 static DECLARE_WORK(cac_work, radar_cac);
 
+static int cc_add_chan(u16 freq)
+{
+	struct radar_cc_list *cc;
+
+	printk(KERN_INFO "DFS: enable CC for freq %u MHz\n", freq);
+
+	mutex_lock(&radar.lock);
+	list_for_each_entry(cc, &radar.cc_list, list) {
+		if (cc->freq == freq) {
+			mutex_unlock(&radar.lock);
+			return 0;
+		}
+	}
+	mutex_unlock(&radar.lock);
+
+	cc = kmalloc(sizeof(struct radar_cc_list), GFP_KERNEL);
+	if (cc == NULL)
+		return -ENOMEM;
+
+	mutex_lock(&radar.lock);
+	cc->freq = freq;
+	cc->timeout = jiffies + msecs_to_jiffies(radar.params->close_time);
+	list_add_tail(&cc->list, &radar.cc_list);
+	mutex_unlock(&radar.lock);
+	return 0;
+}
+
+static void close_channel(u16 freq)
+{
+	struct cfg80211_registered_device *rdev;
+
+	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
+		struct wireless_dev *wdev;
+		struct ieee80211_channel *chan, *c;
+
+		chan = ieee80211_get_channel(&rdev->wiphy, freq);
+		if (chan == NULL)
+			continue;
+		chan->flags &= ~IEEE80211_CHAN_RADAR_CLEAR;
+
+		c = rdev->ops->get_channel(&rdev->wiphy);
+		if (c->center_freq != chan->center_freq)
+			continue;
+
+		list_for_each_entry(wdev, &rdev->netdev_list, list) {
+			if (wdev->iftype == NL80211_IFTYPE_ADHOC ||
+			    wdev->iftype == NL80211_IFTYPE_AP ||
+			    wdev->iftype == NL80211_IFTYPE_AP_VLAN ||
+			    wdev->iftype == NL80211_IFTYPE_MESH_POINT ||
+			    wdev->iftype == NL80211_IFTYPE_P2P_GO)
+				rdev->ops->del_beacon(&rdev->wiphy,
+						      wdev->netdev);
+		}
+	}
+}
+
+static void radar_cc(struct work_struct *work)
+{
+	struct radar_cc_list *cc, *tmp;
+
+	mutex_lock(&radar.lock);
+	list_for_each_entry_safe(cc, tmp, &radar.cc_list, list) {
+		unsigned long timeout = cc->timeout;
+
+		/* the next interation might already be to late. */
+		cc->timeout -= msecs_to_jiffies(100);
+
+		if (time_is_before_jiffies(timeout)) {
+			printk(KERN_INFO "DFS: transmission close time "
+			       "on freq %u MHz reached\n", cc->freq);
+
+			close_channel(cc->freq);
+			list_del(&cc->list);
+			mutex_unlock(&radar.lock);
+
+			kfree(cc);
+			return;
+		}
+	}
+	mutex_unlock(&radar.lock);
+}
+static DECLARE_WORK(cc_work, radar_cc);
+
 static void update_all_interference_flags(u16 freq, bool set)
 {
 	struct cfg80211_registered_device *rdev;
@@ -237,10 +320,13 @@ static void radar_timer(unsigned long data)
 {
 	if (!list_empty(&radar.cac_list))
 		schedule_work(&cac_work);
+	if (!list_empty(&radar.cc_list))
+		schedule_work(&cc_work);
 	if (!list_empty(&radar.nol_list))
 		schedule_work(&nol_work);
 
 	if (!list_empty(&radar.cac_list) ||
+	    !list_empty(&radar.cc_list) ||
 	    !list_empty(&radar.nol_list))
 		mod_timer(&radar.timer, jiffies + msecs_to_jiffies(100));
 }
@@ -255,6 +341,7 @@ void radar_init(void)
 
 	mutex_init(&radar.lock);
 	INIT_LIST_HEAD(&radar.cac_list);
+	INIT_LIST_HEAD(&radar.cc_list);
 	INIT_LIST_HEAD(&radar.nol_list);
 	setup_timer(&radar.timer, radar_timer, (unsigned long)0);
 }
@@ -262,6 +349,7 @@ void radar_init(void)
 void radar_deinit(void)
 {
 	struct radar_cac_list *cac, *cactmp;
+	struct radar_cc_list *cc, *cctmp;
 	struct radar_nol_list *nol, *noltmp;
 
 	del_timer_sync(&radar.timer);
@@ -270,6 +358,10 @@ void radar_deinit(void)
 		list_del(&cac->list);
 		kfree(cac);
 	}
+	list_for_each_entry_safe(cc, cctmp, &radar.cac_list, list) {
+		list_del(&cc->list);
+		kfree(cc);
+	}
 	list_for_each_entry_safe(nol, noltmp, &radar.nol_list, list) {
 		list_del(&nol->list);
 		kfree(nol);
diff --git a/net/wireless/radar.h b/net/wireless/radar.h
index 4ec1aae..23214dd 100644
--- a/net/wireless/radar.h
+++ b/net/wireless/radar.h
@@ -33,6 +33,12 @@ struct radar_cac_list {
 	struct list_head list;
 };
 
+struct radar_cc_list {
+	u16 freq;
+	unsigned long timeout;
+	struct list_head list;
+};
+
 struct radar_nol_list {
 	u16 freq;
 	unsigned long timeout;
@@ -44,6 +50,7 @@ struct radar {
 	struct mutex lock;
 	struct timer_list timer;
 	struct list_head cac_list;
+	struct list_head cc_list;
 	struct list_head nol_list;
 };
 
-- 
1.7.2.3
