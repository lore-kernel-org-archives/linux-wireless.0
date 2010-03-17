Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:26855 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755901Ab0CQV1Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 17:27:25 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 17 Mar 2010 14:27:25 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Sujith <Sujith.Manoharan@atheros.com>, <stable@kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 11/12] ath9k_hw: fix hardware deinit
Date: Wed, 17 Mar 2010 14:25:24 +0530
Message-ID: <1268816125-16173-12-git-send-email-senthilkumar@atheros.com>
In-Reply-To: <1268816125-16173-11-git-send-email-senthilkumar@atheros.com>
References: <1268816125-16173-1-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-2-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-3-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-4-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-5-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-6-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-7-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-8-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-9-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-10-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-11-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
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
index 05aeb51..77db932 100644
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
 	if (!AR_SREV_9280_10_OR_LATER(ah))
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
1.6.4.2

