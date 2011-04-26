Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:40720 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850Ab1DZKkG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 06:40:06 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2011 03:39:39 -0700
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/4] ath9k_hw: Add support for btcoexistence in AR9300.
Date: Tue, 26 Apr 2011 10:39:53 +0530
Message-ID: <1303794595-4031-2-git-send-email-vnatarajan@atheros.com> (sfid-20110426_124009_315316_791EC11E)
In-Reply-To: <1303794595-4031-1-git-send-email-vnatarajan@atheros.com>
References: <1303794595-4031-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/btcoex.c |   34 ++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath9k/btcoex.h |   10 ++++++--
 drivers/net/wireless/ath/ath9k/hw.c     |   24 ++++++++++++++-------
 drivers/net/wireless/ath/ath9k/hw.h     |    5 ++++
 drivers/net/wireless/ath/ath9k/reg.h    |   16 ++++++++++++++
 5 files changed, 75 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index 71e9e48..23f15a7 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -51,6 +51,10 @@ void ath9k_hw_init_btcoex_hw(struct ath_hw *ah, int qnum)
 		.bt_hold_rx_clear = true,
 	};
 	u32 i;
+	bool rxclear_polarity = ath_bt_config.bt_rxclear_polarity;
+
+	if (AR_SREV_9300_20_OR_LATER(ah))
+		rxclear_polarity = !ath_bt_config.bt_rxclear_polarity;
 
 	btcoex_hw->bt_coex_mode =
 		(btcoex_hw->bt_coex_mode & AR_BT_QCU_THRESH) |
@@ -59,7 +63,7 @@ void ath9k_hw_init_btcoex_hw(struct ath_hw *ah, int qnum)
 		SM(ath_bt_config.bt_txframe_extend, AR_BT_TX_FRAME_EXTEND) |
 		SM(ath_bt_config.bt_mode, AR_BT_MODE) |
 		SM(ath_bt_config.bt_quiet_collision, AR_BT_QUIET) |
-		SM(ath_bt_config.bt_rxclear_polarity, AR_BT_RX_CLEAR_POLARITY) |
+		SM(rxclear_polarity, AR_BT_RX_CLEAR_POLARITY) |
 		SM(ath_bt_config.bt_priority_time, AR_BT_PRIORITY_TIME) |
 		SM(ath_bt_config.bt_first_slot_time, AR_BT_FIRST_SLOT_TIME) |
 		SM(qnum, AR_BT_QCU_THRESH);
@@ -142,6 +146,7 @@ void ath9k_hw_btcoex_set_weight(struct ath_hw *ah,
 }
 EXPORT_SYMBOL(ath9k_hw_btcoex_set_weight);
 
