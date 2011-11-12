Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42170 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab1KLOIf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Nov 2011 09:08:35 -0500
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 3/3] ath9k_hw: set btcoex weights for AR9462
Date: Sat, 12 Nov 2011 19:35:48 +0530
Message-ID: <1321106748-13014-3-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111112_150840_009727_20C556CF)
In-Reply-To: <1321106748-13014-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1321106748-13014-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/btcoex.c |   37 ++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath9k/btcoex.h |    2 +
 drivers/net/wireless/ath/ath9k/reg.h    |    2 +-
 3 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index 0ba39ea..9ac28d9 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -43,6 +43,14 @@ static const u32 ar9003_wlan_weights[ATH_BTCOEX_STOMP_MAX]
 	{ 0x00000000, 0x00000000, 0x00000000, 0x00000000 }, /* STOMP_NONE */
 };
 
+static const u32 ar9462_wlan_weights[ATH_BTCOEX_STOMP_MAX]
+				    [AR9300_NUM_WLAN_WEIGHTS] = {
+	{ 0x01017d01, 0x41414101, 0x41414101, 0x41414141 }, /* STOMP_ALL */
+	{ 0x01017d01, 0x3b3b3b01, 0x3b3b3b01, 0x3b3b3b3b }, /* STOMP_LOW */
+	{ 0x01017d01, 0x01010101, 0x01010101, 0x01010101 }, /* STOMP_NONE */
+	{ 0x01017d01, 0x013b0101, 0x3b3b0101, 0x3b3b013b }, /* STOMP_LOW_FTP */
+};
+
 void ath9k_hw_init_btcoex_hw(struct ath_hw *ah, int qnum)
 {
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
@@ -194,6 +202,19 @@ static void ath9k_hw_btcoex_enable_3wire(struct ath_hw *ah)
 			    AR_GPIO_OUTPUT_MUX_AS_RX_CLEAR_EXTERNAL);
 }
 
+static void ath9k_hw_btcoex_enable_mci(struct ath_hw *ah)
+{
+	struct ath_btcoex_hw *btcoex = &ah->btcoex_hw;
+	int i;
+
+	for (i = 0; i < AR9300_NUM_BT_WEIGHTS; i++)
+		REG_WRITE(ah, AR_MCI_COEX_WL_WEIGHTS(i),
+			  btcoex->wlan_weight[i]);
+
+	REG_RMW_FIELD(ah, AR_QUIET1, AR_QUIET1_QUIET_ACK_CTS_ENABLE, 1);
+	btcoex->enabled = true;
+}
+
 void ath9k_hw_btcoex_enable(struct ath_hw *ah)
 {
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
@@ -207,6 +228,9 @@ void ath9k_hw_btcoex_enable(struct ath_hw *ah)
 	case ATH_BTCOEX_CFG_3WIRE:
 		ath9k_hw_btcoex_enable_3wire(ah);
 		break;
+	case ATH_BTCOEX_CFG_MCI:
+		ath9k_hw_btcoex_enable_mci(ah);
+		return;
 	}
 
 	REG_RMW(ah, AR_GPIO_PDPU,
@@ -222,6 +246,13 @@ void ath9k_hw_btcoex_disable(struct ath_hw *ah)
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
 	int i;
 
+	btcoex_hw->enabled = false;
+	if (btcoex_hw->scheme == ATH_BTCOEX_CFG_MCI) {
+		ath9k_hw_btcoex_bt_stomp(ah, ATH_BTCOEX_STOMP_NONE);
+		for (i = 0; i < AR9300_NUM_BT_WEIGHTS; i++)
+			REG_WRITE(ah, AR_MCI_COEX_WL_WEIGHTS(i),
+				  btcoex_hw->wlan_weight[i]);
+	}
 	ath9k_hw_set_gpio(ah, btcoex_hw->wlanactive_gpio, 0);
 
 	ath9k_hw_cfg_output(ah, btcoex_hw->wlanactive_gpio,
@@ -240,8 +271,6 @@ void ath9k_hw_btcoex_disable(struct ath_hw *ah)
 			REG_WRITE(ah, AR_BT_COEX_WEIGHT, 0);
 
 	}
-
-	ah->btcoex_hw.enabled = false;
 }
 EXPORT_SYMBOL(ath9k_hw_btcoex_disable);
 
@@ -249,11 +278,13 @@ static void ar9003_btcoex_bt_stomp(struct ath_hw *ah,
 			 enum ath_stomp_type stomp_type)
 {
 	struct ath_btcoex_hw *btcoex = &ah->btcoex_hw;
+	const u32 *weight = AR_SREV_9462(ah) ? ar9003_wlan_weights[stomp_type] :
+					       ar9462_wlan_weights[stomp_type];
 	int i;
 
 	for (i = 0; i < AR9300_NUM_WLAN_WEIGHTS; i++) {
 		btcoex->bt_weight[i] = AR9300_BT_WGHT;
-		btcoex->wlan_weight[i] = ar9003_wlan_weights[stomp_type][i];
+		btcoex->wlan_weight[i] = weight[i];
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
index 34acb51..d5e5db1 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.h
+++ b/drivers/net/wireless/ath/ath9k/btcoex.h
@@ -43,6 +43,7 @@ enum ath_stomp_type {
 	ATH_BTCOEX_STOMP_ALL,
 	ATH_BTCOEX_STOMP_LOW,
 	ATH_BTCOEX_STOMP_NONE,
+	ATH_BTCOEX_STOMP_LOW_FTP,
 	ATH_BTCOEX_STOMP_MAX
 };
 
@@ -50,6 +51,7 @@ enum ath_btcoex_scheme {
 	ATH_BTCOEX_CFG_NONE,
 	ATH_BTCOEX_CFG_2WIRE,
 	ATH_BTCOEX_CFG_3WIRE,
+	ATH_BTCOEX_CFG_MCI,
 };
 
 struct ath_btcoex_hw {
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index e17236d..4591097 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1752,7 +1752,7 @@ enum {
 
 #define AR_BT_COEX_WL_WEIGHTS0     0x8174
 #define AR_BT_COEX_WL_WEIGHTS1     0x81c4
-
+#define AR_MCI_COEX_WL_WEIGHTS(_i) (0x18b0 + (_i << 2))
 #define AR_BT_COEX_BT_WEIGHTS(_i)  (0x83ac + (_i << 2))
 
 #define AR9300_BT_WGHT             0xcccc4444
-- 
1.7.7.3

