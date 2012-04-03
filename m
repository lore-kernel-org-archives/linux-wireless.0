Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:37774 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210Ab2DCPQE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2012 11:16:04 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linville@tuxdriver.com
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	rodrigue@qca.qualcomm.com, achadd@qca.qualcomm.com,
	nbd@openwrt.org, Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH 2/3] ath9k: add DFS pattern detector instance to ath_softc
Date: Tue,  3 Apr 2012 17:15:50 +0200
Message-Id: <1333466151-6570-3-git-send-email-zefir.kurtisi@neratec.com> (sfid-20120403_171616_257826_BE94D22B)
In-Reply-To: <1333466151-6570-1-git-send-email-zefir.kurtisi@neratec.com>
References: <1333466151-6570-1-git-send-email-zefir.kurtisi@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 ++
 drivers/net/wireless/ath/ath9k/init.c  |    4 ++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 8c84049..f2ade45 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -26,6 +26,7 @@
 #include "debug.h"
 #include "common.h"
 #include "mci.h"
+#include "dfs.h"
 
 /*
  * Header for the ath9k.ko driver core *only* -- hw code nor any other driver
@@ -680,6 +681,7 @@ struct ath_softc {
 
 	struct ath_ant_comb ant_comb;
 	u8 ant_tx, ant_rx;
+	struct dfs_pattern_detector *dfs_detector;
 };
 
 void ath9k_tasklet(unsigned long data);
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index ad1be7d..f9130f7 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -519,6 +519,8 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	atomic_set(&ah->intr_ref_cnt, -1);
 	sc->sc_ah = ah;
 
+	sc->dfs_detector = dfs_pattern_detector_init(NL80211_DFS_UNSET);
+
 	if (!pdata) {
 		ah->ah_flags |= AH_USE_EEPROM;
 		sc->sc_ah->led_pin = -1;
@@ -821,6 +823,8 @@ static void ath9k_deinit_softc(struct ath_softc *sc)
 			ath_tx_cleanupq(sc, &sc->tx.txq[i]);
 
 	ath9k_hw_deinit(sc->sc_ah);
+	if (sc->dfs_detector != NULL)
+		sc->dfs_detector->exit(sc->dfs_detector);
 
 	kfree(sc->sc_ah);
 	sc->sc_ah = NULL;
-- 
1.7.4.1

