Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:48991 "EHLO silver.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934303AbXCWUnd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 16:43:33 -0400
From: Jiri Benc <jbenc@suse.cz>
To: "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20070323214400.642621638.midnight@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 7/19] mac80211: Stop virtual interfaces during scan
Message-Id: <20070323204449.84665484F9@silver.suse.cz>
Date: Fri, 23 Mar 2007 21:44:49 +0100 (CET)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This prevents data frames from being queued on the master device if it is
in the midst of a scan. It also makes both master and virtual interfaces
properly set trans_start when frames are sent. tx_queue_len is left as the
default on virtual interfaces to allow frames to be queued while the device
is scanning.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
Signed-off-by: Jiri Benc <jbenc@suse.cz>

---

 net/mac80211/ieee80211.c     |    5 +++--
 net/mac80211/ieee80211_sta.c |   28 +++++++++++++++++++---------
 2 files changed, 22 insertions(+), 11 deletions(-)

a24e7bbf06b53845f311f596203bc00e0564991d
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 30330b9..05c21d6 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -1145,6 +1145,7 @@ static int __ieee80211_tx(struct ieee802
 		ret = local->ops->tx(local_to_hw(local), skb, control);
 		if (ret)
 			return IEEE80211_TX_AGAIN;
+		local->mdev->trans_start = jiffies;
 		ieee80211_led_tx(local, 1);
 	}
 	if (tx->u.tx.extra_frag) {
@@ -1175,6 +1176,7 @@ static int __ieee80211_tx(struct ieee802
 					    control);
 			if (ret)
 				return IEEE80211_TX_FRAG_AGAIN;
+			local->mdev->trans_start = jiffies;
 			ieee80211_led_tx(local, 1);
 			tx->u.tx.extra_frag[i] = NULL;
 		}
@@ -1585,6 +1587,7 @@ #endif
 	skb->nh.raw = skb->data + nh_pos;
 	skb->h.raw = skb->data + h_pos;
 
+	dev->trans_start = jiffies;
 	dev_queue_xmit(skb);
 
 	return 0;
@@ -4423,7 +4426,6 @@ void ieee80211_if_setup(struct net_devic
 	dev->get_stats = ieee80211_get_stats;
 	dev->open = ieee80211_open;
 	dev->stop = ieee80211_stop;
-	dev->tx_queue_len = 0;
 	dev->uninit = ieee80211_if_reinit;
 	dev->destructor = ieee80211_if_free;
 }
@@ -4438,7 +4440,6 @@ void ieee80211_if_mgmt_setup(struct net_
 	dev->stop = ieee80211_mgmt_stop;
 	dev->type = ARPHRD_IEEE80211_PRISM;
 	dev->hard_header_parse = header_parse_80211;
-	dev->tx_queue_len = 0;
 	dev->uninit = ieee80211_if_reinit;
 	dev->destructor = ieee80211_if_free;
 }
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 9d08a37..ce7dc28 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -1918,10 +1918,7 @@ void ieee80211_sta_work(struct work_stru
 	if (!netif_running(dev))
 		return;
 
-	/* TODO: scan_dev check should be removed once scan_completed wakes
-	 * every STA interface */
-	if (local->sta_scanning &&
-	    local->scan_dev == dev)
+	if (local->sta_scanning)
 		return;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -2527,7 +2524,7 @@ void ieee80211_scan_completed(struct iee
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct net_device *dev = local->scan_dev;
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_sub_if_data *sdata;
 	union iwreq_data wrqu;
 
 	printk(KERN_DEBUG "%s: scan completed\n", dev->name);
@@ -2542,15 +2539,23 @@ void ieee80211_scan_completed(struct iee
 	memset(&wrqu, 0, sizeof(wrqu));
 	wireless_send_event(dev, SIOCGIWSCAN, &wrqu, NULL);
 
+	spin_lock_bh(&local->sub_if_lock);
+	list_for_each_entry(sdata, &local->sub_if_list, list) {
+		netif_wake_queue(sdata->dev);
+
+		if (sdata->type == IEEE80211_IF_TYPE_STA)
+			ieee80211_sta_timer((unsigned long)&sdata->u.sta);
+	}
+	spin_unlock_bh(&local->sub_if_lock);
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (sdata->type == IEEE80211_IF_TYPE_IBSS) {
 		struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 		if (!ifsta->bssid_set ||
 		    (!ifsta->state == IEEE80211_IBSS_JOINED &&
 		    !ieee80211_sta_active_ibss(dev)))
 			ieee80211_sta_find_ibss(dev, ifsta);
-	/* TODO: need to wake every sta interface */
-	} else if (sdata->type == IEEE80211_IF_TYPE_STA)
-		ieee80211_sta_timer((unsigned long)&sdata->u.sta);
+	}
 }
 EXPORT_SYMBOL(ieee80211_scan_completed);
 
@@ -2637,6 +2642,7 @@ static int ieee80211_sta_start_scan(stru
 				    u8 *ssid, size_t ssid_len)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_sub_if_data *sdata;
 
 	if (ssid_len > IEEE80211_MAX_SSID_LEN)
 		return -EINVAL;
@@ -2680,7 +2686,11 @@ static int ieee80211_sta_start_scan(stru
 	}
 
 	local->sta_scanning = 1;
-	/* TODO: stop TX queue? */
+
+	spin_lock_bh(&local->sub_if_lock);
+	list_for_each_entry(sdata, &local->sub_if_list, list)
+		netif_stop_queue(sdata->dev);
+	spin_unlock_bh(&local->sub_if_lock);
 
 	if (ssid) {
 		local->scan_ssid_len = ssid_len;
-- 
1.3.0

