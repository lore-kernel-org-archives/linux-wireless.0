Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:12569 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756163Ab0FPKLc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 06:11:32 -0400
Received: from vs3000.wh2.ocn.ne.jp (125.206.180.163)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0575243091
	for <linux-wireless@vger.kernel.org>; Wed, 16 Jun 2010 19:11:31 +0900 (JST)
Subject: [PATCH 01/17] ath5k: more debug prints for resets
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 16 Jun 2010 19:11:12 +0900
Message-ID: <20100616101112.10067.82778.stgit@tt-desk>
In-Reply-To: <20100616100809.10067.34787.stgit@tt-desk>
References: <20100616100809.10067.34787.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a debug print for every case of reset.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/base.c  |   14 +++++++++++---
 drivers/net/wireless/ath/ath5k/debug.c |    1 +
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 9d37c1a..936afd7 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1111,8 +1111,9 @@ ath5k_setup_bands(struct ieee80211_hw *hw)
 static int
 ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 {
-	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "(%u MHz) -> (%u MHz)\n",
-		sc->curchan->center_freq, chan->center_freq);
+	ATH5K_DBG(sc, ATH5K_DEBUG_RESET,
+		  "channel set, resetting (%u -> %u MHz)\n",
+		  sc->curchan->center_freq, chan->center_freq);
 
 	/*
 	 * To switch channels clear any pending DMA operations;
@@ -2298,6 +2299,8 @@ ath5k_beacon_send(struct ath5k_softc *sc)
 			ATH5K_DBG(sc, ATH5K_DEBUG_BEACON,
 				"stuck beacon time (%u missed)\n",
 				sc->bmisscount);
+			ATH5K_DBG(sc, ATH5K_DEBUG_RESET,
+				  "stuck beacon, resetting\n");
 			tasklet_schedule(&sc->restq);
 		}
 		return;
@@ -2705,6 +2708,8 @@ ath5k_intr(int irq, void *dev_id)
 			 * Fatal errors are unrecoverable.
 			 * Typically these are caused by DMA errors.
 			 */
+			ATH5K_DBG(sc, ATH5K_DEBUG_RESET,
+				  "fatal int, resetting\n");
 			tasklet_schedule(&sc->restq);
 		} else if (unlikely(status & AR5K_INT_RXORN)) {
 			/*
@@ -2717,8 +2722,11 @@ ath5k_intr(int irq, void *dev_id)
 			 * this guess is copied from the HAL.
 			 */
 			sc->stats.rxorn_intr++;
-			if (ah->ah_mac_srev < AR5K_SREV_AR5212)
+			if (ah->ah_mac_srev < AR5K_SREV_AR5212) {
+				ATH5K_DBG(sc, ATH5K_DEBUG_RESET,
+					  "rx overrun, resetting\n");
 				tasklet_schedule(&sc->restq);
+			}
 			else
 				tasklet_schedule(&sc->rxtq);
 		} else {
diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index 0f2e37d..5984edc 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -278,6 +278,7 @@ static ssize_t write_file_reset(struct file *file,
 				 size_t count, loff_t *ppos)
 {
 	struct ath5k_softc *sc = file->private_data;
+	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "debug file triggered reset\n");
 	tasklet_schedule(&sc->restq);
 	return count;
 }

