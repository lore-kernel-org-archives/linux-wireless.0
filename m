Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54437 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab1KLOGC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Nov 2011 09:06:02 -0500
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 2/3] ath9k_hw: Cleanup btcoex wlan weights
Date: Sat, 12 Nov 2011 19:35:47 +0530
Message-ID: <1321106748-13014-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111112_150607_396305_25DEEAA4)
In-Reply-To: <1321106748-13014-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1321106748-13014-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove all wlan weight macros and group it together for better
understanding & readability. It makes the code reusable for
AR9462 wlan weights.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/btcoex.c |   64 ++++++++++++-------------------
 drivers/net/wireless/ath/ath9k/btcoex.h |    8 +++-
 drivers/net/wireless/ath/ath9k/hw.h     |    5 --
 drivers/net/wireless/ath/ath9k/reg.h    |   15 +------
 4 files changed, 34 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index f525e91..0ba39ea 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -36,6 +36,12 @@ struct ath_btcoex_config {
 	bool bt_hold_rx_clear;
 };
 
+static const u32 ar9003_wlan_weights[ATH_BTCOEX_STOMP_MAX]
+				    [AR9300_NUM_WLAN_WEIGHTS] = {
+	{ 0xfffffff0, 0xfffffff0, 0xfffffff0, 0xfffffff0 }, /* STOMP_ALL */
+	{ 0x88888880, 0x88888880, 0x88888880, 0x88888880 }, /* STOMP_LOW */
+	{ 0x00000000, 0x00000000, 0x00000000, 0x00000000 }, /* STOMP_NONE */
+};
 
 void ath9k_hw_init_btcoex_hw(struct ath_hw *ah, int qnum)
 {
@@ -152,27 +158,26 @@ EXPORT_SYMBOL(ath9k_hw_btcoex_set_weight);
 
 static void ath9k_hw_btcoex_enable_3wire(struct ath_hw *ah)
 {
-	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
+	struct ath_btcoex_hw *btcoex = &ah->btcoex_hw;
 	u32  val;
+	int i;
 
 	/*
 	 * Program coex mode and weight registers to
 	 * enable coex 3-wire
 	 */
-	REG_WRITE(ah, AR_BT_COEX_MODE, btcoex_hw->bt_coex_mode);
-	REG_WRITE(ah, AR_BT_COEX_MODE2, btcoex_hw->bt_coex_mode2);
+	REG_WRITE(ah, AR_BT_COEX_MODE, btcoex->bt_coex_mode);
+	REG_WRITE(ah, AR_BT_COEX_MODE2, btcoex->bt_coex_mode2);
 
 
 	if (AR_SREV_9300_20_OR_LATER(ah)) {
-		REG_WRITE(ah, AR_BT_COEX_WL_WEIGHTS0, ah->bt_coex_wlan_weight[0]);
-		REG_WRITE(ah, AR_BT_COEX_WL_WEIGHTS1, ah->bt_coex_wlan_weight[1]);
-		REG_WRITE(ah, AR_BT_COEX_BT_WEIGHTS0, ah->bt_coex_bt_weight[0]);
-		REG_WRITE(ah, AR_BT_COEX_BT_WEIGHTS1, ah->bt_coex_bt_weight[1]);
-		REG_WRITE(ah, AR_BT_COEX_BT_WEIGHTS2, ah->bt_coex_bt_weight[2]);
-		REG_WRITE(ah, AR_BT_COEX_BT_WEIGHTS3, ah->bt_coex_bt_weight[3]);
-
+		REG_WRITE(ah, AR_BT_COEX_WL_WEIGHTS0, btcoex->wlan_weight[0]);
+		REG_WRITE(ah, AR_BT_COEX_WL_WEIGHTS1, btcoex->wlan_weight[1]);
+		for (i = 0; i < AR9300_NUM_BT_WEIGHTS; i++)
+			REG_WRITE(ah, AR_BT_COEX_BT_WEIGHTS(i),
+				  btcoex->bt_weight[i]);
 	} else
-		REG_WRITE(ah, AR_BT_COEX_WEIGHT, btcoex_hw->bt_coex_weights);
+		REG_WRITE(ah, AR_BT_COEX_WEIGHT, btcoex->bt_coex_weights);
 
 
 
@@ -185,7 +190,7 @@ static void ath9k_hw_btcoex_enable_3wire(struct ath_hw *ah)
 	REG_RMW_FIELD(ah, AR_QUIET1, AR_QUIET1_QUIET_ACK_CTS_ENABLE, 1);
 	REG_RMW_FIELD(ah, AR_PCU_MISC, AR_PCU_BT_ANT_PREVENT_RX, 0);
 
-	ath9k_hw_cfg_output(ah, btcoex_hw->wlanactive_gpio,
+	ath9k_hw_cfg_output(ah, btcoex->wlanactive_gpio,
 			    AR_GPIO_OUTPUT_MUX_AS_RX_CLEAR_EXTERNAL);
 }
 
@@ -215,6 +220,7 @@ EXPORT_SYMBOL(ath9k_hw_btcoex_enable);
 void ath9k_hw_btcoex_disable(struct ath_hw *ah)
 {
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
+	int i;
 
 	ath9k_hw_set_gpio(ah, btcoex_hw->wlanactive_gpio, 0);
 
@@ -228,10 +234,8 @@ void ath9k_hw_btcoex_disable(struct ath_hw *ah)
 		if (AR_SREV_9300_20_OR_LATER(ah)) {
 			REG_WRITE(ah, AR_BT_COEX_WL_WEIGHTS0, 0);
 			REG_WRITE(ah, AR_BT_COEX_WL_WEIGHTS1, 0);
-			REG_WRITE(ah, AR_BT_COEX_BT_WEIGHTS0, 0);
-			REG_WRITE(ah, AR_BT_COEX_BT_WEIGHTS1, 0);
-			REG_WRITE(ah, AR_BT_COEX_BT_WEIGHTS2, 0);
-			REG_WRITE(ah, AR_BT_COEX_BT_WEIGHTS3, 0);
+			for (i = 0; i < AR9300_NUM_BT_WEIGHTS; i++)
+				REG_WRITE(ah, AR_BT_COEX_BT_WEIGHTS(i), 0);
 		} else
 			REG_WRITE(ah, AR_BT_COEX_WEIGHT, 0);
 
@@ -244,30 +248,12 @@ EXPORT_SYMBOL(ath9k_hw_btcoex_disable);
 static void ar9003_btcoex_bt_stomp(struct ath_hw *ah,
 			 enum ath_stomp_type stomp_type)
 {
-	ah->bt_coex_bt_weight[0] = AR9300_BT_WGHT;
-	ah->bt_coex_bt_weight[1] = AR9300_BT_WGHT;
-	ah->bt_coex_bt_weight[2] = AR9300_BT_WGHT;
-	ah->bt_coex_bt_weight[3] = AR9300_BT_WGHT;
-
+	struct ath_btcoex_hw *btcoex = &ah->btcoex_hw;
+	int i;
 
-	switch (stomp_type) {
-	case ATH_BTCOEX_STOMP_ALL:
-		ah->bt_coex_wlan_weight[0] = AR9300_STOMP_ALL_WLAN_WGHT0;
-		ah->bt_coex_wlan_weight[1] = AR9300_STOMP_ALL_WLAN_WGHT1;
-		break;
-	case ATH_BTCOEX_STOMP_LOW:
-		ah->bt_coex_wlan_weight[0] = AR9300_STOMP_LOW_WLAN_WGHT0;
-		ah->bt_coex_wlan_weight[1] = AR9300_STOMP_LOW_WLAN_WGHT1;
-		break;
-	case ATH_BTCOEX_STOMP_NONE:
-		ah->bt_coex_wlan_weight[0] = AR9300_STOMP_NONE_WLAN_WGHT0;
-		ah->bt_coex_wlan_weight[1] = AR9300_STOMP_NONE_WLAN_WGHT1;
-		break;
-
-	default:
-		ath_dbg(ath9k_hw_common(ah), ATH_DBG_BTCOEX,
-				"Invalid Stomptype\n");
-		break;
+	for (i = 0; i < AR9300_NUM_WLAN_WEIGHTS; i++) {
+		btcoex->bt_weight[i] = AR9300_BT_WGHT;
+		btcoex->wlan_weight[i] = ar9003_wlan_weights[stomp_type][i];
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
index 234f776..34acb51 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.h
+++ b/drivers/net/wireless/ath/ath9k/btcoex.h
@@ -36,12 +36,14 @@
 #define ATH_BT_CNT_THRESHOLD	       3
 #define ATH_BT_CNT_SCAN_THRESHOLD      15
 
+#define AR9300_NUM_BT_WEIGHTS   4
+#define AR9300_NUM_WLAN_WEIGHTS 4
 /* Defines the BT AR_BT_COEX_WGHT used */
 enum ath_stomp_type {
-	ATH_BTCOEX_NO_STOMP,
 	ATH_BTCOEX_STOMP_ALL,
 	ATH_BTCOEX_STOMP_LOW,
-	ATH_BTCOEX_STOMP_NONE
+	ATH_BTCOEX_STOMP_NONE,
+	ATH_BTCOEX_STOMP_MAX
 };
 
 enum ath_btcoex_scheme {
@@ -59,6 +61,8 @@ struct ath_btcoex_hw {
 	u32 bt_coex_mode; 	/* Register setting for AR_BT_COEX_MODE */
 	u32 bt_coex_weights; 	/* Register setting for AR_BT_COEX_WEIGHT */
 	u32 bt_coex_mode2; 	/* Register setting for AR_BT_COEX_MODE2 */
+	u32 bt_weight[AR9300_NUM_BT_WEIGHTS];
+	u32 wlan_weight[AR9300_NUM_WLAN_WEIGHTS];
 };
 
 void ath9k_hw_btcoex_init_2wire(struct ath_hw *ah);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 33e8f2f..3cb878c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -59,9 +59,6 @@
 #define AT9285_COEX3WIRE_SA_SUBSYSID	0x30aa
 #define AT9285_COEX3WIRE_DA_SUBSYSID	0x30ab
 
-#define AR9300_NUM_BT_WEIGHTS   4
-#define AR9300_NUM_WLAN_WEIGHTS 4
-
 #define ATH_AMPDU_LIMIT_MAX        (64 * 1024 - 1)
 
 #define	ATH_DEFAULT_NOISE_FLOOR -95
@@ -802,8 +799,6 @@ struct ath_hw {
 
 	/* Bluetooth coexistance */
 	struct ath_btcoex_hw btcoex_hw;
-	u32 bt_coex_bt_weight[AR9300_NUM_BT_WEIGHTS];
-	u32 bt_coex_wlan_weight[AR9300_NUM_WLAN_WEIGHTS];
 
 	u32 intr_txqs;
 	u8 txchainmask;
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 8fcb7e9..e17236d 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1753,18 +1753,9 @@ enum {
 #define AR_BT_COEX_WL_WEIGHTS0     0x8174
 #define AR_BT_COEX_WL_WEIGHTS1     0x81c4
 
-#define AR_BT_COEX_BT_WEIGHTS0     0x83ac
-#define AR_BT_COEX_BT_WEIGHTS1     0x83b0
-#define AR_BT_COEX_BT_WEIGHTS2     0x83b4
-#define AR_BT_COEX_BT_WEIGHTS3     0x83b8
-
-#define AR9300_BT_WGHT                     0xcccc4444
-#define AR9300_STOMP_ALL_WLAN_WGHT0        0xfffffff0
-#define AR9300_STOMP_ALL_WLAN_WGHT1        0xfffffff0
-#define AR9300_STOMP_LOW_WLAN_WGHT0        0x88888880
-#define AR9300_STOMP_LOW_WLAN_WGHT1        0x88888880
-#define AR9300_STOMP_NONE_WLAN_WGHT0       0x00000000
-#define AR9300_STOMP_NONE_WLAN_WGHT1       0x00000000
+#define AR_BT_COEX_BT_WEIGHTS(_i)  (0x83ac + (_i << 2))
+
+#define AR9300_BT_WGHT             0xcccc4444
 
 #define AR_BT_COEX_MODE2           0x817c
 #define AR_BT_BCN_MISS_THRESH      0x000000ff
-- 
1.7.7.3

