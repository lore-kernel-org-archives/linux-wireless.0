Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:40717 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850Ab1DZKkA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 06:40:00 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2011 03:39:33 -0700
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/4] ath9k_hw: Move bt_stomp to hw from common.
Date: Tue, 26 Apr 2011 10:39:52 +0530
Message-ID: <1303794595-4031-1-git-send-email-vnatarajan@atheros.com> (sfid-20110426_124005_535110_F0A82809)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move bt_stomp to ath9k_hw and add its support for latest chipsets.
 
Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/btcoex.c       |   66 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/btcoex.h       |   10 ++++
 drivers/net/wireless/ath/ath9k/common.c       |   31 ------------
 drivers/net/wireless/ath/ath9k/common.h       |    8 ---
 drivers/net/wireless/ath/ath9k/gpio.c         |    7 +--
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c |    6 +-
 6 files changed, 82 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index d33bf20..71e9e48 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -209,3 +209,69 @@ void ath9k_hw_btcoex_disable(struct ath_hw *ah)
 	ah->btcoex_hw.enabled = false;
 }
 EXPORT_SYMBOL(ath9k_hw_btcoex_disable);
+
+static void ar9003_btcoex_bt_stomp(struct ath_hw *ah,
+			 enum ath_stomp_type stomp_type)
+{
+	ah->bt_coex_bt_weight[0] = AR9300_BT_WGHT;
+	ah->bt_coex_bt_weight[1] = AR9300_BT_WGHT;
+	ah->bt_coex_bt_weight[2] = AR9300_BT_WGHT;
+	ah->bt_coex_bt_weight[3] = AR9300_BT_WGHT;
+
+
+	switch (stomp_type) {
+	case ATH_BTCOEX_STOMP_ALL:
+		ah->bt_coex_wlan_weight[0] = AR9300_STOMP_ALL_WLAN_WGHT0;
+		ah->bt_coex_wlan_weight[1] = AR9300_STOMP_ALL_WLAN_WGHT1;
+		break;
+	case ATH_BTCOEX_STOMP_LOW:
+		ah->bt_coex_wlan_weight[0] = AR9300_STOMP_LOW_WLAN_WGHT0;
+		ah->bt_coex_wlan_weight[1] = AR9300_STOMP_LOW_WLAN_WGHT1;
+		break;
+	case ATH_BTCOEX_STOMP_NONE:
+		ah->bt_coex_wlan_weight[0] = AR9300_STOMP_NONE_WLAN_WGHT0;
+		ah->bt_coex_wlan_weight[1] = AR9300_STOMP_NONE_WLAN_WGHT1;
+		break;
+
+	default:
+		ath_dbg(ath9k_hw_common(ah), ATH_DBG_BTCOEX,
+				"Invalid Stomptype\n");
+		break;
+	}
+
+	ath9k_hw_btcoex_enable(ah);
+}
+
+/*
+ * Configures appropriate weight based on stomp type.
+ */
+void ath9k_hw_btcoex_bt_stomp(struct ath_hw *ah,
+			      enum ath_stomp_type stomp_type)
+{
+	if (AR_SREV_9300_20_OR_LATER(ah)) {
+		ar9003_btcoex_bt_stomp(ah, stomp_type);
+		return;
+	}
+
+	switch (stomp_type) {
+	case ATH_BTCOEX_STOMP_ALL:
+		ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT,
+				AR_STOMP_ALL_WLAN_WGHT);
+		break;
+	case ATH_BTCOEX_STOMP_LOW:
+		ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT,
+				AR_STOMP_LOW_WLAN_WGHT);
+		break;
+	case ATH_BTCOEX_STOMP_NONE:
+		ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT,
+				AR_STOMP_NONE_WLAN_WGHT);
+		break;
+	default:
+		ath_dbg(ath9k_hw_common(ah), ATH_DBG_BTCOEX,
+				"Invalid Stomptype\n");
+		break;
+	}
+
+	ath9k_hw_btcoex_enable(ah);
+}
+EXPORT_SYMBOL(ath9k_hw_btcoex_bt_stomp);
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
index 588dfd4..aac8fae 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.h
+++ b/drivers/net/wireless/ath/ath9k/btcoex.h
@@ -32,6 +32,14 @@
 #define ATH_BT_CNT_THRESHOLD	       3
 #define ATH_BT_CNT_SCAN_THRESHOLD      15
 
+/* Defines the BT AR_BT_COEX_WGHT used */
+enum ath_stomp_type {
+	ATH_BTCOEX_NO_STOMP,
+	ATH_BTCOEX_STOMP_ALL,
+	ATH_BTCOEX_STOMP_LOW,
+	ATH_BTCOEX_STOMP_NONE
+};
+
 enum ath_btcoex_scheme {
 	ATH_BTCOEX_CFG_NONE,
 	ATH_BTCOEX_CFG_2WIRE,
@@ -57,5 +65,7 @@ void ath9k_hw_btcoex_set_weight(struct ath_hw *ah,
 				u32 wlan_weight);
 void ath9k_hw_btcoex_enable(struct ath_hw *ah);
 void ath9k_hw_btcoex_disable(struct ath_hw *ah);
+void ath9k_hw_btcoex_bt_stomp(struct ath_hw *ah,
+			      enum ath_stomp_type stomp_type);
 
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index 16ba8c6..74535e6 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -158,37 +158,6 @@ int ath9k_cmn_count_streams(unsigned int chainmask, int max)
 }
 EXPORT_SYMBOL(ath9k_cmn_count_streams);
 
