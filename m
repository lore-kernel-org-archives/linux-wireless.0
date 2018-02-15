Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56644 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755154AbeBOIro (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Feb 2018 03:47:44 -0500
From: Govind Singh <govinds@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH 01/13] ath10k: platform driver for WCN3990 SNOC WLAN module
Date: Thu, 15 Feb 2018 14:17:38 +0530
Message-Id: <1518684458-5338-1-git-send-email-govinds@codeaurora.org> (sfid-20180215_094747_924041_5D039EFB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WCN3990 is integrated 802.11ac chipset with SNOC
bus interface. Add snoc layer driver registration
and associated ops.

WCN3990 support is not yet complete as cold-boot
handshake is done using qmi(Qualcomm-MSM-Interface)
and qmi client support will be added once qmi framework
is available.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/Kconfig  |   8 ++
 drivers/net/wireless/ath/ath10k/Makefile |   4 +
 drivers/net/wireless/ath/ath10k/snoc.c   | 153 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/snoc.h   |  76 +++++++++++++++
 4 files changed, 241 insertions(+)
 create mode 100644 drivers/net/wireless/ath/ath10k/snoc.c
 create mode 100644 drivers/net/wireless/ath/ath10k/snoc.h

diff --git a/drivers/net/wireless/ath/ath10k/Kconfig b/drivers/net/wireless/ath/ath10k/Kconfig
index deb5ae2..1b317eb 100644
--- a/drivers/net/wireless/ath/ath10k/Kconfig
+++ b/drivers/net/wireless/ath/ath10k/Kconfig
@@ -36,6 +36,14 @@ config ATH10K_USB
 	  This module adds experimental support for USB bus. Currently
 	  work in progress and will not fully work.
 
+config ATH10K_SNOC
+        tristate "Qualcomm ath10k SNOC support (EXPERIMENTAL)"
+        depends on ATH10K && ARCH_QCOM
+        ---help---
+          This module adds support for integrated WCN3990 chip connected
+          to system NOC(SNOC). Currently work in progress and will not
+          fully work.
+
 config ATH10K_DEBUG
 	bool "Atheros ath10k debugging"
 	depends on ATH10K
diff --git a/drivers/net/wireless/ath/ath10k/Makefile b/drivers/net/wireless/ath/ath10k/Makefile
index 6739ac2..390fde0 100644
--- a/drivers/net/wireless/ath/ath10k/Makefile
+++ b/drivers/net/wireless/ath/ath10k/Makefile
@@ -35,5 +35,9 @@ ath10k_sdio-y += sdio.o
 obj-$(CONFIG_ATH10K_USB) += ath10k_usb.o
 ath10k_usb-y += usb.o
 
+obj-$(CONFIG_ATH10K_SNOC) += ath10k_snoc.o
+ath10k_snoc-y += snoc.o \
+		 ce.o
+
 # for tracing framework to find trace.h
 CFLAGS_trace.o := -I$(src)
diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
new file mode 100644
index 0000000..30354a6
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -0,0 +1,153 @@
+/*
+ * Copyright (c) 2018 The Linux Foundation. All rights reserved.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include "debug.h"
+#include "hif.h"
+#include "htc.h"
+#include "ce.h"
+#include "snoc.h"
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+
+static const struct ath10k_snoc_drv_priv drv_priv = {
+	.hw_rev = ATH10K_HW_WCN3990,
+	.dma_mask = DMA_BIT_MASK(37),
+};
+
+void ath10k_snoc_write32(struct ath10k *ar, u32 offset, u32 value)
+{
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
+
+	iowrite32(value, ar_snoc->mem + offset);
+}
+
+u32 ath10k_snoc_read32(struct ath10k *ar, u32 offset)
+{
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
+	u32 val;
+
+	val = ioread32(ar_snoc->mem + offset);
+
+	return val;
+}
+
+static const struct ath10k_hif_ops ath10k_snoc_hif_ops = {
+	.read32			= ath10k_snoc_read32,
+	.write32		= ath10k_snoc_write32,
+};
+
+static const struct ath10k_bus_ops ath10k_snoc_bus_ops = {
+	.read32		= ath10k_snoc_read32,
+	.write32	= ath10k_snoc_write32,
+};
+
+static const struct of_device_id ath10k_snoc_dt_match[] = {
+	{ .compatible = "qcom,wcn3990-wifi",
+	 .data = &drv_priv,
+	},
+	{ }
+};
+MODULE_DEVICE_TABLE(of, ath10k_snoc_dt_match);
+
+static int ath10k_snoc_probe(struct platform_device *pdev)
+{
+	const struct ath10k_snoc_drv_priv *drv_data;
+	const struct of_device_id *of_id;
+	struct ath10k_snoc *ar_snoc;
+	struct device *dev;
+	struct ath10k *ar;
+	int ret;
+
+	of_id = of_match_device(ath10k_snoc_dt_match, &pdev->dev);
+	if (!of_id) {
+		dev_err(&pdev->dev, "failed to find matching device tree id\n");
+		return -EINVAL;
+	}
+
+	drv_data = of_id->data;
+	dev = &pdev->dev;
+
+	ret = dma_set_mask_and_coherent(dev, drv_data->dma_mask);
+	if (ret) {
+		dev_err(dev, "failed to set dma mask: %d", ret);
+		return ret;
+	}
+
+	ar = ath10k_core_create(sizeof(*ar_snoc), dev, ATH10K_BUS_SNOC,
+				drv_data->hw_rev, &ath10k_snoc_hif_ops);
+	if (!ar) {
+		dev_err(dev, "failed to allocate core\n");
+		return -ENOMEM;
+	}
+
+	ar_snoc = ath10k_snoc_priv(ar);
+	ar_snoc->dev = pdev;
+	platform_set_drvdata(pdev, ar);
+	ar_snoc->ar = ar;
+	ar_snoc->ce.bus_ops = &ath10k_snoc_bus_ops;
+	ar->ce_priv = &ar_snoc->ce;
+
+	ath10k_dbg(ar, ATH10K_DBG_SNOC, "snoc probe\n");
+	ath10k_warn(ar, "Warning: SNOC support is still work-in-progress, it will not work properly!");
+
+	return ret;
+}
+
+static int ath10k_snoc_remove(struct platform_device *pdev)
+{
+	struct ath10k *ar = platform_get_drvdata(pdev);
+
+	ath10k_dbg(ar, ATH10K_DBG_SNOC, "snoc remove\n");
+	ath10k_core_destroy(ar);
+
+	return 0;
+}
+
+static struct platform_driver ath10k_snoc_driver = {
+		.probe  = ath10k_snoc_probe,
+		.remove = ath10k_snoc_remove,
+		.driver = {
+			.name   = "ath10k_snoc",
+			.owner = THIS_MODULE,
+			.of_match_table = ath10k_snoc_dt_match,
+		},
+};
+
+static int __init ath10k_snoc_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&ath10k_snoc_driver);
+	if (ret)
+		pr_err("failed to register ath10k snoc driver: %d\n",
+		       ret);
+
+	return ret;
+}
+module_init(ath10k_snoc_init);
+
+static void __exit ath10k_snoc_exit(void)
+{
+	platform_driver_unregister(&ath10k_snoc_driver);
+}
+module_exit(ath10k_snoc_exit);
+
+MODULE_AUTHOR("Qualcomm");
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_DESCRIPTION("Driver support for Atheros WCN3990 SNOC devices");
diff --git a/drivers/net/wireless/ath/ath10k/snoc.h b/drivers/net/wireless/ath/ath10k/snoc.h
new file mode 100644
index 0000000..cf65b01
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/snoc.h
@@ -0,0 +1,76 @@
+/*
+ * Copyright (c) 2018 The Linux Foundation. All rights reserved.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef _SNOC_H_
+#define _SNOC_H_
+
+#include "hw.h"
+#include "ce.h"
+#include "pci.h"
+
+struct ath10k_snoc_drv_priv {
+	enum ath10k_hw_rev hw_rev;
+	u64 dma_mask;
+};
+
+struct snoc_state {
+	u32 pipe_cfg_addr;
+	u32 svc_to_pipe_map;
+};
+
+struct ath10k_snoc_pipe {
+	struct ath10k_ce_pipe *ce_hdl;
+	u8 pipe_num;
+	struct ath10k *hif_ce_state;
+	size_t buf_sz;
+	/* protect ce info */
+	spinlock_t pipe_lock;
+	struct ath10k_snoc *ar_snoc;
+};
+
+struct ath10k_snoc_target_info {
+	u32 target_version;
+	u32 target_type;
+	u32 target_revision;
+	u32 soc_version;
+};
+
+struct ath10k_snoc_ce_irq {
+	u32 irq_line;
+};
+
+struct ath10k_snoc {
+	struct platform_device *dev;
+	struct ath10k *ar;
+	void __iomem *mem;
+	dma_addr_t mem_pa;
+	struct ath10k_snoc_target_info target_info;
+	size_t mem_len;
+	struct ath10k_snoc_pipe pipe_info[CE_COUNT_MAX];
+	struct ath10k_snoc_ce_irq ce_irqs[CE_COUNT_MAX];
+	struct ath10k_ce ce;
+	struct timer_list rx_post_retry;
+};
+
+static inline struct ath10k_snoc *ath10k_snoc_priv(struct ath10k *ar)
+{
+	return (struct ath10k_snoc *)ar->drv_priv;
+}
+
+void ath10k_snoc_write32(struct ath10k *ar, u32 offset, u32 value);
+u32 ath10k_snoc_read32(struct ath10k *ar, u32 offset);
+
+#endif /* _SNOC_H_ */
-- 
1.9.1
