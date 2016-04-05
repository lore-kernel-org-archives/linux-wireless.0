Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39477 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755083AbcDEH2v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 03:28:51 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u357SLHU028609
	for <linux-wireless@vger.kernel.org>; Tue, 5 Apr 2016 00:28:50 -0700
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0a-0016f401.pphosted.com with ESMTP id 222bekhtp2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 05 Apr 2016 00:28:50 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Shengzhen Li <szli@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 3/7] mwifiex: check revision id while choosing PCIe firmware
Date: Tue, 5 Apr 2016 00:22:28 -0700
Message-ID: <1459840952-25338-3-git-send-email-akarwar@marvell.com> (sfid-20160405_092855_719320_66950AE2)
In-Reply-To: <1459840952-25338-1-git-send-email-akarwar@marvell.com>
References: <1459840952-25338-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shengzhen Li <szli@marvell.com>

Some of the chipsets have two revisions. This patch
selects appropriate firmware by checking revision id.

Signed-off-by: Shengzhen Li <szli@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 56 ++++++++++++++++++++++++++---
 drivers/net/wireless/marvell/mwifiex/pcie.h | 16 +++++----
 2 files changed, 61 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index de36438..6a06ca5 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -190,7 +190,6 @@ static int mwifiex_pcie_probe(struct pci_dev *pdev,
 
 	if (ent->driver_data) {
 		struct mwifiex_pcie_device *data = (void *)ent->driver_data;
-		card->pcie.firmware = data->firmware;
 		card->pcie.reg = data->reg;
 		card->pcie.blksz_fw_dl = data->blksz_fw_dl;
 		card->pcie.tx_buf_size = data->tx_buf_size;
@@ -269,6 +268,11 @@ static const struct pci_device_id mwifiex_ids[] = {
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		.driver_data = (unsigned long)&mwifiex_pcie8997,
 	},
+	{
+		PCIE_VENDOR_ID_V2_MARVELL, PCIE_DEVICE_ID_MARVELL_88W8997,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		.driver_data = (unsigned long)&mwifiex_pcie8997,
+	},
 	{},
 };
 
@@ -2759,6 +2763,51 @@ static int mwifiex_pcie_request_irq(struct mwifiex_adapter *adapter)
 }
 
 /*
+ * This function get firmare name for downloading by revision id
+ *
+ * Read revision id register to get revision id
+ */
+static void mwifiex_pcie_get_fw_name(struct mwifiex_adapter *adapter)
+{
+	int revision_id = 0;
+	struct pcie_service_card *card = adapter->card;
+
+	switch (card->dev->device) {
+	case PCIE_DEVICE_ID_MARVELL_88W8766P:
+		strcpy(adapter->fw_name, PCIE8766_DEFAULT_FW_NAME);
+		break;
+	case PCIE_DEVICE_ID_MARVELL_88W8897:
+		mwifiex_write_reg(adapter, 0x0c58, 0x80c00000);
+		mwifiex_read_reg(adapter, 0x0c58, &revision_id);
+		revision_id &= 0xff00;
+		switch (revision_id) {
+		case PCIE8897_A0:
+			strcpy(adapter->fw_name, PCIE8897_A0_FW_NAME);
+			break;
+		case PCIE8897_B0:
+			strcpy(adapter->fw_name, PCIE8897_B0_FW_NAME);
+			break;
+		default:
+			break;
+		}
+	case PCIE_DEVICE_ID_MARVELL_88W8997:
+		mwifiex_read_reg(adapter, 0x0c48, &revision_id);
+		switch (revision_id) {
+		case PCIE8997_V2:
+			strcpy(adapter->fw_name, PCIE8997_FW_NAME_V2);
+			break;
+		case PCIE8997_Z:
+			strcpy(adapter->fw_name, PCIE8997_FW_NAME_Z);
+			break;
+		default:
+			break;
+		}
+	default:
+		break;
+	}
+}
+
+/*
  * This function registers the PCIE device.
  *
  * PCIE IRQ is claimed, block size is set and driver data is initialized.
@@ -2778,8 +2827,8 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 	adapter->tx_buf_size = card->pcie.tx_buf_size;
 	adapter->mem_type_mapping_tbl = card->pcie.mem_type_mapping_tbl;
 	adapter->num_mem_types = card->pcie.num_mem_types;
-	strcpy(adapter->fw_name, card->pcie.firmware);
 	adapter->ext_scan = card->pcie.can_ext_scan;
+	mwifiex_pcie_get_fw_name(adapter);
 
 	return 0;
 }
@@ -2907,6 +2956,3 @@ MODULE_AUTHOR("Marvell International Ltd.");
 MODULE_DESCRIPTION("Marvell WiFi-Ex PCI-Express Driver version " PCIE_VERSION);
 MODULE_VERSION(PCIE_VERSION);
 MODULE_LICENSE("GPL v2");
-MODULE_FIRMWARE(PCIE8766_DEFAULT_FW_NAME);
-MODULE_FIRMWARE(PCIE8897_DEFAULT_FW_NAME);
-MODULE_FIRMWARE(PCIE8997_DEFAULT_FW_NAME);
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.h b/drivers/net/wireless/marvell/mwifiex/pcie.h
index 29e58ce..4455d19 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.h
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.h
@@ -30,14 +30,22 @@
 #include    "main.h"
 
 #define PCIE8766_DEFAULT_FW_NAME "mrvl/pcie8766_uapsta.bin"
-#define PCIE8897_DEFAULT_FW_NAME "mrvl/pcie8897_uapsta.bin"
-#define PCIE8997_DEFAULT_FW_NAME "mrvl/pcie8997_uapsta.bin"
+#define PCIE8897_A0_FW_NAME "mrvl/pcie8897_uapsta_a0.bin"
+#define PCIE8897_B0_FW_NAME "mrvl/pcie8897_uapsta.bin"
+#define PCIE8997_FW_NAME_Z "mrvl/pcieusb8997_combo.bin"
+#define PCIE8997_FW_NAME_V2 "mrvl/pcieusb8997_combo_v2.bin"
 
 #define PCIE_VENDOR_ID_MARVELL              (0x11ab)
+#define PCIE_VENDOR_ID_V2_MARVELL           (0x1b4b)
 #define PCIE_DEVICE_ID_MARVELL_88W8766P		(0x2b30)
 #define PCIE_DEVICE_ID_MARVELL_88W8897		(0x2b38)
 #define PCIE_DEVICE_ID_MARVELL_88W8997		(0x2b42)
 
+#define PCIE8897_A0	0x1100
+#define PCIE8897_B0	0x1200
+#define PCIE8997_Z	0x0
+#define PCIE8997_V2	0x471
+
 /* Constants for Buffer Descriptor (BD) rings */
 #define MWIFIEX_MAX_TXRX_BD			0x20
 #define MWIFIEX_TXBD_MASK			0x3F
