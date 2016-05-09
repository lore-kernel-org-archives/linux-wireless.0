Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:49991 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503AbcEIXL2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2016 19:11:28 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH 20/21] ath10k: read firmware crash over ioread32 if CE fails.
Date: Mon,  9 May 2016 16:11:14 -0700
Message-Id: <1462835475-11079-21-git-send-email-greearb@candelatech.com> (sfid-20160510_011141_232586_A22B28BA)
In-Reply-To: <1462835475-11079-1-git-send-email-greearb@candelatech.com>
References: <1462835475-11079-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This might work around problem where sometimes host cannot
access firmware crash over normal CE transport.

Requires CT firmware with matching logic in it's assert
handler (-13 and higher releases).

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/hw.h  |  5 ++++
 drivers/net/wireless/ath/ath10k/pci.c | 56 ++++++++++++++++++++++++++++++++++-
 2 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index d3f37d5..5ff1fac 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -603,6 +603,7 @@ enum ath10k_hw_4addr_pad {
 #define PCIE_INTR_ENABLE_ADDRESS		0x0008
 #define PCIE_INTR_CAUSE_ADDRESS			0x000c
 #define PCIE_INTR_CLR_ADDRESS			ar->regs->pcie_intr_clr_address
+#define SCRATCH_2_ADDRESS                       0x002c
 #define SCRATCH_3_ADDRESS			ar->regs->scratch_3_address
 #define CPU_INTR_ADDRESS			0x0010
 
@@ -614,6 +615,10 @@ enum ath10k_hw_4addr_pad {
 #define FW_IND_INITIALIZED			2
 #define FW_IND_HOST_READY			0x80000000
 
+/* CT firmware only */
+#define FW_IND_SCRATCH2_WR      (1<<14) /* scratch2 has data written to it */
+#define FW_IND_SCRATCH2_RD      (1<<15) /* scratch2 has been read (by host) */
+
 /* HOST_REG interrupt from firmware */
 #define PCIE_INTR_FIRMWARE_MASK			ar->regs->pcie_intr_fw_mask
 #define PCIE_INTR_CE_MASK_ALL			ar->regs->pcie_intr_ce_mask_all
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 2adc459..330c150 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1507,6 +1507,54 @@ static void ath10k_pci_dump_exc_stack(struct ath10k *ar,
 				     hi_err_stack);
 }
 
+/* Only CT firmware can do this.  Attempt to read crash dump over pci
+ * registers since normal CE transport is not working.
+ */
+static int ath10k_ct_fw_crash_regs_harder(struct ath10k *ar,
+					  __le32 *reg_dump_values,
+					  int len)
+{
+	u32 val;
+	int i;
+	int q;
+#define MAX_SPIN_TRIES 1000000
+
+	if (!test_bit(ATH10K_FW_FEATURE_WMI_10X_CT,
+		      ar->running_fw->fw_file.fw_features)) {
+		return -EINVAL;
+	}
+
+	for (i = 0; i<MAX_SPIN_TRIES; i++) {
+		val = ath10k_pci_read32(ar, FW_INDICATOR_ADDRESS);
+		if (val & FW_IND_SCRATCH2_WR)
+			goto pingpong;
+	}
+	return -EBUSY;
+
+pingpong:
+	ath10k_warn(ar, "Trying to read crash dump over pingpong registers.\n");
+	/* Firmware is trying to send us info it seems. */
+	for (q = 0; q<len; q++) {
+		reg_dump_values[q] = ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS + SCRATCH_2_ADDRESS);
+		val = ath10k_pci_read32(ar, FW_INDICATOR_ADDRESS);
+		val |= FW_IND_SCRATCH2_RD; /* tell firmware we read it */
+		val &= ~FW_IND_SCRATCH2_WR; /* clear firmware's write flag */
+		ath10k_pci_write32(ar, FW_INDICATOR_ADDRESS, val);
+
+		for (i = 0; i<MAX_SPIN_TRIES; i++) {
+			val = ath10k_pci_read32(ar, FW_INDICATOR_ADDRESS);
+			if (val & FW_IND_SCRATCH2_WR)
+				break;
+		}
+		if (!(val & FW_IND_SCRATCH2_WR)) {
+			ath10k_err(ar, "failed to read reg %i via pingpong method.\n",
+				   q);
+			return 0; // partial read is better than nothing I guess
+		}
+	}
+	return 0;
+}
+
 static void ath10k_pci_dump_registers(struct ath10k *ar,
 				      struct ath10k_fw_crash_data *crash_data)
 {
@@ -1520,7 +1568,13 @@ static void ath10k_pci_dump_registers(struct ath10k *ar,
 				      REG_DUMP_COUNT_QCA988X * sizeof(__le32));
 	if (ret) {
 		ath10k_err(ar, "failed to read firmware dump area: %d\n", ret);
-		return;
+
+		/* Try to read this directly over registers...only works on new
+		 * CT firmware.
+		 */
+		ret = ath10k_ct_fw_crash_regs_harder(ar, reg_dump_values, REG_DUMP_COUNT_QCA988X);
+		if (ret)
+			return;
 	}
 
 	BUILD_BUG_ON(REG_DUMP_COUNT_QCA988X % 4);
-- 
2.4.3

