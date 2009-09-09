Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54038 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692AbZIIXo7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2009 19:44:59 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@linuxdriverproject.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 07/15] ath9k: replaces SC_OP_BTCOEX_ENABLED with a bool
Date: Wed,  9 Sep 2009 19:44:53 -0400
Message-Id: <1252539901-20679-8-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252539901-20679-1-git-send-email-lrodriguez@atheros.com>
References: <1252539901-20679-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Whether or not bluetooth coex has been enabled is a hardware
state and only the hardware helpers will be able to set this.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |    1 -
 drivers/net/wireless/ath/ath9k/btcoex.c |    4 ++--
 drivers/net/wireless/ath/ath9k/btcoex.h |    1 +
 drivers/net/wireless/ath/ath9k/hw.c     |    2 +-
 drivers/net/wireless/ath/ath9k/main.c   |    4 ++--
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index f001cc2..891e71b 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -532,7 +532,6 @@ struct ath_led {
 #define SC_OP_WAIT_FOR_PSPOLL_DATA BIT(17)
 #define SC_OP_WAIT_FOR_TX_ACK   BIT(18)
 #define SC_OP_BEACON_SYNC       BIT(19)
-#define SC_OP_BTCOEX_ENABLED    BIT(20)
 #define SC_OP_BT_PRIORITY_DETECTED BIT(21)
 
 struct ath_bus_ops {
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index 61a8e1d..91befc7 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -164,7 +164,7 @@ void ath9k_hw_btcoex_enable(struct ath_hw *ah)
 		(0x2 << (btcoex_info->btactive_gpio * 2)),
 		(0x3 << (btcoex_info->btactive_gpio * 2)));
 
-	ah->ah_sc->sc_flags |= SC_OP_BTCOEX_ENABLED;
+	ah->btcoex_info.enabled = true;
 }
 
 void ath9k_hw_btcoex_disable(struct ath_hw *ah)
@@ -182,5 +182,5 @@ void ath9k_hw_btcoex_disable(struct ath_hw *ah)
 		REG_WRITE(ah, AR_BT_COEX_MODE2, 0);
 	}
 
-	ah->ah_sc->sc_flags &= ~SC_OP_BTCOEX_ENABLED;
+	ah->btcoex_info.enabled = false;
 }
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
index ed8d01d..b2c3f76 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.h
+++ b/drivers/net/wireless/ath/ath9k/btcoex.h
@@ -64,6 +64,7 @@ struct ath_btcoex_config {
 
 struct ath_btcoex_info {
 	enum ath_btcoex_scheme btcoex_scheme;
+	bool enabled;
 	u8 wlanactive_gpio;
 	u8 btactive_gpio;
 	u8 btpriority_gpio;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 9be5587..30d83cb 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2560,7 +2560,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 #endif
 	}
 
-	if (ah->ah_sc->sc_flags & SC_OP_BTCOEX_ENABLED)
+	if (ah->btcoex_info.enabled)
 		ath9k_hw_btcoex_enable(ah);
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e6a42d2..90be4ed 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2203,7 +2203,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, 0);
 
 	if ((ah->btcoex_info.btcoex_scheme != ATH_BTCOEX_CFG_NONE) &&
-	    !(sc->sc_flags & SC_OP_BTCOEX_ENABLED)) {
+	    !ah->btcoex_info.enabled) {
 		ath9k_hw_btcoex_init_weight(ah);
 		ath9k_hw_btcoex_enable(ah);
 
@@ -2362,7 +2362,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 		return; /* another wiphy still in use */
 	}
 
-	if (sc->sc_flags & SC_OP_BTCOEX_ENABLED) {
+	if (ah->btcoex_info.enabled) {
 		ath9k_hw_btcoex_disable(ah);
 		if (ah->btcoex_info.btcoex_scheme == ATH_BTCOEX_CFG_3WIRE)
 			ath9k_btcoex_timer_pause(sc);
-- 
1.6.3.3

