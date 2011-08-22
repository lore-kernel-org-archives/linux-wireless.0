Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:55719 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893Ab1HVVuu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 17:50:50 -0400
Received: by yie30 with SMTP id 30so3909040yie.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Aug 2011 14:50:49 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	Chaoming Li <chaoming_li@realsil.com.cn>
Subject: [PATCH 3/5] rtlwifi: rtl8192cu: Convert to use the new rate-mapping routine in rtlwifi
Date: Mon, 22 Aug 2011 16:50:16 -0500
Message-Id: <1314049818-21839-4-git-send-email-Larry.Finger@lwfinger.net> (sfid-20110822_235058_802529_7C75314D)
In-Reply-To: <1314049818-21839-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1314049818-21839-1-git-send-email-Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch also removes the now unused code from rtl8192ce/def.h.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>
---
 drivers/net/wireless/rtlwifi/rtl8192ce/def.h |  139 --------------------------
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c |    4 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.h |    8 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c  |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c  |   28 +++---
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c |   23 ++--
 6 files changed, 32 insertions(+), 172 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/def.h b/drivers/net/wireless/rtlwifi/rtl8192ce/def.h
index 35ff7df..11f4319 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/def.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/def.h
@@ -220,41 +220,6 @@ enum rtl_desc_qsel {
 	QSLT_CMD = 0x13,
 };
 
