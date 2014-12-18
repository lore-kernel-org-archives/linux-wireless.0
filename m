Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:39058 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbaLRJGJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 04:06:09 -0500
Received: by mail-ob0-f175.google.com with SMTP id wp4so2334559obc.6
        for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2014 01:06:08 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 12/16] rtlwifi: Convert all drivers to use a common set of rate descriptors
Date: Thu, 18 Dec 2014 03:05:36 -0600
Message-Id: <1418893540-19944-13-git-send-email-Larry.Finger@lwfinger.net> (sfid-20141218_100630_819849_681A8AB2)
In-Reply-To: <1418893540-19944-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1418893540-19944-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This common set of rate descriptors is renamed to be DESC_RATExx.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/base.c          | 80 ++++++++++++++--------------
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c  | 30 +++++------
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c |  8 +--
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c |  4 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c  | 28 +++++-----
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c |  6 +--
 drivers/net/wireless/rtlwifi/rtl8192de/sw.c  | 30 +++++------
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c | 20 +++----
 drivers/net/wireless/rtlwifi/rtl8192ee/trx.c | 12 ++---
 drivers/net/wireless/rtlwifi/rtl8192ee/trx.h |  8 +--
 drivers/net/wireless/rtlwifi/rtl8192se/def.h |  8 +--
 drivers/net/wireless/rtlwifi/rtl8192se/sw.c  | 30 +++++------
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c | 18 +++----
 drivers/net/wireless/rtlwifi/rtl8821ae/def.h | 31 -----------
 drivers/net/wireless/rtlwifi/wifi.h          | 72 ++++++++++++-------------
 15 files changed, 177 insertions(+), 208 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/rtlwifi/base.c
