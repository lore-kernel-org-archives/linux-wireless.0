Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:46801 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752943AbbAULNV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2015 06:13:21 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t0LB8opN007713
	for <linux-wireless@vger.kernel.org>; Wed, 21 Jan 2015 03:13:20 -0800
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0a-0016f401.pphosted.com with ESMTP id 1s09vs9ghh-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 21 Jan 2015 03:13:20 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <yogeshp@marvell.com>,
	<nishants@marvell.com>, <frankh@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 2/3] mwifiex: add support for USB8801
Date: Wed, 21 Jan 2015 22:12:10 +0530
Message-ID: <1421858531-4536-2-git-send-email-patila@marvell.com> (sfid-20150121_121334_991347_A65C6775)
In-Reply-To: <1421858531-4536-1-git-send-email-patila@marvell.com>
References: <1421858531-4536-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

USB8801 is Marvell's 1x1 802.11bgn offering.
Patch adds Device IDs support and defines TX buffer size.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Frank Huang <frankh@marvell.com>
---
 drivers/net/wireless/mwifiex/usb.c | 13 +++++++++++++
 drivers/net/wireless/mwifiex/usb.h |  4 ++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index 6c62995..50517b7 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -37,6 +37,11 @@ static struct usb_device_id mwifiex_usb_table[] = {
 	{USB_DEVICE_AND_INTERFACE_INFO(USB8XXX_VID, USB8797_PID_2,
 				       USB_CLASS_VENDOR_SPEC,
 				       USB_SUBCLASS_VENDOR_SPEC, 0xff)},
+	/* 8801 */
+	{USB_DEVICE(USB8XXX_VID, USB8801_PID_1)},
+	{USB_DEVICE_AND_INTERFACE_INFO(USB8XXX_VID, USB8801_PID_2,
+				       USB_CLASS_VENDOR_SPEC,
+				       USB_SUBCLASS_VENDOR_SPEC, 0xff)},
 	/* 8897 */
 	{USB_DEVICE(USB8XXX_VID, USB8897_PID_1)},
 	{USB_DEVICE_AND_INTERFACE_INFO(USB8XXX_VID, USB8897_PID_2,
@@ -361,11 +366,13 @@ static int mwifiex_usb_probe(struct usb_interface *intf,
 	switch (id_product) {
 	case USB8766_PID_1:
 	case USB8797_PID_1:
+	case USB8801_PID_1:
 	case USB8897_PID_1:
 		card->usb_boot_state = USB8XXX_FW_DNLD;
 		break;
 	case USB8766_PID_2:
 	case USB8797_PID_2:
+	case USB8801_PID_2:
 	case USB8897_PID_2:
 		card->usb_boot_state = USB8XXX_FW_READY;
 		break;
@@ -798,6 +805,11 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 		adapter->tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K;
 		strcpy(adapter->fw_name, USB8766_DEFAULT_FW_NAME);
 		break;
+	case USB8801_PID_1:
+	case USB8801_PID_2:
+		adapter->tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K;
+		strcpy(adapter->fw_name, USB8801_DEFAULT_FW_NAME);
+		break;
 	case USB8797_PID_1:
 	case USB8797_PID_2:
 	default:
@@ -1083,4 +1095,5 @@ MODULE_VERSION(USB_VERSION);
 MODULE_LICENSE("GPL v2");
 MODULE_FIRMWARE(USB8766_DEFAULT_FW_NAME);
 MODULE_FIRMWARE(USB8797_DEFAULT_FW_NAME);
+MODULE_FIRMWARE(USB8801_DEFAULT_FW_NAME);
 MODULE_FIRMWARE(USB8897_DEFAULT_FW_NAME);
diff --git a/drivers/net/wireless/mwifiex/usb.h b/drivers/net/wireless/mwifiex/usb.h
index 0ad1beb..57e1a57 100644
--- a/drivers/net/wireless/mwifiex/usb.h
+++ b/drivers/net/wireless/mwifiex/usb.h
@@ -30,6 +30,9 @@
 #define USB8797_PID_2		0x2044
 #define USB8897_PID_1		0x2045
 #define USB8897_PID_2		0x2046
+#define USB8801_PID_1		0x2049
+#define USB8801_PID_2		0x204a
+
 
 #define USB8XXX_FW_DNLD		1
 #define USB8XXX_FW_READY	2
@@ -41,6 +44,7 @@
 
 #define USB8766_DEFAULT_FW_NAME	"mrvl/usb8766_uapsta.bin"
 #define USB8797_DEFAULT_FW_NAME	"mrvl/usb8797_uapsta.bin"
+#define USB8801_DEFAULT_FW_NAME	"mrvl/usb8801_uapsta.bin"
 #define USB8897_DEFAULT_FW_NAME	"mrvl/usb8897_uapsta.bin"
 
 #define FW_DNLD_TX_BUF_SIZE	620
-- 
1.8.1.4

