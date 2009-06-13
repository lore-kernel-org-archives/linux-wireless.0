Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:45034 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754161AbZFMJ0m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Jun 2009 05:26:42 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 13 Jun 2009 02:26:45 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 1/3] ath9k: Add helper to get ath9k specific current channel
Date: Sat, 13 Jun 2009 14:50:24 +0530
Message-ID: <1244884826-3009-2-git-send-email-vasanth@atheros.com>
In-Reply-To: <1244884826-3009-1-git-send-email-vasanth@atheros.com>
References: <1244884826-3009-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index afac281..5fd17a4 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -231,6 +231,19 @@ static void ath_setup_rates(struct ath_softc *sc, enum ieee80211_band band)
 	}
 }
 
+static struct ath9k_channel *ath_get_curchannel(struct ath_softc *sc,
+						struct ieee80211_hw *hw)
+{
+	struct ieee80211_channel *curchan = hw->conf.channel;
+	struct ath9k_channel *channel;
+	u8 chan_idx;
+
+	chan_idx = curchan->hw_value;
+	channel = &sc->sc_ah->channels[chan_idx];
+	ath9k_update_ichannel(sc, hw, channel);
+	return channel;
+}
+
 /*
  * Set/change channels.  If the channel is really being changed, it's done
  * by reseting the chip.  To accomplish this we must first cleanup any pending
@@ -1925,7 +1938,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	struct ath_softc *sc = aphy->sc;
 	struct ieee80211_channel *curchan = hw->conf.channel;
 	struct ath9k_channel *init_channel;
-	int r, pos;
+	int r;
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "Starting driver with "
 		"initial channel: %d MHz\n", curchan->center_freq);
@@ -1955,11 +1968,9 @@ static int ath9k_start(struct ieee80211_hw *hw)
 
 	/* setup initial channel */
 
-	pos = curchan->hw_value;
+	sc->chan_idx = curchan->hw_value;
 
-	sc->chan_idx = pos;
-	init_channel = &sc->sc_ah->channels[pos];
-	ath9k_update_ichannel(sc, hw, init_channel);
+	init_channel = ath_get_curchannel(sc, hw);
 
 	/* Reset SERDES registers */
 	ath9k_hw_configpcipowersave(sc->sc_ah, 0);
-- 
1.5.5.1

