Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:36925 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbaL0OMa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Dec 2014 09:12:30 -0500
Received: by mail-wg0-f51.google.com with SMTP id x12so15819419wgg.38
        for <linux-wireless@vger.kernel.org>; Sat, 27 Dec 2014 06:12:29 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de, adrian@freebsd.org
Subject: [RFC 1/3] ath9k: add power per-rate tables for AR9002 chips
Date: Sat, 27 Dec 2014 15:12:23 +0100
Message-Id: <1419689545-26965-2-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20141227_151242_222004_E3DD68CB)
In-Reply-To: <1419689545-26965-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1419689545-26965-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add TX power per-rate tables for MIMO/legacy modes for AR9002 based chips
in order to cap the maximum TX power value per-rate in the TX descriptor path.
Add TX power adjustments for HT40 mode, open loop CCK rates and eeprom power
bias for AR9280 and later chips

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c  | 80 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/eeprom_4k.c   | 14 +++++
 drivers/net/wireless/ath/ath9k/eeprom_9287.c | 15 ++++++
 drivers/net/wireless/ath/ath9k/eeprom_def.c  | 14 +++++
 drivers/net/wireless/ath/ath9k/hw.h          |  2 +
 5 files changed, 125 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 5829074..f273427 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -22,6 +22,21 @@
 
 /* All code below is for AR5008, AR9001, AR9002 */
 
+#define AR5008_OFDM_RATES		8
+#define AR5008_HT_SS_RATES		8
+#define AR5008_HT_DS_RATES		8
+
+#define AR5008_HT20_SHIFT		16
+#define AR5008_HT40_SHIFT		24
+
+#define AR5008_11NA_OFDM_SHIFT		0
+#define AR5008_11NA_HT_SS_SHIFT		8
+#define AR5008_11NA_HT_DS_SHIFT		16
+
+#define AR5008_11NG_OFDM_SHIFT		4
+#define AR5008_11NG_HT_SS_SHIFT		12
+#define AR5008_11NG_HT_DS_SHIFT		20
+
 static const int firstep_table[] =
 /* level:  0   1   2   3   4   5   6   7   8  */
 	{ -4, -2,  0,  2,  4,  6,  8, 10, 12 }; /* lvl 0-8, default 2 */
@@ -1235,6 +1250,71 @@ static void ar5008_hw_set_radar_conf(struct ath_hw *ah)
 	conf->radar_inband = 8;
 }
 
+static void ar5008_hw_init_txpower_cck(struct ath_hw *ah, int16_t *rate_array)
+{
+#define CCK_DELTA(x) ((OLC_FOR_AR9280_20_LATER) ? max((x) - 2, 0) : (x))
+	ah->tx_power[0] = CCK_DELTA(rate_array[rate1l]);
+	ah->tx_power[1] = CCK_DELTA(min(rate_array[rate2l],
+					rate_array[rate2s]));
+	ah->tx_power[2] = CCK_DELTA(min(rate_array[rate5_5l],
+					rate_array[rate5_5s]));
+	ah->tx_power[3] = CCK_DELTA(min(rate_array[rate11l],
+					rate_array[rate11s]));
+#undef CCK_DELTA
+}
+
+static void ar5008_hw_init_txpower_ofdm(struct ath_hw *ah, int16_t *rate_array,
+					int offset)
+{
+	int i, idx = 0;
+
+	for (i = offset; i < offset + AR5008_OFDM_RATES; i++) {
+		ah->tx_power[i] = rate_array[idx];
+		idx++;
+	}
+}
+
+static void ar5008_hw_init_txpower_ht(struct ath_hw *ah, int16_t *rate_array,
+				      int ss_offset, int ds_offset,
+				      bool is_40, int ht40_delta)
+{
+	int i, mcs_idx = (is_40) ? AR5008_HT40_SHIFT : AR5008_HT20_SHIFT;
+
+	for (i = ss_offset; i < ss_offset + AR5008_HT_SS_RATES; i++) {
+		ah->tx_power[i] = rate_array[mcs_idx] + ht40_delta;
+		mcs_idx++;
+	}
+	memcpy(&ah->tx_power[ds_offset], &ah->tx_power[ss_offset],
+	       AR5008_HT_SS_RATES);
+}
+
+void ar5008_hw_init_rate_txpower(struct ath_hw *ah, int16_t *rate_array,
+				 struct ath9k_channel *chan, int ht40_delta)
+{
+	if (IS_CHAN_5GHZ(chan)) {
+		ar5008_hw_init_txpower_ofdm(ah, rate_array,
+					    AR5008_11NA_OFDM_SHIFT);
+		if (IS_CHAN_HT20(chan) || IS_CHAN_HT40(chan)) {
+			ar5008_hw_init_txpower_ht(ah, rate_array,
+						  AR5008_11NA_HT_SS_SHIFT,
+						  AR5008_11NA_HT_DS_SHIFT,
+						  IS_CHAN_HT40(chan),
+						  ht40_delta);
+		}
+	} else {
+		ar5008_hw_init_txpower_cck(ah, rate_array);
+		ar5008_hw_init_txpower_ofdm(ah, rate_array,
+					    AR5008_11NG_OFDM_SHIFT);
+		if (IS_CHAN_HT20(chan) || IS_CHAN_HT40(chan)) {
+			ar5008_hw_init_txpower_ht(ah, rate_array,
+						  AR5008_11NG_HT_SS_SHIFT,
+						  AR5008_11NG_HT_DS_SHIFT,
+						  IS_CHAN_HT40(chan),
+						  ht40_delta);
+		}
+	}
+}
+
 int ar5008_hw_attach_phy_ops(struct ath_hw *ah)
 {
 	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 07b806c..e5a78d4 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -748,6 +748,20 @@ static void ath9k_hw_4k_set_txpower(struct ath_hw *ah,
 			  | ATH9K_POW_SM(ratesArray[rateDupCck], 0));
 	}
 
