Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:51498 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428Ab0DAIjM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Apr 2010 04:39:12 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/8] wl1271: Use minimum rate for each band for control messages
Date: Thu,  1 Apr 2010 11:38:20 +0300
Message-Id: <1270111104-29549-5-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1270111104-29549-1-git-send-email-luciano.coelho@nokia.com>
References: <1270111104-29549-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Currently the mac80211 is not telling a hardware rate controlled driver a
rate to use for association frames etc. So to be safe, use the lowest rate
of each band for communication.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    1 +
 drivers/net/wireless/wl12xx/wl1271_acx.c  |    2 +-
 drivers/net/wireless/wl12xx/wl1271_cmd.c  |   27 +++-----
 drivers/net/wireless/wl12xx/wl1271_conf.h |   13 ++++
 drivers/net/wireless/wl12xx/wl1271_main.c |   98 +++++++++++++++++++++++-----
 drivers/net/wireless/wl12xx/wl1271_tx.c   |    2 +-
 drivers/net/wireless/wl12xx/wl1271_tx.h   |    1 +
 7 files changed, 108 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index c5559ef..a29969e 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -447,6 +447,7 @@ struct wl1271 {
 	/* currently configured rate set */
 	u32 sta_rate_set;
 	u32 basic_rate_set;
+	u32 basic_rate;
 	u32 rate_set;
 
 	/* The current band */
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index 8f0bd5b..621c946 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -802,7 +802,7 @@ int wl1271_acx_rate_policies(struct wl1271 *wl)
 
 	/* configure one basic rate class */
 	idx = ACX_TX_BASIC_RATE;
-	acx->rate_class[idx].enabled_rates = cpu_to_le32(wl->basic_rate_set);
+	acx->rate_class[idx].enabled_rates = cpu_to_le32(wl->basic_rate);
 	acx->rate_class[idx].short_retry_limit = c->short_retry_limit;
 	acx->rate_class[idx].long_retry_limit = c->long_retry_limit;
 	acx->rate_class[idx].aflags = c->aflags;
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index f11f9f4..5cee59f 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -317,18 +317,10 @@ int wl1271_cmd_join(struct wl1271 *wl, u8 bss_type)
 	join->rx_config_options = cpu_to_le32(wl->rx_config);
 	join->rx_filter_options = cpu_to_le32(wl->rx_filter);
 	join->bss_type = bss_type;
+	join->basic_rate_set = wl->basic_rate_set;
 
-	if (wl->band == IEEE80211_BAND_2GHZ)
-		join->basic_rate_set = cpu_to_le32(CONF_HW_BIT_RATE_1MBPS   |
-						   CONF_HW_BIT_RATE_2MBPS   |
-						   CONF_HW_BIT_RATE_5_5MBPS |
-						   CONF_HW_BIT_RATE_11MBPS);
-	else {
+	if (wl->band == IEEE80211_BAND_5GHZ)
 		join->bss_type |= WL1271_JOIN_CMD_BSS_TYPE_5GHZ;
-		join->basic_rate_set = cpu_to_le32(CONF_HW_BIT_RATE_6MBPS  |
-						   CONF_HW_BIT_RATE_12MBPS |
-						   CONF_HW_BIT_RATE_24MBPS);
-	}
 
 	join->beacon_interval = cpu_to_le16(wl->beacon_int);
 	join->dtim_interval = WL1271_DEFAULT_DTIM_PERIOD;
@@ -581,17 +573,21 @@ int wl1271_cmd_scan(struct wl1271 *wl, const u8 *ssid, size_t ssid_len,
 	struct wl1271_cmd_trigger_scan_to *trigger = NULL;
 	struct wl1271_cmd_scan *params = NULL;
 	struct ieee80211_channel *channels;
+	u32 rate;
 	int i, j, n_ch, ret;
 	u16 scan_options = 0;
 	u8 ieee_band;
 
-	if (band == WL1271_SCAN_BAND_2_4_GHZ)
+	if (band == WL1271_SCAN_BAND_2_4_GHZ) {
 		ieee_band = IEEE80211_BAND_2GHZ;
-	else if (band == WL1271_SCAN_BAND_DUAL && wl1271_11a_enabled())
+		rate = wl->conf.tx.basic_rate;
+	} else if (band == WL1271_SCAN_BAND_DUAL && wl1271_11a_enabled()) {
 		ieee_band = IEEE80211_BAND_2GHZ;
-	else if (band == WL1271_SCAN_BAND_5_GHZ && wl1271_11a_enabled())
+		rate = wl->conf.tx.basic_rate;
+	} else if (band == WL1271_SCAN_BAND_5_GHZ && wl1271_11a_enabled()) {
 		ieee_band = IEEE80211_BAND_5GHZ;
-	else
+		rate = wl->conf.tx.basic_rate_5;
+	} else
 		return -EINVAL;
 
 	if (wl->hw->wiphy->bands[ieee_band]->channels == NULL)
@@ -618,8 +614,7 @@ int wl1271_cmd_scan(struct wl1271 *wl, const u8 *ssid, size_t ssid_len,
 	params->params.scan_options = cpu_to_le16(scan_options);
 
 	params->params.num_probe_requests = probe_requests;
-	/* Let the fw autodetect suitable tx_rate for probes */
-	params->params.tx_rate = 0;
+	params->params.tx_rate = rate;
 	params->params.tid_trigger = 0;
 	params->params.scan_tag = WL1271_SCAN_DEFAULT_TAG;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h b/drivers/net/wireless/wl12xx/wl1271_conf.h
index 82b5dab..0b34b62 100644
--- a/drivers/net/wireless/wl12xx/wl1271_conf.h
+++ b/drivers/net/wireless/wl12xx/wl1271_conf.h
@@ -674,6 +674,19 @@ struct conf_tx_settings {
 	 */
 	u16 tx_compl_threshold;
 
+	/*
+	 * The rate used for control messages and scanning on the 2.4GHz band
+	 *
+	 * Range: CONF_HW_BIT_RATE_* bit mask
+	 */
+	u32 basic_rate;
+
+	/*
+	 * The rate used for control messages and scanning on the 5GHz band
+	 *
+	 * Range: CONF_HW_BIT_RATE_* bit mask
+	 */
+	u32 basic_rate_5;
 };
 
 enum {
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 2494c96..ca5cd32 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -116,8 +116,7 @@ static struct conf_drv_settings default_conf = {
 	.tx = {
 		.tx_energy_detection         = 0,
 		.rc_conf                     = {
-			.enabled_rates       = CONF_HW_BIT_RATE_1MBPS |
-					       CONF_HW_BIT_RATE_2MBPS,
+			.enabled_rates       = 0,
 			.short_retry_limit   = 10,
 			.long_retry_limit    = 10,
 			.aflags              = 0
@@ -214,7 +213,9 @@ static struct conf_drv_settings default_conf = {
 		},
 		.frag_threshold              = IEEE80211_MAX_FRAG_THRESHOLD,
 		.tx_compl_timeout            = 700,
-		.tx_compl_threshold          = 4
+		.tx_compl_threshold          = 4,
+		.basic_rate                  = CONF_HW_BIT_RATE_1MBPS,
+		.basic_rate_5                = CONF_HW_BIT_RATE_6MBPS,
 	},
 	.conn = {
 		.wake_up_event               = CONF_WAKE_UP_EVENT_DTIM,
@@ -1171,6 +1172,32 @@ out:
 	return ret;
 }
 
+static void wl1271_set_band_rate(struct wl1271 *wl)
+{
+	if (wl->band == IEEE80211_BAND_2GHZ)
+		wl->basic_rate_set = wl->conf.tx.basic_rate;
+	else
+		wl->basic_rate_set = wl->conf.tx.basic_rate_5;
+}
+
+static u32 wl1271_min_rate_get(struct wl1271 *wl)
+{
+	int i;
+	u32 rate = 0;
+
+	if (!wl->basic_rate_set) {
+		WARN_ON(1);
+		wl->basic_rate_set = wl->conf.tx.basic_rate;
+	}
+
+	for (i = 0; !rate; i++) {
+		if ((wl->basic_rate_set >> i) & 0x1)
+			rate = 1 << i;
+	}
+
+	return rate;
+}
+
 static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct wl1271 *wl = hw->priv;
@@ -1187,12 +1214,38 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 
 	mutex_lock(&wl->mutex);
 
-	wl->band = conf->channel->band;
-
 	ret = wl1271_ps_elp_wakeup(wl, false);
 	if (ret < 0)
 		goto out;
 
+	/* if the channel changes while joined, join again */
+	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
+		wl->band = conf->channel->band;
+		wl->channel = channel;
+
+		/*
+		 * FIXME: the mac80211 should really provide a fixed rate
+		 * to use here. for now, just use the smallest possible rate
+		 * for the band as a fixed rate for association frames and
+		 * other control messages.
+		 */
+		if (!test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
+			wl1271_set_band_rate(wl);
+
+		wl->basic_rate = wl1271_min_rate_get(wl);
+		ret = wl1271_acx_rate_policies(wl);
+		if (ret < 0)
+			wl1271_warning("rate policy for update channel "
+				       "failed %d", ret);
+
+		if (test_bit(WL1271_FLAG_JOINED, &wl->flags)) {
+			ret = wl1271_cmd_join(wl, wl->set_bss_type);
+			if (ret < 0)
+				wl1271_warning("cmd join to update channel "
+					       "failed %d", ret);
+		}
+	}
+
 	if (changed & IEEE80211_CONF_CHANGE_IDLE) {
 		if (conf->flags & IEEE80211_CONF_IDLE &&
 		    test_bit(WL1271_FLAG_JOINED, &wl->flags))
@@ -1201,7 +1254,7 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 			wl1271_join_channel(wl, channel);
 
 		if (conf->flags & IEEE80211_CONF_IDLE) {
-			wl->rate_set = CONF_TX_RATE_MASK_BASIC;
+			wl->rate_set = wl1271_min_rate_get(wl);
 			wl->sta_rate_set = 0;
 			wl1271_acx_rate_policies(wl);
 			wl1271_acx_keep_alive_config(
@@ -1210,18 +1263,6 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 		}
 	}
 
-	/* if the channel changes while joined, join again */
-	if (channel != wl->channel &&
-	    test_bit(WL1271_FLAG_JOINED, &wl->flags)) {
-		wl->channel = channel;
-		/* FIXME: maybe use CMD_CHANNEL_SWITCH for this? */
-		ret = wl1271_cmd_join(wl, wl->set_bss_type);
-		if (ret < 0)
-			wl1271_warning("cmd join to update channel failed %d",
-				       ret);
-	} else
-		wl->channel = channel;
-
 	if (conf->flags & IEEE80211_CONF_PS &&
 	    !test_bit(WL1271_FLAG_PSM_REQUESTED, &wl->flags)) {
 		set_bit(WL1271_FLAG_PSM_REQUESTED, &wl->flags);
@@ -1659,10 +1700,23 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 
 	if (changed & BSS_CHANGED_ASSOC) {
 		if (bss_conf->assoc) {
+			u32 rates;
 			wl->aid = bss_conf->aid;
 			set_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags);
 
 			/*
+			 * use basic rates from AP, and determine lowest rate
+			 * to use with control frames.
+			 */
+			rates = bss_conf->basic_rates;
+			wl->basic_rate_set = wl1271_tx_enabled_rates_get(wl,
+									 rates);
+			wl->basic_rate = wl1271_min_rate_get(wl);
+			ret = wl1271_acx_rate_policies(wl);
+			if (ret < 0)
+				goto out_sleep;
+
+			/*
 			 * with wl1271, we don't need to update the
 			 * beacon_int and dtim_period, because the firmware
 			 * updates it by itself when the first beacon is
@@ -1712,6 +1766,13 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			clear_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags);
 			wl->aid = 0;
 
+			/* revert back to minimum rates for the current band */
+			wl1271_set_band_rate(wl);
+			wl->basic_rate = wl1271_min_rate_get(wl);
+			ret = wl1271_acx_rate_policies(wl);
+			if (ret < 0)
+				goto out_sleep;
+
 			/* disable connection monitor features */
 			ret = wl1271_acx_conn_monit_params(wl, false);
 
@@ -2261,6 +2322,7 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->psm_entry_retry = 0;
 	wl->power_level = WL1271_DEFAULT_POWER_LEVEL;
 	wl->basic_rate_set = CONF_TX_RATE_MASK_BASIC;
+	wl->basic_rate = CONF_TX_RATE_MASK_BASIC;
 	wl->rate_set = CONF_TX_RATE_MASK_BASIC;
 	wl->sta_rate_set = 0;
 	wl->band = IEEE80211_BAND_2GHZ;
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
index 66b48b7..0b8cdb4 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.c
@@ -220,7 +220,7 @@ static int wl1271_tx_frame(struct wl1271 *wl, struct sk_buff *skb)
 	return ret;
 }
 
-static u32 wl1271_tx_enabled_rates_get(struct wl1271 *wl, u32 rate_set)
+u32 wl1271_tx_enabled_rates_get(struct wl1271 *wl, u32 rate_set)
 {
 	struct ieee80211_supported_band *band;
 	u32 enabled_rates = 0;
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.h b/drivers/net/wireless/wl12xx/wl1271_tx.h
index b03c95d..3b8b7ac 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.h
@@ -160,5 +160,6 @@ void wl1271_tx_work(struct work_struct *work);
 void wl1271_tx_complete(struct wl1271 *wl);
 void wl1271_tx_flush(struct wl1271 *wl);
 u8 wl1271_rate_to_idx(struct wl1271 *wl, int rate);
+u32 wl1271_tx_enabled_rates_get(struct wl1271 *wl, u32 rate_set);
 
 #endif
-- 
1.6.3.3

