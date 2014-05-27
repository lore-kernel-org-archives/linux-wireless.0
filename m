Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:27598 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbaE0Lqn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 07:46:43 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 6/7] wil6210: improve pointers printing
Date: Tue, 27 May 2014 14:45:49 +0300
Message-ID: <1401191150-29037-7-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140527_134648_384302_5E63F555)
In-Reply-To: <1401191150-29037-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1401191150-29037-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

use proper format %pad for the dma_addr_t arguments;
prefix %p with 0x, as %p don't print is by itself

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c  | 4 ++--
 drivers/net/wireless/ath/wil6210/pcie_bus.c | 2 +-
 drivers/net/wireless/ath/wil6210/txrx.c     | 8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index ecdabe4..8d4bc4b 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -35,7 +35,7 @@ static void wil_print_vring(struct seq_file *s, struct wil6210_priv *wil,
 	void __iomem *x = wmi_addr(wil, vring->hwtail);
 
 	seq_printf(s, "VRING %s = {\n", name);
-	seq_printf(s, "  pa     = 0x%016llx\n", (unsigned long long)vring->pa);
+	seq_printf(s, "  pa     = %pad\n", &vring->pa);
 	seq_printf(s, "  va     = 0x%p\n", vring->va);
 	seq_printf(s, "  size   = %d\n", vring->size);
 	seq_printf(s, "  swtail = %d\n", vring->swtail);
@@ -473,7 +473,7 @@ static int wil_txdesc_debugfs_show(struct seq_file *s, void *data)
 			   u[0], u[1], u[2], u[3]);
 		seq_printf(s, "  DMA = 0x%08x 0x%08x 0x%08x 0x%08x\n",
 			   u[4], u[5], u[6], u[7]);
-		seq_printf(s, "  SKB = %p\n", skb);
+		seq_printf(s, "  SKB = 0x%p\n", skb);
 
 		if (skb) {
 			skb_get(skb);
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index 0660884..1e2e07b 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -138,7 +138,7 @@ static int wil_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_release_reg;
 	}
 	/* rollback to err_iounmap */
-	dev_info(&pdev->dev, "CSR at %pR -> %p\n", &pdev->resource[0], csr);
+	dev_info(&pdev->dev, "CSR at %pR -> 0x%p\n", &pdev->resource[0], csr);
 
 	wil = wil_if_alloc(dev, csr);
 	if (IS_ERR(wil)) {
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 82140e0..0784ef3 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -114,8 +114,8 @@ static int wil_vring_alloc(struct wil6210_priv *wil, struct vring *vring)
 		_d->dma.status = TX_DMA_STATUS_DU;
 	}
 
-	wil_dbg_misc(wil, "vring[%d] 0x%p:0x%016llx 0x%p\n", vring->size,
-		     vring->va, (unsigned long long)vring->pa, vring->ctx);
+	wil_dbg_misc(wil, "vring[%d] 0x%p:%pad 0x%p\n", vring->size,
+		     vring->va, &vring->pa, vring->ctx);
 
 	return 0;
 }
@@ -896,8 +896,8 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	pa = dma_map_single(dev, skb->data,
 			skb_headlen(skb), DMA_TO_DEVICE);
 
-	wil_dbg_txrx(wil, "Tx skb %d bytes %p -> %#08llx\n", skb_headlen(skb),
-		     skb->data, (unsigned long long)pa);
+	wil_dbg_txrx(wil, "Tx skb %d bytes 0x%p -> %pad\n", skb_headlen(skb),
+		     skb->data, &pa);
 	wil_hex_dump_txrx("Tx ", DUMP_PREFIX_OFFSET, 16, 1,
 			  skb->data, skb_headlen(skb), false);
 
-- 
1.9.1

