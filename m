Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54074 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716AbZIIXpE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2009 19:45:04 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@linuxdriverproject.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 10/15] ath9k: rename btcoex_scheme to just scheme
Date: Wed,  9 Sep 2009 19:44:56 -0400
Message-Id: <1252539901-20679-11-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252539901-20679-1-git-send-email-lrodriguez@atheros.com>
References: <1252539901-20679-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

btcoex_scheme is already part of a btcoex struct, its implied
this is btcoex related.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/btcoex.c |    4 ++--
 drivers/net/wireless/ath/ath9k/btcoex.h |    2 +-
 drivers/net/wireless/ath/ath9k/hw.c     |    6 +++---
 drivers/net/wireless/ath/ath9k/main.c   |   14 +++++++-------
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index ab19072..aa0ec2c 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -147,7 +147,7 @@ void ath9k_hw_btcoex_enable(struct ath_hw *ah)
 {
 	struct ath_btcoex_info *btcoex_info = &ah->btcoex_info;
 
-	switch (btcoex_info->btcoex_scheme) {
+	switch (btcoex_info->scheme) {
 	case ATH_BTCOEX_CFG_NONE:
 		break;
 	case ATH_BTCOEX_CFG_2WIRE:
@@ -174,7 +174,7 @@ void ath9k_hw_btcoex_disable(struct ath_hw *ah)
 	ath9k_hw_cfg_output(ah, btcoex_info->wlanactive_gpio,
 			AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
 
-	if (btcoex_info->btcoex_scheme == ATH_BTCOEX_CFG_3WIRE) {
+	if (btcoex_info->scheme == ATH_BTCOEX_CFG_3WIRE) {
 		REG_WRITE(ah, AR_BT_COEX_MODE, AR_BT_QUIET | AR_BT_MODE);
 		REG_WRITE(ah, AR_BT_COEX_WEIGHT, 0);
 		REG_WRITE(ah, AR_BT_COEX_MODE2, 0);
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
index 72c613d..aea6d3f 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.h
+++ b/drivers/net/wireless/ath/ath9k/btcoex.h
@@ -56,7 +56,7 @@ struct ath_btcoex_config {
 };
 
 struct ath_btcoex_info {
-	enum ath_btcoex_scheme btcoex_scheme;
+	enum ath_btcoex_scheme scheme;
 	bool enabled;
 	u8 wlanactive_gpio;
 	u8 btactive_gpio;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 30d83cb..329d404 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -3693,13 +3693,13 @@ void ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		btcoex_info->wlanactive_gpio = ATH_WLANACTIVE_GPIO;
 
 		if (AR_SREV_9285(ah)) {
-			btcoex_info->btcoex_scheme = ATH_BTCOEX_CFG_3WIRE;
+			btcoex_info->scheme = ATH_BTCOEX_CFG_3WIRE;
 			btcoex_info->btpriority_gpio = ATH_BTPRIORITY_GPIO;
 		} else {
-			btcoex_info->btcoex_scheme = ATH_BTCOEX_CFG_2WIRE;
+			btcoex_info->scheme = ATH_BTCOEX_CFG_2WIRE;
 		}
 	} else {
-		btcoex_info->btcoex_scheme = ATH_BTCOEX_CFG_NONE;
+		btcoex_info->scheme = ATH_BTCOEX_CFG_NONE;
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index bc3b9b0..43f1f7e 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -443,7 +443,7 @@ void ath_update_chainmask(struct ath_softc *sc, int is_ht)
 	struct ath_hw *ah = sc->sc_ah;
 
 	if ((sc->sc_flags & SC_OP_SCANNING) || is_ht ||
-	    (ah->btcoex_info.btcoex_scheme != ATH_BTCOEX_CFG_NONE)) {
+	    (ah->btcoex_info.scheme != ATH_BTCOEX_CFG_NONE)) {
 		sc->tx_chainmask = sc->sc_ah->caps.tx_chainmask;
 		sc->rx_chainmask = sc->sc_ah->caps.rx_chainmask;
 	} else {
@@ -511,7 +511,7 @@ static void ath9k_tasklet(unsigned long data)
 		sc->sc_flags |= SC_OP_WAIT_FOR_BEACON | SC_OP_BEACON_SYNC;
 	}
 
-	if (ah->btcoex_info.btcoex_scheme == ATH_BTCOEX_CFG_3WIRE)
+	if (ah->btcoex_info.scheme == ATH_BTCOEX_CFG_3WIRE)
 		if (status & ATH9K_INT_GENTIMER)
 			ath_gen_timer_isr(sc->sc_ah);
 
@@ -1291,7 +1291,7 @@ void ath_detach(struct ath_softc *sc)
 			ath_tx_cleanupq(sc, &sc->tx.txq[i]);
 
 	if ((sc->btcoex.no_stomp_timer) &&
-	    ah->btcoex_info.btcoex_scheme == ATH_BTCOEX_CFG_3WIRE)
+	    ah->btcoex_info.scheme == ATH_BTCOEX_CFG_3WIRE)
 		ath_gen_timer_free(ah, sc->btcoex.no_stomp_timer);
 
 	ath9k_hw_detach(ah);
@@ -1678,7 +1678,7 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid)
 			ARRAY_SIZE(ath9k_5ghz_chantable);
 	}
 
-	switch (ah->btcoex_info.btcoex_scheme) {
+	switch (ah->btcoex_info.scheme) {
 	case ATH_BTCOEX_CFG_NONE:
 		break;
 	case ATH_BTCOEX_CFG_2WIRE:
@@ -2203,13 +2203,13 @@ static int ath9k_start(struct ieee80211_hw *hw)
 
 	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, 0);
 
-	if ((ah->btcoex_info.btcoex_scheme != ATH_BTCOEX_CFG_NONE) &&
+	if ((ah->btcoex_info.scheme != ATH_BTCOEX_CFG_NONE) &&
 	    !ah->btcoex_info.enabled) {
 		ath9k_hw_btcoex_init_weight(ah);
 		ath9k_hw_btcoex_enable(ah);
 
 		ath_pcie_aspm_disable(sc);
-		if (ah->btcoex_info.btcoex_scheme == ATH_BTCOEX_CFG_3WIRE)
+		if (ah->btcoex_info.scheme == ATH_BTCOEX_CFG_3WIRE)
 			ath9k_btcoex_timer_resume(sc);
 	}
 
@@ -2365,7 +2365,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	if (ah->btcoex_info.enabled) {
 		ath9k_hw_btcoex_disable(ah);
-		if (ah->btcoex_info.btcoex_scheme == ATH_BTCOEX_CFG_3WIRE)
+		if (ah->btcoex_info.scheme == ATH_BTCOEX_CFG_3WIRE)
 			ath9k_btcoex_timer_pause(sc);
 	}
 
-- 
1.6.3.3

