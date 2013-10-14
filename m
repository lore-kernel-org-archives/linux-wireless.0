Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:64842 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177Ab3JNSrH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 14:47:07 -0400
Received: by mail-we0-f174.google.com with SMTP id u56so7403058wes.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Oct 2013 11:47:05 -0700 (PDT)
Message-ID: <1381776412.2470.2.camel@canaries32-MCP7A> (sfid-20131014_204711_860249_529B2ADA)
Subject: [PATCH] staging vt6656: Remove 10 second timer and move to
 BSSvSecondCallBack
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 14 Oct 2013 19:46:52 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove sTimerTxData 10 second timer which triggers PSbSendNullPacket
every 40 seconds when bLinkPass == true.

Move the 40 second timer to the existing BSSvSecondCallBack
one second delayed workqueue and trigger every 40 seconds when
bLinkPass == true.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/bssdb.c    | 21 +++++++++++++----
 drivers/staging/vt6656/device.h   |  7 ++----
 drivers/staging/vt6656/main_usb.c |  2 --
 drivers/staging/vt6656/power.c    |  6 ++---
 drivers/staging/vt6656/usbpipe.c  |  2 --
 drivers/staging/vt6656/wcmd.c     | 47 ---------------------------------------
 drivers/staging/vt6656/wcmd.h     |  2 --
 drivers/staging/vt6656/wmgr.c     |  8 -------
 8 files changed, 21 insertions(+), 74 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index ae0438a..ef654c0 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -57,6 +57,7 @@
 #include "control.h"
 #include "rndis.h"
 #include "iowpa.h"
+#include "power.h"
 
 static int          msglevel                =MSG_LEVEL_INFO;
 //static int          msglevel                =MSG_LEVEL_DEBUG;
@@ -1121,10 +1122,22 @@ else {
         }
     }
 
-    if (pDevice->bLinkPass == true) {
-        if (netif_queue_stopped(pDevice->dev))
-            netif_wake_queue(pDevice->dev);
-    }
+	if (pDevice->bLinkPass == true) {
+		if (pMgmt->eAuthenMode < WMAC_AUTH_WPA ||
+			pDevice->fWPA_Authened == true) {
+			if (++pDevice->tx_data_time_out > 40) {
+				pDevice->tx_trigger = true;
+
+				PSbSendNullPacket(pDevice);
+
+				pDevice->tx_trigger = false;
+				pDevice->tx_data_time_out = 0;
+			}
+		}
+
+		if (netif_queue_stopped(pDevice->dev))
+			netif_wake_queue(pDevice->dev);
+	}
 
     spin_unlock_irq(&pDevice->lock);
 
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index fa1cefb..95b181d 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -711,11 +711,8 @@ struct vnt_private {
 	/* One second callback */
 	struct delayed_work second_callback_work;
 
-	struct timer_list sTimerTxData;
-	unsigned long nTxDataTimeCout;
-	int fTxDataInSleep;
-	int IsTxDataTrigger;
-
+	u8 tx_data_time_out;
+	bool tx_trigger;
 	int fWPA_Authened; /*is WPA/WPA-PSK or WPA2/WPA2-PSK authen?? */
 	u8 byReAssocCount;
 	u8 byLinkWaitCount;
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 0de2156..412a776 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1081,8 +1081,6 @@ static int device_close(struct net_device *dev)
 	cancel_delayed_work_sync(&pDevice->run_command_work);
 	cancel_delayed_work_sync(&pDevice->second_callback_work);
 
-    del_timer(&pDevice->sTimerTxData);
-
     if (pDevice->bDiversityRegCtlON) {
         del_timer(&pDevice->TimerSQ3Tmax1);
         del_timer(&pDevice->TimerSQ3Tmax2);
diff --git a/drivers/staging/vt6656/power.c b/drivers/staging/vt6656/power.c
index edc8975..6334315 100644
--- a/drivers/staging/vt6656/power.c
+++ b/drivers/staging/vt6656/power.c
@@ -257,10 +257,8 @@ int PSbSendNullPacket(struct vnt_private *pDevice)
 	if (pDevice->bLinkPass == false)
 		return false;
 
-	if ((pDevice->bEnablePSMode == false) &&
-		(pDevice->fTxDataInSleep == false)) {
-			return false;
-	}
+	if (pDevice->bEnablePSMode == false && pDevice->tx_trigger == false)
+		return false;
 
 	memset(pMgmt->pbyPSPacketPool, 0, sizeof(struct vnt_tx_mgmt)
 		+ WLAN_NULLDATA_FR_MAXLEN);
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 37bcb18..5fc18ad 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -662,8 +662,6 @@ static void s_nsBulkOutIoCompleteWrite(struct urb *urb)
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Write %d bytes\n",(int)ulBufLen);
         pDevice->ulBulkOutBytesWrite += ulBufLen;
         pDevice->ulBulkOutContCRCError = 0;
-	pDevice->nTxDataTimeCout = 0;
-
     } else {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"BULK Out failed %d\n", status);
         pDevice->ulBulkOutError++;
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index debb87a..4f45a7f 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -654,22 +654,6 @@ void vRunCommand(struct work_struct *work)
                     netif_wake_queue(pDevice->dev);
                 }
 
