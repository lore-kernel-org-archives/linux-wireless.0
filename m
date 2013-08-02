Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:59745 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757989Ab3HBH4H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Aug 2013 03:56:07 -0400
Subject: [PATCH] ath10k: remove un ar_pci->cacheline_sz field
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 02 Aug 2013 10:56:01 +0300
Message-ID: <20130802075601.11114.11607.stgit@localhost6.localdomain6> (sfid-20130802_095611_208303_3E0609F0)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cacheline_sz is not used anywhere and can be removed.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c |    2 --
 drivers/net/wireless/ath/ath10k/pci.h |    1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index d95439b..6f44d3a 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2361,8 +2361,6 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 
 	spin_lock_init(&ar_pci->ce_lock);
 
-	ar_pci->cacheline_sz = dma_get_cache_alignment();
-
 	ret = ath10k_pci_start_intr(ar);
 	if (ret) {
 		ath10k_err("could not start interrupt handling (%d)\n", ret);
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index d3a2e6c..bfd60a5 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -189,7 +189,6 @@ struct ath10k_pci {
 	struct device *dev;
 	struct ath10k *ar;
 	void __iomem *mem;
-	int cacheline_sz;
 
 	DECLARE_BITMAP(features, ATH10K_PCI_FEATURE_COUNT);
 

