Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:40478 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbaENL5S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2014 07:57:18 -0400
Received: by mail-ee0-f48.google.com with SMTP id e49so1286349eek.21
        for <linux-wireless@vger.kernel.org>; Wed, 14 May 2014 04:57:17 -0700 (PDT)
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH] ath10k: get rid of pci_assign_resource() call from pci_probe
Date: Wed, 14 May 2014 13:57:07 +0200
Message-Id: <1400068627-4076-1-git-send-email-bartosz.markowski@tieto.com> (sfid-20140514_135721_922616_E3C299A1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On ARM-based (MSM mach), the pci_assign_resource() is passing
some invalid pointers and leading to L2 cache errors,
what prevents the PCI communication completly.

So far I have not found this funtion to be directly called by
any other wifi driver and did not found this assigning needed
on any other platform. So removing it completly.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 66b1f30..9a579cd 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2602,18 +2602,6 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 
 	pci_set_drvdata(pdev, ar);
 
-	/*
-	 * Without any knowledge of the Host, the Target may have been reset or
-	 * power cycled and its Config Space may no longer reflect the PCI
-	 * address space that was assigned earlier by the PCI infrastructure.
-	 * Refresh it now.
-	 */
-	ret = pci_assign_resource(pdev, BAR_NUM);
-	if (ret) {
-		ath10k_err("failed to assign PCI space: %d\n", ret);
-		goto err_ar;
-	}
-
 	ret = pci_enable_device(pdev);
 	if (ret) {
 		ath10k_err("failed to enable PCI device: %d\n", ret);
-- 
1.8.2