-		 if(pDevice->IsTxDataTrigger != false)   {    //TxDataTimer is not triggered at the first time
-                     // printk("Re-initial TxDataTimer****\n");
-		    del_timer(&pDevice->sTimerTxData);
-                      init_timer(&pDevice->sTimerTxData);
-			pDevice->sTimerTxData.data = (unsigned long) pDevice;
-                      pDevice->sTimerTxData.function = (TimerFunction)BSSvSecondTxData;
-                      pDevice->sTimerTxData.expires = RUN_AT(10*HZ);      //10s callback
-                      pDevice->fTxDataInSleep = false;
-                      pDevice->nTxDataTimeCout = 0;
-		 }
-		 else {
-		   // printk("mike:-->First time trigger TimerTxData InSleep\n");
-		 }
-		pDevice->IsTxDataTrigger = true;
-                add_timer(&pDevice->sTimerTxData);
-
             }
 	   else if(pMgmt->eCurrState < WMAC_STATE_ASSOCPENDING) {
                printk("WLAN_ASSOCIATE_WAIT:Association Fail???\n");
@@ -681,7 +665,6 @@ void vRunCommand(struct work_struct *work)
 	       vCommandTimerWait((void *) pDevice, ASSOCIATE_TIMEOUT/2);
 	       return;
 	   }
-	          pDevice->byLinkWaitCount = 0;
 
             s_bCommandComplete(pDevice);
             break;
@@ -1159,33 +1142,3 @@ void vResetCommandTimer(struct vnt_private *pDevice)
 	pDevice->bCmdRunning = false;
 	pDevice->bCmdClear = false;
 }
-
-void BSSvSecondTxData(struct vnt_private *pDevice)
-{
-	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
-
-	pDevice->nTxDataTimeCout++;
-
-	if (pDevice->nTxDataTimeCout < 4) {   //don't tx data if timer less than 40s
-		// printk("mike:%s-->no data Tx not exceed the desired Time as %d\n",__FUNCTION__,
-		//  	(int)pDevice->nTxDataTimeCout);
-		pDevice->sTimerTxData.expires = RUN_AT(10 * HZ);      //10s callback
-		add_timer(&pDevice->sTimerTxData);
-		return;
-	}
-
-	spin_lock_irq(&pDevice->lock);
-	//is wap_supplicant running successful OR only open && sharekey mode!
-	if (((pDevice->bLinkPass == true) &&
-		(pMgmt->eAuthenMode < WMAC_AUTH_WPA)) ||  //open && sharekey linking
-		(pDevice->fWPA_Authened == true)) {   //wpa linking
-		//   printk("mike:%s-->InSleep Tx Data Procedure\n",__FUNCTION__);
-		pDevice->fTxDataInSleep = true;
-		PSbSendNullPacket(pDevice);      //send null packet
-		pDevice->fTxDataInSleep = false;
-	}
-	spin_unlock_irq(&pDevice->lock);
-
-	pDevice->sTimerTxData.expires = RUN_AT(10 * HZ);      //10s callback
-	add_timer(&pDevice->sTimerTxData);
-}
diff --git a/drivers/staging/vt6656/wcmd.h b/drivers/staging/vt6656/wcmd.h
index cd12558..caf2684 100644
--- a/drivers/staging/vt6656/wcmd.h
+++ b/drivers/staging/vt6656/wcmd.h
@@ -107,6 +107,4 @@ int bScheduleCommand(struct vnt_private *, CMD_CODE eCommand, u8 *pbyItem0);
 
 void vRunCommand(struct work_struct *work);
 
-void BSSvSecondTxData(struct vnt_private *);
-
 #endif /* __WCMD_H__ */
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index 5a6a5ba..6300a56 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -213,14 +213,6 @@ void vMgrObjectInit(struct vnt_private *pDevice)
     pMgmt->wIBSSBeaconPeriod = DEFAULT_IBSS_BI;
     BSSvClearBSSList((void *) pDevice, false);
 
-    init_timer(&pDevice->sTimerTxData);
-    pDevice->sTimerTxData.data = (unsigned long)pDevice;
-    pDevice->sTimerTxData.function = (TimerFunction)BSSvSecondTxData;
-    pDevice->sTimerTxData.expires = RUN_AT(10*HZ);      //10s callback
-    pDevice->fTxDataInSleep = false;
-    pDevice->IsTxDataTrigger = false;
-    pDevice->nTxDataTimeCout = 0;
-
     pDevice->cbFreeCmdQueue = CMD_Q_SIZE;
     pDevice->uCmdDequeueIdx = 0;
     pDevice->uCmdEnqueueIdx = 0;
-- 
1.8.3.2

