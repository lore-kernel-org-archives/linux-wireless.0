Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:55016 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbbASSY7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 13:24:59 -0500
Received: by mail-wg0-f52.google.com with SMTP id l2so11127023wgh.11
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jan 2015 10:24:57 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/6] staging: vt6655: remove antenna diversity functions
Date: Mon, 19 Jan 2015 18:24:12 +0000
Message-Id: <1421691855-2927-3-git-send-email-tvboxspy@gmail.com> (sfid-20150119_192508_769666_8C3F6314)
In-Reply-To: <1421691855-2927-1-git-send-email-tvboxspy@gmail.com>
References: <1421691855-2927-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The vendor had disabled these functions in their last version.

On test this can be troublesome, so remove this from the driver along
with its macros and timers.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/baseband.c    | 340 -----------------------------------
 drivers/staging/vt6655/baseband.h    |  17 --
 drivers/staging/vt6655/device.h      |  23 ---
 drivers/staging/vt6655/device_main.c |  56 ------
 drivers/staging/vt6655/dpc.c         |   6 -
 5 files changed, 442 deletions(-)

diff --git a/drivers/staging/vt6655/baseband.c b/drivers/staging/vt6655/baseband.c
index ecf7dac..565ba18 100644
--- a/drivers/staging/vt6655/baseband.c
+++ b/drivers/staging/vt6655/baseband.c
@@ -1699,46 +1699,6 @@ static const unsigned short awcFrameTime[MAX_RATE] = {
 		10, 20, 55, 110, 24, 36, 48, 72, 96, 144, 192, 216
 };
 
-/*---------------------  Static Functions  --------------------------*/
-
-static
-unsigned long
-s_ulGetRatio(struct vnt_private *priv);
-
-static
-void
-s_vChangeAntenna(
-	struct vnt_private *priv
-);
-
-static
-void
-s_vChangeAntenna(
-	struct vnt_private *priv
-)
-{
-	if (priv->dwRxAntennaSel == 0) {
-		priv->dwRxAntennaSel = 1;
-		if (priv->bTxRxAntInv == true)
-			BBvSetRxAntennaMode(priv, ANT_A);
-		else
-			BBvSetRxAntennaMode(priv, ANT_B);
-	} else {
-		priv->dwRxAntennaSel = 0;
-		if (priv->bTxRxAntInv == true)
-			BBvSetRxAntennaMode(priv, ANT_B);
-		else
-			BBvSetRxAntennaMode(priv, ANT_A);
-	}
-	if (priv->dwTxAntennaSel == 0) {
-		priv->dwTxAntennaSel = 1;
-		BBvSetTxAntennaMode(priv, ANT_B);
-	} else {
-		priv->dwTxAntennaSel = 0;
-		BBvSetTxAntennaMode(priv, ANT_A);
-	}
-}
-
 /*---------------------  Export Variables  --------------------------*/
 /*
  * Description: Calculate data frame transmitting time
@@ -2413,303 +2373,3 @@ BBvExitDeepSleep(struct vnt_private *priv, unsigned char byLocalID)
 	BBbWriteEmbedded(priv, 0x0C, 0x00); /* CR12 */
 	BBbWriteEmbedded(priv, 0x0D, 0x01); /* CR13 */
 }
