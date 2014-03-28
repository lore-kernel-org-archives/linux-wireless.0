Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:59670 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaC1HkZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 03:40:25 -0400
Received: by mail-ee0-f42.google.com with SMTP id d17so3703758eek.15
        for <linux-wireless@vger.kernel.org>; Fri, 28 Mar 2014 00:40:24 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 3/3] ath10k: deinit copy engine before resetting
Date: Fri, 28 Mar 2014 08:34:25 +0100
Message-Id: <1395992065-10086-4-git-send-email-michal.kazior@tieto.com> (sfid-20140328_084032_070667_29D3ACEF)
In-Reply-To: <1395992065-10086-1-git-send-email-michal.kazior@tieto.com>
References: <1395745943-29492-1-git-send-email-michal.kazior@tieto.com>
 <1395992065-10086-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since copy engine allocation has been revised the
ath10k_pci_ce_deinit() now simply zeroes copy
engine registers. It's probably a good idea to do
that before reseting for a more graceful device
reset.

Before ath10k_pci_ce_deinit() freed copy engine
ringbuffer memory so it was required to call it
after resetting. Otherwise it was possible for
device to access unmapped/freed copy engine
ringbuffer memory.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
v2:
 * added as a result of splitting another patch

 drivers/net/wireless/ath/ath10k/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 10bf612..52c8c0d 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2000,9 +2000,9 @@ static void ath10k_pci_hif_power_down(struct ath10k *ar)
 	ath10k_pci_free_early_irq(ar);
 	ath10k_pci_kill_tasklet(ar);
 	ath10k_pci_deinit_irq(ar);
+	ath10k_pci_ce_deinit(ar);
 	ath10k_pci_warm_reset(ar);
 
-	ath10k_pci_ce_deinit(ar);
 	if (!test_bit(ATH10K_PCI_FEATURE_SOC_POWER_SAVE, ar_pci->features))
 		ath10k_do_pci_sleep(ar);
 }
-- 
1.8.5.3

