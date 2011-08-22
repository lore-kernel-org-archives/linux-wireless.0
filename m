Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43968 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab1HVVuv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 17:50:51 -0400
Received: by mail-gy0-f174.google.com with SMTP id 6so3903756gya.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Aug 2011 14:50:51 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	Chaoming Li <chaoming_li@realsil.com.cn>
Subject: [PATCH 4/5] rtlwifi: rtl8192se: Convert to use the new rate-mapping routine in rtlwifi
Date: Mon, 22 Aug 2011 16:50:17 -0500
Message-Id: <1314049818-21839-5-git-send-email-Larry.Finger@lwfinger.net> (sfid-20110822_235059_348120_FADF4110)
In-Reply-To: <1314049818-21839-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1314049818-21839-1-git-send-email-Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch also deletes the now unused parts of rtl8192se/def.h.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>
---
 drivers/net/wireless/rtlwifi/rtl8192se/def.h |   39 +-------
 drivers/net/wireless/rtlwifi/rtl8192se/sw.c  |   30 +++---
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c |  124 +++-----------------------
 3 files changed, 32 insertions(+), 161 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/def.h b/drivers/net/wireless/rtlwifi/rtl8192se/def.h
index 69828f2..68204ea 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/def.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/def.h
@@ -33,37 +33,6 @@
 #define RX_CMD_QUEUE				1
 #define RX_MAX_QUEUE				2
 
-#define DESC92S_RATE1M				0x00
-#define DESC92S_RATE2M				0x01
-#define DESC92S_RATE5_5M			0x02
-#define DESC92S_RATE11M				0x03
-#define DESC92S_RATE6M				0x04
-#define DESC92S_RATE9M				0x05
-#define DESC92S_RATE12M				0x06
-#define DESC92S_RATE18M				0x07
-#define DESC92S_RATE24M				0x08
-#define DESC92S_RATE36M				0x09
-#define DESC92S_RATE48M				0x0a
-#define DESC92S_RATE54M				0x0b
-#define DESC92S_RATEMCS0			0x0c
-#define DESC92S_RATEMCS1			0x0d
-#define DESC92S_RATEMCS2			0x0e
-#define DESC92S_RATEMCS3			0x0f
-#define DESC92S_RATEMCS4			0x10
-#define DESC92S_RATEMCS5			0x11
-#define DESC92S_RATEMCS6			0x12
-#define DESC92S_RATEMCS7			0x13
-#define DESC92S_RATEMCS8			0x14
-#define DESC92S_RATEMCS9			0x15
-#define DESC92S_RATEMCS10			0x16
-#define DESC92S_RATEMCS11			0x17
-#define DESC92S_RATEMCS12			0x18
-#define DESC92S_RATEMCS13			0x19
-#define DESC92S_RATEMCS14			0x1a
-#define DESC92S_RATEMCS15			0x1b
-#define DESC92S_RATEMCS15_SG			0x1c
-#define DESC92S_RATEMCS32			0x20
-
 #define SHORT_SLOT_TIME				9
 #define NON_SHORT_SLOT_TIME			20
 
