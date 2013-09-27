Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:40926 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab3I0P4A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Sep 2013 11:56:00 -0400
Received: by mail-wg0-f52.google.com with SMTP id m15so2906189wgh.31
        for <linux-wireless@vger.kernel.org>; Fri, 27 Sep 2013 08:55:59 -0700 (PDT)
Message-ID: <1380297345.2235.34.camel@canaries64-MCP7A> (sfid-20130927_175604_551264_51685AD2)
Subject: [PATCH 4/4] staging: vt6656: covert RXvMngWorkItem to work queue
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Fri, 27 Sep 2013 16:55:45 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tasklet to workqueue.
RxMngWorkItem -> rx_mng_work_item

Reduce atomic area of driver and dependency on system timer.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   | 2 +-
 drivers/staging/vt6656/dpc.c      | 6 ++++--
 drivers/staging/vt6656/dpc.h      | 2 +-
 drivers/staging/vt6656/main_usb.c | 5 +++--
 4 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 7e32a40..fa1cefb 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -385,7 +385,7 @@ struct vnt_private {
 	struct tasklet_struct CmdWorkItem;
 	struct tasklet_struct EventWorkItem;
 	struct work_struct read_work_item;
-	struct tasklet_struct RxMngWorkItem;
+	struct work_struct rx_mng_work_item;
 
 	u32 rx_buf_sz;
 	int multicast_limit;
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index 1b0e6a7..82d7c1d 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -559,7 +559,7 @@ int RXbBulkInProcessData(struct vnt_private *pDevice, struct vnt_rcb *pRCB,
             }
             if (pDevice->bIsRxMngWorkItemQueued == false) {
                 pDevice->bIsRxMngWorkItemQueued = true;
-                tasklet_schedule(&pDevice->RxMngWorkItem);
+		schedule_work(&pDevice->rx_mng_work_item);
             }
 
         }
@@ -1390,8 +1390,10 @@ void RXvFreeRCB(struct vnt_rcb *pRCB, int bReAllocSkb)
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"<----RXFreeRCB %d %d\n",pDevice->NumRecvFreeList, pDevice->NumRecvMngList);
 }
 
-void RXvMngWorkItem(struct vnt_private *pDevice)
+void RXvMngWorkItem(struct work_struct *work)
 {
+	struct vnt_private *pDevice =
+		container_of(work, struct vnt_private, rx_mng_work_item);
 	struct vnt_rcb *pRCB = NULL;
 	struct vnt_rx_mgmt *pRxPacket;
 	int bReAllocSkb = false;
diff --git a/drivers/staging/vt6656/dpc.h b/drivers/staging/vt6656/dpc.h
index aa81bed..8d52434 100644
--- a/drivers/staging/vt6656/dpc.h
+++ b/drivers/staging/vt6656/dpc.h
@@ -34,7 +34,7 @@
 
 void RXvWorkItem(struct work_struct *work);
 
-void RXvMngWorkItem(void *Context);
+void RXvMngWorkItem(struct work_struct *work);
 
 void RXvFreeRCB(struct vnt_rcb *pRCB, int bReAllocSkb);
 
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 948e723..992b611 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -705,6 +705,7 @@ vt6656_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	INIT_DELAYED_WORK(&pDevice->run_command_work, vRunCommand);
 	INIT_DELAYED_WORK(&pDevice->second_callback_work, BSSvSecondCallBack);
 	INIT_WORK(&pDevice->read_work_item, RXvWorkItem);
+	INIT_WORK(&pDevice->rx_mng_work_item, RXvMngWorkItem);
 
 	pDevice->tx_80211 = device_dma0_tx_80211;
 	pDevice->vnt_mgmt.pAdapter = (void *) pDevice;
@@ -984,7 +985,7 @@ static int  device_open(struct net_device *dev)
     }
 
     vMgrObjectInit(pDevice);
-    tasklet_init(&pDevice->RxMngWorkItem, (void *)RXvMngWorkItem, (unsigned long)pDevice);
+
     tasklet_init(&pDevice->EventWorkItem, (void *)INTvWorkItem, (unsigned long)pDevice);
 
 	schedule_delayed_work(&pDevice->second_callback_work, HZ);
@@ -1091,8 +1092,8 @@ static int device_close(struct net_device *dev)
         del_timer(&pDevice->TimerSQ3Tmax2);
         del_timer(&pDevice->TimerSQ3Tmax3);
     }
-    tasklet_kill(&pDevice->RxMngWorkItem);
 
+	cancel_work_sync(&pDevice->rx_mng_work_item);
 	cancel_work_sync(&pDevice->read_work_item);
 
     tasklet_kill(&pDevice->EventWorkItem);
-- 
1.8.3.2

