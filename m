Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:24107 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752227AbbIJO3F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 10:29:05 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t8AEEXID031728
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2015 07:29:03 -0700
Received: from sc-exch01.marvell.com ([199.233.58.181])
	by mx0a-0016f401.pphosted.com with ESMTP id 1wqwrk6ymt-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2015 07:29:03 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Amitkumar Karwar <akarwar@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Cathy Luo <cluo@marvell.com>
Subject: [PATCH 1/2] mwifiex: remove USB8897 chipset support
Date: Thu, 10 Sep 2015 07:27:33 -0700
Message-ID: <1441895254-28890-1-git-send-email-akarwar@marvell.com> (sfid-20150910_162909_542140_B517D7E8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We don't have any customer using this chipset via USB
interface. if both mwifiex_pcie and mwifiex_usb modules
are enabled by user, sometimes mwifiex_usb wins the race
even if user wants wlan interface to be on PCIe and
USB for bluetooth. This patch solves the problem.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Frank Huang <frankh@marvell.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/Kconfig |  4 ++--
 drivers/net/wireless/mwifiex/usb.c   | 14 --------------
 drivers/net/wireless/mwifiex/usb.h   |  3 ---
 3 files changed, 2 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/Kconfig b/drivers/net/wireless/mwifiex/Kconfig
index 317d991..279167d 100644
--- a/drivers/net/wireless/mwifiex/Kconfig
+++ b/drivers/net/wireless/mwifiex/Kconfig
@@ -33,12 +33,12 @@ config MWIFIEX_PCIE
 	  mwifiex_pcie.
 
 config MWIFIEX_USB
-	tristate "Marvell WiFi-Ex Driver for USB8766/8797/8897/8997"
+	tristate "Marvell WiFi-Ex Driver for USB8766/8797/8997"
 	depends on MWIFIEX && USB
 	select FW_LOADER
 	---help---
 	  This adds support for wireless adapters based on Marvell
-	  8797/8897/8997 chipset with USB interface.
+	  8797/8997 chipset with USB interface.
 
 	  If you choose to build it as a module, it will be called
 	  mwifiex_usb.
diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index 5e789b2..bc8619d 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -42,11 +42,6 @@ static struct usb_device_id mwifiex_usb_table[] = {
 	{USB_DEVICE_AND_INTERFACE_INFO(USB8XXX_VID, USB8801_PID_2,
 				       USB_CLASS_VENDOR_SPEC,
 				       USB_SUBCLASS_VENDOR_SPEC, 0xff)},
-	/* 8897 */
-	{USB_DEVICE(USB8XXX_VID, USB8897_PID_1)},
-	{USB_DEVICE_AND_INTERFACE_INFO(USB8XXX_VID, USB8897_PID_2,
-				       USB_CLASS_VENDOR_SPEC,
-				       USB_SUBCLASS_VENDOR_SPEC, 0xff)},
 	/* 8997 */
 	{USB_DEVICE(USB8XXX_VID, USB8997_PID_1)},
 	{USB_DEVICE_AND_INTERFACE_INFO(USB8XXX_VID, USB8997_PID_2,
@@ -386,14 +381,12 @@ static int mwifiex_usb_probe(struct usb_interface *intf,
 	case USB8766_PID_1:
 	case USB8797_PID_1:
 	case USB8801_PID_1:
-	case USB8897_PID_1:
 	case USB8997_PID_1:
 		card->usb_boot_state = USB8XXX_FW_DNLD;
 		break;
 	case USB8766_PID_2:
 	case USB8797_PID_2:
 	case USB8801_PID_2:
-	case USB8897_PID_2:
 	case USB8997_PID_2:
 		card->usb_boot_state = USB8XXX_FW_READY;
 		break;
@@ -827,12 +820,6 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 		strcpy(adapter->fw_name, USB8997_DEFAULT_FW_NAME);
 		adapter->ext_scan = true;
 		break;
-	case USB8897_PID_1:
-	case USB8897_PID_2:
-		adapter->tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K;
-		strcpy(adapter->fw_name, USB8897_DEFAULT_FW_NAME);
-		adapter->ext_scan = true;
-		break;
 	case USB8766_PID_1:
 	case USB8766_PID_2:
 		adapter->tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K;
@@ -1135,5 +1122,4 @@ MODULE_LICENSE("GPL v2");
 MODULE_FIRMWARE(USB8766_DEFAULT_FW_NAME);
 MODULE_FIRMWARE(USB8797_DEFAULT_FW_NAME);
 MODULE_FIRMWARE(USB8801_DEFAULT_FW_NAME);
-MODULE_FIRMWARE(USB8897_DEFAULT_FW_NAME);
 MODULE_FIRMWARE(USB8997_DEFAULT_FW_NAME);
diff --git a/drivers/net/wireless/mwifiex/usb.h b/drivers/net/wireless/mwifiex/usb.h
index f0051f8..1be82d3 100644
--- a/drivers/net/wireless/mwifiex/usb.h
+++ b/drivers/net/wireless/mwifiex/usb.h
@@ -28,8 +28,6 @@
 #define USB8766_PID_2		0x2042
 #define USB8797_PID_1		0x2043
 #define USB8797_PID_2		0x2044
-#define USB8897_PID_1		0x2045
-#define USB8897_PID_2		0x2046
 #define USB8801_PID_1		0x2049
 #define USB8801_PID_2		0x204a
 #define USB8997_PID_1		0x204d
@@ -47,7 +45,6 @@
 #define USB8766_DEFAULT_FW_NAME	"mrvl/usb8766_uapsta.bin"
 #define USB8797_DEFAULT_FW_NAME	"mrvl/usb8797_uapsta.bin"
 #define USB8801_DEFAULT_FW_NAME	"mrvl/usb8801_uapsta.bin"
-#define USB8897_DEFAULT_FW_NAME	"mrvl/usb8897_uapsta.bin"
 #define USB8997_DEFAULT_FW_NAME	"mrvl/usb8997_uapsta.bin"
 
 #define FW_DNLD_TX_BUF_SIZE	620
-- 
1.8.1.4

