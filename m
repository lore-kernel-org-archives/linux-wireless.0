Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:45804 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655AbZHZPrO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 11:47:14 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 08:47:17 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 6/8] ath9k: Remove hw capability bit meant for btcoex
Date: Wed, 26 Aug 2009 21:08:48 +0530
Message-ID: <1251301130-10912-7-git-send-email-vasanth@atheros.com>
In-Reply-To: <1251301130-10912-6-git-send-email-vasanth@atheros.com>
References: <1251301130-10912-1-git-send-email-vasanth@atheros.com>
 <1251301130-10912-2-git-send-email-vasanth@atheros.com>
 <1251301130-10912-3-git-send-email-vasanth@atheros.com>
 <1251301130-10912-4-git-send-email-vasanth@atheros.com>
 <1251301130-10912-5-git-send-email-vasanth@atheros.com>
 <1251301130-10912-6-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We don't need a hw cap bit for btcoex anymore as btcoex scheme type
is enough to do this.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c   |    1 -
 drivers/net/wireless/ath/ath9k/hw.h   |    1 -
 drivers/net/wireless/ath/ath9k/main.c |    8 +++-----
 3 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 7b4bc8b..c80be8c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -3666,7 +3666,6 @@ void ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		ah->eep_ops->get_num_ant_config(ah, ATH9K_HAL_FREQ_BAND_2GHZ);
 
 	if (AR_SREV_9280_10_OR_LATER(ah) && btcoex_enable) {
-		pCap->hw_caps |= ATH9K_HW_CAP_BT_COEX;
 		btcoex_info->btactive_gpio = ATH_BTACTIVE_GPIO;
 		btcoex_info->wlanactive_gpio = ATH_WLANACTIVE_GPIO;
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 259936c..de10de8 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -151,7 +151,6 @@ enum ath9k_hw_caps {
 	ATH9K_HW_CAP_ENHANCEDPM                 = BIT(14),
 	ATH9K_HW_CAP_AUTOSLEEP                  = BIT(15),
 	ATH9K_HW_CAP_4KB_SPLITTRANS             = BIT(16),
-	ATH9K_HW_CAP_BT_COEX			= BIT(17)
 };
 
 enum ath9k_capability_type {
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 8a2f000..215c672 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -440,7 +440,7 @@ static void ath_start_ani(struct ath_softc *sc)
 void ath_update_chainmask(struct ath_softc *sc, int is_ht)
 {
 	if ((sc->sc_flags & SC_OP_SCANNING) || is_ht ||
-	    (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_BT_COEX)) {
+	    (sc->btcoex_info.btcoex_scheme != ATH_BTCOEX_CFG_NONE)) {
 		sc->tx_chainmask = sc->sc_ah->caps.tx_chainmask;
 		sc->rx_chainmask = sc->sc_ah->caps.rx_chainmask;
 	} else {
@@ -1509,8 +1509,7 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc)
 			ARRAY_SIZE(ath9k_5ghz_chantable);
 	}
 
-	if ((ah->caps.hw_caps & ATH9K_HW_CAP_BT_COEX) &&
-	    (sc->btcoex_info.btcoex_scheme == ATH_BTCOEX_CFG_2WIRE))
+	if (sc->btcoex_info.btcoex_scheme == ATH_BTCOEX_CFG_2WIRE)
 		ath9k_hw_btcoex_init(ah);
 
 	return 0;
@@ -1993,8 +1992,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 
 	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, 0);
 
-	if ((sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_BT_COEX) &&
-	    (sc->btcoex_info.btcoex_scheme == ATH_BTCOEX_CFG_2WIRE) &&
+	if ((sc->btcoex_info.btcoex_scheme == ATH_BTCOEX_CFG_2WIRE) &&
 	    !(sc->sc_flags & SC_OP_BTCOEX_ENABLED))
 		ath9k_hw_btcoex_enable(sc->sc_ah);
 
-- 
1.5.5.1

