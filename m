Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32916 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbbGULgh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2015 07:36:37 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH] ath10k: Add QCA99X0 to supported device list
Date: Tue, 21 Jul 2015 17:06:07 +0530
Message-ID: <1437478567-11339-1-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20150721_133640_651685_1F1E6723)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add vendor/device id of QCA99X0 V2.0 to pci id table and
QCA99X0_HW_2_0_CHIP_ID_REV to ath10k_pci_supp_chips[] for
QCA99X0 to get detected by the driver.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 5778e52..cc0e897 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -64,6 +64,7 @@ MODULE_PARM_DESC(reset_mode, "0: auto, 1: warm only (default: 0)");
 static const struct pci_device_id ath10k_pci_id_table[] = {
 	{ PCI_VDEVICE(ATHEROS, QCA988X_2_0_DEVICE_ID) }, /* PCI-E QCA988X V2 */
 	{ PCI_VDEVICE(ATHEROS, QCA6174_2_1_DEVICE_ID) }, /* PCI-E QCA6174 V2.1 */
+	{ PCI_VDEVICE(ATHEROS, QCA99X0_2_0_DEVICE_ID) }, /* PCI-E QCA99X0 V2 */
 	{0}
 };
 
@@ -78,6 +79,7 @@ static const struct ath10k_pci_supp_chip ath10k_pci_supp_chips[] = {
 	{ QCA6174_2_1_DEVICE_ID, QCA6174_HW_3_0_CHIP_ID_REV },
 	{ QCA6174_2_1_DEVICE_ID, QCA6174_HW_3_1_CHIP_ID_REV },
 	{ QCA6174_2_1_DEVICE_ID, QCA6174_HW_3_2_CHIP_ID_REV },
+	{ QCA99X0_2_0_DEVICE_ID, QCA99X0_HW_2_0_CHIP_ID_REV },
 };
 
 static void ath10k_pci_buffer_cleanup(struct ath10k *ar);
-- 
1.9.1

