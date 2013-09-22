Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:49354 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab3IVStH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Sep 2013 14:49:07 -0400
Received: by mail-wg0-f53.google.com with SMTP id x12so2378637wgg.32
        for <linux-wireless@vger.kernel.org>; Sun, 22 Sep 2013 11:49:05 -0700 (PDT)
Message-ID: <1379875734.6139.18.camel@canaries32-MCP7A> (sfid-20130922_204916_257379_D1F03023)
Subject: [PATCH] staging: vt6656: [BUG] main_usb.c oops on device_close move
 flag earlier.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sun, 22 Sep 2013 19:48:54 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The vt6656 is prone to resetting on the usb bus.

It seems there is a race condition and wpa supplicant is
trying to open the device via iw_handlers before its actually
closed at a stage that the buffers are being removed.

The device is longer considered open when the
buffers are being removed. So move ~DEVICE_FLAGS_OPENED
flag to before freeing the device buffers.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/staging/vt6656/main_usb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 5369717..6f9d281 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1098,6 +1098,8 @@ static int device_close(struct net_device *dev)
     memset(pMgmt->abyCurrBSSID, 0, 6);
     pMgmt->eCurrState = WMAC_STATE_IDLE;
 
+	pDevice->flags &= ~DEVICE_FLAGS_OPENED;
+
     device_free_tx_bufs(pDevice);
     device_free_rx_bufs(pDevice);
     device_free_int_bufs(pDevice);
@@ -1109,7 +1111,6 @@ static int device_close(struct net_device *dev)
     usb_free_urb(pDevice->pInterruptURB);
 
     BSSvClearNodeDBTable(pDevice, 0);
-    pDevice->flags &=(~DEVICE_FLAGS_OPENED);
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "device_close2 \n");
 
-- 
1.8.3.2

