Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:58612 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962AbaBYNtS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 08:49:18 -0500
Received: from ultralex.lan ([93.218.100.117]) by mail.gmx.com (mrgmx101) with
 ESMTPSA (Nemesis) id 0Ll0tl-1WqWfn1Job-00aoL7 for
 <linux-wireless@vger.kernel.org>; Tue, 25 Feb 2014 14:49:16 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 1/7] ath9k: move ath9k_init_channels_rates to common-init
Date: Tue, 25 Feb 2014 14:48:50 +0100
Message-Id: <1393336136-31069-2-git-send-email-linux@rempel-privat.de> (sfid-20140225_144922_274402_44A16CB7)
In-Reply-To: <1393336136-31069-1-git-send-email-linux@rempel-privat.de>
References: <1393336136-31069-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

and rename it to ath9k_cmn_init_channels_rates.
sbands are move to ath_common as well.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath.h               |   1 +
 drivers/net/wireless/ath/ath9k/Makefile      |   3 +-
 drivers/net/wireless/ath/ath9k/ath9k.h       |   1 -
 drivers/net/wireless/ath/ath9k/beacon.c      |   2 +-
 drivers/net/wireless/ath/ath9k/common-init.c | 170 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/common-init.h |  17 +++
 drivers/net/wireless/ath/ath9k/common.h      |   2 +
 drivers/net/wireless/ath/ath9k/init.c        | 172 ++-------------------------
 drivers/net/wireless/ath/ath9k/xmit.c        |   3 +-
 9 files changed, 208 insertions(+), 163 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/common-init.c
 create mode 100644 drivers/net/wireless/ath/ath9k/common-init.h

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 6260b83..d0e7ba8 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -163,6 +163,7 @@ struct ath_common {
 	bool bt_ant_diversity;
 
 	int last_rssi;
+	struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
 };
 
 struct sk_buff *ath_rxbuf_alloc(struct ath_common *common,
diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 747975e..b58fe99 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -51,7 +51,8 @@ ath9k_hw-$(CONFIG_ATH9K_BTCOEX_SUPPORT) += btcoex.o \
 obj-$(CONFIG_ATH9K_HW) += ath9k_hw.o
 
 obj-$(CONFIG_ATH9K_COMMON) += ath9k_common.o
-ath9k_common-y:=	common.o
+ath9k_common-y:=	common.o \
+			common-init.o
 
 ath9k_htc-y +=	htc_hst.o \
 		hif_usb.o \
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 21d13bc..e703ddad 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -753,7 +753,6 @@ struct ath_softc {
 	struct ath_rx rx;
 	struct ath_tx tx;
 	struct ath_beacon beacon;
-	struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
 
 #ifdef CONFIG_MAC80211_LEDS
 	bool led_registered;
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 32d00e8..6569528 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -80,7 +80,7 @@ static void ath9k_beacon_setup(struct ath_softc *sc, struct ieee80211_vif *vif,
 	u8 chainmask = ah->txchainmask;
 	u8 rate = 0;
 
-	sband = &sc->sbands[common->hw->conf.chandef.chan->band];
+	sband = &common->sbands[common->hw->conf.chandef.chan->band];
 	rate = sband->bitrates[rateidx].hw_value;
 	if (vif->bss_conf.use_short_preamble)
 		rate |= sband->bitrates[rateidx].hw_value_short;
diff --git a/drivers/net/wireless/ath/ath9k/common-init.c b/drivers/net/wireless/ath/ath9k/common-init.c
new file mode 100644
index 0000000..1fa30c3
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/common-init.c
@@ -0,0 +1,170 @@
+/*
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+/* We use the hw_value as an index into our private channel structure */
+
+#include "common.h"
+
+#define CHAN2G(_freq, _idx)  { \
+	.band = IEEE80211_BAND_2GHZ, \
+	.center_freq = (_freq), \
+	.hw_value = (_idx), \
+	.max_power = 20, \
+}
+
+#define CHAN5G(_freq, _idx) { \
+	.band = IEEE80211_BAND_5GHZ, \
+	.center_freq = (_freq), \
+	.hw_value = (_idx), \
+	.max_power = 20, \
+}
+
+/* Some 2 GHz radios are actually tunable on 2312-2732
+ * on 5 MHz steps, we support the channels which we know
+ * we have calibration data for all cards though to make
+ * this static */
+static const struct ieee80211_channel ath9k_2ghz_chantable[] = {
+	CHAN2G(2412, 0), /* Channel 1 */
+	CHAN2G(2417, 1), /* Channel 2 */
+	CHAN2G(2422, 2), /* Channel 3 */
+	CHAN2G(2427, 3), /* Channel 4 */
+	CHAN2G(2432, 4), /* Channel 5 */
+	CHAN2G(2437, 5), /* Channel 6 */
+	CHAN2G(2442, 6), /* Channel 7 */
+	CHAN2G(2447, 7), /* Channel 8 */
+	CHAN2G(2452, 8), /* Channel 9 */
+	CHAN2G(2457, 9), /* Channel 10 */
+	CHAN2G(2462, 10), /* Channel 11 */
+	CHAN2G(2467, 11), /* Channel 12 */
+	CHAN2G(2472, 12), /* Channel 13 */
+	CHAN2G(2484, 13), /* Channel 14 */
+};
+
+/* Some 5 GHz radios are actually tunable on XXXX-YYYY
+ * on 5 MHz steps, we support the channels which we know
+ * we have calibration data for all cards though to make
+ * this static */
+static const struct ieee80211_channel ath9k_5ghz_chantable[] = {
+	/* _We_ call this UNII 1 */
+	CHAN5G(5180, 14), /* Channel 36 */
+	CHAN5G(5200, 15), /* Channel 40 */
+	CHAN5G(5220, 16), /* Channel 44 */
+	CHAN5G(5240, 17), /* Channel 48 */
+	/* _We_ call this UNII 2 */
+	CHAN5G(5260, 18), /* Channel 52 */
+	CHAN5G(5280, 19), /* Channel 56 */
+	CHAN5G(5300, 20), /* Channel 60 */
+	CHAN5G(5320, 21), /* Channel 64 */
+	/* _We_ call this "Middle band" */
+	CHAN5G(5500, 22), /* Channel 100 */
+	CHAN5G(5520, 23), /* Channel 104 */
+	CHAN5G(5540, 24), /* Channel 108 */
+	CHAN5G(5560, 25), /* Channel 112 */
+	CHAN5G(5580, 26), /* Channel 116 */
+	CHAN5G(5600, 27), /* Channel 120 */
+	CHAN5G(5620, 28), /* Channel 124 */
+	CHAN5G(5640, 29), /* Channel 128 */
+	CHAN5G(5660, 30), /* Channel 132 */
+	CHAN5G(5680, 31), /* Channel 136 */
+	CHAN5G(5700, 32), /* Channel 140 */
+	/* _We_ call this UNII 3 */
+	CHAN5G(5745, 33), /* Channel 149 */
+	CHAN5G(5765, 34), /* Channel 153 */
+	CHAN5G(5785, 35), /* Channel 157 */
+	CHAN5G(5805, 36), /* Channel 161 */
+	CHAN5G(5825, 37), /* Channel 165 */
+};
+
+/* Atheros hardware rate code addition for short premble */
+#define SHPCHECK(__hw_rate, __flags) \
+	((__flags & IEEE80211_RATE_SHORT_PREAMBLE) ? (__hw_rate | 0x04 ) : 0)
+
+#define RATE(_bitrate, _hw_rate, _flags) {              \
+	.bitrate        = (_bitrate),                   \
+	.flags          = (_flags),                     \
+	.hw_value       = (_hw_rate),                   \
+	.hw_value_short = (SHPCHECK(_hw_rate, _flags))  \
+}
+
+static struct ieee80211_rate ath9k_legacy_rates[] = {
+	RATE(10, 0x1b, 0),
+	RATE(20, 0x1a, IEEE80211_RATE_SHORT_PREAMBLE),
+	RATE(55, 0x19, IEEE80211_RATE_SHORT_PREAMBLE),
+	RATE(110, 0x18, IEEE80211_RATE_SHORT_PREAMBLE),
+	RATE(60, 0x0b, (IEEE80211_RATE_SUPPORTS_5MHZ |
+			IEEE80211_RATE_SUPPORTS_10MHZ)),
+	RATE(90, 0x0f, (IEEE80211_RATE_SUPPORTS_5MHZ |
+			IEEE80211_RATE_SUPPORTS_10MHZ)),
+	RATE(120, 0x0a, (IEEE80211_RATE_SUPPORTS_5MHZ |
+			 IEEE80211_RATE_SUPPORTS_10MHZ)),
+	RATE(180, 0x0e, (IEEE80211_RATE_SUPPORTS_5MHZ |
+			 IEEE80211_RATE_SUPPORTS_10MHZ)),
+	RATE(240, 0x09, (IEEE80211_RATE_SUPPORTS_5MHZ |
+			 IEEE80211_RATE_SUPPORTS_10MHZ)),
+	RATE(360, 0x0d, (IEEE80211_RATE_SUPPORTS_5MHZ |
+			 IEEE80211_RATE_SUPPORTS_10MHZ)),
+	RATE(480, 0x08, (IEEE80211_RATE_SUPPORTS_5MHZ |
+			 IEEE80211_RATE_SUPPORTS_10MHZ)),
+	RATE(540, 0x0c, (IEEE80211_RATE_SUPPORTS_5MHZ |
+			 IEEE80211_RATE_SUPPORTS_10MHZ)),
+};
+
+int ath9k_cmn_init_channels_rates(struct ath_common *common)
+{
+	struct ath_hw *ah = (struct ath_hw *)common->ah;
+	void *channels;
+
+	BUILD_BUG_ON(ARRAY_SIZE(ath9k_2ghz_chantable) +
+		     ARRAY_SIZE(ath9k_5ghz_chantable) !=
+		     ATH9K_NUM_CHANNELS);
+
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_2GHZ) {
+		channels = devm_kzalloc(ah->dev,
+			sizeof(ath9k_2ghz_chantable), GFP_KERNEL);
+		if (!channels)
+		    return -ENOMEM;
+
+		memcpy(channels, ath9k_2ghz_chantable,
+		       sizeof(ath9k_2ghz_chantable));
+		common->sbands[IEEE80211_BAND_2GHZ].channels = channels;
+		common->sbands[IEEE80211_BAND_2GHZ].band = IEEE80211_BAND_2GHZ;
+		common->sbands[IEEE80211_BAND_2GHZ].n_channels =
+			ARRAY_SIZE(ath9k_2ghz_chantable);
+		common->sbands[IEEE80211_BAND_2GHZ].bitrates = ath9k_legacy_rates;
+		common->sbands[IEEE80211_BAND_2GHZ].n_bitrates =
+			ARRAY_SIZE(ath9k_legacy_rates);
+	}
+
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_5GHZ) {
+		channels = devm_kzalloc(ah->dev,
+			sizeof(ath9k_5ghz_chantable), GFP_KERNEL);
+		if (!channels)
+			return -ENOMEM;
+
+		memcpy(channels, ath9k_5ghz_chantable,
+		       sizeof(ath9k_5ghz_chantable));
+		common->sbands[IEEE80211_BAND_5GHZ].channels = channels;
+		common->sbands[IEEE80211_BAND_5GHZ].band = IEEE80211_BAND_5GHZ;
+		common->sbands[IEEE80211_BAND_5GHZ].n_channels =
+			ARRAY_SIZE(ath9k_5ghz_chantable);
+		common->sbands[IEEE80211_BAND_5GHZ].bitrates =
+			ath9k_legacy_rates + 4;
+		common->sbands[IEEE80211_BAND_5GHZ].n_bitrates =
+			ARRAY_SIZE(ath9k_legacy_rates) - 4;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(ath9k_cmn_init_channels_rates);
diff --git a/drivers/net/wireless/ath/ath9k/common-init.h b/drivers/net/wireless/ath/ath9k/common-init.h
new file mode 100644
index 0000000..8fc9049
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/common-init.h
@@ -0,0 +1,17 @@
+/*
+ * Copyright (c) 2009-2011 Atheros Communications Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+int ath9k_cmn_init_channels_rates(struct ath_common *common);
diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index 38b5609..4c449e3 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -21,6 +21,8 @@
 #include "hw.h"
 #include "hw-ops.h"
 
+#include "common-init.h"
+
 /* Common header for Atheros 802.11n base driver cores */
 
 #define WME_BA_BMP_SIZE         64
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 07a0315..172b2f9 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -62,111 +62,6 @@ module_param_named(ps_enable, ath9k_ps_enable, int, 0444);
 MODULE_PARM_DESC(ps_enable, "Enable WLAN PowerSave");
 
 bool is_ath9k_unloaded;
-/* We use the hw_value as an index into our private channel structure */
-
-#define CHAN2G(_freq, _idx)  { \
-	.band = IEEE80211_BAND_2GHZ, \
-	.center_freq = (_freq), \
-	.hw_value = (_idx), \
-	.max_power = 20, \
-}
-
-#define CHAN5G(_freq, _idx) { \
-	.band = IEEE80211_BAND_5GHZ, \
-	.center_freq = (_freq), \
-	.hw_value = (_idx), \
-	.max_power = 20, \
-}
-
-/* Some 2 GHz radios are actually tunable on 2312-2732
- * on 5 MHz steps, we support the channels which we know
- * we have calibration data for all cards though to make
- * this static */
-static const struct ieee80211_channel ath9k_2ghz_chantable[] = {
-	CHAN2G(2412, 0), /* Channel 1 */
-	CHAN2G(2417, 1), /* Channel 2 */
-	CHAN2G(2422, 2), /* Channel 3 */
-	CHAN2G(2427, 3), /* Channel 4 */
-	CHAN2G(2432, 4), /* Channel 5 */
-	CHAN2G(2437, 5), /* Channel 6 */
-	CHAN2G(2442, 6), /* Channel 7 */
-	CHAN2G(2447, 7), /* Channel 8 */
-	CHAN2G(2452, 8), /* Channel 9 */
-	CHAN2G(2457, 9), /* Channel 10 */
-	CHAN2G(2462, 10), /* Channel 11 */
-	CHAN2G(2467, 11), /* Channel 12 */
-	CHAN2G(2472, 12), /* Channel 13 */
-	CHAN2G(2484, 13), /* Channel 14 */
-};
-
-/* Some 5 GHz radios are actually tunable on XXXX-YYYY
- * on 5 MHz steps, we support the channels which we know
- * we have calibration data for all cards though to make
- * this static */
-static const struct ieee80211_channel ath9k_5ghz_chantable[] = {
-	/* _We_ call this UNII 1 */
-	CHAN5G(5180, 14), /* Channel 36 */
-	CHAN5G(5200, 15), /* Channel 40 */
-	CHAN5G(5220, 16), /* Channel 44 */
-	CHAN5G(5240, 17), /* Channel 48 */
-	/* _We_ call this UNII 2 */
-	CHAN5G(5260, 18), /* Channel 52 */
-	CHAN5G(5280, 19), /* Channel 56 */
-	CHAN5G(5300, 20), /* Channel 60 */
-	CHAN5G(5320, 21), /* Channel 64 */
-	/* _We_ call this "Middle band" */
-	CHAN5G(5500, 22), /* Channel 100 */
-	CHAN5G(5520, 23), /* Channel 104 */
-	CHAN5G(5540, 24), /* Channel 108 */
-	CHAN5G(5560, 25), /* Channel 112 */
-	CHAN5G(5580, 26), /* Channel 116 */
-	CHAN5G(5600, 27), /* Channel 120 */
-	CHAN5G(5620, 28), /* Channel 124 */
-	CHAN5G(5640, 29), /* Channel 128 */
-	CHAN5G(5660, 30), /* Channel 132 */
-	CHAN5G(5680, 31), /* Channel 136 */
-	CHAN5G(5700, 32), /* Channel 140 */
-	/* _We_ call this UNII 3 */
-	CHAN5G(5745, 33), /* Channel 149 */
-	CHAN5G(5765, 34), /* Channel 153 */
-	CHAN5G(5785, 35), /* Channel 157 */
-	CHAN5G(5805, 36), /* Channel 161 */
-	CHAN5G(5825, 37), /* Channel 165 */
-};
-
-/* Atheros hardware rate code addition for short premble */
-#define SHPCHECK(__hw_rate, __flags) \
-	((__flags & IEEE80211_RATE_SHORT_PREAMBLE) ? (__hw_rate | 0x04 ) : 0)
-
-#define RATE(_bitrate, _hw_rate, _flags) {              \
-	.bitrate        = (_bitrate),                   \
-	.flags          = (_flags),                     \
-	.hw_value       = (_hw_rate),                   \
-	.hw_value_short = (SHPCHECK(_hw_rate, _flags))  \
-}
-
-static struct ieee80211_rate ath9k_legacy_rates[] = {
-	RATE(10, 0x1b, 0),
-	RATE(20, 0x1a, IEEE80211_RATE_SHORT_PREAMBLE),
-	RATE(55, 0x19, IEEE80211_RATE_SHORT_PREAMBLE),
-	RATE(110, 0x18, IEEE80211_RATE_SHORT_PREAMBLE),
-	RATE(60, 0x0b, (IEEE80211_RATE_SUPPORTS_5MHZ |
-			IEEE80211_RATE_SUPPORTS_10MHZ)),
-	RATE(90, 0x0f, (IEEE80211_RATE_SUPPORTS_5MHZ |
-			IEEE80211_RATE_SUPPORTS_10MHZ)),
-	RATE(120, 0x0a, (IEEE80211_RATE_SUPPORTS_5MHZ |
-			 IEEE80211_RATE_SUPPORTS_10MHZ)),
-	RATE(180, 0x0e, (IEEE80211_RATE_SUPPORTS_5MHZ |
-			 IEEE80211_RATE_SUPPORTS_10MHZ)),
-	RATE(240, 0x09, (IEEE80211_RATE_SUPPORTS_5MHZ |
-			 IEEE80211_RATE_SUPPORTS_10MHZ)),
-	RATE(360, 0x0d, (IEEE80211_RATE_SUPPORTS_5MHZ |
-			 IEEE80211_RATE_SUPPORTS_10MHZ)),
-	RATE(480, 0x08, (IEEE80211_RATE_SUPPORTS_5MHZ |
-			 IEEE80211_RATE_SUPPORTS_10MHZ)),
-	RATE(540, 0x0c, (IEEE80211_RATE_SUPPORTS_5MHZ |
-			 IEEE80211_RATE_SUPPORTS_10MHZ)),
-};
 
 #ifdef CONFIG_MAC80211_LEDS
 static const struct ieee80211_tpt_blink ath9k_tpt_blink[] = {
@@ -486,51 +381,6 @@ static int ath9k_init_queues(struct ath_softc *sc)
 	return 0;
 }
 
