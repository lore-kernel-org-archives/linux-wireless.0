Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3700 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756838Ab0GMPdm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jul 2010 11:33:42 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, br1@einfach.org
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	jirislaby@gmail.com, mickflemm@gmail.com, lrodriguez@atheros.com,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 2/2] ath5k: disable tasklets during reset
Date: Tue, 13 Jul 2010 11:32:41 -0400
Message-Id: <1279035161-10802-2-git-send-email-me@bobcopeland.com>
In-Reply-To: <1279035161-10802-1-git-send-email-me@bobcopeland.com>
References: <1279035161-10802-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Based on a patch from Bruno Randolf, attempting useful
work while we are resetting the chip just leads to interface
lockups and bad descriptor data, and possibly DMAing to
freed buffers.  Let's suspend all tasklets while
reprogramming the registers in the card to avoid such
problems.

In the future we can convert the tasklets to threaded
interrupt handlers to simplify things.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/base.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index b290cc6..b0e1ca9 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2639,6 +2639,15 @@ ath5k_stop_locked(struct ath5k_softc *sc)
 	return 0;
 }
 
+static void stop_tasklets(struct ath5k_softc *sc)
+{
+	tasklet_kill(&sc->rxtq);
+	tasklet_kill(&sc->txtq);
+	tasklet_kill(&sc->calib);
+	tasklet_kill(&sc->beacontq);
+	tasklet_kill(&sc->ani_tasklet);
+}
+
 /*
  * Stop the device, grabbing the top-level lock to protect
  * against concurrent entry through ath5k_init (which can happen
@@ -2683,11 +2692,7 @@ ath5k_stop_hw(struct ath5k_softc *sc)
 	mmiowb();
 	mutex_unlock(&sc->lock);
 
-	tasklet_kill(&sc->rxtq);
-	tasklet_kill(&sc->txtq);
-	tasklet_kill(&sc->calib);
-	tasklet_kill(&sc->beacontq);
-	tasklet_kill(&sc->ani_tasklet);
+	stop_tasklets(sc);
 
 	ath5k_rfkill_hw_stop(sc->ah);
 
@@ -2937,8 +2942,11 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 
 	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "resetting\n");
 
+	ath5k_hw_set_imr(ah, 0);
+	synchronize_irq(sc->pdev->irq);
+	stop_tasklets(sc);
+
 	if (chan) {
-		ath5k_hw_set_imr(ah, 0);
 		ath5k_txq_cleanup(sc);
 		ath5k_rx_stop(sc);
 
-- 
1.6.3.3


