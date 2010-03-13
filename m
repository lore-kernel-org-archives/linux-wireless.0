Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40668 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab0CMFrD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Mar 2010 00:47:03 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Sujith <Sujith.Manoharan@atheros.com>, stable@kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v3 12/12] ath9k_hw: fix hardware deinit
Date: Sat, 13 Mar 2010 00:46:56 -0500
Message-Id: <1268459216-22372-13-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1268459216-22372-1-git-send-email-lrodriguez@atheros.com>
References: <1268459216-22372-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith <Sujith.Manoharan@atheros.com>

Without this you will get a panic if the device initialization
fails. Also, free ath_hw instance properly. ath9k_hw_deinit()
shouldn't do it.

Cc: stable@kernel.org
Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c   |    4 +---
 drivers/net/wireless/ath/ath9k/init.c |    3 +++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 0670d98..5f586df 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1227,7 +1227,7 @@ void ath9k_hw_deinit(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 
-	if (common->state <= ATH_HW_INITIALIZED)
+	if (common->state < ATH_HW_INITIALIZED)
 		goto free_hw;
 
 	if (!AR_SREV_9100(ah))
@@ -1238,8 +1238,6 @@ void ath9k_hw_deinit(struct ath_hw *ah)
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

