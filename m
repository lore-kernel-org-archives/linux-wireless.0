Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:27699 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751932AbXB1U6m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 15:58:42 -0500
Received: from localhost (localhost.rutgers.edu [127.0.0.1])
	by annwn13.rutgers.edu (Postfix) with ESMTP id B140D324077
	for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 15:58:40 -0500 (EST)
Received: from annwn13.rutgers.edu ([127.0.0.1])
	by localhost (annwn13.rutgers.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 25667-10 for <linux-wireless@vger.kernel.org>;
	Wed, 28 Feb 2007 15:58:40 -0500 (EST)
Received: from [192.168.1.103] (resnet-172.23.52.117.resnet.rutgers.edu [172.23.52.117])
	by annwn13.rutgers.edu (Postfix) with ESMTP id 8CC7732403F
	for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 15:58:40 -0500 (EST)
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 5/5] d80211: switch STA interfaces to PS mode during scan
Date: Wed, 28 Feb 2007 15:39:43 -0500
To: linux-wireless@vger.kernel.org
Message-Id: <20070228203943.11473.88812.stgit@magic.sourmilk.net>
In-Reply-To: <20070228203943.11473.95222.stgit@magic.sourmilk.net>
References: <20070228203943.11473.95222.stgit@magic.sourmilk.net>
Content-Type: text/plain;
  charset=utf-8;
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This makes scans switch STA interfaces into PS mode so the AP queues frames
destined for us while we are scanning. This is achieved by sending a
nullfunc data frame with the PS mode bit set before scanning commences,
and a PS poll frame after scanning is completed.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 include/linux/ieee80211.h    |    7 ++++
 net/mac80211/ieee80211_sta.c |   77 ++++++++++++++++++++++++++++++++++++++----
 2 files changed, 76 insertions(+), 8 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 4379b1d..836bde2 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -203,6 +203,13 @@ struct ieee80211_cts {
 	__u8 ra[6];
 } __attribute__ ((packed));
 
+struct ieee80211_ps_poll {
+	__le16 frame_control;
+	__le16 aid;
+	__u8 bssid[6];
+	__u8 ta[6];
+} __attribute__ ((packed));
+
 
 /* Authentication algorithms */
 #define WLAN_AUTH_OPEN 0
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 280b24f..7270ae2 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -2523,6 +2523,32 @@ int ieee80211_sta_set_bssid(struct net_d
 }
 
 
+static void ieee80211_send_ps_poll(struct ieee80211_local *local,
+				   struct ieee80211_sub_if_data *sdata)
+{
+	struct sk_buff *skb;
+	struct ieee80211_ps_poll *ps_poll;
+
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom + sizeof(*ps_poll));
+	if (!skb) {
+		printk(KERN_DEBUG "%s: failed to allocate buffer for PS poll "
+		       "frame\n", sdata->dev->name);
+		return;
+	}
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+
+	ps_poll = (struct ieee80211_ps_poll *) skb_put(skb, sizeof(*ps_poll));
+	memset(ps_poll, 0, sizeof(*ps_poll));
+	ps_poll->frame_control = IEEE80211_FC(IEEE80211_FTYPE_CTL,
+					      IEEE80211_STYPE_PSPOLL);
+	ps_poll->aid = cpu_to_le16((1 << 15) | (1 << 14) | sdata->u.sta.aid);
+	memcpy(ps_poll->bssid, sdata->u.sta.bssid, ETH_ALEN);
+	memcpy(ps_poll->ta, sdata->dev->dev_addr, ETH_ALEN);
+
+	ieee80211_sta_tx(sdata->dev, skb, 0);
+}
+
+
 void ieee80211_scan_completed(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
@@ -2544,10 +2570,12 @@ void ieee80211_scan_completed(struct iee
 
 	spin_lock_bh(&local->sub_if_lock);
 	list_for_each_entry(sdata, &local->sub_if_list, list) {
-		netif_wake_queue(sdata->dev);
-
-		if (sdata->type == IEEE80211_IF_TYPE_STA)
+		if (sdata->type == IEEE80211_IF_TYPE_STA) {
+			if (sdata->u.sta.associated)
+				ieee80211_send_ps_poll(local, sdata);
 			ieee80211_sta_timer((unsigned long)&sdata->u.sta);
+		}
+		netif_wake_queue(sdata->dev);
 	}
 	spin_unlock_bh(&local->sub_if_lock);
 
@@ -2641,6 +2669,37 @@ void ieee80211_sta_scan_work(struct work
 }
 
 
+static void ieee80211_send_nullfunc(struct ieee80211_local *local,
+				    struct ieee80211_sub_if_data *sdata,
+				    int powersave)
+{
+	struct sk_buff *skb;
+	struct ieee80211_hdr *nullfunc;
+	u16 fc;
+
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom + 24);
+	if (!skb) {
+		printk(KERN_DEBUG "%s: failed to allocate buffer for nullfunc "
+		       "frame\n", sdata->dev->name);
+		return;
+	}
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+
+	nullfunc = (struct ieee80211_hdr *) skb_put(skb, 24);
+	memset(nullfunc, 0, 24);
+	fc = IEEE80211_FTYPE_DATA | IEEE80211_STYPE_NULLFUNC |
+	     IEEE80211_FCTL_TODS;
+	if (powersave)
+		fc |= IEEE80211_FCTL_PM;
+	nullfunc->frame_control = cpu_to_le16(fc);
+	memcpy(nullfunc->addr1, sdata->u.sta.bssid, ETH_ALEN);
+	memcpy(nullfunc->addr2, sdata->dev->dev_addr, ETH_ALEN);
+	memcpy(nullfunc->addr3, sdata->u.sta.bssid, ETH_ALEN);
+
+	ieee80211_sta_tx(sdata->dev, skb, 0);
+}
+
+
 static int ieee80211_sta_start_scan(struct net_device *dev,
 				    u8 *ssid, size_t ssid_len)
 {
@@ -2667,9 +2726,6 @@ static int ieee80211_sta_start_scan(stru
 	  * ResultCode: SUCCESS, INVALID_PARAMETERS
 	 */
 
-	/* TODO: if assoc, move to power save mode for the duration of the
-	 * scan */
-
 	if (local->sta_scanning) {
 		if (local->scan_dev == dev)
 			return 0;
@@ -2691,8 +2747,12 @@ static int ieee80211_sta_start_scan(stru
 	local->sta_scanning = 1;
 
 	spin_lock_bh(&local->sub_if_lock);
-	list_for_each_entry(sdata, &local->sub_if_list, list)
+	list_for_each_entry(sdata, &local->sub_if_list, list) {
 		netif_stop_queue(sdata->dev);
+		if (sdata->type == IEEE80211_IF_TYPE_STA &&
+		    sdata->u.sta.associated)
+			ieee80211_send_nullfunc(local, sdata, 1);
+	}
 	spin_unlock_bh(&local->sub_if_lock);
 
 	if (ssid) {
@@ -2706,7 +2766,8 @@ static int ieee80211_sta_start_scan(stru
 					 list);
 	local->scan_channel_idx = 0;
 	local->scan_dev = dev;
-	schedule_delayed_work(&local->scan_work, 0);
+	/* TODO: start scan as soon as all nullfunc frames are ACKed */
+	schedule_delayed_work(&local->scan_work, IEEE80211_CHANNEL_TIME);
 
 	return 0;
 }

