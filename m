Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19715 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179AbcE0OqS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2016 10:46:18 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
	"Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>
Subject: [PATCH 1/5] ath10k: fix operating irq mode for ahb device
Date: Fri, 27 May 2016 20:15:55 +0530
Message-ID: <20160527144559.4053-1-rmanohar@qti.qualcomm.com> (sfid-20160527_164636_948325_C3EB36AC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Earlier when operating irq mode is legacy, interrupts are disabled
and re-enabled based on num_msi_intrs. commit cfe9011a05a8 ("ath10k:
remove MSI range support") replaced num_msi_intrs by oper_irq_mode.
Since oper_irq_mode is not initialized for ahb devices (i.e qca4019),
device boot up is failed during probe.

Fixes: cfe9011a05a8 ("ath10k: remove MSI range support")
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/ahb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/ahb.c b/drivers/net/wireless/ath/ath10k/ahb.c
index bd62bc19e758..37ff36fca7bc 100644
--- a/drivers/net/wireless/ath/ath10k/ahb.c
+++ b/drivers/net/wireless/ath/ath10k/ahb.c
@@ -476,6 +476,7 @@ static irqreturn_t ath10k_ahb_interrupt_handler(int irq, void *arg)
 
 static int ath10k_ahb_request_irq_legacy(struct ath10k *ar)
 {
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	struct ath10k_ahb *ar_ahb = ath10k_ahb_priv(ar);
 	int ret;
 
@@ -487,6 +488,7 @@ static int ath10k_ahb_request_irq_legacy(struct ath10k *ar)
 			    ar_ahb->irq, ret);
 		return ret;
 	}
+	ar_pci->oper_irq_mode = ATH10K_PCI_IRQ_LEGACY;
 
 	return 0;
 }
-- 
2.8.3

