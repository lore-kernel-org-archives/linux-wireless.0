Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:37007 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbaHSIWu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2014 04:22:50 -0400
Subject: [PATCH v7 1/8] ath10k: add ath10k_pci_diag_* helpers
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 19 Aug 2014 11:22:46 +0300
Message-ID: <20140819082245.16842.10751.stgit@potku.adurom.net> (sfid-20140819_102254_048245_7839FB0E)
In-Reply-To: <20140819082038.16842.46876.stgit@potku.adurom.net>
References: <20140819082038.16842.46876.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath10k_pci_diag_read32() is for reading u32 from a device and ath10k_pci_diag_read_hi()
is a helper for reading data using "host interest" table.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c |   55 +++++++++++++++++++++++----------
 1 file changed, 38 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 98c029b7d0ab..b4ae4bb3fc09 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -460,13 +460,46 @@ done:
 	return ret;
 }
 
+static int ath10k_pci_diag_read32(struct ath10k *ar, u32 address, u32 *value)
+{
+	return ath10k_pci_diag_read_mem(ar, address, value, sizeof(u32));
+}
+
+static int __ath10k_pci_diag_read_hi(struct ath10k *ar, void *dest,
+				     u32 src, u32 len)
+{
+	u32 host_addr, addr;
+	int ret;
+
+	host_addr = host_interest_item_address(src);
+
+	ret = ath10k_pci_diag_read32(ar, host_addr, &addr);
+	if (ret != 0) {
+		ath10k_warn("failed to get memcpy hi address for firmware address %d: %d\n",
+			    src, ret);
+		return ret;
+	}
+
+	ret = ath10k_pci_diag_read_mem(ar, addr, dest, len);
+	if (ret != 0) {
+		ath10k_warn("failed to memcpy firmware memory from %d (%d B): %d\n",
+			    addr, len, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+#define ath10k_pci_diag_read_hi(ar, dest, src, len)		\
+	__ath10k_pci_diag_read_hi(ar, dest, HI_ITEM(src), len);
+
 /* Read 4-byte aligned data from Target memory or register */
 static int ath10k_pci_diag_read_access(struct ath10k *ar, u32 address,
 				       u32 *data)
 {
 	/* Assume range doesn't cross this boundary */
 	if (address >= DRAM_BASE_ADDRESS)
-		return ath10k_pci_diag_read_mem(ar, address, data, sizeof(u32));
+		return ath10k_pci_diag_read32(ar, address, data);
 
 	*data = ath10k_pci_read32(ar, address);
 	return 0;
@@ -801,9 +834,7 @@ static u16 ath10k_pci_hif_get_free_queue_number(struct ath10k *ar, u8 pipe)
 
 static void ath10k_pci_hif_dump_area(struct ath10k *ar)
 {
-	u32 reg_dump_area = 0;
 	u32 reg_dump_values[REG_DUMP_COUNT_QCA988X] = {};
-	u32 host_addr;
 	int ret;
 	u32 i;
 
@@ -812,21 +843,11 @@ static void ath10k_pci_hif_dump_area(struct ath10k *ar)
 		   ar->hw_params.name, ar->target_version);
 	ath10k_err("firmware version: %s\n", ar->hw->wiphy->fw_version);
 
-	host_addr = host_interest_item_address(HI_ITEM(hi_failure_state));
-	ret = ath10k_pci_diag_read_mem(ar, host_addr,
-				       &reg_dump_area, sizeof(u32));
+	ret = ath10k_pci_diag_read_hi(ar, &reg_dump_values[0],
+				      hi_failure_state,
+				      REG_DUMP_COUNT_QCA988X * sizeof(u32));
 	if (ret) {
-		ath10k_err("failed to read FW dump area address: %d\n", ret);
-		return;
-	}
-
-	ath10k_err("target register Dump Location: 0x%08X\n", reg_dump_area);
-
-	ret = ath10k_pci_diag_read_mem(ar, reg_dump_area,
-				       &reg_dump_values[0],
-				       REG_DUMP_COUNT_QCA988X * sizeof(u32));
-	if (ret != 0) {
-		ath10k_err("failed to read FW dump area: %d\n", ret);
+		ath10k_err("failed to read firmware dump area: %d\n", ret);
 		return;
 	}
 

