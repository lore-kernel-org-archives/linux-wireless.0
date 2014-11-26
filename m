Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135AbaKZOcT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2014 09:32:19 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com,
	Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 1/4] rt2x00: use timeout in rt2x00usb_vendor_request
Date: Wed, 26 Nov 2014 15:29:13 +0100
Message-Id: <1417012156-26197-1-git-send-email-sgruszka@redhat.com> (sfid-20141126_153235_292928_FD104C5E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use provided timeout value in rt2x00usb_vendor_request() instead
of iterating REGISTER_BUSY_COUNT times.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2x00usb.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index dc85d3e..258e2a8 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -42,31 +42,27 @@ int rt2x00usb_vendor_request(struct rt2x00_dev *rt2x00dev,
 {
 	struct usb_device *usb_dev = to_usb_device_intf(rt2x00dev->dev);
 	int status;
-	unsigned int i;
 	unsigned int pipe =
 	    (requesttype == USB_VENDOR_REQUEST_IN) ?
 	    usb_rcvctrlpipe(usb_dev, 0) : usb_sndctrlpipe(usb_dev, 0);
+	unsigned long expire = jiffies + msecs_to_jiffies(timeout);
 
 	if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
 		return -ENODEV;
 
-	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
+	do {
 		status = usb_control_msg(usb_dev, pipe, request, requesttype,
 					 value, offset, buffer, buffer_length,
-					 timeout);
+					 timeout / 2);
 		if (status >= 0)
 			return 0;
 
-		/*
-		 * Check for errors
-		 * -ENODEV: Device has disappeared, no point continuing.
-		 * All other errors: Try again.
-		 */
-		else if (status == -ENODEV) {
+		if (status == -ENODEV) {
+			/* Device has disappeared. */
 			clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
 			break;
 		}
-	}
+	} while (time_before(jiffies, expire));
 
 	/* If the port is powered down, we get a -EPROTO error, and this
 	 * leads to a endless loop. So just say that the device is gone.
-- 
1.8.3.1

