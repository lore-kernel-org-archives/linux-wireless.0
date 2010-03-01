Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:37859 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072Ab0CAJRw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 04:17:52 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 01 Mar 2010 01:17:52 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19339.35508.571751.304682@gargle.gargle.HOWL>
Date: Mon, 1 Mar 2010 15:06:52 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 6/7] ath9k: Use channel routine from library
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

And remove the redundant code in ath9k.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |   19 +++----------------
 1 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 693932d..40cff90 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -96,19 +96,6 @@ static u8 parse_mpdudensity(u8 mpdudensity)
 	}
 }
 
-static struct ath9k_channel *ath_get_curchannel(struct ath_softc *sc,
-						struct ieee80211_hw *hw)
-{
-	struct ieee80211_channel *curchan = hw->conf.channel;
-	struct ath9k_channel *channel;
-	u8 chan_idx;
-
-	chan_idx = curchan->hw_value;
-	channel = &sc->sc_ah->channels[chan_idx];
-	ath9k_update_ichannel(hw, channel);
-	return channel;
-}
-
 bool ath9k_setpower(struct ath_softc *sc, enum ath9k_power_mode mode)
 {
 	unsigned long flags;
@@ -594,7 +581,7 @@ void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	ath9k_hw_configpcipowersave(ah, 0, 0);
 
 	if (!ah->curchan)
-		ah->curchan = ath_get_curchannel(sc, sc->hw);
+		ah->curchan = ath9k_get_curchannel(hw, ah);
 
 	spin_lock_bh(&sc->sc_resetlock);
 	r = ath9k_hw_reset(ah, ah->curchan, false);
@@ -649,7 +636,7 @@ void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	ath_flushrecv(sc);		/* flush recv queue */
 
 	if (!ah->curchan)
-		ah->curchan = ath_get_curchannel(sc, hw);
+		ah->curchan = ath9k_get_curchannel(hw, ah);
 
 	spin_lock_bh(&sc->sc_resetlock);
 	r = ath9k_hw_reset(ah, ah->curchan, false);
@@ -823,7 +810,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 
 	sc->chan_idx = curchan->hw_value;
 
-	init_channel = ath_get_curchannel(sc, hw);
+	init_channel = ath9k_get_curchannel(hw, ah);
 
 	/* Reset SERDES registers */
 	ath9k_hw_configpcipowersave(ah, 0, 0);
-- 
1.7.0.1