-
-static
-unsigned long
-s_ulGetRatio(struct vnt_private *priv)
-{
-	unsigned long ulRatio = 0;
-	unsigned long ulMaxPacket;
-	unsigned long ulPacketNum;
-
-	/* This is a thousand-ratio */
-	ulMaxPacket = priv->uNumSQ3[RATE_54M];
-	if (priv->uNumSQ3[RATE_54M] != 0) {
-		ulPacketNum = priv->uNumSQ3[RATE_54M];
-		ulRatio = (ulPacketNum * 1000 / priv->uDiversityCnt);
-		ulRatio += TOP_RATE_54M;
-	}
-	if (priv->uNumSQ3[RATE_48M] > ulMaxPacket) {
-		ulPacketNum = priv->uNumSQ3[RATE_54M] + priv->uNumSQ3[RATE_48M];
-		ulRatio = (ulPacketNum * 1000 / priv->uDiversityCnt);
-		ulRatio += TOP_RATE_48M;
-		ulMaxPacket = priv->uNumSQ3[RATE_48M];
-	}
-	if (priv->uNumSQ3[RATE_36M] > ulMaxPacket) {
-		ulPacketNum = priv->uNumSQ3[RATE_54M] + priv->uNumSQ3[RATE_48M] +
-			priv->uNumSQ3[RATE_36M];
-		ulRatio = (ulPacketNum * 1000 / priv->uDiversityCnt);
-		ulRatio += TOP_RATE_36M;
-		ulMaxPacket = priv->uNumSQ3[RATE_36M];
-	}
-	if (priv->uNumSQ3[RATE_24M] > ulMaxPacket) {
-		ulPacketNum = priv->uNumSQ3[RATE_54M] + priv->uNumSQ3[RATE_48M] +
-			priv->uNumSQ3[RATE_36M] + priv->uNumSQ3[RATE_24M];
-		ulRatio = (ulPacketNum * 1000 / priv->uDiversityCnt);
-		ulRatio += TOP_RATE_24M;
-		ulMaxPacket = priv->uNumSQ3[RATE_24M];
-	}
-	if (priv->uNumSQ3[RATE_18M] > ulMaxPacket) {
-		ulPacketNum = priv->uNumSQ3[RATE_54M] + priv->uNumSQ3[RATE_48M] +
-			priv->uNumSQ3[RATE_36M] + priv->uNumSQ3[RATE_24M] +
-			priv->uNumSQ3[RATE_18M];
-		ulRatio = (ulPacketNum * 1000 / priv->uDiversityCnt);
-		ulRatio += TOP_RATE_18M;
-		ulMaxPacket = priv->uNumSQ3[RATE_18M];
-	}
-	if (priv->uNumSQ3[RATE_12M] > ulMaxPacket) {
-		ulPacketNum = priv->uNumSQ3[RATE_54M] + priv->uNumSQ3[RATE_48M] +
-			priv->uNumSQ3[RATE_36M] + priv->uNumSQ3[RATE_24M] +
-			priv->uNumSQ3[RATE_18M] + priv->uNumSQ3[RATE_12M];
-		ulRatio = (ulPacketNum * 1000 / priv->uDiversityCnt);
-		ulRatio += TOP_RATE_12M;
-		ulMaxPacket = priv->uNumSQ3[RATE_12M];
-	}
-	if (priv->uNumSQ3[RATE_11M] > ulMaxPacket) {
-		ulPacketNum = priv->uDiversityCnt - priv->uNumSQ3[RATE_1M] -
-			priv->uNumSQ3[RATE_2M] - priv->uNumSQ3[RATE_5M] -
-			priv->uNumSQ3[RATE_6M] - priv->uNumSQ3[RATE_9M];
-		ulRatio = (ulPacketNum * 1000 / priv->uDiversityCnt);
-		ulRatio += TOP_RATE_11M;
-		ulMaxPacket = priv->uNumSQ3[RATE_11M];
-	}
-	if (priv->uNumSQ3[RATE_9M] > ulMaxPacket) {
-		ulPacketNum = priv->uDiversityCnt - priv->uNumSQ3[RATE_1M] -
-			priv->uNumSQ3[RATE_2M] - priv->uNumSQ3[RATE_5M] -
-			priv->uNumSQ3[RATE_6M];
-		ulRatio = (ulPacketNum * 1000 / priv->uDiversityCnt);
-		ulRatio += TOP_RATE_9M;
-		ulMaxPacket = priv->uNumSQ3[RATE_9M];
-	}
-	if (priv->uNumSQ3[RATE_6M] > ulMaxPacket) {
-		ulPacketNum = priv->uDiversityCnt - priv->uNumSQ3[RATE_1M] -
-			priv->uNumSQ3[RATE_2M] - priv->uNumSQ3[RATE_5M];
-		ulRatio = (ulPacketNum * 1000 / priv->uDiversityCnt);
-		ulRatio += TOP_RATE_6M;
-		ulMaxPacket = priv->uNumSQ3[RATE_6M];
-	}
-	if (priv->uNumSQ3[RATE_5M] > ulMaxPacket) {
-		ulPacketNum = priv->uDiversityCnt - priv->uNumSQ3[RATE_1M] -
-			priv->uNumSQ3[RATE_2M];
-		ulRatio = (ulPacketNum * 1000 / priv->uDiversityCnt);
-		ulRatio += TOP_RATE_55M;
-		ulMaxPacket = priv->uNumSQ3[RATE_5M];
-	}
-	if (priv->uNumSQ3[RATE_2M] > ulMaxPacket) {
-		ulPacketNum = priv->uDiversityCnt - priv->uNumSQ3[RATE_1M];
-		ulRatio = (ulPacketNum * 1000 / priv->uDiversityCnt);
-		ulRatio += TOP_RATE_2M;
-		ulMaxPacket = priv->uNumSQ3[RATE_2M];
-	}
-	if (priv->uNumSQ3[RATE_1M] > ulMaxPacket) {
-		ulPacketNum = priv->uDiversityCnt;
-		ulRatio = (ulPacketNum * 1000 / priv->uDiversityCnt);
-		ulRatio += TOP_RATE_1M;
-	}
-
-	return ulRatio;
-}
-
-void
-BBvClearAntDivSQ3Value(struct vnt_private *priv)
-{
-	unsigned int ii;
-
-	priv->uDiversityCnt = 0;
-	for (ii = 0; ii < MAX_RATE; ii++)
-		priv->uNumSQ3[ii] = 0;
-}
-
-/*
- * Description: Antenna Diversity
- *
- * Parameters:
- *  In:
- *      priv          - Device Structure
- *      byRSR            - RSR from received packet
- *      bySQ3            - SQ3 value from received packet
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
-
-void BBvAntennaDiversity(struct vnt_private *priv,
-			 unsigned char byRxRate, unsigned char bySQ3)
-{
-	if ((byRxRate >= MAX_RATE) || (priv->wAntDiversityMaxRate >= MAX_RATE))
-		return;
-
-	priv->uDiversityCnt++;
-
-	priv->uNumSQ3[byRxRate]++;
-
-	if (priv->byAntennaState == 0) {
-		if (priv->uDiversityCnt > priv->ulDiversityNValue) {
-			pr_debug("ulDiversityNValue=[%d],54M-[%d]\n",
-				 (int)priv->ulDiversityNValue,
-				 (int)priv->uNumSQ3[(int)priv->wAntDiversityMaxRate]);
-
-			if (priv->uNumSQ3[priv->wAntDiversityMaxRate] < priv->uDiversityCnt/2) {
-				priv->ulRatio_State0 = s_ulGetRatio(priv);
-				pr_debug("SQ3_State0, rate = [%08x]\n",
-					 (int)priv->ulRatio_State0);
-
-				if (priv->byTMax == 0)
-					return;
-				pr_debug("1.[%08x], uNumSQ3[%d]=%d, %d\n",
-					 (int)priv->ulRatio_State0,
-					 (int)priv->wAntDiversityMaxRate,
-					 (int)priv->uNumSQ3[(int)priv->wAntDiversityMaxRate],
-					 (int)priv->uDiversityCnt);
-
-				s_vChangeAntenna(priv);
-				priv->byAntennaState = 1;
-				del_timer(&priv->TimerSQ3Tmax3);
-				del_timer(&priv->TimerSQ3Tmax2);
-				priv->TimerSQ3Tmax1.expires =  RUN_AT(priv->byTMax * HZ);
-				add_timer(&priv->TimerSQ3Tmax1);
-
-			} else {
-				priv->TimerSQ3Tmax3.expires =  RUN_AT(priv->byTMax3 * HZ);
-				add_timer(&priv->TimerSQ3Tmax3);
-			}
-			BBvClearAntDivSQ3Value(priv);
-
-		}
-	} else { /* byAntennaState == 1 */
-
-		if (priv->uDiversityCnt > priv->ulDiversityMValue) {
-			del_timer(&priv->TimerSQ3Tmax1);
-
-			priv->ulRatio_State1 = s_ulGetRatio(priv);
-			pr_debug("RX:SQ3_State1, rate0 = %08x,rate1 = %08x\n",
-				 (int)priv->ulRatio_State0,
-				 (int)priv->ulRatio_State1);
-
-			if (priv->ulRatio_State1 < priv->ulRatio_State0) {
-				pr_debug("2.[%08x][%08x], uNumSQ3[%d]=%d, %d\n",
-					 (int)priv->ulRatio_State0,
-					 (int)priv->ulRatio_State1,
-					 (int)priv->wAntDiversityMaxRate,
-					 (int)priv->uNumSQ3[(int)priv->wAntDiversityMaxRate],
-					 (int)priv->uDiversityCnt);
-
-				s_vChangeAntenna(priv);
-				priv->TimerSQ3Tmax3.expires =  RUN_AT(priv->byTMax3 * HZ);
-				priv->TimerSQ3Tmax2.expires =  RUN_AT(priv->byTMax2 * HZ);
-				add_timer(&priv->TimerSQ3Tmax3);
-				add_timer(&priv->TimerSQ3Tmax2);
-			}
-			priv->byAntennaState = 0;
-			BBvClearAntDivSQ3Value(priv);
-		}
-	} /* byAntennaState */
-}
-
-/*+
- *
- * Description:
- *  Timer for SQ3 antenna diversity
- *
- * Parameters:
- *  In:
- *  Out:
- *      none
- *
- * Return Value: none
- *
- -*/
-
-void
-TimerSQ3CallBack(
-	unsigned long data
-)
-{
-	struct vnt_private *priv = (struct vnt_private *)data;
-	unsigned long flags;
-
-	pr_debug("TimerSQ3CallBack...\n");
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	pr_debug("3.[%08x][%08x], %d\n",
-		 (int)priv->ulRatio_State0, (int)priv->ulRatio_State1,
-		 (int)priv->uDiversityCnt);
-
-	s_vChangeAntenna(priv);
-	priv->byAntennaState = 0;
-	BBvClearAntDivSQ3Value(priv);
-
-	priv->TimerSQ3Tmax3.expires =  RUN_AT(priv->byTMax3 * HZ);
-	priv->TimerSQ3Tmax2.expires =  RUN_AT(priv->byTMax2 * HZ);
-	add_timer(&priv->TimerSQ3Tmax3);
-	add_timer(&priv->TimerSQ3Tmax2);
-
-	spin_unlock_irqrestore(&priv->lock, flags);
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
- -*/
-
-void
-TimerState1CallBack(
-	unsigned long data
-)
-{
-	struct vnt_private *priv = (struct vnt_private *)data;
-	unsigned long flags;
-
-	pr_debug("TimerState1CallBack...\n");
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	if (priv->uDiversityCnt < priv->ulDiversityMValue/100) {
-		s_vChangeAntenna(priv);
-		priv->TimerSQ3Tmax3.expires =  RUN_AT(priv->byTMax3 * HZ);
-		priv->TimerSQ3Tmax2.expires =  RUN_AT(priv->byTMax2 * HZ);
-		add_timer(&priv->TimerSQ3Tmax3);
-		add_timer(&priv->TimerSQ3Tmax2);
-	} else {
-		priv->ulRatio_State1 = s_ulGetRatio(priv);
-		pr_debug("SQ3_State1, rate0 = %08x,rate1 = %08x\n",
-			 (int)priv->ulRatio_State0,
-			 (int)priv->ulRatio_State1);
-
-		if (priv->ulRatio_State1 < priv->ulRatio_State0) {
-			pr_debug("2.[%08x][%08x], uNumSQ3[%d]=%d, %d\n",
-				 (int)priv->ulRatio_State0,
-				 (int)priv->ulRatio_State1,
-				 (int)priv->wAntDiversityMaxRate,
-				 (int)priv->uNumSQ3[(int)priv->wAntDiversityMaxRate],
-				 (int)priv->uDiversityCnt);
-
-			s_vChangeAntenna(priv);
-
-			priv->TimerSQ3Tmax3.expires =  RUN_AT(priv->byTMax3 * HZ);
-			priv->TimerSQ3Tmax2.expires =  RUN_AT(priv->byTMax2 * HZ);
-			add_timer(&priv->TimerSQ3Tmax3);
-			add_timer(&priv->TimerSQ3Tmax2);
-		}
-	}
-	priv->byAntennaState = 0;
-	BBvClearAntDivSQ3Value(priv);
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-}
diff --git a/drivers/staging/vt6655/baseband.h b/drivers/staging/vt6655/baseband.h
index d9f6d63..43a4fb1 100644
--- a/drivers/staging/vt6655/baseband.h
+++ b/drivers/staging/vt6655/baseband.h
@@ -93,21 +93,4 @@ void BBvSetRxAntennaMode(struct vnt_private *, unsigned char byAntennaMode);
 void BBvSetDeepSleep(struct vnt_private *, unsigned char byLocalID);
 void BBvExitDeepSleep(struct vnt_private *, unsigned char byLocalID);
 
-/* timer for antenna diversity */
-
-void
-TimerSQ3CallBack(
-	unsigned long
-);
-
-void
-TimerState1CallBack(
-	unsigned long
-);
-
-void BBvAntennaDiversity(struct vnt_private *,
-			 unsigned char byRxRate, unsigned char bySQ3);
-void
-BBvClearAntDivSQ3Value(struct vnt_private *);
-
 #endif /* __BASEBAND_H__ */
diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 96d8e62..440537e4 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -407,29 +407,6 @@ struct vnt_private {
 	unsigned char byBBCR88;
 	unsigned char byBBCR09;
 
-	bool bDiversityRegCtlON;
-	bool bDiversityEnable;
-	unsigned long ulDiversityNValue;
-	unsigned long ulDiversityMValue;
-	unsigned char byTMax;
-	unsigned char byTMax2;
-	unsigned char byTMax3;
-	unsigned long ulSQ3TH;
-
-	/* ANT diversity */
-	unsigned long uDiversityCnt;
-	unsigned char byAntennaState;
-	unsigned long ulRatio_State0;
-	unsigned long ulRatio_State1;
-
-	/* SQ3 functions for antenna diversity */
-	struct timer_list           TimerSQ3Tmax1;
-	struct timer_list           TimerSQ3Tmax2;
-	struct timer_list           TimerSQ3Tmax3;
-
-	unsigned long uNumSQ3[MAX_RATE];
-	unsigned short wAntDiversityMaxRate;
-
 	unsigned char abyEEPROM[EEP_MAX_CONTEXT_SIZE]; /* unsigned long alignment */
 
 	unsigned short wBeaconInterval;
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index b010184..3093276 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -126,10 +126,6 @@ DEVICE_PARAM(LongRetryLimit, "long frame retry limits");
 
 DEVICE_PARAM(BasebandType, "baseband type");
 
-#define DIVERSITY_ANT_DEF     0
-
-DEVICE_PARAM(bDiversityANTEnable, "ANT diversity mode");
-
 //
 // Static vars definitions
 //
@@ -152,7 +148,6 @@ static void vt6655_init_info(struct pci_dev *pcid,
 static void device_free_info(struct vnt_private *pDevice);
 static bool device_get_pci_info(struct vnt_private *, struct pci_dev *pcid);
 static void device_print_info(struct vnt_private *pDevice);
-static void device_init_diversity_timer(struct vnt_private *pDevice);
 static  irqreturn_t  device_intr(int irq,  void *dev_instance);
 
 #ifdef CONFIG_PM
@@ -216,7 +211,6 @@ static void device_get_options(struct vnt_private *pDevice)
 	pOpts->short_retry = SHORT_RETRY_DEF;
 	pOpts->long_retry = LONG_RETRY_DEF;
 	pOpts->bbp_type = BBP_TYPE_DEF;
-	pOpts->flags |= DEVICE_FLAGS_DiversityANT;
 }
 
 static void
@@ -224,7 +218,6 @@ device_set_options(struct vnt_private *pDevice)
 {
 	pDevice->byShortRetryLimit = pDevice->sOpts.short_retry;
 	pDevice->byLongRetryLimit = pDevice->sOpts.long_retry;
-	pDevice->bDiversityRegCtlON = (pDevice->sOpts.flags & DEVICE_FLAGS_DiversityANT) ? 1 : 0;
 	pDevice->byBBType = pDevice->sOpts.bbp_type;
 	pDevice->byPacketType = pDevice->byBBType;
 	pDevice->byAutoFBCtrl = AUTO_FB_0;
@@ -236,8 +229,6 @@ device_set_options(struct vnt_private *pDevice)
 	pr_debug(" byPreambleType= %d\n", (int)pDevice->byPreambleType);
 	pr_debug(" byShortPreamble= %d\n", (int)pDevice->byShortPreamble);
 	pr_debug(" byBBType= %d\n", (int)pDevice->byBBType);
-	pr_debug(" pDevice->bDiversityRegCtlON= %d\n",
-		 (int)pDevice->bDiversityRegCtlON);
 }
 
 //
@@ -249,7 +240,6 @@ static void device_init_registers(struct vnt_private *pDevice)
 	unsigned long flags;
 	unsigned int ii;
 	unsigned char byValue;
-	unsigned char byValue1;
 	unsigned char byCCKPwrdBm = 0;
 	unsigned char byOFDMPwrdBm = 0;
 
@@ -301,13 +291,6 @@ static void device_init_registers(struct vnt_private *pDevice)
 	if (byValue == 0)
 		byValue = (EEP_ANTENNA_AUX | EEP_ANTENNA_MAIN);
 
-	pDevice->ulDiversityNValue = 100*260;
-	pDevice->ulDiversityMValue = 100*16;
-	pDevice->byTMax = 1;
-	pDevice->byTMax2 = 4;
-	pDevice->ulSQ3TH = 0;
-	pDevice->byTMax3 = 64;
-
 	if (byValue == (EEP_ANTENNA_AUX | EEP_ANTENNA_MAIN)) {
 		pDevice->byAntennaCount = 2;
 		pDevice->byTxAntennaMode = ANT_B;
@@ -318,16 +301,7 @@ static void device_init_registers(struct vnt_private *pDevice)
 			pDevice->byRxAntennaMode = ANT_A;
 		else
 			pDevice->byRxAntennaMode = ANT_B;
-
-		byValue1 = SROMbyReadEmbedded(pDevice->PortOffset,
-					      EEP_OFS_ANTENNA);
-
-		if ((byValue1 & 0x08) == 0)
-			pDevice->bDiversityEnable = false;
-		else
-			pDevice->bDiversityEnable = true;
 	} else  {
-		pDevice->bDiversityEnable = false;
 		pDevice->byAntennaCount = 1;
 		pDevice->dwTxAntennaSel = 0;
 		pDevice->dwRxAntennaSel = 0;
@@ -349,11 +323,6 @@ static void device_init_registers(struct vnt_private *pDevice)
 		}
 	}
 
-	pr_debug("bDiversityEnable=[%d],NValue=[%d],MValue=[%d],TMax=[%d],TMax2=[%d]\n",
-		 pDevice->bDiversityEnable, (int)pDevice->ulDiversityNValue,
-		 (int)pDevice->ulDiversityMValue, pDevice->byTMax,
-		 pDevice->byTMax2);
-
 	/* zonetype initial */
 	pDevice->byOriginalZonetype = pDevice->abyEEPROM[EEP_OFS_ZONETYPE];
 
@@ -493,24 +462,6 @@ static void device_init_registers(struct vnt_private *pDevice)
 	MACvStart(pDevice->PortOffset);
 }
 
