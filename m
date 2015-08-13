Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:36168 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbbHMMcH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 08:32:07 -0400
Received: by lagz9 with SMTP id z9so25190909lag.3
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2015 05:32:05 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: arnd@arndb.de, twilightrook@gmail.com, vvanpo@gmail.com,
	linux-wireless@vger.kernel.org, oscarrydberg@gmail.com,
	joseph.salisbury@canonical.com,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH/RFT 1/2] ath10k: add qca6164 support
Date: Thu, 13 Aug 2015 14:32:26 +0200
Message-Id: <1439469147-9408-2-git-send-email-michal.kazior@tieto.com> (sfid-20150813_143215_838728_53C30295)
In-Reply-To: <1439469147-9408-1-git-send-email-michal.kazior@tieto.com>
References: <1439469147-9408-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds additional 0x0041 PCI Device ID
definition to ath10k for QCA6164 which is a 1
spatial stream sibling of the QCA6174 (which is 2
spatial stream chip).

The QCA6164 needs a dedicated board.bin file which
is different than the one used for QCA6174. If the
board.bin is wrong the device will crash early
while trying to boot firmware. The register dump
will look like this:

 ath10k_pci 0000:02:00.0: firmware register dump:
 ath10k_pci 0000:02:00.0: [00]: 0x05010000 0x000015B3 0x000A012D 0x00955B31
 ...

Note the value 0x000A012D.

Special credit goes to Alan Liu
<alanliu@qca.qualcomm.com> for providing support
help which enabled me to come up with this patch.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 11 +++++++++++
 drivers/net/wireless/ath/ath10k/core.h |  1 +
 drivers/net/wireless/ath/ath10k/pci.c  | 13 +++++++++++++
 3 files changed, 25 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 25510679fd2e..1ea16d044645 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -231,6 +231,17 @@ static int ath10k_init_configure_target(struct ath10k *ar)
 		return ret;
 	}
 
+	/* Some devices have a special sanity check that verifies the PCI
+	 * Device ID is written to this host interest var. It is known to be
+	 * required to boot QCA6164.
+	 */
+	ret = ath10k_bmi_write32(ar, hi_hci_uart_pwr_mgmt_params_ext,
+				 ar->dev_id);
+	if (ret) {
+		ath10k_err(ar, "failed to set pwr_mgmt_params: %d\n", ret);
+		return ret;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 6a387bac27b0..91d4409dee0b 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -554,6 +554,7 @@ struct ath10k {
 	u8 mac_addr[ETH_ALEN];
 
 	enum ath10k_hw_rev hw_rev;
+	u16 dev_id;
 	u32 chip_id;
 	u32 target_version;
 	u8 fw_version_major;
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index f00b251ec9ce..49a7538325e3 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -58,11 +58,13 @@ MODULE_PARM_DESC(reset_mode, "0: auto, 1: warm only (default: 0)");
 #define ATH10K_PCI_NUM_WARM_RESET_ATTEMPTS 3
 
 #define QCA988X_2_0_DEVICE_ID	(0x003c)
+#define QCA6164_2_1_DEVICE_ID	(0x0041)
 #define QCA6174_2_1_DEVICE_ID	(0x003e)
 #define QCA99X0_2_0_DEVICE_ID	(0x0040)
 
 static const struct pci_device_id ath10k_pci_id_table[] = {
 	{ PCI_VDEVICE(ATHEROS, QCA988X_2_0_DEVICE_ID) }, /* PCI-E QCA988X V2 */
+	{ PCI_VDEVICE(ATHEROS, QCA6164_2_1_DEVICE_ID) }, /* PCI-E QCA6164 V2.1 */
 	{ PCI_VDEVICE(ATHEROS, QCA6174_2_1_DEVICE_ID) }, /* PCI-E QCA6174 V2.1 */
 	{ PCI_VDEVICE(ATHEROS, QCA99X0_2_0_DEVICE_ID) }, /* PCI-E QCA99X0 V2 */
 	{0}
@@ -74,11 +76,19 @@ static const struct ath10k_pci_supp_chip ath10k_pci_supp_chips[] = {
 	 * because of that.
 	 */
 	{ QCA988X_2_0_DEVICE_ID, QCA988X_HW_2_0_CHIP_ID_REV },
+
+	{ QCA6164_2_1_DEVICE_ID, QCA6174_HW_2_1_CHIP_ID_REV },
+	{ QCA6164_2_1_DEVICE_ID, QCA6174_HW_2_2_CHIP_ID_REV },
+	{ QCA6164_2_1_DEVICE_ID, QCA6174_HW_3_0_CHIP_ID_REV },
+	{ QCA6164_2_1_DEVICE_ID, QCA6174_HW_3_1_CHIP_ID_REV },
+	{ QCA6164_2_1_DEVICE_ID, QCA6174_HW_3_2_CHIP_ID_REV },
+
 	{ QCA6174_2_1_DEVICE_ID, QCA6174_HW_2_1_CHIP_ID_REV },
 	{ QCA6174_2_1_DEVICE_ID, QCA6174_HW_2_2_CHIP_ID_REV },
 	{ QCA6174_2_1_DEVICE_ID, QCA6174_HW_3_0_CHIP_ID_REV },
 	{ QCA6174_2_1_DEVICE_ID, QCA6174_HW_3_1_CHIP_ID_REV },
 	{ QCA6174_2_1_DEVICE_ID, QCA6174_HW_3_2_CHIP_ID_REV },
+
 	{ QCA99X0_2_0_DEVICE_ID, QCA99X0_HW_2_0_CHIP_ID_REV },
 };
 
@@ -1810,6 +1820,7 @@ static int ath10k_pci_get_num_banks(struct ath10k *ar)
 	case QCA988X_2_0_DEVICE_ID:
 	case QCA99X0_2_0_DEVICE_ID:
 		return 1;
+	case QCA6164_2_1_DEVICE_ID:
 	case QCA6174_2_1_DEVICE_ID:
 		switch (MS(ar->chip_id, SOC_CHIP_ID_REV)) {
 		case QCA6174_HW_1_0_CHIP_ID_REV:
@@ -2898,6 +2909,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	case QCA988X_2_0_DEVICE_ID:
 		hw_rev = ATH10K_HW_QCA988X;
 		break;
+	case QCA6164_2_1_DEVICE_ID:
 	case QCA6174_2_1_DEVICE_ID:
 		hw_rev = ATH10K_HW_QCA6174;
 		break;
@@ -2922,6 +2934,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	ar_pci->pdev = pdev;
 	ar_pci->dev = &pdev->dev;
 	ar_pci->ar = ar;
+	ar->dev_id = pci_dev->device;
 
 	if (pdev->subsystem_vendor || pdev->subsystem_device)
 		scnprintf(ar->spec_board_id, sizeof(ar->spec_board_id),
-- 
2.1.4

