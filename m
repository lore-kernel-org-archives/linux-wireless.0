Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:61391 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757869AbZLKNlz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 08:41:55 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH v2 27/31] wl1271: Fix supported rate management
Date: Fri, 11 Dec 2009 15:41:06 +0200
Message-Id: <1260538870-32297-28-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1260538870-32297-1-git-send-email-luciano.coelho@nokia.com>
References: <1260538870-32297-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Previously, only basic rates were used for data transmission - resulting in
reduced transfer rates. This patch takes enables the firmware to take advantage
of the full set of data rates supported by the AP.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    7 +++-
 drivers/net/wireless/wl12xx/wl1271_acx.c  |   24 ++++++++---
 drivers/net/wireless/wl12xx/wl1271_acx.h  |    5 ++-
 drivers/net/wireless/wl12xx/wl1271_init.c |    2 +-
 drivers/net/wireless/wl12xx/wl1271_main.c |   59 ++++++++++++----------------
 drivers/net/wireless/wl12xx/wl1271_tx.c   |   37 ++++++++++++++++++
 6 files changed, 90 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index c965c4a..9290c92 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -322,6 +322,10 @@ struct wl1271 {
 	enum wl1271_state state;
 	struct mutex mutex;
 
+#define WL1271_FLAG_STA_RATES_CHANGED  (0)
+#define WL1271_FLAG_STA_ASSOCIATED     (1)
+	unsigned long flags;
+
 	struct wl1271_partition_set part;
 
 	struct wl1271_chip chip;
@@ -394,7 +398,9 @@ struct wl1271 {
 	u16 aid;
 
 	/* currently configured rate set */
+	u32 sta_rate_set;
 	u32 basic_rate_set;
+	u32 rate_set;
 
 	/* The current band */
 	enum ieee80211_band band;
@@ -416,7 +422,6 @@ struct wl1271 {
 
 	/* PSM mode requested */
 	bool psm_requested;
-	bool associated;
 
 	/* retry counter for PSM entries */
 	u8 psm_entry_retry;
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index ea6427a..0ea1a48 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -787,10 +787,11 @@ int wl1271_acx_statistics(struct wl1271 *wl, struct acx_statistics *stats)
 	return 0;
 }
 
-int wl1271_acx_rate_policies(struct wl1271 *wl, u32 enabled_rates)
+int wl1271_acx_rate_policies(struct wl1271 *wl)
 {
 	struct acx_rate_policy *acx;
 	struct conf_tx_rate_class *c = &wl->conf.tx.rc_conf;
+	int idx = 0;
 	int ret = 0;
 
 	wl1271_debug(DEBUG_ACX, "acx rate policies");
@@ -802,12 +803,21 @@ int wl1271_acx_rate_policies(struct wl1271 *wl, u32 enabled_rates)
 		goto out;
 	}
 
-	/* configure one default (one-size-fits-all) rate class */
-	acx->rate_class_cnt = cpu_to_le32(1);
-	acx->rate_class[0].enabled_rates = cpu_to_le32(enabled_rates);
-	acx->rate_class[0].short_retry_limit = c->short_retry_limit;
-	acx->rate_class[0].long_retry_limit = c->long_retry_limit;
-	acx->rate_class[0].aflags = c->aflags;
+	/* configure one basic rate class */
+	idx = ACX_TX_BASIC_RATE;
+	acx->rate_class[idx].enabled_rates = cpu_to_le32(wl->basic_rate_set);
+	acx->rate_class[idx].short_retry_limit = c->short_retry_limit;
+	acx->rate_class[idx].long_retry_limit = c->long_retry_limit;
+	acx->rate_class[idx].aflags = c->aflags;
+
+	/* configure one AP supported rate class */
+	idx = ACX_TX_AP_FULL_RATE;
+	acx->rate_class[idx].enabled_rates = cpu_to_le32(wl->rate_set);
+	acx->rate_class[idx].short_retry_limit = c->short_retry_limit;
+	acx->rate_class[idx].long_retry_limit = c->long_retry_limit;
+	acx->rate_class[idx].aflags = c->aflags;
+
+	acx->rate_class_cnt = cpu_to_le32(ACX_TX_RATE_POLICY_CNT);
 
 	ret = wl1271_cmd_configure(wl, ACX_RATE_POLICY, acx, sizeof(*acx));
 	if (ret < 0) {
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index 6640ebf..b6a473f 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -826,6 +826,9 @@ struct acx_rate_class {
 	u8 reserved;
 };
 
+#define ACX_TX_BASIC_RATE      0
+#define ACX_TX_AP_FULL_RATE    1
+#define ACX_TX_RATE_POLICY_CNT 2
 struct acx_rate_policy {
 	struct acx_header header;
 
@@ -1058,7 +1061,7 @@ int wl1271_acx_set_preamble(struct wl1271 *wl, enum acx_preamble_type preamble);
 int wl1271_acx_cts_protect(struct wl1271 *wl,
 			   enum acx_ctsprotect_type ctsprotect);
 int wl1271_acx_statistics(struct wl1271 *wl, struct acx_statistics *stats);
-int wl1271_acx_rate_policies(struct wl1271 *wl, u32 enabled_rates);
+int wl1271_acx_rate_policies(struct wl1271 *wl);
 int wl1271_acx_ac_cfg(struct wl1271 *wl);
 int wl1271_acx_tid_cfg(struct wl1271 *wl);
 int wl1271_acx_frag_threshold(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
index c67889d..3b4ed07 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.c
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -284,7 +284,7 @@ int wl1271_hw_init(struct wl1271 *wl)
 		goto out_free_memmap;
 
 	/* Configure TX rate classes */
-	ret = wl1271_acx_rate_policies(wl, CONF_TX_RATE_MASK_BASIC);
+	ret = wl1271_acx_rate_policies(wl);
 	if (ret < 0)
 		goto out_free_memmap;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 7a73aaa..775b1e8 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -777,7 +777,20 @@ out:
 static int wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct wl1271 *wl = hw->priv;
+	struct ieee80211_conf *conf = &hw->conf;
+	struct ieee80211_tx_info *txinfo = IEEE80211_SKB_CB(skb);
+	struct ieee80211_sta *sta = txinfo->control.sta;
+	unsigned long flags;
 
+	/* peek into the rates configured in the STA entry */
+	spin_lock_irqsave(&wl->wl_lock, flags);
+	if (sta && sta->supp_rates[conf->channel->band] != wl->sta_rate_set) {
+		wl->sta_rate_set = sta->supp_rates[conf->channel->band];
+		set_bit(WL1271_FLAG_STA_RATES_CHANGED, &wl->flags);
+	}
+	spin_unlock_irqrestore(&wl->wl_lock, flags);
+
+	/* queue the packet */
 	skb_queue_tail(&wl->tx_queue, skb);
 
 	/*
@@ -1004,7 +1017,6 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 	wl->elp = false;
 	wl->psm = 0;
 	wl->psm_entry_retry = 0;
-	wl->associated = false;
 	wl->tx_queue_stopped = false;
 	wl->power_level = WL1271_DEFAULT_POWER_LEVEL;
 	wl->tx_blocks_available = 0;
@@ -1016,6 +1028,9 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 	wl->time_offset = 0;
 	wl->session_counter = 0;
 	wl->joined = false;
+	wl->rate_set = CONF_TX_RATE_MASK_BASIC;
+	wl->sta_rate_set = 0;
+	wl->flags = 0;
 
 	for (i = 0; i < NUM_TX_QUEUES; i++)
 		wl->tx_blocks_freed[i] = 0;
@@ -1212,8 +1227,9 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 			wl1271_join_channel(wl, channel);
 
 		if (conf->flags & IEEE80211_CONF_IDLE) {
-			wl->basic_rate_set = CONF_TX_RATE_MASK_BASIC;
-			wl1271_acx_rate_policies(wl, CONF_TX_RATE_MASK_BASIC);
+			wl->rate_set = CONF_TX_RATE_MASK_BASIC;
+			wl->sta_rate_set = 0;
+			wl1271_acx_rate_policies(wl);
 		}
 	}
 
@@ -1229,7 +1245,7 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 		 * If we're not, we'll enter it when joining an SSID,
 		 * through the bss_info_changed() hook.
 		 */
-		if (wl->associated) {
+		if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags)) {
 			wl1271_info("psm enabled");
 			ret = wl1271_ps_set_mode(wl, STATION_POWER_SAVE_MODE);
 		}
@@ -1522,22 +1538,6 @@ out:
 	return ret;
 }
 
-static u32 wl1271_enabled_rates_get(struct wl1271 *wl, u64 basic_rate_set)
-{
-	struct ieee80211_supported_band *band;
-	u32 enabled_rates = 0;
-	int bit;
-
-	band = wl->hw->wiphy->bands[wl->band];
-	for (bit = 0; bit < band->n_bitrates; bit++) {
-		if (basic_rate_set & 0x1)
-			enabled_rates |= band->bitrates[bit].hw_value;
-		basic_rate_set >>= 1;
-	}
-
-	return enabled_rates;
-}
-
 static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 				       struct ieee80211_vif *vif,
 				       struct ieee80211_bss_conf *bss_conf,
@@ -1616,7 +1616,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_ASSOC) {
 		if (bss_conf->assoc) {
 			wl->aid = bss_conf->aid;
-			wl->associated = true;
+			set_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags);
 
 			/*
 			 * with wl1271, we don't need to update the
@@ -1641,7 +1641,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			}
 		} else {
 			/* use defaults when not associated */
-			wl->associated = false;
+			clear_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags);
 			wl->aid = 0;
 		}
 
@@ -1676,17 +1676,6 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 		}
 	}
 
