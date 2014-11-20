Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:54625 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664AbaKTPxR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2014 10:53:17 -0500
Received: by mail-wg0-f43.google.com with SMTP id l18so4144930wgh.2
        for <linux-wireless@vger.kernel.org>; Thu, 20 Nov 2014 07:53:16 -0800 (PST)
From: Kristian Evensen <kristian.evensen@gmail.com>
To: linux-wireless@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, akarwar@marvell.com,
	patila@marvell.com
Cc: Kristian Evensen <kristian.evensen@gmail.com>
Subject: [PATCH] mwifiex: Add USB8766 support
Date: Thu, 20 Nov 2014 16:52:58 +0100
Message-Id: <1416498778-18742-1-git-send-email-kristian.evensen@gmail.com> (sfid-20141120_165323_886969_0A7318FB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kristian Evensen <kristian.evensen@gmail.com>

Adds new VID/PID for the Marvell 88W8766. The kernel currently only supports
the device as PCI, but it is also available using USB. An example of a device
delivered with the 88W8766 as USB is the Globalscale Mirabox.

TX buffer size is set to driver default (2K), as we do not know the firmware
requirement.

Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/wireless/mwifiex/Kconfig |  2 +-
 drivers/net/wireless/mwifiex/usb.c   | 13 +++++++++++++
 drivers/net/wireless/mwifiex/usb.h   |  3 +++
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/Kconfig b/drivers/net/wireless/mwifiex/Kconfig
index e70d0df..aa01c9b 100644
--- a/drivers/net/wireless/mwifiex/Kconfig
+++ b/drivers/net/wireless/mwifiex/Kconfig
@@ -31,7 +31,7 @@ config MWIFIEX_PCIE
 	  mwifiex_pcie.
 
 config MWIFIEX_USB
-	tristate "Marvell WiFi-Ex Driver for USB8797/8897"
+	tristate "Marvell WiFi-Ex Driver for USB8766/8797/8897"
 	depends on MWIFIEX && USB
 	select FW_LOADER
 	---help---
diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index 4371e12..710dbd9 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -27,6 +27,11 @@ static struct mwifiex_if_ops usb_ops;
 static struct semaphore add_remove_card_sem;
 
 static struct usb_device_id mwifiex_usb_table[] = {
+	/* 8766 */
+	{USB_DEVICE(USB8XXX_VID, USB8766_PID_1)},
+	{USB_DEVICE_AND_INTERFACE_INFO(USB8XXX_VID, USB8766_PID_2,
+				       USB_CLASS_VENDOR_SPEC,
+				       USB_SUBCLASS_VENDOR_SPEC, 0xff)},
 	/* 8797 */
 	{USB_DEVICE(USB8XXX_VID, USB8797_PID_1)},
 	{USB_DEVICE_AND_INTERFACE_INFO(USB8XXX_VID, USB8797_PID_2,
@@ -348,10 +353,12 @@ static int mwifiex_usb_probe(struct usb_interface *intf,
 
 	/* PID_1 is used for firmware downloading only */
 	switch (id_product) {
+	case USB8766_PID_1:
 	case USB8797_PID_1:
 	case USB8897_PID_1:
 		card->usb_boot_state = USB8XXX_FW_DNLD;
 		break;
+	case USB8766_PID_2:
 	case USB8797_PID_2:
 	case USB8897_PID_2:
 		card->usb_boot_state = USB8XXX_FW_READY;
@@ -780,6 +787,11 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 		adapter->tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K;
 		strcpy(adapter->fw_name, USB8897_DEFAULT_FW_NAME);
 		break;
+	case USB8766_PID_1:
+	case USB8766_PID_2:
+		adapter->tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K;
+		strcpy(adapter->fw_name, USB8766_DEFAULT_FW_NAME);
+		break;
 	case USB8797_PID_1:
 	case USB8797_PID_2:
 	default:
@@ -1048,5 +1060,6 @@ MODULE_AUTHOR("Marvell International Ltd.");
 MODULE_DESCRIPTION("Marvell WiFi-Ex USB Driver version" USB_VERSION);
 MODULE_VERSION(USB_VERSION);
 MODULE_LICENSE("GPL v2");
+MODULE_FIRMWARE(USB8766_DEFAULT_FW_NAME);
 MODULE_FIRMWARE(USB8797_DEFAULT_FW_NAME);
 MODULE_FIRMWARE(USB8897_DEFAULT_FW_NAME);
diff --git a/drivers/net/wireless/mwifiex/usb.h b/drivers/net/wireless/mwifiex/usb.h
index 4c41c2a..a7cbba1 100644
--- a/drivers/net/wireless/mwifiex/usb.h
+++ b/drivers/net/wireless/mwifiex/usb.h
@@ -24,6 +24,8 @@
 
 #define USB8XXX_VID		0x1286
 
+#define USB8766_PID_1		0x2041
+#define USB8766_PID_2		0x2042
 #define USB8797_PID_1		0x2043
 #define USB8797_PID_2		0x2044
 #define USB8897_PID_1		0x2045
@@ -37,6 +39,7 @@
 #define MWIFIEX_RX_DATA_URB	6
 #define MWIFIEX_USB_TIMEOUT	100
 
+#define USB8766_DEFAULT_FW_NAME	"mrvl/usb8766_uapsta.bin"
 #define USB8797_DEFAULT_FW_NAME	"mrvl/usb8797_uapsta.bin"
 #define USB8897_DEFAULT_FW_NAME	"mrvl/usb8897_uapsta.bin"
 
-- 
1.8.3.2

