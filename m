Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:46819 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478AbcA0J5R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 04:57:17 -0500
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH 04/12] ath10k: add basic skeleton to support ahb
Date: Wed, 27 Jan 2016 15:24:25 +0530
Message-ID: <1453888473-2879-5-git-send-email-rmani@qti.qualcomm.com> (sfid-20160127_105729_026173_D6DF6760)
In-Reply-To: <1453888473-2879-1-git-send-email-rmani@qti.qualcomm.com>
References: <1453888473-2879-1-git-send-email-rmani@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

qca4019 uses ahb instead of pci where it slightly differs in device
enumeration, clock control, reset control, etc. Good thing is that
ahb also uses copy engine for the data transaction. So, the most of
the stuff implemented in pci.c/ce.c are reusable in ahb case too.

Device enumeration in ahb case comes through platform driver/device
model. All resource details like irq, memory map, clocks, etc for
qca4019 can be fetched from of_node of platform device.

Simply flow would look like,

 device tree => platform device (kernel) => platform driver (ath10k)

Device tree entry will have all qca4019 resource details and the same
info will be passed to kernel. Kernel will prepare new platform device
for that entry and expose DT info to of_node in platform device.
Later, ath10k would register platform driver with unique compatible name
and then kernels binds to corresponding compatible entry & calls ath10k
ahb probe functions. From there onwards, ath10k will take control of it
and move forward.

New bool flag CONFIG_ATH10K_AHB is added in Kconfig to conditionally
enable ahb support in ath10k. On enabling this flag, ath10k_pci.ko
will have ahb support. This patch adds only basic skeleton and few
macros to support ahb in the context of qca4019.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/Kconfig  |  6 +++
 drivers/net/wireless/ath/ath10k/Makefile |  2 +
 drivers/net/wireless/ath/ath10k/ahb.c    | 67 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/ahb.h    | 41 +++++++++++++++++++
 drivers/net/wireless/ath/ath10k/core.h   |  3 ++
 drivers/net/wireless/ath/ath10k/debug.h  |  1 +
 drivers/net/wireless/ath/ath10k/hw.h     |  2 +
 drivers/net/wireless/ath/ath10k/pci.c    |  8 ++++
 drivers/net/wireless/ath/ath10k/pci.h    |  1 +
 9 files changed, 131 insertions(+)
 create mode 100644 drivers/net/wireless/ath/ath10k/ahb.c
 create mode 100644 drivers/net/wireless/ath/ath10k/ahb.h

diff --git a/drivers/net/wireless/ath/ath10k/Kconfig b/drivers/net/wireless/ath/ath10k/Kconfig
index 03aa35f..d7f207a 100644
--- a/drivers/net/wireless/ath/ath10k/Kconfig
+++ b/drivers/net/wireless/ath/ath10k/Kconfig
@@ -15,6 +15,12 @@ config ATH10K_PCI
 	---help---
 	  This module adds support for PCIE bus
 
+config ATH10K_AHB
+	bool "Atheros ath10k AHB support"
+	depends on ATH10K_PCI && OF
+	---help---
+	  This module adds support for AHB bus
+
 config ATH10K_DEBUG
 	bool "Atheros ath10k debugging"
 	depends on ATH10K
diff --git a/drivers/net/wireless/ath/ath10k/Makefile b/drivers/net/wireless/ath/ath10k/Makefile
index c04fb00..930fadd 100644
--- a/drivers/net/wireless/ath/ath10k/Makefile
+++ b/drivers/net/wireless/ath/ath10k/Makefile
@@ -25,5 +25,7 @@ obj-$(CONFIG_ATH10K_PCI) += ath10k_pci.o
 ath10k_pci-y += pci.o \
 		ce.o
 
+ath10k_pci-$(CONFIG_ATH10K_AHB) += ahb.o
+
 # for tracing framework to find trace.h
 CFLAGS_trace.o := -I$(src)
