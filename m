Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:50181 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbYK1Wpm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2008 17:45:42 -0500
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] mac80211: add power state transition callbacks
Date: Fri, 28 Nov 2008 23:45:48 +0100
Cc: John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Stefan Steuerwald <salsasepp@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200811282345.48379.chunkeey@web.de> (sfid-20081128_234545_476494_A00F7605)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is necessary in order to provide a proper Access point support for p54.

Unfortunatly for us, there is no documented way to disable the interfering
power save buffering mechanism in firmware completely.

Therefore we give in and notify the driver through our new sta_notify callback, 
so that we can update the filter state.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 6a1d4ea..7bd8edc 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -768,14 +768,18 @@ struct ieee80211_sta {
 /**
  * enum sta_notify_cmd - sta notify command
  *
- * Used with the sta_notify() callback in &struct ieee80211_ops, this
- * indicates addition and removal of a station to station table.
+ * Used with the sta_notify() callback in &struct ieee80211_ops.
+ * this command indicates addition and removal of a station to
+ * station table, or if a station made a power state transition.
  *
  * @STA_NOTIFY_ADD: a station was added to the station table
  * @STA_NOTIFY_REMOVE: a station being removed from the station table
+ * @STA_NOTIFY_SLEEP: a station is now sleeping
+ * @STA_NOTIFY_AWAKE: a sleeping station woke up
  */
 enum sta_notify_cmd {
-	STA_NOTIFY_ADD, STA_NOTIFY_REMOVE
+	STA_NOTIFY_ADD, STA_NOTIFY_REMOVE,
+	STA_NOTIFY_SLEEP, STA_NOTIFY_AWAKE,
 };
 
 /**
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5a1a60f..2d311a1 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -654,10 +654,14 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 static void ap_sta_ps_start(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct ieee80211_local *local = sdata->local;
 	DECLARE_MAC_BUF(mac);
 
 	atomic_inc(&sdata->bss->num_sta_ps);
 	set_and_clear_sta_flags(sta, WLAN_STA_PS, WLAN_STA_PSPOLL);
+	if (local->ops->sta_notify)
+		local->ops->sta_notify(local_to_hw(local), &sdata->vif,
+				       STA_NOTIFY_SLEEP, &sta->sta);
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	printk(KERN_DEBUG "%s: STA %s aid %d enters power save mode\n",
 	       sdata->dev->name, print_mac(mac, sta->sta.addr), sta->sta.aid);
@@ -675,6 +679,9 @@ static int ap_sta_ps_end(struct sta_info *sta)
 	atomic_dec(&sdata->bss->num_sta_ps);
 
 	clear_sta_flags(sta, WLAN_STA_PS | WLAN_STA_PSPOLL);
+	if (local->ops->sta_notify)
+		local->ops->sta_notify(local_to_hw(local), &sdata->vif,
+				       STA_NOTIFY_AWAKE, &sta->sta);
 
 	if (!skb_queue_empty(&sta->ps_tx_buf))
 		sta_info_clear_tim_bit(sta);
