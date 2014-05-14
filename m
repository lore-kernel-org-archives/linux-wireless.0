Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:46185 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbaENHJx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2014 03:09:53 -0400
Received: by mail-ee0-f47.google.com with SMTP id c13so998085eek.6
        for <linux-wireless@vger.kernel.org>; Wed, 14 May 2014 00:09:52 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: enable early device dumps
Date: Wed, 14 May 2014 09:02:48 +0200
Message-Id: <1400050968-4120-1-git-send-email-michal.kazior@tieto.com> (sfid-20140514_090957_322986_F120AE59)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This can be useful for early initialization
debugging, i.e. ROM crashes.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 66b1f30..fdd1378 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2196,10 +2196,7 @@ static void ath10k_pci_early_irq_tasklet(unsigned long data)
 	if (fw_ind & FW_IND_EVENT_PENDING) {
 		ath10k_pci_write32(ar, FW_INDICATOR_ADDRESS,
 				   fw_ind & ~FW_IND_EVENT_PENDING);
-
-		/* Some structures are unavailable during early boot or at
-		 * driver teardown so just print that the device has crashed. */
-		ath10k_warn("device crashed - no diagnostics available\n");
+		ath10k_pci_hif_dump_area(ar);
 	}
 
 	ath10k_pci_sleep(ar);
@@ -2476,6 +2473,9 @@ static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
 
 	if (val & FW_IND_EVENT_PENDING) {
 		ath10k_warn("device has crashed during init\n");
+		ath10k_pci_write32(ar, FW_INDICATOR_ADDRESS,
+				   val & ~FW_IND_EVENT_PENDING);
+		ath10k_pci_hif_dump_area(ar);
 		ret = -ECOMM;
 		goto out;
 	}
-- 
1.8.5.3

