Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:15532 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757314AbZEONen (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 09:34:43 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 15 May 2009 06:34:45 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k: Print hw reset failure status as signed int
Date: Fri, 15 May 2009 18:59:20 +0530
Message-ID: <1242394162-9812-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |   10 +++++-----
 drivers/net/wireless/ath/ath9k/xmit.c |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index df9b7c1..c161b75 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -280,7 +280,7 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 	if (r) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"Unable to reset channel (%u Mhz) "
-			"reset status %u\n",
+			"reset status %d\n",
 			channel->center_freq, r);
 		spin_unlock_bh(&sc->sc_resetlock);
 		return r;
@@ -1090,7 +1090,7 @@ void ath_radio_enable(struct ath_softc *sc)
 	if (r) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"Unable to reset channel %u (%uMhz) ",
-			"reset status %u\n",
+			"reset status %d\n",
 			channel->center_freq, r);
 	}
 	spin_unlock_bh(&sc->sc_resetlock);
@@ -1142,7 +1142,7 @@ void ath_radio_disable(struct ath_softc *sc)
 	if (r) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"Unable to reset channel %u (%uMhz) "
-			"reset status %u\n",
+			"reset status %d\n",
 			channel->center_freq, r);
 	}
 	spin_unlock_bh(&sc->sc_resetlock);
@@ -1705,7 +1705,7 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 	r = ath9k_hw_reset(ah, sc->sc_ah->curchan, false);
 	if (r)
 		DPRINTF(sc, ATH_DBG_FATAL,
-			"Unable to reset hardware; reset status %u\n", r);
+			"Unable to reset hardware; reset status %d\n", r);
 	spin_unlock_bh(&sc->sc_resetlock);
 
 	if (ath_startrecv(sc) != 0)
@@ -1997,7 +1997,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	r = ath9k_hw_reset(sc->sc_ah, init_channel, false);
 	if (r) {
 		DPRINTF(sc, ATH_DBG_FATAL,
-			"Unable to reset hardware; reset status %u "
+			"Unable to reset hardware; reset status %d "
 			"(freq %u MHz)\n", r,
 			curchan->center_freq);
 		spin_unlock_bh(&sc->sc_resetlock);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 41c4282..3f2bd79 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1070,7 +1070,7 @@ void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
 		r = ath9k_hw_reset(ah, sc->sc_ah->curchan, true);
 		if (r)
 			DPRINTF(sc, ATH_DBG_FATAL,
-				"Unable to reset hardware; reset status %u\n",
+				"Unable to reset hardware; reset status %d\n",
 				r);
 		spin_unlock_bh(&sc->sc_resetlock);
 	}
-- 
1.5.5.1

