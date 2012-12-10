Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:61800 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab2LJV7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 16:59:32 -0500
Received: by mail-wi0-f174.google.com with SMTP id hm9so1815256wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2012 13:59:30 -0800 (PST)
Message-ID: <1355176750.4680.16.camel@canaries64> (sfid-20121210_225935_501474_1DA75230)
Subject: [PATCH 02/11] staging: vt6656: card/main_usb/device use new
 structure names
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 10 Dec 2012 21:59:10 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This patch also cleans up function declarations, definitions and local variables
were appropriate replacing types defined in "ttype.h" with linux/types.h.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c     | 173 +++++++++++++++++---------------------
 drivers/staging/vt6656/card.h     |  41 +++++----
 drivers/staging/vt6656/device.h   |  19 ++---
 drivers/staging/vt6656/main_usb.c | 155 ++++++++++++++++++----------------
 4 files changed, 186 insertions(+), 202 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index d89fac5..93983d9 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -45,6 +45,7 @@
  *
  */
 
+#include "device.h"
 #include "tmacro.h"
 #include "card.h"
 #include "baseband.h"
@@ -91,9 +92,8 @@ const WORD cwRXBCNTSFOff[MAX_RATE] =
  *  Out:
  *      none
  */
-void CARDbSetMediaChannel(void *pDeviceHandler, unsigned int uConnectionChannel)
+void CARDbSetMediaChannel(struct vnt_private *pDevice, u32 uConnectionChannel)
 {
-PSDevice            pDevice = (PSDevice) pDeviceHandler;
 
     if (pDevice->byBBType == BB_TYPE_11A) { // 15 ~ 38
         if ((uConnectionChannel < (CB_MAX_CHANNEL_24G+1)) || (uConnectionChannel > CB_MAX_CHANNEL))
@@ -149,17 +149,17 @@ PSDevice            pDevice = (PSDevice) pDeviceHandler;
  * Return Value: response Control frame rate
  *
  */
-static WORD swGetCCKControlRate(void *pDeviceHandler, WORD wRateIdx)
+static u16 swGetCCKControlRate(struct vnt_private *pDevice, u16 wRateIdx)
 {
-    PSDevice    pDevice = (PSDevice) pDeviceHandler;
-    unsigned int ui = (unsigned int)wRateIdx;
-    while (ui > RATE_1M) {
-        if (pDevice->wBasicRate & ((WORD)1 << ui)) {
-            return (WORD)ui;
-        }
-        ui --;
-    }
-    return (WORD)RATE_1M;
+	u16 ui = wRateIdx;
+
+	while (ui > RATE_1M) {
+		if (pDevice->wBasicRate & (1 << ui))
+			return ui;
+		ui--;
+	}
+
+	return RATE_1M;
 }
 
 /*
@@ -175,28 +175,33 @@ static WORD swGetCCKControlRate(void *pDeviceHandler, WORD wRateIdx)
  * Return Value: response Control frame rate
  *
  */
-static WORD swGetOFDMControlRate(void *pDeviceHandler, WORD wRateIdx)
+static u16 swGetOFDMControlRate(struct vnt_private *pDevice, u16 wRateIdx)
 {
-    PSDevice    pDevice = (PSDevice) pDeviceHandler;
-    unsigned int ui = (unsigned int)wRateIdx;
-
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"BASIC RATE: %X\n", pDevice->wBasicRate);
-
-    if (!CARDbIsOFDMinBasicRate(pDevice)) {
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"swGetOFDMControlRate:(NO OFDM) %d\n", wRateIdx);
-        if (wRateIdx > RATE_24M)
-            wRateIdx = RATE_24M;
-        return wRateIdx;
-    }
-    while (ui > RATE_11M) {
-        if (pDevice->wBasicRate & ((WORD)1 << ui)) {
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"swGetOFDMControlRate : %d\n", ui);
-            return (WORD)ui;
-        }
-        ui --;
-    }
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"swGetOFDMControlRate: 6M\n");
-    return (WORD)RATE_24M;
+	u16 ui = wRateIdx;
+
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"BASIC RATE: %X\n",
+		pDevice->wBasicRate);
+
+	if (!CARDbIsOFDMinBasicRate(pDevice)) {
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			"swGetOFDMControlRate:(NO OFDM) %d\n", wRateIdx);
+	if (wRateIdx > RATE_24M)
+		wRateIdx = RATE_24M;
+		return wRateIdx;
+	}
+
+	while (ui > RATE_11M) {
+		if (pDevice->wBasicRate & (1 << ui)) {
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+				"swGetOFDMControlRate: %d\n", ui);
+			return ui;
+		}
+		ui--;
+	}
+
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"swGetOFDMControlRate: 6M\n");
+
+	return RATE_24M;
 }
 
 /*
@@ -325,16 +330,15 @@ CARDvCalculateOFDMRParameter (
  * Return Value: None.
  *
  */
