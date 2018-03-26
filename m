Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44378 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750955AbeCZI6r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 04:58:47 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Anilkumar Kolli <akolli@codeaurora.org>
Subject: [PATCH 2/2] ath10k: add memory dump support QCA9984
Date: Mon, 26 Mar 2018 11:58:34 +0300
Message-Id: <1522054714-31492-2-git-send-email-kvalo@codeaurora.org> (sfid-20180326_105850_455120_1391E11F)
In-Reply-To: <1522054714-31492-1-git-send-email-kvalo@codeaurora.org>
References: <1522054714-31492-1-git-send-email-kvalo@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Anilkumar Kolli <akolli@codeaurora.org>

QCA9984/QCA99X0/QCA4019 chipsets have 8 memory regions, dump all of them to the
firmware coredump file. Some of the regions need to be read using ioread() so
add new region types for them.

Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
[kvalo: refactoring etc]
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/coredump.c | 90 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/coredump.h |  2 +
 drivers/net/wireless/ath/ath10k/pci.c      | 43 ++++++++++++++
 3 files changed, 135 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/coredump.c b/drivers/net/wireless/ath/ath10k/coredump.c
index 7173b3743b43..f90cec0ebb1c 100644
--- a/drivers/net/wireless/ath/ath10k/coredump.c
+++ b/drivers/net/wireless/ath/ath10k/coredump.c
@@ -701,6 +701,89 @@ static const struct ath10k_mem_region qca988x_hw20_mem_regions[] = {
 	},
 };
 
+static const struct ath10k_mem_region qca9984_hw10_mem_regions[] = {
+	{
+		.type = ATH10K_MEM_REGION_TYPE_DRAM,
+		.start = 0x400000,
+		.len = 0x80000,
+		.name = "DRAM",
+		.section_table = {
+			.sections = NULL,
+			.size = 0,
+		},
+	},
+	{
+		.type = ATH10K_MEM_REGION_TYPE_REG,
+		.start = 0x98000,
+		.len = 0x50000,
+		.name = "IRAM",
+		.section_table = {
+			.sections = NULL,
+			.size = 0,
+		},
+	},
+	{
+		.type = ATH10K_MEM_REGION_TYPE_IOSRAM,
+		.start = 0xC0000,
+		.len = 0x40000,
+		.name = "SRAM",
+		.section_table = {
+			.sections = NULL,
+			.size = 0,
+		},
+	},
+	{
+		.type = ATH10K_MEM_REGION_TYPE_IOREG,
+		.start = 0x30000,
+		.len = 0x7000,
+		.name = "APB REG 1",
+		.section_table = {
+			.sections = NULL,
+			.size = 0,
+		},
+	},
+	{
+		.type = ATH10K_MEM_REGION_TYPE_IOREG,
+		.start = 0x3f000,
+		.len = 0x3000,
+		.name = "APB REG 2",
+		.section_table = {
+			.sections = NULL,
+			.size = 0,
+		},
+	},
+	{
+		.type = ATH10K_MEM_REGION_TYPE_IOREG,
+		.start = 0x43000,
+		.len = 0x3000,
+		.name = "WIFI REG",
+		.section_table = {
+			.sections = NULL,
+			.size = 0,
+		},
+	},
+	{
+		.type = ATH10K_MEM_REGION_TYPE_IOREG,
+		.start = 0x4A000,
+		.len = 0x5000,
+		.name = "CE REG",
+		.section_table = {
+			.sections = NULL,
+			.size = 0,
+		},
+	},
+	{
+		.type = ATH10K_MEM_REGION_TYPE_IOREG,
+		.start = 0x80000,
+		.len = 0x6000,
+		.name = "SOC REG",
+		.section_table = {
+			.sections = NULL,
+			.size = 0,
+		},
+	},
+};
+
 static const struct ath10k_hw_mem_layout hw_mem_layouts[] = {
 	{
 		.hw_id = QCA6174_HW_1_0_VERSION,
@@ -758,6 +841,13 @@ static const struct ath10k_hw_mem_layout hw_mem_layouts[] = {
 			.size = ARRAY_SIZE(qca988x_hw20_mem_regions),
 		},
 	},
+	{
+		.hw_id = QCA9984_HW_1_0_DEV_VERSION,
+		.region_table = {
+			.regions = qca9984_hw10_mem_regions,
+			.size = ARRAY_SIZE(qca9984_hw10_mem_regions),
+		},
+	},
 };
 
 static u32 ath10k_coredump_get_ramdump_size(struct ath10k *ar)
