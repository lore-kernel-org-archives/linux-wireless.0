Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:39840 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab2LJWJo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 17:09:44 -0500
Received: by mail-wg0-f46.google.com with SMTP id dr13so2049956wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2012 14:09:42 -0800 (PST)
Message-ID: <1355177375.4680.21.camel@canaries64> (sfid-20121210_230950_081794_2EA5BC08)
Subject: [PATCH 06/11] staging: vt6656: datarate/dpc/hostap/power use new
 structures.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 10 Dec 2012 22:09:35 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This patch cleans up function declarations, definitions and local variables
were appropriate replacing types defined in "ttype.h" with linux/types.h.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/datarate.c |  68 ++++-----
 drivers/staging/vt6656/datarate.h |  24 +---
 drivers/staging/vt6656/dpc.c      | 286 +++++++++++++-------------------------
 drivers/staging/vt6656/dpc.h      |  16 +--
 drivers/staging/vt6656/hostap.c   |  83 ++++++-----
 drivers/staging/vt6656/hostap.h   |   4 +-
 drivers/staging/vt6656/power.c    |  60 ++++----
 drivers/staging/vt6656/power.h    |  16 +--
 8 files changed, 210 insertions(+), 347 deletions(-)

diff --git a/drivers/staging/vt6656/datarate.c b/drivers/staging/vt6656/datarate.c
index 5c2719f..eefe7bb 100644
--- a/drivers/staging/vt6656/datarate.c
+++ b/drivers/staging/vt6656/datarate.c
@@ -188,28 +188,19 @@ RATEwGetRateIdx(
  * Return Value: none
  *
 -*/
-void RATEvParseMaxRate(
-     void *pDeviceHandler,
-     PWLAN_IE_SUPP_RATES pItemRates,
-     PWLAN_IE_SUPP_RATES pItemExtRates,
-     BOOL bUpdateBasicRate,
-     PWORD pwMaxBasicRate,
-     PWORD pwMaxSuppRate,
-     PWORD pwSuppRate,
-     PBYTE pbyTopCCKRate,
-     PBYTE pbyTopOFDMRate
-    )
-{
-PSDevice  pDevice = (PSDevice) pDeviceHandler;
-unsigned int  ii;
-BYTE  byHighSuppRate = 0;
-BYTE  byRate = 0;
-WORD  wOldBasicRate = pDevice->wBasicRate;
-unsigned int  uRateLen;
 
+void RATEvParseMaxRate(struct vnt_private *pDevice,
+	PWLAN_IE_SUPP_RATES pItemRates, PWLAN_IE_SUPP_RATES pItemExtRates,
+	int bUpdateBasicRate, u16 *pwMaxBasicRate, u16 *pwMaxSuppRate,
+	u16 *pwSuppRate, u8 *pbyTopCCKRate, u8 *pbyTopOFDMRate)
+{
+	int  ii;
+	u8 byHighSuppRate = 0, byRate = 0;
+	u16 wOldBasicRate = pDevice->wBasicRate;
+	u32 uRateLen;
 
-    if (pItemRates == NULL)
-        return;
+	if (pItemRates == NULL)
+		return;
 
     *pwSuppRate = 0;
     uRateLen = pItemRates->len;
@@ -301,27 +292,24 @@ unsigned int  uRateLen;
 #define AUTORATE_TXCNT_THRESHOLD        20
 #define AUTORATE_INC_THRESHOLD          30
 
-void
-RATEvTxRateFallBack(
-     void *pDeviceHandler,
-     PKnownNodeDB psNodeDBTable
-    )
+void RATEvTxRateFallBack(struct vnt_private *pDevice,
+	PKnownNodeDB psNodeDBTable)
 {
-PSDevice        pDevice = (PSDevice) pDeviceHandler;
-PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
-WORD            wIdxDownRate = 0;
-unsigned int            ii;
-BOOL            bAutoRate[MAX_RATE]    = {TRUE,TRUE,TRUE,TRUE,FALSE,FALSE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE};
-DWORD           dwThroughputTbl[MAX_RATE] = {10, 20, 55, 110, 60, 90, 120, 180, 240, 360, 480, 540};
-DWORD           dwThroughput = 0;
-WORD            wIdxUpRate = 0;
-DWORD           dwTxDiff = 0;
-
-    if (pMgmt->eScanState != WMAC_NO_SCANNING) {
-        // Don't do Fallback when scanning Channel
-        return;
-    }
-    psNodeDBTable->uTimeCount ++;
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	u16 wIdxDownRate = 0;
+	int ii;
+	int bAutoRate[MAX_RATE] = {TRUE, TRUE, TRUE, TRUE, FALSE, FALSE, TRUE,
+					 TRUE, TRUE, TRUE, TRUE, TRUE};
+	u32 dwThroughputTbl[MAX_RATE] = {10, 20, 55, 110, 60, 90, 120, 180,
+		240, 360, 480, 540};
+	u32 dwThroughput = 0;
+	u16 wIdxUpRate = 0;
+	u32 dwTxDiff = 0;
+
+	if (pMgmt->eScanState != WMAC_NO_SCANNING)
+		return; /* Don't do Fallback when scanning Channel */
+
+	psNodeDBTable->uTimeCount++;
 
     if (psNodeDBTable->uTxFail[MAX_RATE] > psNodeDBTable->uTxOk[MAX_RATE])
         dwTxDiff = psNodeDBTable->uTxFail[MAX_RATE] - psNodeDBTable->uTxOk[MAX_RATE];
diff --git a/drivers/staging/vt6656/datarate.h b/drivers/staging/vt6656/datarate.h
index c6f5163..1320507 100644
--- a/drivers/staging/vt6656/datarate.h
+++ b/drivers/staging/vt6656/datarate.h
@@ -29,6 +29,7 @@
 #ifndef __DATARATE_H__
 #define __DATARATE_H__
 
+
 /*---------------------  Export Definitions -------------------------*/
 
 #define FALLBACK_PKT_COLLECT_TR_H  50   // pkts
@@ -69,24 +70,13 @@
 


-void
-RATEvParseMaxRate(
-     void *pDeviceHandler,
-     PWLAN_IE_SUPP_RATES pItemRates,
-     PWLAN_IE_SUPP_RATES pItemExtRates,
-     BOOL bUpdateBasicRate,
-     PWORD pwMaxBasicRate,
-     PWORD pwMaxSuppRate,
-     PWORD pwSuppRate,
-     PBYTE pbyTopCCKRate,
-     PBYTE pbyTopOFDMRate
-    );
+void RATEvParseMaxRate(struct vnt_private *, PWLAN_IE_SUPP_RATES pItemRates,
+	PWLAN_IE_SUPP_RATES pItemExtRates, int bUpdateBasicRate,
+	u16 *pwMaxBasicRate, u16 *pwMaxSuppRate, u16 *pwSuppRate,
+	u8 *pbyTopCCKRate, u8 *pbyTopOFDMRate);
 
-void
-RATEvTxRateFallBack(
-     void *pDeviceHandler,
-     PKnownNodeDB psNodeDBTable
-    );
+void RATEvTxRateFallBack(struct vnt_private *pDevice,
+	PKnownNodeDB psNodeDBTable);
 
 BYTE
 RATEuSetIE(
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index 5d94faf..ac1e1b5 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -84,61 +84,23 @@ s_vGetDASA(
      PSEthernetHeader psEthHeader
     );
 
-static
-void
-s_vProcessRxMACHeader (
-      PSDevice pDevice,
-      PBYTE pbyRxBufferAddr,
-      unsigned int cbPacketSize,
-      BOOL bIsWEP,
-      BOOL bExtIV,
-     unsigned int *pcbHeadSize
-    );
-
-static BOOL s_bAPModeRxCtl(
-     PSDevice pDevice,
-     PBYTE    pbyFrame,
-     signed int      iSANodeIndex
-    );
-
-
-
-static BOOL s_bAPModeRxData (
-     PSDevice pDevice,
-     struct sk_buff *skb,
-     unsigned int     FrameSize,
-     unsigned int     cbHeaderOffset,
-     signed int      iSANodeIndex,
-     signed int      iDANodeIndex
-    );
+static void s_vProcessRxMACHeader(struct vnt_private *pDevice,
+	u8 *pbyRxBufferAddr, u32 cbPacketSize, int bIsWEP, int bExtIV,
+	u32 *pcbHeadSize);
 
+static int s_bAPModeRxCtl(struct vnt_private *pDevice, u8 *pbyFrame,
+	s32 iSANodeIndex);
 
-static BOOL s_bHandleRxEncryption(
-     PSDevice     pDevice,
-     PBYTE        pbyFrame,
-     unsigned int         FrameSize,
-     PBYTE        pbyRsr,
-     PBYTE       pbyNewRsr,
-     PSKeyItem   * pKeyOut,
-    int *       pbExtIV,
-     PWORD       pwRxTSC15_0,
-     PDWORD      pdwRxTSC47_16
-    );
-
-static BOOL s_bHostWepRxEncryption(
+static int s_bAPModeRxData(struct vnt_private *pDevice, struct sk_buff *skb,
+	u32 FrameSize, u32 cbHeaderOffset, s32 iSANodeIndex, s32 iDANodeIndex);
 
-     PSDevice     pDevice,
-     PBYTE        pbyFrame,
-     unsigned int         FrameSize,
-     PBYTE        pbyRsr,
-     BOOL         bOnFly,
-     PSKeyItem    pKey,
-     PBYTE       pbyNewRsr,
-    int *       pbExtIV,
-     PWORD       pwRxTSC15_0,
-     PDWORD      pdwRxTSC47_16
+static int s_bHandleRxEncryption(struct vnt_private *pDevice, u8 *pbyFrame,
+	u32 FrameSize, u8 *pbyRsr, u8 *pbyNewRsr, PSKeyItem *pKeyOut,
+	s32 *pbExtIV, u16 *pwRxTSC15_0, u32 *pdwRxTSC47_16);
 
-    );
+static int s_bHostWepRxEncryption(struct vnt_private *pDevice, u8 *pbyFrame,
+	u32 FrameSize, u8 *pbyRsr, int bOnFly, PSKeyItem pKey, u8 *pbyNewRsr,
+	s32 *pbExtIV, u16 *pwRxTSC15_0, u32 *pdwRxTSC47_16);
 
 /*---------------------  Export Variables  --------------------------*/
 
@@ -159,22 +121,16 @@ static BOOL s_bHostWepRxEncryption(
  * Return Value: None
  *
 -*/
-static
-void
-s_vProcessRxMACHeader (
-      PSDevice pDevice,
-      PBYTE pbyRxBufferAddr,
-      unsigned int cbPacketSize,
-      BOOL bIsWEP,
-      BOOL bExtIV,
-     unsigned int *pcbHeadSize
-    )
+
+static void s_vProcessRxMACHeader(struct vnt_private *pDevice,
+	u8 *pbyRxBufferAddr, u32 cbPacketSize, int bIsWEP, int bExtIV,
+	u32 *pcbHeadSize)
 {
-    PBYTE           pbyRxBuffer;
-    unsigned int            cbHeaderSize = 0;
-    PWORD           pwType;
-    PS802_11Header  pMACHeader;
-    int             ii;
+	u8 *pbyRxBuffer;
+	u32 cbHeaderSize = 0;
+	u16 *pwType;
+	PS802_11Header pMACHeader;
+	int ii;
 

     pMACHeader = (PS802_11Header) (pbyRxBufferAddr + cbHeaderSize);
@@ -310,55 +266,39 @@ s_vGetDASA (
 }
 

-
-
-BOOL
-RXbBulkInProcessData (
-     PSDevice         pDevice,
-     PRCB             pRCB,
-     unsigned long            BytesToIndicate
-    )
+int RXbBulkInProcessData(struct vnt_private *pDevice, PRCB pRCB,
+	unsigned long BytesToIndicate)
 {
-
-    struct net_device_stats* pStats=&pDevice->stats;
-    struct sk_buff* skb;
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
-    PSRxMgmtPacket  pRxPacket = &(pMgmt->sRxPacket);
-    PS802_11Header  p802_11Header;
-    PBYTE           pbyRsr;
-    PBYTE           pbyNewRsr;
-    PBYTE           pbyRSSI;
+	struct net_device_stats *pStats = &pDevice->stats;
+	struct sk_buff *skb;
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	struct vnt_rx_mgmt *pRxPacket = &pMgmt->sRxPacket;
+	PS802_11Header p802_11Header;
+	u8 *pbyRsr, *pbyNewRsr, *pbyRSSI, *pbyFrame;
 	u64 *pqwTSFTime;
-    PBYTE           pbyFrame;
-    BOOL            bDeFragRx = FALSE;
-    unsigned int            cbHeaderOffset;
+	u32 bDeFragRx = FALSE;
+	u32 cbHeaderOffset, cbIVOffset;
 	u32 FrameSize;
-    WORD            wEtherType = 0;
-    signed int             iSANodeIndex = -1;
-    signed int             iDANodeIndex = -1;
-    unsigned int            ii;
-    unsigned int            cbIVOffset;
-    PBYTE           pbyRxSts;
-    PBYTE           pbyRxRate;
-    PBYTE           pbySQ;
-    PBYTE           pby3SQ;
-    unsigned int            cbHeaderSize;
-    PSKeyItem       pKey = NULL;
-    WORD            wRxTSC15_0 = 0;
-    DWORD           dwRxTSC47_16 = 0;
-    SKeyItem        STempKey;
-    // 802.11h RPI
-    /* signed long ldBm = 0; */
-    BOOL            bIsWEP = FALSE;
-    BOOL            bExtIV = FALSE;
+	u16 wEtherType = 0;
+	s32 iSANodeIndex = -1, iDANodeIndex = -1;
+	int ii;
+	u8 *pbyRxSts, *pbyRxRate, *pbySQ, *pby3SQ;
+	u32 cbHeaderSize;
+	PSKeyItem pKey = NULL;
+	u16 wRxTSC15_0 = 0;
+	u32 dwRxTSC47_16 = 0;
+	SKeyItem STempKey;
+	/* signed long ldBm = 0; */
+	int bIsWEP = FALSE; int bExtIV = FALSE;
 	u32 dwWbkStatus;
-    PRCB            pRCBIndicate = pRCB;
-    PBYTE           pbyDAddress;
-    PWORD           pwPLCP_Length;
-    BYTE            abyVaildRate[MAX_RATE] = {2,4,11,22,12,18,24,36,48,72,96,108};
-    WORD            wPLCPwithPadding;
-    PS802_11Header  pMACHeader;
-    BOOL            bRxeapol_key = FALSE;
+	PRCB pRCBIndicate = pRCB;
+	u8 *pbyDAddress;
+	u16 *pwPLCP_Length;
+	u8 abyVaildRate[MAX_RATE]
+		= {2, 4, 11, 22, 12, 18, 24, 36, 48, 72, 96, 108};
+	u16 wPLCPwithPadding;
+	PS802_11Header pMACHeader;
+	int bRxeapol_key = FALSE;
 	u16 wLocalTSC15_0 = 0;
 	u32 dwLocalTSC47_16 = 0;
 	u64 RSC = 0;
@@ -984,16 +924,12 @@ RXbBulkInProcessData (
     return TRUE;
 }
 
-
-static BOOL s_bAPModeRxCtl (
-     PSDevice pDevice,
-     PBYTE    pbyFrame,
-     signed int      iSANodeIndex
-    )
+static int s_bAPModeRxCtl(struct vnt_private *pDevice, u8 *pbyFrame,
+	s32 iSANodeIndex)
 {
-    PS802_11Header      p802_11Header;
-    CMD_STATUS          Status;
-    PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
+	struct vnt_manager *pMgmt = &(pDevice->sMgmtObj);
+	PS802_11Header p802_11Header;
+	CMD_STATUS Status;
 

     if (IS_CTL_PSPOLL(pbyFrame) || !IS_TYPE_CONTROL(pbyFrame)) {
@@ -1095,24 +1031,16 @@ static BOOL s_bAPModeRxCtl (
 
 }
 
-static BOOL s_bHandleRxEncryption (
-     PSDevice     pDevice,
-     PBYTE        pbyFrame,
-     unsigned int         FrameSize,
-     PBYTE        pbyRsr,
-     PBYTE       pbyNewRsr,
-     PSKeyItem   * pKeyOut,
-    int *       pbExtIV,
-     PWORD       pwRxTSC15_0,
-     PDWORD      pdwRxTSC47_16
-    )
+static int s_bHandleRxEncryption(struct vnt_private *pDevice, u8 *pbyFrame,
+	u32 FrameSize, u8 *pbyRsr, u8 *pbyNewRsr, PSKeyItem *pKeyOut,
+	s32 *pbExtIV, u16 *pwRxTSC15_0, u32 *pdwRxTSC47_16)
 {
-    unsigned int            PayloadLen = FrameSize;
-    PBYTE           pbyIV;
-    BYTE            byKeyIdx;
-    PSKeyItem       pKey = NULL;
-    BYTE            byDecMode = KEY_CTL_WEP;
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	u32 PayloadLen = FrameSize;
+	u8 *pbyIV;
+	u8 byKeyIdx;
+	PSKeyItem pKey = NULL;
+	u8 byDecMode = KEY_CTL_WEP;
 

     *pwRxTSC15_0 = 0;
@@ -1240,31 +1168,19 @@ static BOOL s_bHandleRxEncryption (
     return TRUE;
 }
 
-
-static BOOL s_bHostWepRxEncryption (
-     PSDevice     pDevice,
-     PBYTE        pbyFrame,
-     unsigned int         FrameSize,
-     PBYTE        pbyRsr,
-     BOOL         bOnFly,
-     PSKeyItem    pKey,
-     PBYTE       pbyNewRsr,
-    int *       pbExtIV,
-     PWORD       pwRxTSC15_0,
-     PDWORD      pdwRxTSC47_16
-    )
+static int s_bHostWepRxEncryption(struct vnt_private *pDevice, u8 *pbyFrame,
+	u32 FrameSize, u8 *pbyRsr, int bOnFly, PSKeyItem pKey, u8 *pbyNewRsr,
+	s32 *pbExtIV, u16 *pwRxTSC15_0, u32 *pdwRxTSC47_16)
 {
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
-    unsigned int            PayloadLen = FrameSize;
-    PBYTE           pbyIV;
-    BYTE            byKeyIdx;
-    BYTE            byDecMode = KEY_CTL_WEP;
-    PS802_11Header  pMACHeader;
-
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	PS802_11Header  pMACHeader;
+	u32 PayloadLen = FrameSize;
+	u8 *pbyIV;
+	u8 byKeyIdx;
+	u8 byDecMode = KEY_CTL_WEP;
 
-
-    *pwRxTSC15_0 = 0;
-    *pdwRxTSC47_16 = 0;
+	*pwRxTSC15_0 = 0;
+	*pdwRxTSC47_16 = 0;
 
     pbyIV = pbyFrame + WLAN_HDR_ADDR3_LEN;
     if ( WLAN_GET_FC_TODS(*(PWORD)pbyFrame) &&
@@ -1371,26 +1287,16 @@ static BOOL s_bHostWepRxEncryption (
     return TRUE;
 }
 
-
-
-static BOOL s_bAPModeRxData (
-     PSDevice pDevice,
-     struct sk_buff *skb,
-     unsigned int     FrameSize,
-     unsigned int     cbHeaderOffset,
-     signed int      iSANodeIndex,
-     signed int      iDANodeIndex
-    )
-
+static int s_bAPModeRxData(struct vnt_private *pDevice, struct sk_buff *skb,
+	u32 FrameSize, u32 cbHeaderOffset, s32 iSANodeIndex, s32 iDANodeIndex)
 {
-    PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
-    BOOL                bRelayAndForward = FALSE;
-    BOOL                bRelayOnly = FALSE;
-    BYTE                byMask[8] = {1, 2, 4, 8, 0x10, 0x20, 0x40, 0x80};
-    WORD                wAID;
-
+	struct sk_buff *skbcpy;
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	int  bRelayAndForward = FALSE;
+	int bRelayOnly = FALSE;
+	u8 byMask[8] = {1, 2, 4, 8, 0x10, 0x20, 0x40, 0x80};
+	u16 wAID;
 
-    struct sk_buff* skbcpy = NULL;
 
     if (FrameSize > CB_MAX_BUF_SIZE)
         return FALSE;
@@ -1467,11 +1373,10 @@ static BOOL s_bAPModeRxData (
 


-void RXvWorkItem(void *Context)
+void RXvWorkItem(struct vnt_private *pDevice)
 {
-    PSDevice pDevice = (PSDevice) Context;
-    int ntStatus;
-    PRCB            pRCB=NULL;
+	int ntStatus;
+	PRCB pRCB = NULL;
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->Rx Polling Thread\n");
     spin_lock_irq(&pDevice->lock);
@@ -1491,13 +1396,9 @@ void RXvWorkItem(void *Context)
 }
 

-void
-RXvFreeRCB(
-     PRCB pRCB,
-     BOOL bReAllocSkb
-    )
+void RXvFreeRCB(PRCB pRCB, int bReAllocSkb)
 {
-    PSDevice pDevice = (PSDevice)pRCB->pDevice;
+	struct vnt_private *pDevice = pRCB->pDevice;
 

     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->RXvFreeRCB\n");
@@ -1536,12 +1437,11 @@ RXvFreeRCB(
 }
 

-void RXvMngWorkItem(void *Context)
+void RXvMngWorkItem(struct vnt_private *pDevice)
 {
-    PSDevice pDevice = (PSDevice) Context;
-    PRCB            pRCB=NULL;
-    PSRxMgmtPacket  pRxPacket;
-    BOOL            bReAllocSkb = FALSE;
+	PRCB pRCB = NULL;
+	struct vnt_rx_mgmt *pRxPacket;
+	int bReAllocSkb = FALSE;
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->Rx Mng Thread\n");
 
diff --git a/drivers/staging/vt6656/dpc.h b/drivers/staging/vt6656/dpc.h
index d4fca43..786c523 100644
--- a/drivers/staging/vt6656/dpc.h
+++ b/drivers/staging/vt6656/dpc.h
@@ -45,17 +45,9 @@ void RXvWorkItem(void *Context);
 
 void RXvMngWorkItem(void *Context);
 
-void
-RXvFreeRCB(
-     PRCB pRCB,
-     BOOL bReAllocSkb
-    );
-
-BOOL
-RXbBulkInProcessData(
-     PSDevice         pDevice,
-     PRCB             pRCB,
-     unsigned long            BytesToIndicate
-    );
+void RXvFreeRCB(PRCB pRCB, int bReAllocSkb);
+
+int RXbBulkInProcessData(struct vnt_private *, PRCB pRCB,
+	unsigned long BytesToIndicate);
 
 #endif /* __RXTX_H__ */
diff --git a/drivers/staging/vt6656/hostap.c b/drivers/staging/vt6656/hostap.c
index 3322855..432961c 100644
--- a/drivers/staging/vt6656/hostap.c
+++ b/drivers/staging/vt6656/hostap.c
@@ -60,13 +60,13 @@ static int          msglevel                =MSG_LEVEL_INFO;
  *
  */
 
-static int hostap_enable_hostapd(PSDevice pDevice, int rtnl_locked)
+static int hostap_enable_hostapd(struct vnt_private *pDevice, int rtnl_locked)
 {
-    PSDevice apdev_priv;
+	struct vnt_private *apdev_priv;
 	struct net_device *dev = pDevice->dev;
 	int ret;
 	const struct net_device_ops apdev_netdev_ops = {
-		.ndo_start_xmit         = pDevice->tx_80211,
+		.ndo_start_xmit = pDevice->tx_80211,
 	};
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%s: Enabling hostapd mode\n", dev->name);
@@ -120,7 +120,7 @@ static int hostap_enable_hostapd(PSDevice pDevice, int rtnl_locked)
  *
  */
 
-static int hostap_disable_hostapd(PSDevice pDevice, int rtnl_locked)
+static int hostap_disable_hostapd(struct vnt_private *pDevice, int rtnl_locked)
 {
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%s: disabling hostapd mode\n", pDevice->dev->name);
@@ -157,7 +157,8 @@ static int hostap_disable_hostapd(PSDevice pDevice, int rtnl_locked)
  *
  */
 
-int vt6656_hostap_set_hostapd(PSDevice pDevice, int val, int rtnl_locked)
+int vt6656_hostap_set_hostapd(struct vnt_private *pDevice,
+	int val, int rtnl_locked)
 {
 	if (val < 0 || val > 1)
 		return -EINVAL;
@@ -187,8 +188,8 @@ int vt6656_hostap_set_hostapd(PSDevice pDevice, int val, int rtnl_locked)
  * Return Value:
  *
  */
-static int hostap_remove_sta(PSDevice pDevice,
-				     struct viawget_hostapd_param *param)
+static int hostap_remove_sta(struct vnt_private *pDevice,
+	struct viawget_hostapd_param *param)
 {
 	unsigned int uNodeIndex;
 
@@ -215,16 +216,15 @@ static int hostap_remove_sta(PSDevice pDevice,
  * Return Value:
  *
  */
-static int hostap_add_sta(PSDevice pDevice,
-				  struct viawget_hostapd_param *param)
+static int hostap_add_sta(struct vnt_private *pDevice,
+	struct viawget_hostapd_param *param)
 {
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	unsigned int uNodeIndex;
 
+	if (!BSSbIsSTAInNodeDB(pDevice, param->sta_addr, &uNodeIndex))
+		BSSvCreateOneNode(pDevice, &uNodeIndex);
 
-    if (!BSSbIsSTAInNodeDB(pDevice, param->sta_addr, &uNodeIndex)) {
-        BSSvCreateOneNode((PSDevice)pDevice, &uNodeIndex);
-    }
     memcpy(pMgmt->sNodeDBTable[uNodeIndex].abyMACAddr, param->sta_addr, WLAN_ADDR_LEN);
     pMgmt->sNodeDBTable[uNodeIndex].eNodeState = NODE_ASSOC;
     pMgmt->sNodeDBTable[uNodeIndex].wCapInfo = param->u.add_sta.capability;
@@ -275,10 +275,10 @@ static int hostap_add_sta(PSDevice pDevice,
  *
  */
 
-static int hostap_get_info_sta(PSDevice pDevice,
-				       struct viawget_hostapd_param *param)
+static int hostap_get_info_sta(struct vnt_private *pDevice,
+	struct viawget_hostapd_param *param)
 {
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	unsigned int uNodeIndex;
 
     if (BSSbIsSTAInNodeDB(pDevice, param->sta_addr, &uNodeIndex)) {
@@ -308,10 +308,10 @@ static int hostap_get_info_sta(PSDevice pDevice,
  * Return Value:
  *
  */
-static int hostap_set_flags_sta(PSDevice pDevice,
-					struct viawget_hostapd_param *param)
+static int hostap_set_flags_sta(struct vnt_private *pDevice,
+		struct viawget_hostapd_param *param)
 {
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	unsigned int uNodeIndex;
 
     if (BSSbIsSTAInNodeDB(pDevice, param->sta_addr, &uNodeIndex)) {
@@ -342,10 +342,10 @@ static int hostap_set_flags_sta(PSDevice pDevice,
  * Return Value:
  *
  */
-static int hostap_set_generic_element(PSDevice pDevice,
+static int hostap_set_generic_element(struct vnt_private *pDevice,
 					struct viawget_hostapd_param *param)
 {
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 


@@ -388,7 +388,7 @@ static int hostap_set_generic_element(PSDevice pDevice,
  *
  */
 
-static void hostap_flush_sta(PSDevice pDevice)
+static void hostap_flush_sta(struct vnt_private *pDevice)
 {
     // reserved node index =0 for multicast node.
     BSSvClearNodeDBTable(pDevice, 1);
@@ -410,21 +410,20 @@ static void hostap_flush_sta(PSDevice pDevice)
  * Return Value:
  *
  */
-static int hostap_set_encryption(PSDevice pDevice,
-				       struct viawget_hostapd_param *param,
-				       int param_len)
+static int hostap_set_encryption(struct vnt_private *pDevice,
+	struct viawget_hostapd_param *param, int param_len)
 {
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
-    DWORD   dwKeyIndex = 0;
-    BYTE    abyKey[MAX_KEY_LEN];
-    BYTE    abySeq[MAX_KEY_LEN];
-    NDIS_802_11_KEY_RSC   KeyRSC;
-    BYTE    byKeyDecMode = KEY_CTL_WEP;
-	int     ret = 0;
-	int     iNodeIndex = -1;
-	int     ii;
-	BOOL    bKeyTableFull = FALSE;
-	WORD    wKeyCtl = 0;
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	u32 dwKeyIndex = 0;
+	u8 abyKey[MAX_KEY_LEN];
+	u8 abySeq[MAX_KEY_LEN];
+	NDIS_802_11_KEY_RSC   KeyRSC;
+	u8 byKeyDecMode = KEY_CTL_WEP;
+	int ret = 0;
+	s32 iNodeIndex = -1;
+	int ii;
+	int bKeyTableFull = FALSE;
+	u16 wKeyCtl = 0;
 

 	param->u.crypt.err = 0;
@@ -647,14 +646,14 @@ static int hostap_set_encryption(PSDevice pDevice,
  * Return Value:
  *
  */
-static int hostap_get_encryption(PSDevice pDevice,
+static int hostap_get_encryption(struct vnt_private *pDevice,
 				       struct viawget_hostapd_param *param,
 				       int param_len)
 {
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
-	int     ret = 0;
-	int     ii;
-	int     iNodeIndex =0;
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	int ret = 0;
+	int ii;
+	s32 iNodeIndex = 0;
 

 	param->u.crypt.err = 0;
@@ -692,7 +691,7 @@ static int hostap_get_encryption(PSDevice pDevice,
  *
  */
 
-int vt6656_hostap_ioctl(PSDevice pDevice, struct iw_point *p)
+int vt6656_hostap_ioctl(struct vnt_private *pDevice, struct iw_point *p)
 {
 	struct viawget_hostapd_param *param;
 	int ret = 0;
diff --git a/drivers/staging/vt6656/hostap.h b/drivers/staging/vt6656/hostap.h
index b660aee..f5656cd 100644
--- a/drivers/staging/vt6656/hostap.h
+++ b/drivers/staging/vt6656/hostap.h
@@ -61,7 +61,7 @@
 #define ARPHRD_IEEE80211 801
 #endif
 
-int vt6656_hostap_set_hostapd(PSDevice pDevice, int val, int rtnl_locked);
-int vt6656_hostap_ioctl(PSDevice pDevice, struct iw_point *p);
+int vt6656_hostap_set_hostapd(struct vnt_private *, int val, int rtnl_locked);
+int vt6656_hostap_ioctl(struct vnt_private *, struct iw_point *p);
 
 #endif /* __HOSTAP_H__ */
diff --git a/drivers/staging/vt6656/power.c b/drivers/staging/vt6656/power.c
index ab3a554..43965bc 100644
--- a/drivers/staging/vt6656/power.c
+++ b/drivers/staging/vt6656/power.c
@@ -70,12 +70,10 @@ static int msglevel = MSG_LEVEL_INFO;
  *
  */
 
-void PSvEnablePowerSaving(void *hDeviceContext,
-			  WORD wListenInterval)
+void PSvEnablePowerSaving(struct vnt_private *pDevice, u16 wListenInterval)
 {
-	PSDevice pDevice = (PSDevice)hDeviceContext;
-	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
-	WORD wAID = pMgmt->wCurrAID | BIT14 | BIT15;
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	u16 wAID = pMgmt->wCurrAID | BIT14 | BIT15;
 
 	/* set period of power up before TBTT */
 	MACvWriteWord(pDevice, MAC_REG_PWBT, C_PWBT);
@@ -136,10 +134,8 @@ void PSvEnablePowerSaving(void *hDeviceContext,
  *
  */
 
-void PSvDisablePowerSaving(void *hDeviceContext)
+void PSvDisablePowerSaving(struct vnt_private *pDevice)
 {
-	PSDevice pDevice = (PSDevice)hDeviceContext;
-	/* PSMgmtObject pMgmt = &(pDevice->sMgmtObj); */
 
 	/* disable power saving hw function */
 	CONTROLnsRequestOut(pDevice, MESSAGE_TYPE_DISABLE_PS, 0,
@@ -168,13 +164,11 @@ void PSvDisablePowerSaving(void *hDeviceContext)
  *    FALSE, if fail
  */
 
-BOOL PSbConsiderPowerDown(void *hDeviceContext,
-			  BOOL bCheckRxDMA,
-			  BOOL bCheckCountToWakeUp)
+int PSbConsiderPowerDown(struct vnt_private *pDevice, int bCheckRxDMA,
+	int bCheckCountToWakeUp)
 {
-	PSDevice pDevice = (PSDevice)hDeviceContext;
-	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
-	BYTE byData;
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	u8 byData;
 
 	/* check if already in Doze mode */
 	ControlvReadByte(pDevice, MESSAGE_REQUEST_MACREG,
@@ -225,15 +219,17 @@ BOOL PSbConsiderPowerDown(void *hDeviceContext,
  *
  */
 
-void PSvSendPSPOLL(void *hDeviceContext)
+void PSvSendPSPOLL(struct vnt_private *pDevice)
 {
-	PSDevice pDevice = (PSDevice)hDeviceContext;
-	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
-	PSTxMgmtPacket pTxPacket = NULL;
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	struct vnt_tx_mgmt *pTxPacket = NULL;
+
+	memset(pMgmt->pbyPSPacketPool, 0, sizeof(struct vnt_tx_mgmt)
+		+ WLAN_HDR_ADDR2_LEN);
+	pTxPacket = (struct vnt_tx_mgmt *)pMgmt->pbyPSPacketPool;
+	pTxPacket->p80211Header = (PUWLAN_80211HDR)((u8 *)pTxPacket
+		+ sizeof(struct vnt_tx_mgmt));
 
-	memset(pMgmt->pbyPSPacketPool, 0, sizeof(STxMgmtPacket) + WLAN_HDR_ADDR2_LEN);
-	pTxPacket = (PSTxMgmtPacket)pMgmt->pbyPSPacketPool;
-	pTxPacket->p80211Header = (PUWLAN_80211HDR)((PBYTE)pTxPacket + sizeof(STxMgmtPacket));
 	pTxPacket->p80211Header->sA2.wFrameCtl = cpu_to_le16(
 		(
 			WLAN_SET_FC_FTYPE(WLAN_TYPE_CTL) |
@@ -263,11 +259,10 @@ void PSvSendPSPOLL(void *hDeviceContext)
  *
  */
 
-BOOL PSbSendNullPacket(void *hDeviceContext)
+int PSbSendNullPacket(struct vnt_private *pDevice)
 {
-	PSDevice pDevice = (PSDevice)hDeviceContext;
-	PSTxMgmtPacket pTxPacket = NULL;
-	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+	struct vnt_tx_mgmt *pTxPacket = NULL;
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	u16 flags = 0;
 
 	if (pDevice->bLinkPass == FALSE)
@@ -278,9 +273,11 @@ BOOL PSbSendNullPacket(void *hDeviceContext)
 			return FALSE;
 	}
 
-	memset(pMgmt->pbyPSPacketPool, 0, sizeof(STxMgmtPacket) + WLAN_NULLDATA_FR_MAXLEN);
-	pTxPacket = (PSTxMgmtPacket)pMgmt->pbyPSPacketPool;
-	pTxPacket->p80211Header = (PUWLAN_80211HDR)((PBYTE)pTxPacket + sizeof(STxMgmtPacket));
+	memset(pMgmt->pbyPSPacketPool, 0, sizeof(struct vnt_tx_mgmt)
+		+ WLAN_NULLDATA_FR_MAXLEN);
+	pTxPacket = (struct vnt_tx_mgmt *)pMgmt->pbyPSPacketPool;
+	pTxPacket->p80211Header = (PUWLAN_80211HDR)((u8 *)pTxPacket
+		+ sizeof(struct vnt_tx_mgmt));
 
 	flags = WLAN_SET_FC_FTYPE(WLAN_TYPE_DATA) |
                         WLAN_SET_FC_FSTYPE(WLAN_FSTYPE_NULL);
@@ -318,11 +315,10 @@ BOOL PSbSendNullPacket(void *hDeviceContext)
  *
  */
 
-BOOL PSbIsNextTBTTWakeUp(void *hDeviceContext)
+int PSbIsNextTBTTWakeUp(struct vnt_private *pDevice)
 {
-	PSDevice pDevice = (PSDevice)hDeviceContext;
-	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
-	BOOL bWakeUp = FALSE;
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	int bWakeUp = FALSE;
 
 	if (pMgmt->wListenInterval >= 2) {
 		if (pMgmt->wCountToWakeUp == 0)
diff --git a/drivers/staging/vt6656/power.h b/drivers/staging/vt6656/power.h
index 41bffe5..879b10c 100644
--- a/drivers/staging/vt6656/power.h
+++ b/drivers/staging/vt6656/power.h
@@ -48,14 +48,12 @@
 /*  PSDevice pDevice */
 /*  PSDevice hDeviceContext */
 
-BOOL PSbConsiderPowerDown(void *hDeviceContext,
-			  BOOL bCheckRxDMA,
-			  BOOL bCheckCountToWakeUp);
-
-void PSvDisablePowerSaving(void *hDeviceContext);
-void PSvEnablePowerSaving(void *hDeviceContext, WORD wListenInterval);
-void PSvSendPSPOLL(void *hDeviceContext);
-BOOL PSbSendNullPacket(void *hDeviceContext);
-BOOL PSbIsNextTBTTWakeUp(void *hDeviceContext);
+int PSbConsiderPowerDown(struct vnt_private *, int bCheckRxDMA,
+	int bCheckCountToWakeUp);
+void PSvDisablePowerSaving(struct vnt_private *);
+void PSvEnablePowerSaving(struct vnt_private *, u16 wListenInterval);
+void PSvSendPSPOLL(struct vnt_private *);
+int PSbSendNullPacket(struct vnt_private *);
+int PSbIsNextTBTTWakeUp(struct vnt_private *);
 
 #endif /* __POWER_H__ */
-- 
1.8.0




