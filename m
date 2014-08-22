Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:48927 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756069AbaHVMd2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 08:33:28 -0400
Received: by mail-la0-f45.google.com with SMTP id ty20so9955760lab.4
        for <linux-wireless@vger.kernel.org>; Fri, 22 Aug 2014 05:33:26 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 2/6] ath10k: fix legacy irq workaround
Date: Fri, 22 Aug 2014 14:23:30 +0200
Message-Id: <1408710214-24894-3-git-send-email-michal.kazior@tieto.com> (sfid-20140822_143332_454098_496620F8)
In-Reply-To: <1408710214-24894-1-git-send-email-michal.kazior@tieto.com>
References: <1408710214-24894-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wrong register was being set up. This could
prevent firmware from booting in some rare cases
when using legacy interrupts.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index bb1e473..4a7a5fe 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2465,9 +2465,10 @@ static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
 
 		if (ar_pci->num_msi_intrs == 0)
 			/* Fix potential race by repeating CORE_BASE writes */
-			ath10k_pci_soc_write32(ar, PCIE_INTR_ENABLE_ADDRESS,
-					       PCIE_INTR_FIRMWARE_MASK |
-					       PCIE_INTR_CE_MASK_ALL);
+			ath10k_pci_write32(ar, SOC_CORE_BASE_ADDRESS +
+					   PCIE_INTR_ENABLE_ADDRESS,
+					   PCIE_INTR_FIRMWARE_MASK |
+					   PCIE_INTR_CE_MASK_ALL);
 
 		mdelay(10);
 	} while (time_before(jiffies, timeout));
-- 
1.8.5.3

