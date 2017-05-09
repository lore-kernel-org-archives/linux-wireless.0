Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33066 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754049AbdEINcN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 May 2017 09:32:13 -0400
Received: by mail-pg0-f68.google.com with SMTP id s62so15183168pgc.0
        for <linux-wireless@vger.kernel.org>; Tue, 09 May 2017 06:32:12 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [v2 07/11] rsi: Add usb multi-byte read operation
Date: Tue,  9 May 2017 19:00:10 +0530
Message-Id: <1494336614-2107-8-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170509_153218_795822_85A5F915)
In-Reply-To: <1494336614-2107-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1494336614-2107-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

USB multibyte read will be used in the new firmware loading method
for RS9113 chipset.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 40 ++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 634f726..fc52311 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -266,6 +266,46 @@ static int rsi_rx_urb_submit(struct rsi_hw *adapter)
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
+	buf = kzalloc(4096, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	while (count) {
+		transfer = min_t(u16, count, 4096);
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