index d4c8e95..23fc51e 100644
--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
@@ -867,20 +867,20 @@ static u8 _rtl_get_highest_n_rate(struct ieee80211_hw *hw,
  *
  * B/G rate:
  * (rx_status->flag & RX_FLAG_HT) = 0,
- * DESC92_RATE1M-->DESC92_RATE54M ==> idx is 0-->11,
+ * DESC_RATE1M-->DESC_RATE54M ==> idx is 0-->11,
  *
  * N rate:
  * (rx_status->flag & RX_FLAG_HT) = 1,
- * DESC92_RATEMCS0-->DESC92_RATEMCS15 ==> idx is 0-->15
+ * DESC_RATEMCS0-->DESC_RATEMCS15 ==> idx is 0-->15
  *
  * 5G band:rx_status->band == IEEE80211_BAND_5GHZ
  * A rate:
  * (rx_status->flag & RX_FLAG_HT) = 0,
- * DESC92_RATE6M-->DESC92_RATE54M ==> idx is 0-->7,
+ * DESC_RATE6M-->DESC_RATE54M ==> idx is 0-->7,
  *
  * N rate:
  * (rx_status->flag & RX_FLAG_HT) = 1,
- * DESC92_RATEMCS0-->DESC92_RATEMCS15 ==> idx is 0-->15
+ * DESC_RATEMCS0-->DESC_RATEMCS15 ==> idx is 0-->15
  */
 int rtlwifi_rate_mapping(struct ieee80211_hw *hw,
 			 bool isht, u8 desc_rate)
@@ -890,40 +890,40 @@ int rtlwifi_rate_mapping(struct ieee80211_hw *hw,
 	if (false == isht) {
 		if (IEEE80211_BAND_2GHZ == hw->conf.chandef.chan->band) {
 			switch (desc_rate) {
-			case DESC92_RATE1M:
+			case DESC_RATE1M:
 				rate_idx = 0;
 				break;
-			case DESC92_RATE2M:
+			case DESC_RATE2M:
 				rate_idx = 1;
 				break;
-			case DESC92_RATE5_5M:
+			case DESC_RATE5_5M:
 				rate_idx = 2;
 				break;
-			case DESC92_RATE11M:
+			case DESC_RATE11M:
 				rate_idx = 3;
 				break;
-			case DESC92_RATE6M:
+			case DESC_RATE6M:
 				rate_idx = 4;
 				break;
-			case DESC92_RATE9M:
+			case DESC_RATE9M:
 				rate_idx = 5;
 				break;
-			case DESC92_RATE12M:
+			case DESC_RATE12M:
 				rate_idx = 6;
 				break;
-			case DESC92_RATE18M:
+			case DESC_RATE18M:
 				rate_idx = 7;
 				break;
-			case DESC92_RATE24M:
+			case DESC_RATE24M:
 				rate_idx = 8;
 				break;
-			case DESC92_RATE36M:
+			case DESC_RATE36M:
 				rate_idx = 9;
 				break;
-			case DESC92_RATE48M:
+			case DESC_RATE48M:
 				rate_idx = 10;
 				break;
-			case DESC92_RATE54M:
+			case DESC_RATE54M:
 				rate_idx = 11;
 				break;
 			default:
@@ -932,28 +932,28 @@ int rtlwifi_rate_mapping(struct ieee80211_hw *hw,
 			}
 		} else {
 			switch (desc_rate) {
-			case DESC92_RATE6M:
+			case DESC_RATE6M:
 				rate_idx = 0;
 				break;
-			case DESC92_RATE9M:
+			case DESC_RATE9M:
 				rate_idx = 1;
 				break;
-			case DESC92_RATE12M:
+			case DESC_RATE12M:
 				rate_idx = 2;
 				break;
-			case DESC92_RATE18M:
+			case DESC_RATE18M:
 				rate_idx = 3;
 				break;
-			case DESC92_RATE24M:
+			case DESC_RATE24M:
 				rate_idx = 4;
 				break;
-			case DESC92_RATE36M:
+			case DESC_RATE36M:
 				rate_idx = 5;
 				break;
-			case DESC92_RATE48M:
+			case DESC_RATE48M:
 				rate_idx = 6;
 				break;
-			case DESC92_RATE54M:
+			case DESC_RATE54M:
 				rate_idx = 7;
 				break;
 			default:
@@ -963,52 +963,52 @@ int rtlwifi_rate_mapping(struct ieee80211_hw *hw,
 		}
 	} else {
 		switch (desc_rate) {
-		case DESC92_RATEMCS0:
+		case DESC_RATEMCS0:
 			rate_idx = 0;
 			break;
-		case DESC92_RATEMCS1:
+		case DESC_RATEMCS1:
 			rate_idx = 1;
 			break;
-		case DESC92_RATEMCS2:
+		case DESC_RATEMCS2:
 			rate_idx = 2;
 			break;
-		case DESC92_RATEMCS3:
+		case DESC_RATEMCS3:
 			rate_idx = 3;
 			break;
-		case DESC92_RATEMCS4:
+		case DESC_RATEMCS4:
 			rate_idx = 4;
 			break;
-		case DESC92_RATEMCS5:
+		case DESC_RATEMCS5:
 			rate_idx = 5;
 			break;
-		case DESC92_RATEMCS6:
+		case DESC_RATEMCS6:
 			rate_idx = 6;
 			break;
-		case DESC92_RATEMCS7:
+		case DESC_RATEMCS7:
 			rate_idx = 7;
 			break;
-		case DESC92_RATEMCS8:
+		case DESC_RATEMCS8:
 			rate_idx = 8;
 			break;
-		case DESC92_RATEMCS9:
+		case DESC_RATEMCS9:
 			rate_idx = 9;
 			break;
-		case DESC92_RATEMCS10:
+		case DESC_RATEMCS10:
 			rate_idx = 10;
 			break;
-		case DESC92_RATEMCS11:
+		case DESC_RATEMCS11:
 			rate_idx = 11;
 			break;
-		case DESC92_RATEMCS12:
+		case DESC_RATEMCS12:
 			rate_idx = 12;
 			break;
-		case DESC92_RATEMCS13:
+		case DESC_RATEMCS13:
 			rate_idx = 13;
 			break;
-		case DESC92_RATEMCS14:
+		case DESC_RATEMCS14:
 			rate_idx = 14;
 			break;
-		case DESC92_RATEMCS15:
+		case DESC_RATEMCS15:
 			rate_idx = 15;
 			break;
 		default:
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
index dd5aa08..de6cb6c 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
@@ -334,21 +334,21 @@ static struct rtl_hal_cfg rtl92ce_hal_cfg = {
 	.maps[RTL_IMR_ROK] = IMR_ROK,
 	.maps[RTL_IBSS_INT_MASKS] = (IMR_BCNINT | IMR_TBDOK | IMR_TBDER),
 
-	.maps[RTL_RC_CCK_RATE1M] = DESC92_RATE1M,
-	.maps[RTL_RC_CCK_RATE2M] = DESC92_RATE2M,
-	.maps[RTL_RC_CCK_RATE5_5M] = DESC92_RATE5_5M,
-	.maps[RTL_RC_CCK_RATE11M] = DESC92_RATE11M,
-	.maps[RTL_RC_OFDM_RATE6M] = DESC92_RATE6M,
-	.maps[RTL_RC_OFDM_RATE9M] = DESC92_RATE9M,
-	.maps[RTL_RC_OFDM_RATE12M] = DESC92_RATE12M,
-	.maps[RTL_RC_OFDM_RATE18M] = DESC92_RATE18M,
-	.maps[RTL_RC_OFDM_RATE24M] = DESC92_RATE24M,
-	.maps[RTL_RC_OFDM_RATE36M] = DESC92_RATE36M,
-	.maps[RTL_RC_OFDM_RATE48M] = DESC92_RATE48M,
-	.maps[RTL_RC_OFDM_RATE54M] = DESC92_RATE54M,
-
-	.maps[RTL_RC_HT_RATEMCS7] = DESC92_RATEMCS7,
-	.maps[RTL_RC_HT_RATEMCS15] = DESC92_RATEMCS15,
+	.maps[RTL_RC_CCK_RATE1M] = DESC_RATE1M,
+	.maps[RTL_RC_CCK_RATE2M] = DESC_RATE2M,
+	.maps[RTL_RC_CCK_RATE5_5M] = DESC_RATE5_5M,
+	.maps[RTL_RC_CCK_RATE11M] = DESC_RATE11M,
+	.maps[RTL_RC_OFDM_RATE6M] = DESC_RATE6M,
+	.maps[RTL_RC_OFDM_RATE9M] = DESC_RATE9M,
+	.maps[RTL_RC_OFDM_RATE12M] = DESC_RATE12M,
+	.maps[RTL_RC_OFDM_RATE18M] = DESC_RATE18M,
+	.maps[RTL_RC_OFDM_RATE24M] = DESC_RATE24M,
+	.maps[RTL_RC_OFDM_RATE36M] = DESC_RATE36M,
+	.maps[RTL_RC_OFDM_RATE48M] = DESC_RATE48M,
+	.maps[RTL_RC_OFDM_RATE54M] = DESC_RATE54M,
+
+	.maps[RTL_RC_HT_RATEMCS7] = DESC_RATEMCS7,
+	.maps[RTL_RC_HT_RATEMCS15] = DESC_RATEMCS15,
 };
 
 static const struct pci_device_id rtl92ce_pci_ids[] = {
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
index d25aeeb..685faea 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
@@ -257,8 +257,8 @@ static void _rtl92ce_query_rxphystatus(struct ieee80211_hw *hw,
 		pstats->recvsignalpower = rx_pwr_all;
 
 		/* (3)EVM of HT rate */
-		if (pstats->is_ht && pstats->rate >= DESC92_RATEMCS8 &&
-		    pstats->rate <= DESC92_RATEMCS15)
+		if (pstats->is_ht && pstats->rate >= DESC_RATEMCS8 &&
+		    pstats->rate <= DESC_RATEMCS15)
 			max_spatial_stream = 2;
 		else
 			max_spatial_stream = 1;
@@ -500,7 +500,7 @@ void rtl92ce_tx_fill_desc(struct ieee80211_hw *hw,
 		SET_TX_DESC_RTS_BW(pdesc, 0);
 		SET_TX_DESC_RTS_SC(pdesc, tcb_desc->rts_sc);
 		SET_TX_DESC_RTS_SHORT(pdesc,
-				      ((tcb_desc->rts_rate <= DESC92_RATE54M) ?
+				      ((tcb_desc->rts_rate <= DESC_RATE54M) ?
 				       (tcb_desc->rts_use_shortpreamble ? 1 : 0)
 				       : (tcb_desc->rts_use_shortgi ? 1 : 0)));
 
@@ -623,7 +623,7 @@ void rtl92ce_tx_fill_cmddesc(struct ieee80211_hw *hw,
 	if (firstseg)
 		SET_TX_DESC_OFFSET(pdesc, USB_HWDESC_HEADER_LEN);
 
-	SET_TX_DESC_TX_RATE(pdesc, DESC92_RATE1M);
+	SET_TX_DESC_TX_RATE(pdesc, DESC_RATE1M);
 
 	SET_TX_DESC_SEQ(pdesc, 0);
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
index c2d8ec6..133e395 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
@@ -880,8 +880,8 @@ static void _rtl92c_query_rxphystatus(struct ieee80211_hw *hw,
 		pstats->rxpower = rx_pwr_all;
 		pstats->recvsignalpower = rx_pwr_all;
 		if (GET_RX_DESC_RX_MCS(pdesc) &&
-		    GET_RX_DESC_RX_MCS(pdesc) >= DESC92_RATEMCS8 &&
-		    GET_RX_DESC_RX_MCS(pdesc) <= DESC92_RATEMCS15)
+		    GET_RX_DESC_RX_MCS(pdesc) >= DESC_RATEMCS8 &&
+		    GET_RX_DESC_RX_MCS(pdesc) <= DESC_RATEMCS15)
 			max_spatial_stream = 2;
 		else
 			max_spatial_stream = 1;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
index e06bafe..90a714c 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -257,20 +257,20 @@ static struct rtl_hal_cfg rtl92cu_hal_cfg = {
 	.maps[RTL_IMR_ROK] = IMR_ROK,
 	.maps[RTL_IBSS_INT_MASKS] = (IMR_BCNINT | IMR_TBDOK | IMR_TBDER),
 
-	.maps[RTL_RC_CCK_RATE1M] = DESC92_RATE1M,
-	.maps[RTL_RC_CCK_RATE2M] = DESC92_RATE2M,
-	.maps[RTL_RC_CCK_RATE5_5M] = DESC92_RATE5_5M,
-	.maps[RTL_RC_CCK_RATE11M] = DESC92_RATE11M,
-	.maps[RTL_RC_OFDM_RATE6M] = DESC92_RATE6M,
-	.maps[RTL_RC_OFDM_RATE9M] = DESC92_RATE9M,
-	.maps[RTL_RC_OFDM_RATE12M] = DESC92_RATE12M,
-	.maps[RTL_RC_OFDM_RATE18M] = DESC92_RATE18M,
-	.maps[RTL_RC_OFDM_RATE24M] = DESC92_RATE24M,
-	.maps[RTL_RC_OFDM_RATE36M] = DESC92_RATE36M,
-	.maps[RTL_RC_OFDM_RATE48M] = DESC92_RATE48M,
-	.maps[RTL_RC_OFDM_RATE54M] = DESC92_RATE54M,
-	.maps[RTL_RC_HT_RATEMCS7] = DESC92_RATEMCS7,
-	.maps[RTL_RC_HT_RATEMCS15] = DESC92_RATEMCS15,
+	.maps[RTL_RC_CCK_RATE1M] = DESC_RATE1M,
+	.maps[RTL_RC_CCK_RATE2M] = DESC_RATE2M,
+	.maps[RTL_RC_CCK_RATE5_5M] = DESC_RATE5_5M,
+	.maps[RTL_RC_CCK_RATE11M] = DESC_RATE11M,
+	.maps[RTL_RC_OFDM_RATE6M] = DESC_RATE6M,
+	.maps[RTL_RC_OFDM_RATE9M] = DESC_RATE9M,
+	.maps[RTL_RC_OFDM_RATE12M] = DESC_RATE12M,
+	.maps[RTL_RC_OFDM_RATE18M] = DESC_RATE18M,
+	.maps[RTL_RC_OFDM_RATE24M] = DESC_RATE24M,
+	.maps[RTL_RC_OFDM_RATE36M] = DESC_RATE36M,
+	.maps[RTL_RC_OFDM_RATE48M] = DESC_RATE48M,
+	.maps[RTL_RC_OFDM_RATE54M] = DESC_RATE54M,
+	.maps[RTL_RC_HT_RATEMCS7] = DESC_RATEMCS7,
+	.maps[RTL_RC_HT_RATEMCS15] = DESC_RATEMCS15,
 };
 
 #define USB_VENDER_ID_REALTEK		0x0bda
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
index fa30b26..fe29876 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
@@ -543,7 +543,7 @@ void rtl92cu_tx_fill_desc(struct ieee80211_hw *hw,
 	SET_TX_DESC_RTS_BW(txdesc, 0);
 	SET_TX_DESC_RTS_SC(txdesc, tcb_desc->rts_sc);
 	SET_TX_DESC_RTS_SHORT(txdesc,
-			      ((tcb_desc->rts_rate <= DESC92_RATE54M) ?
+			      ((tcb_desc->rts_rate <= DESC_RATE54M) ?
 			       (tcb_desc->rts_use_shortpreamble ? 1 : 0)
 			       : (tcb_desc->rts_use_shortgi ? 1 : 0)));
 	if (mac->bw_40) {
@@ -642,7 +642,7 @@ void rtl92cu_fill_fake_txdesc(struct ieee80211_hw *hw, u8 * pDesc,
 	}
 	SET_TX_DESC_USE_RATE(pDesc, 1); /* use data rate which is set by Sw */
 	SET_TX_DESC_OWN(pDesc, 1);
-	SET_TX_DESC_TX_RATE(pDesc, DESC92_RATE1M);
+	SET_TX_DESC_TX_RATE(pDesc, DESC_RATE1M);
 	_rtl_tx_desc_checksum(pDesc);
 }
 
@@ -658,7 +658,7 @@ void rtl92cu_tx_fill_cmddesc(struct ieee80211_hw *hw,
 	memset((void *)pdesc, 0, RTL_TX_HEADER_SIZE);
 	if (firstseg)
 		SET_TX_DESC_OFFSET(pdesc, RTL_TX_HEADER_SIZE);
-	SET_TX_DESC_TX_RATE(pdesc, DESC92_RATE1M);
+	SET_TX_DESC_TX_RATE(pdesc, DESC_RATE1M);
 	SET_TX_DESC_SEQ(pdesc, 0);
 	SET_TX_DESC_LINIP(pdesc, 0);
 	SET_TX_DESC_QUEUE_SEL(pdesc, fw_queue);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/sw.c b/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
index a0aba08..b19d039 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
@@ -337,21 +337,21 @@ static struct rtl_hal_cfg rtl92de_hal_cfg = {
 	.maps[RTL_IMR_ROK] = IMR_ROK,
 	.maps[RTL_IBSS_INT_MASKS] = (IMR_BCNINT | IMR_TBDOK | IMR_TBDER),
 
-	.maps[RTL_RC_CCK_RATE1M] = DESC92_RATE1M,
-	.maps[RTL_RC_CCK_RATE2M] = DESC92_RATE2M,
-	.maps[RTL_RC_CCK_RATE5_5M] = DESC92_RATE5_5M,
-	.maps[RTL_RC_CCK_RATE11M] = DESC92_RATE11M,
-	.maps[RTL_RC_OFDM_RATE6M] = DESC92_RATE6M,
-	.maps[RTL_RC_OFDM_RATE9M] = DESC92_RATE9M,
-	.maps[RTL_RC_OFDM_RATE12M] = DESC92_RATE12M,
-	.maps[RTL_RC_OFDM_RATE18M] = DESC92_RATE18M,
-	.maps[RTL_RC_OFDM_RATE24M] = DESC92_RATE24M,
-	.maps[RTL_RC_OFDM_RATE36M] = DESC92_RATE36M,
-	.maps[RTL_RC_OFDM_RATE48M] = DESC92_RATE48M,
-	.maps[RTL_RC_OFDM_RATE54M] = DESC92_RATE54M,
-
-	.maps[RTL_RC_HT_RATEMCS7] = DESC92_RATEMCS7,
-	.maps[RTL_RC_HT_RATEMCS15] = DESC92_RATEMCS15,
+	.maps[RTL_RC_CCK_RATE1M] = DESC_RATE1M,
+	.maps[RTL_RC_CCK_RATE2M] = DESC_RATE2M,
+	.maps[RTL_RC_CCK_RATE5_5M] = DESC_RATE5_5M,
+	.maps[RTL_RC_CCK_RATE11M] = DESC_RATE11M,
+	.maps[RTL_RC_OFDM_RATE6M] = DESC_RATE6M,
+	.maps[RTL_RC_OFDM_RATE9M] = DESC_RATE9M,
+	.maps[RTL_RC_OFDM_RATE12M] = DESC_RATE12M,
+	.maps[RTL_RC_OFDM_RATE18M] = DESC_RATE18M,
+	.maps[RTL_RC_OFDM_RATE24M] = DESC_RATE24M,
+	.maps[RTL_RC_OFDM_RATE36M] = DESC_RATE36M,
+	.maps[RTL_RC_OFDM_RATE48M] = DESC_RATE48M,
+	.maps[RTL_RC_OFDM_RATE54M] = DESC_RATE54M,
+
+	.maps[RTL_RC_HT_RATEMCS7] = DESC_RATEMCS7,
+	.maps[RTL_RC_HT_RATEMCS15] = DESC_RATEMCS15,
 };
 
 static struct pci_device_id rtl92de_pci_ids[] = {
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/trx.c b/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
index 7fbae49..381a4c0 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
@@ -235,8 +235,8 @@ static void _rtl92de_query_rxphystatus(struct ieee80211_hw *hw,
 		pstats->rx_pwdb_all = pwdb_all;
 		pstats->rxpower = rx_pwr_all;
 		pstats->recvsignalpower = rx_pwr_all;
-		if (pdesc->rxht && pdesc->rxmcs >= DESC92_RATEMCS8 &&
-		    pdesc->rxmcs <= DESC92_RATEMCS15)
+		if (pdesc->rxht && pdesc->rxmcs >= DESC_RATEMCS8 &&
+		    pdesc->rxmcs <= DESC_RATEMCS15)
 			max_spatial_stream = 2;
 		else
 			max_spatial_stream = 1;
@@ -611,14 +611,14 @@ void rtl92de_tx_fill_desc(struct ieee80211_hw *hw,
 		}
 		/* 5G have no CCK rate */
 		if (rtlhal->current_bandtype == BAND_ON_5G)
-			if (ptcb_desc->hw_rate < DESC92_RATE6M)
-				ptcb_desc->hw_rate = DESC92_RATE6M;
+			if (ptcb_desc->hw_rate < DESC_RATE6M)
+				ptcb_desc->hw_rate = DESC_RATE6M;
 		SET_TX_DESC_TX_RATE(pdesc, ptcb_desc->hw_rate);
 		if (ptcb_desc->use_shortgi || ptcb_desc->use_shortpreamble)
 			SET_TX_DESC_DATA_SHORTGI(pdesc, 1);
 
 		if (rtlhal->macphymode == DUALMAC_DUALPHY &&
-			ptcb_desc->hw_rate == DESC92_RATEMCS7)
+			ptcb_desc->hw_rate == DESC_RATEMCS7)
 			SET_TX_DESC_DATA_SHORTGI(pdesc, 1);
 
 		if (info->flags & IEEE80211_TX_CTL_AMPDU) {
@@ -634,13 +634,13 @@ void rtl92de_tx_fill_desc(struct ieee80211_hw *hw,
 		SET_TX_DESC_RTS_STBC(pdesc, ((ptcb_desc->rts_stbc) ? 1 : 0));
 		/* 5G have no CCK rate */
 		if (rtlhal->current_bandtype == BAND_ON_5G)
-			if (ptcb_desc->rts_rate < DESC92_RATE6M)
-				ptcb_desc->rts_rate = DESC92_RATE6M;
+			if (ptcb_desc->rts_rate < DESC_RATE6M)
+				ptcb_desc->rts_rate = DESC_RATE6M;
 		SET_TX_DESC_RTS_RATE(pdesc, ptcb_desc->rts_rate);
 		SET_TX_DESC_RTS_BW(pdesc, 0);
 		SET_TX_DESC_RTS_SC(pdesc, ptcb_desc->rts_sc);
 		SET_TX_DESC_RTS_SHORT(pdesc, ((ptcb_desc->rts_rate <=
-			DESC92_RATE54M) ?
+			DESC_RATE54M) ?
 			(ptcb_desc->rts_use_shortpreamble ? 1 : 0) :
 			(ptcb_desc->rts_use_shortgi ? 1 : 0)));
 		if (bw_40) {
@@ -755,9 +755,9 @@ void rtl92de_tx_fill_cmddesc(struct ieee80211_hw *hw,
 	 * The braces are needed no matter what checkpatch says
 	 */
 	if (rtlhal->current_bandtype == BAND_ON_5G) {
-		SET_TX_DESC_TX_RATE(pdesc, DESC92_RATE6M);
+		SET_TX_DESC_TX_RATE(pdesc, DESC_RATE6M);
 	} else {
-		SET_TX_DESC_TX_RATE(pdesc, DESC92_RATE1M);
+		SET_TX_DESC_TX_RATE(pdesc, DESC_RATE1M);
 	}
 	SET_TX_DESC_SEQ(pdesc, 0);
 	SET_TX_DESC_LINIP(pdesc, 0);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/trx.c b/drivers/net/wireless/rtlwifi/rtl8192ee/trx.c
index fb46fb9..3ea7367 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ee/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ee/trx.c
@@ -187,8 +187,8 @@ static void _rtl92ee_query_rxphystatus(struct ieee80211_hw *hw,
 		pstatus->recvsignalpower = rx_pwr_all;
 
 		/* (3)EVM of HT rate */
-		if (pstatus->rate >= DESC92C_RATEMCS8 &&
-		    pstatus->rate <= DESC92C_RATEMCS15)
+		if (pstatus->rate >= DESC_RATEMCS8 &&
+		    pstatus->rate <= DESC_RATEMCS15)
 			max_spatial_stream = 2;
 		else
 			max_spatial_stream = 1;
@@ -742,13 +742,13 @@ void rtl92ee_tx_fill_desc(struct ieee80211_hw *hw,
 		} else {
 			if (rtlpriv->ra.is_special_data) {
 				ptcb_desc->use_driver_rate = true;
-				SET_TX_DESC_TX_RATE(pdesc, DESC92C_RATE11M);
+				SET_TX_DESC_TX_RATE(pdesc, DESC_RATE11M);
 			} else {
 				ptcb_desc->use_driver_rate = false;
 			}
 		}
 
-		if (ptcb_desc->hw_rate > DESC92C_RATEMCS0)
+		if (ptcb_desc->hw_rate > DESC_RATEMCS0)
 			short_gi = (ptcb_desc->use_shortgi) ? 1 : 0;
 		else
 			short_gi = (ptcb_desc->use_shortpreamble) ? 1 : 0;
@@ -768,7 +768,7 @@ void rtl92ee_tx_fill_desc(struct ieee80211_hw *hw,
 		SET_TX_DESC_RTS_RATE(pdesc, ptcb_desc->rts_rate);
 		SET_TX_DESC_RTS_SC(pdesc, ptcb_desc->rts_sc);
 		SET_TX_DESC_RTS_SHORT(pdesc,
-				((ptcb_desc->rts_rate <= DESC92C_RATE54M) ?
+				((ptcb_desc->rts_rate <= DESC_RATE54M) ?
 				 (ptcb_desc->rts_use_shortpreamble ? 1 : 0) :
 				 (ptcb_desc->rts_use_shortgi ? 1 : 0)));
 
@@ -879,7 +879,7 @@ void rtl92ee_tx_fill_cmddesc(struct ieee80211_hw *hw,
 	if (firstseg)
 		SET_TX_DESC_OFFSET(pdesc, txdesc_len);
 
-	SET_TX_DESC_TX_RATE(pdesc, DESC92C_RATE1M);
+	SET_TX_DESC_TX_RATE(pdesc, DESC_RATE1M);
 
 	SET_TX_DESC_SEQ(pdesc, 0);
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/trx.h b/drivers/net/wireless/rtlwifi/rtl8192ee/trx.h
index 6f9be1c..45fd9db 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ee/trx.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ee/trx.h
@@ -591,10 +591,10 @@ do {								\
 } while (0)
 
 #define RTL92EE_RX_HAL_IS_CCK_RATE(rxmcs)\
-	(rxmcs == DESC92C_RATE1M ||\
-	 rxmcs == DESC92C_RATE2M ||\
-	 rxmcs == DESC92C_RATE5_5M ||\
-	 rxmcs == DESC92C_RATE11M)
+	(rxmcs == DESC_RATE1M ||\
+	 rxmcs == DESC_RATE2M ||\
+	 rxmcs == DESC_RATE5_5M ||\
+	 rxmcs == DESC_RATE11M)
 
 #define IS_LITTLE_ENDIAN	1
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/def.h b/drivers/net/wireless/rtlwifi/rtl8192se/def.h
index 6e7a70b..ef87c09 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/def.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/def.h
@@ -450,10 +450,10 @@
 	SHIFT_AND_MASK_LE(__pdesc + 24, 0, 32)
 
 #define SE_RX_HAL_IS_CCK_RATE(_pdesc)\
-	(GET_RX_STATUS_DESC_RX_MCS(_pdesc) == DESC92_RATE1M ||	\
-	 GET_RX_STATUS_DESC_RX_MCS(_pdesc) == DESC92_RATE2M ||	\
-	 GET_RX_STATUS_DESC_RX_MCS(_pdesc) == DESC92_RATE5_5M ||\
-	 GET_RX_STATUS_DESC_RX_MCS(_pdesc) == DESC92_RATE11M)
+	(GET_RX_STATUS_DESC_RX_MCS(_pdesc) == DESC_RATE1M ||	\
+	 GET_RX_STATUS_DESC_RX_MCS(_pdesc) == DESC_RATE2M ||	\
+	 GET_RX_STATUS_DESC_RX_MCS(_pdesc) == DESC_RATE5_5M ||\
+	 GET_RX_STATUS_DESC_RX_MCS(_pdesc) == DESC_RATE11M)
 
 enum rf_optype {
 	RF_OP_BY_SW_3WIRE = 0,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/sw.c b/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
index fb00386..e1fd27c 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
@@ -383,21 +383,21 @@ static struct rtl_hal_cfg rtl92se_hal_cfg = {
 	.maps[RTL_IMR_ROK] = IMR_ROK,
 	.maps[RTL_IBSS_INT_MASKS] = (IMR_BCNINT | IMR_TBDOK | IMR_TBDER),
 
-	.maps[RTL_RC_CCK_RATE1M] = DESC92_RATE1M,
-	.maps[RTL_RC_CCK_RATE2M] = DESC92_RATE2M,
-	.maps[RTL_RC_CCK_RATE5_5M] = DESC92_RATE5_5M,
-	.maps[RTL_RC_CCK_RATE11M] = DESC92_RATE11M,
-	.maps[RTL_RC_OFDM_RATE6M] = DESC92_RATE6M,
-	.maps[RTL_RC_OFDM_RATE9M] = DESC92_RATE9M,
-	.maps[RTL_RC_OFDM_RATE12M] = DESC92_RATE12M,
-	.maps[RTL_RC_OFDM_RATE18M] = DESC92_RATE18M,
-	.maps[RTL_RC_OFDM_RATE24M] = DESC92_RATE24M,
-	.maps[RTL_RC_OFDM_RATE36M] = DESC92_RATE36M,
-	.maps[RTL_RC_OFDM_RATE48M] = DESC92_RATE48M,
-	.maps[RTL_RC_OFDM_RATE54M] = DESC92_RATE54M,
-
-	.maps[RTL_RC_HT_RATEMCS7] = DESC92_RATEMCS7,
-	.maps[RTL_RC_HT_RATEMCS15] = DESC92_RATEMCS15,
+	.maps[RTL_RC_CCK_RATE1M] = DESC_RATE1M,
+	.maps[RTL_RC_CCK_RATE2M] = DESC_RATE2M,
+	.maps[RTL_RC_CCK_RATE5_5M] = DESC_RATE5_5M,
+	.maps[RTL_RC_CCK_RATE11M] = DESC_RATE11M,
+	.maps[RTL_RC_OFDM_RATE6M] = DESC_RATE6M,
+	.maps[RTL_RC_OFDM_RATE9M] = DESC_RATE9M,
+	.maps[RTL_RC_OFDM_RATE12M] = DESC_RATE12M,
+	.maps[RTL_RC_OFDM_RATE18M] = DESC_RATE18M,
+	.maps[RTL_RC_OFDM_RATE24M] = DESC_RATE24M,
+	.maps[RTL_RC_OFDM_RATE36M] = DESC_RATE36M,
+	.maps[RTL_RC_OFDM_RATE48M] = DESC_RATE48M,
+	.maps[RTL_RC_OFDM_RATE54M] = DESC_RATE54M,
+
+	.maps[RTL_RC_HT_RATEMCS7] = DESC_RATEMCS7,
+	.maps[RTL_RC_HT_RATEMCS15] = DESC_RATEMCS15,
 };
 
 static struct pci_device_id rtl92se_pci_ids[] = {
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
index da053cb..95eebff 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
@@ -191,8 +191,8 @@ static void _rtl92se_query_rxphystatus(struct ieee80211_hw *hw,
 		pstats->rxpower = rx_pwr_all;
 		pstats->recvsignalpower = rx_pwr_all;
 
-		if (pstats->is_ht && pstats->rate >= DESC92_RATEMCS8 &&
-		    pstats->rate <= DESC92_RATEMCS15)
+		if (pstats->is_ht && pstats->rate >= DESC_RATEMCS8 &&
+		    pstats->rate <= DESC_RATEMCS15)
 			max_spatial_stream = 2;
 		else
 			max_spatial_stream = 1;
@@ -393,14 +393,14 @@ void rtl92se_tx_fill_desc(struct ieee80211_hw *hw,
 		SET_TX_DESC_RSVD_MACID(pdesc, reserved_macid);
 
 		SET_TX_DESC_TXHT(pdesc, ((ptcb_desc->hw_rate >=
-				 DESC92_RATEMCS0) ? 1 : 0));
+				 DESC_RATEMCS0) ? 1 : 0));
 
 		if (rtlhal->version == VERSION_8192S_ACUT) {
-			if (ptcb_desc->hw_rate == DESC92_RATE1M ||
-			    ptcb_desc->hw_rate  == DESC92_RATE2M ||
-			    ptcb_desc->hw_rate == DESC92_RATE5_5M ||
-			    ptcb_desc->hw_rate == DESC92_RATE11M) {
-				ptcb_desc->hw_rate = DESC92_RATE12M;
+			if (ptcb_desc->hw_rate == DESC_RATE1M ||
+			    ptcb_desc->hw_rate  == DESC_RATE2M ||
+			    ptcb_desc->hw_rate == DESC_RATE5_5M ||
+			    ptcb_desc->hw_rate == DESC_RATE11M) {
+				ptcb_desc->hw_rate = DESC_RATE12M;
 			}
 		}
 
@@ -429,7 +429,7 @@ void rtl92se_tx_fill_desc(struct ieee80211_hw *hw,
 		SET_TX_DESC_RTS_BANDWIDTH(pdesc, 0);
 		SET_TX_DESC_RTS_SUB_CARRIER(pdesc, ptcb_desc->rts_sc);
 		SET_TX_DESC_RTS_SHORT(pdesc, ((ptcb_desc->rts_rate <=
-		       DESC92_RATE54M) ?
+		       DESC_RATE54M) ?
 		       (ptcb_desc->rts_use_shortpreamble ? 1 : 0)
 		       : (ptcb_desc->rts_use_shortgi ? 1 : 0)));
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/def.h b/drivers/net/wireless/rtlwifi/rtl8821ae/def.h
index a730985..53dc522 100644
--- a/drivers/net/wireless/rtlwifi/rtl8821ae/def.h
+++ b/drivers/net/wireless/rtlwifi/rtl8821ae/def.h
@@ -374,37 +374,6 @@ enum rtl_desc_qsel {
 };
 
 enum rtl_desc8821ae_rate {
-	DESC_RATE1M = 0x00,
-	DESC_RATE2M = 0x01,
-	DESC_RATE5_5M = 0x02,
-	DESC_RATE11M = 0x03,
-
-	DESC_RATE6M = 0x04,
-	DESC_RATE9M = 0x05,
-	DESC_RATE12M = 0x06,
-	DESC_RATE18M = 0x07,
-	DESC_RATE24M = 0x08,
-	DESC_RATE36M = 0x09,
-	DESC_RATE48M = 0x0a,
-	DESC_RATE54M = 0x0b,
-
-	DESC_RATEMCS0 = 0x0c,
-	DESC_RATEMCS1 = 0x0d,
-	DESC_RATEMCS2 = 0x0e,
-	DESC_RATEMCS3 = 0x0f,
-	DESC_RATEMCS4 = 0x10,
-	DESC_RATEMCS5 = 0x11,
-	DESC_RATEMCS6 = 0x12,
-	DESC_RATEMCS7 = 0x13,
-	DESC_RATEMCS8 = 0x14,
-	DESC_RATEMCS9 = 0x15,
-	DESC_RATEMCS10 = 0x16,
-	DESC_RATEMCS11 = 0x17,
-	DESC_RATEMCS12 = 0x18,
-	DESC_RATEMCS13 = 0x19,
-	DESC_RATEMCS14 = 0x1a,
-	DESC_RATEMCS15 = 0x1b,
-
 	DESC_RATEVHT1SS_MCS0 = 0x2c,
 	DESC_RATEVHT1SS_MCS1 = 0x2d,
 	DESC_RATEVHT1SS_MCS2 = 0x2e,
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index a233b26..26fd960 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -331,10 +331,10 @@ enum hardware_type {
 (IS_HARDWARE_TYPE_8723E(rtlhal) || IS_HARDWARE_TYPE_8723U(rtlhal))
 
 #define RX_HAL_IS_CCK_RATE(rxmcs)			\
-	((rxmcs) == DESC92_RATE1M ||			\
-	 (rxmcs) == DESC92_RATE2M ||			\
-	 (rxmcs) == DESC92_RATE5_5M ||			\
-	 (rxmcs) == DESC92_RATE11M)
+	((rxmcs) == DESC_RATE1M ||			\
+	 (rxmcs) == DESC_RATE2M ||			\
+	 (rxmcs) == DESC_RATE5_5M ||			\
+	 (rxmcs) == DESC_RATE11M)
 
 enum scan_operation_backup_opt {
 	SCAN_OPT_BACKUP = 0,
@@ -579,38 +579,38 @@ enum rtl_hal_state {
 };
 
 enum rtl_desc92_rate {
-	DESC92_RATE1M = 0x00,
-	DESC92_RATE2M = 0x01,
-	DESC92_RATE5_5M = 0x02,
-	DESC92_RATE11M = 0x03,
-
-	DESC92_RATE6M = 0x04,
-	DESC92_RATE9M = 0x05,
-	DESC92_RATE12M = 0x06,
-	DESC92_RATE18M = 0x07,
-	DESC92_RATE24M = 0x08,
-	DESC92_RATE36M = 0x09,
-	DESC92_RATE48M = 0x0a,
-	DESC92_RATE54M = 0x0b,
-
-	DESC92_RATEMCS0 = 0x0c,
-	DESC92_RATEMCS1 = 0x0d,
-	DESC92_RATEMCS2 = 0x0e,
-	DESC92_RATEMCS3 = 0x0f,
-	DESC92_RATEMCS4 = 0x10,
-	DESC92_RATEMCS5 = 0x11,
-	DESC92_RATEMCS6 = 0x12,
-	DESC92_RATEMCS7 = 0x13,
-	DESC92_RATEMCS8 = 0x14,
-	DESC92_RATEMCS9 = 0x15,
-	DESC92_RATEMCS10 = 0x16,
-	DESC92_RATEMCS11 = 0x17,
-	DESC92_RATEMCS12 = 0x18,
-	DESC92_RATEMCS13 = 0x19,
-	DESC92_RATEMCS14 = 0x1a,
-	DESC92_RATEMCS15 = 0x1b,
-	DESC92_RATEMCS15_SG = 0x1c,
-	DESC92_RATEMCS32 = 0x20,
+	DESC_RATE1M = 0x00,
+	DESC_RATE2M = 0x01,
+	DESC_RATE5_5M = 0x02,
+	DESC_RATE11M = 0x03,
+
+	DESC_RATE6M = 0x04,
+	DESC_RATE9M = 0x05,
+	DESC_RATE12M = 0x06,
+	DESC_RATE18M = 0x07,
+	DESC_RATE24M = 0x08,
+	DESC_RATE36M = 0x09,
+	DESC_RATE48M = 0x0a,
+	DESC_RATE54M = 0x0b,
+
+	DESC_RATEMCS0 = 0x0c,
+	DESC_RATEMCS1 = 0x0d,
+	DESC_RATEMCS2 = 0x0e,
+	DESC_RATEMCS3 = 0x0f,
+	DESC_RATEMCS4 = 0x10,
+	DESC_RATEMCS5 = 0x11,
+	DESC_RATEMCS6 = 0x12,
+	DESC_RATEMCS7 = 0x13,
+	DESC_RATEMCS8 = 0x14,
+	DESC_RATEMCS9 = 0x15,
+	DESC_RATEMCS10 = 0x16,
+	DESC_RATEMCS11 = 0x17,
+	DESC_RATEMCS12 = 0x18,
+	DESC_RATEMCS13 = 0x19,
+	DESC_RATEMCS14 = 0x1a,
+	DESC_RATEMCS15 = 0x1b,
+	DESC_RATEMCS15_SG = 0x1c,
+	DESC_RATEMCS32 = 0x20,
 };
 
 enum rtl_var_map {
-- 
2.1.2

