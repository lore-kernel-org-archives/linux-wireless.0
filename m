Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:55719 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab1HVVuw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 17:50:52 -0400
Received: by mail-yi0-f46.google.com with SMTP id 30so3909040yie.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Aug 2011 14:50:52 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	Chaoming Li <chaoming_li@realsil.com.cn>
Subject: [PATCH 5/5] rtlwifi: rtl8192de: Convert to use the new rate-mapping routine in rtlwifi
Date: Mon, 22 Aug 2011 16:50:18 -0500
Message-Id: <1314049818-21839-6-git-send-email-Larry.Finger@lwfinger.net> (sfid-20110822_235059_933878_E6DD9E7C)
In-Reply-To: <1314049818-21839-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1314049818-21839-1-git-send-email-Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch also deletes the now unused parts of rtl8192de/def.h.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>
---
 drivers/net/wireless/rtlwifi/rtl8192de/def.h |   35 --------
 drivers/net/wireless/rtlwifi/rtl8192de/sw.c  |   30 +++---
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c |  121 +++-----------------------
 drivers/net/wireless/rtlwifi/rtl8192de/trx.h |    8 +-
 4 files changed, 33 insertions(+), 161 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/def.h b/drivers/net/wireless/rtlwifi/rtl8192de/def.h
index f0f5f9b..aff7e19 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/def.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/def.h
@@ -193,41 +193,6 @@ enum rtl_desc_qsel {
 	QSLT_CMD = 0x13,
 };
 
