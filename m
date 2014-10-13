Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:40654 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaJMGku (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2014 02:40:50 -0400
Subject: [PATCH 1/3] ath10k: add back enum ath10k_bus
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 13 Oct 2014 09:40:47 +0300
Message-ID: <20141013064047.30315.55006.stgit@potku.adurom.net> (sfid-20141013_084058_826899_FFB9B921)
In-Reply-To: <20141013063929.30315.41969.stgit@potku.adurom.net>
References: <20141013063929.30315.41969.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 3a0861fffd223 ("ath10k: remove ath10k_bus") removed enum ath10k_bus
because it was not used for anything at the time. But now it's needed for for
retrieving the right calibration data file so add it back. Only new addition is
ath10k_bus_str().

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |    2 ++
 drivers/net/wireless/ath/ath10k/core.h |   16 ++++++++++++++++
 drivers/net/wireless/ath/ath10k/pci.c  |    1 +
 3 files changed, 19 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 37e31665628c..76f0db0654bb 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1084,6 +1084,7 @@ void ath10k_core_unregister(struct ath10k *ar)
 EXPORT_SYMBOL(ath10k_core_unregister);
 
 struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
+				  enum ath10k_bus bus,
 				  const struct ath10k_hif_ops *hif_ops)
 {
 	struct ath10k *ar;
@@ -1100,6 +1101,7 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 	ar->dev = dev;
 
 	ar->hif.ops = hif_ops;
+	ar->hif.bus = bus;
 
 	init_completion(&ar->scan.started);
 	init_completion(&ar->scan.completed);
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 1ac2f1466758..770b0bcc3e69 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -63,6 +63,20 @@
 
 struct ath10k;
 
+enum ath10k_bus {
+	ATH10K_BUS_PCI,
+};
+
+static inline const char *ath10k_bus_str(enum ath10k_bus bus)
+{
+	switch (bus) {
+	case ATH10K_BUS_PCI:
+		return "pci";
+	}
+
+	return "unknown";
+}
+
 struct ath10k_skb_cb {
 	dma_addr_t paddr;
 	u8 vdev_id;
@@ -423,6 +437,7 @@ struct ath10k {
 	bool p2p;
 
 	struct {
+		enum ath10k_bus bus;
 		const struct ath10k_hif_ops *ops;
 	} hif;
 
@@ -577,6 +592,7 @@ struct ath10k {
 };
 
 struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
+				  enum ath10k_bus bus,
 				  const struct ath10k_hif_ops *hif_ops);
 void ath10k_core_destroy(struct ath10k *ar);
 
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 730bb18c3f45..86f734e74103 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2435,6 +2435,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	u32 chip_id;
 
 	ar = ath10k_core_create(sizeof(*ar_pci), &pdev->dev,
+				ATH10K_BUS_PCI,
 				&ath10k_pci_hif_ops);
 	if (!ar) {
 		dev_err(&pdev->dev, "failed to allocate core\n");

