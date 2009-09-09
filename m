Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54029 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588AbZIIXo7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2009 19:44:59 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@linuxdriverproject.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 13/15] ath9k: now move ath9k_hw_btcoex_set_weight() to btcoex.c
Date: Wed,  9 Sep 2009 19:44:59 -0400
Message-Id: <1252539901-20679-14-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252539901-20679-1-git-send-email-lrodriguez@atheros.com>
References: <1252539901-20679-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After some necessary cleanups we now move ath9k_hw_btcoex_set_weight()
to where it belongs.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/btcoex.c |   10 ++++++++++
 drivers/net/wireless/ath/ath9k/btcoex.h |    3 +++
 drivers/net/wireless/ath/ath9k/main.c   |   18 ++----------------
 3 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index 0b5a7d4..4cca023 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -124,6 +124,16 @@ static void ath9k_hw_btcoex_enable_2wire(struct ath_hw *ah)
 			    AR_GPIO_OUTPUT_MUX_AS_TX_FRAME);
 }
 
+void ath9k_hw_btcoex_set_weight(struct ath_hw *ah,
+				u32 bt_weight,
+				u32 wlan_weight)
+{
+	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
+
+	btcoex_hw->bt_coex_weights = SM(bt_weight, AR_BTCOEX_BT_WGHT) |
+				     SM(wlan_weight, AR_BTCOEX_WL_WGHT);
+}
+
 static void ath9k_hw_btcoex_enable_3wire(struct ath_hw *ah)
 {
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
index 296ddd8..971d200 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.h
+++ b/drivers/net/wireless/ath/ath9k/btcoex.h
@@ -70,6 +70,9 @@ bool ath_btcoex_supported(u16 subsysid);
 void ath9k_hw_btcoex_init_2wire(struct ath_hw *ah);
 void ath9k_hw_btcoex_init_3wire(struct ath_hw *ah);
 void ath9k_hw_init_btcoex_hw(struct ath_hw *ah, int qnum);
+void ath9k_hw_btcoex_set_weight(struct ath_hw *ah,
+				u32 bt_weight,
+				u32 wlan_weight);
 void ath9k_hw_btcoex_enable(struct ath_hw *ah);
 void ath9k_hw_btcoex_disable(struct ath_hw *ah);
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index c8f2ff6..5a33d01 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1336,21 +1336,6 @@ static void ath_detect_bt_priority(struct ath_softc *sc)
 	}
 }
 
-static void ath9k_hw_btcoex_set_weight(struct ath_hw *ah,
-				       u32 bt_weight,
-				       u32 wlan_weight)
-{
-	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
-
-	btcoex_hw->bt_coex_weights = SM(bt_weight, AR_BTCOEX_BT_WGHT) |
-				     SM(wlan_weight, AR_BTCOEX_WL_WGHT);
-}
-
-static void ath9k_hw_btcoex_init_weight(struct ath_hw *ah)
-{
-	ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT, AR_STOMP_LOW_WLAN_WGHT);
-}
-
 /*
  * Configures appropriate weight based on stomp type.
  */
@@ -2204,7 +2189,8 @@ static int ath9k_start(struct ieee80211_hw *hw)
 
 	if ((ah->btcoex_hw.scheme != ATH_BTCOEX_CFG_NONE) &&
 	    !ah->btcoex_hw.enabled) {
-		ath9k_hw_btcoex_init_weight(ah);
+		ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT,
+					   AR_STOMP_LOW_WLAN_WGHT);
 		ath9k_hw_btcoex_enable(ah);
 
 		ath_pcie_aspm_disable(sc);
-- 
1.6.3.3

