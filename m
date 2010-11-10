Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:25304 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755784Ab0KJMYO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 07:24:14 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 04:24:02 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linux-wireless@vger.kernel.org>
Subject: [RFC 4/5] ath9k: Add support for Tx beamforming feature.
Date: Wed, 10 Nov 2010 17:53:48 +0530
Message-ID: <1289391829-8577-4-git-send-email-vnatarajan@atheros.com>
In-Reply-To: <1289391829-8577-3-git-send-email-vnatarajan@atheros.com>
References: <1289391829-8577-1-git-send-email-vnatarajan@atheros.com>
 <1289391829-8577-2-git-send-email-vnatarajan@atheros.com>
 <1289391829-8577-3-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Beamforming is enabled with the latest hardware if the module parameter
is set.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 +
 drivers/net/wireless/ath/ath9k/init.c  |    9 +
 drivers/net/wireless/ath/ath9k/main.c  |   22 ++
 drivers/net/wireless/ath/ath9k/rc.c    |  453 ++++++++++++++++++++------------
 drivers/net/wireless/ath/ath9k/rc.h    |   90 +++++++-
 drivers/net/wireless/ath/ath9k/xmit.c  |   43 +++-
 6 files changed, 454 insertions(+), 165 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 8a2b04e..5216999 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -270,6 +270,8 @@ struct ath_node {
 	struct ath_atx_ac ac[WME_NUM_AC];
 	u16 maxampdu;
 	u8 mpdudensity;
+	bool txbf;
+	u8 key_idx;
 };
 
 #define AGGR_CLEANUP         BIT(1)
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index f14fe53..531efe7 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -38,6 +38,10 @@ int led_blink;
 module_param_named(blink, led_blink, int, 0444);
 MODULE_PARM_DESC(blink, "Enable LED blink on activity");
 
+int txbf;
+module_param_named(txbf, txbf, int, 0444);
+MODULE_PARM_DESC(blink, "Enable TxBF");
+
 /* We use the hw_value as an index into our private channel structure */
 
 #define CHAN2G(_freq, _idx)  { \
@@ -239,6 +243,11 @@ static void setup_ht_cap(struct ath_softc *sc,
 		ht_info->mcs.rx_mask[i] = 0xff;
 
 	ht_info->mcs.tx_params |= IEEE80211_HT_MCS_TX_DEFINED;
+
+	if (txbf && AR_SREV_9300_20_OR_LATER(ah)) {
+		ar9003_fill_txbf_capabilities(sc->sc_ah);
+		ht_info->txbf = ar9003_get_txbf_capabilities(sc->sc_ah);
+	}
 }
 
 static int ath9k_reg_notifier(struct wiphy *wiphy,
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 4b93a72..bea2568 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -553,8 +553,10 @@ void ath_update_chainmask(struct ath_softc *sc, int is_ht)
 static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta)
 {
 	struct ath_node *an;
+	struct ieee80211_sta_ht_cap *ht_cap;
 
 	an = (struct ath_node *)sta->drv_priv;
+	ht_cap = &sta->ht_cap;
 
 	if (sc->sc_flags & SC_OP_TXAGGR) {
 		ath_tx_node_init(sc, an);
@@ -562,6 +564,15 @@ static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta)
 				     sta->ht_cap.ampdu_factor);
 		an->mpdudensity = parse_mpdudensity(sta->ht_cap.ampdu_density);
 	}
+
+	if (ht_cap->explicit_compbf ||
+	    ht_cap->explicit_noncompbf ||
+	    ht_cap->implicit_bf) {
+		an->txbf = true;
+		an->key_idx = ath_txbf_key_config(ath9k_hw_common(sc->sc_ah),
+						  sta);
+		set_bit(an->key_idx, ath9k_hw_common(sc->sc_ah)->keymap);
+	}
 }
 
 static void ath_node_detach(struct ath_softc *sc, struct ieee80211_sta *sta)
@@ -1858,6 +1869,7 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_node *an = (struct ath_node *)sta->drv_priv;
 	int ret = 0;
 
 	if (modparam_nohwcrypt)