-	if (changed & BSS_CHANGED_BASIC_RATES) {
-		wl->basic_rate_set = wl1271_enabled_rates_get(
-			wl, bss_conf->basic_rates);
-
-		ret = wl1271_acx_rate_policies(wl, wl->basic_rate_set);
-		if (ret < 0) {
-			wl1271_warning("Set rate policies failed %d", ret);
-			goto out_sleep;
-		}
-	}
-
 out_sleep:
 	wl1271_ps_elp_sleep(wl);
 
@@ -1969,14 +1958,16 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 	wl->psm = 0;
 	wl->psm_requested = false;
 	wl->psm_entry_retry = 0;
-	wl->associated = false;
 	wl->tx_queue_stopped = false;
 	wl->power_level = WL1271_DEFAULT_POWER_LEVEL;
 	wl->basic_rate_set = CONF_TX_RATE_MASK_BASIC;
+	wl->rate_set = CONF_TX_RATE_MASK_BASIC;
+	wl->sta_rate_set = 0;
 	wl->band = IEEE80211_BAND_2GHZ;
 	wl->vif = NULL;
 	wl->joined = false;
 	wl->gpio_power = false;
+	wl->flags = 0;
 
 	for (i = 0; i < ACX_TX_DESCRIPTORS; i++)
 		wl->tx_frames[i] = NULL;
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
index 00af065..75f5327 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.c
@@ -121,6 +121,11 @@ static int wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 	pad = pad - skb->len;
 	tx_attr |= pad << TX_HW_ATTR_OFST_LAST_WORD_PAD;
 
