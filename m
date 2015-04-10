Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:35306 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820AbbDJNER (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2015 09:04:17 -0400
Received: by lbbuc2 with SMTP id uc2so13120938lbb.2
        for <linux-wireless@vger.kernel.org>; Fri, 10 Apr 2015 06:04:16 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: fix error handling in pci_probe
Date: Fri, 10 Apr 2015 13:01:27 +0000
Message-Id: <1428670887-7533-1-git-send-email-michal.kazior@tieto.com> (sfid-20150410_150425_818875_111A1AB9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If chip_id wasn't recognized clean up code wasn't
executed properly. It would skip freeing memory
causing a leak and irqs causing possibly MSI
warning splats later or even kernel crashes.

Fixes: 1a7fecb766c8 ("ath10k: reset chip before reading chip_id in probe")
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 262a84f67f62..1f770ac28df4 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2684,7 +2684,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	if (!ath10k_pci_chip_is_supported(pdev->device, chip_id)) {
 		ath10k_err(ar, "device %04x with chip_id %08x isn't supported\n",
 			   pdev->device, chip_id);
-		goto err_sleep;
+		goto err_free_irq;
 	}
 
 	ret = ath10k_core_register(ar, chip_id);
-- 
2.1.4

