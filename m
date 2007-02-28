Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:14445 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751930AbXB1U6m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 15:58:42 -0500
Received: from localhost (localhost.rutgers.edu [127.0.0.1])
	by annwn13.rutgers.edu (Postfix) with ESMTP id 9D24132407E
	for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 15:58:40 -0500 (EST)
Received: from annwn13.rutgers.edu ([127.0.0.1])
	by localhost (annwn13.rutgers.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 25684-09 for <linux-wireless@vger.kernel.org>;
	Wed, 28 Feb 2007 15:58:40 -0500 (EST)
Received: from [192.168.1.103] (resnet-172.23.52.117.resnet.rutgers.edu [172.23.52.117])
	by annwn13.rutgers.edu (Postfix) with ESMTP id 7AE08324077
	for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 15:58:40 -0500 (EST)
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 4/5] d80211: Stop virtual interfaces during scan
Date: Wed, 28 Feb 2007 15:39:43 -0500
To: linux-wireless@vger.kernel.org
Message-Id: <20070228203943.11473.81749.stgit@magic.sourmilk.net>
In-Reply-To: <20070228203943.11473.95222.stgit@magic.sourmilk.net>
References: <20070228203943.11473.95222.stgit@magic.sourmilk.net>
Content-Type: text/plain;
  charset=utf-8;
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This prevents data frames from being queued on the master device if it is
in the midst of a scan. It also makes both master and virtual interfaces
properly set trans_start when frames are sent so the network watchdog does
not try to reset the interfaces. tx_queue_len is left as the default on
virtual interfaces to allow frames to be queued while the device is
scanning.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 net/mac80211/ieee80211.c     |    5 +++--
 net/mac80211/ieee80211_sta.c |   23 ++++++++++++++++++-----
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index a0879ba..967df9c 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -1148,6 +1148,7 @@ static int __ieee80211_tx(struct ieee802
 		ret = local->ops->tx(local_to_hw(local), skb, control);
 		if (ret)
 			return IEEE80211_TX_AGAIN;
+		local->mdev->trans_start = jiffies;
 		ieee80211_led_tx(local, 1);
 	}
 	if (tx->u.tx.extra_frag) {
@@ -1178,6 +1179,7 @@ static int __ieee80211_tx(struct ieee802
 					    control);
 			if (ret)
 				return IEEE80211_TX_FRAG_AGAIN;
+			local->mdev->trans_start = jiffies;
 			ieee80211_led_tx(local, 1);
 			tx->u.tx.extra_frag[i] = NULL;
 		}
@@ -1588,6 +1590,7 @@ static int ieee80211_subif_start_xmit(st
 	skb->nh.raw = skb->data + nh_pos;
 	skb->h.raw = skb->data + h_pos;
 
+	dev->trans_start = jiffies;
 	dev_queue_xmit(skb);
 
 	return 0;
@@ -4433,7 +4436,6 @@ void ieee80211_if_setup(struct net_devic
 	dev->get_stats = ieee80211_get_stats;
 	dev->open = ieee80211_open;
 	dev->stop = ieee80211_stop;
-	dev->tx_queue_len = 0;
 	dev->uninit = ieee80211_if_reinit;
 	dev->destructor = ieee80211_if_free;
 }
@@ -4448,7 +4450,6 @@ void ieee80211_if_mgmt_setup(struct net_
 	dev->stop = ieee80211_mgmt_stop;
 	dev->type = ARPHRD_IEEE80211_PRISM;
 	dev->hard_header_parse = header_parse_80211;
-	dev->tx_queue_len = 0;
 	dev->uninit = ieee80211_if_reinit;
 	dev->destructor = ieee80211_if_free;
 }
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 9d08a37..280b24f 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -2527,7 +2527,7 @@ void ieee80211_scan_completed(struct iee
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct net_device *dev = local->scan_dev;
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_sub_if_data *sdata;
 	union iwreq_data wrqu;
 
 	printk(KERN_DEBUG "%s: scan completed\n", dev->name);
@@ -2542,15 +2542,23 @@ void ieee80211_scan_completed(struct iee
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
 
@@ -2637,6 +2645,7 @@ static int ieee80211_sta_start_scan(stru
 				    u8 *ssid, size_t ssid_len)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_sub_if_data *sdata;
 
 	if (ssid_len > IEEE80211_MAX_SSID_LEN)
 		return -EINVAL;
@@ -2680,7 +2689,11 @@ static int ieee80211_sta_start_scan(stru
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