-/*
- * Configures appropriate weight based on stomp type.
- */
-void ath9k_cmn_btcoex_bt_stomp(struct ath_common *common,
-				  enum ath_stomp_type stomp_type)
-{
-	struct ath_hw *ah = common->ah;
-
-	switch (stomp_type) {
-	case ATH_BTCOEX_STOMP_ALL:
-		ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT,
-					   AR_STOMP_ALL_WLAN_WGHT);
-		break;
-	case ATH_BTCOEX_STOMP_LOW:
-		ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT,
-					   AR_STOMP_LOW_WLAN_WGHT);
-		break;
-	case ATH_BTCOEX_STOMP_NONE:
-		ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT,
-					   AR_STOMP_NONE_WLAN_WGHT);
-		break;
-	default:
-		ath_dbg(common, ATH_DBG_BTCOEX,
-			"Invalid Stomptype\n");
-		break;
-	}
-
-	ath9k_hw_btcoex_enable(ah);
-}
-EXPORT_SYMBOL(ath9k_cmn_btcoex_bt_stomp);
-
 void ath9k_cmn_update_txpow(struct ath_hw *ah, u16 cur_txpow,
 			    u16 new_txpow, u16 *txpower)
 {
diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index b2f7b5f..5124f14 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -50,14 +50,6 @@
 #define ATH_EP_RND(x, mul) 						\
 	((((x)%(mul)) >= ((mul)/2)) ? ((x) + ((mul) - 1)) / (mul) : (x)/(mul))
 
-/* Defines the BT AR_BT_COEX_WGHT used */
-enum ath_stomp_type {
-	ATH_BTCOEX_NO_STOMP,
-	ATH_BTCOEX_STOMP_ALL,
-	ATH_BTCOEX_STOMP_LOW,
-	ATH_BTCOEX_STOMP_NONE
-};
-
 int ath9k_cmn_padpos(__le16 frame_control);
 int ath9k_cmn_get_hw_crypto_keytype(struct sk_buff *skb);
 void ath9k_cmn_update_ichannel(struct ath9k_channel *ichan,
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 2c59452..3a4ddd1 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -176,7 +176,6 @@ static void ath_btcoex_period_timer(unsigned long data)
 	struct ath_softc *sc = (struct ath_softc *) data;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_btcoex *btcoex = &sc->btcoex;
-	struct ath_common *common = ath9k_hw_common(ah);
 	u32 timer_period;
 	bool is_btscan;
 
@@ -186,7 +185,7 @@ static void ath_btcoex_period_timer(unsigned long data)
 
 	spin_lock_bh(&btcoex->btcoex_lock);
 
-	ath9k_cmn_btcoex_bt_stomp(common, is_btscan ? ATH_BTCOEX_STOMP_ALL :
+	ath9k_hw_btcoex_bt_stomp(ah, is_btscan ? ATH_BTCOEX_STOMP_ALL :
 			      btcoex->bt_stomp_type);
 
 	spin_unlock_bh(&btcoex->btcoex_lock);
@@ -224,9 +223,9 @@ static void ath_btcoex_no_stomp_timer(void *arg)
 	spin_lock_bh(&btcoex->btcoex_lock);
 
 	if (btcoex->bt_stomp_type == ATH_BTCOEX_STOMP_LOW || is_btscan)
-		ath9k_cmn_btcoex_bt_stomp(common, ATH_BTCOEX_STOMP_NONE);
+		ath9k_hw_btcoex_bt_stomp(ah, ATH_BTCOEX_STOMP_NONE);
 	 else if (btcoex->bt_stomp_type == ATH_BTCOEX_STOMP_ALL)
-		ath9k_cmn_btcoex_bt_stomp(common, ATH_BTCOEX_STOMP_LOW);
+		ath9k_hw_btcoex_bt_stomp(ah, ATH_BTCOEX_STOMP_LOW);
 
 	spin_unlock_bh(&btcoex->btcoex_lock);
 }
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
index d051a42..26ede1d 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
@@ -77,7 +77,7 @@ static void ath_btcoex_period_work(struct work_struct *work)
 		return;
 	}
 
-	ath9k_cmn_btcoex_bt_stomp(common, is_btscan ? ATH_BTCOEX_STOMP_ALL :
+	ath9k_hw_btcoex_bt_stomp(priv->ah, is_btscan ? ATH_BTCOEX_STOMP_ALL :
 			btcoex->bt_stomp_type);
 
 	timer_period = is_btscan ? btcoex->btscan_no_stomp :
@@ -105,9 +105,9 @@ static void ath_btcoex_duty_cycle_work(struct work_struct *work)
 		"time slice work for bt and wlan\n");
 
 	if (btcoex->bt_stomp_type == ATH_BTCOEX_STOMP_LOW || is_btscan)
-		ath9k_cmn_btcoex_bt_stomp(common, ATH_BTCOEX_STOMP_NONE);
+		ath9k_hw_btcoex_bt_stomp(ah, ATH_BTCOEX_STOMP_NONE);
 	else if (btcoex->bt_stomp_type == ATH_BTCOEX_STOMP_ALL)
-		ath9k_cmn_btcoex_bt_stomp(common, ATH_BTCOEX_STOMP_LOW);
+		ath9k_hw_btcoex_bt_stomp(ah, ATH_BTCOEX_STOMP_LOW);
 }
 
 void ath_htc_init_btcoex_work(struct ath9k_htc_priv *priv)
-- 
1.7.1

