Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:62834 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424Ab3I0PvU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Sep 2013 11:51:20 -0400
Received: by mail-wg0-f49.google.com with SMTP id l18so2849715wgh.28
        for <linux-wireless@vger.kernel.org>; Fri, 27 Sep 2013 08:51:19 -0700 (PDT)
Message-ID: <1380297073.2235.32.camel@canaries64-MCP7A> (sfid-20130927_175125_033535_EA0B0276)
Subject: [PATCH 2/4] staging: vt6656: covert BSSvSecondCallBack to
 delayed_work.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Fri, 27 Sep 2013 16:51:13 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

timer to delay workqueue.
sTimerSecondCallback -> second_callback_work

The delayed work queue is declared in device.h

This timer is very heavy on the system.

Improves over performance of driver and reduce the atomic
area of driver.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/bssdb.c    | 7 ++++---
 drivers/staging/vt6656/bssdb.h    | 2 +-
 drivers/staging/vt6656/device.h   | 2 ++
 drivers/staging/vt6656/main_usb.c | 8 +++++---
 drivers/staging/vt6656/wcmd.c     | 4 ++--
 drivers/staging/vt6656/wmgr.c     | 5 -----
 drivers/staging/vt6656/wmgr.h     | 3 ---
 7 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index ed1d609..ae0438a 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -813,8 +813,10 @@ void BSSvAddMulticastNode(struct vnt_private *pDevice)
  *
 -*/
 
-void BSSvSecondCallBack(struct vnt_private *pDevice)
+void BSSvSecondCallBack(struct work_struct *work)
 {
+	struct vnt_private *pDevice = container_of(work,
+			struct vnt_private, second_callback_work.work);
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	int ii;
 	PWLAN_IE_SSID pItemSSID, pCurrSSID;
@@ -1126,8 +1128,7 @@ else {
 
     spin_unlock_irq(&pDevice->lock);
 
-    pMgmt->sTimerSecondCallback.expires = RUN_AT(HZ);
-    add_timer(&pMgmt->sTimerSecondCallback);
+	schedule_delayed_work(&pDevice->second_callback_work, HZ);
 }
 
 /*+
diff --git a/drivers/staging/vt6656/bssdb.h b/drivers/staging/vt6656/bssdb.h
index bce3b46..fc41855 100644
--- a/drivers/staging/vt6656/bssdb.h
+++ b/drivers/staging/vt6656/bssdb.h
@@ -262,7 +262,7 @@ void BSSvCreateOneNode(struct vnt_private *, u32 *puNodeIndex);
 void BSSvUpdateAPNode(struct vnt_private *, u16 *pwCapInfo,
 	PWLAN_IE_SUPP_RATES pItemRates, PWLAN_IE_SUPP_RATES pExtSuppRates);
 
-void BSSvSecondCallBack(struct vnt_private *);
+void BSSvSecondCallBack(struct work_struct *work);
 
 void BSSvUpdateNodeTxCounter(struct vnt_private *, PSStatCounter pStatistic,
 	u8 byTSR, u8 byPktNO);
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 63806e8..6052f4c 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -708,6 +708,8 @@ struct vnt_private {
 
 	/* command timer */
 	struct delayed_work run_command_work;
+	/* One second callback */
+	struct delayed_work second_callback_work;
 
 	struct timer_list sTimerTxData;
 	unsigned long nTxDataTimeCout;
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 41d1e79..c4eb092 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -703,6 +703,7 @@ vt6656_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	device_set_options(pDevice);
 	spin_lock_init(&pDevice->lock);
 	INIT_DELAYED_WORK(&pDevice->run_command_work, vRunCommand);
+	INIT_DELAYED_WORK(&pDevice->second_callback_work, BSSvSecondCallBack);
 
 	pDevice->tx_80211 = device_dma0_tx_80211;
 	pDevice->vnt_mgmt.pAdapter = (void *) pDevice;
@@ -985,7 +986,9 @@ static int  device_open(struct net_device *dev)
     tasklet_init(&pDevice->RxMngWorkItem, (void *)RXvMngWorkItem, (unsigned long)pDevice);
     tasklet_init(&pDevice->ReadWorkItem, (void *)RXvWorkItem, (unsigned long)pDevice);
     tasklet_init(&pDevice->EventWorkItem, (void *)INTvWorkItem, (unsigned long)pDevice);
-	add_timer(&pDevice->vnt_mgmt.sTimerSecondCallback);
+
+	schedule_delayed_work(&pDevice->second_callback_work, HZ);
+
 	pDevice->int_interval = 100;  /* max 100 microframes */
     pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
 
@@ -1079,8 +1082,7 @@ static int device_close(struct net_device *dev)
     pDevice->fKillEventPollingThread = true;
 
 	cancel_delayed_work_sync(&pDevice->run_command_work);
-
-    del_timer(&pMgmt->sTimerSecondCallback);
+	cancel_delayed_work_sync(&pDevice->second_callback_work);
 
     del_timer(&pDevice->sTimerTxData);
 
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 3b9bfcb..debb87a 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -690,7 +690,7 @@ void vRunCommand(struct work_struct *work)
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"eCommandState == WLAN_CMD_AP_MODE_START\n");
 
             if (pMgmt->eConfigMode == WMAC_CONFIG_AP) {
-                del_timer(&pMgmt->sTimerSecondCallback);
+		cancel_delayed_work_sync(&pDevice->second_callback_work);
                 pMgmt->eCurrState = WMAC_STATE_IDLE;
                 pMgmt->eCurrMode = WMAC_MODE_STANDBY;
                 pDevice->bLinkPass = false;
@@ -718,7 +718,7 @@ void vRunCommand(struct work_struct *work)
                 }
                 pDevice->bLinkPass = true;
                 ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_INTER);
-                add_timer(&pMgmt->sTimerSecondCallback);
+		schedule_delayed_work(&pDevice->second_callback_work, HZ);
             }
             s_bCommandComplete(pDevice);
             break;
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index 03629c5..5a6a5ba 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -213,11 +213,6 @@ void vMgrObjectInit(struct vnt_private *pDevice)
     pMgmt->wIBSSBeaconPeriod = DEFAULT_IBSS_BI;
     BSSvClearBSSList((void *) pDevice, false);
 
-    init_timer(&pMgmt->sTimerSecondCallback);
-    pMgmt->sTimerSecondCallback.data = (unsigned long)pDevice;
-    pMgmt->sTimerSecondCallback.function = (TimerFunction)BSSvSecondCallBack;
-    pMgmt->sTimerSecondCallback.expires = RUN_AT(HZ);
-
     init_timer(&pDevice->sTimerTxData);
     pDevice->sTimerTxData.data = (unsigned long)pDevice;
     pDevice->sTimerTxData.function = (TimerFunction)BSSvSecondTxData;
diff --git a/drivers/staging/vt6656/wmgr.h b/drivers/staging/vt6656/wmgr.h
index 5424c7f..26ba47d 100644
--- a/drivers/staging/vt6656/wmgr.h
+++ b/drivers/staging/vt6656/wmgr.h
@@ -310,9 +310,6 @@ struct vnt_manager {
 	u8 byMgmtPacketPool[sizeof(struct vnt_tx_mgmt)
 		+ WLAN_A3FR_MAXLEN];
 
-	/* One second callback timer */
-	struct timer_list sTimerSecondCallback;
-
 	/* Temporarily Rx Mgmt Packet Descriptor */
 	struct vnt_rx_mgmt sRxPacket;
 
-- 
1.8.3.2

