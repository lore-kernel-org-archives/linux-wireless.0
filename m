Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:48069 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaBQVYv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 16:24:51 -0500
Received: by mail-wi0-f177.google.com with SMTP id e4so2842861wiv.16
        for <linux-wireless@vger.kernel.org>; Mon, 17 Feb 2014 13:24:49 -0800 (PST)
Message-ID: <1392672273.11154.13.camel@canaries64-MCP7A> (sfid-20140217_222455_115557_1F6B1AE5)
Subject: [PATCH 4/5] staging: vt6656: Remove variable fKillEventPollingThread
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 17 Feb 2014 21:24:33 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We already kill the urb and since patch
s_nsInterruptUsbIoCompleteRead add urb status returns.
have error handling

There is no need for this variable.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

Conflicts:
	drivers/staging/vt6656/usbpipe.c
---
 drivers/staging/vt6656/device.h   | 1 -
 drivers/staging/vt6656/int.c      | 5 +++--
 drivers/staging/vt6656/main_usb.c | 2 --
 drivers/staging/vt6656/usbpipe.c  | 4 +---
 4 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index ec20b14..e5f0be3 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -421,7 +421,6 @@ struct vnt_private {
 
 	/* Variables to track resources for the Interrupt In Pipe */
 	INT_BUFFER intBuf;
-	int fKillEventPollingThread;
 	int bEventAvailable;
 
 	/* default config from file by user setting */
diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index ec135b4..34c4528 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -70,8 +70,9 @@ void INTvWorkItem(struct vnt_private *pDevice)
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->Interrupt Polling Thread\n");
 
 	spin_lock_irq(&pDevice->lock);
-	if (pDevice->fKillEventPollingThread != true)
-		ntStatus = PIPEnsInterruptRead(pDevice);
+
+	ntStatus = PIPEnsInterruptRead(pDevice);
+
 	spin_unlock_irq(&pDevice->lock);
 }
 
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 4f913d3..bea1ad9 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1000,7 +1000,6 @@ static int  device_open(struct net_device *dev)
     pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
 
     pDevice->bIsRxWorkItemQueued = true;
-    pDevice->fKillEventPollingThread = false;
     pDevice->bEventAvailable = false;
 
    pDevice->bWPADEVUp = false;
@@ -1084,7 +1083,6 @@ static int device_close(struct net_device *dev)
     MP_SET_FLAG(pDevice, fMP_DISCONNECTED);
     MP_CLEAR_FLAG(pDevice, fMP_POST_WRITES);
     MP_CLEAR_FLAG(pDevice, fMP_POST_READS);
-    pDevice->fKillEventPollingThread = true;
 
 	cancel_delayed_work_sync(&pDevice->run_command_work);
 	cancel_delayed_work_sync(&pDevice->second_callback_work);
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 1ab1bbc..3721937 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -393,7 +393,6 @@ static void s_nsInterruptUsbIoCompleteRead(struct urb *urb)
 
 //        if (ntStatus == STATUS_NOT_CONNECTED )
 //        {
-            pDevice->fKillEventPollingThread = true;
 //        }
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"IntUSBIoCompleteControl STATUS = %d\n", ntStatus );
     } else {
@@ -403,7 +402,6 @@ static void s_nsInterruptUsbIoCompleteRead(struct urb *urb)
 	    INTnsProcessData(pDevice);
     }
 
-    if (pDevice->fKillEventPollingThread != true) {
 	ntStatus = usb_submit_urb(pDevice->pInterruptURB, GFP_ATOMIC);
 	if (ntStatus) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
@@ -411,7 +409,7 @@ static void s_nsInterruptUsbIoCompleteRead(struct urb *urb)
 	} else {
 		pDevice->intBuf.bInUse = true;
 	}
-    }
+
     //
     // We return STATUS_MORE_PROCESSING_REQUIRED so that the completion
     // routine (IofCompleteRequest) will stop working on the irp.
-- 
1.9.rc1

