Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:47253 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756056AbZC3KCh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 06:02:37 -0400
Received: from mail.atheros.com ([10.10.20.86])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2009 03:02:36 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18896.38846.357618.182930@gargle.gargle.HOWL> (sfid-20090330_120238_745752_9652D0F4)
Date: Mon, 30 Mar 2009 15:28:22 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 01/17] ath9k: Remove a few unused flags
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unused HW capability flags and
HW operation variables, and a chainmask flag that
we don't use anywhere.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h |   25 ++++++++---------
 drivers/net/wireless/ath9k/hw.c    |   21 --------------
 drivers/net/wireless/ath9k/hw.h    |   52 ++++++++++++-----------------------
 drivers/net/wireless/ath9k/main.c  |    2 -
 drivers/net/wireless/ath9k/rc.h    |    1 -
 5 files changed, 30 insertions(+), 71 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 10cd96a..954b76d 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -529,19 +529,18 @@ struct ath_rfkill {
 #define SC_OP_BEACONS           BIT(1)
 #define SC_OP_RXAGGR            BIT(2)
 #define SC_OP_TXAGGR            BIT(3)
-#define SC_OP_CHAINMASK_UPDATE  BIT(4)
-#define SC_OP_FULL_RESET        BIT(5)
-#define SC_OP_PREAMBLE_SHORT    BIT(6)
-#define SC_OP_PROTECT_ENABLE    BIT(7)
-#define SC_OP_RXFLUSH           BIT(8)
-#define SC_OP_LED_ASSOCIATED    BIT(9)
-#define SC_OP_RFKILL_REGISTERED BIT(10)
-#define SC_OP_RFKILL_SW_BLOCKED BIT(11)
-#define SC_OP_RFKILL_HW_BLOCKED BIT(12)
-#define SC_OP_WAIT_FOR_BEACON   BIT(13)
-#define SC_OP_LED_ON            BIT(14)
-#define SC_OP_SCANNING          BIT(15)
-#define SC_OP_TSF_RESET         BIT(16)
+#define SC_OP_FULL_RESET        BIT(4)
+#define SC_OP_PREAMBLE_SHORT    BIT(5)
+#define SC_OP_PROTECT_ENABLE    BIT(6)
+#define SC_OP_RXFLUSH           BIT(7)
+#define SC_OP_LED_ASSOCIATED    BIT(8)
+#define SC_OP_RFKILL_REGISTERED BIT(9)
+#define SC_OP_RFKILL_SW_BLOCKED BIT(10)
+#define SC_OP_RFKILL_HW_BLOCKED BIT(11)
+#define SC_OP_WAIT_FOR_BEACON   BIT(12)
+#define SC_OP_LED_ON            BIT(13)
+#define SC_OP_SCANNING          BIT(14)
+#define SC_OP_TSF_RESET         BIT(15)
 
 struct ath_bus_ops {
 	void		(*read_cachesize)(struct ath_softc *sc, int *csz);
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index b15eaf8..13d8c2a 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -363,10 +363,7 @@ static void ath9k_hw_set_defaults(struct ath_hw *ah)
 	ah->config.ack_6mb = 0x0;
 	ah->config.cwm_ignore_extcca = 0;
 	ah->config.pcie_powersave_enable = 0;
-	ah->config.pcie_l1skp_enable = 0;
 	ah->config.pcie_clock_req = 0;
-	ah->config.pcie_power_reset = 0x100;
-	ah->config.pcie_restore = 0;
 	ah->config.pcie_waen = 0;
 	ah->config.analog_shiftreg = 1;
 	ah->config.ht_enable = 1;
@@ -375,13 +372,6 @@ static void ath9k_hw_set_defaults(struct ath_hw *ah)
 	ah->config.cck_trig_high = 200;
 	ah->config.cck_trig_low = 100;
 	ah->config.enable_ani = 1;
-	ah->config.noise_immunity_level = 4;
-	ah->config.ofdm_weaksignal_det = 1;
-	ah->config.cck_weaksignal_thr = 0;
-	ah->config.spur_immunity_level = 2;
-	ah->config.firstep_level = 0;
-	ah->config.rssi_thr_high = 40;
-	ah->config.rssi_thr_low = 7;
 	ah->config.diversity_control = 0;
 	ah->config.antenna_switch_swap = 0;
 
@@ -3343,8 +3333,6 @@ bool ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	pCap->hw_caps |= ATH9K_HW_CAP_MIC_TKIP;
 	pCap->hw_caps |= ATH9K_HW_CAP_MIC_AESCCM;
 
-	pCap->hw_caps |= ATH9K_HW_CAP_CHAN_SPREAD;
-
 	if (ah->config.ht_enable)
 		pCap->hw_caps |= ATH9K_HW_CAP_HT;
 	else
@@ -3368,7 +3356,6 @@ bool ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		pCap->keycache_size = AR_KEYTABLE_SIZE;
 
 	pCap->hw_caps |= ATH9K_HW_CAP_FASTCC;
-	pCap->num_mr_retries = 4;
 	pCap->tx_triglevel_max = MAX_TX_FIFO_THRESHOLD;
 
 	if (AR_SREV_9285_10_OR_LATER(ah))
@@ -3378,14 +3365,6 @@ bool ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	else
 		pCap->num_gpio_pins = AR_NUM_GPIO;
 
-	if (AR_SREV_9280_10_OR_LATER(ah)) {
-		pCap->hw_caps |= ATH9K_HW_CAP_WOW;
-		pCap->hw_caps |= ATH9K_HW_CAP_WOW_MATCHPATTERN_EXACT;
-	} else {
-		pCap->hw_caps &= ~ATH9K_HW_CAP_WOW;
-		pCap->hw_caps &= ~ATH9K_HW_CAP_WOW_MATCHPATTERN_EXACT;
-	}
-
 	if (AR_SREV_9160_10_OR_LATER(ah) || AR_SREV_9100(ah)) {
 		pCap->hw_caps |= ATH9K_HW_CAP_CST;
 		pCap->rts_aggr_limit = ATH_AMPDU_LIMIT_MAX;
diff --git a/drivers/net/wireless/ath9k/hw.h b/drivers/net/wireless/ath9k/hw.h
index 0b594e0..5ba6a4b 100644
--- a/drivers/net/wireless/ath9k/hw.h
+++ b/drivers/net/wireless/ath9k/hw.h
@@ -124,29 +124,24 @@ enum wireless_mode {
 };
 
 enum ath9k_hw_caps {
-	ATH9K_HW_CAP_CHAN_SPREAD		= BIT(0),
-	ATH9K_HW_CAP_MIC_AESCCM                 = BIT(1),
-	ATH9K_HW_CAP_MIC_CKIP                   = BIT(2),
-	ATH9K_HW_CAP_MIC_TKIP                   = BIT(3),
-	ATH9K_HW_CAP_CIPHER_AESCCM              = BIT(4),
-	ATH9K_HW_CAP_CIPHER_CKIP                = BIT(5),
-	ATH9K_HW_CAP_CIPHER_TKIP                = BIT(6),
-	ATH9K_HW_CAP_VEOL                       = BIT(7),
-	ATH9K_HW_CAP_BSSIDMASK                  = BIT(8),
-	ATH9K_HW_CAP_MCAST_KEYSEARCH            = BIT(9),
-	ATH9K_HW_CAP_CHAN_HALFRATE              = BIT(10),
-	ATH9K_HW_CAP_CHAN_QUARTERRATE           = BIT(11),
-	ATH9K_HW_CAP_HT                         = BIT(12),
-	ATH9K_HW_CAP_GTT                        = BIT(13),
-	ATH9K_HW_CAP_FASTCC                     = BIT(14),
-	ATH9K_HW_CAP_RFSILENT                   = BIT(15),
-	ATH9K_HW_CAP_WOW                        = BIT(16),
-	ATH9K_HW_CAP_CST                        = BIT(17),
-	ATH9K_HW_CAP_ENHANCEDPM                 = BIT(18),
-	ATH9K_HW_CAP_AUTOSLEEP                  = BIT(19),
-	ATH9K_HW_CAP_4KB_SPLITTRANS             = BIT(20),
-	ATH9K_HW_CAP_WOW_MATCHPATTERN_EXACT     = BIT(21),
-	ATH9K_HW_CAP_BT_COEX			= BIT(22)
+	ATH9K_HW_CAP_MIC_AESCCM                 = BIT(0),
+	ATH9K_HW_CAP_MIC_CKIP                   = BIT(1),
+	ATH9K_HW_CAP_MIC_TKIP                   = BIT(2),
+	ATH9K_HW_CAP_CIPHER_AESCCM              = BIT(3),
+	ATH9K_HW_CAP_CIPHER_CKIP                = BIT(4),
+	ATH9K_HW_CAP_CIPHER_TKIP                = BIT(5),
+	ATH9K_HW_CAP_VEOL                       = BIT(6),
+	ATH9K_HW_CAP_BSSIDMASK                  = BIT(7),
+	ATH9K_HW_CAP_MCAST_KEYSEARCH            = BIT(8),
+	ATH9K_HW_CAP_HT                         = BIT(9),
+	ATH9K_HW_CAP_GTT                        = BIT(10),
+	ATH9K_HW_CAP_FASTCC                     = BIT(11),
+	ATH9K_HW_CAP_RFSILENT                   = BIT(12),
+	ATH9K_HW_CAP_CST                        = BIT(13),
+	ATH9K_HW_CAP_ENHANCEDPM                 = BIT(14),
+	ATH9K_HW_CAP_AUTOSLEEP                  = BIT(15),
+	ATH9K_HW_CAP_4KB_SPLITTRANS             = BIT(16),
+	ATH9K_HW_CAP_BT_COEX			= BIT(17)
 };
 
 enum ath9k_capability_type {
@@ -166,7 +161,6 @@ struct ath9k_hw_capabilities {
 	u16 keycache_size;
 	u16 low_5ghz_chan, high_5ghz_chan;
 	u16 low_2ghz_chan, high_2ghz_chan;
-	u16 num_mr_retries;
 	u16 rts_aggr_limit;
 	u8 tx_chainmask;
 	u8 rx_chainmask;
@@ -184,11 +178,8 @@ struct ath9k_ops_config {
 	int ack_6mb;
 	int cwm_ignore_extcca;
 	u8 pcie_powersave_enable;
-	u8 pcie_l1skp_enable;
 	u8 pcie_clock_req;
 	u32 pcie_waen;
-	int pcie_power_reset;
-	u8 pcie_restore;
 	u8 analog_shiftreg;
 	u8 ht_enable;
 	u32 ofdm_trig_low;
@@ -196,13 +187,6 @@ struct ath9k_ops_config {
 	u32 cck_trig_high;
 	u32 cck_trig_low;
 	u32 enable_ani;
-	u8 noise_immunity_level;
-	u32 ofdm_weaksignal_det;
-	u32 cck_weaksignal_thr;
-	u8 spur_immunity_level;
-	u8 firstep_level;
-	int8_t rssi_thr_high;
-	int8_t rssi_thr_low;
 	u16 diversity_control;
 	u16 antenna_switch_swap;
 	int serialize_regmode;
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 2aaa378..1648a4b 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -287,7 +287,6 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 	}
 	spin_unlock_bh(&sc->sc_resetlock);
 
-	sc->sc_flags &= ~SC_OP_CHAINMASK_UPDATE;
 	sc->sc_flags &= ~SC_OP_FULL_RESET;
 
 	if (ath_startrecv(sc) != 0) {
@@ -416,7 +415,6 @@ set_timer:
  */
 void ath_update_chainmask(struct ath_softc *sc, int is_ht)
 {
-	sc->sc_flags |= SC_OP_CHAINMASK_UPDATE;
 	if (is_ht ||
 	    (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_BT_COEX)) {
 		sc->tx_chainmask = sc->sc_ah->caps.tx_chainmask;
diff --git a/drivers/net/wireless/ath9k/rc.h b/drivers/net/wireless/ath9k/rc.h
index 199a3ce..ec72dd2 100644
--- a/drivers/net/wireless/ath9k/rc.h
+++ b/drivers/net/wireless/ath9k/rc.h
@@ -24,7 +24,6 @@ struct ath_softc;
 #define ATH_RATE_MAX     30
 #define RATE_TABLE_SIZE  64
 #define MAX_TX_RATE_PHY  48
-#define WLAN_CTRL_FRAME_SIZE (2+2+6+4)
 
 /* VALID_ALL - valid for 20/40/Legacy,
  * VALID - Legacy only,
-- 
1.6.2.1