-enum rtl_desc92c_rate {
-	DESC92C_RATE1M = 0x00,
-	DESC92C_RATE2M = 0x01,
-	DESC92C_RATE5_5M = 0x02,
-	DESC92C_RATE11M = 0x03,
-
-	DESC92C_RATE6M = 0x04,
-	DESC92C_RATE9M = 0x05,
-	DESC92C_RATE12M = 0x06,
-	DESC92C_RATE18M = 0x07,
-	DESC92C_RATE24M = 0x08,
-	DESC92C_RATE36M = 0x09,
-	DESC92C_RATE48M = 0x0a,
-	DESC92C_RATE54M = 0x0b,
-
-	DESC92C_RATEMCS0 = 0x0c,
-	DESC92C_RATEMCS1 = 0x0d,
-	DESC92C_RATEMCS2 = 0x0e,
-	DESC92C_RATEMCS3 = 0x0f,
-	DESC92C_RATEMCS4 = 0x10,
-	DESC92C_RATEMCS5 = 0x11,
-	DESC92C_RATEMCS6 = 0x12,
-	DESC92C_RATEMCS7 = 0x13,
-	DESC92C_RATEMCS8 = 0x14,
-	DESC92C_RATEMCS9 = 0x15,
-	DESC92C_RATEMCS10 = 0x16,
-	DESC92C_RATEMCS11 = 0x17,
-	DESC92C_RATEMCS12 = 0x18,
-	DESC92C_RATEMCS13 = 0x19,
-	DESC92C_RATEMCS14 = 0x1a,
-	DESC92C_RATEMCS15 = 0x1b,
-	DESC92C_RATEMCS15_SG = 0x1c,
-	DESC92C_RATEMCS32 = 0x20,
-};
-
 struct phy_sts_cck_8192s_t {
 	u8 adc_pwdb_X[4];
 	u8 sq_rpt;
@@ -267,108 +232,4 @@ struct h2c_cmd_8192c {
 	u8 *p_cmdbuffer;
 };
 
-/* NOTE: reference to rtl8192c_rates struct */
-static inline int _rtl92c_rate_mapping(struct ieee80211_hw *hw, bool isHT,
-				       u8 desc_rate, bool first_ampdu)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	int rate_idx = 0;
-
-	if (first_ampdu) {
-		if (false == isHT) {
-			switch (desc_rate) {
-			case DESC92C_RATE1M:
-				rate_idx = 0;
-				break;
-			case DESC92C_RATE2M:
-				rate_idx = 1;
-				break;
-			case DESC92C_RATE5_5M:
-				rate_idx = 2;
-				break;
-			case DESC92C_RATE11M:
-				rate_idx = 3;
-				break;
-			case DESC92C_RATE6M:
-				rate_idx = 4;
-				break;
-			case DESC92C_RATE9M:
-				rate_idx = 5;
-				break;
-			case DESC92C_RATE12M:
-				rate_idx = 6;
-				break;
-			case DESC92C_RATE18M:
-				rate_idx = 7;
-				break;
-			case DESC92C_RATE24M:
-				rate_idx = 8;
-				break;
-			case DESC92C_RATE36M:
-				rate_idx = 9;
-				break;
-			case DESC92C_RATE48M:
-				rate_idx = 10;
-				break;
-			case DESC92C_RATE54M:
-				rate_idx = 11;
-				break;
-			default:
-				RT_TRACE(rtlpriv, COMP_ERR, DBG_DMESG,
-					 ("Rate %d is not support, set to "
-					"1M rate.\n", desc_rate));
-				rate_idx = 0;
-				break;
-			}
-		} else {
-			rate_idx = 11;
-		}
-		return rate_idx;
-	}
-	switch (desc_rate) {
-	case DESC92C_RATE1M:
-		rate_idx = 0;
-		break;
-	case DESC92C_RATE2M:
-		rate_idx = 1;
-		break;
-	case DESC92C_RATE5_5M:
-		rate_idx = 2;
-		break;
-	case DESC92C_RATE11M:
-		rate_idx = 3;
-		break;
-	case DESC92C_RATE6M:
-		rate_idx = 4;
-		break;
-	case DESC92C_RATE9M:
-		rate_idx = 5;
-		break;
-	case DESC92C_RATE12M:
-		rate_idx = 6;
-		break;
-	case DESC92C_RATE18M:
-		rate_idx = 7;
-		break;
-	case DESC92C_RATE24M:
-		rate_idx = 8;
-		break;
-	case DESC92C_RATE36M:
-		rate_idx = 9;
-		break;
-	case DESC92C_RATE48M:
-		rate_idx = 10;
-		break;
-	case DESC92C_RATE54M:
-		rate_idx = 11;
-		break;
-	/* TODO: How to mapping MCS rate? */
-	/*  NOTE: referenc to __ieee80211_rx */
-	default:
-		rate_idx = 11;
-		break;
-	}
-	return rate_idx;
-}
-
 #endif
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
index 194fc69..060a06f 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
@@ -892,8 +892,8 @@ static void _rtl92c_query_rxphystatus(struct ieee80211_hw *hw,
 		pstats->rxpower = rx_pwr_all;
 		pstats->recvsignalpower = rx_pwr_all;
 		if (GET_RX_DESC_RX_MCS(pdesc) &&
-		    GET_RX_DESC_RX_MCS(pdesc) >= DESC92C_RATEMCS8 &&
-		    GET_RX_DESC_RX_MCS(pdesc) <= DESC92C_RATEMCS15)
+		    GET_RX_DESC_RX_MCS(pdesc) >= DESC92_RATEMCS8 &&
+		    GET_RX_DESC_RX_MCS(pdesc) <= DESC92_RATEMCS15)
 			max_spatial_stream = 2;
 		else
 			max_spatial_stream = 1;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.h b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.h
index 298fdb7..35529f7 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.h
@@ -88,10 +88,10 @@ void rtl92c_set_data_filter(struct ieee80211_hw *hw, u16 filter);
 u32 rtl92c_get_txdma_status(struct ieee80211_hw *hw);
 
 #define RX_HAL_IS_CCK_RATE(_pdesc)\