@@ -263,7 +271,6 @@ static struct memory_type_mapping mem_type_mapping_tbl_w8997[] = {
 };
 
 struct mwifiex_pcie_device {
-	const char *firmware;
 	const struct mwifiex_pcie_card_reg *reg;
 	u16 blksz_fw_dl;
 	u16 tx_buf_size;
@@ -274,7 +281,6 @@ struct mwifiex_pcie_device {
 };
 
 static const struct mwifiex_pcie_device mwifiex_pcie8766 = {
-	.firmware       = PCIE8766_DEFAULT_FW_NAME,
 	.reg            = &mwifiex_reg_8766,
 	.blksz_fw_dl = MWIFIEX_PCIE_BLOCK_SIZE_FW_DNLD,
 	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
@@ -283,7 +289,6 @@ static const struct mwifiex_pcie_device mwifiex_pcie8766 = {
 };
 
 static const struct mwifiex_pcie_device mwifiex_pcie8897 = {
-	.firmware       = PCIE8897_DEFAULT_FW_NAME,
 	.reg            = &mwifiex_reg_8897,
 	.blksz_fw_dl = MWIFIEX_PCIE_BLOCK_SIZE_FW_DNLD,
 	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K,
@@ -294,7 +299,6 @@ static const struct mwifiex_pcie_device mwifiex_pcie8897 = {
 };
 
 static const struct mwifiex_pcie_device mwifiex_pcie8997 = {
-	.firmware       = PCIE8997_DEFAULT_FW_NAME,
 	.reg            = &mwifiex_reg_8997,
 	.blksz_fw_dl = MWIFIEX_PCIE_BLOCK_SIZE_FW_DNLD,
 	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K,
-- 
1.8.1.4

