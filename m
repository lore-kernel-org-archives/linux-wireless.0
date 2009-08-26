Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:45795 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbZHZPrD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 11:47:03 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 08:47:06 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 1/8] ath9k: Split ath9k_hw_btcoex_enable() into two logical pieces
Date: Wed, 26 Aug 2009 21:08:43 +0530
Message-ID: <1251301130-10912-2-git-send-email-vasanth@atheros.com>
In-Reply-To: <1251301130-10912-1-git-send-email-vasanth@atheros.com>
References: <1251301130-10912-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function currently does initialization + enable the
btcoex support. Split it into two logical functions which
does the above operations separately. Btcoex initialization
is done during attach time and enabling this feature is done
in start(). Also, add code to disable btcoex support in stop().

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/hw.c    |   17 ++++++++++++++++-
 drivers/net/wireless/ath/ath9k/hw.h    |    2 ++
 drivers/net/wireless/ath/ath9k/main.c  |   11 +++++++++--
 4 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 7705da1..0868800 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -521,6 +521,7 @@ struct ath_led {
 #define SC_OP_WAIT_FOR_PSPOLL_DATA BIT(17)
 #define SC_OP_WAIT_FOR_TX_ACK   BIT(18)
 #define SC_OP_BEACON_SYNC       BIT(19)
+#define SC_OP_BTCOEX_ENABLED    BIT(20)
 
 struct ath_bus_ops {
 	void		(*read_cachesize)(struct ath_softc *sc, int *csz);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 4f3d5ea..d81e826 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -4073,7 +4073,7 @@ void ath9k_hw_set11nmac2040(struct ath_hw *ah, enum ath9k_ht_macmode mode)
 /*  Bluetooth Coexistence  */
 /***************************/
 
-void ath9k_hw_btcoex_enable(struct ath_hw *ah)
+void ath9k_hw_btcoex_init(struct ath_hw *ah)
 {
 	/* connect bt_active to baseband */
 	REG_CLR_BIT(ah, AR_GPIO_INPUT_EN_VAL,
@@ -4090,8 +4090,23 @@ void ath9k_hw_btcoex_enable(struct ath_hw *ah)
 
 	/* Configure the desired gpio port for input */
 	ath9k_hw_cfg_gpio_input(ah, ah->btactive_gpio);
+}
 
+void ath9k_hw_btcoex_enable(struct ath_hw *ah)
+{
 	/* Configure the desired GPIO port for TX_FRAME output */
 	ath9k_hw_cfg_output(ah, ah->wlanactive_gpio,
 			    AR_GPIO_OUTPUT_MUX_AS_TX_FRAME);
+
+	ah->ah_sc->sc_flags |= SC_OP_BTCOEX_ENABLED;
+}
+
+void ath9k_hw_btcoex_disable(struct ath_hw *ah)
+{
+	ath9k_hw_set_gpio(ah, ah->wlanactive_gpio, 0);
+
+	ath9k_hw_cfg_output(ah, ah->wlanactive_gpio,
+			AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
+
+	ah->ah_sc->sc_flags &= ~SC_OP_BTCOEX_ENABLED;
 }
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index b24150a..e634cb4 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -614,6 +614,8 @@ bool ath9k_hw_intrpend(struct ath_hw *ah);
 bool ath9k_hw_getisr(struct ath_hw *ah, enum ath9k_int *masked);
 enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints);
 
+void ath9k_hw_btcoex_init(struct ath_hw *ah);
 void ath9k_hw_btcoex_enable(struct ath_hw *ah);
+void ath9k_hw_btcoex_disable(struct ath_hw *ah);
 
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index eb8d673..878d3be 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1509,8 +1509,8 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc)
 			ARRAY_SIZE(ath9k_5ghz_chantable);
 	}
 
-	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_BT_COEX)
-		ath9k_hw_btcoex_enable(sc->sc_ah);
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_BT_COEX)
+		ath9k_hw_btcoex_init(ah);
 
 	return 0;
 bad2:
@@ -1992,6 +1992,10 @@ static int ath9k_start(struct ieee80211_hw *hw)
 
 	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, 0);
 
+	if ((sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_BT_COEX) &&
+	    !(sc->sc_flags & SC_OP_BTCOEX_ENABLED))
+		ath9k_hw_btcoex_enable(sc->sc_ah);
+
 mutex_unlock:
 	mutex_unlock(&sc->mutex);
 
@@ -2138,6 +2142,9 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	wiphy_rfkill_stop_polling(sc->hw->wiphy);
 
+	if (sc->sc_flags & SC_OP_BTCOEX_ENABLED)
+		ath9k_hw_btcoex_disable(sc->sc_ah);
+
 	/* disable HAL and put h/w to sleep */
 	ath9k_hw_disable(sc->sc_ah);
 	ath9k_hw_configpcipowersave(sc->sc_ah, 1);
-- 
1.5.5.1

