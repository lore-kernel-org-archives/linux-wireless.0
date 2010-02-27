Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:31405 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691Ab0B0FsB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 00:48:01 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 26 Feb 2010 21:48:01 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19336.46721.589379.479488@gargle.gargle.HOWL>
Date: Sat, 27 Feb 2010 11:36:57 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] ath9k: Fix HW deinit
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also, free ath_hw instance properly.
ath9k_hw_deinit() shouldn't do it.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    1 -
 drivers/net/wireless/ath/ath9k/hw.c           |    4 +---
 drivers/net/wireless/ath/ath9k/init.c         |    3 +++
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 5378c6e..67a9dd2 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -491,7 +491,6 @@ err_queues:
 err_debug:
 	ath9k_hw_deinit(ah);
 err_hw:
-
 	kfree(ah);
 	priv->ah = NULL;
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index cc4242f..259d951 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1228,7 +1228,7 @@ void ath9k_hw_deinit(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 
-	if (common->state <= ATH_HW_INITIALIZED)
+	if (common->state < ATH_HW_INITIALIZED)
 		goto free_hw;
 
 	if (!AR_SREV_9100(ah))
@@ -1239,8 +1239,6 @@ void ath9k_hw_deinit(struct ath_hw *ah)
 free_hw:
 	if (!AR_SREV_9280_10_OR_LATER(ah) && !AR_SREV_9271(ah))
 		ath9k_hw_rf_free_ext_banks(ah);
-	kfree(ah);
-	ah = NULL;
 }
 EXPORT_SYMBOL(ath9k_hw_deinit);
 
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 623c2f8..6063f54 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -758,6 +758,9 @@ static void ath9k_deinit_softc(struct ath_softc *sc)
 
 	tasklet_kill(&sc->intr_tq);
 	tasklet_kill(&sc->bcon_tasklet);
+
+	kfree(sc->sc_ah);
+	sc->sc_ah = NULL;
 }
 
 void ath9k_deinit_device(struct ath_softc *sc)
-- 
1.7.0