+	/* TPC initializations */
+	if (ah->tpc_enabled) {
+		int ht40_delta;
+
+		ht40_delta = (IS_CHAN_HT40(chan)) ? ht40PowerIncForPdadc : 0;
+		ar5008_hw_init_rate_txpower(ah, ratesArray, chan, ht40_delta);
+		/* Enable TPC */
+		REG_WRITE(ah, AR_PHY_POWER_TX_RATE_MAX,
+			MAX_RATE_POWER | AR_PHY_POWER_TX_RATE_MAX_TPC_ENABLE);
+	} else {
+		/* Disable TPC */
+		REG_WRITE(ah, AR_PHY_POWER_TX_RATE_MAX, MAX_RATE_POWER);
+	}
+
 	REGWRITE_BUFFER_FLUSH(ah);
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index 5ba1385..6ca33df 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -886,6 +886,21 @@ static void ath9k_hw_ar9287_set_txpower(struct ath_hw *ah,
 			  | ATH9K_POW_SM(ratesArray[rateDupOfdm], 8)
 			  | ATH9K_POW_SM(ratesArray[rateDupCck], 0));
 	}
+
+	/* TPC initializations */
+	if (ah->tpc_enabled) {
+		int ht40_delta;
+
+		ht40_delta = (IS_CHAN_HT40(chan)) ? ht40PowerIncForPdadc : 0;
+		ar5008_hw_init_rate_txpower(ah, ratesArray, chan, ht40_delta);
+		/* Enable TPC */
+		REG_WRITE(ah, AR_PHY_POWER_TX_RATE_MAX,
+			MAX_RATE_POWER | AR_PHY_POWER_TX_RATE_MAX_TPC_ENABLE);
+	} else {
+		/* Disable TPC */
+		REG_WRITE(ah, AR_PHY_POWER_TX_RATE_MAX, MAX_RATE_POWER);
+	}
+
 	REGWRITE_BUFFER_FLUSH(ah);
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 122b846..0980590 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -1332,6 +1332,20 @@ static void ath9k_hw_def_set_txpower(struct ath_hw *ah,
 		  ATH9K_POW_SM(pModal->pwrDecreaseFor3Chain, 6)
 		  | ATH9K_POW_SM(pModal->pwrDecreaseFor2Chain, 0));
 
+	/* TPC initializations */
+	if (ah->tpc_enabled) {
+		int ht40_delta;
+
+		ht40_delta = (IS_CHAN_HT40(chan)) ? ht40PowerIncForPdadc : 0;
+		ar5008_hw_init_rate_txpower(ah, ratesArray, chan, ht40_delta);
+		/* Enable TPC */
+		REG_WRITE(ah, AR_PHY_POWER_TX_RATE_MAX,
+			MAX_RATE_POWER | AR_PHY_POWER_TX_RATE_MAX_TPC_ENABLE);
+	} else {
+		/* Disable TPC */
+		REG_WRITE(ah, AR_PHY_POWER_TX_RATE_MAX, MAX_RATE_POWER);
+	}
+
 	REGWRITE_BUFFER_FLUSH(ah);
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 1cbd335..69a1222 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -1086,6 +1086,8 @@ bool ar9003_is_paprd_enabled(struct ath_hw *ah);
 void ar9003_hw_set_chain_masks(struct ath_hw *ah, u8 rx, u8 tx);
 void ar9003_hw_init_rate_txpower(struct ath_hw *ah, u8 *rate_array,
 				 struct ath9k_channel *chan);
+void ar5008_hw_init_rate_txpower(struct ath_hw *ah, int16_t *rate_array,
+				 struct ath9k_channel *chan, int ht40_delta);
 
 /* Hardware family op attach helpers */
 int ar5008_hw_attach_phy_ops(struct ath_hw *ah);
-- 
2.1.0

