Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:60387 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab3I0PyC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Sep 2013 11:54:02 -0400
Received: by mail-wi0-f180.google.com with SMTP id hj3so1057009wib.1
        for <linux-wireless@vger.kernel.org>; Fri, 27 Sep 2013 08:54:00 -0700 (PDT)
Message-ID: <1380297235.2235.33.camel@canaries64-MCP7A> (sfid-20130927_175406_380335_82BA1037)
Subject: [PATCH 3/4] staging: vt6656: convert RXvWorkItem to work queue
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Fri, 27 Sep 2013 16:53:55 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tasklet to workqueue.
ReadWorkItem -> read_work_item

Reduce atomic area of driver.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   | 2 +-
 drivers/staging/vt6656/dpc.c      | 6 ++++--
 drivers/staging/vt6656/dpc.h      | 2 +-
 drivers/staging/vt6656/main_usb.c | 8 +++++---
 4 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 6052f4c..7e32a40 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -384,7 +384,7 @@ struct vnt_private {
 
 	struct tasklet_struct CmdWorkItem;
 	struct tasklet_struct EventWorkItem;
-	struct tasklet_struct ReadWorkItem;
+	struct work_struct read_work_item;
 	struct tasklet_struct RxMngWorkItem;
 
 	u32 rx_buf_sz;
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index 29381b4..1b0e6a7 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -1332,8 +1332,10 @@ static int s_bAPModeRxData(struct vnt_private *pDevice, struct sk_buff *skb,
     return true;
 }
 
-void RXvWorkItem(struct vnt_private *pDevice)
+void RXvWorkItem(struct work_struct *work)
 {
+	struct vnt_private *pDevice =
+		container_of(work, struct vnt_private, read_work_item);
 	int ntStatus;
 	struct vnt_rcb *pRCB = NULL;
 
@@ -1383,7 +1385,7 @@ void RXvFreeRCB(struct vnt_rcb *pRCB, int bReAllocSkb)
         (pDevice->bIsRxWorkItemQueued == false) ) {
 
         pDevice->bIsRxWorkItemQueued = true;
-        tasklet_schedule(&pDevice->ReadWorkItem);
+	schedule_work(&pDevice->read_work_item);
     }
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"<----RXFreeRCB %d %d\n",pDevice->NumRecvFreeList, pDevice->NumRecvMngList);
 }
diff --git a/drivers/staging/vt6656/dpc.h b/drivers/staging/vt6656/dpc.h
index 95388dc..aa81bed 100644
--- a/drivers/staging/vt6656/dpc.h
+++ b/drivers/staging/vt6656/dpc.h
@@ -32,7 +32,7 @@
 #include "device.h"
 #include "wcmd.h"
 
-void RXvWorkItem(void *Context);
+void RXvWorkItem(struct work_struct *work);
 
 void RXvMngWorkItem(void *Context);
 
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index c4eb092..948e723 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -704,6 +704,7 @@ vt6656_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	spin_lock_init(&pDevice->lock);
 	INIT_DELAYED_WORK(&pDevice->run_command_work, vRunCommand);
 	INIT_DELAYED_WORK(&pDevice->second_callback_work, BSSvSecondCallBack);
+	INIT_WORK(&pDevice->read_work_item, RXvWorkItem);
 
 	pDevice->tx_80211 = device_dma0_tx_80211;
 	pDevice->vnt_mgmt.pAdapter = (void *) pDevice;
@@ -984,7 +985,6 @@ static int  device_open(struct net_device *dev)
 
     vMgrObjectInit(pDevice);
     tasklet_init(&pDevice->RxMngWorkItem, (void *)RXvMngWorkItem, (unsigned long)pDevice);
-    tasklet_init(&pDevice->ReadWorkItem, (void *)RXvWorkItem, (unsigned long)pDevice);
     tasklet_init(&pDevice->EventWorkItem, (void *)INTvWorkItem, (unsigned long)pDevice);
 
 	schedule_delayed_work(&pDevice->second_callback_work, HZ);
@@ -1004,7 +1004,7 @@ static int  device_open(struct net_device *dev)
      pDevice->bWPASuppWextEnabled = false;
     pDevice->byReAssocCount = 0;
 
-    RXvWorkItem(pDevice);
+	schedule_work(&pDevice->read_work_item);
     INTvWorkItem(pDevice);
 
     /* if WEP key already set by iwconfig but device not yet open */
@@ -1092,7 +1092,9 @@ static int device_close(struct net_device *dev)
         del_timer(&pDevice->TimerSQ3Tmax3);
     }
     tasklet_kill(&pDevice->RxMngWorkItem);
-    tasklet_kill(&pDevice->ReadWorkItem);
+
+	cancel_work_sync(&pDevice->read_work_item);
+
     tasklet_kill(&pDevice->EventWorkItem);
 
    pDevice->bRoaming = false;
-- 
1.8.3.2

