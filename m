Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:28034 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753032AbYKRDlH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 22:41:07 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 17 Nov 2008 19:41:07 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18722.14501.113252.240643@gargle.gargle.HOWL> (sfid-20081118_044116_186232_3326FFDF)
Date: Tue, 18 Nov 2008 09:08:13 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 13/18] ath9k: General code scrub
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace TRUE/FALSE macros with VALID/INVALID macros.
Follow a consistent variable convention.
Remove unnecessary comments.
Add all RC phy macros into a single enum.
Merge functions into reasonably sized entities.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h |   18 +-
 drivers/net/wireless/ath9k/hw.c    |    4 +-
 drivers/net/wireless/ath9k/main.c  |    9 +-
 drivers/net/wireless/ath9k/rc.c    |  546 ++++++++++++++++--------------------
 drivers/net/wireless/ath9k/rc.h    |  110 ++------
 drivers/net/wireless/ath9k/xmit.c  |    2 +-
 6 files changed, 277 insertions(+), 412 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index c4012c8..6b0e3dd 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -686,13 +686,19 @@ enum ath9k_ani_cmd {
 	ATH9K_ANI_ALL = 0xff
 };
 
-enum phytype {
-	PHY_DS,
-	PHY_FH,
-	PHY_OFDM,
-	PHY_HT,
+enum {
+	WLAN_RC_PHY_OFDM,
+	WLAN_RC_PHY_CCK,
+	WLAN_RC_PHY_HT_20_SS,
+	WLAN_RC_PHY_HT_20_DS,
+	WLAN_RC_PHY_HT_40_SS,
+	WLAN_RC_PHY_HT_40_DS,
+	WLAN_RC_PHY_HT_20_SS_HGI,
+	WLAN_RC_PHY_HT_20_DS_HGI,
+	WLAN_RC_PHY_HT_40_SS_HGI,
+	WLAN_RC_PHY_HT_40_DS_HGI,
+	WLAN_RC_PHY_MAX
 };
-#define PHY_CCK PHY_DS
 
 enum ath9k_tp_scale {
 	ATH9K_TP_SCALE_MAX = 0,
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 7964639..1885d24 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -155,14 +155,14 @@ u16 ath9k_hw_computetxtime(struct ath_hal *ah,
 		return 0;
 
 	switch (rates->info[rateix].phy) {
-	case PHY_CCK:
+	case WLAN_RC_PHY_CCK:
 		phyTime = CCK_PREAMBLE_BITS + CCK_PLCP_BITS;
 		if (shortPreamble && rates->info[rateix].short_preamble)
 			phyTime >>= 1;
 		numBits = frameLen << 3;
 		txTime = CCK_SIFS_TIME + phyTime + ((numBits * 1000) / kbps);
 		break;
-	case PHY_OFDM:
+	case WLAN_RC_PHY_OFDM:
 		if (ah->ah_curchan && IS_CHAN_QUARTER_RATE(ah->ah_curchan)) {
 			bitsPerSymbol =	(kbps * OFDM_SYMBOL_TIME_QUARTER) / 1000;
 			numBits = OFDM_PLCP_BITS + (frameLen << 3);
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index cbe53bd..28a24df 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -347,16 +347,15 @@ void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 {
 	struct ieee80211_hw *hw = sc->hw;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+	struct ath_tx_info_priv *tx_info_priv = ATH_TX_INFO_PRIV(tx_info);
 
 	DPRINTF(sc, ATH_DBG_XMIT,
 		"%s: TX complete: skb: %p\n", __func__, skb);
 
 	if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK ||
-		tx_info->flags & IEEE80211_TX_STAT_TX_FILTERED) {
-		if (tx_info->rate_driver_data[0] != NULL) {
-			kfree(tx_info->rate_driver_data[0]);
-			tx_info->rate_driver_data[0] = NULL;
-		}
+	    tx_info->flags & IEEE80211_TX_STAT_TX_FILTERED) {
+		kfree(tx_info_priv);
+		tx_info->rate_driver_data[0] = NULL;
 	}
 
 	if (tx_status->flags & ATH_TX_BAR) {
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index bf637aa..51f51af 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -15,142 +15,136 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-/*
- * Atheros rate control algorithm
- */
-
 #include "core.h"
-/* FIXME: remove this include! */
-#include "../net/mac80211/rate.h"
 
 static struct ath_rate_table ar5416_11na_ratetable = {
 	42,
 	{0},
 	{
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 6000, /* 6 Mb */
+		{ VALID, VALID, WLAN_RC_PHY_OFDM, 6000, /* 6 Mb */
 			5400, 0x0b, 0x00, 12,
 			0, 2, 1, 0, 0, 0, 0, 0 },
-		{ TRUE,	TRUE, WLAN_PHY_OFDM, 9000, /* 9 Mb */
+		{ VALID,	VALID, WLAN_RC_PHY_OFDM, 9000, /* 9 Mb */
 			7800,  0x0f, 0x00, 18,
 			0, 3, 1, 1, 1, 1, 1, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 12000, /* 12 Mb */
+		{ VALID, VALID, WLAN_RC_PHY_OFDM, 12000, /* 12 Mb */
 			10000, 0x0a, 0x00, 24,
 			2, 4, 2, 2, 2, 2, 2, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 18000, /* 18 Mb */
+		{ VALID, VALID, WLAN_RC_PHY_OFDM, 18000, /* 18 Mb */
 			13900, 0x0e, 0x00, 36,
 			2, 6,  2, 3, 3, 3, 3, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 24000, /* 24 Mb */
+		{ VALID, VALID, WLAN_RC_PHY_OFDM, 24000, /* 24 Mb */
 			17300, 0x09, 0x00, 48,
 			4, 10, 3, 4, 4, 4, 4, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 36000, /* 36 Mb */
+		{ VALID, VALID, WLAN_RC_PHY_OFDM, 36000, /* 36 Mb */
 			23000, 0x0d, 0x00, 72,
 			4, 14, 3, 5, 5, 5, 5, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 48000, /* 48 Mb */
+		{ VALID, VALID, WLAN_RC_PHY_OFDM, 48000, /* 48 Mb */
 			27400, 0x08, 0x00, 96,
 			4, 20, 3, 6, 6, 6, 6, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 54000, /* 54 Mb */
+		{ VALID, VALID, WLAN_RC_PHY_OFDM, 54000, /* 54 Mb */
 			29300, 0x0c, 0x00, 108,
 			4, 23, 3, 7, 7, 7, 7, 0 },
-		{ TRUE_20, TRUE_20, WLAN_PHY_HT_20_SS, 6500, /* 6.5 Mb */
+		{ VALID_20, VALID_20, WLAN_RC_PHY_HT_20_SS, 6500, /* 6.5 Mb */
 			6400, 0x80, 0x00, 0,
 			0, 2, 3, 8, 24, 8, 24, 3216 },
-		{ TRUE_20, TRUE_20, WLAN_PHY_HT_20_SS, 13000, /* 13 Mb */
+		{ VALID_20, VALID_20, WLAN_RC_PHY_HT_20_SS, 13000, /* 13 Mb */
 			12700, 0x81, 0x00, 1,
 			2, 4, 3, 9, 25, 9, 25, 6434 },
-		{ TRUE_20, TRUE_20, WLAN_PHY_HT_20_SS, 19500, /* 19.5 Mb */
+		{ VALID_20, VALID_20, WLAN_RC_PHY_HT_20_SS, 19500, /* 19.5 Mb */
 			18800, 0x82, 0x00, 2,
 			2, 6, 3, 10, 26, 10, 26, 9650 },
-		{ TRUE_20, TRUE_20, WLAN_PHY_HT_20_SS, 26000, /* 26 Mb */
+		{ VALID_20, VALID_20, WLAN_RC_PHY_HT_20_SS, 26000, /* 26 Mb */
 			25000, 0x83, 0x00, 3,
 			4, 10, 3, 11, 27, 11, 27, 12868 },
-		{ TRUE_20, TRUE_20, WLAN_PHY_HT_20_SS, 39000, /* 39 Mb */
+		{ VALID_20, VALID_20, WLAN_RC_PHY_HT_20_SS, 39000, /* 39 Mb */
 			36700, 0x84, 0x00, 4,
 			4, 14, 3, 12, 28, 12, 28, 19304 },
-		{ FALSE, TRUE_20, WLAN_PHY_HT_20_SS, 52000, /* 52 Mb */
+		{ INVALID, VALID_20, WLAN_RC_PHY_HT_20_SS, 52000, /* 52 Mb */
 			48100, 0x85, 0x00, 5,
 			4, 20, 3, 13, 29, 13, 29, 25740 },
-		{ FALSE, TRUE_20, WLAN_PHY_HT_20_SS, 58500, /* 58.5 Mb */
+		{ INVALID, VALID_20, WLAN_RC_PHY_HT_20_SS, 58500, /* 58.5 Mb */
 			53500, 0x86, 0x00, 6,
 			4, 23, 3, 14, 30, 14, 30,  28956 },
-		{ FALSE, TRUE_20, WLAN_PHY_HT_20_SS, 65000, /* 65 Mb */
+		{ INVALID, VALID_20, WLAN_RC_PHY_HT_20_SS, 65000, /* 65 Mb */
 			59000, 0x87, 0x00, 7,
 			4, 25, 3, 15, 31, 15, 32, 32180 },
-		{ FALSE, FALSE, WLAN_PHY_HT_20_DS, 13000, /* 13 Mb */
+		{ INVALID, INVALID, WLAN_RC_PHY_HT_20_DS, 13000, /* 13 Mb */
 			12700, 0x88, 0x00,
 			8, 0, 2, 3, 16, 33, 16, 33, 6430 },
-		{ FALSE, FALSE, WLAN_PHY_HT_20_DS, 26000, /* 26 Mb */
+		{ INVALID, INVALID, WLAN_RC_PHY_HT_20_DS, 26000, /* 26 Mb */
 			24800, 0x89, 0x00, 9,
 			2, 4, 3, 17, 34, 17, 34, 12860 },
-		{ FALSE, FALSE, WLAN_PHY_HT_20_DS, 39000, /* 39 Mb */
+		{ INVALID, INVALID, WLAN_RC_PHY_HT_20_DS, 39000, /* 39 Mb */
 			36600, 0x8a, 0x00, 10,
 			2, 6, 3, 18, 35, 18, 35, 19300 },
-		{ TRUE_20, FALSE, WLAN_PHY_HT_20_DS, 52000, /* 52 Mb */
+		{ VALID_20, INVALID, WLAN_RC_PHY_HT_20_DS, 52000, /* 52 Mb */
 			48100, 0x8b, 0x00, 11,
 			4, 10, 3, 19, 36, 19, 36, 25736 },
-		{ TRUE_20, FALSE, WLAN_PHY_HT_20_DS, 78000, /* 78 Mb */
+		{ VALID_20, INVALID, WLAN_RC_PHY_HT_20_DS, 78000, /* 78 Mb */
 			69500, 0x8c, 0x00, 12,
 			4, 14, 3, 20, 37, 20, 37, 38600 },
-		{ TRUE_20, FALSE, WLAN_PHY_HT_20_DS, 104000, /* 104 Mb */
+		{ VALID_20, INVALID, WLAN_RC_PHY_HT_20_DS, 104000, /* 104 Mb */
 			89500, 0x8d, 0x00, 13,
 			4, 20, 3, 21, 38, 21, 38, 51472 },
-		{ TRUE_20, FALSE, WLAN_PHY_HT_20_DS, 117000, /* 117 Mb */
+		{ VALID_20, INVALID, WLAN_RC_PHY_HT_20_DS, 117000, /* 117 Mb */
 			98900, 0x8e, 0x00, 14,
 			4, 23, 3, 22, 39, 22, 39, 57890 },
-		{ TRUE_20, FALSE, WLAN_PHY_HT_20_DS, 130000, /* 130 Mb */
+		{ VALID_20, INVALID, WLAN_RC_PHY_HT_20_DS, 130000, /* 130 Mb */
 			108300, 0x8f, 0x00, 15,
 			4, 25, 3, 23, 40, 23, 41, 64320 },
-		{ TRUE_40, TRUE_40, WLAN_PHY_HT_40_SS, 13500, /* 13.5 Mb */
+		{ VALID_40, VALID_40, WLAN_RC_PHY_HT_40_SS, 13500, /* 13.5 Mb */
 			13200, 0x80, 0x00, 0,
 			0, 2, 3, 8, 24, 24, 24, 6684 },
-		{ TRUE_40, TRUE_40, WLAN_PHY_HT_40_SS, 27500, /* 27.0 Mb */
+		{ VALID_40, VALID_40, WLAN_RC_PHY_HT_40_SS, 27500, /* 27.0 Mb */
 			25900, 0x81, 0x00, 1,
 			2, 4, 3, 9, 25, 25, 25, 13368 },
-		{ TRUE_40, TRUE_40, WLAN_PHY_HT_40_SS, 40500, /* 40.5 Mb */
+		{ VALID_40, VALID_40, WLAN_RC_PHY_HT_40_SS, 40500, /* 40.5 Mb */
 			38600, 0x82, 0x00, 2,
 			2, 6, 3, 10, 26, 26, 26, 20052 },
-		{ TRUE_40, TRUE_40, WLAN_PHY_HT_40_SS, 54000, /* 54 Mb */
+		{ VALID_40, VALID_40, WLAN_RC_PHY_HT_40_SS, 54000, /* 54 Mb */
 			49800, 0x83, 0x00, 3,
 			4, 10, 3, 11, 27, 27, 27, 26738 },
-		{ TRUE_40, TRUE_40, WLAN_PHY_HT_40_SS, 81500, /* 81 Mb */
+		{ VALID_40, VALID_40, WLAN_RC_PHY_HT_40_SS, 81500, /* 81 Mb */
 			72200, 0x84, 0x00, 4,
 			4, 14, 3, 12, 28, 28, 28, 40104 },
-		{ FALSE, TRUE_40, WLAN_PHY_HT_40_SS, 108000, /* 108 Mb */
+		{ INVALID, VALID_40, WLAN_RC_PHY_HT_40_SS, 108000, /* 108 Mb */
 			92900, 0x85, 0x00, 5,
 			4, 20, 3, 13, 29, 29, 29, 53476 },
-		{ FALSE, TRUE_40, WLAN_PHY_HT_40_SS, 121500, /* 121.5 Mb */
+		{ INVALID, VALID_40, WLAN_RC_PHY_HT_40_SS, 121500, /* 121.5 Mb */
 			102700, 0x86, 0x00, 6,
 			4, 23, 3, 14, 30, 30, 30, 60156 },
-		{ FALSE, TRUE_40, WLAN_PHY_HT_40_SS, 135000, /* 135 Mb */
+		{ INVALID, VALID_40, WLAN_RC_PHY_HT_40_SS, 135000, /* 135 Mb */
 			112000, 0x87, 0x00, 7,
 			4, 25, 3, 15, 31, 32, 32, 66840 },
-		{ FALSE, TRUE_40, WLAN_PHY_HT_40_SS_HGI, 150000, /* 150 Mb */
+		{ INVALID, VALID_40, WLAN_RC_PHY_HT_40_SS_HGI, 150000, /* 150 Mb */
 			122000, 0x87, 0x00, 7,
 			4, 25, 3, 15, 31, 32, 32, 74200 },
-		{ FALSE, FALSE, WLAN_PHY_HT_40_DS, 27000, /* 27 Mb */
+		{ INVALID, INVALID, WLAN_RC_PHY_HT_40_DS, 27000, /* 27 Mb */
 			25800, 0x88, 0x00, 8,
 			0, 2, 3, 16, 33, 33, 33, 13360 },
-		{ FALSE, FALSE, WLAN_PHY_HT_40_DS, 54000, /* 54 Mb */
+		{ INVALID, INVALID, WLAN_RC_PHY_HT_40_DS, 54000, /* 54 Mb */
 			49800, 0x89, 0x00, 9,
 			2, 4, 3, 17, 34, 34, 34, 26720 },
-		{ FALSE, FALSE, WLAN_PHY_HT_40_DS, 81000, /* 81 Mb */
+		{ INVALID, INVALID, WLAN_RC_PHY_HT_40_DS, 81000, /* 81 Mb */
 			71900, 0x8a, 0x00, 10,
 			2, 6, 3, 18, 35, 35, 35, 40080 },
-		{ TRUE_40, FALSE, WLAN_PHY_HT_40_DS, 108000, /* 108 Mb */
+		{ VALID_40, INVALID, WLAN_RC_PHY_HT_40_DS, 108000, /* 108 Mb */
 			92500, 0x8b, 0x00, 11,
 			4, 10, 3, 19, 36, 36, 36, 53440 },
-		{ TRUE_40, FALSE, WLAN_PHY_HT_40_DS, 162000, /* 162 Mb */
+		{ VALID_40, INVALID, WLAN_RC_PHY_HT_40_DS, 162000, /* 162 Mb */
 			130300, 0x8c, 0x00, 12,
 			4, 14, 3, 20, 37, 37, 37, 80160 },
-		{ TRUE_40, FALSE, WLAN_PHY_HT_40_DS, 216000, /* 216 Mb */
+		{ VALID_40, INVALID, WLAN_RC_PHY_HT_40_DS, 216000, /* 216 Mb */
 			162800, 0x8d, 0x00, 13,
 			4, 20, 3, 21, 38, 38, 38, 106880 },
-		{ TRUE_40, FALSE, WLAN_PHY_HT_40_DS, 243000, /* 243 Mb */
+		{ VALID_40, INVALID, WLAN_RC_PHY_HT_40_DS, 243000, /* 243 Mb */
 			178200, 0x8e, 0x00, 14,
 			4, 23, 3, 22, 39, 39, 39, 120240 },
-		{ TRUE_40, FALSE, WLAN_PHY_HT_40_DS, 270000, /* 270 Mb */
+		{ VALID_40, INVALID, WLAN_RC_PHY_HT_40_DS, 270000, /* 270 Mb */
 			192100, 0x8f, 0x00, 15,
 			4, 25, 3, 23, 40, 41, 41, 133600 },
-		{ TRUE_40, FALSE, WLAN_PHY_HT_40_DS_HGI, 300000, /* 300 Mb */
+		{ VALID_40, INVALID, WLAN_RC_PHY_HT_40_DS_HGI, 300000, /* 300 Mb */
 			207000, 0x8f, 0x00, 15,
 			4, 25, 3, 23, 40, 41, 41, 148400 },
 	},
@@ -159,10 +153,10 @@ static struct ath_rate_table ar5416_11na_ratetable = {
 	WLAN_RC_HT_FLAG,  /* Phy rates allowed initially */
 };
 
-/* TRUE_ALL - valid for 20/40/Legacy,
- * TRUE - Legacy only,
- * TRUE_20 - HT 20 only,
- * TRUE_40 - HT 40 only */
+/* VALID_ALL - valid for 20/40/Legacy,
+ * VALID - Legacy only,
+ * VALID_20 - HT 20 only,
+ * VALID_40 - HT 40 only */
 
 /* 4ms frame limit not used for NG mode.  The values filled
  * for HT are the 64K max aggregate limit */
@@ -171,142 +165,142 @@ static struct ath_rate_table ar5416_11ng_ratetable = {
 	46,
 	{0},
 	{
-		{ TRUE_ALL, TRUE_ALL, WLAN_PHY_CCK, 1000, /* 1 Mb */
+		{ VALID_ALL, VALID_ALL, WLAN_RC_PHY_CCK, 1000, /* 1 Mb */
 			900, 0x1b, 0x00, 2,
 			0, 0, 1, 0, 0, 0, 0, 0 },
-		{ TRUE_ALL, TRUE_ALL, WLAN_PHY_CCK, 2000, /* 2 Mb */
+		{ VALID_ALL, VALID_ALL, WLAN_RC_PHY_CCK, 2000, /* 2 Mb */
 			1900, 0x1a, 0x04, 4,
 			1, 1, 1, 1, 1, 1, 1, 0 },
-		{ TRUE_ALL, TRUE_ALL, WLAN_PHY_CCK, 5500, /* 5.5 Mb */
+		{ VALID_ALL, VALID_ALL, WLAN_RC_PHY_CCK, 5500, /* 5.5 Mb */
 			4900, 0x19, 0x04, 11,
 			2, 2, 2, 2, 2, 2, 2, 0 },
-		{ TRUE_ALL, TRUE_ALL, WLAN_PHY_CCK, 11000, /* 11 Mb */
+		{ VALID_ALL, VALID_ALL, WLAN_RC_PHY_CCK, 11000, /* 11 Mb */
 			8100, 0x18, 0x04, 22,
 			3, 3, 2, 3, 3, 3, 3, 0 },
-		{ FALSE, FALSE, WLAN_PHY_OFDM, 6000, /* 6 Mb */
+		{ INVALID, INVALID, WLAN_RC_PHY_OFDM, 6000, /* 6 Mb */
 			5400, 0x0b, 0x00, 12,
 			4, 2, 1, 4, 4, 4, 4, 0 },
-		{ FALSE, FALSE, WLAN_PHY_OFDM, 9000, /* 9 Mb */
+		{ INVALID, INVALID, WLAN_RC_PHY_OFDM, 9000, /* 9 Mb */
 			7800, 0x0f, 0x00, 18,
 			4, 3, 1, 5, 5, 5, 5, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 12000, /* 12 Mb */
+		{ VALID, VALID, WLAN_RC_PHY_OFDM, 12000, /* 12 Mb */
 			10100, 0x0a, 0x00, 24,
 			6, 4, 1, 6, 6, 6, 6, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 18000, /* 18 Mb */
+		{ VALID, VALID, WLAN_RC_PHY_OFDM, 18000, /* 18 Mb */
 			14100,  0x0e, 0x00, 36,
 			6, 6, 2, 7, 7, 7, 7, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 24000, /* 24 Mb */
+		{ VALID, VALID, WLAN_RC_PHY_OFDM, 24000, /* 24 Mb */
 			17700, 0x09, 0x00, 48,
 			8, 10, 3, 8, 8, 8, 8, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 36000, /* 36 Mb */
+		{ VALID, VALID, WLAN_RC_PHY_OFDM, 36000, /* 36 Mb */
 			23700, 0x0d, 0x00, 72,
 			8, 14, 3, 9, 9, 9, 9, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 48000, /* 48 Mb */
+		{ VALID, VALID, WLAN_RC_PHY_OFDM, 48000, /* 48 Mb */
 			27400, 0x08, 0x00, 96,
 			8, 20, 3, 10, 10, 10, 10, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 54000, /* 54 Mb */
+		{ VALID, VALID, WLAN_RC_PHY_OFDM, 54000, /* 54 Mb */
 			30900, 0x0c, 0x00, 108,
 			8, 23, 3, 11, 11, 11, 11, 0 },
-		{ FALSE, FALSE, WLAN_PHY_HT_20_SS, 6500, /* 6.5 Mb */
+		{ INVALID, INVALID, WLAN_RC_PHY_HT_20_SS, 6500, /* 6.5 Mb */
 			6400, 0x80, 0x00, 0,
 			4, 2, 3, 12, 28, 12, 28, 3216 },
-		{ TRUE_20, TRUE_20, WLAN_PHY_HT_20_SS, 13000, /* 13 Mb */
+		{ VALID_20, VALID_20, WLAN_RC_PHY_HT_20_SS, 13000, /* 13 Mb */
 			12700, 0x81, 0x00, 1,
 			6, 4, 3, 13, 29, 13, 29, 6434 },
-		{ TRUE_20, TRUE_20, WLAN_PHY_HT_20_SS, 19500, /* 19.5 Mb */
+		{ VALID_20, VALID_20, WLAN_RC_PHY_HT_20_SS, 19500, /* 19.5 Mb */
 			18800, 0x82, 0x00, 2,
 			6, 6, 3, 14, 30, 14, 30, 9650 },
-		{ TRUE_20, TRUE_20, WLAN_PHY_HT_20_SS, 26000, /* 26 Mb */
+		{ VALID_20, VALID_20, WLAN_RC_PHY_HT_20_SS, 26000, /* 26 Mb */
 			25000, 0x83, 0x00, 3,
 			8, 10, 3, 15, 31, 15, 31, 12868 },
-		{ TRUE_20, TRUE_20, WLAN_PHY_HT_20_SS, 39000, /* 39 Mb */
+		{ VALID_20, VALID_20, WLAN_RC_PHY_HT_20_SS, 39000, /* 39 Mb */
 			36700, 0x84, 0x00, 4,
 			8, 14, 3, 16, 32, 16, 32, 19304 },
-		{ FALSE, TRUE_20, WLAN_PHY_HT_20_SS, 52000, /* 52 Mb */
+		{ INVALID, VALID_20, WLAN_RC_PHY_HT_20_SS, 52000, /* 52 Mb */
 			48100, 0x85, 0x00, 5,
 			8, 20, 3, 17, 33, 17, 33, 25740 },
-		{ FALSE,  TRUE_20, WLAN_PHY_HT_20_SS, 58500, /* 58.5 Mb */
+		{ INVALID,  VALID_20, WLAN_RC_PHY_HT_20_SS, 58500, /* 58.5 Mb */
 			53500, 0x86, 0x00, 6,
 			8, 23, 3, 18, 34, 18, 34, 28956 },
-		{ FALSE, TRUE_20, WLAN_PHY_HT_20_SS, 65000, /* 65 Mb */
+		{ INVALID, VALID_20, WLAN_RC_PHY_HT_20_SS, 65000, /* 65 Mb */
 			59000, 0x87, 0x00, 7,
 			8, 25, 3, 19, 35, 19, 36, 32180 },
-		{ FALSE, FALSE, WLAN_PHY_HT_20_DS, 13000, /* 13 Mb */
+		{ INVALID, INVALID, WLAN_RC_PHY_HT_20_DS, 13000, /* 13 Mb */
 			12700, 0x88, 0x00, 8,
 			4, 2, 3, 20, 37, 20, 37, 6430 },
-		{ FALSE, FALSE, WLAN_PHY_HT_20_DS, 26000, /* 26 Mb */
+		{ INVALID, INVALID, WLAN_RC_PHY_HT_20_DS, 26000, /* 26 Mb */
 			24800, 0x89, 0x00, 9,
 			6, 4, 3, 21, 38, 21, 38, 12860 },
-		{ FALSE, FALSE, WLAN_PHY_HT_20_DS, 39000, /* 39 Mb */
+		{ INVALID, INVALID, WLAN_RC_PHY_HT_20_DS, 39000, /* 39 Mb */
 			36600, 0x8a, 0x00, 10,
 			6, 6, 3, 22, 39, 22, 39, 19300 },
-		{ TRUE_20, FALSE, WLAN_PHY_HT_20_DS, 52000, /* 52 Mb */
+		{ VALID_20, INVALID, WLAN_RC_PHY_HT_20_DS, 52000, /* 52 Mb */
 			48100, 0x8b, 0x00, 11,
 			8, 10, 3, 23, 40, 23, 40, 25736 },
-		{ TRUE_20, FALSE, WLAN_PHY_HT_20_DS, 78000, /* 78 Mb */
+		{ VALID_20, INVALID, WLAN_RC_PHY_HT_20_DS, 78000, /* 78 Mb */
 			69500, 0x8c, 0x00, 12,
 			8, 14, 3, 24, 41, 24, 41, 38600 },
-		{ TRUE_20, FALSE, WLAN_PHY_HT_20_DS, 104000, /* 104 Mb */
+		{ VALID_20, INVALID, WLAN_RC_PHY_HT_20_DS, 104000, /* 104 Mb */
 			89500, 0x8d, 0x00, 13,
 			8, 20, 3, 25, 42, 25, 42, 51472 },
-		{ TRUE_20, FALSE, WLAN_PHY_HT_20_DS, 117000, /* 117 Mb */
+		{ VALID_20, INVALID, WLAN_RC_PHY_HT_20_DS, 117000, /* 117 Mb */
 			98900, 0x8e, 0x00, 14,
 			8, 23, 3, 26, 43, 26, 44, 57890 },
-		{ TRUE_20, FALSE, WLAN_PHY_HT_20_DS, 130000, /* 130 Mb */
+		{ VALID_20, INVALID, WLAN_RC_PHY_HT_20_DS, 130000, /* 130 Mb */
 			108300, 0x8f, 0x00, 15,
 			8, 25, 3, 27, 44, 27, 45, 64320 },
-		{ TRUE_40, TRUE_40, WLAN_PHY_HT_40_SS, 13500, /* 13.5 Mb */
+		{ VALID_40, VALID_40, WLAN_RC_PHY_HT_40_SS, 13500, /* 13.5 Mb */
 			13200, 0x80, 0x00, 0,
 			8, 2, 3, 12, 28, 28, 28, 6684 },
-		{ TRUE_40, TRUE_40, WLAN_PHY_HT_40_SS, 27500, /* 27.0 Mb */
+		{ VALID_40, VALID_40, WLAN_RC_PHY_HT_40_SS, 27500, /* 27.0 Mb */
 			25900, 0x81, 0x00, 1,
 			8, 4, 3, 13, 29, 29, 29, 13368 },
-		{ TRUE_40, TRUE_40, WLAN_PHY_HT_40_SS, 40500, /* 40.5 Mb */
+		{ VALID_40, VALID_40, WLAN_RC_PHY_HT_40_SS, 40500, /* 40.5 Mb */
 			38600, 0x82, 0x00, 2,
 			8, 6, 3, 14, 30, 30, 30, 20052 },
-		{ TRUE_40, TRUE_40, WLAN_PHY_HT_40_SS, 54000, /* 54 Mb */
+		{ VALID_40, VALID_40, WLAN_RC_PHY_HT_40_SS, 54000, /* 54 Mb */
 			49800, 0x83, 0x00, 3,
 			8, 10, 3, 15, 31, 31, 31, 26738 },
-		{ TRUE_40, TRUE_40, WLAN_PHY_HT_40_SS, 81500, /* 81 Mb */
+		{ VALID_40, VALID_40, WLAN_RC_PHY_HT_40_SS, 81500, /* 81 Mb */
 			72200, 0x84, 0x00, 4,
 			8, 14, 3, 16, 32, 32, 32, 40104 },
-		{ FALSE, TRUE_40, WLAN_PHY_HT_40_SS, 108000, /* 108 Mb */
+		{ INVALID, VALID_40, WLAN_RC_PHY_HT_40_SS, 108000, /* 108 Mb */
 			92900, 0x85, 0x00, 5,
 			8, 20, 3, 17, 33, 33, 33, 53476 },
-		{ FALSE,  TRUE_40, WLAN_PHY_HT_40_SS, 121500, /* 121.5 Mb */
+		{ INVALID,  VALID_40, WLAN_RC_PHY_HT_40_SS, 121500, /* 121.5 Mb */
 			102700, 0x86, 0x00, 6,
 			8, 23, 3, 18, 34, 34, 34, 60156 },
-		{ FALSE, TRUE_40, WLAN_PHY_HT_40_SS, 135000, /* 135 Mb */
+		{ INVALID, VALID_40, WLAN_RC_PHY_HT_40_SS, 135000, /* 135 Mb */
 			112000, 0x87, 0x00, 7,
 			8, 23, 3, 19, 35, 36, 36, 66840 },
-		{ FALSE, TRUE_40, WLAN_PHY_HT_40_SS_HGI, 150000, /* 150 Mb */
+		{ INVALID, VALID_40, WLAN_RC_PHY_HT_40_SS_HGI, 150000, /* 150 Mb */
 			122000, 0x87, 0x00, 7,
 			8, 25, 3, 19, 35, 36, 36, 74200 },
-		{ FALSE, FALSE, WLAN_PHY_HT_40_DS, 27000, /* 27 Mb */
+		{ INVALID, INVALID, WLAN_RC_PHY_HT_40_DS, 27000, /* 27 Mb */
 			25800, 0x88, 0x00, 8,
 			8, 2, 3, 20, 37, 37, 37, 13360 },
-		{ FALSE, FALSE, WLAN_PHY_HT_40_DS, 54000, /* 54 Mb */
+		{ INVALID, INVALID, WLAN_RC_PHY_HT_40_DS, 54000, /* 54 Mb */
 			49800, 0x89, 0x00, 9,
 			8, 4, 3, 21, 38, 38, 38, 26720 },
-		{ FALSE, FALSE, WLAN_PHY_HT_40_DS, 81000, /* 81 Mb */
+		{ INVALID, INVALID, WLAN_RC_PHY_HT_40_DS, 81000, /* 81 Mb */
 			71900, 0x8a, 0x00, 10,
 			8, 6, 3, 22, 39, 39, 39, 40080 },
-		{ TRUE_40, FALSE, WLAN_PHY_HT_40_DS, 108000, /* 108 Mb */
+		{ VALID_40, INVALID, WLAN_RC_PHY_HT_40_DS, 108000, /* 108 Mb */
 			92500, 0x8b, 0x00, 11,
 			8, 10, 3, 23, 40, 40, 40, 53440 },
-		{ TRUE_40, FALSE, WLAN_PHY_HT_40_DS, 162000, /* 162 Mb */
+		{ VALID_40, INVALID, WLAN_RC_PHY_HT_40_DS, 162000, /* 162 Mb */
 			130300, 0x8c, 0x00, 12,
 			8, 14, 3, 24, 41, 41, 41, 80160 },
-		{ TRUE_40, FALSE, WLAN_PHY_HT_40_DS, 216000, /* 216 Mb */
+		{ VALID_40, INVALID, WLAN_RC_PHY_HT_40_DS, 216000, /* 216 Mb */
 			162800, 0x8d, 0x00, 13,
 			8, 20, 3, 25, 42, 42, 42, 106880 },
-		{ TRUE_40, FALSE, WLAN_PHY_HT_40_DS, 243000, /* 243 Mb */
+		{ VALID_40, INVALID, WLAN_RC_PHY_HT_40_DS, 243000, /* 243 Mb */
 			178200, 0x8e, 0x00, 14,
 			8, 23, 3, 26, 43, 43, 43, 120240 },
-		{ TRUE_40, FALSE, WLAN_PHY_HT_40_DS, 270000, /* 270 Mb */
+		{ VALID_40, INVALID, WLAN_RC_PHY_HT_40_DS, 270000, /* 270 Mb */
 			192100, 0x8f, 0x00, 15,
 			8, 23, 3, 27, 44, 45, 45, 133600 },
-		{ TRUE_40, FALSE, WLAN_PHY_HT_40_DS_HGI, 300000, /* 300 Mb */
+		{ VALID_40, INVALID, WLAN_RC_PHY_HT_40_DS_HGI, 300000, /* 300 Mb */
 			207000, 0x8f, 0x00, 15,
 			8, 25, 3, 27, 44, 45, 45, 148400 },
 		},
@@ -319,28 +313,28 @@ static struct ath_rate_table ar5416_11a_ratetable = {
 	8,
 	{0},
 	{
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 6000, /* 6 Mb */
+		{ VALID, VALID, WLAN_RC_PHY_OFDM, 6000, /* 6 Mb */
 			5400, 0x0b, 0x00, (0x80|12),
 			0, 2, 1, 0, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 9000, /* 9 Mb */
+		{ VALID, VALID, WLAN_RC_PHY_OFDM, 9000, /* 9 Mb */
 			7800, 0x0f, 0x00, 18,
 			0, 3, 1, 1, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 12000, /* 12 Mb */
+		{ VALID, VALID, WLAN_RC_PHY_OFDM, 12000, /* 12 Mb */
 			10000, 0x0a, 0x00, (0x80|24),
 			2, 4, 2, 2, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 18000, /* 18 Mb */
+		{ VALID, VALID, WLAN_RC_PHY_OFDM, 18000, /* 18 Mb */
 			13900, 0x0e, 0x00, 36,
 			2, 6, 2, 3, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 24000, /* 24 Mb */
+		{ VALID, VALID, WLAN_RC_PHY_OFDM, 24000, /* 24 Mb */
 			17300, 0x09, 0x00, (0x80|48),
 			4, 10, 3, 4, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 36000, /* 36 Mb */
+		{ VALID, VALID, WLAN_RC_PHY_OFDM, 36000, /* 36 Mb */
 			23000, 0x0d, 0x00, 72,
 			4, 14, 3, 5, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 48000, /* 48 Mb */
+		{ VALID, VALID, WLAN_RC_PHY_OFDM, 48000, /* 48 Mb */
 			27400, 0x08, 0x00, 96,
 			4, 19, 3, 6, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 54000, /* 54 Mb */
+		{ VALID, VALID, WLAN_RC_PHY_OFDM, 54000, /* 54 Mb */
 			29300, 0x0c, 0x00, 108,
 			4, 23, 3, 7, 0 },
 	},
@@ -353,40 +347,40 @@ static struct ath_rate_table ar5416_11g_ratetable = {
 	12,
 	{0},
 	{
-		{ TRUE, TRUE, WLAN_PHY_CCK, 1000, /* 1 Mb */
+		{ VALID, VALID, WLAN_RC_PHY_CCK, 1000, /* 1 Mb */
 			900, 0x1b, 0x00, 2,
 			0, 0, 1, 0, 0 },
-		{ TRUE, TRUE, WLAN_PHY_CCK, 2000, /* 2 Mb */
+		{ VALID, VALID, WLAN_RC_PHY_CCK, 2000, /* 2 Mb */
 			1900, 0x1a, 0x04, 4,
 			1, 1, 1, 1, 0 },
-		{ TRUE, TRUE, WLAN_PHY_CCK, 5500, /* 5.5 Mb */
+		{ VALID, VALID, WLAN_RC_PHY_CCK, 5500, /* 5.5 Mb */
 			4900, 0x19, 0x04, 11,
 			2, 2, 2, 2, 0 },
-		{ TRUE, TRUE, WLAN_PHY_CCK, 11000, /* 11 Mb */
+		{ VALID, VALID, WLAN_RC_PHY_CCK, 11000, /* 11 Mb */
 			8100, 0x18, 0x04, 22,
 			3, 3, 2, 3, 0 },
-		{ FALSE, FALSE, WLAN_PHY_OFDM, 6000, /* 6 Mb */
+		{ INVALID, INVALID, WLAN_RC_PHY_OFDM, 6000, /* 6 Mb */
 			5400, 0x0b, 0x00, 12,
 			4, 2, 1, 4, 0 },
-		{ FALSE, FALSE, WLAN_PHY_OFDM, 9000, /* 9 Mb */
+		{ INVALID, INVALID, WLAN_RC_PHY_OFDM, 9000, /* 9 Mb */
 			7800, 0x0f, 0x00, 18,
 			4, 3, 1, 5, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 12000, /* 12 Mb */
+		{ VALID, VALID, WLAN_RC_PHY_OFDM, 12000, /* 12 Mb */
 			10000, 0x0a, 0x00, 24,
 			6, 4, 1, 6, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 18000, /* 18 Mb */
+		{ VALID, VALID, WLAN_RC_PHY_OFDM, 18000, /* 18 Mb */
 			13900, 0x0e, 0x00, 36,
 			6, 6, 2, 7, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 24000, /* 24 Mb */
+		{ VALID, VALID, WLAN_RC_PHY_OFDM, 24000, /* 24 Mb */
 			17300, 0x09, 0x00, 48,
 			8, 10, 3, 8, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 36000, /* 36 Mb */
+		{ VALID, VALID, WLAN_RC_PHY_OFDM, 36000, /* 36 Mb */
 			23000, 0x0d, 0x00, 72,
 			8, 14, 3, 9, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 48000, /* 48 Mb */
+		{ VALID, VALID, WLAN_RC_PHY_OFDM, 48000, /* 48 Mb */
 			27400, 0x08, 0x00, 96,
 			8, 19, 3, 10, 0 },
-		{ TRUE, TRUE, WLAN_PHY_OFDM, 54000, /* 54 Mb */
+		{ VALID, VALID, WLAN_RC_PHY_OFDM, 54000, /* 54 Mb */
 			29300, 0x0c, 0x00, 108,
 			8, 23, 3, 11, 0 },
 	},
@@ -399,16 +393,16 @@ static struct ath_rate_table ar5416_11b_ratetable = {
 	4,
 	{0},
 	{
-		{ TRUE, TRUE, WLAN_PHY_CCK, 1000, /* 1 Mb */
+		{ VALID, VALID, WLAN_RC_PHY_CCK, 1000, /* 1 Mb */
 			900, 0x1b,  0x00, (0x80|2),
 			0, 0, 1, 0, 0 },
-		{ TRUE, TRUE, WLAN_PHY_CCK, 2000, /* 2 Mb */
+		{ VALID, VALID, WLAN_RC_PHY_CCK, 2000, /* 2 Mb */
 			1800, 0x1a, 0x04, (0x80|4),
 			1, 1, 1, 1, 0 },
-		{ TRUE, TRUE, WLAN_PHY_CCK, 5500, /* 5.5 Mb */
+		{ VALID, VALID, WLAN_RC_PHY_CCK, 5500, /* 5.5 Mb */
 			4300, 0x19, 0x04, (0x80|11),
 			1, 2, 2, 2, 0 },
-		{ TRUE, TRUE, WLAN_PHY_CCK, 11000, /* 11 Mb */
+		{ VALID, VALID, WLAN_RC_PHY_CCK, 11000, /* 11 Mb */
 			7100, 0x18, 0x04, (0x80|22),
 			1, 4, 100, 3, 0 },
 	},
@@ -417,9 +411,6 @@ static struct ath_rate_table ar5416_11b_ratetable = {
 	0,   /* Phy rates allowed initially */
 };
 
-/*
- * Return the median of three numbers
- */
 static inline int8_t median(int8_t a, int8_t b, int8_t c)
 {
 	if (a >= b) {
@@ -440,7 +431,7 @@ static inline int8_t median(int8_t a, int8_t b, int8_t c)
 }
 
 static void ath_rc_sort_validrates(struct ath_rate_table *rate_table,
-				   struct ath_rate_node *ath_rc_priv)
+				   struct ath_rate_priv *ath_rc_priv)
 {
 	u8 i, j, idx, idx_next;
 
@@ -458,34 +449,31 @@ static void ath_rc_sort_validrates(struct ath_rate_table *rate_table,
 	}
 }
 
-/* Access functions for valid_txrate_mask */
-
-static void ath_rc_init_valid_txmask(struct ath_rate_node *ath_rc_priv)
+static void ath_rc_init_valid_txmask(struct ath_rate_priv *ath_rc_priv)
 {
 	u8 i;
 
 	for (i = 0; i < ath_rc_priv->rate_table_size; i++)
-		ath_rc_priv->valid_rate_index[i] = FALSE;
+		ath_rc_priv->valid_rate_index[i] = 0;
 }
 
-static inline void ath_rc_set_valid_txmask(struct ath_rate_node *ath_rc_priv,
+static inline void ath_rc_set_valid_txmask(struct ath_rate_priv *ath_rc_priv,
 					   u8 index, int valid_tx_rate)
 {
 	ASSERT(index <= ath_rc_priv->rate_table_size);
-	ath_rc_priv->valid_rate_index[index] = valid_tx_rate ? TRUE : FALSE;
+	ath_rc_priv->valid_rate_index[index] = valid_tx_rate ? 1 : 0;
 }
 
-static inline int ath_rc_isvalid_txmask(struct ath_rate_node *ath_rc_priv,
+static inline int ath_rc_isvalid_txmask(struct ath_rate_priv *ath_rc_priv,
 					u8 index)
 {
 	ASSERT(index <= ath_rc_priv->rate_table_size);
 	return ath_rc_priv->valid_rate_index[index];
 }
 
-/* Iterators for valid_txrate_mask */
 static inline int
 ath_rc_get_nextvalid_txrate(struct ath_rate_table *rate_table,
-			    struct ath_rate_node *ath_rc_priv,
+			    struct ath_rate_priv *ath_rc_priv,
 			    u8 cur_valid_txrate,
 			    u8 *next_idx)
 {
@@ -494,13 +482,13 @@ ath_rc_get_nextvalid_txrate(struct ath_rate_table *rate_table,
 	for (i = 0; i < ath_rc_priv->max_valid_rate - 1; i++) {
 		if (ath_rc_priv->valid_rate_index[i] == cur_valid_txrate) {
 			*next_idx = ath_rc_priv->valid_rate_index[i+1];
-			return TRUE;
+			return 1;
 		}
 	}
 
 	/* No more valid rates */
 	*next_idx = 0;
-	return FALSE;
+	return 0;
 }
 
 /* Return true only for single stream */
@@ -508,22 +496,22 @@ ath_rc_get_nextvalid_txrate(struct ath_rate_table *rate_table,
 static int ath_rc_valid_phyrate(u32 phy, u32 capflag, int ignore_cw)
 {
 	if (WLAN_RC_PHY_HT(phy) & !(capflag & WLAN_RC_HT_FLAG))
-		return FALSE;
+		return 0;
 	if (WLAN_RC_PHY_DS(phy) && !(capflag & WLAN_RC_DS_FLAG))
-		return FALSE;
+		return 0;
 	if (WLAN_RC_PHY_SGI(phy) && !(capflag & WLAN_RC_SGI_FLAG))
-		return FALSE;
+		return 0;
 	if (!ignore_cw && WLAN_RC_PHY_HT(phy))
 		if (WLAN_RC_PHY_40(phy) && !(capflag & WLAN_RC_40_FLAG))
-			return FALSE;
+			return 0;
 		if (!WLAN_RC_PHY_40(phy) && (capflag & WLAN_RC_40_FLAG))
-			return FALSE;
-	return TRUE;
+			return 0;
+	return 1;
 }
 
 static inline int
 ath_rc_get_nextlowervalid_txrate(struct ath_rate_table *rate_table,
-				 struct ath_rate_node *ath_rc_priv,
+				 struct ath_rate_priv *ath_rc_priv,
 				 u8 cur_valid_txrate, u8 *next_idx)
 {
 	int8_t i;
@@ -531,17 +519,14 @@ ath_rc_get_nextlowervalid_txrate(struct ath_rate_table *rate_table,
 	for (i = 1; i < ath_rc_priv->max_valid_rate ; i++) {
 		if (ath_rc_priv->valid_rate_index[i] == cur_valid_txrate) {
 			*next_idx = ath_rc_priv->valid_rate_index[i-1];
-			return TRUE;
+			return 1;
 		}
 	}
-	return FALSE;
+	return 0;
 }
 
-/*
- * Initialize the Valid Rate Index from valid entries in Rate Table
- */
 static u8
-ath_rc_sib_init_validrates(struct ath_rate_node *ath_rc_priv,
+ath_rc_sib_init_validrates(struct ath_rate_priv *ath_rc_priv,
 			   struct ath_rate_table *rate_table,
 			   u32 capflag)
 {
@@ -552,34 +537,30 @@ ath_rc_sib_init_validrates(struct ath_rate_node *ath_rc_priv,
 		valid = (ath_rc_priv->single_stream ?
 			 rate_table->info[i].valid_single_stream :
 			 rate_table->info[i].valid);
-		if (valid == TRUE) {
+		if (valid == 1) {
 			u32 phy = rate_table->info[i].phy;
 			u8 valid_rate_count = 0;
 
-			if (!ath_rc_valid_phyrate(phy, capflag, FALSE))
+			if (!ath_rc_valid_phyrate(phy, capflag, 0))
 				continue;
 
 			valid_rate_count = ath_rc_priv->valid_phy_ratecnt[phy];
 
 			ath_rc_priv->valid_phy_rateidx[phy][valid_rate_count] = i;
 			ath_rc_priv->valid_phy_ratecnt[phy] += 1;
-			ath_rc_set_valid_txmask(ath_rc_priv, i, TRUE);
+			ath_rc_set_valid_txmask(ath_rc_priv, i, 1);
 			hi = A_MAX(hi, i);
 		}
 	}
 	return hi;
 }
 
-/*
- * Initialize the Valid Rate Index from Rate Set
- */
 static u8
-ath_rc_sib_setvalid_rates(struct ath_rate_node *ath_rc_priv,
+ath_rc_sib_setvalid_rates(struct ath_rate_priv *ath_rc_priv,
 			  struct ath_rate_table *rate_table,
 			  struct ath_rateset *rateset,
 			  u32 capflag)
 {
-	/* XXX: Clean me up and make identation friendly */
 	u8 i, j, hi = 0;
 
 	/* Use intersection of working rates and valid rates */
@@ -592,10 +573,8 @@ ath_rc_sib_setvalid_rates(struct ath_rate_node *ath_rc_priv,
 
 			/* We allow a rate only if its valid and the
 			 * capflag matches one of the validity
-			 * (TRUE/TRUE_20/TRUE_40) flags */
+			 * (VALID/VALID_20/VALID_40) flags */
 
-			/* XXX: catch the negative of this branch
-			 * first and then continue */
 			if (((rateset->rs_rates[i] & 0x7F) ==
 				(rate_table->info[j].dot11rate & 0x7F)) &&
 				((valid & WLAN_RC_CAP_MODE(capflag)) ==
@@ -604,7 +583,7 @@ ath_rc_sib_setvalid_rates(struct ath_rate_node *ath_rc_priv,
 
 				u8 valid_rate_count = 0;
 
-				if (!ath_rc_valid_phyrate(phy, capflag, FALSE))
+				if (!ath_rc_valid_phyrate(phy, capflag, 0))
 					continue;
 
 				valid_rate_count =
@@ -613,7 +592,7 @@ ath_rc_sib_setvalid_rates(struct ath_rate_node *ath_rc_priv,
 				ath_rc_priv->valid_phy_rateidx[phy]
 					[valid_rate_count] = j;
 				ath_rc_priv->valid_phy_ratecnt[phy] += 1;
-				ath_rc_set_valid_txmask(ath_rc_priv, j, TRUE);
+				ath_rc_set_valid_txmask(ath_rc_priv, j, 1);
 				hi = A_MAX(hi, j);
 			}
 		}
@@ -622,7 +601,7 @@ ath_rc_sib_setvalid_rates(struct ath_rate_node *ath_rc_priv,
 }
 
 static u8
-ath_rc_sib_setvalid_htrates(struct ath_rate_node *ath_rc_priv,
+ath_rc_sib_setvalid_htrates(struct ath_rate_priv *ath_rc_priv,
 			    struct ath_rate_table *rate_table,
 			    u8 *mcs_set, u32 capflag)
 {
@@ -643,13 +622,13 @@ ath_rc_sib_setvalid_htrates(struct ath_rate_node *ath_rc_priv,
 			    !WLAN_RC_PHY_HT_VALID(valid, capflag))
 				continue;
 
-			if (!ath_rc_valid_phyrate(phy, capflag, FALSE))
+			if (!ath_rc_valid_phyrate(phy, capflag, 0))
 				continue;
 
 			ath_rc_priv->valid_phy_rateidx[phy]
 				[ath_rc_priv->valid_phy_ratecnt[phy]] = j;
 			ath_rc_priv->valid_phy_ratecnt[phy] += 1;
-			ath_rc_set_valid_txmask(ath_rc_priv, j, TRUE);
+			ath_rc_set_valid_txmask(ath_rc_priv, j, 1);
 			hi = A_MAX(hi, j);
 		}
 	}
@@ -676,7 +655,7 @@ u8 ath_rate_findrateix(struct ath_softc *sc,
 }
 
 static u8 ath_rc_ratefind_ht(struct ath_softc *sc,
-			     struct ath_rate_node *ath_rc_priv,
+			     struct ath_rate_priv *ath_rc_priv,
 			     struct ath_rate_table *rate_table,
 			     int probe_allowed, int *is_probing,
 			     int is_retry)
@@ -685,7 +664,7 @@ static u8 ath_rc_ratefind_ht(struct ath_softc *sc,
 	u8 rate, next_rate, best_rate, maxindex, minindex;
 	int8_t  rssi_last, rssi_reduce = 0, index = 0;
 
-	*is_probing = FALSE;
+	*is_probing = 0;
 
 	rssi_last = median(ath_rc_priv->rssi_last,
 			   ath_rc_priv->rssi_last_prev,
@@ -789,16 +768,10 @@ static u8 ath_rc_ratefind_ht(struct ath_softc *sc,
 			ath_rc_priv->probe_rate = rate;
 			ath_rc_priv->probe_time = now_msec;
 			ath_rc_priv->hw_maxretry_pktcnt = 0;
-			*is_probing = TRUE;
+			*is_probing = 1;
 		}
 	}
 
-	/*
-	 * Make sure rate is not higher than the allowed maximum.
-	 * We should also enforce the min, but I suspect the min is
-	 * normally 1 rather than 0 because of the rate 9 vs 6 issue
-	 * in the old code.
-	 */
 	if (rate > (ath_rc_priv->rate_table_size - 1))
 		rate = ath_rc_priv->rate_table_size - 1;
 
@@ -829,7 +802,7 @@ static void ath_rc_rate_set_series(struct ath_rate_table *rate_table ,
 }
 
 static u8 ath_rc_rate_getidx(struct ath_softc *sc,
-			     struct ath_rate_node *ath_rc_priv,
+			     struct ath_rate_priv *ath_rc_priv,
 			     struct ath_rate_table *rate_table,
 			     u8 rix, u16 stepdown,
 			     u16 min_rate)
@@ -858,8 +831,8 @@ static u8 ath_rc_rate_getidx(struct ath_softc *sc,
 }
 
 static void ath_rc_ratefind(struct ath_softc *sc,
-			    struct ath_rate_node *ath_rc_priv,
-			    int num_tries, int num_rates, unsigned int rcflag,
+			    struct ath_rate_priv *ath_rc_priv,
+			    int num_tries, int num_rates,
 			    struct ieee80211_tx_info *tx_info, int *is_probe,
 			    int is_retry)
 {
@@ -868,30 +841,29 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 	struct ieee80211_tx_rate *rates = tx_info->control.rates;
 
 	rate_table = sc->hw_rate_table[sc->sc_curmode];
-	rix = ath_rc_ratefind_ht(sc, ath_rc_priv, rate_table,
-				 (rcflag & ATH_RC_PROBE_ALLOWED) ? 1 : 0,
+	rix = ath_rc_ratefind_ht(sc, ath_rc_priv, rate_table, 1,
 				 is_probe, is_retry);
 	nrix = rix;
 
-	if ((rcflag & ATH_RC_PROBE_ALLOWED) && (*is_probe)) {
+	if (*is_probe) {
 		/* set one try for probe rates. For the
 		 * probes don't enable rts */
 		ath_rc_rate_set_series(rate_table,
-			&rates[i++], 1, nrix, FALSE);
+			&rates[i++], 1, nrix, 0);
 
 		try_per_rate = (num_tries/num_rates);
 		/* Get the next tried/allowed rate. No RTS for the next series
 		 * after the probe rate
 		 */
 		nrix = ath_rc_rate_getidx(sc,
-			ath_rc_priv, rate_table, nrix, 1, FALSE);
+			ath_rc_priv, rate_table, nrix, 1, 0);
 		ath_rc_rate_set_series(rate_table,
 			&rates[i++], try_per_rate, nrix, 0);
 	} else {
 		try_per_rate = (num_tries/num_rates);
 		/* Set the choosen rate. No RTS for first series entry. */
 		ath_rc_rate_set_series(rate_table,
-			&rates[i++], try_per_rate, nrix, FALSE);
+			&rates[i++], try_per_rate, nrix, 0);
 	}
 
 	/* Fill in the other rates for multirate retry */
@@ -901,14 +873,13 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 
 		try_num = ((i + 1) == num_rates) ?
 			num_tries - (try_per_rate * i) : try_per_rate ;
-		min_rate = (((i + 1) == num_rates) &&
-			    (rcflag & ATH_RC_MINRATE_LASTRATE)) ? 1 : 0;
+		min_rate = (((i + 1) == num_rates) && 0);
 
 		nrix = ath_rc_rate_getidx(sc, ath_rc_priv,
 					  rate_table, nrix, 1, min_rate);
 		/* All other rates in the series have RTS enabled */
 		ath_rc_rate_set_series(rate_table,
-				       &rates[i], try_num, nrix, TRUE);
+				       &rates[i], try_num, nrix, 1);
 	}
 
 	/*
@@ -940,32 +911,13 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 	}
 }
 
-/*
- * Return the Tx rate series.
- */
-static void ath_rate_findrate(struct ath_softc *sc,
-			      struct ath_rate_node *ath_rc_priv,
-			      int num_tries,
-			      int num_rates,
-			      unsigned int rcflag,
-			      struct ieee80211_tx_info *tx_info,
-			      int *is_probe,
-			      int is_retry)
-{
-	if (!num_rates || !num_tries)
-		return;
-
-	ath_rc_ratefind(sc, ath_rc_priv, num_tries, num_rates,
-			rcflag, tx_info, is_probe, is_retry);
-}
-
 static void ath_rc_update_ht(struct ath_softc *sc,
-			     struct ath_rate_node *ath_rc_priv,
-			     struct ath_tx_info_priv *info_priv,
+			     struct ath_rate_priv *ath_rc_priv,
+			     struct ath_tx_info_priv *tx_info_priv,
 			     int tx_rate, int xretries, int retries)
 {
 	u32 now_msec = jiffies_to_msecs(jiffies);
-	int state_change = FALSE, rate, count;
+	int state_change = 0, rate, count;
 	u8 last_per;
 	struct ath_rate_table *rate_table = sc->hw_rate_table[sc->sc_curmode];
 	static u32 nretry_to_per_lookup[10] = {
@@ -991,9 +943,9 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 	/* To compensate for some imbalance between ctrl and ext. channel */
 
 	if (WLAN_RC_PHY_40(rate_table->info[tx_rate].phy))
-		info_priv->tx.ts_rssi =
-			info_priv->tx.ts_rssi < 3 ? 0 :
-			info_priv->tx.ts_rssi - 3;
+		tx_info_priv->tx.ts_rssi =
+			tx_info_priv->tx.ts_rssi < 3 ? 0 :
+			tx_info_priv->tx.ts_rssi - 3;
 
 	last_per = ath_rc_priv->state[tx_rate].per;
 
@@ -1026,7 +978,7 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 		count = ARRAY_SIZE(nretry_to_per_lookup);
 		if (retries >= count)
 			retries = count - 1;
-		if (info_priv->n_bad_frames) {
+		if (tx_info_priv->n_bad_frames) {
 			/* new_PER = 7/8*old_PER + 1/8*(currentPER)
 			 * Assuming that n_frames is not 0.  The current PER
 			 * from the retries is 100 * retries / (retries+1),
@@ -1039,14 +991,14 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 			 * the above PER.  The expression below is a
 			 * simplified version of the sum of these two terms.
 			 */
-			if (info_priv->n_frames > 0)
+			if (tx_info_priv->n_frames > 0)
 				ath_rc_priv->state[tx_rate].per
 				      = (u8)
 					(ath_rc_priv->state[tx_rate].per -
 					(ath_rc_priv->state[tx_rate].per >> 3) +
-					((100*(retries*info_priv->n_frames +
-					info_priv->n_bad_frames) /
-					(info_priv->n_frames *
+					((100*(retries*tx_info_priv->n_frames +
+					tx_info_priv->n_bad_frames) /
+					(tx_info_priv->n_frames *
 						(retries+1))) >> 3));
 		} else {
 			/* new_PER = 7/8*old_PER + 1/8*(currentPER) */
@@ -1059,7 +1011,7 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 
 		ath_rc_priv->rssi_last_prev2 = ath_rc_priv->rssi_last_prev;
 		ath_rc_priv->rssi_last_prev  = ath_rc_priv->rssi_last;
-		ath_rc_priv->rssi_last = info_priv->tx.ts_rssi;
+		ath_rc_priv->rssi_last = tx_info_priv->tx.ts_rssi;
 		ath_rc_priv->rssi_time = now_msec;
 
 		/*
@@ -1068,8 +1020,8 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 		 */
 
 		if (ath_rc_priv->probe_rate && ath_rc_priv->probe_rate == tx_rate) {
-			if (retries > 0 || 2 * info_priv->n_bad_frames >
-				info_priv->n_frames) {
+			if (retries > 0 || 2 * tx_info_priv->n_bad_frames >
+				tx_info_priv->n_frames) {
 				/*
 				 * Since we probed with just a single attempt,
 				 * any retries means the probe failed.  Also,
@@ -1121,7 +1073,7 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 				ath_rc_priv->hw_maxretry_pktcnt++;
 			}
 
-			if (info_priv->tx.ts_rssi >=
+			if (tx_info_priv->tx.ts_rssi >=
 				rate_table->info[tx_rate].rssi_ack_validmin) {
 				/* Average the rssi */
 				if (tx_rate != ath_rc_priv->rssi_sum_rate) {
@@ -1130,7 +1082,7 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 						ath_rc_priv->rssi_sum_cnt = 0;
 				}
 
-				ath_rc_priv->rssi_sum += info_priv->tx.ts_rssi;
+				ath_rc_priv->rssi_sum += tx_info_priv->tx.ts_rssi;
 				ath_rc_priv->rssi_sum_cnt++;
 
 				if (ath_rc_priv->rssi_sum_cnt > 4) {
@@ -1154,7 +1106,7 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 							rssi_thres--;
 					}
 
-					state_change = TRUE;
+					state_change = 1;
 				}
 			}
 		}
@@ -1282,17 +1234,12 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 	}
 }
 
-/*
- * This routine is called in rate control callback tx_status() to give
- * the status of previous frames.
- */
-static void ath_rc_update(struct ath_softc *sc,
-			  struct ath_rate_node *ath_rc_priv,
-			  struct ieee80211_tx_info *tx_info, int final_ts_idx,
-			  int xretries, int long_retry)
+static void ath_rc_tx_status(struct ath_softc *sc,
+			     struct ath_rate_priv *ath_rc_priv,
+			     struct ieee80211_tx_info *tx_info,
+			     int final_ts_idx, int xretries, int long_retry)
 {
-	struct ath_tx_info_priv *info_priv =
-		(struct ath_tx_info_priv *)tx_info->rate_driver_data[0];
+	struct ath_tx_info_priv *tx_info_priv = ATH_TX_INFO_PRIV(tx_info);
 	struct ath_rate_table *rate_table;
 	struct ieee80211_tx_rate *rates = tx_info->status.rates;
 	u8 flags;
@@ -1329,7 +1276,7 @@ static void ath_rc_update(struct ath_softc *sc,
 					rix = rate_table->info[
 						rates[series].idx].base_index;
 				ath_rc_update_ht(sc, ath_rc_priv,
-						info_priv, rix,
+						tx_info_priv, rix,
 						xretries ? 1 : 2,
 						rates[series].count);
 			}
@@ -1361,55 +1308,12 @@ static void ath_rc_update(struct ath_softc *sc,
 	else
 		rix = rate_table->info[rates[series].idx].base_index;
 
-	ath_rc_update_ht(sc, ath_rc_priv, info_priv, rix,
+	ath_rc_update_ht(sc, ath_rc_priv, tx_info_priv, rix,
 		xretries, long_retry);
 }
 
-/*
- * Process a tx descriptor for a completed transmit (success or failure).
- */
-static void ath_rate_tx_complete(struct ath_softc *sc,
-				 struct ath_node *an,
-				 struct ath_rate_node *rc_priv,
-				 struct ieee80211_tx_info *tx_info)
-{
-	struct ath_tx_info_priv *info_priv =
-		(struct ath_tx_info_priv *)tx_info->rate_driver_data[0];
-	int final_ts_idx = info_priv->tx.ts_rateindex;
-	int tx_status = 0, is_underrun = 0;
-
-	if (info_priv->tx.ts_status & ATH9K_TXERR_FILT)
-		return;
-
-	if (info_priv->tx.ts_rssi > 0) {
-		ATH_RSSI_LPF(an->an_chainmask_sel.tx_avgrssi,
-			     info_priv->tx.ts_rssi);
-	}
-
-	/*
-	 * If underrun error is seen assume it as an excessive retry only
-	 * if prefetch trigger level have reached the max (0x3f for 5416)
-	 * Adjust the long retry as if the frame was tried ATH_11N_TXMAXTRY
-	 * times. This affects how ratectrl updates PER for the failed rate.
-	 */
-	if (info_priv->tx.ts_flags &
-		(ATH9K_TX_DATA_UNDERRUN | ATH9K_TX_DELIM_UNDERRUN) &&
-		((sc->sc_ah->ah_txTrigLevel) >= rc_priv->tx_triglevel_max)) {
-		tx_status = 1;
-		is_underrun = 1;
-	}
-
-	if ((info_priv->tx.ts_status & ATH9K_TXERR_XRETRY) ||
-			(info_priv->tx.ts_status & ATH9K_TXERR_FIFO))
-		tx_status = 1;
-
-	ath_rc_update(sc, rc_priv, tx_info, final_ts_idx, tx_status,
-		      (is_underrun) ? ATH_11N_TXMAXTRY :
-		      info_priv->tx.ts_longretry);
-}
-
 static void ath_rc_init(struct ath_softc *sc,
-			struct ath_rate_node *ath_rc_priv,
+			struct ath_rate_priv *ath_rc_priv,
 			struct ieee80211_supported_band *sband,
 			struct ieee80211_sta *sta)
 {
@@ -1427,13 +1331,14 @@ static void ath_rc_init(struct ath_softc *sc,
 			rate_table = sc->hw_rate_table[ATH9K_MODE_11NA_HT20];
 
 		ath_rc_priv->ht_cap = (WLAN_RC_HT_FLAG | WLAN_RC_DS_FLAG);
+
 		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
 			ath_rc_priv->ht_cap |= WLAN_RC_40_FLAG;
 	}
 
 	/* Initial rate table size. Will change depending
 	 * on the working rate set */
-	ath_rc_priv->rate_table_size = MAX_TX_RATE_TBL;
+	ath_rc_priv->rate_table_size = RATE_TABLE_SIZE;
 
 	/* Initialize thresholds according to the global rate table */
 	for (i = 0 ; i < ath_rc_priv->rate_table_size; i++) {
@@ -1474,7 +1379,7 @@ static void ath_rc_init(struct ath_softc *sc,
 
 	ath_rc_priv->rate_table_size = hi + 1;
 	ath_rc_priv->rate_max_phy = 0;
-	ASSERT(ath_rc_priv->rate_table_size <= MAX_TX_RATE_TBL);
+	ASSERT(ath_rc_priv->rate_table_size <= RATE_TABLE_SIZE);
 
 	for (i = 0, k = 0; i < WLAN_RC_PHY_MAX; i++) {
 		for (j = 0; j < ath_rc_priv->valid_phy_ratecnt[i]; j++) {
@@ -1482,21 +1387,16 @@ static void ath_rc_init(struct ath_softc *sc,
 				ath_rc_priv->valid_phy_rateidx[i][j];
 		}
 
-		if (!ath_rc_valid_phyrate(i, rate_table->initial_ratemax, TRUE)
+		if (!ath_rc_valid_phyrate(i, rate_table->initial_ratemax, 1)
 		    || !ath_rc_priv->valid_phy_ratecnt[i])
 			continue;
 
 		ath_rc_priv->rate_max_phy = ath_rc_priv->valid_phy_rateidx[i][j-1];
 	}
-	ASSERT(ath_rc_priv->rate_table_size <= MAX_TX_RATE_TBL);
-	ASSERT(k <= MAX_TX_RATE_TBL);
+	ASSERT(ath_rc_priv->rate_table_size <= RATE_TABLE_SIZE);
+	ASSERT(k <= RATE_TABLE_SIZE);
 
 	ath_rc_priv->max_valid_rate = k;
-	/*
-	 * Some third party vendors don't send the supported rate series in
-	 * order. So sorting to make sure its in order, otherwise our RateFind
-	 * Algo will select wrong rates
-	 */
 	ath_rc_sort_validrates(rate_table, ath_rc_priv);
 	ath_rc_priv->rate_max_phy = ath_rc_priv->valid_rate_index[k-4];
 }
@@ -1507,24 +1407,53 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
 			  struct sk_buff *skb)
 {
 	struct ath_softc *sc = priv;
-	struct ath_tx_info_priv *tx_info_priv;
+	struct ath_rate_priv *ath_rc_priv = priv_sta;
+	struct ath_tx_info_priv *tx_info_priv = NULL;
 	struct ath_node *an;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr;
+	int final_ts_idx, tx_status = 0, is_underrun = 0;
 	__le16 fc;
 
 	hdr = (struct ieee80211_hdr *)skb->data;
 	fc = hdr->frame_control;
-	tx_info_priv = (struct ath_tx_info_priv *)tx_info->rate_driver_data[0];
-
+	tx_info_priv = ATH_TX_INFO_PRIV(tx_info);
 	an = (struct ath_node *)sta->drv_priv;
+	final_ts_idx = tx_info_priv->tx.ts_rateindex;
 
-	if (tx_info_priv == NULL)
-		return;
+	if (!an || !priv_sta || !ieee80211_is_data(fc))
+		goto exit;
 
-	if (an && priv_sta && ieee80211_is_data(fc))
-		ath_rate_tx_complete(sc, an, priv_sta, tx_info);
+	if (tx_info_priv->tx.ts_status & ATH9K_TXERR_FILT)
+		goto exit;
 
+	if (tx_info_priv->tx.ts_rssi > 0) {
+		ATH_RSSI_LPF(an->an_chainmask_sel.tx_avgrssi,
+			     tx_info_priv->tx.ts_rssi);
+	}
+
+	/*
+	 * If underrun error is seen assume it as an excessive retry only
+	 * if prefetch trigger level have reached the max (0x3f for 5416)
+	 * Adjust the long retry as if the frame was tried ATH_11N_TXMAXTRY
+	 * times. This affects how ratectrl updates PER for the failed rate.
+	 */
+	if (tx_info_priv->tx.ts_flags &
+	    (ATH9K_TX_DATA_UNDERRUN | ATH9K_TX_DELIM_UNDERRUN) &&
+	    ((sc->sc_ah->ah_txTrigLevel) >= ath_rc_priv->tx_triglevel_max)) {
+		tx_status = 1;
+		is_underrun = 1;
+	}
+
+	if ((tx_info_priv->tx.ts_status & ATH9K_TXERR_XRETRY) ||
+	    (tx_info_priv->tx.ts_status & ATH9K_TXERR_FIFO))
+		tx_status = 1;
+
+	ath_rc_tx_status(sc, ath_rc_priv, tx_info, final_ts_idx, tx_status,
+			 (is_underrun) ? ATH_11N_TXMAXTRY :
+			 tx_info_priv->tx.ts_longretry);
+
+exit:
 	kfree(tx_info_priv);
 }
 
@@ -1536,12 +1465,10 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ath_softc *sc = priv;
 	struct ieee80211_hw *hw = sc->hw;
-	struct ath_rate_node *ath_rc_priv = priv_sta;
-	struct ath_node *an;
+	struct ath_rate_priv *ath_rc_priv = priv_sta;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-	int is_probe = FALSE;
+	int is_probe = 0;
 	__le16 fc = hdr->frame_control;
-	u8 *qc, tid;
 
 	/* lowest rate for management and multicast/broadcast frames */
 	if (!ieee80211_is_data(fc) || is_multicast_ether_addr(hdr->addr1)) {
@@ -1552,16 +1479,15 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	}
 
 	/* Find tx rate for unicast frames */
-	ath_rate_findrate(sc, ath_rc_priv,
-			  ATH_11N_TXMAXTRY, 4,
-			  ATH_RC_PROBE_ALLOWED,
-			  tx_info,
-			  &is_probe,
-			  false);
+	ath_rc_ratefind(sc, ath_rc_priv, ATH_11N_TXMAXTRY, 4,
+			tx_info, &is_probe, false);
 
 	/* Check if aggregation has to be enabled for this tid */
 	if (hw->conf.ht.enabled) {
 		if (ieee80211_is_data_qos(fc)) {
+			u8 *qc, tid;
+			struct ath_node *an;
+
 			qc = ieee80211_get_qos_ctl(hdr);
 			tid = qc[0] & 0xf;
 			an = (struct ath_node *)sta->drv_priv;
@@ -1576,7 +1502,7 @@ static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
                           struct ieee80211_sta *sta, void *priv_sta)
 {
 	struct ath_softc *sc = priv;
-	struct ath_rate_node *ath_rc_priv = priv_sta;
+	struct ath_rate_priv *ath_rc_priv = priv_sta;
 	int i, j = 0;
 
 	for (i = 0; i < sband->n_bitrates; i++) {
@@ -1614,9 +1540,9 @@ static void ath_rate_free(void *priv)
 static void *ath_rate_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp)
 {
 	struct ath_softc *sc = priv;
-	struct ath_rate_node *rate_priv;
+	struct ath_rate_priv *rate_priv;
 
-	rate_priv = kzalloc(sizeof(struct ath_rate_node), gfp);
+	rate_priv = kzalloc(sizeof(struct ath_rate_priv), gfp);
 	if (!rate_priv) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: Unable to allocate private rc structure\n",
@@ -1633,7 +1559,7 @@ static void *ath_rate_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp
 static void ath_rate_free_sta(void *priv, struct ieee80211_sta *sta,
 			      void *priv_sta)
 {
-	struct ath_rate_node *rate_priv = priv_sta;
+	struct ath_rate_priv *rate_priv = priv_sta;
 	kfree(rate_priv);
 }
 
diff --git a/drivers/net/wireless/ath9k/rc.h b/drivers/net/wireless/ath9k/rc.h
index c1e370c..dff4b7a 100644
--- a/drivers/net/wireless/ath9k/rc.h
+++ b/drivers/net/wireless/ath9k/rc.h
@@ -20,73 +20,19 @@
 #define RC_H
 
 #include "ath9k.h"
-/*
- * Interface definitions for transmit rate control modules for the
- * Atheros driver.
- *
- * A rate control module is responsible for choosing the transmit rate
- * for each data frame.  Management+control frames are always sent at
- * a fixed rate.
- *
- * Only one module may be present at a time; the driver references
- * rate control interfaces by symbol name.  If multiple modules are
- * to be supported we'll need to switch to a registration-based scheme
- * as is currently done, for example, for authentication modules.
- *
- * An instance of the rate control module is attached to each device
- * at attach time and detached when the device is destroyed.  The module
- * may associate data with each device and each node (station).  Both
- * sets of storage are opaque except for the size of the per-node storage
- * which must be provided when the module is attached.
- *
- * The rate control module is notified for each state transition and
- * station association/reassociation.  Otherwise it is queried for a
- * rate for each outgoing frame and provided status from each transmitted
- * frame.  Any ancillary processing is the responsibility of the module
- * (e.g. if periodic processing is required then the module should setup
- * it's own timer).
- *
- * In addition to the transmit rate for each frame the module must also
- * indicate the number of attempts to make at the specified rate.  If this
- * number is != ATH_TXMAXTRY then an additional callback is made to setup
- * additional transmit state.  The rate control code is assumed to write
- * this additional data directly to the transmit descriptor.
- */
 
 struct ath_softc;
 
-#define TRUE 1
-#define FALSE 0
-
-#define ATH_RATE_MAX	30
-
-#define WLAN_PHY_HT_20_SS       WLAN_RC_PHY_HT_20_SS
-#define WLAN_PHY_HT_20_DS       WLAN_RC_PHY_HT_20_DS
-#define WLAN_PHY_HT_20_DS_HGI   WLAN_RC_PHY_HT_20_DS_HGI
-#define WLAN_PHY_HT_40_SS       WLAN_RC_PHY_HT_40_SS
-#define WLAN_PHY_HT_40_SS_HGI   WLAN_RC_PHY_HT_40_SS_HGI
-#define WLAN_PHY_HT_40_DS       WLAN_RC_PHY_HT_40_DS
-#define WLAN_PHY_HT_40_DS_HGI   WLAN_RC_PHY_HT_40_DS_HGI
-
-#define WLAN_PHY_OFDM	PHY_OFDM
-#define WLAN_PHY_CCK	PHY_CCK
+#define ATH_RATE_MAX     30
+#define RATE_TABLE_SIZE  64
+#define MAX_TX_RATE_PHY  48
 
-#define TRUE_20		0x2
-#define TRUE_40		0x4
-#define TRUE_2040	(TRUE_20|TRUE_40)
-#define TRUE_ALL	(TRUE_2040|TRUE)
-
-enum {
-	WLAN_RC_PHY_HT_20_SS = 4,
-	WLAN_RC_PHY_HT_20_DS,
-	WLAN_RC_PHY_HT_40_SS,
-	WLAN_RC_PHY_HT_40_DS,
-	WLAN_RC_PHY_HT_20_SS_HGI,
-	WLAN_RC_PHY_HT_20_DS_HGI,
-	WLAN_RC_PHY_HT_40_SS_HGI,
-	WLAN_RC_PHY_HT_40_DS_HGI,
-	WLAN_RC_PHY_MAX
-};
+#define INVALID    0x0
+#define VALID      0x1
+#define VALID_20   0x2
+#define VALID_40   0x4
+#define VALID_2040 (VALID_20|VALID_40)
+#define VALID_ALL  (VALID_2040|VALID)
 
 #define WLAN_RC_PHY_DS(_phy)   ((_phy == WLAN_RC_PHY_HT_20_DS)		\
 				|| (_phy == WLAN_RC_PHY_HT_40_DS)	\
@@ -103,26 +49,22 @@ enum {
 
 #define WLAN_RC_PHY_HT(_phy)    (_phy >= WLAN_RC_PHY_HT_20_SS)
 
-/* Returns the capflag mode */
 #define WLAN_RC_CAP_MODE(capflag) (((capflag & WLAN_RC_HT_FLAG) ?	\
-		(capflag & WLAN_RC_40_FLAG) ? TRUE_40 : TRUE_20 : TRUE))
+		(capflag & WLAN_RC_40_FLAG) ? VALID_40 : VALID_20 : VALID))
 
 /* Return TRUE if flag supports HT20 && client supports HT20 or
  * return TRUE if flag supports HT40 && client supports HT40.
  * This is used becos some rates overlap between HT20/HT40.
  */
-
-#define WLAN_RC_PHY_HT_VALID(flag, capflag) (((flag & TRUE_20) && !(capflag \
-				& WLAN_RC_40_FLAG)) || ((flag & TRUE_40) && \
-				  (capflag & WLAN_RC_40_FLAG)))
+#define WLAN_RC_PHY_HT_VALID(flag, capflag)			\
+	(((flag & VALID_20) && !(capflag & WLAN_RC_40_FLAG)) || \
+	 ((flag & VALID_40) && (capflag & WLAN_RC_40_FLAG)))
 
 #define WLAN_RC_DS_FLAG         (0x01)
 #define WLAN_RC_40_FLAG         (0x02)
 #define WLAN_RC_SGI_FLAG        (0x04)
 #define WLAN_RC_HT_FLAG         (0x08)
 
-#define RATE_TABLE_SIZE		64
-
 /**
  * struct ath_rate_table - Rate Control table
  * @valid: valid for use in rate control
@@ -139,7 +81,7 @@ enum {
  * @max_4ms_framelen: maximum frame length(bytes) for tx duration
  * @probe_interval: interval for rate control to probe for other rates
  * @rssi_reduce_interval: interval for rate control to reduce rssi
- * @initial_ratemax: initial ratemax value used in ath_rc_sib_update()
+ * @initial_ratemax: initial ratemax value
  */
 struct ath_rate_table {
 	int rate_cnt;
@@ -169,15 +111,6 @@ struct ath_rate_table {
 	u8 initial_ratemax;
 };
 
-#define ATH_RC_PROBE_ALLOWED            0x00000001
-#define ATH_RC_MINRATE_LASTRATE         0x00000002
-
-/*
- * State structures for new rate adaptation code
- */
-#define	MAX_TX_RATE_TBL	        64
-#define MAX_TX_RATE_PHY         48
-
 struct ath_tx_ratectrl_state {
 	int8_t rssi_thres;	/* required rssi for this rate (dB) */
 	u8 per;			/* recent estimate of packet error rate (%) */
@@ -189,7 +122,7 @@ struct ath_rateset {
 };
 
 /**
- * struct ath_rate_node - Rate Control priv data
+ * struct ath_rate_priv - Rate Control priv data
  * @state: RC state
  * @rssi_last: last ACK rssi
  * @rssi_last_lookup: last ACK rssi used for lookup
@@ -214,9 +147,7 @@ struct ath_rateset {
  * @neg_rates: Negotatied rates
  * @neg_ht_rates: Negotiated HT rates
  */
-
-/* per-node state */
-struct ath_rate_node {
+struct ath_rate_priv {
 	int8_t rssi_last;
 	int8_t rssi_last_lookup;
 	int8_t rssi_last_prev;
@@ -228,11 +159,11 @@ struct ath_rate_node {
 	u8 probe_rate;
 	u8 hw_maxretry_pktcnt;
 	u8 max_valid_rate;
-	u8 valid_rate_index[MAX_TX_RATE_TBL];
+	u8 valid_rate_index[RATE_TABLE_SIZE];
 	u8 ht_cap;
 	u8 single_stream;
 	u8 valid_phy_ratecnt[WLAN_RC_PHY_MAX];
-	u8 valid_phy_rateidx[WLAN_RC_PHY_MAX][MAX_TX_RATE_TBL];
+	u8 valid_phy_rateidx[WLAN_RC_PHY_MAX][RATE_TABLE_SIZE];
 	u8 rc_phy_mode;
 	u8 rate_max_phy;
 	u32 rssi_time;
@@ -242,7 +173,7 @@ struct ath_rate_node {
 	u32 probe_interval;
 	u32 prev_data_rix;
 	u32 tx_triglevel_max;
-	struct ath_tx_ratectrl_state state[MAX_TX_RATE_TBL];
+	struct ath_tx_ratectrl_state state[RATE_TABLE_SIZE];
 	struct ath_rateset neg_rates;
 	struct ath_rateset neg_ht_rates;
 	struct ath_rate_softc *asc;
@@ -254,6 +185,9 @@ struct ath_tx_info_priv {
 	int n_bad_frames;
 };
 
+#define ATH_TX_INFO_PRIV(tx_info) \
+	((struct ath_tx_info_priv *)((tx_info)->rate_driver_data[0]))
+
 void ath_rate_attach(struct ath_softc *sc);
 u8 ath_rate_findrateix(struct ath_softc *sc, u8 dot11_rate);
 int ath_rate_control_register(void);
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index b2d0cca..93317ce 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -536,7 +536,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 	 * just CTS.  Note that this is only done for OFDM/HT unicast frames.
 	 */
 	if (sc->sc_protmode != PROT_M_NONE && !(bf->bf_flags & ATH9K_TXDESC_NOACK)
-	    && (rt->info[rix].phy == WLAN_PHY_OFDM ||
+	    && (rt->info[rix].phy == WLAN_RC_PHY_OFDM ||
 		WLAN_RC_PHY_HT(rt->info[rix].phy))) {
 		if (sc->sc_protmode == PROT_M_RTSCTS)
 			flags = ATH9K_TXDESC_RTSENA;
-- 
1.6.0.3

