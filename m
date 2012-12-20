Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:59894 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab2LTOYp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 09:24:45 -0500
Subject: [PATCH] rtlwifi: fix incorrect use of usb_alloc_coherent with
 usb_control_msg
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	stable@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>
Date: Thu, 20 Dec 2012 16:24:43 +0200
Message-ID: <20121220142443.16895.45834.stgit@localhost6.localdomain6> (sfid-20121220_152450_235340_472C8CC3)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Incorrect use of usb_alloc_coherent memory as input buffer to usb_control_msg
can cause problems in arch DMA code, for example kernel BUG at
'arch/arm/include/asm/dma-mapping.h:321' on ARM (linux-3.4).

Change _usb_writeN_sync use kmalloc'd buffer instead.

Cc: stable@vger.kernel.org
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/rtlwifi/usb.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index 29f0969..a3312b7 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -210,17 +210,16 @@ static void _usb_writeN_sync(struct rtl_priv *rtlpriv, u32 addr, void *data,
 	u16 index = REALTEK_USB_VENQT_CMD_IDX;
 	int pipe = usb_sndctrlpipe(udev, 0); /* write_out */
 	u8 *buffer;
-	dma_addr_t dma_addr;
 
-	wvalue = (u16)(addr&0x0000ffff);
-	buffer = usb_alloc_coherent(udev, (size_t)len, GFP_ATOMIC, &dma_addr);
+	wvalue = (u16)(addr & 0x0000ffff);
+	buffer = kmalloc(len, GFP_ATOMIC);
 	if (!buffer)
 		return;
 	memcpy(buffer, data, len);
 	usb_control_msg(udev, pipe, request, reqtype, wvalue,
 			index, buffer, len, 50);
 
-	usb_free_coherent(udev, (size_t)len, buffer, dma_addr);
+	kfree(buffer);
 }
 
 static void _rtl_usb_io_handler_init(struct device *dev,