diff --git a/drivers/net/wireless/ath/ath10k/ahb.c b/drivers/net/wireless/ath/ath10k/ahb.c
new file mode 100644
index 0000000..129f4f4
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/ahb.c
@@ -0,0 +1,67 @@
+/*
+ * Copyright (c) 2016 Qualcomm Atheros, Inc. All rights reserved.
+ * Copyright (c) 2015 The Linux Foundation. All rights reserved.
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
+#include <linux/module.h>
+#include "core.h"
+#include "debug.h"
+#include "ahb.h"
+
+static const struct of_device_id ath10k_ahb_of_match[] = {
+	/* TODO: enable this entry once everything in place.
+	 * { .compatible = "qcom,ipq4019-wifi",
+	 *   .data = (void *)ATH10K_HW_QCA4019 },
+	 */
+	{ }
+};
+
+MODULE_DEVICE_TABLE(of, ath10k_ahb_of_match);
+
+static int ath10k_ahb_probe(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static int ath10k_ahb_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static struct platform_driver ath10k_ahb_driver = {
+	.driver         = {
+		.name   = "ath10k_ahb",
+		.of_match_table = ath10k_ahb_of_match,
+	},
+	.probe  = ath10k_ahb_probe,
+	.remove = ath10k_ahb_remove,
+};
+
+int ath10k_ahb_init(void)
+{
+	int ret;
+
+	printk(KERN_ERR "AHB support is still work in progress\n");
+
+	ret = platform_driver_register(&ath10k_ahb_driver);
+	if (ret)
+		printk(KERN_ERR "failed to register ath10k ahb driver: %d\n",
+		       ret);
+	return ret;
+}
+
+void ath10k_ahb_exit(void)
+{
+	platform_driver_unregister(&ath10k_ahb_driver);
+}
diff --git a/drivers/net/wireless/ath/ath10k/ahb.h b/drivers/net/wireless/ath/ath10k/ahb.h
new file mode 100644
index 0000000..d1afe93
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/ahb.h
@@ -0,0 +1,41 @@
+/*
+ * Copyright (c) 2016 Qualcomm Atheros, Inc. All rights reserved.
+ * Copyright (c) 2015 The Linux Foundation. All rights reserved.
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
+#ifndef _AHB_H_
+#define _AHB_H_
+
+#include <linux/platform_device.h>
+
+#ifdef CONFIG_ATH10K_AHB
+
+int ath10k_ahb_init(void);
+void ath10k_ahb_exit(void);
+
+#else /* CONFIG_ATH10K_AHB */
+
+static inline int ath10k_ahb_init(void)
+{
+	return 0;
+}
+
+static inline void ath10k_ahb_exit(void)
+{
+}
+
+#endif /* CONFIG_ATH10K_AHB */
+
+#endif /* _AHB_H_ */
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 7840cf3..2e1a7da 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -69,6 +69,7 @@ struct ath10k;
 
 enum ath10k_bus {
 	ATH10K_BUS_PCI,
+	ATH10K_BUS_AHB,
 };
 
 static inline const char *ath10k_bus_str(enum ath10k_bus bus)
@@ -76,6 +77,8 @@ static inline const char *ath10k_bus_str(enum ath10k_bus bus)
 	switch (bus) {
 	case ATH10K_BUS_PCI:
 		return "pci";
+	case ATH10K_BUS_AHB:
+		return "ahb";
 	}
 
 	return "unknown";
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 814719c..33a5038 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -37,6 +37,7 @@ enum ath10k_debug_mask {
 	ATH10K_DBG_TESTMODE	= 0x00001000,
 	ATH10K_DBG_WMI_PRINT	= 0x00002000,
 	ATH10K_DBG_PCI_PS	= 0x00004000,
+	ATH10K_DBG_AHB		= 0x00008000,
 	ATH10K_DBG_ANY		= 0xffffffff,
 };
 
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 0678831..f885015 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -200,6 +200,7 @@ enum ath10k_hw_rev {
 	ATH10K_HW_QCA6174,
 	ATH10K_HW_QCA99X0,
 	ATH10K_HW_QCA9377,
+	ATH10K_HW_QCA4019,
 };
 
 struct ath10k_hw_regs {
@@ -253,6 +254,7 @@ void ath10k_hw_fill_survey_time(struct ath10k *ar, struct survey_info *survey,
 #define QCA_REV_6174(ar) ((ar)->hw_rev == ATH10K_HW_QCA6174)
 #define QCA_REV_99X0(ar) ((ar)->hw_rev == ATH10K_HW_QCA99X0)
 #define QCA_REV_9377(ar) ((ar)->hw_rev == ATH10K_HW_QCA9377)
+#define QCA_REV_40XX(ar) ((ar)->hw_rev == ATH10K_HW_QCA4019)
 
 /* Known pecularities:
  *  - raw appears in nwifi decap, raw and nwifi appear in ethernet decap
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 6ef878c..0e338b6 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -851,6 +851,7 @@ static u32 ath10k_pci_targ_cpu_to_ce_addr(struct ath10k *ar, u32 addr)
 		       0x7ff) << 21;
 		break;
 	case ATH10K_HW_QCA99X0:
+	case ATH10K_HW_QCA4019:
 		val = ath10k_pci_read32(ar, PCIE_BAR_REG_ADDRESS);
 		break;
 	}
@@ -1529,6 +1530,7 @@ static void ath10k_pci_irq_msi_fw_mask(struct ath10k *ar)
 				   CORE_CTRL_ADDRESS, val);
 		break;
 	case ATH10K_HW_QCA99X0:
+	case ATH10K_HW_QCA4019:
 		/* TODO: Find appropriate register configuration for QCA99X0
 		 *  to mask irq/MSI.
 		 */
@@ -1551,6 +1553,7 @@ static void ath10k_pci_irq_msi_fw_unmask(struct ath10k *ar)
 				   CORE_CTRL_ADDRESS, val);
 		break;
 	case ATH10K_HW_QCA99X0:
+	case ATH10K_HW_QCA4019:
 		/* TODO: Find appropriate register configuration for QCA99X0
 		 *  to unmask irq/MSI.
 		 */
@@ -3231,6 +3234,10 @@ static int __init ath10k_pci_init(void)
 		printk(KERN_ERR "failed to register ath10k pci driver: %d\n",
 		       ret);
 
+	ret = ath10k_ahb_init();
+	if (ret)
+		printk(KERN_ERR "ahb init failed: %d\n", ret);
+
 	return ret;
 }
 module_init(ath10k_pci_init);
@@ -3238,6 +3245,7 @@ module_init(ath10k_pci_init);
 static void __exit ath10k_pci_exit(void)
 {
 	pci_unregister_driver(&ath10k_pci_driver);
+	ath10k_ahb_exit();
 }
 
 module_exit(ath10k_pci_exit);
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index fcfdbca..c2d4a79 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -22,6 +22,7 @@
 
 #include "hw.h"
 #include "ce.h"
+#include "ahb.h"
 
 /*
  * maximum number of bytes that can be handled atomically by DiagRead/DiagWrite
-- 
1.8.1.2

