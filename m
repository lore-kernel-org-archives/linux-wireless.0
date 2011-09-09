Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18002 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab1IIFQq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Sep 2011 01:16:46 -0400
Cc: <linville@tuxdriver.com>, <rodrigue@qca.qualcomm.com>,
	<senthilb@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>, <rmanohar@qca.qualcomm.com>
Subject: [RFC] ath9k: Fix PS wrappers and enabling LED
Date: Fri, 9 Sep 2011 10:46:37 +0530
Message-ID: <1315545397-6107-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20110909_071650_067339_E66172CF)
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
index 891661a..5733faf 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -332,16 +332,16 @@ static int ath_pci_resume(struct device *device)
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

