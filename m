Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57720 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755154AbeBOIr6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Feb 2018 03:47:58 -0500
From: Govind Singh <govinds@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH 02/13] ath10k: add resource init and deinit for WCN3990
Date: Thu, 15 Feb 2018 14:17:50 +0530
Message-Id: <1518684470-5397-1-git-send-email-govinds@codeaurora.org> (sfid-20180215_094801_444210_4D4C1255)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add methods for resource(memory, irq, HOST CE config)
initialization and de-initialization for WCN3990 target.

WCN3990 target uses 12 copy engine and following CE config.

[CE0] :host->target control and raw streams
[CE1] :target->host HTT
[CE2] :target->host WMI
[CE3] :host->target WMI
[CE4] :host->target HTT
[CE5] :reserved
[CE6] :Target autonomous HIF_memcpy
[CE7] :reserved
[CE8] :reserved
[CE9] :target->host HTT
[CE10] :target->host HTT
[CE11] :target -> host PKTLOG

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 271 +++++++++++++++++++++++++++++++++
 1 file changed, 271 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 30354a6..575355c 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -24,12 +24,135 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
+#define  WCN3990_CE_ATTR_FLAGS 0
+
+static char *const ce_name[] = {
+	"WLAN_CE_0",
+	"WLAN_CE_1",
+	"WLAN_CE_2",
+	"WLAN_CE_3",
+	"WLAN_CE_4",
+	"WLAN_CE_5",
+	"WLAN_CE_6",
+	"WLAN_CE_7",
+	"WLAN_CE_8",
+	"WLAN_CE_9",
+	"WLAN_CE_10",
+	"WLAN_CE_11",
+};
 
 static const struct ath10k_snoc_drv_priv drv_priv = {
 	.hw_rev = ATH10K_HW_WCN3990,
 	.dma_mask = DMA_BIT_MASK(37),
 };
 
+static struct ce_attr host_ce_config_wlan[] = {
+	/* CE0: host->target HTC control streams */
+	{
+		.flags = WCN3990_CE_ATTR_FLAGS,
+		.src_nentries = 16,
+		.src_sz_max = 2048,
+		.dest_nentries = 0,
+		.send_cb = NULL,
+	},
+
+	/* CE1: target->host HTT + HTC control */
+	{
+		.flags = WCN3990_CE_ATTR_FLAGS,
+		.src_nentries = 0,
+		.src_sz_max = 2048,
+		.dest_nentries = 512,
+		.recv_cb = NULL,
+	},
+
+	/* CE2: target->host WMI */
+	{
+		.flags = WCN3990_CE_ATTR_FLAGS,
+		.src_nentries = 0,
+		.src_sz_max = 2048,
+		.dest_nentries = 64,
+		.recv_cb = NULL,
+	},
+
+	/* CE3: host->target WMI */
+	{
+		.flags = WCN3990_CE_ATTR_FLAGS,
+		.src_nentries = 32,
+		.src_sz_max = 2048,
+		.dest_nentries = 0,
+		.send_cb = NULL,
+	},
+
+	/* CE4: host->target HTT */
+	{
+		.flags = WCN3990_CE_ATTR_FLAGS | CE_ATTR_DIS_INTR,
+		.src_nentries = 256,
+		.src_sz_max = 256,
+		.dest_nentries = 0,
+		.send_cb = NULL,
+	},
+
+	/* CE5: target->host HTT (ipa_uc->target ) */
+	{
+		.flags = WCN3990_CE_ATTR_FLAGS,
+		.src_nentries = 0,
+		.src_sz_max = 512,
+		.dest_nentries = 512,
+		.recv_cb = NULL,
+	},
+
+	/* CE6: target autonomous hif_memcpy */
+	{
+		.flags = WCN3990_CE_ATTR_FLAGS,
+		.src_nentries = 0,
+		.src_sz_max = 0,
+		.dest_nentries = 0,
+	},
+
+	/* CE7: ce_diag, the Diagnostic Window */
+	{
+		.flags = WCN3990_CE_ATTR_FLAGS,
+		.src_nentries = 2,
+		.src_sz_max = 2048,
+		.dest_nentries = 2,
+	},
+
+	/* CE8: Target to uMC */
+	{
+		.flags = WCN3990_CE_ATTR_FLAGS,
+		.src_nentries = 0,
+		.src_sz_max = 2048,
+		.dest_nentries = 128,
+	},
+
+	/* CE9 target->host HTT */
+	{
+		.flags = WCN3990_CE_ATTR_FLAGS,
+		.src_nentries = 0,
+		.src_sz_max = 2048,
+		.dest_nentries = 512,
+		.recv_cb = NULL,
+	},
+
+	/* CE10: target->host HTT */
+	{
+		.flags = WCN3990_CE_ATTR_FLAGS,
+		.src_nentries = 0,
+		.src_sz_max = 2048,
+		.dest_nentries = 512,
+		.recv_cb = NULL,
+	},
+
+	/* CE11: target -> host PKTLOG */
+	{
+		.flags = WCN3990_CE_ATTR_FLAGS,
+		.src_nentries = 0,
+		.src_sz_max = 2048,
+		.dest_nentries = 512,
+		.recv_cb = NULL,
+	},
+};
+
 void ath10k_snoc_write32(struct ath10k *ar, u32 offset, u32 value)
 {
 	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
@@ -57,6 +180,119 @@ u32 ath10k_snoc_read32(struct ath10k *ar, u32 offset)
 	.write32	= ath10k_snoc_write32,
 };
 
