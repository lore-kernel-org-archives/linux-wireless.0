Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35296 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751716AbdEPKDB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 May 2017 06:03:01 -0400
Received: by mail-pg0-f68.google.com with SMTP id i63so20849494pgd.2
        for <linux-wireless@vger.kernel.org>; Tue, 16 May 2017 03:03:01 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [v3 05/11] rsi: use macros in USB specific code
Date: Tue, 16 May 2017 15:31:11 +0530
Message-Id: <1494928877-27168-6-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170516_120346_375397_CD0ECF46)
In-Reply-To: <1494928877-27168-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1494928877-27168-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

For USB vendor read and write operations new macros added to avoid
redundant usage of long or'ed macros. Also for timeouts standard USB
macros are used.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
v3: Same as v2 04/11
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 5f6c700..9e1359a 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -141,6 +141,9 @@ static int rsi_find_bulk_in_and_out_endpoints(struct usb_interface *interface,
 	return 0;
 }
 
+#define RSI_USB_REQ_OUT	(USB_TYPE_VENDOR | USB_DIR_OUT | USB_RECIP_DEVICE)
+#define RSI_USB_REQ_IN	(USB_TYPE_VENDOR | USB_DIR_IN | USB_RECIP_DEVICE)
+
 /* rsi_usb_reg_read() - This function reads data from given register address.
  * @usbdev: Pointer to the usb_device structure.
  * @reg: Address of the register to be read.
@@ -164,11 +167,11 @@ static int rsi_usb_reg_read(struct usb_device *usbdev,
 	status = usb_control_msg(usbdev,
 				 usb_rcvctrlpipe(usbdev, 0),
 				 USB_VENDOR_REGISTER_READ,
-				 USB_TYPE_VENDOR,
+				 RSI_USB_REQ_IN,
 				 ((reg & 0xffff0000) >> 16), (reg & 0xffff),
 				 (void *)buf,
 				 len,
-				 HZ * 5);
+				 USB_CTRL_GET_TIMEOUT);
 
 	*value = (buf[0] | (buf[1] << 8));
 	if (status < 0) {
@@ -211,12 +214,12 @@ static int rsi_usb_reg_write(struct usb_device *usbdev,
 	status = usb_control_msg(usbdev,
 				 usb_sndctrlpipe(usbdev, 0),
 				 USB_VENDOR_REGISTER_WRITE,
-				 USB_TYPE_VENDOR,
+				 RSI_USB_REQ_OUT,
 				 ((reg & 0xffff0000) >> 16),
 				 (reg & 0xffff),
 				 (void *)usb_reg_buf,
 				 len,
-				 HZ * 5);
+				 USB_CTRL_SET_TIMEOUT);
 	if (status < 0) {
 		rsi_dbg(ERR_ZONE,
 			"%s: Reg write failed with error code :%d\n",
@@ -303,12 +306,12 @@ int rsi_usb_write_register_multiple(struct rsi_hw *adapter,
 		status = usb_control_msg(dev->usbdev,
 					 usb_sndctrlpipe(dev->usbdev, 0),
 					 USB_VENDOR_REGISTER_WRITE,
-					 USB_TYPE_VENDOR,
+					 RSI_USB_REQ_OUT,
 					 ((addr & 0xffff0000) >> 16),
 					 (addr & 0xffff),
 					 (void *)buf,
 					 transfer,
-					 HZ * 5);
+					 USB_CTRL_SET_TIMEOUT);
 		if (status < 0) {
 			rsi_dbg(ERR_ZONE,
 				"Reg write failed with error code :%d\n",
-- 
2.7.4