-static int ath9k_init_channels_rates(struct ath_softc *sc)
-{
-	void *channels;
-
-	BUILD_BUG_ON(ARRAY_SIZE(ath9k_2ghz_chantable) +
-		     ARRAY_SIZE(ath9k_5ghz_chantable) !=
-		     ATH9K_NUM_CHANNELS);
-
-	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_2GHZ) {
-		channels = devm_kzalloc(sc->dev,
-			sizeof(ath9k_2ghz_chantable), GFP_KERNEL);
-		if (!channels)
-		    return -ENOMEM;
-
-		memcpy(channels, ath9k_2ghz_chantable,
-		       sizeof(ath9k_2ghz_chantable));
-		sc->sbands[IEEE80211_BAND_2GHZ].channels = channels;
-		sc->sbands[IEEE80211_BAND_2GHZ].band = IEEE80211_BAND_2GHZ;
-		sc->sbands[IEEE80211_BAND_2GHZ].n_channels =
-			ARRAY_SIZE(ath9k_2ghz_chantable);
-		sc->sbands[IEEE80211_BAND_2GHZ].bitrates = ath9k_legacy_rates;
-		sc->sbands[IEEE80211_BAND_2GHZ].n_bitrates =
-			ARRAY_SIZE(ath9k_legacy_rates);
-	}
-
-	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_5GHZ) {
-		channels = devm_kzalloc(sc->dev,
-			sizeof(ath9k_5ghz_chantable), GFP_KERNEL);
-		if (!channels)
-			return -ENOMEM;
-
-		memcpy(channels, ath9k_5ghz_chantable,
-		       sizeof(ath9k_5ghz_chantable));
-		sc->sbands[IEEE80211_BAND_5GHZ].channels = channels;
-		sc->sbands[IEEE80211_BAND_5GHZ].band = IEEE80211_BAND_5GHZ;
-		sc->sbands[IEEE80211_BAND_5GHZ].n_channels =
-			ARRAY_SIZE(ath9k_5ghz_chantable);
-		sc->sbands[IEEE80211_BAND_5GHZ].bitrates =
-			ath9k_legacy_rates + 4;
-		sc->sbands[IEEE80211_BAND_5GHZ].n_bitrates =
-			ARRAY_SIZE(ath9k_legacy_rates) - 4;
-	}
-	return 0;
-}
-
 static void ath9k_init_misc(struct ath_softc *sc)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