@@ -491,10 +460,10 @@ do {								\
 	SET_BITS_OFFSET_LE(__pdesc + 24, 0, 32, __val)
 
 #define RX_HAL_IS_CCK_RATE(_pdesc)\
-	(GET_RX_STATUS_DESC_RX_MCS(_pdesc) == DESC92S_RATE1M ||	\
-	 GET_RX_STATUS_DESC_RX_MCS(_pdesc) == DESC92S_RATE2M ||	\
-	 GET_RX_STATUS_DESC_RX_MCS(_pdesc) == DESC92S_RATE5_5M ||\
-	 GET_RX_STATUS_DESC_RX_MCS(_pdesc) == DESC92S_RATE11M)
+	(GET_RX_STATUS_DESC_RX_MCS(_pdesc) == DESC92_RATE1M ||	\
+	 GET_RX_STATUS_DESC_RX_MCS(_pdesc) == DESC92_RATE2M ||	\
+	 GET_RX_STATUS_DESC_RX_MCS(_pdesc) == DESC92_RATE5_5M ||\
+	 GET_RX_STATUS_DESC_RX_MCS(_pdesc) == DESC92_RATE11M)
 
 enum rf_optype {
 	RF_OP_BY_SW_3WIRE = 0,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/sw.c b/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
index 3876078..0055a1c 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
@@ -348,21 +348,21 @@ static struct rtl_hal_cfg rtl92se_hal_cfg = {
 	.maps[RTL_IMR_ROK] = IMR_ROK,
 	.maps[RTL_IBSS_INT_MASKS] = (IMR_BCNINT | IMR_TBDOK | IMR_TBDER),
 
-	.maps[RTL_RC_CCK_RATE1M] = DESC92S_RATE1M,
-	.maps[RTL_RC_CCK_RATE2M] = DESC92S_RATE2M,
-	.maps[RTL_RC_CCK_RATE5_5M] = DESC92S_RATE5_5M,
-	.maps[RTL_RC_CCK_RATE11M] = DESC92S_RATE11M,
-	.maps[RTL_RC_OFDM_RATE6M] = DESC92S_RATE6M,
-	.maps[RTL_RC_OFDM_RATE9M] = DESC92S_RATE9M,
-	.maps[RTL_RC_OFDM_RATE12M] = DESC92S_RATE12M,
-	.maps[RTL_RC_OFDM_RATE18M] = DESC92S_RATE18M,
-	.maps[RTL_RC_OFDM_RATE24M] = DESC92S_RATE24M,
-	.maps[RTL_RC_OFDM_RATE36M] = DESC92S_RATE36M,
-	.maps[RTL_RC_OFDM_RATE48M] = DESC92S_RATE48M,
-	.maps[RTL_RC_OFDM_RATE54M] = DESC92S_RATE54M,
-
-	.maps[RTL_RC_HT_RATEMCS7] = DESC92S_RATEMCS7,
-	.maps[RTL_RC_HT_RATEMCS15] = DESC92S_RATEMCS15,
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
 
 static struct pci_device_id rtl92se_pci_ids[] __devinitdata = {
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
index cffe308..d9aeae7 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
@@ -51,104 +51,6 @@ static u8 _rtl92se_map_hwqueue_to_fwqueue(struct sk_buff *skb,	u8 skb_queue)
 	return skb->priority;
 }
 
-static int _rtl92se_rate_mapping(bool isht, u8 desc_rate, bool first_ampdu)
-{
-	int rate_idx = 0;
-
-	if (first_ampdu) {
-		if (false == isht) {
-			switch (desc_rate) {
-			case DESC92S_RATE1M:
-				rate_idx = 0;
-				break;
-			case DESC92S_RATE2M:
-				rate_idx = 1;
-				break;
-			case DESC92S_RATE5_5M:
-				rate_idx = 2;
-				break;
-			case DESC92S_RATE11M:
-				rate_idx = 3;
-				break;
-			case DESC92S_RATE6M:
-				rate_idx = 4;
-				break;
-			case DESC92S_RATE9M:
-				rate_idx = 5;
-				break;
-			case DESC92S_RATE12M:
-				rate_idx = 6;
-				break;
-			case DESC92S_RATE18M:
-				rate_idx = 7;
-				break;
-			case DESC92S_RATE24M:
-				rate_idx = 8;
-				break;
-			case DESC92S_RATE36M:
-				rate_idx = 9;
-				break;
-			case DESC92S_RATE48M:
-				rate_idx = 10;
-				break;
-			case DESC92S_RATE54M:
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
-	case DESC92S_RATE1M:
-		rate_idx = 0;
-		break;
-	case DESC92S_RATE2M:
-		rate_idx = 1;
-		break;
-	case DESC92S_RATE5_5M:
-		rate_idx = 2;
-		break;
-	case DESC92S_RATE11M:
-		rate_idx = 3;
-		break;
-	case DESC92S_RATE6M:
-		rate_idx = 4;
-		break;
-	case DESC92S_RATE9M:
-		rate_idx = 5;
-		break;
-	case DESC92S_RATE12M:
-		rate_idx = 6;
-		break;
-	case DESC92S_RATE18M:
-		rate_idx = 7;
-		break;
-	case DESC92S_RATE24M:
-		rate_idx = 8;
-		break;
-	case DESC92S_RATE36M:
-		rate_idx = 9;
-		break;
-	case DESC92S_RATE48M:
-		rate_idx = 10;
-		break;
-	case DESC92S_RATE54M:
-		rate_idx = 11;
-		break;
-	default:
-		rate_idx = 11;
-		break;
-	}
-	return rate_idx;
-}
-
 static u8 _rtl92s_query_rxpwrpercentage(char antpower)
 {
 	if ((antpower <= -100) || (antpower >= 20))
@@ -345,8 +247,8 @@ static void _rtl92se_query_rxphystatus(struct ieee80211_hw *hw,
 		pstats->recvsignalpower = rx_pwr_all;
 
 		if (GET_RX_STATUS_DESC_RX_HT(pdesc) &&
-			GET_RX_STATUS_DESC_RX_MCS(pdesc) >= DESC92S_RATEMCS8 &&
-		    GET_RX_STATUS_DESC_RX_MCS(pdesc) <= DESC92S_RATEMCS15)
+			GET_RX_STATUS_DESC_RX_MCS(pdesc) >= DESC92_RATEMCS8 &&
+		    GET_RX_STATUS_DESC_RX_MCS(pdesc) <= DESC92_RATEMCS15)
 			max_spatial_stream = 2;
 		else
 			max_spatial_stream = 1;
@@ -654,10 +556,10 @@ bool rtl92se_rx_query_desc(struct ieee80211_hw *hw, struct rtl_stats *stats,
 	if (stats->decrypted)
 		rx_status->flag |= RX_FLAG_DECRYPTED;
 
-	rx_status->rate_idx = _rtl92se_rate_mapping((bool)
-			GET_RX_STATUS_DESC_RX_HT(pdesc),
-			(u8)GET_RX_STATUS_DESC_RX_MCS(pdesc),
-			(bool)GET_RX_STATUS_DESC_PAGGR(pdesc));
+	rx_status->rate_idx = rtlwifi_rate_mapping(hw,
+				(bool)GET_RX_STATUS_DESC_RX_HT(pdesc),
+				(u8)GET_RX_STATUS_DESC_RX_MCS(pdesc),
+				(bool)GET_RX_STATUS_DESC_PAGGR(pdesc));
 
 
 	rx_status->mactime = GET_RX_STATUS_DESC_TSFL(pdesc);
@@ -723,14 +625,14 @@ void rtl92se_tx_fill_desc(struct ieee80211_hw *hw,
 		SET_TX_DESC_RSVD_MACID(pdesc, reserved_macid);
 
 		SET_TX_DESC_TXHT(pdesc, ((ptcb_desc->hw_rate >=
-				 DESC92S_RATEMCS0) ? 1 : 0));
+				 DESC92_RATEMCS0) ? 1 : 0));
 
 		if (rtlhal->version == VERSION_8192S_ACUT) {
-			if (ptcb_desc->hw_rate == DESC92S_RATE1M ||
-				ptcb_desc->hw_rate  == DESC92S_RATE2M ||
-				ptcb_desc->hw_rate == DESC92S_RATE5_5M ||
-				ptcb_desc->hw_rate == DESC92S_RATE11M) {
-				ptcb_desc->hw_rate = DESC92S_RATE12M;
+			if (ptcb_desc->hw_rate == DESC92_RATE1M ||
+				ptcb_desc->hw_rate  == DESC92_RATE2M ||
+				ptcb_desc->hw_rate == DESC92_RATE5_5M ||
+				ptcb_desc->hw_rate == DESC92_RATE11M) {
+				ptcb_desc->hw_rate = DESC92_RATE12M;
 			}
 		}
 
@@ -759,7 +661,7 @@ void rtl92se_tx_fill_desc(struct ieee80211_hw *hw,
 		SET_TX_DESC_RTS_BANDWIDTH(pdesc, 0);
 		SET_TX_DESC_RTS_SUB_CARRIER(pdesc, ptcb_desc->rts_sc);
 		SET_TX_DESC_RTS_SHORT(pdesc, ((ptcb_desc->rts_rate <=
-		       DESC92S_RATE54M) ?
+		       DESC92_RATE54M) ?
 		       (ptcb_desc->rts_use_shortpreamble ? 1 : 0)
 		       : (ptcb_desc->rts_use_shortgi ? 1 : 0)));
 
-- 
1.7.3.4