-void CARDvSetRSPINF(void *pDeviceHandler, BYTE byBBType)
+void CARDvSetRSPINF(struct vnt_private *pDevice, u8 byBBType)
 {
-    PSDevice    pDevice = (PSDevice) pDeviceHandler;
-    BYTE    abyServ[4] = {0,0,0,0};             // For CCK
-    BYTE    abySignal[4] = {0,0,0,0};
-    WORD    awLen[4] = {0,0,0,0};
-    BYTE    abyTxRate[9] = {0,0,0,0,0,0,0,0,0}; // For OFDM
-    BYTE    abyRsvTime[9] = {0,0,0,0,0,0,0,0,0};
-    BYTE    abyData[34];
-    int     i;
+	u8 abyServ[4] = {0, 0, 0, 0}; /* For CCK */
+	u8 abySignal[4] = {0, 0, 0, 0};
+	u16 awLen[4] = {0, 0, 0, 0};
+	u8 abyTxRate[9] = {0, 0, 0, 0, 0, 0, 0, 0, 0}; /* For OFDM */
+	u8 abyRsvTime[9] = {0, 0, 0, 0, 0, 0, 0, 0, 0};
+	u8 abyData[34];
+	int i;
 
     //RSPINF_b_1
     BBvCalculateParameter(pDevice,
@@ -476,12 +480,10 @@ void CARDvSetRSPINF(void *pDeviceHandler, BYTE byBBType)
  * Return Value: None.
  *
  */
-void vUpdateIFS(void *pDeviceHandler)
+void vUpdateIFS(struct vnt_private *pDevice)
 {
-    PSDevice    pDevice = (PSDevice) pDeviceHandler;
-    //Set SIFS, DIFS, EIFS, SlotTime, CwMin
-    BYTE byMaxMin = 0;
-    BYTE byData[4];
+	u8 byMaxMin = 0;
+	u8 byData[4];
 
     if (pDevice->byPacketType==PK_TYPE_11A) {//0000 0000 0000 0000,11a
         pDevice->uSlot = C_SLOT_SHORT;
@@ -561,11 +563,10 @@ void vUpdateIFS(void *pDeviceHandler)
                         &byMaxMin);
 }
 
-void CARDvUpdateBasicTopRate(void *pDeviceHandler)
+void CARDvUpdateBasicTopRate(struct vnt_private *pDevice)
 {
-PSDevice    pDevice = (PSDevice) pDeviceHandler;
-BYTE byTopOFDM = RATE_24M, byTopCCK = RATE_1M;
-BYTE ii;
+	u8 byTopOFDM = RATE_24M, byTopCCK = RATE_1M;
+	u8 ii;
 
      //Determines the highest basic rate.
      for (ii = RATE_54M; ii >= RATE_6M; ii --) {
@@ -600,10 +601,9 @@ BYTE ii;
  * Return Value: TRUE if succeeded; FALSE if failed.
  *
  */
-void CARDbAddBasicRate(void *pDeviceHandler, WORD wRateIdx)
+void CARDbAddBasicRate(struct vnt_private *pDevice, u16 wRateIdx)
 {
-PSDevice    pDevice = (PSDevice) pDeviceHandler;
-WORD wRate = (WORD)(1<<wRateIdx);
+	u16 wRate = (1 << wRateIdx);
 
     pDevice->wBasicRate |= wRate;
 
@@ -611,10 +611,9 @@ WORD wRate = (WORD)(1<<wRateIdx);
     CARDvUpdateBasicTopRate(pDevice);
 }
 
-BOOL CARDbIsOFDMinBasicRate(void *pDeviceHandler)
+int CARDbIsOFDMinBasicRate(struct vnt_private *pDevice)
 {
-PSDevice    pDevice = (PSDevice) pDeviceHandler;
-int ii;
+	int ii;
 
     for (ii = RATE_54M; ii >= RATE_6M; ii --) {
         if ((pDevice->wBasicRate) & ((WORD)(1<<ii)))
@@ -623,9 +622,8 @@ int ii;
     return FALSE;
 }
 
-BYTE CARDbyGetPktType(void *pDeviceHandler)
+u8 CARDbyGetPktType(struct vnt_private *pDevice)
 {
-    PSDevice    pDevice = (PSDevice) pDeviceHandler;
 
     if (pDevice->byBBType == BB_TYPE_11A || pDevice->byBBType == BB_TYPE_11B) {
         return (BYTE)pDevice->byBBType;
@@ -685,13 +683,11 @@ u64 CARDqGetTSFOffset(BYTE byRxRate, u64 qwTSF1, u64 qwTSF2)
  * Return Value: none
  *
  */
-void CARDvAdjustTSF(void *pDeviceHandler, BYTE byRxRate,
+void CARDvAdjustTSF(struct vnt_private *pDevice, u8 byRxRate,
 		u64 qwBSSTimestamp, u64 qwLocalTSF)
 {
-
-    PSDevice        pDevice = (PSDevice) pDeviceHandler;
 	u64 qwTSFOffset = 0;
-    BYTE            pbyData[8];
+	u8 pbyData[8];
 

     qwTSFOffset = CARDqGetTSFOffset(byRxRate, qwBSSTimestamp, qwLocalTSF);
@@ -729,13 +725,12 @@ void CARDvAdjustTSF(void *pDeviceHandler, BYTE byRxRate,
  * Return Value: TRUE if success; otherwise FALSE
  *
  */
-BOOL CARDbGetCurrentTSF(void *pDeviceHandler, u64 *pqwCurrTSF)
+int CARDbGetCurrentTSF(struct vnt_private *pDevice, u64 *pqwCurrTSF)
 {
-	PSDevice    pDevice = (PSDevice) pDeviceHandler;
 
 	*pqwCurrTSF = pDevice->qwCurrTSF;
 
-    return(TRUE);
+	return TRUE;
 }
 

@@ -750,15 +745,14 @@ BOOL CARDbGetCurrentTSF(void *pDeviceHandler, u64 *pqwCurrTSF)
  * Return Value: TRUE if success; otherwise FALSE
  *
  */
-BOOL CARDbClearCurrentTSF(void *pDeviceHandler)
+int CARDbClearCurrentTSF(struct vnt_private *pDevice)
 {
-    PSDevice    pDevice = (PSDevice) pDeviceHandler;
 
-    MACvRegBitsOn(pDevice,MAC_REG_TFTCTL,TFTCTL_TSFCNTRST);
+	MACvRegBitsOn(pDevice, MAC_REG_TFTCTL, TFTCTL_TSFCNTRST);
 
 	pDevice->qwCurrTSF = 0;
 
-    return(TRUE);
+	return TRUE;
 }
 
 /*
@@ -816,12 +810,10 @@ u64 CARDqGetNextTBTT(u64 qwTSF, WORD wBeaconInterval)
  * Return Value: none
  *
  */
-void CARDvSetFirstNextTBTT(void *pDeviceHandler, WORD wBeaconInterval)
+void CARDvSetFirstNextTBTT(struct vnt_private *pDevice, WORD wBeaconInterval)
 {
-
-    PSDevice        pDevice = (PSDevice) pDeviceHandler;
 	u64 qwNextTBTT = 0;
-	BYTE            pbyData[8];
+	u8 pbyData[8];
 
 	CARDbClearCurrentTSF(pDevice);
     //CARDbGetCurrentTSF(pDevice, &qwNextTBTT); //Get Local TSF counter
@@ -864,11 +856,10 @@ void CARDvSetFirstNextTBTT(void *pDeviceHandler, WORD wBeaconInterval)
  * Return Value: none
  *
  */
-void CARDvUpdateNextTBTT(void *pDeviceHandler, u64 qwTSF,
-			 WORD wBeaconInterval)
+void CARDvUpdateNextTBTT(struct vnt_private *pDevice, u64 qwTSF,
+			u16 wBeaconInterval)
 {
-    PSDevice        pDevice = (PSDevice) pDeviceHandler;
-    BYTE            pbyData[8];
+	u8 pbyData[8];
 
     qwTSF = CARDqGetNextTBTT(qwTSF, wBeaconInterval);
 
@@ -910,10 +901,9 @@ void CARDvUpdateNextTBTT(void *pDeviceHandler, u64 qwTSF,
  * Return Value: TRUE if success; otherwise FALSE
  *
  */
-BOOL CARDbRadioPowerOff(void *pDeviceHandler)
+int CARDbRadioPowerOff(struct vnt_private *pDevice)
 {
-PSDevice    pDevice = (PSDevice) pDeviceHandler;
-BOOL bResult = TRUE;
+	int bResult = TRUE;
 
     //if (pDevice->bRadioOff == TRUE)
     //    return TRUE;
@@ -951,11 +941,9 @@ BOOL bResult = TRUE;
  * Return Value: TRUE if success; otherwise FALSE
  *
  */
-BOOL CARDbRadioPowerOn(void *pDeviceHandler)
+int CARDbRadioPowerOn(struct vnt_private *pDevice)
 {
-PSDevice    pDevice = (PSDevice) pDeviceHandler;
-BOOL bResult = TRUE;
-
+	int bResult = TRUE;
 
     if ((pDevice->bHWRadioOff == TRUE) || (pDevice->bRadioControlOff == TRUE)) {
         return FALSE;
@@ -984,9 +972,8 @@ BOOL bResult = TRUE;
     return bResult;
 }
 
-void CARDvSetBSSMode(void *pDeviceHandler)
+void CARDvSetBSSMode(struct vnt_private *pDevice)
 {
-    PSDevice    pDevice = (PSDevice) pDeviceHandler;
     // Set BB and packet type at the same time.//{{RobertYu:20050222, AL7230 have two TX PA output, only connet to b/g now
     // so in 11a mode need to set the MAC Reg0x4C to 11b/g mode to turn on PA
     if( (pDevice->byRFType == RF_AIROHA7230 ) && (pDevice->byBBType == BB_TYPE_11A) )
@@ -1043,16 +1030,10 @@ void CARDvSetBSSMode(void *pDeviceHandler)
  * Return Value: none.
  *
 -*/
-BOOL
-CARDbChannelSwitch (
-     void *pDeviceHandler,
-     BYTE             byMode,
-     BYTE             byNewChannel,
-     BYTE             byCount
-    )
+int CARDbChannelSwitch(struct vnt_private *pDevice, u8 byMode,
+	u8 byNewChannel, u8 byCount)
 {
-    PSDevice    pDevice = (PSDevice) pDeviceHandler;
-    BOOL        bResult = TRUE;
+	int bResult = TRUE;
 
     if (byCount == 0) {
         pDevice->sMgmtObj.uCurrChannel = byNewChannel;
diff --git a/drivers/staging/vt6656/card.h b/drivers/staging/vt6656/card.h
index 1059467..720643f 100644
--- a/drivers/staging/vt6656/card.h
+++ b/drivers/staging/vt6656/card.h
@@ -28,7 +28,7 @@
 
 #ifndef __CARD_H__
 #define __CARD_H__
-
+#include "device.h"
 #include "ttype.h"
 
 /*---------------------  Export Definitions -------------------------*/
@@ -58,31 +58,28 @@ typedef enum _CARD_OP_MODE {
 /*---------------------  Export Variables  --------------------------*/
 
 /*---------------------  Export Functions  --------------------------*/
+struct vnt_private;
 
-void CARDbSetMediaChannel(void *pDeviceHandler,
-			  unsigned int uConnectionChannel);
-void CARDvSetRSPINF(void *pDeviceHandler, BYTE byBBType);
-void vUpdateIFS(void *pDeviceHandler);
-void CARDvUpdateBasicTopRate(void *pDeviceHandler);
-void CARDbAddBasicRate(void *pDeviceHandler, WORD wRateIdx);
-BOOL CARDbIsOFDMinBasicRate(void *pDeviceHandler);
-void CARDvAdjustTSF(void *pDeviceHandler, BYTE byRxRate,
+void CARDbSetMediaChannel(struct vnt_private *pDevice, u32 uConnectionChannel);
+void CARDvSetRSPINF(struct vnt_private *pDevice, u8 byBBType);
+void vUpdateIFS(struct vnt_private *pDevice);
+void CARDvUpdateBasicTopRate(struct vnt_private *pDevice);
+void CARDbAddBasicRate(struct vnt_private *pDevice, u16 wRateIdx);
+int CARDbIsOFDMinBasicRate(struct vnt_private *pDevice);
+void CARDvAdjustTSF(struct vnt_private *pDevice, u8 byRxRate,
 		u64 qwBSSTimestamp, u64 qwLocalTSF);
-BOOL CARDbGetCurrentTSF(void *pDeviceHandler, u64 *pqwCurrTSF);
-BOOL CARDbClearCurrentTSF(void *pDeviceHandler);
-void CARDvSetFirstNextTBTT(void *pDeviceHandler, WORD wBeaconInterval);
-void CARDvUpdateNextTBTT(void *pDeviceHandler, u64 qwTSF,
+BOOL CARDbGetCurrentTSF(struct vnt_private *pDevice, u64 *pqwCurrTSF);
+BOOL CARDbClearCurrentTSF(struct vnt_private *pDevice);
+void CARDvSetFirstNextTBTT(struct vnt_private *pDevice, WORD wBeaconInterval);
+void CARDvUpdateNextTBTT(struct vnt_private *pDevice, u64 qwTSF,
 			 WORD wBeaconInterval);
 u64 CARDqGetNextTBTT(u64 qwTSF, WORD wBeaconInterval);
 u64 CARDqGetTSFOffset(BYTE byRxRate, u64 qwTSF1, u64 qwTSF2);
-BOOL CARDbRadioPowerOff(void *pDeviceHandler);
-BOOL CARDbRadioPowerOn(void *pDeviceHandler);
-BYTE CARDbyGetPktType(void *pDeviceHandler);
-void CARDvSetBSSMode(void *pDeviceHandler);
-
-BOOL CARDbChannelSwitch(void *pDeviceHandler,
-			BYTE byMode,
-			BYTE byNewChannel,
-			BYTE byCount);
+int CARDbRadioPowerOff(struct vnt_private *pDevice);
+int CARDbRadioPowerOn(struct vnt_private *pDevice);
+u8 CARDbyGetPktType(struct vnt_private *pDevice);
+void CARDvSetBSSMode(struct vnt_private *pDevice);
+int CARDbChannelSwitch(struct vnt_private *pDevice, u8 byMode,
+	u8 byNewChannel, u8 byCount);
 
 #endif /* __CARD_H__ */
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 37ec234..eb8a311 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -174,13 +174,13 @@ typedef enum _CONTEXT_TYPE {
 // RCB (Receive Control Block)
 typedef struct _RCB
 {
-    void *Next;
-    signed long                    Ref;
-    void *pDevice;
-    struct urb              *pUrb;
-    SRxMgmtPacket           sMngPacket;
-    struct sk_buff*         skb;
-    BOOL                    bBoolInUse;
+	void *Next;
+	signed long Ref;
+	void *pDevice;
+	struct urb *pUrb;
+	struct vnt_rx_mgmt sMngPacket;
+	struct sk_buff *skb;
+	int bBoolInUse;
 
 } RCB, *PRCB;
 
@@ -872,9 +872,6 @@ typedef struct vnt_private {
 
 /*---------------------  Export Functions  --------------------------*/
 
-/* BOOL device_dma0_xmit(PSDevice pDevice, struct sk_buff *skb,
- *                       unsigned int uNodeIndex);
- */
-BOOL device_alloc_frag_buf(PSDevice pDevice, PSDeFragControlBlock pDeF);
+int device_alloc_frag_buf(struct vnt_private *, PSDeFragControlBlock pDeF);
 
 #endif
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index f33086d..a316d89 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -225,26 +225,27 @@ static void device_set_multi(struct net_device *dev);
 static int  device_close(struct net_device *dev);
 static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
 
-static BOOL device_init_registers(PSDevice pDevice, DEVICE_INIT_TYPE InitType);
-static BOOL device_init_defrag_cb(PSDevice pDevice);
-static void device_init_diversity_timer(PSDevice pDevice);
+static int device_init_registers(struct vnt_private *pDevice,
+	DEVICE_INIT_TYPE InitType);
+static BOOL device_init_defrag_cb(struct vnt_private *pDevice);
+static void device_init_diversity_timer(struct vnt_private *pDevice);
 static int  device_dma0_tx_80211(struct sk_buff *skb, struct net_device *dev);
 
 static int  ethtool_ioctl(struct net_device *dev, void *useraddr);
-static void device_free_tx_bufs(PSDevice pDevice);
-static void device_free_rx_bufs(PSDevice pDevice);
-static void device_free_int_bufs(PSDevice pDevice);
-static void device_free_frag_bufs(PSDevice pDevice);
-static BOOL device_alloc_bufs(PSDevice pDevice);
-
-static int Read_config_file(PSDevice pDevice);
-static unsigned char *Config_FileOperation(PSDevice pDevice);
+static void device_free_tx_bufs(struct vnt_private *pDevice);
+static void device_free_rx_bufs(struct vnt_private *pDevice);
+static void device_free_int_bufs(struct vnt_private *pDevice);
+static void device_free_frag_bufs(struct vnt_private *pDevice);
+static BOOL device_alloc_bufs(struct vnt_private *pDevice);
+
+static int Read_config_file(struct vnt_private *pDevice);
+static unsigned char *Config_FileOperation(struct vnt_private *pDevice);
 static int Config_FileGetParameter(unsigned char *string,
 				   unsigned char *dest,
 				   unsigned char *source);
 

-static void usb_device_reset(PSDevice pDevice);
+static void usb_device_reset(struct vnt_private *pDevice);
 


@@ -254,7 +255,7 @@ static void usb_device_reset(PSDevice pDevice);
 

 static void
-device_set_options(PSDevice pDevice) {
+device_set_options(struct vnt_private *pDevice) {
 
     BYTE    abyBroadcastAddr[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
     BYTE    abySNAP_RFC1042[ETH_ALEN] = {0xAA, 0xAA, 0x03, 0x00, 0x00, 0x00};
@@ -292,7 +293,7 @@ device_set_options(PSDevice pDevice) {
 }
 

-static void device_init_diversity_timer(PSDevice pDevice)
+static void device_init_diversity_timer(struct vnt_private *pDevice)
 {
     init_timer(&pDevice->TimerSQ3Tmax1);
     pDevice->TimerSQ3Tmax1.data = (unsigned long)pDevice;
@@ -317,21 +318,21 @@ static void device_init_diversity_timer(PSDevice pDevice)
 // Initialization of MAC & BBP registers
 //
 
-static BOOL device_init_registers(PSDevice pDevice, DEVICE_INIT_TYPE InitType)
+static int device_init_registers(struct vnt_private *pDevice,
+	DEVICE_INIT_TYPE InitType)
 {
-    u8 abyBroadcastAddr[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
-    u8 abySNAP_RFC1042[ETH_ALEN] = {0xAA, 0xAA, 0x03, 0x00, 0x00, 0x00};
-    u8 abySNAP_Bridgetunnel[ETH_ALEN] = {0xAA, 0xAA, 0x03, 0x00, 0x00, 0xF8};
-    BYTE            byAntenna;
-    unsigned int            ii;
-    CMD_CARD_INIT   sInitCmd;
-    int ntStatus = STATUS_SUCCESS;
-    RSP_CARD_INIT   sInitRsp;
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
-    BYTE            byTmp;
-    BYTE            byCalibTXIQ = 0;
-    BYTE            byCalibTXDC = 0;
-    BYTE            byCalibRXIQ = 0;
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	u8 abyBroadcastAddr[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+	u8 abySNAP_RFC1042[ETH_ALEN] = {0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00};
+	u8 abySNAP_Bridgetunnel[ETH_ALEN]
+		= {0xaa, 0xaa, 0x03, 0x00, 0x00, 0xf8};
+	u8 byAntenna;
+	int ii;
+	CMD_CARD_INIT sInitCmd;
+	int ntStatus = STATUS_SUCCESS;
+	RSP_CARD_INIT   sInitRsp;
+	u8 byTmp;
+	u8 byCalibTXIQ = 0, byCalibTXDC = 0, byCalibRXIQ = 0;
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "---->INIbInitAdapter. [%d][%d]\n", InitType, pDevice->byPacketType);
 	spin_lock_irq(&pDevice->lock);
@@ -636,7 +637,7 @@ static BOOL device_init_registers(PSDevice pDevice, DEVICE_INIT_TYPE InitType)
 
 static int vt6656_suspend(struct usb_interface *intf, pm_message_t message)
 {
-	PSDevice device = usb_get_intfdata(intf);
+	struct vnt_private *device = usb_get_intfdata(intf);
 
 	if (!device || !device->dev)
 		return -ENODEV;
@@ -651,7 +652,7 @@ static int vt6656_suspend(struct usb_interface *intf, pm_message_t message)
 
 static int vt6656_resume(struct usb_interface *intf)
 {
-	PSDevice device = usb_get_intfdata(intf);
+	struct vnt_private *device = usb_get_intfdata(intf);
 
 	if (!device || !device->dev)
 		return -ENODEV;
@@ -682,13 +683,13 @@ vt6656_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	struct usb_device *udev = interface_to_usbdev(intf);
 	int rc = 0;
 	struct net_device *netdev = NULL;
-	PSDevice pDevice = NULL;
+	struct vnt_private *pDevice;
 
 	printk(KERN_NOTICE "%s Ver. %s\n", DEVICE_FULL_DRV_NAM, DEVICE_VERSION);
 	printk(KERN_NOTICE "Copyright (c) 2004 VIA Networking Technologies, Inc.\n");
 
 	udev = usb_get_dev(udev);
-	netdev = alloc_etherdev(sizeof(DEVICE_INFO));
+	netdev = alloc_etherdev(sizeof(struct vnt_private));
 	if (!netdev) {
 		printk(KERN_ERR DEVICE_NAME ": allocate net device failed\n");
 		rc = -ENOMEM;
@@ -696,7 +697,7 @@ vt6656_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	}
 
 	pDevice = netdev_priv(netdev);
-	memset(pDevice, 0, sizeof(DEVICE_INFO));
+	memset(pDevice, 0, sizeof(struct vnt_private));
 
 	pDevice->dev = netdev;
 	pDevice->usb = udev;
@@ -732,7 +733,7 @@ err_nomem:
 	return rc;
 }
 
-static void device_free_tx_bufs(PSDevice pDevice)
+static void device_free_tx_bufs(struct vnt_private *pDevice)
 {
     PUSB_SEND_CONTEXT pTxContext;
     int ii;
@@ -751,7 +752,7 @@ static void device_free_tx_bufs(PSDevice pDevice)
 }
 

-static void device_free_rx_bufs(PSDevice pDevice)
+static void device_free_rx_bufs(struct vnt_private *pDevice)
 {
     PRCB pRCB;
     int ii;
@@ -773,7 +774,7 @@ static void device_free_rx_bufs(PSDevice pDevice)
     return;
 }
 
-static void usb_device_reset(PSDevice pDevice)
+static void usb_device_reset(struct vnt_private *pDevice)
 {
  int status;
  status = usb_reset_device(pDevice->usb);
@@ -782,14 +783,15 @@ static void usb_device_reset(PSDevice pDevice)
 	return ;
 }
 
-static void device_free_int_bufs(PSDevice pDevice)
+static void device_free_int_bufs(struct vnt_private *pDevice)
 {
     kfree(pDevice->intBuf.pDataBuf);
     return;
 }
 

-static BOOL device_alloc_bufs(PSDevice pDevice) {
+static BOOL device_alloc_bufs(struct vnt_private *pDevice)
+{
 
     PUSB_SEND_CONTEXT pTxContext;
     PRCB pRCB;
@@ -888,9 +890,10 @@ free_tx:
 


-static BOOL device_init_defrag_cb(PSDevice pDevice) {
-    int i;
-    PSDeFragControlBlock pDeF;
+static BOOL device_init_defrag_cb(struct vnt_private *pDevice)
+{
+	int i;
+	PSDeFragControlBlock pDeF;
 
     /* Init the fragment ctl entries */
     for (i = 0; i < CB_MAX_RX_FRAG; i++) {
@@ -912,9 +915,10 @@ free_frag:
 


-static void device_free_frag_bufs(PSDevice pDevice) {
-    PSDeFragControlBlock pDeF;
-    int i;
+static void device_free_frag_bufs(struct vnt_private *pDevice)
+{
+	PSDeFragControlBlock pDeF;
+	int i;
 
     for (i = 0; i < CB_MAX_RX_FRAG; i++) {
 
@@ -927,7 +931,9 @@ static void device_free_frag_bufs(PSDevice pDevice) {
 


-BOOL device_alloc_frag_buf(PSDevice pDevice, PSDeFragControlBlock pDeF) {
+int device_alloc_frag_buf(struct vnt_private *pDevice,
+		PSDeFragControlBlock pDeF)
+{
 
     pDeF->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
     if (pDeF->skb == NULL)
@@ -941,8 +947,9 @@ BOOL device_alloc_frag_buf(PSDevice pDevice, PSDeFragControlBlock pDeF) {
 
 /*-----------------------------------------------------------------*/
 
-static int  device_open(struct net_device *dev) {
-    PSDevice    pDevice=(PSDevice) netdev_priv(dev);
+static int  device_open(struct net_device *dev)
+{
+	struct vnt_private *pDevice = netdev_priv(dev);
 
      pDevice->fWPA_Authened = FALSE;
 
@@ -1061,13 +1068,13 @@ free_rx_tx:
 


-static int  device_close(struct net_device *dev) {
-    PSDevice    pDevice=(PSDevice) netdev_priv(dev);
-    PSMgmtObject     pMgmt = &(pDevice->sMgmtObj);
-
-        int uu;
+static int device_close(struct net_device *dev)
+{
+	struct vnt_private *pDevice = netdev_priv(dev);
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	int uu;
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "device_close1 \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "device_close1\n");
     if (pDevice == NULL)
         return -ENODEV;
 
@@ -1136,7 +1143,7 @@ static int  device_close(struct net_device *dev) {
 
 static void vt6656_disconnect(struct usb_interface *intf)
 {
-	PSDevice device = usb_get_intfdata(intf);
+	struct vnt_private *device = usb_get_intfdata(intf);
 
 	if (!device)
 		return;
@@ -1156,7 +1163,7 @@ static void vt6656_disconnect(struct usb_interface *intf)
 
 static int device_dma0_tx_80211(struct sk_buff *skb, struct net_device *dev)
 {
-	PSDevice pDevice = netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 
 	spin_lock_irq(&pDevice->lock);
 
@@ -1172,7 +1179,7 @@ static int device_dma0_tx_80211(struct sk_buff *skb, struct net_device *dev)
 
 static int device_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-	PSDevice pDevice = netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	struct net_device_stats *stats = &pDevice->stats;
 
 	spin_lock_irq(&pDevice->lock);
@@ -1290,7 +1297,7 @@ static int Config_FileGetParameter(unsigned char *string,
 }
 
 //if read fail,return NULL,or return data pointer;
-static unsigned char *Config_FileOperation(PSDevice pDevice)
+static unsigned char *Config_FileOperation(struct vnt_private *pDevice)
 {
     unsigned char *config_path = CONFIG_PATH;
     unsigned char *buffer = NULL;
@@ -1354,10 +1361,11 @@ if(result!=0) {
 }
 
 //return --->-1:fail;  >=0:successful
-static int Read_config_file(PSDevice pDevice) {
-  int result = 0;
-  unsigned char tmpbuffer[100];
-  unsigned char *buffer = NULL;
+static int Read_config_file(struct vnt_private *pDevice)
+{
+	int result = 0;
+	unsigned char tmpbuffer[100];
+	unsigned char *buffer = NULL;
 
   //init config setting
  pDevice->config_file.ZoneType = -1;
@@ -1406,15 +1414,16 @@ static int Read_config_file(PSDevice pDevice) {
   return result;
 }
 
-static void device_set_multi(struct net_device *dev) {
-    PSDevice         pDevice = (PSDevice) netdev_priv(dev);
-    PSMgmtObject     pMgmt = &(pDevice->sMgmtObj);
-    u32              mc_filter[2];
-    int              ii;
-    struct netdev_hw_addr *ha;
-    BYTE             pbyData[8] = {0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff};
-    BYTE             byTmpMode = 0;
-    int              rc;
+static void device_set_multi(struct net_device *dev)
+{
+	struct vnt_private *pDevice = netdev_priv(dev);
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	struct netdev_hw_addr *ha;
+	u32 mc_filter[2];
+	int ii;
+	u8 pbyData[8] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+	u8 byTmpMode = 0;
+	int rc;
 

 	spin_lock_irq(&pDevice->lock);
@@ -1472,14 +1481,14 @@ static void device_set_multi(struct net_device *dev) {
 
 static struct net_device_stats *device_get_stats(struct net_device *dev)
 {
-    PSDevice pDevice=(PSDevice) netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 
-    return &pDevice->stats;
+	return &pDevice->stats;
 }
 
 static int device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 {
-	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	struct iwreq *wrq = (struct iwreq *) rq;
 	int rc = 0;
 
-- 
1.8.0





