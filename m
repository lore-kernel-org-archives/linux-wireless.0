Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48117 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab3FRH3E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 03:29:04 -0400
Date: Tue, 18 Jun 2013 10:28:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] ath10k: off by one sanity check
Message-ID: <20130618072846.GC12329@elgon.mountain> (sfid-20130618_092921_179841_684C7112)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This should be >= ARRAY_SIZE() instead of > ARRAY_SIZE().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 8e4e832..c8e9056 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1772,7 +1772,7 @@ static irqreturn_t ath10k_pci_per_engine_handler(int irq, void *arg)
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	int ce_id = irq - ar_pci->pdev->irq - MSI_ASSIGN_CE_INITIAL;
 
-	if (ce_id < 0 || ce_id > ARRAY_SIZE(ar_pci->pipe_info)) {
+	if (ce_id < 0 || ce_id >= ARRAY_SIZE(ar_pci->pipe_info)) {
 		ath10k_warn("unexpected/invalid irq %d ce_id %d\n", irq, ce_id);
 		return IRQ_HANDLED;
 	}