-	(GET_RX_DESC_RX_MCS(_pdesc) == DESC92C_RATE1M ||\
-	 GET_RX_DESC_RX_MCS(_pdesc) == DESC92C_RATE2M ||\
-	 GET_RX_DESC_RX_MCS(_pdesc) == DESC92C_RATE5_5M ||\
-	 GET_RX_DESC_RX_MCS(_pdesc) == DESC92C_RATE11M)
+	(GET_RX_DESC_RX_MCS(_pdesc) == DESC92_RATE1M ||\
+	 GET_RX_DESC_RX_MCS(_pdesc) == DESC92_RATE2M ||\
+	 GET_RX_DESC_RX_MCS(_pdesc) == DESC92_RATE5_5M ||\
+	 GET_RX_DESC_RX_MCS(_pdesc) == DESC92_RATE11M)
 
 struct rx_fwinfo_92c {
 	u8 gain_trsw[4];
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c b/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
index 17a8e96..1e851aa 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
@@ -104,7 +104,7 @@ void rtl92cu_phy_rf6052_set_cck_txpower(struct ieee80211_hw *hw,
 			tx_agc[RF90_PATH_A] = 0x10101010;
 			tx_agc[RF90_PATH_B] = 0x10101010;
 		} else if (rtlpriv->dm.dynamic_txhighpower_lvl ==
-			   TXHIGHPWRLEVEL_LEVEL2) {
+			   TXHIGHPWRLEVEL_LEVEL1) {
 			tx_agc[RF90_PATH_A] = 0x00000000;
 			tx_agc[RF90_PATH_B] = 0x00000000;
 		} else{
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
index ef63c0d..424b8a0 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -241,20 +241,20 @@ static struct rtl_hal_cfg rtl92cu_hal_cfg = {
 	.maps[RTL_IMR_ROK] = IMR_ROK,
 	.maps[RTL_IBSS_INT_MASKS] = (IMR_BCNINT | IMR_TBDOK | IMR_TBDER),
 
-	.maps[RTL_RC_CCK_RATE1M] = DESC92C_RATE1M,
-	.maps[RTL_RC_CCK_RATE2M] = DESC92C_RATE2M,
-	.maps[RTL_RC_CCK_RATE5_5M] = DESC92C_RATE5_5M,
-	.maps[RTL_RC_CCK_RATE11M] = DESC92C_RATE11M,
-	.maps[RTL_RC_OFDM_RATE6M] = DESC92C_RATE6M,
-	.maps[RTL_RC_OFDM_RATE9M] = DESC92C_RATE9M,
-	.maps[RTL_RC_OFDM_RATE12M] = DESC92C_RATE12M,
-	.maps[RTL_RC_OFDM_RATE18M] = DESC92C_RATE18M,
-	.maps[RTL_RC_OFDM_RATE24M] = DESC92C_RATE24M,
-	.maps[RTL_RC_OFDM_RATE36M] = DESC92C_RATE36M,
-	.maps[RTL_RC_OFDM_RATE48M] = DESC92C_RATE48M,
-	.maps[RTL_RC_OFDM_RATE54M] = DESC92C_RATE54M,
-	.maps[RTL_RC_HT_RATEMCS7] = DESC92C_RATEMCS7,
-	.maps[RTL_RC_HT_RATEMCS15] = DESC92C_RATEMCS15,
+	.maps[RTL_RC_CCK_RATE1M] = DESC92_RATE1M,
+	.maps[RTL_RC_CCK_RATE2M] = DESC92_RATE2M,
+	.maps[RTL_RC_CCK_RATE5_5M] = DESC92_RATE5_5M,
+	.maps[RTL_RC_CCK_RATE11M] = DESC92_RATE11M,
+	.maps[RTL_RC_OFDM_RATE6M] = DESC92_RATE6M,
+	.maps[RTL_RC_OFDM_RATE9M] = DESC92_RATE9M,
+	.maps[RTL_RC_OFDM_RATE12M] = DESC92_RATE12M,
+	.maps[RTL_RC_OFDM_RATE18M] = DESC92_RATE18M,
+	.maps[RTL_RC_OFDM_RATE24M] = DESC92_RATE24M,
+	.maps[RTL_RC_OFDM_RATE36M] = DESC92_RATE36M,
+	.maps[RTL_RC_OFDM_RATE48M] = DESC92_RATE48M,
+	.maps[RTL_RC_OFDM_RATE54M] = DESC92_RATE54M,
+	.maps[RTL_RC_HT_RATEMCS7] = DESC92_RATEMCS7,
+	.maps[RTL_RC_HT_RATEMCS15] = DESC92_RATEMCS15,
 };
 
 #define USB_VENDER_ID_REALTEK		0x0bda
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
index 906e7aa..c416114 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
@@ -337,10 +337,10 @@ bool rtl92cu_rx_query_desc(struct ieee80211_hw *hw,
 	rx_status->flag |= RX_FLAG_MACTIME_MPDU;
 	if (stats->decrypted)
 		rx_status->flag |= RX_FLAG_DECRYPTED;
-	rx_status->rate_idx = _rtl92c_rate_mapping(hw,
-						(bool)GET_RX_DESC_RX_HT(pdesc),
-						(u8)GET_RX_DESC_RX_MCS(pdesc),
-						(bool)GET_RX_DESC_PAGGR(pdesc));
+	rx_status->rate_idx = rtlwifi_rate_mapping(hw,
+					(bool)GET_RX_DESC_RX_HT(pdesc),
+					(u8)GET_RX_DESC_RX_MCS(pdesc),
+					(bool)GET_RX_DESC_PAGGR(pdesc));
 	rx_status->mactime = GET_RX_DESC_TSFL(pdesc);
 	if (phystatus) {
 		p_drvinfo = (struct rx_fwinfo_92c *)(pdesc + RTL_RX_DESC_SIZE);
@@ -406,11 +406,10 @@ static void _rtl_rx_process(struct ieee80211_hw *hw, struct sk_buff *skb)
 	if (GET_RX_DESC_RX_HT(rxdesc))
 		rx_status->flag |= RX_FLAG_HT;
 	/* Data rate */
-	rx_status->rate_idx = _rtl92c_rate_mapping(hw,
-						(bool)GET_RX_DESC_RX_HT(rxdesc),
-						(u8)GET_RX_DESC_RX_MCS(rxdesc),
-						(bool)GET_RX_DESC_PAGGR(rxdesc)
-						);
+	rx_status->rate_idx = rtlwifi_rate_mapping(hw,
+					(bool)GET_RX_DESC_RX_HT(rxdesc),
+					(u8)GET_RX_DESC_RX_MCS(rxdesc),
+					(bool)GET_RX_DESC_PAGGR(rxdesc));
 	/*  There is a phy status after this rx descriptor. */
 	if (GET_RX_DESC_PHY_STATUS(rxdesc)) {
 		p_drvinfo = (struct rx_fwinfo_92c *)(rxdesc + RTL_RX_DESC_SIZE);
@@ -545,7 +544,7 @@ void rtl92cu_tx_fill_desc(struct ieee80211_hw *hw,
 	SET_TX_DESC_RTS_BW(txdesc, 0);
 	SET_TX_DESC_RTS_SC(txdesc, tcb_desc->rts_sc);
 	SET_TX_DESC_RTS_SHORT(txdesc,
-			      ((tcb_desc->rts_rate <= DESC92C_RATE54M) ?
+			      ((tcb_desc->rts_rate <= DESC92_RATE54M) ?
 			       (tcb_desc->rts_use_shortpreamble ? 1 : 0)
 			       : (tcb_desc->rts_use_shortgi ? 1 : 0)));
 	if (mac->bw_40) {
@@ -643,7 +642,7 @@ void rtl92cu_fill_fake_txdesc(struct ieee80211_hw *hw, u8 * pDesc,
 	}
 	SET_TX_DESC_USE_RATE(pDesc, 1); /* use data rate which is set by Sw */
 	SET_TX_DESC_OWN(pDesc, 1);
-	SET_TX_DESC_TX_RATE(pDesc, DESC92C_RATE1M);
+	SET_TX_DESC_TX_RATE(pDesc, DESC92_RATE1M);
 	_rtl_tx_desc_checksum(pDesc);
 }
 
@@ -659,7 +658,7 @@ void rtl92cu_tx_fill_cmddesc(struct ieee80211_hw *hw,
 	memset((void *)pdesc, 0, RTL_TX_HEADER_SIZE);
 	if (firstseg)
 		SET_TX_DESC_OFFSET(pdesc, RTL_TX_HEADER_SIZE);
-	SET_TX_DESC_TX_RATE(pdesc, DESC92C_RATE1M);
+	SET_TX_DESC_TX_RATE(pdesc, DESC92_RATE1M);
 	SET_TX_DESC_SEQ(pdesc, 0);
 	SET_TX_DESC_LINIP(pdesc, 0);
 	SET_TX_DESC_QUEUE_SEL(pdesc, fw_queue);
-- 
1.7.3.4

