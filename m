Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:30909 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752374AbcDKOxQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2016 10:53:16 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u3BEpdiP016332
	for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2016 07:53:15 -0700
Received: from sc-exch04.marvell.com ([199.233.58.184])
	by mx0a-0016f401.pphosted.com with ESMTP id 226y3kdqvp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2016 07:53:15 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Shengzhen Li <szli@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 2/5] mwifiex: add pcie usb/uart firmware download support
Date: Mon, 11 Apr 2016 07:52:38 -0700
Message-ID: <1460386361-29918-2-git-send-email-akarwar@marvell.com> (sfid-20160411_165403_046089_F1F69866)
In-Reply-To: <1460386361-29918-1-git-send-email-akarwar@marvell.com>
References: <1460386361-29918-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shengzhen Li <szli@marvell.com>

This patch adds support for downloading usb/uart firmware for
8997 chipset by reading the chip version.

Signed-off-by: Shengzhen Li <szli@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 17 +++++++++++++++--
 drivers/net/wireless/marvell/mwifiex/pcie.h |  7 +++++--
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index c28edbb..1d888b5 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -2811,6 +2811,7 @@ static int mwifiex_pcie_request_irq(struct mwifiex_adapter *adapter)
 static void mwifiex_pcie_get_fw_name(struct mwifiex_adapter *adapter)
 {
 	int revision_id = 0;
+	int version;
 	struct pcie_service_card *card = adapter->card;
 
 	switch (card->dev->device) {
@@ -2834,12 +2835,24 @@ static void mwifiex_pcie_get_fw_name(struct mwifiex_adapter *adapter)
 		break;
 	case PCIE_DEVICE_ID_MARVELL_88W8997:
 		mwifiex_read_reg(adapter, 0x0c48, &revision_id);
+		mwifiex_read_reg(adapter, 0x0cd0, &version);
+		version &= 0x7;
 		switch (revision_id) {
 		case PCIE8997_V2:
-			strcpy(adapter->fw_name, PCIE8997_FW_NAME_V2);
+			if (version == CHIP_VER_PCIEUSB)
+				strcpy(adapter->fw_name,
+				       PCIEUSB8997_FW_NAME_V2);
+			else
+				strcpy(adapter->fw_name,
+				       PCIEUART8997_FW_NAME_V2);
 			break;
 		case PCIE8997_Z:
-			strcpy(adapter->fw_name, PCIE8997_FW_NAME_Z);
+			if (version == CHIP_VER_PCIEUSB)
+				strcpy(adapter->fw_name,
+				       PCIEUSB8997_FW_NAME_Z);
+			else
+				strcpy(adapter->fw_name,
+				       PCIEUART8997_FW_NAME_Z);
 			break;
 		default:
 			break;
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.h b/drivers/net/wireless/marvell/mwifiex/pcie.h
index cc7a5df..bbabfb0 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.h
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.h
@@ -32,8 +32,10 @@
 #define PCIE8766_DEFAULT_FW_NAME "mrvl/pcie8766_uapsta.bin"
 #define PCIE8897_A0_FW_NAME "mrvl/pcie8897_uapsta_a0.bin"
 #define PCIE8897_B0_FW_NAME "mrvl/pcie8897_uapsta.bin"
-#define PCIE8997_FW_NAME_Z "mrvl/pcieusb8997_combo.bin"
-#define PCIE8997_FW_NAME_V2 "mrvl/pcieusb8997_combo_v2.bin"
+#define PCIEUART8997_FW_NAME_Z "mrvl/pcieuart8997_combo.bin"
+#define PCIEUART8997_FW_NAME_V2 "mrvl/pcieuart8997_combo_v2.bin"
+#define PCIEUSB8997_FW_NAME_Z "mrvl/pcieusb8997_combo.bin"
+#define PCIEUSB8997_FW_NAME_V2 "mrvl/pcieusb8997_combo_v2.bin"
 
 #define PCIE_VENDOR_ID_MARVELL              (0x11ab)
 #define PCIE_VENDOR_ID_V2_MARVELL           (0x1b4b)
@@ -45,6 +47,7 @@
 #define PCIE8897_B0	0x1200
 #define PCIE8997_Z	0x0
 #define PCIE8997_V2	0x471
+#define CHIP_VER_PCIEUSB	0x2
 
 /* Constants for Buffer Descriptor (BD) rings */
 #define MWIFIEX_MAX_TXRX_BD			0x20
-- 
1.8.1.4