@@ -793,7 +643,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	if (ret)
 		goto err_btcoex;
 
-	ret = ath9k_init_channels_rates(sc);
+	ret = ath9k_cmn_init_channels_rates(common);
 	if (ret)
 		goto err_btcoex;
 
@@ -823,10 +673,11 @@ static void ath9k_init_band_txpower(struct ath_softc *sc, int band)
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *chan;
 	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct cfg80211_chan_def chandef;
 	int i;
 
-	sband = &sc->sbands[band];
+	sband = &common->sbands[band];
 	for (i = 0; i < sband->n_channels; i++) {
 		chan = &sband->channels[i];
 		ah->curchan = &ah->channels[chan->hw_value];
@@ -851,13 +702,16 @@ static void ath9k_init_txpower_limits(struct ath_softc *sc)
 
 void ath9k_reload_chainmask_settings(struct ath_softc *sc)
 {
-	if (!(sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT))
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_HT))
 		return;
 
-	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_2GHZ)
-		setup_ht_cap(sc, &sc->sbands[IEEE80211_BAND_2GHZ].ht_cap);
-	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_5GHZ)
-		setup_ht_cap(sc, &sc->sbands[IEEE80211_BAND_5GHZ].ht_cap);
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_2GHZ)
+		setup_ht_cap(sc, &common->sbands[IEEE80211_BAND_2GHZ].ht_cap);
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_5GHZ)
+		setup_ht_cap(sc, &common->sbands[IEEE80211_BAND_5GHZ].ht_cap);
 }
 
 static const struct ieee80211_iface_limit if_limits[] = {
@@ -969,10 +823,10 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_2GHZ)
 		hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
-			&sc->sbands[IEEE80211_BAND_2GHZ];
+			&common->sbands[IEEE80211_BAND_2GHZ];
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_5GHZ)
 		hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
-			&sc->sbands[IEEE80211_BAND_5GHZ];
+			&common->sbands[IEEE80211_BAND_5GHZ];
 
 	ath9k_init_wow(hw);
 	ath9k_reload_chainmask_settings(sc);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 9ec5a36..8b31e2e 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1076,6 +1076,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf,
 			     struct ath_tx_info *info, int len, bool rts)
 {
 	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct sk_buff *skb;
 	struct ieee80211_tx_info *tx_info;
 	struct ieee80211_tx_rate *rates;
@@ -1145,7 +1146,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf,
 		}
 
 		/* legacy rates */
-		rate = &sc->sbands[tx_info->band].bitrates[rates[i].idx];
+		rate = &common->sbands[tx_info->band].bitrates[rates[i].idx];
 		if ((tx_info->band == IEEE80211_BAND_2GHZ) &&
 		    !(rate->flags & IEEE80211_RATE_ERP_G))
 			phy = WLAN_RC_PHY_CCK;
-- 
1.9.0

