Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:12298 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbcA0J7F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 04:59:05 -0500
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH 11/12] ath10k: add resource init and deinit in ahb
Date: Wed, 27 Jan 2016 15:24:32 +0530
Message-ID: <1453888473-2879-12-git-send-email-rmani@qti.qualcomm.com> (sfid-20160127_105910_025915_2864637A)
In-Reply-To: <1453888473-2879-1-git-send-email-rmani@qti.qualcomm.com>
References: <1453888473-2879-1-git-send-email-rmani@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add function to gather resources required for qca4019 to operate
(memory, irq, dma setting, clock init , rest control init) and
function release those resources when it's not needed.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/ahb.c | 122 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/ahb.h |   7 ++
 2 files changed, 129 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/ahb.c b/drivers/net/wireless/ath/ath10k/ahb.c
index 29d0b6c..d83a864 100644
--- a/drivers/net/wireless/ath/ath10k/ahb.c
+++ b/drivers/net/wireless/ath/ath10k/ahb.c
@@ -15,6 +15,8 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 #include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/clk.h>
 #include <linux/reset.h>
 #include "core.h"
@@ -502,6 +504,126 @@ static void ath10k_ahb_irq_disable(struct ath10k *ar)
 	ath10k_pci_disable_and_clear_legacy_irq(ar);
 }
 
+static int ath10k_ahb_resource_init(struct ath10k *ar)
+{
+	struct ath10k_ahb *ar_ahb = ath10k_ahb_priv(ar);
+	struct platform_device *pdev;
+	struct device *dev;
+	struct resource *res;
+	int ret;
+
+	pdev = ar_ahb->pdev;
+	dev = &pdev->dev;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		ath10k_err(ar, "failed to get memory resource\n");
+		ret = -ENXIO;
+		goto out;
+	}
+
+	ar_ahb->mem = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(ar_ahb->mem)) {
+		ath10k_err(ar, "mem ioremap error\n");
+		ret = PTR_ERR(ar_ahb->mem);
+		goto out;
+	}
+
+	ar_ahb->mem_len = resource_size(res);
+
+	ar_ahb->gcc_mem = ioremap_nocache(ATH10K_GCC_REG_BASE,
+					  ATH10K_GCC_REG_SIZE);
+	if (!ar_ahb->gcc_mem) {
+		ath10k_err(ar, "gcc mem ioremap error\n");
+		ret = -ENOMEM;
+		goto err_mem_unmap;
+	}
+
+	ar_ahb->tcsr_mem = ioremap_nocache(ATH10K_TCSR_REG_BASE,
+					   ATH10K_TCSR_REG_SIZE);
+	if (!ar_ahb->tcsr_mem) {
+		ath10k_err(ar, "tcsr mem ioremap error\n");
+		ret = -ENOMEM;
+		goto err_gcc_mem_unmap;
+	}
+
+	ret = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
+	if (ret) {
+		ath10k_err(ar, "failed to set 32-bit dma mask: %d\n", ret);
+		goto err_tcsr_mem_unmap;
+	}
+
+	ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	if (ret) {
+		ath10k_err(ar, "failed to set 32-bit consistent dma: %d\n",
+			   ret);
+		goto err_tcsr_mem_unmap;
+	}
+
+	ret = ath10k_ahb_clock_init(ar);
+	if (ret)
+		goto err_tcsr_mem_unmap;
+
+	ret = ath10k_ahb_rst_ctrl_init(ar);
+	if (ret)
+		goto err_clock_deinit;
+
+	ar_ahb->irq = platform_get_irq_byname(pdev, "legacy");
+	if (ar_ahb->irq < 0) {
+		ath10k_err(ar, "failed to get irq number: %d\n", ar_ahb->irq);
+		goto err_clock_deinit;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "irq: %d\n", ar_ahb->irq);
+
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "mem: 0x%p mem_len: %lu gcc mem: 0x%p tcsr_mem: 0x%p\n",
+		   ar_ahb->mem, ar_ahb->mem_len,
+		   ar_ahb->gcc_mem, ar_ahb->tcsr_mem);
+	return 0;
+
+err_clock_deinit:
+	ath10k_ahb_clock_deinit(ar);
+
+err_tcsr_mem_unmap:
+	iounmap(ar_ahb->tcsr_mem);
+
+err_gcc_mem_unmap:
+	ar_ahb->tcsr_mem = NULL;
+	iounmap(ar_ahb->gcc_mem);
+
+err_mem_unmap:
+	ar_ahb->gcc_mem = NULL;
+	devm_iounmap(&pdev->dev, ar_ahb->mem);
+
+out:
+	ar_ahb->mem = NULL;
+	return ret;
+}
+
+static void ath10k_ahb_resource_deinit(struct ath10k *ar)
+{
+	struct ath10k_ahb *ar_ahb = ath10k_ahb_priv(ar);
+	struct device *dev;
+
+	dev = &ar_ahb->pdev->dev;
+
+	if (ar_ahb->mem)
+		devm_iounmap(dev, ar_ahb->mem);
+
+	if (ar_ahb->gcc_mem)
+		iounmap(ar_ahb->gcc_mem);
+
+	if (ar_ahb->tcsr_mem)
+		iounmap(ar_ahb->tcsr_mem);
+
+	ar_ahb->mem = NULL;
+	ar_ahb->gcc_mem = NULL;
+	ar_ahb->tcsr_mem = NULL;
+
+	ath10k_ahb_clock_deinit(ar);
+	ath10k_ahb_rst_ctrl_deinit(ar);
+}
+
 static int ath10k_ahb_probe(struct platform_device *pdev)
 {
 	return 0;
diff --git a/drivers/net/wireless/ath/ath10k/ahb.h b/drivers/net/wireless/ath/ath10k/ahb.h
index 97c40e4..5bd01b4 100644
--- a/drivers/net/wireless/ath/ath10k/ahb.h
+++ b/drivers/net/wireless/ath/ath10k/ahb.h
@@ -23,6 +23,7 @@
 struct ath10k_ahb {
 	struct platform_device *pdev;
 	void __iomem *mem;
+	unsigned long mem_len;
 	void __iomem *gcc_mem;
 	void __iomem *tcsr_mem;
 
@@ -41,6 +42,12 @@ struct ath10k_ahb {
 
 #ifdef CONFIG_ATH10K_AHB
 
+#define ATH10K_GCC_REG_BASE                  0x1800000
+#define ATH10K_GCC_REG_SIZE                  0x60000
+
+#define ATH10K_TCSR_REG_BASE                 0x1900000
+#define ATH10K_TCSR_REG_SIZE                 0x80000
+
 #define ATH10K_AHB_WLAN_CORE_ID_REG          0x82030
 
 #define ATH10K_AHB_TCSR_WIFI0_GLB_CFG        0x49000
-- 
1.8.1.2