+static irqreturn_t ath10k_snoc_per_engine_handler(int irq, void *arg)
+{
+	return IRQ_HANDLED;
+}
+
+static int ath10k_snoc_request_irq(struct ath10k *ar)
+{
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
+	int irqflags = IRQF_TRIGGER_RISING;
+	int ret, id;
+
+	for (id = 0; id < CE_COUNT_MAX; id++) {
+		ret = request_irq(ar_snoc->ce_irqs[id].irq_line,
+				  ath10k_snoc_per_engine_handler,
+				  irqflags, ce_name[id], ar);
+		if (ret) {
+			ath10k_err(ar,
+				   "failed to register IRQ handler for CE %d: %d",
+				   id, ret);
+			goto err_irq;
+		}
+	}
+
+	return 0;
+
+err_irq:
+	for (id -= 1; id >= 0; id--)
+		free_irq(ar_snoc->ce_irqs[id].irq_line, ar);
+
+	return ret;
+}
+
+static void ath10k_snoc_free_irq(struct ath10k *ar)
+{
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
+	int id;
+
+	for (id = 0; id < CE_COUNT_MAX; id++)
+		free_irq(ar_snoc->ce_irqs[id].irq_line, ar);
+}
+
+static int ath10k_snoc_resource_init(struct ath10k *ar)
+{
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
+	struct platform_device *pdev;
+	struct resource *res;
+	int i, ret = 0;
+
+	pdev = ar_snoc->dev;
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "membase");
+	if (!res) {
+		ath10k_err(ar, "Memory base not found in DT\n");
+		return -EINVAL;
+	}
+
+	ar_snoc->mem_pa = res->start;
+	ar_snoc->mem = devm_ioremap(&pdev->dev, ar_snoc->mem_pa,
+				    resource_size(res));
+	if (!ar_snoc->mem) {
+		ath10k_err(ar, "Memory base ioremap failed with physical address %pa\n",
+			   &ar_snoc->mem_pa);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < CE_COUNT; i++) {
+		res = platform_get_resource(ar_snoc->dev, IORESOURCE_IRQ, i);
+		if (!res) {
+			ath10k_err(ar, "failed to get IRQ%d\n", i);
+			ret = -ENODEV;
+			goto out;
+		}
+		ar_snoc->ce_irqs[i].irq_line = res->start;
+	}
+
+out:
+	return ret;
+}
+
+static int ath10k_snoc_setup_resource(struct ath10k *ar)
+{
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
+	struct ath10k_ce *ce = ath10k_ce_priv(ar);
+	struct ath10k_snoc_pipe *pipe;
+	int i, ret;
+
+	spin_lock_init(&ce->ce_lock);
+	for (i = 0; i < CE_COUNT; i++) {
+		pipe = &ar_snoc->pipe_info[i];
+		pipe->ce_hdl = &ce->ce_states[i];
+		pipe->pipe_num = i;
+		pipe->hif_ce_state = ar;
+
+		ret = ath10k_ce_alloc_pipe(ar, i, &host_ce_config_wlan[i]);
+		if (ret) {
+			ath10k_err(ar, "failed to allocate copy engine pipe %d: %d\n",
+				   i, ret);
+			return ret;
+		}
+
+		pipe->buf_sz = host_ce_config_wlan[i].src_sz_max;
+	}
+
+	return 0;
+}
+
+static void ath10k_snoc_release_resource(struct ath10k *ar)
+{
+	int i;
+
+	for (i = 0; i < CE_COUNT; i++)
+		ath10k_ce_free_pipe(ar, i);
+}
+
 static const struct of_device_id ath10k_snoc_dt_match[] = {
 	{ .compatible = "qcom,wcn3990-wifi",
 	 .data = &drv_priv,
@@ -103,9 +339,41 @@ static int ath10k_snoc_probe(struct platform_device *pdev)
 	ar_snoc->ce.bus_ops = &ath10k_snoc_bus_ops;
 	ar->ce_priv = &ar_snoc->ce;
 
+	ath10k_snoc_resource_init(ar);
+	if (ret) {
+		ath10k_warn(ar, "failed to initialize resource: %d\n", ret);
+		goto err_core_destroy;
+	}
+
+	ath10k_snoc_setup_resource(ar);
+	if (ret) {
+		ath10k_warn(ar, "failed to setup resource: %d\n", ret);
+		goto err_core_destroy;
+	}
+	ret = ath10k_snoc_request_irq(ar);
+	if (ret) {
+		ath10k_warn(ar, "failed to request irqs: %d\n", ret);
+		goto err_release_resource;
+	}
+	ret = ath10k_core_register(ar, drv_data->hw_rev);
+	if (ret) {
+		ath10k_err(ar, "failed to register driver core: %d\n", ret);
+		goto err_free_irq;
+	}
 	ath10k_dbg(ar, ATH10K_DBG_SNOC, "snoc probe\n");
 	ath10k_warn(ar, "Warning: SNOC support is still work-in-progress, it will not work properly!");
 
+	return 0;
+
+err_free_irq:
+	ath10k_snoc_free_irq(ar);
+
+err_release_resource:
+	ath10k_snoc_release_resource(ar);
+
+err_core_destroy:
+	ath10k_core_destroy(ar);
+
 	return ret;
 }
 
@@ -114,6 +382,9 @@ static int ath10k_snoc_remove(struct platform_device *pdev)
 	struct ath10k *ar = platform_get_drvdata(pdev);
 
 	ath10k_dbg(ar, ATH10K_DBG_SNOC, "snoc remove\n");
+	ath10k_core_unregister(ar);
+	ath10k_snoc_free_irq(ar);
+	ath10k_snoc_release_resource(ar);
 	ath10k_core_destroy(ar);
 
 	return 0;
-- 
1.9.1
