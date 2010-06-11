Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:44881 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755942Ab0FKKMg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jun 2010 06:12:36 -0400
Received: from vs3015.wh2.ocn.ne.jp (125.206.180.247)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0995721152
	for <linux-wireless@vger.kernel.org>; Fri, 11 Jun 2010 19:12:32 +0900 (JST)
Subject: [PATCH] ath5k: disable all tasklets while resetting
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Fri, 11 Jun 2010 19:12:21 +0900
Message-ID: <20100611101221.26538.46913.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make sure no tasklets can run concurrently to a reset.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/base.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 9d37c1a..585c517 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2908,6 +2908,12 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 
 	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "resetting\n");
 
+	tasklet_disable(&sc->rxtq);		/* ath5k_tasklet_rx */
+	tasklet_disable(&sc->txtq);		/* ath5k_tasklet_tx */
+	tasklet_disable(&sc->calib);		/* ath5k_tasklet_calibrate */
+	tasklet_disable(&sc->beacontq);		/* ath5k_tasklet_beacon */
+	tasklet_disable(&sc->ani_tasklet);	/* ath5k_tasklet_ani */
+
 	if (chan) {
 		ath5k_hw_set_imr(ah, 0);
 		ath5k_txq_cleanup(sc);
@@ -2948,6 +2954,12 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 	ath5k_beacon_config(sc);
 	/* intrs are enabled by ath5k_beacon_config */
 
+	tasklet_enable(&sc->rxtq);		/* ath5k_tasklet_rx */
+	tasklet_enable(&sc->txtq);		/* ath5k_tasklet_tx */
+	tasklet_enable(&sc->calib);		/* ath5k_tasklet_calibrate */
+	tasklet_enable(&sc->beacontq);		/* ath5k_tasklet_beacon */
+	tasklet_enable(&sc->ani_tasklet);	/* ath5k_tasklet_ani */
+
 	ieee80211_wake_queues(sc->hw);
 
 	return 0;

