Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3103 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbZGDRA7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jul 2009 13:00:59 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH 4/5] ath5k: do not release irq across suspend/resume
Date: Sat,  4 Jul 2009 12:59:54 -0400
Message-Id: <1246726795-3934-5-git-send-email-me@bobcopeland.com>
In-Reply-To: <1246726795-3934-1-git-send-email-me@bobcopeland.com>
References: <1246726795-3934-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Paraphrasing Rafael J. Wysocki: "drivers should not release PCI IRQs
in suspend."  Doing so causes a warning during suspend/resume on some
platforms.

Cc: Rafael J. Wysocki <rjw@sisk.pl>
Reported-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/base.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 4829329..3f55e90 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -674,7 +674,6 @@ ath5k_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 
 	ath5k_led_off(sc);
 
-	free_irq(pdev->irq, sc);
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
 	pci_set_power_state(pdev, PCI_D3hot);
@@ -702,18 +701,8 @@ ath5k_pci_resume(struct pci_dev *pdev)
 	 */
 	pci_write_config_byte(pdev, 0x41, 0);
 
-	err = request_irq(pdev->irq, ath5k_intr, IRQF_SHARED, "ath", sc);
-	if (err) {
-		ATH5K_ERR(sc, "request_irq failed\n");
-		goto err_no_irq;
-	}
-
 	ath5k_led_enable(sc);
 	return 0;
-
-err_no_irq:
-	pci_disable_device(pdev);
-	return err;
 }
 #endif /* CONFIG_PM */
 
-- 
1.6.2.5


