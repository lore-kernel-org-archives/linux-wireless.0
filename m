Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:17675 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148Ab0HRO15 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 10:27:57 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 18 Aug 2010 07:27:57 -0700
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] ath9k_common: Move bt_stomp to common for sharing with ath9k_htc.
Date: Wed, 18 Aug 2010 19:57:48 +0530
Message-ID: <1282141669-9823-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |    8 ------
 drivers/net/wireless/ath/ath9k/common.c |   31 ++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/common.h |   11 ++++++++
 drivers/net/wireless/ath/ath9k/gpio.c   |   40 ++++--------------------------
 4 files changed, 48 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index def0cd3..f0197a6 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -437,14 +437,6 @@ void ath_ani_calibrate(unsigned long data);
 /* BTCOEX */
 /**********/
 
-/* Defines the BT AR_BT_COEX_WGHT used */
-enum ath_stomp_type {
-	ATH_BTCOEX_NO_STOMP,
-	ATH_BTCOEX_STOMP_ALL,
-	ATH_BTCOEX_STOMP_LOW,
-	ATH_BTCOEX_STOMP_NONE
-};
-
 struct ath_btcoex {
 	bool hw_timer_enabled;
 	spinlock_t btcoex_lock;
diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index 3100c87..31cfe46 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -420,6 +420,37 @@ int ath9k_cmn_count_streams(unsigned int chainmask, int max)
 }
 EXPORT_SYMBOL(ath9k_cmn_count_streams);
 
+/*
+ * Configures appropriate weight based on stomp type.
+ */
+void ath9k_cmn_btcoex_bt_stomp(struct ath_common *common,
+				  enum ath_stomp_type stomp_type)
+{
+	struct ath_hw *ah = common->ah;
+
+	switch (stomp_type) {
+	case ATH_BTCOEX_STOMP_ALL:
+		ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT,
+					   AR_STOMP_ALL_WLAN_WGHT);
+		break;
+	case ATH_BTCOEX_STOMP_LOW:
+		ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT,
+					   AR_STOMP_LOW_WLAN_WGHT);
+		break;
+	case ATH_BTCOEX_STOMP_NONE:
+		ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT,
+					   AR_STOMP_NONE_WLAN_WGHT);
+		break;
+	default:
+		ath_print(common, ATH_DBG_BTCOEX,
+			  "Invalid Stomptype\n");
+		break;
+	}
+
+	ath9k_hw_btcoex_enable(ah);
+}
+EXPORT_SYMBOL(ath9k_cmn_btcoex_bt_stomp);
+
 static int __init ath9k_cmn_init(void)
 {
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index 97809d3..fcc3f9a 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -52,6 +52,14 @@
 #define ATH_EP_RND(x, mul) 						\
 	((((x)%(mul)) >= ((mul)/2)) ? ((x) + ((mul) - 1)) / (mul) : (x)/(mul))
 
+/* Defines the BT AR_BT_COEX_WGHT used */
+enum ath_stomp_type {
+	ATH_BTCOEX_NO_STOMP,
+	ATH_BTCOEX_STOMP_ALL,
+	ATH_BTCOEX_STOMP_LOW,
+	ATH_BTCOEX_STOMP_NONE
+};
+
 int ath9k_cmn_padpos(__le16 frame_control);
 int ath9k_cmn_get_hw_crypto_keytype(struct sk_buff *skb);
 void ath9k_cmn_update_ichannel(struct ieee80211_hw *hw,
@@ -65,3 +73,6 @@ int ath9k_cmn_key_config(struct ath_common *common,
 void ath9k_cmn_key_delete(struct ath_common *common,
 			  struct ieee80211_key_conf *key);
 int ath9k_cmn_count_streams(unsigned int chainmask, int max);
+void ath9k_cmn_btcoex_bt_stomp(struct ath_common *common,
+				  enum ath_stomp_type stomp_type);
+
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 3a8ee99..4a9a68b 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -251,36 +251,6 @@ static void ath_detect_bt_priority(struct ath_softc *sc)
 	}
 }
 
-/*
- * Configures appropriate weight based on stomp type.
- */
-static void ath9k_btcoex_bt_stomp(struct ath_softc *sc,
-				  enum ath_stomp_type stomp_type)
-{
-	struct ath_hw *ah = sc->sc_ah;
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
-		ath_print(ath9k_hw_common(ah), ATH_DBG_BTCOEX,
-			  "Invalid Stomptype\n");
-		break;
-	}
-
-	ath9k_hw_btcoex_enable(ah);
-}
-
 static void ath9k_gen_timer_start(struct ath_hw *ah,
 				  struct ath_gen_timer *timer,
 				  u32 timer_next,
@@ -319,6 +289,7 @@ static void ath_btcoex_period_timer(unsigned long data)
 	struct ath_softc *sc = (struct ath_softc *) data;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_btcoex *btcoex = &sc->btcoex;
+	struct ath_common *common = ath9k_hw_common(ah);
 	u32 timer_period;
 	bool is_btscan;
 
@@ -328,7 +299,7 @@ static void ath_btcoex_period_timer(unsigned long data)
 
 	spin_lock_bh(&btcoex->btcoex_lock);
 
-	ath9k_btcoex_bt_stomp(sc, is_btscan ? ATH_BTCOEX_STOMP_ALL :
+	ath9k_cmn_btcoex_bt_stomp(common, is_btscan ? ATH_BTCOEX_STOMP_ALL :
 			      btcoex->bt_stomp_type);
 
 	spin_unlock_bh(&btcoex->btcoex_lock);
@@ -359,17 +330,18 @@ static void ath_btcoex_no_stomp_timer(void *arg)
 	struct ath_softc *sc = (struct ath_softc *)arg;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_btcoex *btcoex = &sc->btcoex;
+	struct ath_common *common = ath9k_hw_common(ah);
 	bool is_btscan = sc->sc_flags & SC_OP_BT_SCAN;
 
-	ath_print(ath9k_hw_common(ah), ATH_DBG_BTCOEX,
+	ath_print(common, ATH_DBG_BTCOEX,
 		  "no stomp timer running\n");
 
 	spin_lock_bh(&btcoex->btcoex_lock);
 
 	if (btcoex->bt_stomp_type == ATH_BTCOEX_STOMP_LOW || is_btscan)
-		ath9k_btcoex_bt_stomp(sc, ATH_BTCOEX_STOMP_NONE);
+		ath9k_cmn_btcoex_bt_stomp(common, ATH_BTCOEX_STOMP_NONE);
 	 else if (btcoex->bt_stomp_type == ATH_BTCOEX_STOMP_ALL)
-		ath9k_btcoex_bt_stomp(sc, ATH_BTCOEX_STOMP_LOW);
+		ath9k_cmn_btcoex_bt_stomp(common, ATH_BTCOEX_STOMP_LOW);
 
 	spin_unlock_bh(&btcoex->btcoex_lock);
 }
-- 
1.6.3.3

