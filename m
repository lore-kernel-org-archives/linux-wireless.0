Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:35942 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab3I0Psd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Sep 2013 11:48:33 -0400
Received: by mail-wi0-f176.google.com with SMTP id cb5so1040736wib.9
        for <linux-wireless@vger.kernel.org>; Fri, 27 Sep 2013 08:48:32 -0700 (PDT)
Message-ID: <1380296894.2235.30.camel@canaries64-MCP7A> (sfid-20130927_174836_935250_7E384A05)
Subject: [PATCH 1/4] staging: vt6656: device.h convert sTimerCommand to
 delayed_work
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Fri, 27 Sep 2013 16:48:14 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

timer to delay workqueue.
sTimerCommand -> run_command_work

sTimerCommand is very heavy on the system timer.

Improves over performance of driver and reduce the atomic
area of driver.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   |  2 +-
 drivers/staging/vt6656/main_usb.c |  5 ++++-
 drivers/staging/vt6656/wcmd.c     | 24 ++++++------------------
 drivers/staging/vt6656/wcmd.h     |  9 +--------
 drivers/staging/vt6656/wmgr.c     | 13 ++++---------
 5 files changed, 16 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 8e39634..63806e8 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -707,7 +707,7 @@ struct vnt_private {
 	u8 byBBCR09;
 
 	/* command timer */
-	struct timer_list sTimerCommand;
+	struct delayed_work run_command_work;
 
 	struct timer_list sTimerTxData;
 	unsigned long nTxDataTimeCout;
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 5369717..41d1e79 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -702,6 +702,7 @@ vt6656_probe(struct usb_interface *intf, const struct usb_device_id *id)
 
 	device_set_options(pDevice);
 	spin_lock_init(&pDevice->lock);
+	INIT_DELAYED_WORK(&pDevice->run_command_work, vRunCommand);
 
 	pDevice->tx_80211 = device_dma0_tx_80211;
 	pDevice->vnt_mgmt.pAdapter = (void *) pDevice;
@@ -1076,7 +1077,9 @@ static int device_close(struct net_device *dev)
     MP_CLEAR_FLAG(pDevice, fMP_POST_WRITES);
     MP_CLEAR_FLAG(pDevice, fMP_POST_READS);
     pDevice->fKillEventPollingThread = true;
-    del_timer(&pDevice->sTimerCommand);
+
+	cancel_delayed_work_sync(&pDevice->run_command_work);
+
     del_timer(&pMgmt->sTimerSecondCallback);
 
     del_timer(&pDevice->sTimerTxData);
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 0013cb7..3b9bfcb 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -268,20 +268,14 @@ struct vnt_tx_mgmt *s_MgrMakeProbeRequest(struct vnt_private *pDevice,
 
 void vCommandTimerWait(struct vnt_private *pDevice, unsigned long MSecond)
 {
-
-	init_timer(&pDevice->sTimerCommand);
-
-	pDevice->sTimerCommand.data = (unsigned long)pDevice;
-	pDevice->sTimerCommand.function = (TimerFunction)vRunCommand;
-	pDevice->sTimerCommand.expires = RUN_AT((MSecond * HZ) / 1000);
-
-	add_timer(&pDevice->sTimerCommand);
-
-	return;
+	schedule_delayed_work(&pDevice->run_command_work,
+						msecs_to_jiffies(MSecond));
 }
 
-void vRunCommand(struct vnt_private *pDevice)
+void vRunCommand(struct work_struct *work)
 {
+	struct vnt_private *pDevice =
+		container_of(work, struct vnt_private, run_command_work.work);
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	PWLAN_IE_SSID pItemSSID;
 	PWLAN_IE_SSID pItemSSIDCurr;
@@ -1156,14 +1150,8 @@ static int s_bClearBSSID_SCAN(struct vnt_private *pDevice)
 //mike add:reset command timer
 void vResetCommandTimer(struct vnt_private *pDevice)
 {
+	cancel_delayed_work_sync(&pDevice->run_command_work);
 
-	//delete timer
-	del_timer(&pDevice->sTimerCommand);
-	//init timer
-	init_timer(&pDevice->sTimerCommand);
-	pDevice->sTimerCommand.data = (unsigned long)pDevice;
-	pDevice->sTimerCommand.function = (TimerFunction)vRunCommand;
-	pDevice->sTimerCommand.expires = RUN_AT(HZ);
 	pDevice->cbFreeCmdQueue = CMD_Q_SIZE;
 	pDevice->uCmdDequeueIdx = 0;
 	pDevice->uCmdEnqueueIdx = 0;
diff --git a/drivers/staging/vt6656/wcmd.h b/drivers/staging/vt6656/wcmd.h
index db8b4cf..cd12558 100644
--- a/drivers/staging/vt6656/wcmd.h
+++ b/drivers/staging/vt6656/wcmd.h
@@ -105,14 +105,7 @@ void vResetCommandTimer(struct vnt_private *);
 
 int bScheduleCommand(struct vnt_private *, CMD_CODE eCommand, u8 *pbyItem0);
 
-void vRunCommand(struct vnt_private *);
-
-/*
-void
-WCMDvCommandThread(
-    void * Context
-    );
-*/
+void vRunCommand(struct work_struct *work);
 
 void BSSvSecondTxData(struct vnt_private *);
 
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index a69b883..03629c5 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -218,11 +218,6 @@ void vMgrObjectInit(struct vnt_private *pDevice)
     pMgmt->sTimerSecondCallback.function = (TimerFunction)BSSvSecondCallBack;
     pMgmt->sTimerSecondCallback.expires = RUN_AT(HZ);
 
-    init_timer(&pDevice->sTimerCommand);
-    pDevice->sTimerCommand.data = (unsigned long)pDevice;
-    pDevice->sTimerCommand.function = (TimerFunction)vRunCommand;
-    pDevice->sTimerCommand.expires = RUN_AT(HZ);
-
     init_timer(&pDevice->sTimerTxData);
     pDevice->sTimerTxData.data = (unsigned long)pDevice;
     pDevice->sTimerTxData.function = (TimerFunction)BSSvSecondTxData;
@@ -844,8 +839,8 @@ static void s_vMgrRxAssocResponse(struct vnt_private *pDevice,
               pDevice->bwextstep3 = false;
               pDevice->bWPASuppWextEnabled = false;
 
-if(pMgmt->eCurrState == WMAC_STATE_ASSOC)
-      timer_expire(pDevice->sTimerCommand, 0);
+	if (pMgmt->eCurrState == WMAC_STATE_ASSOC)
+		schedule_delayed_work(&pDevice->run_command_work, 0);
 
     return;
 }
@@ -1127,7 +1122,7 @@ static void s_vMgrRxAuthenSequence_2(struct vnt_private *pDevice,
             if ( cpu_to_le16((*(pFrame->pwStatus))) == WLAN_MGMT_STATUS_SUCCESS ){
                 DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "802.11 Authen (OPEN) Successful.\n");
                 pMgmt->eCurrState = WMAC_STATE_AUTH;
-	       timer_expire(pDevice->sTimerCommand, 0);
+		schedule_delayed_work(&pDevice->run_command_work, 0);
             }
             else {
                 DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "802.11 Authen (OPEN) Failed.\n");
@@ -1302,7 +1297,7 @@ static void s_vMgrRxAuthenSequence_4(struct vnt_private *pDevice,
     if ( cpu_to_le16((*(pFrame->pwStatus))) == WLAN_MGMT_STATUS_SUCCESS ){
         DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "802.11 Authen (SHAREDKEY) Successful.\n");
         pMgmt->eCurrState = WMAC_STATE_AUTH;
-        timer_expire(pDevice->sTimerCommand, 0);
+	schedule_delayed_work(&pDevice->run_command_work, 0);
     }
     else{
         DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "802.11 Authen (SHAREDKEY) Failed.\n");
-- 
1.8.3.2

