Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42346 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747Ab1INJjs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 05:39:48 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <rodrigue@qca.qualcomm.com>,
	<senthilb@qca.qualcomm.com>, <rmanohar@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH 2/2] ath9k: Fix PS wrappers and enabling LED
Date: Wed, 14 Sep 2011 15:09:40 +0530
Message-ID: <1315993180-14343-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20110914_113951_723318_42AB4F84)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

in ath_pci_resume it seems we are not enabling LED properly, in addition
we have a PS wrapper fix for this

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/pci.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index bda2233..d67d6ee 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -333,16 +333,16 @@ static int ath_pci_resume(struct device *device)
 	if ((val & 0x0000ff00) != 0)
 		pci_write_config_dword(pdev, 0x40, val & 0xffff00ff);
 
+	ath9k_ps_wakeup(sc);
 	/* Enable LED */
 	ath9k_hw_cfg_output(sc->sc_ah, sc->sc_ah->led_pin,
 			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
-	ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 1);
+	ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 0);
 
 	  /*
 	   * Reset key cache to sane defaults (all entries cleared) instead of
 	   * semi-random values after suspend/resume.
 	   */
-	ath9k_ps_wakeup(sc);
 	ath9k_cmn_init_crypto(sc->sc_ah);
 	ath9k_ps_restore(sc);
 
-- 
1.7.0.4

