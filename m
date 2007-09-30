Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:34592 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbXI3Skz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2007 14:40:55 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 21/26] at76_usb: Remove incorrect firmware version check
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 30 Sep 2007 14:40:53 -0400
Message-ID: <20070930184053.23921.98224.stgit@tt.roinet.com>
In-Reply-To: <20070930183409.23921.97762.stgit@tt.roinet.com>
References: <20070930183409.23921.97762.stgit@tt.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The major version of the firmware reported by the device can mismatch
the version of the originally loaded firmware, as it is the case for
Belkin F5D6050.

Remove this check and assume the firmware to be working as long that the
external firmware download didn't fail and the firmware version could be
read at all.

Reported by Corey Pappas <pappascd@gmail.com>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 6dc8e23..ce74e03 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -5454,19 +5454,6 @@ static int at76_probe(struct usb_interface *interface,
 			       ": error %d getting firmware version\n", ret);
 			goto error;
 		}
-
-		/* Major and minor version must match */
-		if (fwv.major != fwe->fw_version.major
-		    || fwv.minor != fwe->fw_version.minor) {
-			printk(KERN_ERR DRIVER_NAME
-			       ": wrong firmware version, loaded %d.%d.%d-%d, "
-			       "read back %d.%d.%d-%d\n",
-			       fwe->fw_version.major, fwe->fw_version.minor,
-			       fwe->fw_version.patch, fwe->fw_version.build,
-			       fwv.major, fwv.minor, fwv.patch, fwv.build);
-			ret = -EBUSY;
-			goto error;
-		}
 	}
 
 	priv = at76_alloc_new_device(udev);