diff --git a/drivers/net/wireless/ath/ath10k/coredump.h b/drivers/net/wireless/ath/ath10k/coredump.h
index bfee13038e59..3baaf9d2cbcd 100644
--- a/drivers/net/wireless/ath/ath10k/coredump.h
+++ b/drivers/net/wireless/ath/ath10k/coredump.h
@@ -124,6 +124,8 @@ enum ath10k_mem_region_type {
 	ATH10K_MEM_REGION_TYPE_AXI	= 3,
 	ATH10K_MEM_REGION_TYPE_IRAM1	= 4,
 	ATH10K_MEM_REGION_TYPE_IRAM2	= 5,
+	ATH10K_MEM_REGION_TYPE_IOSRAM	= 6,
+	ATH10K_MEM_REGION_TYPE_IOREG	= 7,
 };
 
 /* Define a section of the region which should be copied. As not all parts
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 977b7dade44e..cc42c96e3c05 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -57,6 +57,10 @@ MODULE_PARM_DESC(reset_mode, "0: auto, 1: warm only (default: 0)");
  */
 #define ATH10K_DIAG_TRANSFER_LIMIT	0x5000
 
+#define QCA99X0_PCIE_BAR0_START_REG    0x81030
+#define QCA99X0_CPU_MEM_ADDR_REG       0x4d00c
+#define QCA99X0_CPU_MEM_DATA_REG       0x4d010
+
 static const struct pci_device_id ath10k_pci_id_table[] = {
 	/* PCI-E QCA988X V2 (Ubiquiti branded) */
 	{ PCI_VDEVICE(UBIQUITI, QCA988X_2_0_DEVICE_ID_UBNT) },
@@ -1585,6 +1589,39 @@ static int ath10k_pci_set_ram_config(struct ath10k *ar, u32 config)
 }
 
 /* if an error happened returns < 0, otherwise the length */
+static int ath10k_pci_dump_memory_sram(struct ath10k *ar,
+				       const struct ath10k_mem_region *region,
+				       u8 *buf)
+{
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	u32 base_addr, i;
+
+	base_addr = ioread32(ar_pci->mem + QCA99X0_PCIE_BAR0_START_REG);
+	base_addr += region->start;
+
+	for (i = 0; i < region->len; i += 4) {
+		iowrite32(base_addr + i, ar_pci->mem + QCA99X0_CPU_MEM_ADDR_REG);
+		*(u32 *)(buf + i) = ioread32(ar_pci->mem + QCA99X0_CPU_MEM_DATA_REG);
+	}
+
+	return region->len;
+}
+
+/* if an error happened returns < 0, otherwise the length */
+static int ath10k_pci_dump_memory_reg(struct ath10k *ar,
+				      const struct ath10k_mem_region *region,
+				      u8 *buf)
+{
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	u32 i;
+
+	for (i = 0; i < region->len; i += 4)
+		*(u32 *)(buf + i) = ioread32(ar_pci->mem + region->start + i);
+
+	return region->len;
+}
+
+/* if an error happened returns < 0, otherwise the length */
 static int ath10k_pci_dump_memory_generic(struct ath10k *ar,
 					  const struct ath10k_mem_region *current_region,
 					  u8 *buf)
@@ -1673,6 +1710,12 @@ static void ath10k_pci_dump_memory(struct ath10k *ar,
 		buf_len -= sizeof(*hdr);
 
 		switch (current_region->type) {
+		case ATH10K_MEM_REGION_TYPE_IOSRAM:
+			count = ath10k_pci_dump_memory_sram(ar, current_region, buf);
+			break;
+		case ATH10K_MEM_REGION_TYPE_IOREG:
+			count = ath10k_pci_dump_memory_reg(ar, current_region, buf);
+			break;
 		default:
 			ret = ath10k_pci_dump_memory_generic(ar, current_region, buf);
 			if (ret < 0)
-- 
2.7.4
