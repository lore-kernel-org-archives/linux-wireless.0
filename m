Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:40943 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933015Ab2DKTx5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 15:53:57 -0400
Received: by lbok13 with SMTP id k13so1102015lbo.31
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 12:53:54 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, coelho@ti.com
Subject: [PATCH 06/24] wlcore/wl12xx: add global elements to convert hw-rates to standard rates
Date: Wed, 11 Apr 2012 22:53:22 +0300
Message-Id: <1334174020-18957-7-git-send-email-coelho@ti.com> (sfid-20120411_215446_446042_936537DA)
In-Reply-To: <1334174020-18957-1-git-send-email-coelho@ti.com>
References: <1334174020-18957-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Rates reported by HW can be different between chip families. Make the
rate-to-idx translation tables private per family and use them in a
common translation function. Add a global element to help determine
which rates are HW HT-rates.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |   93 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wlcore/conf.h   |   31 +----------
 drivers/net/wireless/ti/wlcore/main.c   |   75 +-----------------------
 drivers/net/wireless/ti/wlcore/rx.c     |    4 +-
 drivers/net/wireless/ti/wlcore/tx.c     |   17 ++++-
 drivers/net/wireless/ti/wlcore/tx.h     |    2 +-
 drivers/net/wireless/ti/wlcore/wlcore.h |    9 +++
 7 files changed, 123 insertions(+), 108 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index eafa020..790c622 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -39,6 +39,96 @@
 #define WL12XX_TX_HW_BLOCK_GEM_SPARE            2
 #define WL12XX_TX_HW_BLOCK_SIZE                 252
 
