Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:25530 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751090AbcG2Kjc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2016 06:39:32 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u6TAU999019147
	for <linux-wireless@vger.kernel.org>; Fri, 29 Jul 2016 03:39:32 -0700
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0b-0016f401.pphosted.com with ESMTP id 24fahmgjc4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 29 Jul 2016 03:39:31 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: PCIe8997 chip specific handling
Date: Fri, 29 Jul 2016 16:08:51 +0530
Message-ID: <1469788731-5361-1-git-send-email-akarwar@marvell.com> (sfid-20160729_123936_725549_EC210C10)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch corrects the revision id register and uses it along with
magic value and chip version registers to download appropriate firmware
image.

PCIe8997 Z chipset variant code has been removed, as it won't be used in
production.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 35 ++++++++++-------------------
 drivers/net/wireless/marvell/mwifiex/pcie.h | 14 +++++-------
 2 files changed, 18 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 81bceef..9aec9a9 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -2910,7 +2910,7 @@ static int mwifiex_pcie_request_irq(struct mwifiex_adapter *adapter)
 static void mwifiex_pcie_get_fw_name(struct mwifiex_adapter *adapter)
 {
 	int revision_id = 0;
-	int version;
+	int version, magic;
 	struct pcie_service_card *card = adapter->card;
 
 	switch (card->dev->device) {
@@ -2935,30 +2935,19 @@ static void mwifiex_pcie_get_fw_name(struct mwifiex_adapter *adapter)
 		}
 		break;
 	case PCIE_DEVICE_ID_MARVELL_88W8997:
-		mwifiex_read_reg(adapter, 0x0c48, &revision_id);
+		mwifiex_read_reg(adapter, 0x8, &revision_id);
 		mwifiex_read_reg(adapter, 0x0cd0, &version);
+		mwifiex_read_reg(adapter, 0x0cd4, &magic);
+		revision_id &= 0xff;
 		version &= 0x7;
-		switch (revision_id) {
-		case PCIE8997_V2:
-			if (version == CHIP_VER_PCIEUART)
-				strcpy(adapter->fw_name,
-				       PCIEUART8997_FW_NAME_V2);
-			else
-				strcpy(adapter->fw_name,
-				       PCIEUSB8997_FW_NAME_V2);
-			break;
-		case PCIE8997_Z:
-			if (version == CHIP_VER_PCIEUART)
-				strcpy(adapter->fw_name,
-				       PCIEUART8997_FW_NAME_Z);
-			else
-				strcpy(adapter->fw_name,
-				       PCIEUSB8997_FW_NAME_Z);
-			break;
-		default:
-			strcpy(adapter->fw_name, PCIE8997_DEFAULT_FW_NAME);
-			break;
-		}
+		magic &= 0xff;
+		if (revision_id == PCIE8997_A1 &&
+		    magic == CHIP_MAGIC_VALUE &&
+		    version == CHIP_VER_PCIEUART)
+			strcpy(adapter->fw_name, PCIEUART8997_FW_NAME_V4);
+		else
+			strcpy(adapter->fw_name, PCIEUSB8997_FW_NAME_V4);
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.h b/drivers/net/wireless/marvell/mwifiex/pcie.h
index f6992f0..46f99ca 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.h
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.h
@@ -32,12 +32,9 @@
 #define PCIE8897_DEFAULT_FW_NAME "mrvl/pcie8897_uapsta.bin"
 #define PCIE8897_A0_FW_NAME "mrvl/pcie8897_uapsta_a0.bin"
 #define PCIE8897_B0_FW_NAME "mrvl/pcie8897_uapsta.bin"
-#define PCIE8997_DEFAULT_FW_NAME "mrvl/pcieusb8997_combo_v2.bin"
-#define PCIEUART8997_FW_NAME_Z "mrvl/pcieuart8997_combo.bin"
-#define PCIEUART8997_FW_NAME_V2 "mrvl/pcieuart8997_combo_v2.bin"
-#define PCIEUSB8997_FW_NAME_Z "mrvl/pcieusb8997_combo.bin"
-#define PCIEUSB8997_FW_NAME_V2 "mrvl/pcieusb8997_combo_v2.bin"
-#define PCIE8997_DEFAULT_WIFIFW_NAME "mrvl/pcie8997_wlan.bin"
+#define PCIEUART8997_FW_NAME_V4 "mrvl/pcieuart8997_combo_v4.bin"
+#define PCIEUSB8997_FW_NAME_V4 "mrvl/pcieusb8997_combo_v4.bin"
+#define PCIE8997_DEFAULT_WIFIFW_NAME "mrvl/pcie8997_wlan_v4.bin"
 
 #define PCIE_VENDOR_ID_MARVELL              (0x11ab)
 #define PCIE_VENDOR_ID_V2_MARVELL           (0x1b4b)
@@ -47,9 +44,10 @@
 
 #define PCIE8897_A0	0x1100
 #define PCIE8897_B0	0x1200
-#define PCIE8997_Z	0x0
-#define PCIE8997_V2	0x471
+#define PCIE8997_A0	0x10
+#define PCIE8997_A1	0x11
 #define CHIP_VER_PCIEUART	0x3
+#define CHIP_MAGIC_VALUE	0x24
 
 /* Constants for Buffer Descriptor (BD) rings */
 #define MWIFIEX_MAX_TXRX_BD			0x20
-- 
1.9.1

