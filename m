Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:32966 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab1HVVus (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 17:50:48 -0400
Received: by yxj19 with SMTP id 19so3844690yxj.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Aug 2011 14:50:48 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	Chaoming Li <chaoming_li@realsil.com.cn>
Subject: [PATCH 2/5] rtlwifi: rtl8192ce: Convert to use the new rate-mapping routine in rtlwifi
Date: Mon, 22 Aug 2011 16:50:15 -0500
Message-Id: <1314049818-21839-3-git-send-email-Larry.Finger@lwfinger.net> (sfid-20110822_235058_236902_7D03CF69)
In-Reply-To: <1314049818-21839-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1314049818-21839-1-git-send-email-Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>
---
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c  |   30 ++++----
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c |  116 ++------------------------
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.h |    8 +-
 3 files changed, 27 insertions(+), 127 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
index 373dc78..4c34c4c 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
@@ -318,21 +318,21 @@ static struct rtl_hal_cfg rtl92ce_hal_cfg = {
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
-
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
+
+	.maps[RTL_RC_HT_RATEMCS7] = DESC92_RATEMCS7,
+	.maps[RTL_RC_HT_RATEMCS15] = DESC92_RATEMCS15,
 };
 
 DEFINE_PCI_DEVICE_TABLE(rtl92ce_pci_ids) = {
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
index 230bbe9..4fb5ae2 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
@@ -48,104 +48,6 @@ static u8 _rtl92ce_map_hwqueue_to_fwqueue(struct sk_buff *skb, u8 hw_queue)
 	return skb->priority;
 }
 
-static int _rtl92ce_rate_mapping(bool isht, u8 desc_rate, bool first_ampdu)
-{
-	int rate_idx;
-
-	if (first_ampdu) {
-		if (false == isht) {
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
-				rate_idx = 0;
-				break;
-			}
-		} else {
-			rate_idx = 11;
-		}
-
-		return rate_idx;
-	}
-
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
-	default:
-		rate_idx = 11;
-		break;
-	}
-	return rate_idx;
-}
-
 static u8 _rtl92c_query_rxpwrpercentage(char antpower)
 {
 	if ((antpower <= -100) || (antpower >= 20))
@@ -336,8 +238,8 @@ static void _rtl92ce_query_rxphystatus(struct ieee80211_hw *hw,
 		pstats->rxpower = rx_pwr_all;
 		pstats->recvsignalpower = rx_pwr_all;
 
-		if (pdesc->rxht && pdesc->rxmcs >= DESC92C_RATEMCS8 &&
-		    pdesc->rxmcs <= DESC92C_RATEMCS15)
+		if (pdesc->rxht && pdesc->rxmcs >= DESC92_RATEMCS8 &&
+		    pdesc->rxmcs <= DESC92_RATEMCS15)
 			max_spatial_stream = 2;
 		else
 			max_spatial_stream = 1;
@@ -670,12 +572,10 @@ bool rtl92ce_rx_query_desc(struct ieee80211_hw *hw,
 	if (stats->decrypted)
 		rx_status->flag |= RX_FLAG_DECRYPTED;
 
-	rx_status->rate_idx = _rtl92ce_rate_mapping((bool)
-						    GET_RX_DESC_RXHT(pdesc),
-						    (u8)
-						    GET_RX_DESC_RXMCS(pdesc),
-						    (bool)
-						    GET_RX_DESC_PAGGR(pdesc));
+	rx_status->rate_idx = rtlwifi_rate_mapping(hw,
+				(bool)GET_RX_DESC_RXHT(pdesc),
+				(u8)GET_RX_DESC_RXMCS(pdesc),
+				(bool)GET_RX_DESC_PAGGR(pdesc));
 
 	rx_status->mactime = GET_RX_DESC_TSFL(pdesc);
 	if (phystatus) {
@@ -768,7 +668,7 @@ void rtl92ce_tx_fill_desc(struct ieee80211_hw *hw,
 		SET_TX_DESC_RTS_BW(pdesc, 0);
 		SET_TX_DESC_RTS_SC(pdesc, tcb_desc->rts_sc);
 		SET_TX_DESC_RTS_SHORT(pdesc,
-				      ((tcb_desc->rts_rate <= DESC92C_RATE54M) ?
+				      ((tcb_desc->rts_rate <= DESC92_RATE54M) ?
 				       (tcb_desc->rts_use_shortpreamble ? 1 : 0)
 				       : (tcb_desc->rts_use_shortgi ? 1 : 0)));
 
@@ -886,7 +786,7 @@ void rtl92ce_tx_fill_cmddesc(struct ieee80211_hw *hw,
 	if (firstseg)
 		SET_TX_DESC_OFFSET(pdesc, USB_HWDESC_HEADER_LEN);
 
-	SET_TX_DESC_TX_RATE(pdesc, DESC92C_RATE1M);
+	SET_TX_DESC_TX_RATE(pdesc, DESC92_RATE1M);
 
 	SET_TX_DESC_SEQ(pdesc, 0);
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
index 0f11771..81ae642 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
@@ -538,10 +538,10 @@ do {							\
 } while (0);
 
 #define RX_HAL_IS_CCK_RATE(_pdesc)\
-	(_pdesc->rxmcs == DESC92C_RATE1M ||		\
-	 _pdesc->rxmcs == DESC92C_RATE2M ||		\
-	 _pdesc->rxmcs == DESC92C_RATE5_5M ||		\
-	 _pdesc->rxmcs == DESC92C_RATE11M)
+	(_pdesc->rxmcs == DESC92_RATE1M ||		\
+	 _pdesc->rxmcs == DESC92_RATE2M ||		\
+	 _pdesc->rxmcs == DESC92_RATE5_5M ||		\
+	 _pdesc->rxmcs == DESC92_RATE11M)
 
 struct rx_fwinfo_92c {
 	u8 gain_trsw[4];
-- 
1.7.3.4

