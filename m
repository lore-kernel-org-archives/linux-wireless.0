Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:48999 "EHLO silver.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934309AbXCWUnk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 16:43:40 -0400
From: Jiri Benc <jbenc@suse.cz>
To: "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20070323214400.642621638.midnight@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 14/19] mac80211: switch STA interfaces to PS mode during scan
Message-Id: <20070323204457.1E11D48585@silver.suse.cz>
Date: Fri, 23 Mar 2007 21:44:57 +0100 (CET)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This makes scans switch STA interfaces into PS mode so the AP queues frames
destined for us while we are scanning. This is achieved by sending a
nullfunc data frame with the PS mode bit set before scanning commences,
and a nullfunc data frame without the PS mode bit set after scanning is
completed.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
Signed-off-by: Jiri Benc <jbenc@suse.cz>

---

 net/mac80211/ieee80211_sta.c |   51 +++++++++++++++++++++++++++++++++++-------
 1 files changed, 43 insertions(+), 8 deletions(-)

202d728b6d56a44e1be0970ee3e3f0971fbd7c66
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index ce7dc28..087f176 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -2520,6 +2520,37 @@ int ieee80211_sta_set_bssid(struct net_d
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
 void ieee80211_scan_completed(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
@@ -2541,10 +2572,12 @@ void ieee80211_scan_completed(struct iee
 
 	spin_lock_bh(&local->sub_if_lock);
 	list_for_each_entry(sdata, &local->sub_if_list, list) {
-		netif_wake_queue(sdata->dev);
-
-		if (sdata->type == IEEE80211_IF_TYPE_STA)
+		if (sdata->type == IEEE80211_IF_TYPE_STA) {
+			if (sdata->u.sta.associated)
+				ieee80211_send_nullfunc(local, sdata, 0);
 			ieee80211_sta_timer((unsigned long)&sdata->u.sta);
+		}
+		netif_wake_queue(sdata->dev);
 	}
 	spin_unlock_bh(&local->sub_if_lock);
 
@@ -2664,9 +2697,6 @@ static int ieee80211_sta_start_scan(stru
 	  * ResultCode: SUCCESS, INVALID_PARAMETERS
 	 */
 
-	/* TODO: if assoc, move to power save mode for the duration of the
-	 * scan */
-
 	if (local->sta_scanning) {
 		if (local->scan_dev == dev)
 			return 0;
@@ -2688,8 +2718,12 @@ static int ieee80211_sta_start_scan(stru
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
@@ -2703,7 +2737,8 @@ static int ieee80211_sta_start_scan(stru
 					 list);
 	local->scan_channel_idx = 0;
 	local->scan_dev = dev;
-	schedule_delayed_work(&local->scan_work, 0);
+	/* TODO: start scan as soon as all nullfunc frames are ACKed */
+	schedule_delayed_work(&local->scan_work, IEEE80211_CHANNEL_TIME);
 
 	return 0;
 }
-- 
1.3.0