-enum rtl_desc92d_rate {
-	DESC92D_RATE1M = 0x00,
-	DESC92D_RATE2M = 0x01,
-	DESC92D_RATE5_5M = 0x02,
-	DESC92D_RATE11M = 0x03,
-
-	DESC92D_RATE6M = 0x04,
-	DESC92D_RATE9M = 0x05,
-	DESC92D_RATE12M = 0x06,
-	DESC92D_RATE18M = 0x07,
-	DESC92D_RATE24M = 0x08,
-	DESC92D_RATE36M = 0x09,
-	DESC92D_RATE48M = 0x0a,
-	DESC92D_RATE54M = 0x0b,
-
-	DESC92D_RATEMCS0 = 0x0c,
-	DESC92D_RATEMCS1 = 0x0d,
-	DESC92D_RATEMCS2 = 0x0e,
-	DESC92D_RATEMCS3 = 0x0f,
-	DESC92D_RATEMCS4 = 0x10,
-	DESC92D_RATEMCS5 = 0x11,
-	DESC92D_RATEMCS6 = 0x12,
-	DESC92D_RATEMCS7 = 0x13,
-	DESC92D_RATEMCS8 = 0x14,
-	DESC92D_RATEMCS9 = 0x15,
-	DESC92D_RATEMCS10 = 0x16,
-	DESC92D_RATEMCS11 = 0x17,
-	DESC92D_RATEMCS12 = 0x18,
-	DESC92D_RATEMCS13 = 0x19,
-	DESC92D_RATEMCS14 = 0x1a,
-	DESC92D_RATEMCS15 = 0x1b,
-	DESC92D_RATEMCS15_SG = 0x1c,
-	DESC92D_RATEMCS32 = 0x20,
-};
-
 enum channel_plan {
 	CHPL_FCC	= 0,
 	CHPL_IC		= 1,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/sw.c b/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
index 351765d..f6419b7 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
@@ -340,21 +340,21 @@ static struct rtl_hal_cfg rtl92de_hal_cfg = {
 	.maps[RTL_IMR_ROK] = IMR_ROK,
 	.maps[RTL_IBSS_INT_MASKS] = (IMR_BcnInt | IMR_TBDOK | IMR_TBDER),
 
-	.maps[RTL_RC_CCK_RATE1M] = DESC92D_RATE1M,
-	.maps[RTL_RC_CCK_RATE2M] = DESC92D_RATE2M,
-	.maps[RTL_RC_CCK_RATE5_5M] = DESC92D_RATE5_5M,
-	.maps[RTL_RC_CCK_RATE11M] = DESC92D_RATE11M,
-	.maps[RTL_RC_OFDM_RATE6M] = DESC92D_RATE6M,
-	.maps[RTL_RC_OFDM_RATE9M] = DESC92D_RATE9M,
-	.maps[RTL_RC_OFDM_RATE12M] = DESC92D_RATE12M,
-	.maps[RTL_RC_OFDM_RATE18M] = DESC92D_RATE18M,
-	.maps[RTL_RC_OFDM_RATE24M] = DESC92D_RATE24M,
-	.maps[RTL_RC_OFDM_RATE36M] = DESC92D_RATE36M,
-	.maps[RTL_RC_OFDM_RATE48M] = DESC92D_RATE48M,
-	.maps[RTL_RC_OFDM_RATE54M] = DESC92D_RATE54M,
-
-	.maps[RTL_RC_HT_RATEMCS7] = DESC92D_RATEMCS7,
-	.maps[RTL_RC_HT_RATEMCS15] = DESC92D_RATEMCS15,
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
 
 static struct pci_device_id rtl92de_pci_ids[] __devinitdata = {
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/trx.c b/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
index dc86fcb..3637c0c 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
@@ -48,99 +48,6 @@ static u8 _rtl92de_map_hwqueue_to_fwqueue(struct sk_buff *skb, u8 hw_queue)
 	return skb->priority;
 }
 
-static int _rtl92de_rate_mapping(bool isht, u8 desc_rate)
-{
-	int rate_idx;
-
-	if (false == isht) {
-		switch (desc_rate) {
-		case DESC92D_RATE1M:
-			rate_idx = 0;
-			break;
-		case DESC92D_RATE2M:
-			rate_idx = 1;
-			break;
-		case DESC92D_RATE5_5M:
-			rate_idx = 2;
-			break;
-		case DESC92D_RATE11M:
-			rate_idx = 3;
-			break;
-		case DESC92D_RATE6M:
-			rate_idx = 4;
-			break;
-		case DESC92D_RATE9M:
-			rate_idx = 5;
-			break;
-		case DESC92D_RATE12M:
-			rate_idx = 6;
-			break;
-		case DESC92D_RATE18M:
-			rate_idx = 7;
-			break;
-		case DESC92D_RATE24M:
-			rate_idx = 8;
-			break;
-		case DESC92D_RATE36M:
-			rate_idx = 9;
-			break;
-		case DESC92D_RATE48M:
-			rate_idx = 10;
-			break;
-		case DESC92D_RATE54M:
-			rate_idx = 11;
-			break;
-		default:
-			rate_idx = 0;
-			break;
-		}
-		return rate_idx;
-	} else {
-		switch (desc_rate) {
-		case DESC92D_RATE1M:
-			rate_idx = 0;
-			break;
-		case DESC92D_RATE2M:
-			rate_idx = 1;
-			break;
-		case DESC92D_RATE5_5M:
-			rate_idx = 2;
-			break;
-		case DESC92D_RATE11M:
-			rate_idx = 3;
-			break;
-		case DESC92D_RATE6M:
-			rate_idx = 4;
-			break;
-		case DESC92D_RATE9M:
-			rate_idx = 5;
-			break;
-		case DESC92D_RATE12M:
-			rate_idx = 6;
-			break;
-		case DESC92D_RATE18M:
-			rate_idx = 7;
-			break;
-		case DESC92D_RATE24M:
-			rate_idx = 8;
-			break;
-		case DESC92D_RATE36M:
-			rate_idx = 9;
-			break;
-		case DESC92D_RATE48M:
-			rate_idx = 10;
-			break;
-		case DESC92D_RATE54M:
-			rate_idx = 11;
-			break;
-		default:
-			rate_idx = 11;
-			break;
-		}
-		return rate_idx;
-	}
-}
-
 static u8 _rtl92d_query_rxpwrpercentage(char antpower)
 {
 	if ((antpower <= -100) || (antpower >= 20))
@@ -328,8 +235,8 @@ static void _rtl92de_query_rxphystatus(struct ieee80211_hw *hw,
 		pstats->rx_pwdb_all = pwdb_all;
 		pstats->rxpower = rx_pwr_all;
 		pstats->recvsignalpower = rx_pwr_all;
-		if (pdesc->rxht && pdesc->rxmcs >= DESC92D_RATEMCS8 &&
-		    pdesc->rxmcs <= DESC92D_RATEMCS15)
+		if (pdesc->rxht && pdesc->rxmcs >= DESC92_RATEMCS8 &&
+		    pdesc->rxmcs <= DESC92_RATEMCS15)
 			max_spatial_stream = 2;
 		else
 			max_spatial_stream = 1;
@@ -609,10 +516,10 @@ bool rtl92de_rx_query_desc(struct ieee80211_hw *hw,	struct rtl_stats *stats,
 	rx_status->flag |= RX_FLAG_MACTIME_MPDU;
 	if (stats->decrypted)
 		rx_status->flag |= RX_FLAG_DECRYPTED;
-	rx_status->rate_idx = _rtl92de_rate_mapping((bool)
-						    GET_RX_DESC_RXHT(pdesc),
-						    (u8)
-						    GET_RX_DESC_RXMCS(pdesc));
+	rx_status->rate_idx = rtlwifi_rate_mapping(hw,
+					(bool)GET_RX_DESC_RXHT(pdesc),
+					(u8)GET_RX_DESC_RXMCS(pdesc),
+					(bool)GET_RX_DESC_PAGGR(pdesc));
 	rx_status->mactime = GET_RX_DESC_TSFL(pdesc);
 	if (phystatus) {
 		p_drvinfo = (struct rx_fwinfo_92d *)(skb->data +
@@ -705,14 +612,14 @@ void rtl92de_tx_fill_desc(struct ieee80211_hw *hw,
 		}
 		/* 5G have no CCK rate */
 		if (rtlhal->current_bandtype == BAND_ON_5G)
-			if (ptcb_desc->hw_rate < DESC92D_RATE6M)
-				ptcb_desc->hw_rate = DESC92D_RATE6M;
+			if (ptcb_desc->hw_rate < DESC92_RATE6M)
+				ptcb_desc->hw_rate = DESC92_RATE6M;
 		SET_TX_DESC_TX_RATE(pdesc, ptcb_desc->hw_rate);
 		if (ptcb_desc->use_shortgi || ptcb_desc->use_shortpreamble)
 			SET_TX_DESC_DATA_SHORTGI(pdesc, 1);
 
 		if (rtlhal->macphymode == DUALMAC_DUALPHY &&
-			ptcb_desc->hw_rate == DESC92D_RATEMCS7)
+			ptcb_desc->hw_rate == DESC92_RATEMCS7)
 			SET_TX_DESC_DATA_SHORTGI(pdesc, 1);
 
 		if (info->flags & IEEE80211_TX_CTL_AMPDU) {
@@ -728,13 +635,13 @@ void rtl92de_tx_fill_desc(struct ieee80211_hw *hw,
 		SET_TX_DESC_RTS_STBC(pdesc, ((ptcb_desc->rts_stbc) ? 1 : 0));
 		/* 5G have no CCK rate */
 		if (rtlhal->current_bandtype == BAND_ON_5G)
-			if (ptcb_desc->rts_rate < DESC92D_RATE6M)
-				ptcb_desc->rts_rate = DESC92D_RATE6M;
+			if (ptcb_desc->rts_rate < DESC92_RATE6M)
+				ptcb_desc->rts_rate = DESC92_RATE6M;
 		SET_TX_DESC_RTS_RATE(pdesc, ptcb_desc->rts_rate);
 		SET_TX_DESC_RTS_BW(pdesc, 0);
 		SET_TX_DESC_RTS_SC(pdesc, ptcb_desc->rts_sc);
 		SET_TX_DESC_RTS_SHORT(pdesc, ((ptcb_desc->rts_rate <=
-			DESC92D_RATE54M) ?
+			DESC92_RATE54M) ?
 			(ptcb_desc->rts_use_shortpreamble ? 1 : 0) :
 			(ptcb_desc->rts_use_shortgi ? 1 : 0)));
 		if (bw_40) {
@@ -844,9 +751,9 @@ void rtl92de_tx_fill_cmddesc(struct ieee80211_hw *hw,
 	 * The braces are needed no matter what checkpatch says
 	 */
 	if (rtlhal->current_bandtype == BAND_ON_5G) {
-		SET_TX_DESC_TX_RATE(pdesc, DESC92D_RATE6M);
+		SET_TX_DESC_TX_RATE(pdesc, DESC92_RATE6M);
 	} else {
-		SET_TX_DESC_TX_RATE(pdesc, DESC92D_RATE1M);
+		SET_TX_DESC_TX_RATE(pdesc, DESC92_RATE1M);
 	}
 	SET_TX_DESC_SEQ(pdesc, 0);
 	SET_TX_DESC_LINIP(pdesc, 0);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/trx.h b/drivers/net/wireless/rtlwifi/rtl8192de/trx.h
index 992d676..6c22368 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/trx.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/trx.h
@@ -538,10 +538,10 @@ do {							\
 } while (0);
 
 #define RX_HAL_IS_CCK_RATE(_pdesc)\
-	(_pdesc->rxmcs == DESC92D_RATE1M ||		\
-	 _pdesc->rxmcs == DESC92D_RATE2M ||		\
-	 _pdesc->rxmcs == DESC92D_RATE5_5M ||		\
-	 _pdesc->rxmcs == DESC92D_RATE11M)
+	(_pdesc->rxmcs == DESC92_RATE1M ||		\
+	 _pdesc->rxmcs == DESC92_RATE2M ||		\
+	 _pdesc->rxmcs == DESC92_RATE5_5M ||		\
+	 _pdesc->rxmcs == DESC92_RATE11M)
 
 /* For 92D early mode */
 #define SET_EARLYMODE_PKTNUM(__paddr, __value)		\
-- 
1.7.3.4

