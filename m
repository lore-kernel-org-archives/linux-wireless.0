Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:51236 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbbCLOgB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 10:36:01 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 2/3] rt2x00usb: check USB's request error code in rt2800usb_autorun_detect()
Date: Thu, 12 Mar 2015 15:35:45 +0100
Message-Id: <1426170946-13918-2-git-send-email-bigeasy@linutronix.de> (sfid-20150312_153606_371625_A42B680F)
In-Reply-To: <1426170946-13918-1-git-send-email-bigeasy@linutronix.de>
References: <1426170946-13918-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2800usb_autorun_detect() blindly assumes assumes that it worked while
it could have failed. Check the error code here.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/wireless/rt2x00/rt2800usb.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 8444313eabe2..e692e5fe4e01 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -233,6 +233,7 @@ static int rt2800usb_autorun_detect(struct rt2x00_dev *rt2x00dev)
 {
 	__le32 *reg;
 	u32 fw_mode;
+	int ret;
 
 	reg = kmalloc(sizeof(*reg), GFP_KERNEL);
 	if (reg == NULL)
@@ -242,11 +243,14 @@ static int rt2800usb_autorun_detect(struct rt2x00_dev *rt2x00dev)
 	 * magic value USB_MODE_AUTORUN (0x11) to the device, thus the
 	 * returned value would be invalid.
 	 */
-	rt2x00usb_vendor_request(rt2x00dev, USB_DEVICE_MODE,
-				 USB_VENDOR_REQUEST_IN, 0, USB_MODE_AUTORUN,
-				 reg, sizeof(*reg), REGISTER_TIMEOUT_FIRMWARE);
+	ret = rt2x00usb_vendor_request(rt2x00dev, USB_DEVICE_MODE,
+				       USB_VENDOR_REQUEST_IN, 0,
+				       USB_MODE_AUTORUN, reg, sizeof(*reg),
+				       REGISTER_TIMEOUT_FIRMWARE);
 	fw_mode = le32_to_cpu(*reg);
 	kfree(reg);
+	if (ret < 0)
+		return ret;
 
 	if ((fw_mode & 0x00000003) == 2)
 		return 1;
-- 
2.1.4

