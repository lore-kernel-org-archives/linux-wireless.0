Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:32903 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751987AbdEPKDK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 May 2017 06:03:10 -0400
Received: by mail-pf0-f195.google.com with SMTP id f27so9050755pfe.0
        for <linux-wireless@vger.kernel.org>; Tue, 16 May 2017 03:03:09 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [v3 07/11] rsi: Add usb multi-byte read operation
Date: Tue, 16 May 2017 15:31:13 +0530
Message-Id: <1494928877-27168-8-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170516_120348_009050_D6AE1F6B)
In-Reply-To: <1494928877-27168-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1494928877-27168-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

USB multibyte read will be used in the new firmware loading method
for RS9113 chipset.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
v3: Use RSI_USB_BUF_SIZE macro for 4096
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 40 ++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index a900a72..31f96f0 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -276,6 +276,46 @@ static int rsi_rx_urb_submit(struct rsi_hw *adapter)
 	return status;
 }
 
+static int rsi_usb_read_register_multiple(struct rsi_hw *adapter, u32 addr,
+					  u8 *data, u16 count)
+{
+	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
+	u8 *buf;
+	u16 transfer;
+	int status;
+
+	if (!addr)
+		return -EINVAL;
+
+	buf = kzalloc(RSI_USB_BUF_SIZE, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	while (count) {
+		transfer = min_t(u16, count, RSI_USB_BUF_SIZE);
+		status = usb_control_msg(dev->usbdev,
+					 usb_rcvctrlpipe(dev->usbdev, 0),
+					 USB_VENDOR_REGISTER_READ,
+					 RSI_USB_REQ_IN,
+					 ((addr & 0xffff0000) >> 16),
+					 (addr & 0xffff), (void *)buf,
+					 transfer, USB_CTRL_GET_TIMEOUT);
+		if (status < 0) {
+			rsi_dbg(ERR_ZONE,
+				"Reg read failed with error code :%d\n",
+				 status);
+			kfree(buf);
+			return status;
+		}
+		memcpy(data, buf, transfer);
+		count -= transfer;
+		data += transfer;
+		addr += transfer;
+	}
+	kfree(buf);
+	return 0;
+}
+
 /**
  * rsi_usb_write_register_multiple() - This function writes multiple bytes of
  *				       information to multiple registers.
-- 
2.7.4
