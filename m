Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33520 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752231AbdFPO5x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Jun 2017 10:57:53 -0400
Received: by mail-pg0-f68.google.com with SMTP id u62so1018194pgb.0
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jun 2017 07:57:52 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [v2 06/20] rsi: USB tx headroom cleanup
Date: Fri, 16 Jun 2017 20:24:27 +0530
Message-Id: <1497624881-2315-7-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170616_165755_847629_3A16DFB9)
In-Reply-To: <1497624881-2315-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1497624881-2315-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karun Eagalapati <karun256@gmail.com>

USB headroom is added while submitting the data to URB as per
firmware's requirement. This logic is moved to rsi_usb_card_write() so
that caller need not worry about it.

Signed-off-by: Karun Eagalapati <karun256@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 41 +++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 1d7bb9d..25f6195 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -29,19 +29,24 @@
  * Return: status: 0 on success, a negative error code on failure.
  */
 static int rsi_usb_card_write(struct rsi_hw *adapter,
-			      void *buf,
+			      u8 *buf,
 			      u16 len,
 			      u8 endpoint)
 {
 	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
 	int status;
-	s32 transfer;
+	u8 *seg = dev->tx_buffer;
+	int transfer;
+	int ep = dev->bulkout_endpoint_addr[endpoint - 1];
 
+	memset(seg, 0, len + RSI_USB_TX_HEAD_ROOM);
+	memcpy(seg + RSI_USB_TX_HEAD_ROOM, buf, len);
+	len += RSI_USB_TX_HEAD_ROOM;
+	transfer = len;
 	status = usb_bulk_msg(dev->usbdev,
-			      usb_sndbulkpipe(dev->usbdev,
-			      dev->bulkout_endpoint_addr[endpoint - 1]),
-			      buf,
-			      len,
+			      usb_sndbulkpipe(dev->usbdev, ep),
+			      (void *)seg,
+			      (int)len,
 			      &transfer,
 			      HZ * 5);
 
@@ -68,23 +73,19 @@ static int rsi_write_multiple(struct rsi_hw *adapter,
 			      u8 *data,
 			      u32 count)
 {
-	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
-	u8 *seg = dev->tx_buffer;
+	struct rsi_91x_usbdev *dev =
+		(struct rsi_91x_usbdev *)adapter->rsi_dev;
 
-	if (dev->write_fail)
-		return 0;
+	if (!adapter)
+		return -ENODEV;
 
-	if (endpoint == MGMT_EP) {
-		memset(seg, 0, RSI_USB_TX_HEAD_ROOM);
-		memcpy(seg + RSI_USB_TX_HEAD_ROOM, data, count);
-	} else {
-		seg = ((u8 *)data - RSI_USB_TX_HEAD_ROOM);
-	}
+	if (endpoint == 0)
+		return -EINVAL;
+
+	if (dev->write_fail)
+		return -ENETDOWN;
 
-	return rsi_usb_card_write(adapter,
-				  seg,
-				  count + RSI_USB_TX_HEAD_ROOM,
-				  endpoint);
+	return rsi_usb_card_write(adapter, data, count, endpoint);
 }
 
 /**
-- 
2.7.4
