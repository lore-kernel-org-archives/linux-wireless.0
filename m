Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45648 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbaJIIdk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 04:33:40 -0400
Received: by mail-wi0-f174.google.com with SMTP id cc10so12419301wib.13
        for <linux-wireless@vger.kernel.org>; Thu, 09 Oct 2014 01:33:38 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/5] ath10k: re-disable interrupts after target init
Date: Thu,  9 Oct 2014 10:22:26 +0200
Message-Id: <1412842950-14098-2-git-send-email-michal.kazior@tieto.com> (sfid-20141009_103354_661795_55C6374B)
In-Reply-To: <1412842950-14098-1-git-send-email-michal.kazior@tieto.com>
References: <1412842950-14098-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If MSI isn't configured device ROM program expects
legacy interrupts to be enabled before it can
fully boot. Don't forget to disable legacy
interrupts after that.

While at it re-use the legacy irq enabling helper
instead of calling ath10k_pci_write32().

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 730bb18..6077095 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2279,14 +2279,13 @@ static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
 
 		if (ar_pci->num_msi_intrs == 0)
 			/* Fix potential race by repeating CORE_BASE writes */
-			ath10k_pci_write32(ar, SOC_CORE_BASE_ADDRESS +
-					   PCIE_INTR_ENABLE_ADDRESS,
-					   PCIE_INTR_FIRMWARE_MASK |
-					   PCIE_INTR_CE_MASK_ALL);
+			ath10k_pci_enable_legacy_irq(ar);
 
 		mdelay(10);
 	} while (time_before(jiffies, timeout));
 
+	ath10k_pci_disable_and_clear_legacy_irq(ar);
+
 	if (val == 0xffffffff) {
 		ath10k_err(ar, "failed to read device register, device is gone\n");
 		return -EIO;
-- 
1.8.5.3

