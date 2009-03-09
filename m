Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:63655 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbZCIEGA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 00:06:00 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 08 Mar 2009 21:05:59 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18868.38061.239758.963002@gargle.gargle.HOWL> (sfid-20090309_050611_320124_924B24A2)
Date: Mon, 9 Mar 2009 09:31:49 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 1/3] ath9k: Initialize ANI properly
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ANI was not being initialized correctly for all HW variants.
This patch fixes it.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/hw.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index c10b33b..ea550cc 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -662,16 +662,9 @@ static struct ath_hw *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 		ah->supp_cals = ADC_GAIN_CAL | ADC_DC_CAL | IQ_MISMATCH_CAL;
 	}
 
-	if (AR_SREV_9160(ah)) {
-		ah->config.enable_ani = 1;
-		ah->ani_function = (ATH9K_ANI_SPUR_IMMUNITY_LEVEL |
-					ATH9K_ANI_FIRSTEP_LEVEL);
-	} else {
-		ah->ani_function = ATH9K_ANI_ALL;
-		if (AR_SREV_9280_10_OR_LATER(ah)) {
-			ah->ani_function &=	~ATH9K_ANI_NOISE_IMMUNITY_LEVEL;
-		}
-	}
+	ah->ani_function = ATH9K_ANI_ALL;
+	if (AR_SREV_9280_10_OR_LATER(ah))
+		ah->ani_function &= ~ATH9K_ANI_NOISE_IMMUNITY_LEVEL;
 
 	DPRINTF(sc, ATH_DBG_RESET,
 		"This Mac Chip Rev 0x%02x.%x is \n",
-- 
1.6.1

