Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:61924 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755980Ab0CJJgT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 04:36:19 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Mar 2010 01:36:19 -0800
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Sujith <Sujith.Manoharan@atheros.com>
Subject: [PATCH 3/3] ath9k: Fix HW deinit
Date: Wed, 10 Mar 2010 15:04:51 +0530
Message-ID: <1268213691-2497-3-git-send-email-senthilkumar@atheros.com>
In-Reply-To: <1268213691-2497-2-git-send-email-senthilkumar@atheros.com>
References: <1268213691-2497-1-git-send-email-senthilkumar@atheros.com>
 <1268213691-2497-2-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith <Sujith.Manoharan@atheros.com>

Also, free ath_hw instance properly.
ath9k_hw_deinit() shouldn't do it.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c   |    4 +---
 drivers/net/wireless/ath/ath9k/init.c |    3 +++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index ecd70fb..9699007 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1229,7 +1229,7 @@ void ath9k_hw_deinit(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 
-	if (common->state <= ATH_HW_INITIALIZED)
+	if (common->state < ATH_HW_INITIALIZED)
 		goto free_hw;
 
 	if (!AR_SREV_9100(ah))
@@ -1240,8 +1240,6 @@ void ath9k_hw_deinit(struct ath_hw *ah)
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
1.6.3.3

