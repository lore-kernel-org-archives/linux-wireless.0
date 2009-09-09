Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54039 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbZIIXo7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2009 19:44:59 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@linuxdriverproject.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 12/15] ath9k: simplify ath_btcoex_bt_stomp()
Date: Wed,  9 Sep 2009 19:44:58 -0400
Message-Id: <1252539901-20679-13-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252539901-20679-1-git-send-email-lrodriguez@atheros.com>
References: <1252539901-20679-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The second argument is always the hardware bt coex struct, so
remove it, and rename the function on the path with a ath9k_ prefix.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |   43 ++++++++++++++++-----------------
 1 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 1a89e47..c8f2ff6 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1336,47 +1336,48 @@ static void ath_detect_bt_priority(struct ath_softc *sc)
 	}
 }
 
-static void ath_btcoex_set_weight(struct ath_btcoex_hw *btcoex_hw,
-				  u32 bt_weight,
-				  u32 wlan_weight)
+static void ath9k_hw_btcoex_set_weight(struct ath_hw *ah,
+				       u32 bt_weight,
+				       u32 wlan_weight)
 {
+	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
+
 	btcoex_hw->bt_coex_weights = SM(bt_weight, AR_BTCOEX_BT_WGHT) |
-				       SM(wlan_weight, AR_BTCOEX_WL_WGHT);
+				     SM(wlan_weight, AR_BTCOEX_WL_WGHT);
 }
 
 static void ath9k_hw_btcoex_init_weight(struct ath_hw *ah)
 {
-	ath_btcoex_set_weight(&ah->btcoex_hw, AR_BT_COEX_WGHT,
-			      AR_STOMP_LOW_WLAN_WGHT);
+	ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT, AR_STOMP_LOW_WLAN_WGHT);
 }
 
 /*
  * Configures appropriate weight based on stomp type.
  */
-static void ath_btcoex_bt_stomp(struct ath_softc *sc,
-				struct ath_btcoex_hw *btcoex_hw,
-				int stomp_type)
+static void ath9k_btcoex_bt_stomp(struct ath_softc *sc,
+				  enum ath_stomp_type stomp_type)
 {
+	struct ath_hw *ah = sc->sc_ah;
 
 	switch (stomp_type) {
 	case ATH_BTCOEX_STOMP_ALL:
-		ath_btcoex_set_weight(btcoex_hw, AR_BT_COEX_WGHT,
-				      AR_STOMP_ALL_WLAN_WGHT);
+		ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT,
+					   AR_STOMP_ALL_WLAN_WGHT);
 		break;
 	case ATH_BTCOEX_STOMP_LOW:
-		ath_btcoex_set_weight(btcoex_hw, AR_BT_COEX_WGHT,
-				      AR_STOMP_LOW_WLAN_WGHT);
+		ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT,
+					   AR_STOMP_LOW_WLAN_WGHT);
 		break;
 	case ATH_BTCOEX_STOMP_NONE:
-		ath_btcoex_set_weight(btcoex_hw, AR_BT_COEX_WGHT,
-				      AR_STOMP_NONE_WLAN_WGHT);
+		ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT,
+					   AR_STOMP_NONE_WLAN_WGHT);
 		break;
 	default:
-		DPRINTF(sc->sc_ah, ATH_DBG_BTCOEX, "Invalid Stomptype\n");
+		DPRINTF(ah, ATH_DBG_BTCOEX, "Invalid Stomptype\n");
 		break;
 	}
 
-	ath9k_hw_btcoex_enable(sc->sc_ah);
+	ath9k_hw_btcoex_enable(ah);
 }
 
 /*
@@ -1389,13 +1390,12 @@ static void ath_btcoex_period_timer(unsigned long data)
 	struct ath_softc *sc = (struct ath_softc *) data;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_btcoex *btcoex = &sc->btcoex;
-	struct ath_btcoex_hw *btcoex_hw= &ah->btcoex_hw;
 
 	ath_detect_bt_priority(sc);
 
 	spin_lock_bh(&btcoex->btcoex_lock);
 
-	ath_btcoex_bt_stomp(sc, btcoex_hw, btcoex->bt_stomp_type);
+	ath9k_btcoex_bt_stomp(sc, btcoex->bt_stomp_type);
 
 	spin_unlock_bh(&btcoex->btcoex_lock);
 
@@ -1424,16 +1424,15 @@ static void ath_btcoex_no_stomp_timer(void *arg)
 	struct ath_softc *sc = (struct ath_softc *)arg;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_btcoex *btcoex = &sc->btcoex;
-	struct ath_btcoex_hw *btcoex_hw= &ah->btcoex_hw;
 
 	DPRINTF(ah, ATH_DBG_BTCOEX, "no stomp timer running \n");
 
 	spin_lock_bh(&btcoex->btcoex_lock);
 
 	if (btcoex->bt_stomp_type == ATH_BTCOEX_STOMP_LOW)
-		ath_btcoex_bt_stomp(sc, btcoex_hw, ATH_BTCOEX_STOMP_NONE);
+		ath9k_btcoex_bt_stomp(sc, ATH_BTCOEX_STOMP_NONE);
 	 else if (btcoex->bt_stomp_type == ATH_BTCOEX_STOMP_ALL)
-		ath_btcoex_bt_stomp(sc, btcoex_hw, ATH_BTCOEX_STOMP_LOW);
+		ath9k_btcoex_bt_stomp(sc, ATH_BTCOEX_STOMP_LOW);
 
 	spin_unlock_bh(&btcoex->btcoex_lock);
 }
-- 
1.6.3.3

