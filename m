Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63088 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455Ab3JNS6c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 14:58:32 -0400
Received: by mail-wg0-f44.google.com with SMTP id n12so6533165wgh.23
        for <linux-wireless@vger.kernel.org>; Mon, 14 Oct 2013 11:58:30 -0700 (PDT)
Message-ID: <1381777092.2470.7.camel@canaries32-MCP7A> (sfid-20131014_205835_787911_5F0CC5D1)
Subject: [PATCH] staging: vt6656: main_usb.c correct pDevice->pControlURB
 goto
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 14 Oct 2013 19:58:12 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Correct goto of patch
staging: vt6656: make pControlURB available life time of driver.

Which should free_netdev.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 412a776..5e4a5d0 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -710,7 +710,7 @@ vt6656_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	pDevice->pControlURB = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!pDevice->pControlURB) {
 		DBG_PRT(MSG_LEVEL_ERR, KERN_ERR"Failed to alloc control urb\n");
-		goto err_nomem;
+		goto err_netdev;
 	}
 
 	pDevice->tx_80211 = device_dma0_tx_80211;
-- 
1.8.3.2