@@ -1869,6 +1881,16 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 
 	switch (cmd) {
 	case SET_KEY:
+		if (sta && sta->txbf &&
+		    (key->flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
+			if (key->cipher == WLAN_CIPHER_SUITE_CCMP)
+				key->keyidx = an->key_idx;
+			else {
+				ath_hw_keyreset(common, an->key_idx);
+				clear_bit(an->key_idx, common->keymap);
+			}
+		}
+
 		ret = ath_key_config(common, vif, sta, key);
 		if (ret >= 0) {
 			key->hw_key_idx = ret;
diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 85c8e93..0b9c405 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -23,141 +23,141 @@ static const struct ath_rate_table ar5416_11na_ratetable = {
 	68,
 	8, /* MCS start */
 	{
-		[0] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 6000,
+		[0] = { RC_L_SDT, FALSE, WLAN_RC_PHY_OFDM, 6000,
 			5400, 0, 12, 0, 0, 0, 0 }, /* 6 Mb */
-		[1] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 9000,
+		[1] = { RC_L_SDT, FALSE, WLAN_RC_PHY_OFDM, 9000,
 			7800,  1, 18, 0, 1, 1, 1 }, /* 9 Mb */
-		[2] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 12000,
+		[2] = { RC_L_SDT, FALSE, WLAN_RC_PHY_OFDM, 12000,
 			10000, 2, 24, 2, 2, 2, 2 }, /* 12 Mb */
-		[3] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 18000,
+		[3] = { RC_L_SDT, FALSE, WLAN_RC_PHY_OFDM, 18000,
 			13900, 3, 36, 2, 3, 3, 3 }, /* 18 Mb */
-		[4] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 24000,
+		[4] = { RC_L_SDT, FALSE, WLAN_RC_PHY_OFDM, 24000,
 			17300, 4, 48, 4, 4, 4, 4 }, /* 24 Mb */
-		[5] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 36000,
+		[5] = { RC_L_SDT, FALSE, WLAN_RC_PHY_OFDM, 36000,
 			23000, 5, 72, 4, 5, 5, 5 }, /* 36 Mb */
-		[6] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 48000,
+		[6] = { RC_L_SDT, FALSE, WLAN_RC_PHY_OFDM, 48000,
 			27400, 6, 96, 4, 6, 6, 6 }, /* 48 Mb */
-		[7] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 54000,
+		[7] = { RC_L_SDT, FALSE, WLAN_RC_PHY_OFDM, 54000,
 			29300, 7, 108, 4, 7, 7, 7 }, /* 54 Mb */
-		[8] = { RC_HT_SDT_2040, WLAN_RC_PHY_HT_20_SS, 6500,
+		[8] = { RC_HT_SDT_2040, TRUE_N_1_2_ALL, WLAN_RC_PHY_HT_20_SS, 6500,
 			6400, 0, 0, 0, 38, 8, 38 }, /* 6.5 Mb */
-		[9] = { RC_HT_SDT_20, WLAN_RC_PHY_HT_20_SS, 13000,
+		[9] = { RC_HT_SDT_20, TRUE_N_1_2_ALL, WLAN_RC_PHY_HT_20_SS, 13000,
 			12700, 1, 1, 2, 39, 9, 39 }, /* 13 Mb */
-		[10] = { RC_HT_SDT_20, WLAN_RC_PHY_HT_20_SS, 19500,
+		[10] = { RC_HT_SDT_20, TRUE_N_1_2_ALL, WLAN_RC_PHY_HT_20_SS, 19500,
 			18800, 2, 2, 2, 40, 10, 40 }, /* 19.5 Mb */
-		[11] = { RC_HT_SD_20, WLAN_RC_PHY_HT_20_SS, 26000,
+		[11] = { RC_HT_SD_20, TRUE_N_1_2_ALL, WLAN_RC_PHY_HT_20_SS, 26000,
 			25000, 3, 3, 4, 41, 11, 41 }, /* 26 Mb */
-		[12] = { RC_HT_SD_20, WLAN_RC_PHY_HT_20_SS, 39000,
+		[12] = { RC_HT_SD_20, TRUE_N2_T_N1_T_S, WLAN_RC_PHY_HT_20_SS, 39000,
 			36700, 4, 4, 4, 42, 12, 42 }, /* 39 Mb */
-		[13] = { RC_HT_S_20, WLAN_RC_PHY_HT_20_SS, 52000,
+		[13] = { RC_HT_S_20, TRUE_N2_F_N1_S, WLAN_RC_PHY_HT_20_SS, 52000,
 			48100, 5, 5, 4, 43, 13, 43 }, /* 52 Mb */
-		[14] = { RC_HT_S_20, WLAN_RC_PHY_HT_20_SS, 58500,
+		[14] = { RC_HT_S_20, TRUE_N2_T_N1_S, WLAN_RC_PHY_HT_20_SS, 58500,
 			53500, 6, 6, 4, 44, 14, 44 }, /* 58.5 Mb */
-		[15] = { RC_HT_S_20, WLAN_RC_PHY_HT_20_SS, 65000,
+		[15] = { RC_HT_S_20, TRUE_N2_F_N1_S, WLAN_RC_PHY_HT_20_SS, 65000,
 			59000, 7, 7, 4, 45, 16, 46 }, /* 65 Mb */
-		[16] = { RC_HT_S_20, WLAN_RC_PHY_HT_20_SS_HGI, 72200,
+		[16] = { RC_HT_S_20, TRUE_N2_F_N1_S, WLAN_RC_PHY_HT_20_SS_HGI, 72200,
 			65400, 7, 7, 4, 45, 16, 46 }, /* 75 Mb */
-		[17] = { RC_INVALID, WLAN_RC_PHY_HT_20_DS, 13000,
+		[17] = { RC_INVALID, FALSE, WLAN_RC_PHY_HT_20_DS, 13000,
 			12700, 8, 8, 0, 47, 17, 47 }, /* 13 Mb */
-		[18] = { RC_HT_T_20, WLAN_RC_PHY_HT_20_DS, 26000,
+		[18] = { RC_HT_T_20, FALSE, WLAN_RC_PHY_HT_20_DS, 26000,
 			24800, 9, 9, 2, 48, 18, 48 }, /* 26 Mb */
-		[19] = { RC_HT_T_20, WLAN_RC_PHY_HT_20_DS, 39000,
+		[19] = { RC_HT_T_20, TRUE_N2_D_N1_D, WLAN_RC_PHY_HT_20_DS, 39000,
 			36600, 10, 10, 2, 49, 19, 49 }, /* 39 Mb */
-		[20] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 52000,
+		[20] = { RC_HT_DT_20, TRUE_N2_ALL_N1_T_D, WLAN_RC_PHY_HT_20_DS, 52000,
 			48100, 11, 11, 4, 50, 20, 50 }, /* 52 Mb */
-		[21] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 78000,
+		[21] = { RC_HT_DT_20, TRUE_N2_ALL_N1_T_D, WLAN_RC_PHY_HT_20_DS, 78000,
 			69500, 12, 12, 4, 51, 21, 51 }, /* 78 Mb */
-		[22] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 104000,
+		[22] = { RC_HT_DT_20, TRUE_N2_ALL_N1_T_D, WLAN_RC_PHY_HT_20_DS, 104000,
 			89500, 13, 13, 4, 52, 22, 52 }, /* 104 Mb */
-		[23] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 117000,
+		[23] = { RC_HT_DT_20, TRUE_N2_ALL_N1_T_D, WLAN_RC_PHY_HT_20_DS, 117000,
 			98900, 14, 14, 4, 53, 23, 53 }, /* 117 Mb */
-		[24] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 130000,
+		[24] = { RC_HT_DT_20, TRUE_N2_ALL_N1_T, WLAN_RC_PHY_HT_20_DS, 130000,
 			108300, 15, 15, 4, 54, 25, 55 }, /* 130 Mb */
-		[25] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS_HGI, 144400,
+		[25] = { RC_HT_DT_20, TRUE_N2_ALL_N1_T_D, WLAN_RC_PHY_HT_20_DS_HGI, 144400,
 			120000, 15, 15, 4, 54, 25, 55 }, /* 144.4 Mb */
-		[26] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 19500,
+		[26] = {  RC_INVALID, FALSE, WLAN_RC_PHY_HT_20_TS, 19500,
 			17400, 16, 16, 0, 56, 26, 56 }, /* 19.5 Mb */
-		[27] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 39000,
+		[27] = {  RC_INVALID, FALSE, WLAN_RC_PHY_HT_20_TS, 39000,
 			35100, 17, 17, 2, 57, 27, 57 }, /* 39 Mb */
-		[28] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 58500,
+		[28] = {  RC_INVALID, FALSE, WLAN_RC_PHY_HT_20_TS, 58500,
 			52600, 18, 18, 2, 58, 28, 58 }, /* 58.5 Mb */
-		[29] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 78000,
+		[29] = {  RC_INVALID, FALSE, WLAN_RC_PHY_HT_20_TS, 78000,
 			70400, 19, 19, 4, 59, 29, 59 }, /* 78 Mb */
-		[30] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 117000,
+		[30] = {  RC_INVALID, FALSE, WLAN_RC_PHY_HT_20_TS, 117000,
 			104900, 20, 20, 4, 60, 31, 61 }, /* 117 Mb */
-		[31] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS_HGI, 130000,
+		[31] = {  RC_INVALID, FALSE, WLAN_RC_PHY_HT_20_TS_HGI, 130000,
 			115800, 20, 20, 4, 60, 31, 61 }, /* 130 Mb*/
-		[32] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS, 156000,
+		[32] = {  RC_HT_T_20, FALSE, WLAN_RC_PHY_HT_20_TS, 156000,
 			137200, 21, 21, 4, 62, 33, 63 }, /* 156 Mb */
-		[33] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS_HGI, 173300,
+		[33] = {  RC_HT_T_20, TRUE_N2_T_N1_T, WLAN_RC_PHY_HT_20_TS_HGI, 173300,
 			151100, 21, 21, 4, 62, 33, 63 }, /* 173.3 Mb */
-		[34] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS, 175500,
+		[34] = {  RC_HT_T_20, FALSE, WLAN_RC_PHY_HT_20_TS, 175500,
 			152800, 22, 22, 4, 64, 35, 65 }, /* 175.5 Mb */
-		[35] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS_HGI, 195000,
+		[35] = {  RC_HT_T_20, TRUE_N2_T_N1_T, WLAN_RC_PHY_HT_20_TS_HGI, 195000,
 			168400, 22, 22, 4, 64, 35, 65 }, /* 195 Mb*/
-		[36] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS, 195000,
+		[36] = {  RC_HT_T_20, FALSE, WLAN_RC_PHY_HT_20_TS, 195000,
 			168400, 23, 23, 4, 66, 37, 67 }, /* 195 Mb */
-		[37] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS_HGI, 216700,
+		[37] = {  RC_HT_T_20, TRUE_N2_T_N1_T, WLAN_RC_PHY_HT_20_TS_HGI, 216700,
 			185000, 23, 23, 4, 66, 37, 67 }, /* 216.7 Mb */
-		[38] = { RC_HT_SDT_40, WLAN_RC_PHY_HT_40_SS, 13500,
+		[38] = { RC_HT_SDT_40, TRUE_N_1_2_ALL, WLAN_RC_PHY_HT_40_SS, 13500,
 			13200, 0, 0, 0, 38, 38, 38 }, /* 13.5 Mb*/
-		[39] = { RC_HT_SDT_40, WLAN_RC_PHY_HT_40_SS, 27500,
+		[39] = { RC_HT_SDT_40, TRUE_N_1_2_ALL, WLAN_RC_PHY_HT_40_SS, 27500,
 			25900, 1, 1, 2, 39, 39, 39 }, /* 27.0 Mb*/
-		[40] = { RC_HT_SDT_40, WLAN_RC_PHY_HT_40_SS, 40500,
+		[40] = { RC_HT_SDT_40, TRUE_N_1_2_ALL, WLAN_RC_PHY_HT_40_SS, 40500,
 			38600, 2, 2, 2, 40, 40, 40 }, /* 40.5 Mb*/
-		[41] = { RC_HT_SD_40, WLAN_RC_PHY_HT_40_SS, 54000,
+		[41] = { RC_HT_SD_40, TRUE_N_1_2_ALL, WLAN_RC_PHY_HT_40_SS, 54000,
 			49800, 3, 3, 4, 41, 41, 41 }, /* 54 Mb */
-		[42] = { RC_HT_SD_40, WLAN_RC_PHY_HT_40_SS, 81500,
+		[42] = { RC_HT_SD_40, TRUE_N2_T_N1_T_S, WLAN_RC_PHY_HT_40_SS, 81500,
 			72200, 4, 4, 4, 42, 42, 42 }, /* 81 Mb */
-		[43] = { RC_HT_S_40, WLAN_RC_PHY_HT_40_SS, 108000,
+		[43] = { RC_HT_S_40, TRUE_N2_F_N1_S, WLAN_RC_PHY_HT_40_SS, 108000,
 			92900, 5, 5, 4, 43, 43, 43 }, /* 108 Mb */
-		[44] = { RC_HT_S_40, WLAN_RC_PHY_HT_40_SS, 121500,
+		[44] = { RC_HT_S_40, TRUE_N2_T_N1_S, WLAN_RC_PHY_HT_40_SS, 121500,
 			102700, 6, 6, 4, 44, 44, 44 }, /* 121.5 Mb*/
-		[45] = { RC_HT_S_40, WLAN_RC_PHY_HT_40_SS, 135000,
+		[45] = { RC_HT_S_40, TRUE_N2_F_N1_S, WLAN_RC_PHY_HT_40_SS, 135000,
 			112000, 7, 7, 4, 45, 46, 46 }, /* 135 Mb */
-		[46] = { RC_HT_S_40, WLAN_RC_PHY_HT_40_SS_HGI, 150000,
+		[46] = { RC_HT_S_40, TRUE_N2_F_N1_S, WLAN_RC_PHY_HT_40_SS_HGI, 150000,
 			122000, 7, 7, 4, 45, 46, 46 }, /* 150 Mb */
-		[47] = { RC_INVALID, WLAN_RC_PHY_HT_40_DS, 27000,
+		[47] = { RC_INVALID, FALSE, WLAN_RC_PHY_HT_40_DS, 27000,
 			25800, 8, 8, 0, 47, 47, 47 }, /* 27 Mb */
-		[48] = { RC_HT_T_40, WLAN_RC_PHY_HT_40_DS, 54000,
+		[48] = { RC_HT_T_40, FALSE, WLAN_RC_PHY_HT_40_DS, 54000,
 			49800, 9, 9, 2, 48, 48, 48 }, /* 54 Mb */
-		[49] = { RC_HT_T_40, WLAN_RC_PHY_HT_40_DS, 81000,
+		[49] = { RC_HT_T_40, TRUE_N2_D_N1_D, WLAN_RC_PHY_HT_40_DS, 81000,
 			71900, 10, 10, 2, 49, 49, 49 }, /* 81 Mb */
-		[50] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 108000,
+		[50] = { RC_HT_DT_40, TRUE_N2_ALL_N1_T_D, WLAN_RC_PHY_HT_40_DS, 108000,
 			92500, 11, 11, 4, 50, 50, 50 }, /* 108 Mb */
-		[51] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 162000,
+		[51] = { RC_HT_DT_40, TRUE_N2_ALL_N1_T_D, WLAN_RC_PHY_HT_40_DS, 162000,
 			130300, 12, 12, 4, 51, 51, 51 }, /* 162 Mb */
-		[52] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 216000,
+		[52] = { RC_HT_DT_40, TRUE_N2_ALL_N1_T_D, WLAN_RC_PHY_HT_40_DS, 216000,
 			162800, 13, 13, 4, 52, 52, 52 }, /* 216 Mb */
-		[53] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 243000,
+		[53] = { RC_HT_DT_40, TRUE_N2_ALL_N1_T_D, WLAN_RC_PHY_HT_40_DS, 243000,
 			178200, 14, 14, 4, 53, 53, 53 }, /* 243 Mb */
-		[54] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 270000,
+		[54] = { RC_HT_DT_40, TRUE_N2_ALL_N1_T, WLAN_RC_PHY_HT_40_DS, 270000,
 			192100, 15, 15, 4, 54, 55, 55 }, /* 270 Mb */
-		[55] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS_HGI, 300000,
+		[55] = { RC_HT_DT_40, TRUE_N2_ALL_N1_T_D, WLAN_RC_PHY_HT_40_DS_HGI, 300000,
 			207000, 15, 15, 4, 54, 55, 55 }, /* 300 Mb */
-		[56] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 40500,
+		[56] = {  RC_INVALID, FALSE, WLAN_RC_PHY_HT_40_TS, 40500,
 			36100, 16, 16, 0, 56, 56, 56 }, /* 40.5 Mb */
-		[57] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 81000,
+		[57] = {  RC_INVALID, FALSE, WLAN_RC_PHY_HT_40_TS, 81000,
 			72900, 17, 17, 2, 57, 57, 57 }, /* 81 Mb */
-		[58] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 121500,
+		[58] = {  RC_INVALID, FALSE, WLAN_RC_PHY_HT_40_TS, 121500,
 			108300, 18, 18, 2, 58, 58, 58 }, /* 121.5 Mb */
-		[59] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 162000,
+		[59] = {  RC_INVALID, FALSE, WLAN_RC_PHY_HT_40_TS, 162000,
 			142000, 19, 19, 4, 59, 59, 59 }, /*  162 Mb */
-		[60] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 243000,
+		[60] = {  RC_INVALID, FALSE, WLAN_RC_PHY_HT_40_TS, 243000,
 			205100, 20, 20, 4, 60, 61, 61 }, /*  243 Mb */
-		[61] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS_HGI, 270000,
+		[61] = {  RC_INVALID, FALSE, WLAN_RC_PHY_HT_40_TS_HGI, 270000,
 			224700, 20, 20, 4, 60, 61, 61 }, /*  270 Mb */
-		[62] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS, 324000,
+		[62] = {  RC_HT_T_40, FALSE, WLAN_RC_PHY_HT_40_TS, 324000,
 			263100, 21, 21, 4, 62, 63, 63 }, /*  324 Mb */
-		[63] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS_HGI, 360000,
+		[63] = {  RC_HT_T_40, TRUE_N2_T_N1_T, WLAN_RC_PHY_HT_40_TS_HGI, 360000,
 			288000, 21, 21, 4, 62, 63, 63 }, /*  360 Mb */
-		[64] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS, 364500,
+		[64] = {  RC_HT_T_40, FALSE, WLAN_RC_PHY_HT_40_TS, 364500,
 			290700, 22, 22, 4, 64, 65, 65 }, /* 364.5 Mb */
-		[65] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS_HGI, 405000,
+		[65] = {  RC_HT_T_40, TRUE_N2_T_N1_T, WLAN_RC_PHY_HT_40_TS_HGI, 405000,
 			317200, 22, 22, 4, 64, 65, 65 }, /* 405 Mb */
-		[66] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS, 405000,
+		[66] = {  RC_HT_T_40, FALSE, WLAN_RC_PHY_HT_40_TS, 405000,
 			317200, 23, 23, 4, 66, 67, 67 }, /* 405 Mb */
-		[67] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS_HGI, 450000,
+		[67] = {  RC_HT_T_40, TRUE_N2_T_N1_T, WLAN_RC_PHY_HT_40_TS_HGI, 450000,
 			346400, 23, 23, 4, 66, 67, 67 }, /* 450 Mb */
 	},
 	50,  /* probe interval */
@@ -171,149 +171,149 @@ static const struct ath_rate_table ar5416_11ng_ratetable = {
 	72,
 	12, /* MCS start */
 	{
-		[0] = { RC_ALL, WLAN_RC_PHY_CCK, 1000,
+		[0] = { RC_ALL, FALSE, WLAN_RC_PHY_CCK, 1000,
 			900, 0, 2, 0, 0, 0, 0 }, /* 1 Mb */
-		[1] = { RC_ALL, WLAN_RC_PHY_CCK, 2000,
+		[1] = { RC_ALL, FALSE, WLAN_RC_PHY_CCK, 2000,
 			1900, 1, 4, 1, 1, 1, 1 }, /* 2 Mb */
-		[2] = { RC_ALL, WLAN_RC_PHY_CCK, 5500,
+		[2] = { RC_ALL, FALSE, WLAN_RC_PHY_CCK, 5500,
 			4900, 2, 11, 2, 2, 2, 2 }, /* 5.5 Mb */
-		[3] = { RC_ALL, WLAN_RC_PHY_CCK, 11000,
+		[3] = { RC_ALL, FALSE, WLAN_RC_PHY_CCK, 11000,
 			8100, 3, 22, 3, 3, 3, 3 }, /* 11 Mb */
-		[4] = { RC_INVALID, WLAN_RC_PHY_OFDM, 6000,
+		[4] = { RC_INVALID, FALSE, WLAN_RC_PHY_OFDM, 6000,
 			5400, 4, 12, 4, 4, 4, 4 }, /* 6 Mb */
-		[5] = { RC_INVALID, WLAN_RC_PHY_OFDM, 9000,
+		[5] = { RC_INVALID, FALSE, WLAN_RC_PHY_OFDM, 9000,
 			7800, 5, 18, 4, 5, 5, 5 }, /* 9 Mb */
-		[6] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 12000,
+		[6] = { RC_L_SDT, FALSE, WLAN_RC_PHY_OFDM, 12000,
 			10100, 6, 24, 6, 6, 6, 6 }, /* 12 Mb */
-		[7] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 18000,
+		[7] = { RC_L_SDT, FALSE, WLAN_RC_PHY_OFDM, 18000,
 			14100, 7, 36, 6, 7, 7, 7 }, /* 18 Mb */
-		[8] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 24000,
+		[8] = { RC_L_SDT, FALSE, WLAN_RC_PHY_OFDM, 24000,
 			17700, 8, 48, 8, 8, 8, 8 }, /* 24 Mb */
-		[9] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 36000,
+		[9] = { RC_L_SDT, FALSE, WLAN_RC_PHY_OFDM, 36000,
 			23700, 9, 72, 8, 9, 9, 9 }, /* 36 Mb */
-		[10] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 48000,
+		[10] = { RC_L_SDT, FALSE, WLAN_RC_PHY_OFDM, 48000,
 			27400, 10, 96, 8, 10, 10, 10 }, /* 48 Mb */
-		[11] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 54000,
+		[11] = { RC_L_SDT, FALSE, WLAN_RC_PHY_OFDM, 54000,
 			30900, 11, 108, 8, 11, 11, 11 }, /* 54 Mb */
-		[12] = { RC_INVALID, WLAN_RC_PHY_HT_20_SS, 6500,
+		[12] = { RC_INVALID, TRUE_N_1_2_ALL, WLAN_RC_PHY_HT_20_SS, 6500,
 			6400, 0, 0, 4, 42, 12, 42 }, /* 6.5 Mb */
-		[13] = { RC_HT_SDT_20, WLAN_RC_PHY_HT_20_SS, 13000,
+		[13] = { RC_HT_SDT_20, TRUE_N_1_2_ALL, WLAN_RC_PHY_HT_20_SS, 13000,
 			12700, 1, 1, 6, 43, 13, 43 }, /* 13 Mb */
-		[14] = { RC_HT_SDT_20, WLAN_RC_PHY_HT_20_SS, 19500,
+		[14] = { RC_HT_SDT_20, TRUE_N_1_2_ALL, WLAN_RC_PHY_HT_20_SS, 19500,
 			18800, 2, 2, 6, 44, 14, 44 }, /* 19.5 Mb*/
-		[15] = { RC_HT_SD_20, WLAN_RC_PHY_HT_20_SS, 26000,
+		[15] = { RC_HT_SD_20, TRUE_N_1_2_ALL, WLAN_RC_PHY_HT_20_SS, 26000,
 			25000, 3, 3, 8, 45, 15, 45 }, /* 26 Mb */
-		[16] = { RC_HT_SD_20, WLAN_RC_PHY_HT_20_SS, 39000,
+		[16] = { RC_HT_SD_20, TRUE_N2_T_N1_ALL, WLAN_RC_PHY_HT_20_SS, 39000,
 			36700, 4, 4, 8, 46, 16, 46 }, /* 39 Mb */
-		[17] = { RC_HT_S_20, WLAN_RC_PHY_HT_20_SS, 52000,
+		[17] = { RC_HT_S_20, TRUE_N2_F_N1_D_S, WLAN_RC_PHY_HT_20_SS, 52000,
 			48100, 5, 5, 8, 47, 17, 47 }, /* 52 Mb */
-		[18] = { RC_HT_S_20, WLAN_RC_PHY_HT_20_SS, 58500,
+		[18] = { RC_HT_S_20, TRUE_N2_T_N1_S, WLAN_RC_PHY_HT_20_SS, 58500,
 			53500, 6, 6, 8, 48, 18, 48 }, /* 58.5 Mb */
-		[19] = { RC_HT_S_20, WLAN_RC_PHY_HT_20_SS, 65000,
+		[19] = { RC_HT_S_20, TRUE_N2_F_N1_S, WLAN_RC_PHY_HT_20_SS, 65000,
 			59000, 7, 7, 8, 49, 20, 50 }, /* 65 Mb */
-		[20] = { RC_HT_S_20, WLAN_RC_PHY_HT_20_SS_HGI, 72200,
+		[20] = { RC_HT_S_20, TRUE_N2_F_N1_S, WLAN_RC_PHY_HT_20_SS_HGI, 72200,
 			65400, 7, 7, 8, 49, 20, 50 }, /* 65 Mb*/
-		[21] = { RC_INVALID, WLAN_RC_PHY_HT_20_DS, 13000,
+		[21] = { RC_INVALID, FALSE, WLAN_RC_PHY_HT_20_DS, 13000,
 			12700, 8, 8, 4, 51, 21, 51 }, /* 13 Mb */
-		[22] = { RC_HT_T_20, WLAN_RC_PHY_HT_20_DS, 26000,
+		[22] = { RC_HT_T_20, FALSE, WLAN_RC_PHY_HT_20_DS, 26000,
 			24800, 9, 9, 6, 52, 22, 52 }, /* 26 Mb */
-		[23] = { RC_HT_T_20, WLAN_RC_PHY_HT_20_DS, 39000,
+		[23] = { RC_HT_T_20, TRUE_N2_D_N1_F, WLAN_RC_PHY_HT_20_DS, 39000,
 			36600, 10, 10, 6, 53, 23, 53 }, /* 39 Mb */
-		[24] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 52000,
+		[24] = { RC_HT_DT_20, TRUE_N2_ALL_N1_T, WLAN_RC_PHY_HT_20_DS, 52000,
 			48100, 11, 11, 8, 54, 24, 54 }, /* 52 Mb */
-		[25] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 78000,
+		[25] = { RC_HT_DT_20, TRUE_N2_ALL_N1_T_D, WLAN_RC_PHY_HT_20_DS, 78000,
 			69500, 12, 12, 8, 55, 25, 55 }, /* 78 Mb */
-		[26] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 104000,
+		[26] = { RC_HT_DT_20, TRUE_N2_ALL_N1_T_D, WLAN_RC_PHY_HT_20_DS, 104000,
 			89500, 13, 13, 8, 56, 26, 56 }, /* 104 Mb */
-		[27] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 117000,
+		[27] = { RC_HT_DT_20, TRUE_N2_ALL_N1_T_D, WLAN_RC_PHY_HT_20_DS, 117000,
 			98900, 14, 14, 8, 57, 27, 57 }, /* 117 Mb */
-		[28] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 130000,
+		[28] = { RC_HT_DT_20, TRUE_N2_ALL_N1_T, WLAN_RC_PHY_HT_20_DS, 130000,
 			108300, 15, 15, 8, 58, 29, 59 }, /* 130 Mb */
-		[29] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS_HGI, 144400,
+		[29] = { RC_HT_DT_20, TRUE_N2_ALL_N1_T_D, WLAN_RC_PHY_HT_20_DS_HGI, 144400,
 			120000, 15, 15, 8, 58, 29, 59 }, /* 144.4 Mb */
-		[30] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 19500,
+		[30] = {  RC_INVALID, FALSE, WLAN_RC_PHY_HT_20_TS, 19500,
 			17400, 16, 16, 4, 60, 30, 60 }, /* 19.5 Mb */
-		[31] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 39000,
+		[31] = {  RC_INVALID, FALSE, WLAN_RC_PHY_HT_20_TS, 39000,
 			35100, 17, 17, 6, 61, 31, 61 }, /* 39 Mb */
-		[32] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 58500,
+		[32] = {  RC_INVALID, FALSE, WLAN_RC_PHY_HT_20_TS, 58500,
 			52600, 18, 18, 6, 62, 32, 62 }, /* 58.5 Mb */
-		[33] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 78000,
+		[33] = {  RC_INVALID, FALSE, WLAN_RC_PHY_HT_20_TS, 78000,
 			70400, 19, 19, 8, 63, 33, 63 }, /* 78 Mb */
-		[34] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 117000,
+		[34] = {  RC_INVALID, FALSE, WLAN_RC_PHY_HT_20_TS, 117000,
 			104900, 20, 20, 8, 64, 35, 65 }, /* 117 Mb */
-		[35] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS_HGI, 130000,
+		[35] = {  RC_INVALID, FALSE, WLAN_RC_PHY_HT_20_TS_HGI, 130000,
 			115800, 20, 20, 8, 64, 35, 65 }, /* 130 Mb */
-		[36] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS, 156000,
+		[36] = {  RC_HT_T_20, FALSE, WLAN_RC_PHY_HT_20_TS, 156000,
 			137200, 21, 21, 8, 66, 37, 67 }, /* 156 Mb */
-		[37] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS_HGI, 173300,
+		[37] = {  RC_HT_T_20, TRUE_N2_T_N1_T, WLAN_RC_PHY_HT_20_TS_HGI, 173300,
 			151100, 21, 21, 8, 66, 37, 67 }, /* 173.3 Mb */
-		[38] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS, 175500,
+		[38] = {  RC_HT_T_20, FALSE, WLAN_RC_PHY_HT_20_TS, 175500,
 			152800, 22, 22, 8, 68, 39, 69 }, /* 175.5 Mb */
-		[39] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS_HGI, 195000,
+		[39] = {  RC_HT_T_20, TRUE_N2_T_N1_T, WLAN_RC_PHY_HT_20_TS_HGI, 195000,
 			168400, 22, 22, 8, 68, 39, 69 }, /* 195 Mb */
-		[40] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS, 195000,
+		[40] = {  RC_HT_T_20, FALSE, WLAN_RC_PHY_HT_20_TS, 195000,
 			168400, 23, 23, 8, 70, 41, 71 }, /* 195 Mb */
-		[41] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS_HGI, 216700,
+		[41] = {  RC_HT_T_20, TRUE_N2_T_N1_T, WLAN_RC_PHY_HT_20_TS_HGI, 216700,
 			185000, 23, 23, 8, 70, 41, 71 }, /* 216.7 Mb */
-		[42] = { RC_HT_SDT_40, WLAN_RC_PHY_HT_40_SS, 13500,
+		[42] = { RC_HT_SDT_40, TRUE_N_1_2_ALL, WLAN_RC_PHY_HT_40_SS, 13500,
 			13200, 0, 0, 8, 42, 42, 42 }, /* 13.5 Mb */
-		[43] = { RC_HT_SDT_40, WLAN_RC_PHY_HT_40_SS, 27500,
+		[43] = { RC_HT_SDT_40, TRUE_N_1_2_ALL, WLAN_RC_PHY_HT_40_SS, 27500,
 			25900, 1, 1, 8, 43, 43, 43 }, /* 27.0 Mb */
-		[44] = { RC_HT_SDT_40, WLAN_RC_PHY_HT_40_SS, 40500,
+		[44] = { RC_HT_SDT_40, TRUE_N_1_2_ALL, WLAN_RC_PHY_HT_40_SS, 40500,
 			38600, 2, 2, 8, 44, 44, 44 }, /* 40.5 Mb */
-		[45] = { RC_HT_SD_40, WLAN_RC_PHY_HT_40_SS, 54000,
+		[45] = { RC_HT_SD_40, TRUE_N_1_2_ALL, WLAN_RC_PHY_HT_40_SS, 54000,
 			49800, 3, 3, 8, 45, 45, 45 }, /* 54 Mb */
-		[46] = { RC_HT_SD_40, WLAN_RC_PHY_HT_40_SS, 81500,
+		[46] = { RC_HT_SD_40, TRUE_N_1_2_ALL, WLAN_RC_PHY_HT_40_SS, 81500,
 			72200, 4, 4, 8, 46, 46, 46 }, /* 81 Mb */
-		[47] = { RC_HT_S_40 , WLAN_RC_PHY_HT_40_SS, 108000,
+		[47] = { RC_HT_S_40, TRUE_N2_F_N1_D_S, WLAN_RC_PHY_HT_40_SS, 108000,
 			92900, 5, 5, 8, 47, 47, 47 }, /* 108 Mb */
-		[48] = { RC_HT_S_40, WLAN_RC_PHY_HT_40_SS, 121500,
+		[48] = { RC_HT_S_40, TRUE_N2_T_N1_S, WLAN_RC_PHY_HT_40_SS, 121500,
 			102700, 6, 6, 8, 48, 48, 48 }, /* 121.5 Mb */
-		[49] = { RC_HT_S_40, WLAN_RC_PHY_HT_40_SS, 135000,
+		[49] = { RC_HT_S_40, TRUE_N2_F_N1_S, WLAN_RC_PHY_HT_40_SS, 135000,
 			112000, 7, 7, 8, 49, 50, 50 }, /* 135 Mb */
-		[50] = { RC_HT_S_40, WLAN_RC_PHY_HT_40_SS_HGI, 150000,
+		[50] = { RC_HT_S_40, TRUE_N2_F_N1_S, WLAN_RC_PHY_HT_40_SS_HGI, 150000,
 			122000, 7, 7, 8, 49, 50, 50 }, /* 150 Mb */
-		[51] = { RC_INVALID, WLAN_RC_PHY_HT_40_DS, 27000,
+		[51] = { RC_INVALID, FALSE, WLAN_RC_PHY_HT_40_DS, 27000,
 			25800, 8, 8, 8, 51, 51, 51 }, /* 27 Mb */
-		[52] = { RC_HT_T_40, WLAN_RC_PHY_HT_40_DS, 54000,
+		[52] = { RC_HT_T_40, FALSE, WLAN_RC_PHY_HT_40_DS, 54000,
 			49800, 9, 9, 8, 52, 52, 52 }, /* 54 Mb */
-		[53] = { RC_HT_T_40, WLAN_RC_PHY_HT_40_DS, 81000,
+		[53] = { RC_HT_T_40, FALSE, WLAN_RC_PHY_HT_40_DS, 81000,
 			71900, 10, 10, 8, 53, 53, 53 }, /* 81 Mb */
-		[54] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 108000,
+		[54] = { RC_HT_DT_40, TRUE_N2_ALL_N1_T, WLAN_RC_PHY_HT_40_DS, 108000,
 			92500, 11, 11, 8, 54, 54, 54 }, /* 108 Mb */
-		[55] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 162000,
+		[55] = { RC_HT_DT_40, TRUE_N2_ALL_N1_T_D, WLAN_RC_PHY_HT_40_DS, 162000,
 			130300, 12, 12, 8, 55, 55, 55 }, /* 162 Mb */
-		[56] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 216000,
+		[56] = { RC_HT_DT_40, TRUE_N2_ALL_N1_T_D, WLAN_RC_PHY_HT_40_DS, 216000,
 			162800, 13, 13, 8, 56, 56, 56 }, /* 216 Mb */
-		[57] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 243000,
+		[57] = { RC_HT_DT_40, TRUE_N2_ALL_N1_T_D, WLAN_RC_PHY_HT_40_DS, 243000,
 			178200, 14, 14, 8, 57, 57, 57 }, /* 243 Mb */
-		[58] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 270000,
+		[58] = { RC_HT_DT_40, TRUE_N2_ALL_N1_T, WLAN_RC_PHY_HT_40_DS, 270000,
 			192100, 15, 15, 8, 58, 59, 59 }, /* 270 Mb */
-		[59] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS_HGI, 300000,
+		[59] = { RC_HT_DT_40, TRUE_N2_ALL_N1_T_D, WLAN_RC_PHY_HT_40_DS_HGI, 300000,
 			207000, 15, 15, 8, 58, 59, 59 }, /* 300 Mb */
-		[60] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 40500,
+		[60] = {  RC_INVALID, FALSE, WLAN_RC_PHY_HT_40_TS, 40500,
 			36100, 16, 16, 8, 60, 60, 60 }, /* 40.5 Mb */
-		[61] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 81000,
+		[61] = {  RC_INVALID, FALSE, WLAN_RC_PHY_HT_40_TS, 81000,
 			72900, 17, 17, 8, 61, 61, 61 }, /* 81 Mb */
-		[62] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 121500,
+		[62] = {  RC_INVALID, FALSE, WLAN_RC_PHY_HT_40_TS, 121500,
 			108300, 18, 18, 8, 62, 62, 62 }, /* 121.5 Mb */
-		[63] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 162000,
+		[63] = {  RC_INVALID, FALSE, WLAN_RC_PHY_HT_40_TS, 162000,
 			142000, 19, 19, 8, 63, 63, 63 }, /* 162 Mb */
-		[64] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 243000,
+		[64] = {  RC_INVALID, FALSE, WLAN_RC_PHY_HT_40_TS, 243000,
 			205100, 20, 20, 8, 64, 65, 65 }, /* 243 Mb */
-		[65] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS_HGI, 270000,
-			224700, 20, 20, 8, 64, 65, 65 }, /* 270 Mb */
-		[66] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS, 324000,
+		[65] = {  RC_INVALID, FALSE, WLAN_RC_PHY_HT_40_TS_HGI, 270000,
+			224700, 20, 20, 8, 64, 65, 65 }, /* 170 Mb */
+		[66] = {  RC_HT_T_40, FALSE, WLAN_RC_PHY_HT_40_TS, 324000,
 			263100, 21, 21, 8, 66, 67, 67 }, /* 324 Mb */
-		[67] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS_HGI, 360000,
+		[67] = {  RC_HT_T_40, TRUE_N2_T_N1_T, WLAN_RC_PHY_HT_40_TS_HGI, 360000,
 			288000, 21, 21, 8, 66, 67, 67 }, /* 360 Mb */
-		[68] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS, 364500,
+		[68] = {  RC_HT_T_40, FALSE, WLAN_RC_PHY_HT_40_TS, 364500,
 			290700, 22, 22, 8, 68, 69, 69 }, /* 364.5 Mb */
-		[69] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS_HGI, 405000,
+		[69] = {  RC_HT_T_40, TRUE_N2_T_N1_T, WLAN_RC_PHY_HT_40_TS_HGI, 405000,
 			317200, 22, 22, 8, 68, 69, 69 }, /* 405 Mb */
-		[70] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS, 405000,
+		[70] = {  RC_HT_T_40, FALSE, WLAN_RC_PHY_HT_40_TS, 405000,
 			317200, 23, 23, 8, 70, 71, 71 }, /* 405 Mb */
-		[71] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS_HGI, 450000,
+		[71] = {  RC_HT_T_40, TRUE_N2_T_N1_T, WLAN_RC_PHY_HT_40_TS_HGI, 450000,
 			346400, 23, 23, 8, 70, 71, 71 }, /* 450 Mb */
 	},
 	50,  /* probe interval */
@@ -324,21 +324,21 @@ static const struct ath_rate_table ar5416_11a_ratetable = {
 	8,
 	0,
 	{
-		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 6000, /* 6 Mb */
+		{ RC_L_SDT, FALSE, WLAN_RC_PHY_OFDM, 6000, /* 6 Mb */
 			5400, 0, 12, 0},
-		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 9000, /* 9 Mb */
+		{ RC_L_SDT, FALSE, WLAN_RC_PHY_OFDM, 9000, /* 9 Mb */
 			7800,  1, 18, 0},
-		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 12000, /* 12 Mb */
+		{ RC_L_SDT, FALSE, WLAN_RC_PHY_OFDM, 12000, /* 12 Mb */
 			10000, 2, 24, 2},
-		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 18000, /* 18 Mb */
+		{ RC_L_SDT, FALSE, WLAN_RC_PHY_OFDM, 18000, /* 18 Mb */
 			13900, 3, 36, 2},
-		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 24000, /* 24 Mb */
+		{ RC_L_SDT, FALSE, WLAN_RC_PHY_OFDM, 24000, /* 24 Mb */
 			17300, 4, 48, 4},
-		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 36000, /* 36 Mb */
+		{ RC_L_SDT, FALSE, WLAN_RC_PHY_OFDM, 36000, /* 36 Mb */
 			23000, 5, 72, 4},
-		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 48000, /* 48 Mb */
+		{ RC_L_SDT, FALSE, WLAN_RC_PHY_OFDM, 48000, /* 48 Mb */
 			27400, 6, 96, 4},
-		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 54000, /* 54 Mb */
+		{ RC_L_SDT, FALSE, WLAN_RC_PHY_OFDM, 54000, /* 54 Mb */
 			29300, 7, 108, 4},
 	},
 	50,  /* probe interval */
@@ -349,29 +349,29 @@ static const struct ath_rate_table ar5416_11g_ratetable = {
 	12,
 	0,
 	{
-		{ RC_L_SDT, WLAN_RC_PHY_CCK, 1000, /* 1 Mb */
+		{ RC_L_SDT, FALSE, WLAN_RC_PHY_CCK, 1000, /* 1 Mb */
 			900, 0, 2, 0},
-		{ RC_L_SDT, WLAN_RC_PHY_CCK, 2000, /* 2 Mb */
+		{ RC_L_SDT, FALSE, WLAN_RC_PHY_CCK, 2000, /* 2 Mb */
 			1900, 1, 4, 1},
-		{ RC_L_SDT, WLAN_RC_PHY_CCK, 5500, /* 5.5 Mb */
+		{ RC_L_SDT, FALSE, WLAN_RC_PHY_CCK, 5500, /* 5.5 Mb */
 			4900, 2, 11, 2},
-		{ RC_L_SDT, WLAN_RC_PHY_CCK, 11000, /* 11 Mb */
+		{ RC_L_SDT, FALSE, WLAN_RC_PHY_CCK, 11000, /* 11 Mb */
 			8100, 3, 22, 3},
-		{ RC_INVALID, WLAN_RC_PHY_OFDM, 6000, /* 6 Mb */
+		{ RC_INVALID, FALSE, WLAN_RC_PHY_OFDM, 6000, /* 6 Mb */
 			5400, 4, 12, 4},
-		{ RC_INVALID, WLAN_RC_PHY_OFDM, 9000, /* 9 Mb */
+		{ RC_INVALID, FALSE, WLAN_RC_PHY_OFDM, 9000, /* 9 Mb */
 			7800, 5, 18, 4},
-		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 12000, /* 12 Mb */
+		{ RC_L_SDT, FALSE, WLAN_RC_PHY_OFDM, 12000, /* 12 Mb */
 			10000, 6, 24, 6},
-		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 18000, /* 18 Mb */
+		{ RC_L_SDT, FALSE, WLAN_RC_PHY_OFDM, 18000, /* 18 Mb */
 			13900, 7, 36, 6},
-		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 24000, /* 24 Mb */
+		{ RC_L_SDT, FALSE, WLAN_RC_PHY_OFDM, 24000, /* 24 Mb */
 			17300, 8, 48, 8},
-		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 36000, /* 36 Mb */
+		{ RC_L_SDT, FALSE, WLAN_RC_PHY_OFDM, 36000, /* 36 Mb */
 			23000, 9, 72, 8},
-		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 48000, /* 48 Mb */
+		{ RC_L_SDT, FALSE, WLAN_RC_PHY_OFDM, 48000, /* 48 Mb */
 			27400, 10, 96, 8},
-		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 54000, /* 54 Mb */
+		{ RC_L_SDT, FALSE, WLAN_RC_PHY_OFDM, 54000, /* 54 Mb */
 			29300, 11, 108, 8},
 	},
 	50,  /* probe interval */
@@ -541,6 +541,72 @@ static u8 ath_rc_setvalid_rates(struct ath_rate_priv *ath_rc_priv,
 	return hi;
 }
 
+static bool ath_valid_txbf_rate(struct ath_rate_priv *ath_rc_priv,
+				const struct ath_rate_table *rate_table,
+				struct ath_rateset *rateset,
+				u32 capflag, u8 i, u8 j)
+{
+	u32 phy = rate_table->info[j].phy;
+	u16 rate_flags = rate_table->info[j].rate_flags;
+	u8 rate = rateset->rs_rates[i];
+
+	if (ath_rc_priv->usedNss == NSS_DIM_2) {
+		if (RC_TS_ONLY(rate_table->info[rate].rate_flags)) {
+			if (!(rate_table->info[j].tx_bf & TRUE_TS_N2))
+				return true;
+			if (capflag & WLAN_RC_40_FLAG) {
+				if ((phy < WLAN_RC_PHY_HT_40_SS) ||
+				    ((phy > WLAN_RC_PHY_HT_40_TS) &&
+				     (phy < WLAN_RC_PHY_HT_40_SS_HGI)))
+					return true;
+			}
+		} else if (RC_DS_ONLY(rate_table->info[rate].rate_flags)) {
+			if (!(rate_table->info[j].tx_bf & TRUE_DS_N2))
+				return true;
+
+			if (capflag & WLAN_RC_40_FLAG) {
+				if ((phy < WLAN_RC_PHY_HT_40_SS) ||
+				    (phy > WLAN_RC_PHY_HT_40_TS))
+					return true;
+			}
+		}
+	} else if (ath_rc_priv->usedNss == NSS_DIM_1) {
+		if (RC_TS_ONLY(rate_table->info[rate].rate_flags)) {
+			if (!(rate_table->info[j].tx_bf & TRUE_TS_N1))
+				return true;
+
+			if (capflag & WLAN_RC_40_FLAG) {
+				if ((phy < WLAN_RC_PHY_HT_40_SS) ||
+				    ((phy > WLAN_RC_PHY_HT_40_TS) &&
+				     (phy < WLAN_RC_PHY_HT_40_SS_HGI)))
+					return true;
+			}
+		} else if (RC_DS_ONLY(rate_table->info[rate].rate_flags)) {
+			if (!(rate_table->info[j].tx_bf & TRUE_DS_N1))
+				return true;
+
+			if (capflag & WLAN_RC_40_FLAG) {
+				if ((phy < WLAN_RC_PHY_HT_40_SS) ||
+				    ((phy > WLAN_RC_PHY_HT_40_TS) &&
+				     (phy < WLAN_RC_PHY_HT_40_SS_HGI)))
+					return true;
+			}
+		} else if (RC_SS_ONLY(rate_table->info[rate].rate_flags)) {
+			if (!(rate_table->info[j].tx_bf & TRUE_SS_N1))
+				return true;
+
+			if (capflag & WLAN_RC_40_FLAG) {
+				if ((phy < WLAN_RC_PHY_HT_40_SS) ||
+				    (phy > WLAN_RC_PHY_HT_40_TS))
+					return true;
+			}
+		}
+	} else {
+		if (!WLAN_RC_PHY_HT_VALID(rate_flags, capflag))
+			return true;
+	}
+	return false;
+}
 static u8 ath_rc_setvalid_htrates(struct ath_rate_priv *ath_rc_priv,
 				  const struct ath_rate_table *rate_table,
 				  u8 *mcs_set, u32 capflag)
@@ -557,6 +623,19 @@ static u8 ath_rc_setvalid_htrates(struct ath_rate_priv *ath_rc_priv,
 			u8 rate = rateset->rs_rates[i];
 			u8 dot11rate = rate_table->info[j].dot11rate;
 
+			if (capflag & WLAN_RC_TxBF_FLAG) {
+				if ((rate != dot11rate) || !WLAN_RC_PHY_HT(phy))
+					continue;
+				else {
+					if (ath_valid_txbf_rate(ath_rc_priv,
+								rate_table,
+								rateset,
+								capflag,
+								i, j))
+						continue;
+				}
+			}
+
 			if ((rate != dot11rate) || !WLAN_RC_PHY_HT(phy) ||
 			    !(rate_flags & WLAN_RC_CAP_STREAM(capflag)) ||
 			    !WLAN_RC_PHY_HT_VALID(rate_flags, capflag))
@@ -749,6 +828,14 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	if (rate_control_send_low(sta, priv_sta, txrc))
 		return;
 
+#define MS(_v, _f)  (((_v) & _f) >> _f##_S)
+	ath_rc_priv->txbf_sounding = 0;
+	if (ieee80211_has_order(fc)) {
+		ath_rc_priv->txbf_sounding = 1;
+		if (sta->ht_cap.staggered_sounding)
+			tx_info->flags |= IEEE80211_TX_CTL_STAG_SOUND;
+	}
+
 	/*
 	 * For Multi Rate Retry we use a different number of
 	 * retry attempt counts. This ends up looking like this:
@@ -764,17 +851,26 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	rate_table = ath_rc_priv->rate_table;
 	rix = ath_rc_get_highest_rix(sc, ath_rc_priv, rate_table, &is_probe);
 
+	if (ath_rc_priv->txbf_sounding) {
+		if (rix > 9)
+			rix -= 2;
+		if (rix == 9)
+			rix = 8;
+	}
+
 	/*
 	 * If we're in HT mode and both us and our peer supports LDPC.
 	 * We don't need to check our own device's capabilities as our own
 	 * ht capabilities would have already been intersected with our peer's.
 	 */
 	if (conf_is_ht(&sc->hw->conf) &&
-	    (sta->ht_cap.cap & IEEE80211_HT_CAP_LDPC_CODING))
+	    (sta->ht_cap.cap & IEEE80211_HT_CAP_LDPC_CODING) &&
+	    !(ath_rc_priv->txbf))
 		tx_info->flags |= IEEE80211_TX_CTL_LDPC;
 
 	if (conf_is_ht(&sc->hw->conf) &&
-	    (sta->ht_cap.cap & IEEE80211_HT_CAP_TX_STBC))
+	    (sta->ht_cap.cap & IEEE80211_HT_CAP_TX_STBC) &&
+	    !(ath_rc_priv->txbf))
 		tx_info->flags |= (1 << IEEE80211_TX_CTL_STBC_SHIFT);
 
 	if (is_probe) {
@@ -807,6 +903,16 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 		/* All other rates in the series have RTS enabled */
 		ath_rc_rate_set_series(rate_table, &rates[i], txrc,
 				       try_per_rate, rix, 1);
+
+		if (ath_rc_priv->txbf && ath_rc_priv->txbf_sounding) {
+			if (rates[i].flags & IEEE80211_TX_RC_MCS)
+				rates[i].flags &= ~IEEE80211_TX_RC_SHORT_GI;
+			else {
+				/* Remove sounding */
+				hdr->frame_control &=
+					~cpu_to_le16(IEEE80211_FCTL_ORDER);
+			}
+		}
 	}
 
 	/*
@@ -1163,6 +1269,9 @@ static void ath_rc_tx_status(struct ath_softc *sc,
 	    !(ath_rc_priv->ht_cap & WLAN_RC_40_FLAG))
 		return;
 
+	if (ath_rc_priv->txbf_sounding)
+		return;
+
 	rix = ath_rc_get_rateindex(rate_table, &rates[i]);
 	ath_rc_update_ht(sc, ath_rc_priv, tx_info, rix, xretries, long_retry);
 }
@@ -1189,6 +1298,10 @@ struct ath_rate_table *ath_choose_rate_table(struct ath_softc *sc,
 	}
 }
 
+#ifndef MIN
+#define MIN(a, b) (((a) < (b)) ? (a) : (b))
+#endif
+
 static void ath_rc_init(struct ath_softc *sc,
 			struct ath_rate_priv *ath_rc_priv,
 			struct ieee80211_supported_band *sband,
@@ -1218,6 +1331,15 @@ static void ath_rc_init(struct ath_softc *sc,
 		ath_rc_priv->valid_phy_ratecnt[i] = 0;
 	}
 
+	ath_rc_priv->usedNss = 0;
+	if (ath_rc_priv->txbf) {
+		ath_rc_priv->usedNss = MIN(MIN((ar5416_get_ntxchains(
+					   sc->sc_ah->txchainmask) - 1),
+					   TX_STREAM_USED_NUM(ath_rc_priv)),
+					   sta->ht_cap.channel_estimation_cap
+					   + 1);
+	}
+
 	if (!rateset->rs_nrates) {
 		/* No working rate, just initialize valid rates */
 		hi = ath_rc_init_validrates(ath_rc_priv, rate_table,
@@ -1279,6 +1401,8 @@ static u8 ath_rc_build_ht_caps(struct ath_softc *sc, struct ieee80211_sta *sta,
 			caps |= WLAN_RC_40_FLAG;
 		if (is_sgi)
 			caps |= WLAN_RC_SGI_FLAG;
+		if (sta->txbf)
+			caps |= WLAN_RC_TxBF_FLAG;
 	}
 
 	return caps;
@@ -1437,6 +1561,9 @@ static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
 	rate_table = ath_choose_rate_table(sc, sband->band,
 	                      sta->ht_cap.ht_supported);
 
+	if (sta->txbf)
+		ath_rc_priv->txbf = 1;
+
 	ath_rc_priv->ht_cap = ath_rc_build_ht_caps(sc, sta, is_cw40, is_sgi);
 	ath_rc_init(sc, priv_sta, sband, sta, rate_table);
 }
diff --git a/drivers/net/wireless/ath/ath9k/rc.h b/drivers/net/wireless/ath/ath9k/rc.h
index 2f46a22..ec2fe4e 100644
--- a/drivers/net/wireless/ath/ath9k/rc.h
+++ b/drivers/net/wireless/ath/ath9k/rc.h
@@ -36,11 +36,80 @@ struct ath_softc;
 #define RC_HT_20	0x0010
 #define RC_HT_40	0x0020
 
+/* flag for TxBF */
+/*
+ *  N2;N1 mean Nss(number of spatial streams) of Beamforming
+ *  Nss=2 : dualStream & tripleStream mode (DS & TS)
+ *  Nss=1 : singleStream ,dualStream mode & tripleStream mode (SS, DS & TS)
+ *
+ *  TRUE_AS_NB
+ *  A: which stream mode supported (TS, DS or SS)
+ *  B: under which Nss number
+*/
+#define    FALSE    0
+#define TRUE_TS_N2              (0x01)
+#define TRUE_DS_N2              (0x02)
+#define TRUE_TS_DS_N2           (TRUE_TS_N2|TRUE_DS_N2)
+#define TRUE_TS_N1              (0x04)
+#define TRUE_DS_N1              (0x08)
+#define TRUE_SS_N1              (0x10)
+#define TRUE_TS_SS_N1           (TRUE_TS_N1|TRUE_SS_N1)
+#define TRUE_DS_SS_N1           (TRUE_DS_N1|TRUE_SS_N1)
+#define TRUE_TS_DS_N1           (TRUE_TS_N1|TRUE_DS_N1)
+#define TRUE_ALL_N1             (TRUE_TS_N1|TRUE_DS_N1|TRUE_SS_N1)
+
+/*
+ * TRUE_N2_A_N1_B
+ * A: support under Nss=2
+ * B: support under Nss=1
+ *      ALL     : rate supported for all configuration of its Nss
+ *      S,D,T   : rate supported for single, dual ,triple stream of its Nss
+ *      F       : rate not supported
+ *
+ * (Nss2   |   Nss1)
+ */
+#define TRUE_N_1_2_ALL      (TRUE_TS_DS_N2|TRUE_ALL_N1)
+#define FALSE_N_ALL         (FALSE|FALSE)
+#define TRUE_N2_ALL_N1_F    (TRUE_TS_DS_N2|FALSE)
+#define TRUE_N2_T_N1_F      (TRUE_TS_N2|FALSE)
+#define TRUE_N2_D_N1_F      (TRUE_DS_N2|FALSE)
+#define TRUE_N2_ALL_N1_T    (TRUE_TS_DS_N2|TRUE_TS_N1)
+#define TRUE_N2_T_N1_T      (TRUE_TS_N2|TRUE_TS_N1)
+#define TRUE_N2_D_N1_T      (TRUE_DS_N2|TRUE_TS_N1)
+#define TRUE_N2_F_N1_T      (FALSE|TRUE_TS_N1)
+#define TRUE_N2_ALL_N1_D    (TRUE_TS_DS_N2|TRUE_DS_N1)
+#define TRUE_N2_T_N1_D      (TRUE_TS_N2|TRUE_DS_N1)
+#define TRUE_N2_D_N1_D      (TRUE_DS_N2|TRUE_DS_N1)
+#define TRUE_N2_F_N1_D      (FALSE|TRUE_DS_N1)
+#define TRUE_N2_ALL_N1_S    (TRUE_TS_DS_N2 | TRUE_SS_N1)
+#define TRUE_N2_T_N1_S      (TRUE_TS_N2 | TRUE_SS_N1)
+#define TRUE_N2_D_N1_S      (TRUE_DS_N2 | TRUE_SS_N1)
+#define TRUE_N2_F_N1_S      (FALSE | TRUE_SS_N1)
+#define TRUE_N2_ALL_N1_T_S  (TRUE_TS_DS_N2 | TRUE_TS_SS_N1)
+#define TRUE_N2_T_N1_T_S    (TRUE_TS_N2 | TRUE_TS_SS_N1)
+#define TRUE_N2_D_N1_T_S    (TRUE_DS_N2 | TRUE_TS_SS_N1)
+#define TRUE_N2_F_N1_T_S    (FALSE | TRUE_TS_SS_N1)
+#define TRUE_N2_ALL_N1_D_S  (TRUE_TS_DS_N2 | TRUE_DS_SS_N1)
+#define TRUE_N2_T_N1_D_S    (TRUE_TS_N2 | TRUE_DS_SS_N1)
+#define TRUE_N2_D_N1_D_S    (TRUE_DS_N2 | TRUE_DS_SS_N1)
+#define TRUE_N2_F_N1_D_S    (FALSE | TRUE_DS_SS_N1)
+#define TRUE_N2_ALL_N1_T_D  (TRUE_TS_DS_N2 | TRUE_TS_DS_N1)
+#define TRUE_N2_T_N1_T_D    (TRUE_TS_N2 | TRUE_TS_DS_N1)
+#define TRUE_N2_D_N1_T_D    (TRUE_DS_N2 | TRUE_TS_DS_N1)
+#define TRUE_N2_F_N1_T_D    (FALSE | TRUE_TS_DS_N1)
+#define TRUE_N2_T_N1_ALL    (TRUE_TS_N2 | TRUE_ALL_N1)
+#define TRUE_N2_D_N1_ALL    (TRUE_DS_N2 | TRUE_ALL_N1)
+#define TRUE_N2_F_N1_ALL    (FALSE | TRUE_ALL_N1)
+
+
+
 #define RC_STREAM_MASK	0xe
 #define RC_DS_OR_LATER(f)	((((f) & RC_STREAM_MASK) == RC_DS) || \
 				(((f) & RC_STREAM_MASK) == (RC_DS | RC_TS)))
 #define RC_TS_ONLY(f)		(((f) & RC_STREAM_MASK) == RC_TS)
 #define RC_SS_OR_LEGACY(f)	((f) & (RC_SS | RC_LEGACY))
+#define RC_DS_ONLY(f)		(((f) & RC_STREAM_MASK) == RC_DS)
+#define RC_SS_ONLY(f)		(((f) & RC_STREAM_MASK) == RC_SS)
 
 #define RC_HT_2040		(RC_HT_20 | RC_HT_40)
 #define RC_ALL_STREAM		(RC_SS | RC_DS | RC_TS)
@@ -66,6 +135,9 @@ struct ath_softc;
 
 #define RC_ALL			(RC_LEGACY | RC_HT_2040 | RC_ALL_STREAM)
 
+#define WLAN_RC_TxBF_FLAG       (0x400)
+#define WLAN_RC_CEC_FLAG        (0x1800)
+#define WLAN_RC_CEC_FLAG_S      11
 enum {
 	WLAN_RC_PHY_OFDM,
 	WLAN_RC_PHY_CCK,
@@ -132,7 +204,12 @@ enum {
 #define WLAN_RC_40_FLAG         (0x04)
 #define WLAN_RC_SGI_FLAG        (0x08)
 #define WLAN_RC_HT_FLAG         (0x10)
-
+#define ATH_RC_TXBF_FLAG             0x800
+#define ATH_RC_CEC_FLAG              0x3000
+#define ATH_RC_CEC_FLAG_S                12
+#define ATH_RC_SOUNDING_FLAG         0x4000
+#define VALID_TXBF_RATE(_rate, _nss) ((_rate >= 8) && \
+	(_rate < ((_nss == 2) ? 24 : 16)))
 /**
  * struct ath_rate_table - Rate Control table
  * @rate_cnt: total number of rates for the given wireless mode
@@ -157,6 +234,7 @@ struct ath_rate_table {
 	int mcs_start;
 	struct {
 		u16 rate_flags;
+		u8 tx_bf;
 		u8 phy;
 		u32 ratekbps;
 		u32 user_ratekbps;
@@ -216,6 +294,9 @@ struct ath_rate_priv {
 	u32 probe_interval;
 	u32 prev_data_rix;
 	u32 tx_triglevel_max;
+	u8 usedNss;
+	u8      txbf:1,   /* transmit beamforming capable */
+		txbf_sounding:1;   /* sounding indicator */
 	struct ath_rateset neg_rates;
 	struct ath_rateset neg_ht_rates;
 	struct ath_rate_softc *asc;
@@ -249,5 +330,12 @@ static inline void ath_rate_control_unregister(void)
 {
 }
 #endif
+#define NSS_DIM_2 0x2
+#define NSS_DIM_1 0x1
+
+#define TX_STREAM_USED_NUM(_pSib) (3*(_pSib->ht_cap & (WLAN_RC_TS_FLAG)) +   \
+	2*(_pSib->ht_cap & (WLAN_RC_DS_FLAG)) + 1)
+#define OPPOSITE_CEC_NUM(_capflag)	\
+	(((_capflag & WLAN_RC_CEC_FLAG) >> WLAN_RC_CEC_FLAG_S) + 1)
 
 #endif /* RC_H */
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 2bc422e..73e3723 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -668,18 +668,32 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 					     struct list_head *bf_q)
 {
 #define PADBYTES(_len) ((4 - ((_len) % 4)) % 4)
+#define MS(_v, _f)  (((_v) & _f) >> _f##_S)
 	struct ath_buf *bf, *bf_first, *bf_prev = NULL;
 	int rl = 0, nframes = 0, ndelim, prev_al = 0;
 	u16 aggr_limit = 0, al = 0, bpad = 0,
 		al_delta, h_baw = tid->baw_size / 2;
 	enum ATH_AGGR_STATUS status = ATH_AGGR_DONE;
 	struct ieee80211_tx_info *tx_info;
+	u8 is_prev_sounding = 0;
 
 	bf_first = list_first_entry(&tid->buf_q, struct ath_buf, list);
 
 	do {
 		bf = list_first_entry(&tid->buf_q, struct ath_buf, list);
 
+		/* send the sounding frame as a single frame */
+		if (bf->bf_flags &
+		   (ATH9K_TXDESC_TXBF_SOUND | ATH9K_TXDESC_TXBF_STAG_SOUND)) {
+			if (nframes != 0)
+				break;
+			else
+				is_prev_sounding = 1;
+		}
+
+		if ((nframes == 1) & (is_prev_sounding))
+			break;
+
 		/* do not step over block-ack window */
 		if (!BAW_WITHIN(tid->seq_start, tid->baw_size, bf->bf_seqno)) {
 			status = ATH_AGGR_BAW_CLOSED;
@@ -1532,6 +1546,25 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 		is_40 = !!(rates[i].flags & IEEE80211_TX_RC_40_MHZ_WIDTH);
 		is_sp = !!(rates[i].flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE);
 
+		if (ieee80211_has_order(hdr->frame_control)) {
+			struct ieee80211_qos_htc_hdr *qos_hdr;
+			qos_hdr = (struct ieee80211_qos_htc_hdr *)skb->data;
+
+			if (ieee80211_has_order(hdr->frame_control)) {
+				if ((qos_hdr->htc & cpu_to_le32(
+				     IEEE80211_HTC2_CSI_COMP_BF |
+				     IEEE80211_HTC2_CSI_NONCOMP_BF))) {
+					if (tx_info->flags &
+					    IEEE80211_TX_CTL_STAG_SOUND)
+						flags |=
+						  ATH9K_TXDESC_TXBF_STAG_SOUND;
+					else
+						flags |=
+						  ATH9K_TXDESC_TXBF_SOUND;
+				}
+			}
+		}
+
 		if (rates[i].flags & IEEE80211_TX_RC_MCS) {
 			/* MCS rates */
 			series[i].Rate = rix | 0x80;
@@ -1588,6 +1621,7 @@ static int ath_tx_setup_buffer(struct ieee80211_hw *hw, struct ath_buf *bf,
 	struct ath_softc *sc = aphy->sc;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ath_node *an = NULL;
 	int hdrlen;
 	__le16 fc;
 	int padpos, padsize;
@@ -1634,7 +1668,11 @@ static int ath_tx_setup_buffer(struct ieee80211_hw *hw, struct ath_buf *bf,
 		bf->bf_frmlen += tx_info->control.hw_key->icv_len;
 		bf->bf_keyix = tx_info->control.hw_key->hw_key_idx;
 	} else {
-		bf->bf_keyix = ATH9K_TXKEYIX_INVALID;
+		if (tx_info->control.sta) {
+			an = (struct ath_node *)tx_info->control.sta->drv_priv;
+			bf->bf_keyix = an->key_idx;
+		} else
+			bf->bf_keyix = ATH9K_TXKEYIX_INVALID;
 	}
 
 	if (ieee80211_is_data_qos(fc) && bf_isht(bf) &&
@@ -1998,6 +2036,9 @@ static void ath_tx_rc_status(struct ath_buf *bf, struct ath_tx_status *ts,
 		tx_info->status.ampdu_ack_len = bf->bf_nframes - nbad;
 	}
 
+	if (ts->ts_flags & ATH9K_TX_BF_ERR)
+		tx_info->flags |= IEEE80211_TX_CTL_TXBF_UPDATE;
+
 	if ((ts->ts_status & ATH9K_TXERR_FILT) == 0 &&
 	    (bf->bf_flags & ATH9K_TXDESC_NOACK) == 0 && update_rc) {
 		if (ieee80211_is_data(hdr->frame_control)) {
-- 
1.6.3.3

