Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:52550 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758418AbZAPTYe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 14:24:34 -0500
From: Christian Lamparter <chunkeey@web.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH] p54usb: fix conflict with recent usb changes
Date: Fri, 16 Jan 2009 20:24:31 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200901162024.31636.chunkeey@web.de> (sfid-20090116_202440_377306_93A894C0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A recent change in the usb core "USB: change interface to usb_lock_device_for_reset()" 
conflicts with "p54usb: utilize usb_reset_device for 3887".

Sadly, we have to call usb_reset_device before we can upload the firmware on 3887.
Unless someone figures out how to reliably stop the 3887 so the hardware is still usable
next time we want to start it.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
John,

I guess this patch should be in the next wireless-2.6 pull.
And it would be nice, if you can put "[PATCH] p54: fix p54_set_key's return code" in there too. 
---
diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 4d54826..3bfee58 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -435,14 +435,16 @@ static const char p54u_firmware_upload_3887[] = "<\r";
 static int p54u_device_reset_3887(struct ieee80211_hw *dev)
 {
 	struct p54u_priv *priv = dev->priv;
-	int ret, lock;
+	int ret, lock = (priv->intf->condition != USB_INTERFACE_BINDING);
 	u8 buf[4];
 
-	ret = lock = usb_lock_device_for_reset(priv->udev, priv->intf);
-	if (ret < 0) {
-		dev_err(&priv->udev->dev, "(p54usb) unable to lock device for "
-			"reset: %d\n", ret);
-		return ret;
+	if (lock) {
+		ret = usb_lock_device_for_reset(priv->udev, priv->intf);
+		if (ret < 0) {
+			dev_err(&priv->udev->dev, "(p54usb) unable to lock "
+				" device for reset: %d\n", ret);
+			return ret;
+		}
 	}
 
 	ret = usb_reset_device(priv->udev);
