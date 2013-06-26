Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:50835 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886Ab3FZGvY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 02:51:24 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath9k-devel@lists.ath9k.org>, <linux-wireless@vger.kernel.org>
CC: Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2] ath10k: fix MSI-X setup failpath
Date: Wed, 26 Jun 2013 08:50:50 +0200
Message-ID: <1372229450-4575-1-git-send-email-michal.kazior@tieto.com> (sfid-20130626_085127_864833_DA5F435C)
In-Reply-To: <1372150661-6862-1-git-send-email-michal.kazior@tieto.com>
References: <1372150661-6862-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Irqs were not freed up correctly upon msi-x setup
failure.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 1a59638..63c58b5 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1882,9 +1882,10 @@ static int ath10k_pci_start_intr_msix(struct ath10k *ar, int num)
 			ath10k_warn("request_irq(%d) failed %d\n",
 				    ar_pci->pdev->irq + i, ret);
 
-			for (; i >= MSI_ASSIGN_CE_INITIAL; i--)
-				free_irq(ar_pci->pdev->irq, ar);
+			for (i--; i >= MSI_ASSIGN_CE_INITIAL; i--)
+				free_irq(ar_pci->pdev->irq + i, ar);
 
+			free_irq(ar_pci->pdev->irq + MSI_ASSIGN_FW, ar);
 			pci_disable_msi(ar_pci->pdev);
 			return ret;
 		}
-- 
1.7.9.5

