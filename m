Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:45011 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbaEUUKu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2014 16:10:50 -0400
Received: by mail-wg0-f42.google.com with SMTP id y10so2451377wgg.13
        for <linux-wireless@vger.kernel.org>; Wed, 21 May 2014 13:10:49 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 6/6] staging: vt6656: dead code remove diversity code
Date: Wed, 21 May 2014 21:09:44 +0100
Message-Id: <1400702984-3221-6-git-send-email-tvboxspy@gmail.com> (sfid-20140521_221055_411774_B23541C0)
In-Reply-To: <1400702984-3221-1-git-send-email-tvboxspy@gmail.com>
References: <1400702984-3221-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bDiversityRegCtlON is always false.

In later vendor driver code has been commented out.

Remove diversity timers and variables.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 282 --------------------------------------
 drivers/staging/vt6656/baseband.h |   7 -
 drivers/staging/vt6656/device.h   |  24 ----
 drivers/staging/vt6656/dpc.c      |   7 -
 drivers/staging/vt6656/main_usb.c |  45 ------
 5 files changed, 365 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 88682c0..3a06bf4 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -636,20 +636,6 @@ static const u16 awcFrameTime[MAX_RATE] =
 {10, 20, 55, 110, 24, 36, 48, 72, 96, 144, 192, 216};
 
 /*
-static
-unsigned long
-s_ulGetLowSQ3(PSDevice pDevice);
-
-static
-unsigned long
-s_ulGetRatio(PSDevice pDevice);
-
-static
-void
-s_vClearSQ3Value(PSDevice pDevice);
-*/
-
-/*
  * Description: Calculate data frame transmitting time
  *
  * Parameters:
@@ -1140,274 +1126,6 @@ void BBvExitDeepSleep(struct vnt_private *priv)
 	ControlvWriteByte(priv, MESSAGE_REQUEST_BBREG, 0x0d, 0x01);/* CR13 */
 }
 
