Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:33451 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab3JITTG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Oct 2013 15:19:06 -0400
Received: by mail-wg0-f46.google.com with SMTP id k14so1343720wgh.25
        for <linux-wireless@vger.kernel.org>; Wed, 09 Oct 2013 12:19:05 -0700 (PDT)
Message-ID: <1381346334.5568.6.camel@canaries64-MCP7A> (sfid-20131009_211911_343734_F6A1962C)
Subject: [PATCH] staging: vt6656: make pControlURB available life time of
 driver.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 09 Oct 2013 20:18:54 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no need remove and add the control urb in device open/close.

Move to the probe and disconnect. This make the USB control in/out
functions always available to driver.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index e5add18..0de2156 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -707,6 +707,12 @@ vt6656_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	INIT_WORK(&pDevice->read_work_item, RXvWorkItem);
 	INIT_WORK(&pDevice->rx_mng_work_item, RXvMngWorkItem);
 
+	pDevice->pControlURB = usb_alloc_urb(0, GFP_ATOMIC);
+	if (!pDevice->pControlURB) {
+		DBG_PRT(MSG_LEVEL_ERR, KERN_ERR"Failed to alloc control urb\n");
+		goto err_nomem;
+	}
+
 	pDevice->tx_80211 = device_dma0_tx_80211;
 	pDevice->vnt_mgmt.pAdapter = (void *) pDevice;
 
@@ -853,23 +859,15 @@ static bool device_alloc_bufs(struct vnt_private *pDevice)
         pRCB++;
     }
 
-	pDevice->pControlURB = usb_alloc_urb(0, GFP_ATOMIC);
-	if (pDevice->pControlURB == NULL) {
-	    DBG_PRT(MSG_LEVEL_ERR,KERN_ERR"Failed to alloc control urb\n");
-	    goto free_rx_tx;
-	}
-
 	pDevice->pInterruptURB = usb_alloc_urb(0, GFP_ATOMIC);
 	if (pDevice->pInterruptURB == NULL) {
 	    DBG_PRT(MSG_LEVEL_ERR,KERN_ERR"Failed to alloc int urb\n");
-	    usb_free_urb(pDevice->pControlURB);
 	    goto free_rx_tx;
 	}
 
     pDevice->intBuf.pDataBuf = kmalloc(MAX_INTERRUPT_SIZE, GFP_KERNEL);
 	if (pDevice->intBuf.pDataBuf == NULL) {
 	    DBG_PRT(MSG_LEVEL_ERR,KERN_ERR"Failed to alloc int buf\n");
-	    usb_free_urb(pDevice->pControlURB);
 	    usb_free_urb(pDevice->pInterruptURB);
 	    goto free_rx_tx;
 	}
@@ -1040,9 +1038,7 @@ free_rx_tx:
     device_free_rx_bufs(pDevice);
     device_free_tx_bufs(pDevice);
     device_free_int_bufs(pDevice);
-	usb_kill_urb(pDevice->pControlURB);
 	usb_kill_urb(pDevice->pInterruptURB);
-    usb_free_urb(pDevice->pControlURB);
     usb_free_urb(pDevice->pInterruptURB);
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "device_open fail.. \n");
@@ -1113,9 +1109,7 @@ static int device_close(struct net_device *dev)
     device_free_int_bufs(pDevice);
     device_free_frag_bufs(pDevice);
 
-	usb_kill_urb(pDevice->pControlURB);
 	usb_kill_urb(pDevice->pInterruptURB);
-    usb_free_urb(pDevice->pControlURB);
     usb_free_urb(pDevice->pInterruptURB);
 
     BSSvClearNodeDBTable(pDevice, 0);
@@ -1139,9 +1133,12 @@ static void vt6656_disconnect(struct usb_interface *intf)
 
 	if (device->dev) {
 		unregister_netdev(device->dev);
+
+		usb_kill_urb(device->pControlURB);
+		usb_free_urb(device->pControlURB);
+
 		free_netdev(device->dev);
 	}
-
 }
 
 static int device_dma0_tx_80211(struct sk_buff *skb, struct net_device *dev)
-- 
1.8.3.2

