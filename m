Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:51648 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421AbYHKIq5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2008 04:46:57 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 11 Aug 2008 01:46:57 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18591.63950.871160.902986@localhost.localdomain> (sfid-20080811_104659_618491_38A38018)
Date: Mon, 11 Aug 2008 14:05:26 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>
Subject: [PATCH 09/10] ath9k: Use ah_curchan and remove sc_curchan which is redundant
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.c |   20 +++++++++-----------
 drivers/net/wireless/ath9k/core.h |    1 -
 drivers/net/wireless/ath9k/rc.c   |    4 ++--
 drivers/net/wireless/ath9k/xmit.c |    2 +-
 4 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index 9b8258d..87b4ca5 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -322,16 +322,16 @@ int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 	DPRINTF(sc, ATH_DBG_CONFIG,
 		"%s: %u (%u MHz) -> %u (%u MHz), cflags:%x\n",
 		__func__,
-		ath9k_hw_mhz2ieee(ah, sc->sc_curchan.channel,
-				  sc->sc_curchan.channelFlags),
-		sc->sc_curchan.channel,
+		ath9k_hw_mhz2ieee(ah, sc->sc_ah->ah_curchan->channel,
+				  sc->sc_ah->ah_curchan->channelFlags),
+		sc->sc_ah->ah_curchan->channel,
 		ath9k_hw_mhz2ieee(ah, hchan->channel, hchan->channelFlags),
 		hchan->channel, hchan->channelFlags);
 
 	ht_macmode = ath_cwm_macmode(sc);
 
-	if (hchan->channel != sc->sc_curchan.channel ||
-	    hchan->channelFlags != sc->sc_curchan.channelFlags ||
+	if (hchan->channel != sc->sc_ah->ah_curchan->channel ||
+	    hchan->channelFlags != sc->sc_ah->ah_curchan->channelFlags ||
 	    (sc->sc_flags & SC_OP_CHAINMASK_UPDATE) ||
 	    (sc->sc_flags & SC_OP_FULL_RESET)) {
 		int status;
@@ -372,7 +372,6 @@ int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 		}
 		spin_unlock_bh(&sc->sc_resetlock);
 
-		sc->sc_curchan = *hchan;
 		sc->sc_flags &= ~SC_OP_CHAINMASK_UPDATE;
 		sc->sc_flags &= ~SC_OP_FULL_RESET;
 
@@ -702,16 +701,15 @@ int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)
 	 * be followed by initialization of the appropriate bits
 	 * and then setup of the interrupt mask.
 	 */
-	sc->sc_curchan = *initial_chan;
 
 	spin_lock_bh(&sc->sc_resetlock);
-	if (!ath9k_hw_reset(ah, &sc->sc_curchan, ht_macmode,
+	if (!ath9k_hw_reset(ah, initial_chan, ht_macmode,
 			   sc->sc_tx_chainmask, sc->sc_rx_chainmask,
 			   sc->sc_ht_extprotspacing, false, &status)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: unable to reset hardware; hal status %u "
 			"(freq %u flags 0x%x)\n", __func__, status,
-			sc->sc_curchan.channel, sc->sc_curchan.channelFlags);
+			initial_chan->channel, initial_chan->channelFlags);
 		error = -EIO;
 		spin_unlock_bh(&sc->sc_resetlock);
 		goto done;
@@ -793,7 +791,7 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 
 	/* Reset chip */
 	spin_lock_bh(&sc->sc_resetlock);
-	if (!ath9k_hw_reset(ah, &sc->sc_curchan,
+	if (!ath9k_hw_reset(ah, sc->sc_ah->ah_curchan,
 			   ht_macmode,
 			   sc->sc_tx_chainmask, sc->sc_rx_chainmask,
 			   sc->sc_ht_extprotspacing, false, &status)) {
@@ -813,7 +811,7 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 	 * that changes the channel so update any state that
 	 * might change as a result.
 	 */
-	ath_setcurmode(sc, ath_chan2mode(&sc->sc_curchan));
+	ath_setcurmode(sc, ath_chan2mode(sc->sc_ah->ah_curchan));
 
 	ath_update_txpow(sc);
 
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 702f7b8..7f4bd15 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -1001,7 +1001,6 @@ struct ath_softc {
 	/* Channel, Band */
 	struct ieee80211_channel channels[IEEE80211_NUM_BANDS][ATH_CHAN_MAX];
 	struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
-	struct ath9k_channel sc_curchan;
 
 	/* Locks */
 	spinlock_t sc_rxflushlock;
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 20e1084..1392361 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -847,9 +847,9 @@ void ath_rate_newstate(struct ath_softc *sc, struct ath_vap *avp)
 	/* For half and quarter rate channles use different
 	 * rate tables
 	 */
-	if (sc->sc_curchan.channelFlags & CHANNEL_HALF)
+	if (sc->sc_ah->ah_curchan->channelFlags & CHANNEL_HALF)
 		ar5416_sethalf_ratetable(asc);
-	else if (sc->sc_curchan.channelFlags & CHANNEL_QUARTER)
+	else if (sc->sc_ah->ah_curchan->channelFlags & CHANNEL_QUARTER)
 		ar5416_setquarter_ratetable(asc);
 	else /* full rate */
 		ar5416_setfull_ratetable(asc);
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 75a8492..9ea5d93 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -1456,7 +1456,7 @@ static void ath_drain_txdataq(struct ath_softc *sc, bool retry_tx)
 
 		spin_lock_bh(&sc->sc_resetlock);
 		if (!ath9k_hw_reset(ah,
-			&sc->sc_curchan, ht_macmode,
+			sc->sc_ah->ah_curchan, ht_macmode,
 			sc->sc_tx_chainmask, sc->sc_rx_chainmask,
 			sc->sc_ht_extprotspacing, true, &status)) {
 
-- 
1.5.6.5