-static unsigned long s_ulGetLowSQ3(struct vnt_private *pDevice)
-{
-	int ii;
-	unsigned long ulSQ3 = 0;
-	unsigned long ulMaxPacket;
-
-    ulMaxPacket = pDevice->aulPktNum[RATE_54M];
-	if (pDevice->aulPktNum[RATE_54M] != 0)
-        ulSQ3 = pDevice->aulSQ3Val[RATE_54M] / pDevice->aulPktNum[RATE_54M];
-
-	for (ii = RATE_48M; ii >= RATE_6M; ii--)
-		if (pDevice->aulPktNum[ii] > ulMaxPacket) {
-            ulMaxPacket = pDevice->aulPktNum[ii];
-            ulSQ3 = pDevice->aulSQ3Val[ii] / pDevice->aulPktNum[ii];
-        }
-
-    return ulSQ3;
-}
-
-static unsigned long s_ulGetRatio(struct vnt_private *pDevice)
-{
-	int ii, jj;
-	unsigned long ulRatio = 0;
-	unsigned long ulMaxPacket;
-	unsigned long ulPacketNum;
-
-    //This is a thousand-ratio
-    ulMaxPacket = pDevice->aulPktNum[RATE_54M];
-    if ( pDevice->aulPktNum[RATE_54M] != 0 ) {
-        ulPacketNum = pDevice->aulPktNum[RATE_54M];
-        ulRatio = (ulPacketNum * 1000 / pDevice->uDiversityCnt);
-        ulRatio += TOP_RATE_54M;
-    }
-	for (ii = RATE_48M; ii >= RATE_1M; ii--)
-        if ( pDevice->aulPktNum[ii] > ulMaxPacket ) {
-            ulPacketNum = 0;
-            for ( jj=RATE_54M;jj>=ii;jj--)
-                ulPacketNum += pDevice->aulPktNum[jj];
-            ulRatio = (ulPacketNum * 1000 / pDevice->uDiversityCnt);
-            ulRatio += TOP_RATE_48M;
-            ulMaxPacket = pDevice->aulPktNum[ii];
-        }
-
-    return ulRatio;
-}
-
-static void s_vClearSQ3Value(struct vnt_private *pDevice)
-{
-    int ii;
-    pDevice->uDiversityCnt = 0;
-
-    for ( ii=RATE_1M;ii<MAX_RATE;ii++) {
-        pDevice->aulPktNum[ii] = 0;
-        pDevice->aulSQ3Val[ii] = 0;
-    }
-}
-
-/*
- * Description: Antenna Diversity
- *
- * Parameters:
- *  In:
- *      pDevice          - Device Structure
- *      byRSR            - RSR from received packet
- *      bySQ3            - SQ3 value from received packet
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
-
-void BBvAntennaDiversity(struct vnt_private *pDevice,
-	u8 byRxRate, u8 bySQ3)
-{
-
-    pDevice->uDiversityCnt++;
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pDevice->uDiversityCnt = %d\n", (int)pDevice->uDiversityCnt);
-
-    if (byRxRate == 2) {
-        pDevice->aulPktNum[RATE_1M]++;
-    }
-    else if (byRxRate==4) {
-        pDevice->aulPktNum[RATE_2M]++;
-    }
-    else if (byRxRate==11) {
-        pDevice->aulPktNum[RATE_5M]++;
-    }
-    else if (byRxRate==22) {
-        pDevice->aulPktNum[RATE_11M]++;
-    }
-    else if(byRxRate==12){
-        pDevice->aulPktNum[RATE_6M]++;
-        pDevice->aulSQ3Val[RATE_6M] += bySQ3;
-    }
-    else if(byRxRate==18){
-        pDevice->aulPktNum[RATE_9M]++;
-        pDevice->aulSQ3Val[RATE_9M] += bySQ3;
-    }
-    else if(byRxRate==24){
-        pDevice->aulPktNum[RATE_12M]++;
-        pDevice->aulSQ3Val[RATE_12M] += bySQ3;
-    }
-    else if(byRxRate==36){
-        pDevice->aulPktNum[RATE_18M]++;
-        pDevice->aulSQ3Val[RATE_18M] += bySQ3;
-    }
-    else if(byRxRate==48){
-        pDevice->aulPktNum[RATE_24M]++;
-        pDevice->aulSQ3Val[RATE_24M] += bySQ3;
-    }
-    else if(byRxRate==72){
-        pDevice->aulPktNum[RATE_36M]++;
-        pDevice->aulSQ3Val[RATE_36M] += bySQ3;
-    }
-    else if(byRxRate==96){
-        pDevice->aulPktNum[RATE_48M]++;
-        pDevice->aulSQ3Val[RATE_48M] += bySQ3;
-    }
-    else if(byRxRate==108){
-        pDevice->aulPktNum[RATE_54M]++;
-        pDevice->aulSQ3Val[RATE_54M] += bySQ3;
-    }
-
-    if (pDevice->byAntennaState == 0) {
-
-        if (pDevice->uDiversityCnt > pDevice->ulDiversityNValue) {
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"ulDiversityNValue=[%d],54M-[%d]\n",(int)pDevice->ulDiversityNValue, (int)pDevice->aulPktNum[RATE_54M]);
-
-            pDevice->ulSQ3_State0 = s_ulGetLowSQ3(pDevice);
-            pDevice->ulRatio_State0 = s_ulGetRatio(pDevice);
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"SQ3_State0, SQ3= [%08x] rate = [%08x]\n",(int)pDevice->ulSQ3_State0,(int)pDevice->ulRatio_State0);
-
-            if ( ((pDevice->aulPktNum[RATE_54M] < pDevice->ulDiversityNValue/2) &&
-                  (pDevice->ulSQ3_State0 > pDevice->ulSQ3TH) ) ||
-                 (pDevice->ulSQ3_State0 == 0 ) )  {
-
-                if ( pDevice->byTMax == 0 )
-                    return;
-
-		bScheduleCommand((void *) pDevice,
-				 WLAN_CMD_CHANGE_ANTENNA,
-				 NULL);
-
-                pDevice->byAntennaState = 1;
-
-                del_timer(&pDevice->TimerSQ3Tmax3);
-                del_timer(&pDevice->TimerSQ3Tmax2);
-                pDevice->TimerSQ3Tmax1.expires =  RUN_AT(pDevice->byTMax * HZ);
-                add_timer(&pDevice->TimerSQ3Tmax1);
-
-            } else {
-                pDevice->TimerSQ3Tmax3.expires =  RUN_AT(pDevice->byTMax3 * HZ);
-                add_timer(&pDevice->TimerSQ3Tmax3);
-            }
-            s_vClearSQ3Value(pDevice);
-
-        }
-    } else { //byAntennaState == 1
-
-        if (pDevice->uDiversityCnt > pDevice->ulDiversityMValue) {
-
-            del_timer(&pDevice->TimerSQ3Tmax1);
-            pDevice->ulSQ3_State1 = s_ulGetLowSQ3(pDevice);
-            pDevice->ulRatio_State1 = s_ulGetRatio(pDevice);
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"SQ3_State1, rate0 = %08x,rate1 = %08x\n",(int)pDevice->ulRatio_State0,(int)pDevice->ulRatio_State1);
-
-            if ( ((pDevice->ulSQ3_State1 == 0) && (pDevice->ulSQ3_State0 != 0)) ||
-                 ((pDevice->ulSQ3_State1 == 0) && (pDevice->ulSQ3_State0 == 0) && (pDevice->ulRatio_State1 < pDevice->ulRatio_State0)) ||
-                 ((pDevice->ulSQ3_State1 != 0) && (pDevice->ulSQ3_State0 != 0) && (pDevice->ulSQ3_State0 < pDevice->ulSQ3_State1))
-               ) {
-
-		bScheduleCommand((void *) pDevice,
-				 WLAN_CMD_CHANGE_ANTENNA,
-				 NULL);
-
-                pDevice->TimerSQ3Tmax3.expires =  RUN_AT(pDevice->byTMax3 * HZ);
-                pDevice->TimerSQ3Tmax2.expires =  RUN_AT(pDevice->byTMax2 * HZ);
-                add_timer(&pDevice->TimerSQ3Tmax3);
-                add_timer(&pDevice->TimerSQ3Tmax2);
-
-            }
-            pDevice->byAntennaState = 0;
-            s_vClearSQ3Value(pDevice);
-        }
-    } //byAntennaState
-}
-
-/*+
- *
- * Description:
- *  Timer for SQ3 antenna diversity
- *
- * Parameters:
- *  In:
- *      pvSysSpec1
- *      hDeviceContext - Pointer to the adapter
- *      pvSysSpec2
- *      pvSysSpec3
- *  Out:
- *      none
- *
- * Return Value: none
- *
--*/
-
-void TimerSQ3CallBack(struct vnt_private *pDevice)
-{
-
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"TimerSQ3CallBack...");
-    spin_lock_irq(&pDevice->lock);
-
-    bScheduleCommand((void *) pDevice, WLAN_CMD_CHANGE_ANTENNA, NULL);
-    pDevice->byAntennaState = 0;
-    s_vClearSQ3Value(pDevice);
-    pDevice->TimerSQ3Tmax3.expires =  RUN_AT(pDevice->byTMax3 * HZ);
-    pDevice->TimerSQ3Tmax2.expires =  RUN_AT(pDevice->byTMax2 * HZ);
-    add_timer(&pDevice->TimerSQ3Tmax3);
-    add_timer(&pDevice->TimerSQ3Tmax2);
-
-    spin_unlock_irq(&pDevice->lock);
-}
-
-/*+
- *
- * Description:
- *  Timer for SQ3 antenna diversity
- *
- * Parameters:
- *  In:
- *      pvSysSpec1
- *      hDeviceContext - Pointer to the adapter
- *      pvSysSpec2
- *      pvSysSpec3
- *  Out:
- *      none
- *
- * Return Value: none
- *
--*/
-
-void TimerSQ3Tmax3CallBack(struct vnt_private *pDevice)
-{
-
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"TimerSQ3Tmax3CallBack...");
-    spin_lock_irq(&pDevice->lock);
-
-    pDevice->ulRatio_State0 = s_ulGetRatio(pDevice);
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"SQ3_State0 = [%08x]\n",(int)pDevice->ulRatio_State0);
-
-    s_vClearSQ3Value(pDevice);
-    if ( pDevice->byTMax == 0 ) {
-        pDevice->TimerSQ3Tmax3.expires =  RUN_AT(pDevice->byTMax3 * HZ);
-        add_timer(&pDevice->TimerSQ3Tmax3);
-        spin_unlock_irq(&pDevice->lock);
-        return;
-    }
-
-    bScheduleCommand((void *) pDevice, WLAN_CMD_CHANGE_ANTENNA, NULL);
-    pDevice->byAntennaState = 1;
-    del_timer(&pDevice->TimerSQ3Tmax3);
-    del_timer(&pDevice->TimerSQ3Tmax2);
-    pDevice->TimerSQ3Tmax1.expires =  RUN_AT(pDevice->byTMax * HZ);
-    add_timer(&pDevice->TimerSQ3Tmax1);
-
-    spin_unlock_irq(&pDevice->lock);
-}
-
 void BBvUpdatePreEDThreshold(struct vnt_private *priv, int scanning)
 {
 	u8 cr_201 = 0x0, cr_206 = 0x0;
diff --git a/drivers/staging/vt6656/baseband.h b/drivers/staging/vt6656/baseband.h
index eda0d8a..3044d6c 100644
--- a/drivers/staging/vt6656/baseband.h
+++ b/drivers/staging/vt6656/baseband.h
@@ -94,13 +94,6 @@ unsigned int BBuGetFrameTime(u8 preamble_type, u8 pkt_type,
 void BBvCalculateParameter(struct vnt_private *, u32 frame_length,
 	u16 tx_rate, u8 pkt_type, struct vnt_phy_field *);
 
-/* timer for antenna diversity */
-
-void TimerSQ3CallBack(struct vnt_private *);
-void TimerSQ3Tmax3CallBack(struct vnt_private *);
-
-void BBvAntennaDiversity(struct vnt_private *, u8 byRxRate, u8 bySQ3);
-
 void BBvSetShortSlotTime(struct vnt_private *);
 void BBvSetVGAGainOffset(struct vnt_private *, u8 byData);
 void BBvSetAntennaMode(struct vnt_private *, u8 byAntennaMode);
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index d55f81c..e5f84f5 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -492,30 +492,6 @@ struct vnt_private {
 	u8 byRadioCtl;
 	u8 bHWRadioOff;
 
-	/* SQ3 functions for antenna diversity */
-	struct timer_list TimerSQ3Tmax1;
-	struct timer_list TimerSQ3Tmax2;
-	struct timer_list TimerSQ3Tmax3;
-
-	int bDiversityRegCtlON;
-	int bDiversityEnable;
-	unsigned long ulDiversityNValue;
-	unsigned long ulDiversityMValue;
-	u8 byTMax;
-	u8 byTMax2;
-	u8 byTMax3;
-	unsigned long ulSQ3TH;
-
-	unsigned long uDiversityCnt;
-	u8 byAntennaState;
-	unsigned long ulRatio_State0;
-	unsigned long ulRatio_State1;
-	unsigned long ulSQ3_State0;
-	unsigned long ulSQ3_State1;
-
-	unsigned long aulSQ3Val[MAX_RATE];
-	unsigned long aulPktNum[MAX_RATE];
-
 	/* IFS & Cw */
 	u32 uSIFS;  /* Current SIFS */
 	u32 uDIFS;  /* Current DIFS */
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index 2ad6c3e..286e735 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -556,13 +556,6 @@ int RXbBulkInProcessData(struct vnt_private *pDevice, struct vnt_rcb *pRCB,
         }
     }
 
-    // Now it only supports 802.11g Infrastructure Mode, and support rate must up to 54 Mbps
-    if (pDevice->bDiversityEnable && (FrameSize>50) &&
-	pDevice->op_mode == NL80211_IFTYPE_STATION &&
-       (pDevice->bLinkPass == true)) {
-        BBvAntennaDiversity(pDevice, s_byGetRateIdx(*pbyRxRate), 0);
-    }
-
     // ++++++++ For BaseBand Algorithm +++++++++++++++
     pDevice->uCurrRSSI = *pbyRSSI;
     pDevice->byCurrSQ = *pbySQ;
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 787261e..09e444d 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -214,7 +214,6 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
 
 static int device_init_registers(struct vnt_private *pDevice);
 static bool device_init_defrag_cb(struct vnt_private *pDevice);
-static void device_init_diversity_timer(struct vnt_private *pDevice);
 
 static int  ethtool_ioctl(struct net_device *dev, struct ifreq *);
 static void device_free_tx_bufs(struct vnt_private *pDevice);
@@ -261,28 +260,6 @@ device_set_options(struct vnt_private *pDevice) {
     pDevice->byAutoFBCtrl = AUTO_FB_0;
     pDevice->byPreambleType = 0;
     pDevice->bExistSWNetAddr = false;
-    /* pDevice->bDiversityRegCtlON = true; */
-    pDevice->bDiversityRegCtlON = false;
-}
-
-static void device_init_diversity_timer(struct vnt_private *pDevice)
-{
-    init_timer(&pDevice->TimerSQ3Tmax1);
-    pDevice->TimerSQ3Tmax1.data = (unsigned long)pDevice;
-    pDevice->TimerSQ3Tmax1.function = (TimerFunction)TimerSQ3CallBack;
-    pDevice->TimerSQ3Tmax1.expires = RUN_AT(HZ);
-
-    init_timer(&pDevice->TimerSQ3Tmax2);
-    pDevice->TimerSQ3Tmax2.data = (unsigned long)pDevice;
-    pDevice->TimerSQ3Tmax2.function = (TimerFunction)TimerSQ3CallBack;
-    pDevice->TimerSQ3Tmax2.expires = RUN_AT(HZ);
-
-    init_timer(&pDevice->TimerSQ3Tmax3);
-    pDevice->TimerSQ3Tmax3.data = (unsigned long)pDevice;
-    pDevice->TimerSQ3Tmax3.function = (TimerFunction)TimerSQ3Tmax3CallBack;
-    pDevice->TimerSQ3Tmax3.expires = RUN_AT(HZ);
-
-    return;
 }
 
 /*
@@ -444,13 +421,7 @@ static int device_init_registers(struct vnt_private *pDevice)
 			pDevice->byRxAntennaMode = ANT_A;
 		else
 			pDevice->byRxAntennaMode = ANT_B;
-
-		if (pDevice->bDiversityRegCtlON)
-			pDevice->bDiversityEnable = true;
-		else
-			pDevice->bDiversityEnable = false;
 	} else  {
-		pDevice->bDiversityEnable = false;
 		pDevice->byAntennaCount = 1;
 		pDevice->dwTxAntennaSel = 0;
 		pDevice->dwRxAntennaSel = 0;
@@ -472,13 +443,6 @@ static int device_init_registers(struct vnt_private *pDevice)
 		}
 	}
 
-	pDevice->ulDiversityNValue = 100 * 255;
-	pDevice->ulDiversityMValue = 100 * 16;
-	pDevice->byTMax = 1;
-	pDevice->byTMax2 = 4;
-	pDevice->ulSQ3TH = 0;
-	pDevice->byTMax3 = 64;
-
 	/* get Auto Fall Back type */
 	pDevice->byAutoFBCtrl = AUTO_FB_0;
 
@@ -957,9 +921,6 @@ static int  device_open(struct net_device *dev)
     pDevice->bRoaming = false;
     pDevice->bIsRoaming = false;
     pDevice->bEnableRoaming = false;
-    if (pDevice->bDiversityRegCtlON) {
-        device_init_diversity_timer(pDevice);
-    }
 
     vMgrObjectInit(pDevice);
 
@@ -1053,12 +1014,6 @@ static int device_close(struct net_device *dev)
 	cancel_delayed_work_sync(&pDevice->run_command_work);
 	cancel_delayed_work_sync(&pDevice->second_callback_work);
 
-    if (pDevice->bDiversityRegCtlON) {
-        del_timer(&pDevice->TimerSQ3Tmax1);
-        del_timer(&pDevice->TimerSQ3Tmax2);
-        del_timer(&pDevice->TimerSQ3Tmax3);
-    }
-
 	cancel_work_sync(&pDevice->rx_mng_work_item);
 	cancel_work_sync(&pDevice->read_work_item);
 
-- 
1.9.1

