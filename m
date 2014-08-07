Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51459 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157AbaHGJNu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2014 05:13:50 -0400
Received: by mail-wi0-f172.google.com with SMTP id n3so10348032wiv.5
        for <linux-wireless@vger.kernel.org>; Thu, 07 Aug 2014 02:13:49 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/5] ath10k: fix legacy irq workaround
Date: Thu,  7 Aug 2014 11:04:16 +0200
Message-Id: <1407402260-29854-2-git-send-email-michal.kazior@tieto.com> (sfid-20140807_111354_052809_C85A4D77)
In-Reply-To: <1407402260-29854-1-git-send-email-michal.kazior@tieto.com>
References: <1407402260-29854-1-git-send-email-michal.kazior@tieto.com>
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
index cfc1da2..54deea3 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2418,9 +2418,10 @@ static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
 
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

