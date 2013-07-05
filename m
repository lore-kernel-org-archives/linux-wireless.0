Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:41604 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757360Ab3GENPV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 09:15:21 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 05/16] ath10k: remove ath10k_bus
Date: Fri,  5 Jul 2013 16:15:06 +0300
Message-Id: <1373030117-18077-6-git-send-email-kvalo@qca.qualcomm.com> (sfid-20130705_151528_882775_12933749)
In-Reply-To: <1373030117-18077-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1373030117-18077-1-git-send-email-kvalo@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

It serves no purpose.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |    2 --
 drivers/net/wireless/ath/ath10k/core.h |    6 ------
 drivers/net/wireless/ath/ath10k/pci.c  |    3 +--
 3 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 2b3426b..aabe166 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -441,7 +441,6 @@ static int ath10k_init_hw_params(struct ath10k *ar)
 }
 
 struct ath10k *ath10k_core_create(void *hif_priv, struct device *dev,
-				  enum ath10k_bus bus,
 				  const struct ath10k_hif_ops *hif_ops)
 {
 	struct ath10k *ar;
@@ -458,7 +457,6 @@ struct ath10k *ath10k_core_create(void *hif_priv, struct device *dev,
 
 	ar->hif.priv = hif_priv;
 	ar->hif.ops = hif_ops;
-	ar->hif.bus = bus;
 
 	ar->free_vdev_map = 0xFF; /* 8 vdevs */
 
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 539336d..7489770 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -43,10 +43,6 @@
 
 struct ath10k;
 
-enum ath10k_bus {
-	ATH10K_BUS_PCI,
-};
-
 struct ath10k_skb_cb {
 	dma_addr_t paddr;
 	bool is_mapped;
@@ -274,7 +270,6 @@ struct ath10k {
 
 	struct {
 		void *priv;
-		enum ath10k_bus bus;
 		const struct ath10k_hif_ops *ops;
 	} hif;
 
@@ -356,7 +351,6 @@ struct ath10k {
 };
 
 struct ath10k *ath10k_core_create(void *hif_priv, struct device *dev,
-				  enum ath10k_bus bus,
 				  const struct ath10k_hif_ops *hif_ops);
 void ath10k_core_destroy(struct ath10k *ar);
 
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 1bd381f..ab7e4a2 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2156,8 +2156,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 
 	ath10k_pci_dump_features(ar_pci);
 
-	ar = ath10k_core_create(ar_pci, ar_pci->dev, ATH10K_BUS_PCI,
-				&ath10k_pci_hif_ops);
+	ar = ath10k_core_create(ar_pci, ar_pci->dev, &ath10k_pci_hif_ops);
 	if (!ar) {
 		ath10k_err("ath10k_core_create failed!\n");
 		ret = -EINVAL;
-- 
1.7.9.5

