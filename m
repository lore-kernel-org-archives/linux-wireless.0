Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0075.outbound.protection.outlook.com ([104.47.41.75]:55935
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753323AbdH2MRK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Aug 2017 08:17:10 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 3/5] qtnfmac: modify qtnf_map_bar not to return NULL
Date: Tue, 29 Aug 2017 15:16:21 +0300
Message-Id: <20170829121623.24761-4-sergey.matyukevich.os@quantenna.com> (sfid-20170829_141715_520603_AE121B52)
In-Reply-To: <20170829121623.24761-1-sergey.matyukevich.os@quantenna.com>
References: <20170829121623.24761-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

NULL is not a special type of success here but a error pointer.
So it makes sense to check against NULL in qtnf_map_bar
and return error code.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
index fd552d64f943..bfbcd0bf75bf 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
@@ -184,8 +184,10 @@ static void __iomem *qtnf_map_bar(struct qtnf_pcie_bus_priv *priv, u8 index)
 		return IOMEM_ERR_PTR(ret);
 
 	busaddr = pci_resource_start(priv->pdev, index);
-	vaddr = pcim_iomap_table(priv->pdev)[index];
 	len = pci_resource_len(priv->pdev, index);
+	vaddr = pcim_iomap_table(priv->pdev)[index];
+	if (!vaddr)
+		return IOMEM_ERR_PTR(-ENOMEM);
 
 	pr_debug("BAR%u vaddr=0x%p busaddr=%pad len=%u\n",
 		 index, vaddr, &busaddr, (int)len);
@@ -248,19 +250,19 @@ static int qtnf_pcie_init_memory(struct qtnf_pcie_bus_priv *priv)
 	int ret = -ENOMEM;
 
 	priv->sysctl_bar = qtnf_map_bar(priv, QTN_SYSCTL_BAR);
-	if (IS_ERR_OR_NULL(priv->sysctl_bar)) {
+	if (IS_ERR(priv->sysctl_bar)) {
 		pr_err("failed to map BAR%u\n", QTN_SYSCTL_BAR);
 		return ret;
 	}
 
 	priv->dmareg_bar = qtnf_map_bar(priv, QTN_DMA_BAR);
-	if (IS_ERR_OR_NULL(priv->dmareg_bar)) {
+	if (IS_ERR(priv->dmareg_bar)) {
 		pr_err("failed to map BAR%u\n", QTN_DMA_BAR);
 		return ret;
 	}
 
 	priv->epmem_bar = qtnf_map_bar(priv, QTN_SHMEM_BAR);
-	if (IS_ERR_OR_NULL(priv->epmem_bar)) {
+	if (IS_ERR(priv->epmem_bar)) {
 		pr_err("failed to map BAR%u\n", QTN_SHMEM_BAR);
 		return ret;
 	}
-- 
2.11.0
