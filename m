Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:17438 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754801Ab1ESMjW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2011 08:39:22 -0400
Received: from mail.atheros.com ([10.234.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 19 May 2011 05:38:51 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH] ath9k: mark few functions as static
Date: Thu, 19 May 2011 18:08:57 +0530
Message-ID: <1305808737-11021-1-git-send-email-mshajakhan@atheros.com> (sfid-20110519_143925_326987_0B0247C0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    3 ---
 drivers/net/wireless/ath/ath9k/main.c  |    6 +++---
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index f75068b..2c02505 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -669,10 +669,7 @@ int ath9k_init_device(u16 devid, struct ath_softc *sc, u16 subsysid,
 		    const struct ath_bus_ops *bus_ops);
 void ath9k_deinit_device(struct ath_softc *sc);
 void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw);
-int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
-		    struct ath9k_channel *hchan);
 
-void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw);
 void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw);
 bool ath9k_setpower(struct ath_softc *sc, enum ath9k_power_mode mode);
 bool ath9k_uses_beacons(int type);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a198ee3..b205b7c 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -219,7 +219,7 @@ static int ath_update_survey_stats(struct ath_softc *sc)
  * by reseting the chip.  To accomplish this we must first cleanup any pending
  * DMA, then restart stuff.
 */
-int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
+static int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 		    struct ath9k_channel *hchan)
 {
 	struct ath_hw *ah = sc->sc_ah;
@@ -866,7 +866,7 @@ chip_reset:
 #undef SCHED_INTR
 }
 
-void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
+static void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -2332,7 +2332,7 @@ static bool ath9k_tx_frames_pending(struct ieee80211_hw *hw)
 	return false;
 }
 
-int ath9k_tx_last_beacon(struct ieee80211_hw *hw)
+static int ath9k_tx_last_beacon(struct ieee80211_hw *hw)
 {
 	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
-- 
1.7.0.4

