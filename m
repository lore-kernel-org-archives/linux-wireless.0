Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:14670 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299Ab1AaSSi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 13:18:38 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 10:18:19 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 2/5] ath9k: use common get current channel function
Date: Mon, 31 Jan 2011 23:47:43 +0530
Message-ID: <1296497866-3189-2-git-send-email-rmanoharan@atheros.com>
In-Reply-To: <1296497866-3189-1-git-send-email-rmanoharan@atheros.com>
References: <1296497866-3189-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |   19 +++----------------
 1 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 20c70ba..9e3faa6 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -64,19 +64,6 @@ static u8 parse_mpdudensity(u8 mpdudensity)
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
-	ath9k_cmn_update_ichannel(channel, curchan, hw->conf.channel_type);
-	return channel;
-}
-
 bool ath9k_setpower(struct ath_softc *sc, enum ath9k_power_mode mode)
 {
 	unsigned long flags;
@@ -861,7 +848,7 @@ void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	ath9k_hw_configpcipowersave(ah, 0, 0);
 
 	if (!ah->curchan)
-		ah->curchan = ath_get_curchannel(sc, sc->hw);
+		ah->curchan = ath9k_cmn_get_curchannel(sc->hw, ah);
 
 	r = ath9k_hw_reset(ah, ah->curchan, ah->caldata, false);
 	if (r) {
@@ -922,7 +909,7 @@ void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	ath_flushrecv(sc);		/* flush recv queue */
 
 	if (!ah->curchan)
-		ah->curchan = ath_get_curchannel(sc, hw);
+		ah->curchan = ath9k_cmn_get_curchannel(hw, ah);
 
 	r = ath9k_hw_reset(ah, ah->curchan, ah->caldata, false);
 	if (r) {
@@ -1023,7 +1010,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	/* setup initial channel */
 	sc->chan_idx = curchan->hw_value;
 
-	init_channel = ath_get_curchannel(sc, hw);
+	init_channel = ath9k_cmn_get_curchannel(hw, ah);
 
 	/* Reset SERDES registers */
 	ath9k_hw_configpcipowersave(ah, 0, 0);
-- 
1.7.3.5

