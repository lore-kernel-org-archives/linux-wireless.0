Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:37276 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882AbaEIQRu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2014 12:17:50 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] orinoco_usb: Fix broken firmware load error checking
Date: Fri, 9 May 2014 18:10:34 +0200
Cc: Kumar Amit Mehta <gmate.amit@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201405091810.34444.linux@rainbow-software.org> (sfid-20140509_181752_960842_31069C3D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The check of ezusb_firmware_download() return value (added by commit
488ec878034eccb852267b0e27ce9d511f75c587) is broken because
ezusb_firmware_download() returns 1 on success.
This causes the driver not to work with the following error:
orinoco_usb: probe of 3-3:1.0 failed with error -14

Check the return value only for negative values.

This fix should be applied to -stable kernels too.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/net/wireless/orinoco/orinoco_usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/orinoco/orinoco_usb.c b/drivers/net/wireless/orinoco/orinoco_usb.c
index f9805c9..1cbb783 100644
--- a/drivers/net/wireless/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/orinoco/orinoco_usb.c
@@ -1687,7 +1687,7 @@ static int ezusb_probe(struct usb_interface *interface,
 		firmware.code = fw_entry->data;
 	}
 	if (firmware.size && firmware.code) {
-		if (ezusb_firmware_download(upriv, &firmware))
+		if (ezusb_firmware_download(upriv, &firmware) < 0)
 			goto error;
 	} else {
 		err("No firmware to download");
-- 
Ondrej Zary
