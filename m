Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:65260 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752119AbcF3Q4U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2016 12:56:20 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u5UGpxZD008080
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jun 2016 09:56:19 -0700
Received: from sc-exch02.marvell.com ([199.233.58.182])
	by mx0a-0016f401.pphosted.com with ESMTP id 23sqakur2m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jun 2016 09:56:19 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Nishant Sarmukadam <nishants@marvell.com>,
	Cathy Luo <cluo@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: Change default firmware for PCIe8997 chipset
Date: Thu, 30 Jun 2016 22:24:57 +0530
Message-ID: <1467305697-2371-1-git-send-email-akarwar@marvell.com> (sfid-20160630_185623_122917_D5EE007A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PCIe-USB8997 variant is being used in the product. Let's change default
firmware from PCIe-UART to PCIe-USB. So by default PCIe-USB firmware would
be downloaded if version register doesn't give any information.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 12 ++++++------
 drivers/net/wireless/marvell/mwifiex/pcie.h |  4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index e15c483..2352031 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -2841,20 +2841,20 @@ static void mwifiex_pcie_get_fw_name(struct mwifiex_adapter *adapter)
 		version &= 0x7;
 		switch (revision_id) {
 		case PCIE8997_V2:
-			if (version == CHIP_VER_PCIEUSB)
+			if (version == CHIP_VER_PCIEUART)
 				strcpy(adapter->fw_name,
-				       PCIEUSB8997_FW_NAME_V2);
+				       PCIEUART8997_FW_NAME_V2);
 			else
 				strcpy(adapter->fw_name,
-				       PCIEUART8997_FW_NAME_V2);
+				       PCIEUSB8997_FW_NAME_V2);
 			break;
 		case PCIE8997_Z:
-			if (version == CHIP_VER_PCIEUSB)
+			if (version == CHIP_VER_PCIEUART)
 				strcpy(adapter->fw_name,
-				       PCIEUSB8997_FW_NAME_Z);
+				       PCIEUART8997_FW_NAME_Z);
 			else
 				strcpy(adapter->fw_name,
-				       PCIEUART8997_FW_NAME_Z);
+				       PCIEUSB8997_FW_NAME_Z);
 			break;
 		default:
 			strcpy(adapter->fw_name, PCIE8997_DEFAULT_FW_NAME);
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.h b/drivers/net/wireless/marvell/mwifiex/pcie.h
index 9c00c7e..f05061c 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.h
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.h
@@ -32,7 +32,7 @@
 #define PCIE8897_DEFAULT_FW_NAME "mrvl/pcie8897_uapsta.bin"
 #define PCIE8897_A0_FW_NAME "mrvl/pcie8897_uapsta_a0.bin"
 #define PCIE8897_B0_FW_NAME "mrvl/pcie8897_uapsta.bin"
-#define PCIE8997_DEFAULT_FW_NAME "mrvl/pcieuart8997_combo_v2.bin"
+#define PCIE8997_DEFAULT_FW_NAME "mrvl/pcieusb8997_combo_v2.bin"
 #define PCIEUART8997_FW_NAME_Z "mrvl/pcieuart8997_combo.bin"
 #define PCIEUART8997_FW_NAME_V2 "mrvl/pcieuart8997_combo_v2.bin"
 #define PCIEUSB8997_FW_NAME_Z "mrvl/pcieusb8997_combo.bin"
@@ -48,7 +48,7 @@
 #define PCIE8897_B0	0x1200
 #define PCIE8997_Z	0x0
 #define PCIE8997_V2	0x471
-#define CHIP_VER_PCIEUSB	0x2
+#define CHIP_VER_PCIEUART	0x3
 
 /* Constants for Buffer Descriptor (BD) rings */
 #define MWIFIEX_MAX_TXRX_BD			0x20
-- 
1.9.1

