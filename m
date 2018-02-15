Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37374 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755101AbeBOJEO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Feb 2018 04:04:14 -0500
From: Govind Singh <govinds@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH] ath10k: Enable IOMMU support for WCN3990 target
Date: Thu, 15 Feb 2018 14:34:08 +0530
Message-Id: <1518685448-15317-1-git-send-email-govinds@codeaurora.org> (sfid-20180215_100424_214589_D6D60522)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When an IOMMU device is available on the platform bus, allocate
an IOMMU domain and attach the wlan target to it.
WCN3990 target can then attach an DMA I/O virtual address
space to scan out of bound transactions.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 100 ++++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/snoc.h |   3 +
 2 files changed, 101 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index cd21b25..502263d 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -26,6 +26,10 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
 #include <linux/clk.h>
+#include <asm/dma-iommu.h>
+#include <linux/iommu.h>
+#include <linux/dma-mapping.h>
+
 #define  WCN3990_CE_ATTR_FLAGS 0
 #define ATH10K_SNOC_RX_POST_RETRY_MS 50
 #define CE_POLL_PIPE 4
@@ -1292,6 +1296,88 @@ static int ath10k_hw_power_off(struct ath10k *ar)
 	return ret;
 }
 
+static int ath10k_smmu_attach(struct ath10k *ar)
+{
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
+	struct dma_iommu_mapping *mapping;
+	struct platform_device *pdev;
+	int ret = 0;
+
+	ath10k_dbg(ar, ATH10K_DBG_SNOC, "Initializing SMMU\n");
+
+	pdev = ar_snoc->dev;
+	mapping = arm_iommu_create_mapping(&platform_bus_type,
+					   ar_snoc->smmu_iova_start,
+					   ar_snoc->smmu_iova_len);
+	if (IS_ERR(mapping)) {
+		ath10k_err(ar, "create mapping failed, err = %d\n", ret);
+		ret = PTR_ERR(mapping);
+		goto map_fail;
+	}
+
+	ret = arm_iommu_attach_device(&pdev->dev, mapping);
+	if (ret < 0 && ret != -EEXIST) {
+		ath10k_err(ar, "iommu attach device failed, err = %d\n", ret);
+		goto attach_fail;
+	} else if (ret == -EEXIST) {
+		ret = 0;
+	}
+
+	ar_snoc->smmu_mapping = mapping;
+
+	return ret;
+
+attach_fail:
+	arm_iommu_release_mapping(mapping);
+map_fail:
+	return ret;
+}
+
+static void ath10k_smmu_deinit(struct ath10k *ar)
+{
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
+	struct platform_device *pdev;
+
+	pdev = ar_snoc->dev;
+
+	if (!ar_snoc->smmu_mapping)
+		return;
+
+	arm_iommu_detach_device(&pdev->dev);
+	arm_iommu_release_mapping(ar_snoc->smmu_mapping);
+
+	ar_snoc->smmu_mapping = NULL;
+}
+
+static int ath10k_smmu_init(struct ath10k *ar)
+{
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
+	struct platform_device *pdev;
+	struct resource *res;
+	int ret = 0;
+
+	pdev = ar_snoc->dev;
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+					   "smmu_iova_base");
+	if (!res) {
+		ath10k_err(ar, "SMMU iova base not found\n");
+	} else {
+		ar_snoc->smmu_iova_start = res->start;
+		ar_snoc->smmu_iova_len = resource_size(res);
+		ath10k_dbg(ar, ATH10K_DBG_SNOC, "SMMU iova start: %pa, len: %zu\n",
+			   &ar_snoc->smmu_iova_start, ar_snoc->smmu_iova_len);
+
+		ret = ath10k_smmu_attach(ar);
+		if (ret < 0) {
+			ath10k_err(ar, "SMMU init failed, err = %d, start: %pad, len: %zx\n",
+				   ret, &ar_snoc->smmu_iova_start,
+				   ar_snoc->smmu_iova_len);
+		}
+	}
+
+	return ret;
+}
+
 static const struct of_device_id ath10k_snoc_dt_match[] = {
 	{ .compatible = "qcom,wcn3990-wifi",
 	 .data = &drv_priv,
@@ -1339,16 +1425,22 @@ static int ath10k_snoc_probe(struct platform_device *pdev)
 	ar_snoc->ce.bus_ops = &ath10k_snoc_bus_ops;
 	ar->ce_priv = &ar_snoc->ce;
 
+	ret = ath10k_smmu_init(ar);
+	if (ret) {
+		ath10k_warn(ar, "failed to int SMMU: %d\n", ret);
+		goto err_core_destroy;
+	}
+
 	ath10k_snoc_resource_init(ar);
 	if (ret) {
 		ath10k_warn(ar, "failed to initialize resource: %d\n", ret);
-		goto err_core_destroy;
+		goto err_smmu_deinit;
 	}
 
 	ath10k_snoc_setup_resource(ar);
 	if (ret) {
 		ath10k_warn(ar, "failed to setup resource: %d\n", ret);
-		goto err_core_destroy;
+		goto err_smmu_deinit;
 	}
 	ret = ath10k_snoc_request_irq(ar);
 	if (ret) {
@@ -1396,6 +1488,9 @@ static int ath10k_snoc_probe(struct platform_device *pdev)
 err_release_resource:
 	ath10k_snoc_release_resource(ar);
 
+err_smmu_deinit:
+	ath10k_smmu_deinit(ar);
+
 err_core_destroy:
 	ath10k_core_destroy(ar);
 
@@ -1409,6 +1504,7 @@ static int ath10k_snoc_remove(struct platform_device *pdev)
 	ath10k_dbg(ar, ATH10K_DBG_SNOC, "snoc remove\n");
 	ath10k_core_unregister(ar);
 	ath10k_hw_power_off(ar);
+	ath10k_smmu_deinit(ar);
 	ath10k_snoc_free_irq(ar);
 	ath10k_snoc_release_resource(ar);
 	ath10k_core_destroy(ar);
diff --git a/drivers/net/wireless/ath/ath10k/snoc.h b/drivers/net/wireless/ath/ath10k/snoc.h
index 05dc98f..a9bca2e 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.h
+++ b/drivers/net/wireless/ath/ath10k/snoc.h
@@ -82,6 +82,9 @@ struct ath10k_snoc {
 	struct timer_list rx_post_retry;
 	struct ath10k_wcn3990_vreg_info *vreg;
 	struct ath10k_wcn3990_clk_info *clk;
+	struct dma_iommu_mapping *smmu_mapping;
+	dma_addr_t smmu_iova_start;
+	size_t smmu_iova_len;
 };
 
 static inline struct ath10k_snoc *ath10k_snoc_priv(struct ath10k *ar)
-- 
1.9.1