+static const u8 wl12xx_rate_to_idx_2ghz[] = {
+	/* MCS rates are used only with 11n */
+	7,                             /* WL12XX_CONF_HW_RXTX_RATE_MCS7_SGI */
+	7,                             /* WL12XX_CONF_HW_RXTX_RATE_MCS7 */
+	6,                             /* WL12XX_CONF_HW_RXTX_RATE_MCS6 */
+	5,                             /* WL12XX_CONF_HW_RXTX_RATE_MCS5 */
+	4,                             /* WL12XX_CONF_HW_RXTX_RATE_MCS4 */
+	3,                             /* WL12XX_CONF_HW_RXTX_RATE_MCS3 */
+	2,                             /* WL12XX_CONF_HW_RXTX_RATE_MCS2 */
+	1,                             /* WL12XX_CONF_HW_RXTX_RATE_MCS1 */
+	0,                             /* WL12XX_CONF_HW_RXTX_RATE_MCS0 */
+
+	11,                            /* WL12XX_CONF_HW_RXTX_RATE_54   */
+	10,                            /* WL12XX_CONF_HW_RXTX_RATE_48   */
+	9,                             /* WL12XX_CONF_HW_RXTX_RATE_36   */
+	8,                             /* WL12XX_CONF_HW_RXTX_RATE_24   */
+
+	/* TI-specific rate */
+	CONF_HW_RXTX_RATE_UNSUPPORTED, /* WL12XX_CONF_HW_RXTX_RATE_22   */
+
+	7,                             /* WL12XX_CONF_HW_RXTX_RATE_18   */
+	6,                             /* WL12XX_CONF_HW_RXTX_RATE_12   */
+	3,                             /* WL12XX_CONF_HW_RXTX_RATE_11   */
+	5,                             /* WL12XX_CONF_HW_RXTX_RATE_9    */
+	4,                             /* WL12XX_CONF_HW_RXTX_RATE_6    */
+	2,                             /* WL12XX_CONF_HW_RXTX_RATE_5_5  */
+	1,                             /* WL12XX_CONF_HW_RXTX_RATE_2    */
+	0                              /* WL12XX_CONF_HW_RXTX_RATE_1    */
+};
+
+static const u8 wl12xx_rate_to_idx_5ghz[] = {
+	/* MCS rates are used only with 11n */
+	7,                             /* WL12XX_CONF_HW_RXTX_RATE_MCS7_SGI */
+	7,                             /* WL12XX_CONF_HW_RXTX_RATE_MCS7 */
+	6,                             /* WL12XX_CONF_HW_RXTX_RATE_MCS6 */
+	5,                             /* WL12XX_CONF_HW_RXTX_RATE_MCS5 */
+	4,                             /* WL12XX_CONF_HW_RXTX_RATE_MCS4 */
+	3,                             /* WL12XX_CONF_HW_RXTX_RATE_MCS3 */
+	2,                             /* WL12XX_CONF_HW_RXTX_RATE_MCS2 */
+	1,                             /* WL12XX_CONF_HW_RXTX_RATE_MCS1 */
+	0,                             /* WL12XX_CONF_HW_RXTX_RATE_MCS0 */
+
+	7,                             /* WL12XX_CONF_HW_RXTX_RATE_54   */
+	6,                             /* WL12XX_CONF_HW_RXTX_RATE_48   */
+	5,                             /* WL12XX_CONF_HW_RXTX_RATE_36   */
+	4,                             /* WL12XX_CONF_HW_RXTX_RATE_24   */
+
+	/* TI-specific rate */
+	CONF_HW_RXTX_RATE_UNSUPPORTED, /* WL12XX_CONF_HW_RXTX_RATE_22   */
+
+	3,                             /* WL12XX_CONF_HW_RXTX_RATE_18   */
+	2,                             /* WL12XX_CONF_HW_RXTX_RATE_12   */
+	CONF_HW_RXTX_RATE_UNSUPPORTED, /* WL12XX_CONF_HW_RXTX_RATE_11   */
+	1,                             /* WL12XX_CONF_HW_RXTX_RATE_9    */
+	0,                             /* WL12XX_CONF_HW_RXTX_RATE_6    */
+	CONF_HW_RXTX_RATE_UNSUPPORTED, /* WL12XX_CONF_HW_RXTX_RATE_5_5  */
+	CONF_HW_RXTX_RATE_UNSUPPORTED, /* WL12XX_CONF_HW_RXTX_RATE_2    */
+	CONF_HW_RXTX_RATE_UNSUPPORTED  /* WL12XX_CONF_HW_RXTX_RATE_1    */
+};
+
+static const u8 *wl12xx_band_rate_to_idx[] = {
+	[IEEE80211_BAND_2GHZ] = wl12xx_rate_to_idx_2ghz,
+	[IEEE80211_BAND_5GHZ] = wl12xx_rate_to_idx_5ghz
+};
+
+enum wl12xx_hw_rates {
+	WL12XX_CONF_HW_RXTX_RATE_MCS7_SGI = 0,
+	WL12XX_CONF_HW_RXTX_RATE_MCS7,
+	WL12XX_CONF_HW_RXTX_RATE_MCS6,
+	WL12XX_CONF_HW_RXTX_RATE_MCS5,
+	WL12XX_CONF_HW_RXTX_RATE_MCS4,
+	WL12XX_CONF_HW_RXTX_RATE_MCS3,
+	WL12XX_CONF_HW_RXTX_RATE_MCS2,
+	WL12XX_CONF_HW_RXTX_RATE_MCS1,
+	WL12XX_CONF_HW_RXTX_RATE_MCS0,
+	WL12XX_CONF_HW_RXTX_RATE_54,
+	WL12XX_CONF_HW_RXTX_RATE_48,
+	WL12XX_CONF_HW_RXTX_RATE_36,
+	WL12XX_CONF_HW_RXTX_RATE_24,
+	WL12XX_CONF_HW_RXTX_RATE_22,
+	WL12XX_CONF_HW_RXTX_RATE_18,
+	WL12XX_CONF_HW_RXTX_RATE_12,
+	WL12XX_CONF_HW_RXTX_RATE_11,
+	WL12XX_CONF_HW_RXTX_RATE_9,
+	WL12XX_CONF_HW_RXTX_RATE_6,
+	WL12XX_CONF_HW_RXTX_RATE_5_5,
+	WL12XX_CONF_HW_RXTX_RATE_2,
+	WL12XX_CONF_HW_RXTX_RATE_1,
+	WL12XX_CONF_HW_RXTX_RATE_MAX,
+};
 
 static struct wlcore_partition_set wl12xx_ptable[PART_TABLE_LEN] = {
 	[PART_DOWN] = {
@@ -741,6 +831,9 @@ static int __devinit wl12xx_probe(struct platform_device *pdev)
 	wl->num_tx_desc = 16;
 	wl->normal_tx_spare = WL12XX_TX_HW_BLOCK_SPARE_DEFAULT;
 	wl->gem_tx_spare = WL12XX_TX_HW_BLOCK_GEM_SPARE;
+	wl->band_rate_to_idx = wl12xx_band_rate_to_idx;
+	wl->hw_tx_rate_tbl_size = WL12XX_CONF_HW_RXTX_RATE_MAX;
+	wl->hw_min_ht_rate = WL12XX_CONF_HW_RXTX_RATE_MCS0;
 
 	return wlcore_probe(wl, pdev);
 }
diff --git a/drivers/net/wireless/ti/wlcore/conf.h b/drivers/net/wireless/ti/wlcore/conf.h
index 3bdb1be..11b6951 100644
--- a/drivers/net/wireless/ti/wlcore/conf.h
+++ b/drivers/net/wireless/ti/wlcore/conf.h
@@ -65,36 +65,7 @@ enum {
 	CONF_HW_RATE_INDEX_MAX     = CONF_HW_RATE_INDEX_54MBPS,
 };
 
-enum {
-	CONF_HW_RXTX_RATE_MCS7_SGI = 0,
-	CONF_HW_RXTX_RATE_MCS7,
-	CONF_HW_RXTX_RATE_MCS6,
-	CONF_HW_RXTX_RATE_MCS5,
-	CONF_HW_RXTX_RATE_MCS4,
-	CONF_HW_RXTX_RATE_MCS3,
-	CONF_HW_RXTX_RATE_MCS2,
-	CONF_HW_RXTX_RATE_MCS1,
-	CONF_HW_RXTX_RATE_MCS0,
-	CONF_HW_RXTX_RATE_54,
-	CONF_HW_RXTX_RATE_48,
-	CONF_HW_RXTX_RATE_36,
-	CONF_HW_RXTX_RATE_24,
-	CONF_HW_RXTX_RATE_22,
-	CONF_HW_RXTX_RATE_18,
-	CONF_HW_RXTX_RATE_12,
-	CONF_HW_RXTX_RATE_11,
-	CONF_HW_RXTX_RATE_9,
-	CONF_HW_RXTX_RATE_6,
-	CONF_HW_RXTX_RATE_5_5,
-	CONF_HW_RXTX_RATE_2,
-	CONF_HW_RXTX_RATE_1,
-	CONF_HW_RXTX_RATE_MAX,
-	CONF_HW_RXTX_RATE_UNSUPPORTED = 0xff
-};
-
-/* Rates between and including these are MCS rates */
-#define CONF_HW_RXTX_RATE_MCS_MIN CONF_HW_RXTX_RATE_MCS7_SGI
-#define CONF_HW_RXTX_RATE_MCS_MAX CONF_HW_RXTX_RATE_MCS0
+#define CONF_HW_RXTX_RATE_UNSUPPORTED 0xff
 
 enum {
 	CONF_SG_DISABLE = 0,
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index b56bbc3..3f558d5 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -4624,37 +4624,6 @@ static struct ieee80211_channel wl1271_channels[] = {
 	{ .hw_value = 14, .center_freq = 2484, .max_power = 25 },
 };
 
-/* mapping to indexes for wl1271_rates */
-static const u8 wl1271_rate_to_idx_2ghz[] = {
-	/* MCS rates are used only with 11n */
-	7,                            /* CONF_HW_RXTX_RATE_MCS7_SGI */
-	7,                            /* CONF_HW_RXTX_RATE_MCS7 */
-	6,                            /* CONF_HW_RXTX_RATE_MCS6 */
-	5,                            /* CONF_HW_RXTX_RATE_MCS5 */
-	4,                            /* CONF_HW_RXTX_RATE_MCS4 */
-	3,                            /* CONF_HW_RXTX_RATE_MCS3 */
-	2,                            /* CONF_HW_RXTX_RATE_MCS2 */
-	1,                            /* CONF_HW_RXTX_RATE_MCS1 */
-	0,                            /* CONF_HW_RXTX_RATE_MCS0 */
-
-	11,                            /* CONF_HW_RXTX_RATE_54   */
-	10,                            /* CONF_HW_RXTX_RATE_48   */
-	9,                             /* CONF_HW_RXTX_RATE_36   */
-	8,                             /* CONF_HW_RXTX_RATE_24   */
-
-	/* TI-specific rate */
-	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_22   */
-
-	7,                             /* CONF_HW_RXTX_RATE_18   */
-	6,                             /* CONF_HW_RXTX_RATE_12   */
-	3,                             /* CONF_HW_RXTX_RATE_11   */
-	5,                             /* CONF_HW_RXTX_RATE_9    */
-	4,                             /* CONF_HW_RXTX_RATE_6    */
-	2,                             /* CONF_HW_RXTX_RATE_5_5  */
-	1,                             /* CONF_HW_RXTX_RATE_2    */
-	0                              /* CONF_HW_RXTX_RATE_1    */
-};
-
 /* 11n STA capabilities */
 #define HW_RX_HIGHEST_RATE	72
 
@@ -4746,37 +4715,6 @@ static struct ieee80211_channel wl1271_channels_5ghz[] = {
 	{ .hw_value = 165, .center_freq = 5825, .max_power = 25 },
 };
 
-/* mapping to indexes for wl1271_rates_5ghz */
-static const u8 wl1271_rate_to_idx_5ghz[] = {
-	/* MCS rates are used only with 11n */
-	7,                            /* CONF_HW_RXTX_RATE_MCS7_SGI */
-	7,                            /* CONF_HW_RXTX_RATE_MCS7 */
-	6,                            /* CONF_HW_RXTX_RATE_MCS6 */
-	5,                            /* CONF_HW_RXTX_RATE_MCS5 */
-	4,                            /* CONF_HW_RXTX_RATE_MCS4 */
-	3,                            /* CONF_HW_RXTX_RATE_MCS3 */
-	2,                            /* CONF_HW_RXTX_RATE_MCS2 */
-	1,                            /* CONF_HW_RXTX_RATE_MCS1 */
-	0,                            /* CONF_HW_RXTX_RATE_MCS0 */
-
-	7,                             /* CONF_HW_RXTX_RATE_54   */
-	6,                             /* CONF_HW_RXTX_RATE_48   */
-	5,                             /* CONF_HW_RXTX_RATE_36   */
-	4,                             /* CONF_HW_RXTX_RATE_24   */
-
-	/* TI-specific rate */
-	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_22   */
-
-	3,                             /* CONF_HW_RXTX_RATE_18   */
-	2,                             /* CONF_HW_RXTX_RATE_12   */
-	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_11   */
-	1,                             /* CONF_HW_RXTX_RATE_9    */
-	0,                             /* CONF_HW_RXTX_RATE_6    */
-	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_5_5  */
-	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_2    */
-	CONF_HW_RXTX_RATE_UNSUPPORTED  /* CONF_HW_RXTX_RATE_1    */
-};
-
 static struct ieee80211_supported_band wl1271_band_5ghz = {
 	.channels = wl1271_channels_5ghz,
 	.n_channels = ARRAY_SIZE(wl1271_channels_5ghz),
@@ -4785,11 +4723,6 @@ static struct ieee80211_supported_band wl1271_band_5ghz = {
 	.ht_cap	= WL12XX_HT_CAP,
 };
 
-static const u8 *wl1271_band_rate_to_idx[] = {
-	[IEEE80211_BAND_2GHZ] = wl1271_rate_to_idx_2ghz,
-	[IEEE80211_BAND_5GHZ] = wl1271_rate_to_idx_5ghz
-};
-
 static const struct ieee80211_ops wl1271_ops = {
 	.start = wl1271_op_start,
 	.stop = wl1271_op_stop,
@@ -4824,18 +4757,18 @@ static const struct ieee80211_ops wl1271_ops = {
 };
 
 
-u8 wl1271_rate_to_idx(int rate, enum ieee80211_band band)
+u8 wlcore_rate_to_idx(struct wl1271 *wl, u8 rate, enum ieee80211_band band)
 {
 	u8 idx;
 
-	BUG_ON(band >= sizeof(wl1271_band_rate_to_idx)/sizeof(u8 *));
+	BUG_ON(band >= 2);
 
-	if (unlikely(rate >= CONF_HW_RXTX_RATE_MAX)) {
+	if (unlikely(rate >= wl->hw_tx_rate_tbl_size)) {
 		wl1271_error("Illegal RX rate from HW: %d", rate);
 		return 0;
 	}
 
-	idx = wl1271_band_rate_to_idx[band][rate];
+	idx = wl->band_rate_to_idx[band][rate];
 	if (unlikely(idx == CONF_HW_RXTX_RATE_UNSUPPORTED)) {
 		wl1271_error("Unsupported RX rate from HW: %d", rate);
 		return 0;
diff --git a/drivers/net/wireless/ti/wlcore/rx.c b/drivers/net/wireless/ti/wlcore/rx.c
index 71c8d70..db761af 100644
--- a/drivers/net/wireless/ti/wlcore/rx.c
+++ b/drivers/net/wireless/ti/wlcore/rx.c
@@ -71,10 +71,10 @@ static void wl1271_rx_status(struct wl1271 *wl,
 	else
 		status->band = IEEE80211_BAND_5GHZ;
 
-	status->rate_idx = wl1271_rate_to_idx(desc->rate, status->band);
+	status->rate_idx = wlcore_rate_to_idx(wl, desc->rate, status->band);
 
 	/* 11n support */
-	if (desc->rate <= CONF_HW_RXTX_RATE_MCS0)
+	if (desc->rate <= wl->hw_min_ht_rate)
 		status->flag |= RX_FLAG_HT;
 
 	status->signal = desc->rssi;
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index be8fcfd..1fabc48 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -759,11 +759,20 @@ static u8 wl1271_tx_get_rate_flags(u8 rate_class_index)
 {
 	u8 flags = 0;
 
-	if (rate_class_index >= CONF_HW_RXTX_RATE_MCS_MIN &&
-	    rate_class_index <= CONF_HW_RXTX_RATE_MCS_MAX)
+	/*
+	 * TODO: use wl12xx constants when this code is moved to wl12xx, as
+	 * only it uses Tx-completion.
+	 */
+	if (rate_class_index <= 8)
 		flags |= IEEE80211_TX_RC_MCS;
-	if (rate_class_index == CONF_HW_RXTX_RATE_MCS7_SGI)
+
+	/*
+	 * TODO: use wl12xx constants when this code is moved to wl12xx, as
+	 * only it uses Tx-completion.
+	 */
+	if (rate_class_index == 0)
 		flags |= IEEE80211_TX_RC_SHORT_GI;
+
 	return flags;
 }
 
@@ -801,7 +810,7 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
 	if (result->status == TX_SUCCESS) {
 		if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
 			info->flags |= IEEE80211_TX_STAT_ACK;
-		rate = wl1271_rate_to_idx(result->rate_class_index,
+		rate = wlcore_rate_to_idx(wl, result->rate_class_index,
 					  wlvif->band);
 		rate_flags = wl1271_tx_get_rate_flags(result->rate_class_index);
 		retries = result->ack_failures;
diff --git a/drivers/net/wireless/ti/wlcore/tx.h b/drivers/net/wireless/ti/wlcore/tx.h
index 4b01c87..2fd6e5d 100644
--- a/drivers/net/wireless/ti/wlcore/tx.h
+++ b/drivers/net/wireless/ti/wlcore/tx.h
@@ -209,7 +209,7 @@ void wl1271_tx_complete(struct wl1271 *wl);
 void wl12xx_tx_reset_wlvif(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 void wl12xx_tx_reset(struct wl1271 *wl, bool reset_tx_queues);
 void wl1271_tx_flush(struct wl1271 *wl);
-u8 wl1271_rate_to_idx(int rate, enum ieee80211_band band);
+u8 wlcore_rate_to_idx(struct wl1271 *wl, u8 rate, enum ieee80211_band band);
 u32 wl1271_tx_enabled_rates_get(struct wl1271 *wl, u32 rate_set,
 				enum ieee80211_band rate_band);
 u32 wl1271_tx_min_rate_get(struct wl1271 *wl, u32 rate_set);
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index fa636e2..3c0fbc6 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -319,6 +319,15 @@ struct wl1271 {
 	/* spare Tx blocks for normal/GEM operating modes */
 	u32 normal_tx_spare;
 	u32 gem_tx_spare;
+
+	/* translate HW Tx rates to standard rate-indices */
+	const u8 **band_rate_to_idx;
+
+	/* size of table for HW rates that can be received from chip */
+	u8 hw_tx_rate_tbl_size;
+
+	/* this HW rate and below are considered HT rates for this chip */
+	u8 hw_min_ht_rate;
 };
 
 int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev);
-- 
1.7.5.4

