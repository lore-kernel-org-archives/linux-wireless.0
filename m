Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:43897 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932942Ab3HGNSG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Aug 2013 09:18:06 -0400
Received: by mail-ee0-f45.google.com with SMTP id c50so849755eek.4
        for <linux-wireless@vger.kernel.org>; Wed, 07 Aug 2013 06:18:04 -0700 (PDT)
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH 1/2] ath10k: Remove qca98xx hw1.0 support
Date: Wed,  7 Aug 2013 15:17:45 +0200
Message-Id: <1375881466-30090-1-git-send-email-bartosz.markowski@tieto.com> (sfid-20130807_151815_566853_4E344DA9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the firmware support is no longer available for hw1.0,
drop all code (especially workarounds) for those units.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/ce.c   |   31 +------------------------------
 drivers/net/wireless/ath/ath10k/core.c |   11 -----------
 drivers/net/wireless/ath/ath10k/hw.h   |    8 --------
 drivers/net/wireless/ath/ath10k/pci.c  |   15 ---------------
 drivers/net/wireless/ath/ath10k/pci.h  |   23 ++---------------------
 5 files changed, 3 insertions(+), 85 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index f8b969f..9c9f081 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -76,36 +76,7 @@ static inline void ath10k_ce_src_ring_write_index_set(struct ath10k *ar,
 						      u32 ce_ctrl_addr,
 						      unsigned int n)
 {
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	void __iomem *indicator_addr;
-
-	if (!test_bit(ATH10K_PCI_FEATURE_HW_1_0_WORKAROUND, ar_pci->features)) {
-		ath10k_pci_write32(ar, ce_ctrl_addr + SR_WR_INDEX_ADDRESS, n);
-		return;
-	}
-
-	/* workaround for QCA988x_1.0 HW CE */
-	indicator_addr = ar_pci->mem + ce_ctrl_addr + DST_WATERMARK_ADDRESS;
-
-	if (ce_ctrl_addr == ath10k_ce_base_address(CDC_WAR_DATA_CE)) {
-		iowrite32((CDC_WAR_MAGIC_STR | n), indicator_addr);
-	} else {
-		unsigned long irq_flags;
-		local_irq_save(irq_flags);
-		iowrite32(1, indicator_addr);
-
-		/*
-		 * PCIE write waits for ACK in IPQ8K, there is no
-		 * need to read back value.
-		 */
-		(void)ioread32(indicator_addr);
-		(void)ioread32(indicator_addr); /* conservative */
-
-		ath10k_pci_write32(ar, ce_ctrl_addr + SR_WR_INDEX_ADDRESS, n);
-
-		iowrite32(0, indicator_addr);
-		local_irq_restore(irq_flags);
-	}
+	ath10k_pci_write32(ar, ce_ctrl_addr + SR_WR_INDEX_ADDRESS, n);
 }
 
 static inline u32 ath10k_ce_src_ring_write_index_get(struct ath10k *ar,
diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 7226c23..04c132e 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -39,17 +39,6 @@ MODULE_PARM_DESC(p2p, "Enable ath10k P2P support");
 
 static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 	{
-		.id = QCA988X_HW_1_0_VERSION,
-		.name = "qca988x hw1.0",
-		.patch_load_addr = QCA988X_HW_1_0_PATCH_LOAD_ADDR,
-		.fw = {
-			.dir = QCA988X_HW_1_0_FW_DIR,
-			.fw = QCA988X_HW_1_0_FW_FILE,
-			.otp = QCA988X_HW_1_0_OTP_FILE,
-			.board = QCA988X_HW_1_0_BOARD_DATA_FILE,
-		},
-	},
-	{
 		.id = QCA988X_HW_2_0_VERSION,
 		.name = "qca988x hw2.0",
 		.patch_load_addr = QCA988X_HW_2_0_PATCH_LOAD_ADDR,
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 44ed5af..373c2ef 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -26,14 +26,6 @@
 #define SUPPORTED_FW_RELEASE	0
 #define SUPPORTED_FW_BUILD	629
 
-/* QCA988X 1.0 definitions */
-#define QCA988X_HW_1_0_VERSION		0x4000002c
-#define QCA988X_HW_1_0_FW_DIR		"ath10k/QCA988X/hw1.0"
-#define QCA988X_HW_1_0_FW_FILE		"firmware.bin"
-#define QCA988X_HW_1_0_OTP_FILE		"otp.bin"
-#define QCA988X_HW_1_0_BOARD_DATA_FILE	"board.bin"
-#define QCA988X_HW_1_0_PATCH_LOAD_ADDR	0x1234
-
 /* QCA988X 2.0 definitions */
 #define QCA988X_HW_2_0_VERSION		0x4100016c
 #define QCA988X_HW_2_0_FW_DIR		"ath10k/QCA988X/hw2.0"
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index e2f9ef5..4c94add 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -36,11 +36,9 @@ static unsigned int ath10k_target_ps;
 module_param(ath10k_target_ps, uint, 0644);
 MODULE_PARM_DESC(ath10k_target_ps, "Enable ath10k Target (SoC) PS option");
 
-#define QCA988X_1_0_DEVICE_ID	(0xabcd)
 #define QCA988X_2_0_DEVICE_ID	(0x003c)
 
 static DEFINE_PCI_DEVICE_TABLE(ath10k_pci_id_table) = {
-	{ PCI_VDEVICE(ATHEROS, QCA988X_1_0_DEVICE_ID) }, /* PCI-E QCA988X V1 */
 	{ PCI_VDEVICE(ATHEROS, QCA988X_2_0_DEVICE_ID) }, /* PCI-E QCA988X V2 */
 	{0}
 };
@@ -2269,9 +2267,6 @@ static void ath10k_pci_dump_features(struct ath10k_pci *ar_pci)
 		case ATH10K_PCI_FEATURE_MSI_X:
 			ath10k_dbg(ATH10K_DBG_PCI, "device supports MSI-X\n");
 			break;
-		case ATH10K_PCI_FEATURE_HW_1_0_WORKAROUND:
-			ath10k_dbg(ATH10K_DBG_PCI, "QCA988X_1.0 workaround enabled\n");
-			break;
 		case ATH10K_PCI_FEATURE_SOC_POWER_SAVE:
 			ath10k_dbg(ATH10K_DBG_PCI, "QCA98XX SoC power save enabled\n");
 			break;
@@ -2298,9 +2293,6 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	ar_pci->dev = &pdev->dev;
 
 	switch (pci_dev->device) {
-	case QCA988X_1_0_DEVICE_ID:
-		set_bit(ATH10K_PCI_FEATURE_HW_1_0_WORKAROUND, ar_pci->features);
-		break;
 	case QCA988X_2_0_DEVICE_ID:
 		set_bit(ATH10K_PCI_FEATURE_MSI_X, ar_pci->features);
 		break;
@@ -2322,10 +2314,6 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 		goto err_ar_pci;
 	}
 
-	/* Enable QCA988X_1.0 HW workarounds */
-	if (test_bit(ATH10K_PCI_FEATURE_HW_1_0_WORKAROUND, ar_pci->features))
-		spin_lock_init(&ar_pci->hw_v1_workaround_lock);
-
 	ar_pci->ar = ar;
 	ar_pci->fw_indicator_address = FW_INDICATOR_ADDRESS;
 	atomic_set(&ar_pci->keep_awake_count, 0);
@@ -2483,9 +2471,6 @@ module_exit(ath10k_pci_exit);
 MODULE_AUTHOR("Qualcomm Atheros");
 MODULE_DESCRIPTION("Driver support for Atheros QCA988X PCIe devices");
 MODULE_LICENSE("Dual BSD/GPL");
-MODULE_FIRMWARE(QCA988X_HW_1_0_FW_DIR "/" QCA988X_HW_1_0_FW_FILE);
-MODULE_FIRMWARE(QCA988X_HW_1_0_FW_DIR "/" QCA988X_HW_1_0_OTP_FILE);
-MODULE_FIRMWARE(QCA988X_HW_1_0_FW_DIR "/" QCA988X_HW_1_0_BOARD_DATA_FILE);
 MODULE_FIRMWARE(QCA988X_HW_2_0_FW_DIR "/" QCA988X_HW_2_0_FW_FILE);
 MODULE_FIRMWARE(QCA988X_HW_2_0_FW_DIR "/" QCA988X_HW_2_0_OTP_FILE);
 MODULE_FIRMWARE(QCA988X_HW_2_0_FW_DIR "/" QCA988X_HW_2_0_BOARD_DATA_FILE);
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index 871bb33..b2439f5 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -152,8 +152,7 @@ struct service_to_pipe {
 
 enum ath10k_pci_features {
 	ATH10K_PCI_FEATURE_MSI_X		= 0,
-	ATH10K_PCI_FEATURE_HW_1_0_WORKAROUND	= 1,
-	ATH10K_PCI_FEATURE_SOC_POWER_SAVE	= 2,
+	ATH10K_PCI_FEATURE_SOC_POWER_SAVE	= 1,
 
 	/* keep last */
 	ATH10K_PCI_FEATURE_COUNT
@@ -234,9 +233,6 @@ struct ath10k_pci {
 
 	/* Map CE id to ce_state */
 	struct ce_state *ce_id_to_state[CE_COUNT_MAX];
-
-	/* makes sure that dummy reads are atomic */
-	spinlock_t hw_v1_workaround_lock;
 };
 
 static inline struct ath10k_pci *ath10k_pci_priv(struct ath10k *ar)
@@ -310,23 +306,8 @@ static inline void ath10k_pci_write32(struct ath10k *ar, u32 offset,
 				      u32 value)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	void __iomem *addr = ar_pci->mem;
-
-	if (test_bit(ATH10K_PCI_FEATURE_HW_1_0_WORKAROUND, ar_pci->features)) {
-		unsigned long irq_flags;
-
-		spin_lock_irqsave(&ar_pci->hw_v1_workaround_lock, irq_flags);
-
-		ioread32(addr+offset+4); /* 3rd read prior to write */
-		ioread32(addr+offset+4); /* 2nd read prior to write */
-		ioread32(addr+offset+4); /* 1st read prior to write */
-		iowrite32(value, addr+offset);
 
-		spin_unlock_irqrestore(&ar_pci->hw_v1_workaround_lock,
-				       irq_flags);
-	} else {
-		iowrite32(value, addr+offset);
-	}
+	iowrite32(value, ar_pci->mem + offset);
 }
 
 static inline u32 ath10k_pci_read32(struct ath10k *ar, u32 offset)
-- 
1.7.9.5