+	/* if the packets are destined for AP (have a STA entry) send them
+	   with AP rate policies, otherwise use default basic rates */
+	if (control->control.sta)
+		tx_attr |= ACX_TX_AP_FULL_RATE << TX_HW_ATTR_OFST_RATE_POLICY;
+
 	desc->tx_attr = cpu_to_le16(tx_attr);
 
 	wl1271_debug(DEBUG_TX, "tx_fill_hdr: pad: %d", pad);
@@ -214,18 +219,50 @@ static int wl1271_tx_frame(struct wl1271 *wl, struct sk_buff *skb)
 	return ret;
 }
 
+static u32 wl1271_tx_enabled_rates_get(struct wl1271 *wl, u32 rate_set)
+{
+	struct ieee80211_supported_band *band;
+	u32 enabled_rates = 0;
+	int bit;
+
+	band = wl->hw->wiphy->bands[wl->band];
+	for (bit = 0; bit < band->n_bitrates; bit++) {
+		if (rate_set & 0x1)
+			enabled_rates |= band->bitrates[bit].hw_value;
+		rate_set >>= 1;
+	}
+
+	return enabled_rates;
+}
+
 void wl1271_tx_work(struct work_struct *work)
 {
 	struct wl1271 *wl = container_of(work, struct wl1271, tx_work);
 	struct sk_buff *skb;
 	bool woken_up = false;
+	u32 sta_rates = 0;
 	int ret;
 
+	/* check if the rates supported by the AP have changed */
+	if (unlikely(test_and_clear_bit(WL1271_FLAG_STA_RATES_CHANGED,
+					&wl->flags))) {
+		unsigned long flags;
+		spin_lock_irqsave(&wl->wl_lock, flags);
+		sta_rates = wl->sta_rate_set;
+		spin_unlock_irqrestore(&wl->wl_lock, flags);
+	}
+
 	mutex_lock(&wl->mutex);
 
 	if (unlikely(wl->state == WL1271_STATE_OFF))
 		goto out;
 
+	/* if rates have changed, re-configure the rate policy */
+	if (unlikely(sta_rates)) {
+		wl->rate_set = wl1271_tx_enabled_rates_get(wl, sta_rates);
+		wl1271_acx_rate_policies(wl);
+	}
+
 	while ((skb = skb_dequeue(&wl->tx_queue))) {
 		if (!woken_up) {
 			ret = wl1271_ps_elp_wakeup(wl, false);
-- 
1.6.3.3