-static void device_init_diversity_timer(struct vnt_private *pDevice)
-{
-	init_timer(&pDevice->TimerSQ3Tmax1);
-	pDevice->TimerSQ3Tmax1.data = (unsigned long) pDevice;
-	pDevice->TimerSQ3Tmax1.function = TimerSQ3CallBack;
-	pDevice->TimerSQ3Tmax1.expires = RUN_AT(HZ);
-
-	init_timer(&pDevice->TimerSQ3Tmax2);
-	pDevice->TimerSQ3Tmax2.data = (unsigned long) pDevice;
-	pDevice->TimerSQ3Tmax2.function = TimerSQ3CallBack;
-	pDevice->TimerSQ3Tmax2.expires = RUN_AT(HZ);
-
-	init_timer(&pDevice->TimerSQ3Tmax3);
-	pDevice->TimerSQ3Tmax3.data = (unsigned long) pDevice;
-	pDevice->TimerSQ3Tmax3.function = TimerState1CallBack;
-	pDevice->TimerSQ3Tmax3.expires = RUN_AT(HZ);
-}
-
 static void device_print_info(struct vnt_private *pDevice)
 {
 	dev_info(&pDevice->pcid->dev, "%s\n", get_chip_name(pDevice->chip_id));
@@ -1348,8 +1299,6 @@ static int vnt_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
-		if (priv->bDiversityRegCtlON)
-			device_init_diversity_timer(priv);
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		MACvRegBitsOff(priv->PortOffset, MAC_REG_RCR, RCR_UNICAST);
@@ -1379,11 +1328,6 @@ static void vnt_remove_interface(struct ieee80211_hw *hw,
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
-		if (priv->bDiversityRegCtlON) {
-			del_timer(&priv->TimerSQ3Tmax1);
-			del_timer(&priv->TimerSQ3Tmax2);
-			del_timer(&priv->TimerSQ3Tmax3);
-		}
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		MACvRegBitsOff(priv->PortOffset, MAC_REG_TCR, TCR_AUTOBCNTX);
diff --git a/drivers/staging/vt6655/dpc.c b/drivers/staging/vt6655/dpc.c
index 977683c..11cc090 100644
--- a/drivers/staging/vt6655/dpc.c
+++ b/drivers/staging/vt6655/dpc.c
@@ -116,12 +116,6 @@ static bool vnt_rx_data(struct vnt_private *priv, struct sk_buff *skb,
 			rx_status.flag = RX_FLAG_DECRYPTED;
 	}
 
-	if (priv->vif && priv->bDiversityEnable) {
-		if (ieee80211_is_data(fc) &&
-		    (frame_size > 50) && priv->vif->bss_conf.assoc)
-			BBvAntennaDiversity(priv, priv->rx_rate, 0);
-	}
-
 	memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
 
 	ieee80211_rx_irqsafe(priv->hw, skb);
-- 
2.1.0

