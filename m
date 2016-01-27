Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:28194 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbcA0J5q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 04:57:46 -0500
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH 06/12] ath10k: add helper functions in ahb.c for reg rd/wr
Date: Wed, 27 Jan 2016 15:24:27 +0530
Message-ID: <1453888473-2879-7-git-send-email-rmani@qti.qualcomm.com> (sfid-20160127_105807_713426_1733CACD)
In-Reply-To: <1453888473-2879-1-git-send-email-rmani@qti.qualcomm.com>
References: <1453888473-2879-1-git-send-email-rmani@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

qca4019 deals with below register memory region to control the clock,
reset, etc.

        - Memory to control wifi core
        - gcc (outside of wifi)
        - tcsr (outside of wifi)

Add new helper functions to perform read/write in above registers
spaces. Actual ioremap for above registers are done in later patch.
Struct ath10k_ahb is introduced to maintain ahb specific info and
memory this struct will be allocated in the continuation of struct
ath10k_pci (again, memory ath10k_ahb is allocated in the later patch).

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/ahb.c | 55 +++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/ahb.h |  7 +++++
 drivers/net/wireless/ath/ath10k/pci.h |  6 ++++
 3 files changed, 68 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/ahb.c b/drivers/net/wireless/ath/ath10k/ahb.c
index 129f4f4..eab4b47 100644
--- a/drivers/net/wireless/ath/ath10k/ahb.c
+++ b/drivers/net/wireless/ath/ath10k/ahb.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include "core.h"
 #include "debug.h"
+#include "pci.h"
 #include "ahb.h"
 
 static const struct of_device_id ath10k_ahb_of_match[] = {
@@ -29,6 +30,60 @@ static const struct of_device_id ath10k_ahb_of_match[] = {
 
 MODULE_DEVICE_TABLE(of, ath10k_ahb_of_match);
 
+static inline struct ath10k_ahb *ath10k_ahb_priv(struct ath10k *ar)
+{
+	return &((struct ath10k_pci *)ar->drv_priv)->ahb[0];
+}
+
+static void ath10k_ahb_write32(struct ath10k *ar, u32 offset, u32 value)
+{
+	struct ath10k_ahb *ar_ahb = ath10k_ahb_priv(ar);
+
+	iowrite32(value, ar_ahb->mem + offset);
+}
+
+static u32 ath10k_ahb_read32(struct ath10k *ar, u32 offset)
+{
+	struct ath10k_ahb *ar_ahb = ath10k_ahb_priv(ar);
+
+	return ioread32(ar_ahb->mem + offset);
+}
+
+static u32 ath10k_ahb_gcc_read32(struct ath10k *ar, u32 offset)
+{
+	struct ath10k_ahb *ar_ahb = ath10k_ahb_priv(ar);
+
+	return ioread32(ar_ahb->gcc_mem + offset);
+}
+
+static void ath10k_ahb_tcsr_write32(struct ath10k *ar, u32 offset, u32 value)
+{
+	struct ath10k_ahb *ar_ahb = ath10k_ahb_priv(ar);
+
+	iowrite32(value, ar_ahb->tcsr_mem + offset);
+}
+
+static u32 ath10k_ahb_tcsr_read32(struct ath10k *ar, u32 offset)
+{
+	struct ath10k_ahb *ar_ahb = ath10k_ahb_priv(ar);
+
+	return ioread32(ar_ahb->tcsr_mem + offset);
+}
+
+static u32 ath10k_ahb_soc_read32(struct ath10k *ar, u32 addr)
+{
+	return ath10k_ahb_read32(ar, RTC_SOC_BASE_ADDRESS + addr);
+}
+
+static int ath10k_ahb_get_num_banks(struct ath10k *ar)
+{
+	if (ar->hw_rev == ATH10K_HW_QCA4019)
+		return 1;
+
+	ath10k_warn(ar, "unknown number of banks, assuming 1\n");
+	return 1;
+}
+
 static int ath10k_ahb_probe(struct platform_device *pdev)
 {
 	return 0;
diff --git a/drivers/net/wireless/ath/ath10k/ahb.h b/drivers/net/wireless/ath/ath10k/ahb.h
index d1afe93..77d15af 100644
--- a/drivers/net/wireless/ath/ath10k/ahb.h
+++ b/drivers/net/wireless/ath/ath10k/ahb.h
@@ -20,6 +20,13 @@
 
 #include <linux/platform_device.h>
 
+struct ath10k_ahb {
+	struct platform_device *pdev;
+	void __iomem *mem;
+	void __iomem *gcc_mem;
+	void __iomem *tcsr_mem;
+};
+
 #ifdef CONFIG_ATH10K_AHB
 
 int ath10k_ahb_init(void);
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index c2d4a79..249c73a 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -234,6 +234,12 @@ struct ath10k_pci {
 	bool pci_ps;
 
 	const struct ath10k_bus_ops *bus_ops;
+
+	/* Keep this entry in the last, memory for struct ath10k_ahb is
+	 * allocated (ahb support enabled case) in the continuation of
+	 * this struct.
+	 */
+	struct ath10k_ahb ahb[0];
 };
 
 static inline struct ath10k_pci *ath10k_pci_priv(struct ath10k *ar)
-- 
1.8.1.2