+
 static void ath9k_hw_btcoex_enable_3wire(struct ath_hw *ah)
 {
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
@@ -152,9 +157,22 @@ static void ath9k_hw_btcoex_enable_3wire(struct ath_hw *ah)
 	 * enable coex 3-wire
 	 */
 	REG_WRITE(ah, AR_BT_COEX_MODE, btcoex_hw->bt_coex_mode);
-	REG_WRITE(ah, AR_BT_COEX_WEIGHT, btcoex_hw->bt_coex_weights);
 	REG_WRITE(ah, AR_BT_COEX_MODE2, btcoex_hw->bt_coex_mode2);
 
+
+	if (AR_SREV_9300_20_OR_LATER(ah)) {
+		REG_WRITE(ah, AR_BT_COEX_WL_WEIGHTS0, ah->bt_coex_wlan_weight[0]);
+		REG_WRITE(ah, AR_BT_COEX_WL_WEIGHTS1, ah->bt_coex_wlan_weight[1]);
+		REG_WRITE(ah, AR_BT_COEX_BT_WEIGHTS0, ah->bt_coex_bt_weight[0]);
+		REG_WRITE(ah, AR_BT_COEX_BT_WEIGHTS1, ah->bt_coex_bt_weight[1]);
+		REG_WRITE(ah, AR_BT_COEX_BT_WEIGHTS2, ah->bt_coex_bt_weight[2]);
+		REG_WRITE(ah, AR_BT_COEX_BT_WEIGHTS3, ah->bt_coex_bt_weight[3]);
+
+	} else
+		REG_WRITE(ah, AR_BT_COEX_WEIGHT, btcoex_hw->bt_coex_weights);
+
+
+
 	if (AR_SREV_9271(ah)) {
 		val = REG_READ(ah, 0x50040);
 		val &= 0xFFFFFEFF;
@@ -202,8 +220,18 @@ void ath9k_hw_btcoex_disable(struct ath_hw *ah)
 
 	if (btcoex_hw->scheme == ATH_BTCOEX_CFG_3WIRE) {
 		REG_WRITE(ah, AR_BT_COEX_MODE, AR_BT_QUIET | AR_BT_MODE);
-		REG_WRITE(ah, AR_BT_COEX_WEIGHT, 0);
 		REG_WRITE(ah, AR_BT_COEX_MODE2, 0);
+
+		if (AR_SREV_9300_20_OR_LATER(ah)) {
+			REG_WRITE(ah, AR_BT_COEX_WL_WEIGHTS0, 0);
+			REG_WRITE(ah, AR_BT_COEX_WL_WEIGHTS1, 0);
+			REG_WRITE(ah, AR_BT_COEX_BT_WEIGHTS0, 0);
+			REG_WRITE(ah, AR_BT_COEX_BT_WEIGHTS1, 0);
+			REG_WRITE(ah, AR_BT_COEX_BT_WEIGHTS2, 0);
+			REG_WRITE(ah, AR_BT_COEX_BT_WEIGHTS3, 0);
+		} else
+			REG_WRITE(ah, AR_BT_COEX_WEIGHT, 0);
+
 	}
 
 	ah->btcoex_hw.enabled = false;
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
index aac8fae..a9efca8 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.h
+++ b/drivers/net/wireless/ath/ath9k/btcoex.h
@@ -19,9 +19,13 @@
 
 #include "hw.h"
 
-#define ATH_WLANACTIVE_GPIO	5
-#define ATH_BTACTIVE_GPIO	6
-#define ATH_BTPRIORITY_GPIO	7
+#define ATH_WLANACTIVE_GPIO_9280     5
+#define ATH_BTACTIVE_GPIO_9280       6
+#define ATH_BTPRIORITY_GPIO_9285     7
+
+#define ATH_WLANACTIVE_GPIO_9300     5
+#define ATH_BTACTIVE_GPIO_9300       4
+#define ATH_BTPRIORITY_GPIO_9300     8
 
 #define ATH_BTCOEX_DEF_BT_PERIOD  45
 #define ATH_BTCOEX_DEF_DUTY_CYCLE 55
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index e99e319..58f3d42 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1956,15 +1956,23 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	else
 		pCap->hw_caps |= ATH9K_HW_CAP_4KB_SPLITTRANS;
 
-	if (AR_SREV_9280_20_OR_LATER(ah) && common->btcoex_enabled) {
-		btcoex_hw->btactive_gpio = ATH_BTACTIVE_GPIO;
-		btcoex_hw->wlanactive_gpio = ATH_WLANACTIVE_GPIO;
-
-		if (AR_SREV_9285(ah)) {
+	if (common->btcoex_enabled) {
+		if (AR_SREV_9300_20_OR_LATER(ah)) {
 			btcoex_hw->scheme = ATH_BTCOEX_CFG_3WIRE;
-			btcoex_hw->btpriority_gpio = ATH_BTPRIORITY_GPIO;
-		} else {
-			btcoex_hw->scheme = ATH_BTCOEX_CFG_2WIRE;
+			btcoex_hw->btactive_gpio = ATH_BTACTIVE_GPIO_9300;
+			btcoex_hw->wlanactive_gpio = ATH_WLANACTIVE_GPIO_9300;
+			btcoex_hw->btpriority_gpio = ATH_BTPRIORITY_GPIO_9300;
+		} else if (AR_SREV_9280_20_OR_LATER(ah)) {
+			btcoex_hw->btactive_gpio = ATH_BTACTIVE_GPIO_9280;
+			btcoex_hw->wlanactive_gpio = ATH_WLANACTIVE_GPIO_9280;
+
+			if (AR_SREV_9285(ah)) {
+				btcoex_hw->scheme = ATH_BTCOEX_CFG_3WIRE;
+				btcoex_hw->btpriority_gpio =
+						ATH_BTPRIORITY_GPIO_9285;
+			} else {
+				btcoex_hw->scheme = ATH_BTCOEX_CFG_2WIRE;
+			}
 		}
 	} else {
 		btcoex_hw->scheme = ATH_BTCOEX_CFG_NONE;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 6a028bd..34ed1bd 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -56,6 +56,9 @@
 #define AT9285_COEX3WIRE_SA_SUBSYSID	0x30aa
 #define AT9285_COEX3WIRE_DA_SUBSYSID	0x30ab
 
+#define AR9300_NUM_BT_WEIGHTS   4
+#define AR9300_NUM_WLAN_WEIGHTS 4
+
 #define ATH_AMPDU_LIMIT_MAX        (64 * 1024 - 1)
 
 #define	ATH_DEFAULT_NOISE_FLOOR -95
@@ -772,6 +775,8 @@ struct ath_hw {
 
 	/* Bluetooth coexistance */
 	struct ath_btcoex_hw btcoex_hw;
+	u32 bt_coex_bt_weight[AR9300_NUM_BT_WEIGHTS];
+	u32 bt_coex_wlan_weight[AR9300_NUM_WLAN_WEIGHTS];
 
 	u32 intr_txqs;
 	u8 txchainmask;
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index b42e36c..3483af8 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1707,6 +1707,22 @@ enum {
 #define AR_BTCOEX_WL_WGHT          0xffff0000
 #define AR_BTCOEX_WL_WGHT_S        16
 
+#define AR_BT_COEX_WL_WEIGHTS0     0x8174
+#define AR_BT_COEX_WL_WEIGHTS1     0x81c4
+
+#define AR_BT_COEX_BT_WEIGHTS0     0x83ac
+#define AR_BT_COEX_BT_WEIGHTS1     0x83b0
+#define AR_BT_COEX_BT_WEIGHTS2     0x83b4
+#define AR_BT_COEX_BT_WEIGHTS3     0x83b8
+
+#define AR9300_BT_WGHT                     0xcccc4444
+#define AR9300_STOMP_ALL_WLAN_WGHT0        0xfffffff0
+#define AR9300_STOMP_ALL_WLAN_WGHT1        0xfffffff0
+#define AR9300_STOMP_LOW_WLAN_WGHT0        0x88888880
+#define AR9300_STOMP_LOW_WLAN_WGHT1        0x88888880
+#define AR9300_STOMP_NONE_WLAN_WGHT0       0x00000000
+#define AR9300_STOMP_NONE_WLAN_WGHT1       0x00000000
+
 #define AR_BT_COEX_MODE2           0x817c
 #define AR_BT_BCN_MISS_THRESH      0x000000ff
 #define AR_BT_BCN_MISS_THRESH_S    0
-- 
1.7.1

