Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:48398 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbYK2Vc6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Nov 2008 16:32:58 -0500
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/6 v2] mac80211: add sta_notify_ps callback
Date: Sat, 29 Nov 2008 22:32:56 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John W Linville <linville@tuxdriver.com>,
	Stefan Steuerwald <salsasepp@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200811292232.56550.chunkeey@web.de> (sfid-20081129_223302_681700_9CC6526E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is necessary in order to provide a proper Access point support for p54.

Unfortunately for us, there is no documented way to disable the interfering
power save buffering mechanism in firmware completely.

Therefore we give in and notify the driver through our new sta_notify_ps callback, 
so that we can update the filter state.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
BTW, the extra patch for mac80211_hwsim is no longer needed...
This is all for wireless-testing.
---
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 6a1d4ea..a6baf37 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -779,6 +779,19 @@ enum sta_notify_cmd {
 };
 
 /**
+ * enum sta_notify_ps_cmd - sta power save notify command
+ *
+ * Used with the sta_notify_ps() callback in &struct ieee80211_ops to
+ * notify the driver if a station made a power state transition.
+ *
+ * @STA_WILL_SLEEP: a station is now sleeping
+ * @STA_WOKE_UP: a sleeping station woke up
+ */
+enum sta_notify_ps_cmd {
+	STA_NOTIFY_SLEEP, STA_NOTIFY_AWAKE,
+};
+
+/**
  * enum ieee80211_tkip_key_type - get tkip key
  *
  * Used by drivers which need to get a tkip key for skb. Some drivers need a
@@ -1248,6 +1261,9 @@ enum ieee80211_ampdu_mlme_action {
  * @sta_notify: Notifies low level driver about addition or removal
  *	of associated station or AP.
  *
+ * @sta_ps_notify: Notifies low level driver about the power state transition
+ *	of a associated station. Must be atomic.
+ *
  * @conf_tx: Configure TX queue parameters (EDCF (aifs, cw_min, cw_max),
  *	bursting) for a hardware TX queue.
  *
@@ -1314,6 +1330,8 @@ struct ieee80211_ops {
 	int (*set_frag_threshold)(struct ieee80211_hw *hw, u32 value);
 	void (*sta_notify)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			enum sta_notify_cmd, struct ieee80211_sta *sta);
+	void (*sta_notify_ps)(struct ieee80211_hw *hw,
+			enum sta_notify_ps_cmd, struct ieee80211_sta *sta);
 	int (*conf_tx)(struct ieee80211_hw *hw, u16 queue,
 		       const struct ieee80211_tx_queue_params *params);
 	int (*get_tx_stats)(struct ieee80211_hw *hw,
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5a1a60f..3bf056e 100644
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
+	if (local->ops->sta_notify_ps)
+		local->ops->sta_notify_ps(local_to_hw(local), STA_WILL_SLEEP,
+					  &sta->sta);
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	printk(KERN_DEBUG "%s: STA %s aid %d enters power save mode\n",
 	       sdata->dev->name, print_mac(mac, sta->sta.addr), sta->sta.aid);
@@ -675,6 +679,9 @@ static int ap_sta_ps_end(struct sta_info *sta)
 	atomic_dec(&sdata->bss->num_sta_ps);
 
 	clear_sta_flags(sta, WLAN_STA_PS | WLAN_STA_PSPOLL);
+	if (local->ops->sta_notify_ps)
+		local->ops->sta_notify_ps(local_to_hw(local), STA_WOKE_UP,
+					  &sta->sta);
 
 	if (!skb_queue_empty(&sta->ps_tx_buf))
 		sta_info_clear_tim_bit(sta);
