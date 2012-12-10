Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:41308 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab2LJWGV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 17:06:21 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so1268765eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2012 14:06:20 -0800 (PST)
Message-ID: <1355177170.4680.20.camel@canaries64> (sfid-20121210_230625_269157_49A220B4)
Subject: [PATCH 05/11] staging: vt6656:  change bssdb/rxtx/wpa2 to new
 structures.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 10 Dec 2012 22:06:10 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This patch cleans up function declarations, definitions and local variables
were appropriate replacing types defined in "ttype.h" with linux/types.h.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/bssdb.c | 279 +++++++--------
 drivers/staging/vt6656/bssdb.h | 130 ++++---
 drivers/staging/vt6656/rxtx.c  | 757 +++++++++++++----------------------------
 drivers/staging/vt6656/rxtx.h  |  31 +-
 drivers/staging/vt6656/wpa2.c  |  19 +-
 5 files changed, 446 insertions(+), 770 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index d27469e..cf1add9 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -91,9 +91,9 @@ const WORD             awHWRetry1[5][5] = {
 
 /*---------------------  Static Functions  --------------------------*/
 
-void s_vCheckSensitivity(void *hDeviceContext);
-void s_vCheckPreEDThreshold(void *hDeviceContext);
-void s_uCalculateLinkQual(void *hDeviceContext);
+static void s_vCheckSensitivity(struct vnt_private *pDevice);
+static void s_vCheckPreEDThreshold(struct vnt_private *pDevice);
+static void s_uCalculateLinkQual(struct vnt_private *pDevice);
 
 /*---------------------  Export Variables  --------------------------*/
 
@@ -114,20 +114,19 @@ void s_uCalculateLinkQual(void *hDeviceContext);
  *
 -*/
 
-PKnownBSS BSSpSearchBSSList(void *hDeviceContext,
-			    PBYTE pbyDesireBSSID,
-			    PBYTE pbyDesireSSID,
-			    CARD_PHY_TYPE ePhyType)
+PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
+		u8 *pbyDesireBSSID, u8 *pbyDesireSSID,
+		CARD_PHY_TYPE ePhyType)
 {
-    PSDevice        pDevice = (PSDevice)hDeviceContext;
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
-    PBYTE           pbyBSSID = NULL;
-    PWLAN_IE_SSID   pSSID = NULL;
-    PKnownBSS       pCurrBSS = NULL;
-    PKnownBSS       pSelect = NULL;
-    BYTE                 ZeroBSSID[WLAN_BSSID_LEN]={0x00,0x00,0x00,0x00,0x00,0x00};
-    unsigned int ii = 0;
-    unsigned int jj = 0;
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	u8 *pbyBSSID = NULL;
+	PWLAN_IE_SSID pSSID = NULL;
+	PKnownBSS pCurrBSS = NULL;
+	PKnownBSS pSelect = NULL;
+	u8 ZeroBSSID[WLAN_BSSID_LEN] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
+	int ii = 0;
+	int jj = 0;
+
     if (pbyDesireBSSID != NULL) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 			"BSSpSearchBSSList BSSID[%pM]\n", pbyDesireBSSID);
@@ -263,11 +262,10 @@ pDevice->bSameBSSMaxNum = jj;
 -*/
 

-void BSSvClearBSSList(void *hDeviceContext, BOOL bKeepCurrBSSID)
+void BSSvClearBSSList(struct vnt_private *pDevice, int bKeepCurrBSSID)
 {
-    PSDevice     pDevice = (PSDevice)hDeviceContext;
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
-    unsigned int            ii;
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	int ii;
 
     for (ii = 0; ii < MAX_BSS_NUM; ii++) {
         if (bKeepCurrBSSID) {
@@ -299,14 +297,12 @@ void BSSvClearBSSList(void *hDeviceContext, BOOL bKeepCurrBSSID)
  *    TRUE if found.
  *
 -*/
-PKnownBSS BSSpAddrIsInBSSList(void *hDeviceContext,
-			      PBYTE abyBSSID,
-			      PWLAN_IE_SSID pSSID)
+PKnownBSS BSSpAddrIsInBSSList(struct vnt_private *pDevice,
+	u8 *abyBSSID, PWLAN_IE_SSID pSSID)
 {
-    PSDevice     pDevice = (PSDevice)hDeviceContext;
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
-    PKnownBSS       pBSSList = NULL;
-    unsigned int            ii;
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	PKnownBSS pBSSList = NULL;
+	int ii;
 
     for (ii = 0; ii < MAX_BSS_NUM; ii++) {
         pBSSList = &(pMgmt->sBSSList[ii]);
@@ -337,27 +333,27 @@ PKnownBSS BSSpAddrIsInBSSList(void *hDeviceContext,
  *
 -*/
 
-BOOL BSSbInsertToBSSList(void *hDeviceContext,
-			 PBYTE abyBSSIDAddr,
+int BSSbInsertToBSSList(struct vnt_private *pDevice,
+			u8 *abyBSSIDAddr,
 			u64 qwTimestamp,
-			 WORD wBeaconInterval,
-			 WORD wCapInfo,
-			 BYTE byCurrChannel,
-			 PWLAN_IE_SSID pSSID,
-			 PWLAN_IE_SUPP_RATES pSuppRates,
-			 PWLAN_IE_SUPP_RATES pExtSuppRates,
-			 PERPObject psERP,
-			 PWLAN_IE_RSN pRSN,
-			 PWLAN_IE_RSN_EXT pRSNWPA,
-			 PWLAN_IE_COUNTRY pIE_Country,
-			 PWLAN_IE_QUIET pIE_Quiet,
-			 unsigned int uIELength,
-			 PBYTE pbyIEs,
-			 void *pRxPacketContext)
+			u16 wBeaconInterval,
+			u16 wCapInfo,
+			u8 byCurrChannel,
+			PWLAN_IE_SSID pSSID,
+			PWLAN_IE_SUPP_RATES pSuppRates,
+			PWLAN_IE_SUPP_RATES pExtSuppRates,
+			PERPObject psERP,
+			PWLAN_IE_RSN pRSN,
+			PWLAN_IE_RSN_EXT pRSNWPA,
+			PWLAN_IE_COUNTRY pIE_Country,
+			PWLAN_IE_QUIET pIE_Quiet,
+			u32 uIELength,
+			u8 *pbyIEs,
+			void *pRxPacketContext)
 {
-	PSDevice pDevice = (PSDevice)hDeviceContext;
-	PSMgmtObject pMgmt = &pDevice->sMgmtObj;
-	PSRxMgmtPacket pRxPacket = (PSRxMgmtPacket)pRxPacketContext;
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	struct vnt_rx_mgmt *pRxPacket =
+		(struct vnt_rx_mgmt *)pRxPacketContext;
 	PKnownBSS pBSSList = NULL;
 	unsigned int ii;
 	int bParsingQuiet = FALSE;
@@ -513,28 +509,28 @@ BOOL BSSbInsertToBSSList(void *hDeviceContext,
 -*/
 // TODO: input structure modify
 
-BOOL BSSbUpdateToBSSList(void *hDeviceContext,
+int BSSbUpdateToBSSList(struct vnt_private *pDevice,
 			u64 qwTimestamp,
-			 WORD wBeaconInterval,
-			 WORD wCapInfo,
-			 BYTE byCurrChannel,
-			 BOOL bChannelHit,
-			 PWLAN_IE_SSID pSSID,
-			 PWLAN_IE_SUPP_RATES pSuppRates,
-			 PWLAN_IE_SUPP_RATES pExtSuppRates,
-			 PERPObject psERP,
-			 PWLAN_IE_RSN pRSN,
-			 PWLAN_IE_RSN_EXT pRSNWPA,
-			 PWLAN_IE_COUNTRY pIE_Country,
-			 PWLAN_IE_QUIET pIE_Quiet,
-			 PKnownBSS pBSSList,
-			 unsigned int uIELength,
-			 PBYTE pbyIEs,
-			 void *pRxPacketContext)
+			u16 wBeaconInterval,
+			u16 wCapInfo,
+			u8 byCurrChannel,
+			int bChannelHit,
+			PWLAN_IE_SSID pSSID,
+			PWLAN_IE_SUPP_RATES pSuppRates,
+			PWLAN_IE_SUPP_RATES pExtSuppRates,
+			PERPObject psERP,
+			PWLAN_IE_RSN pRSN,
+			PWLAN_IE_RSN_EXT pRSNWPA,
+			PWLAN_IE_COUNTRY pIE_Country,
+			PWLAN_IE_QUIET pIE_Quiet,
+			PKnownBSS pBSSList,
+			u32 uIELength,
+			u8 *pbyIEs,
+			void *pRxPacketContext)
 {
-	PSDevice pDevice = (PSDevice)hDeviceContext;
-	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
-	PSRxMgmtPacket pRxPacket = (PSRxMgmtPacket)pRxPacketContext;
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	struct vnt_rx_mgmt *pRxPacket =
+		(struct vnt_rx_mgmt *)pRxPacketContext;
 	signed long            ldBm, ldBmSum;
 	int bParsingQuiet = FALSE;
 	int ii, jj;
@@ -654,13 +650,11 @@ BOOL BSSbUpdateToBSSList(void *hDeviceContext,
  *
 -*/
 
-BOOL BSSbIsSTAInNodeDB(void *hDeviceContext,
-		       PBYTE abyDstAddr,
-		       unsigned int *puNodeIndex)
+int BSSbIsSTAInNodeDB(struct vnt_private *pDevice,
+		u8 *abyDstAddr, u32 *puNodeIndex)
 {
-    PSDevice        pDevice = (PSDevice)hDeviceContext;
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
-    unsigned int            ii;
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	unsigned int ii;
 
     // Index = 0 reserved for AP Node
     for (ii = 1; ii < (MAX_NODE_NUM + 1); ii++) {
@@ -688,15 +682,14 @@ BOOL BSSbIsSTAInNodeDB(void *hDeviceContext,
  *    None
  *
 -*/
-void BSSvCreateOneNode(void *hDeviceContext, unsigned int *puNodeIndex)
+void BSSvCreateOneNode(struct vnt_private *pDevice, u32 *puNodeIndex)
 {
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	int            ii;
+	u32 BigestCount = 0;
+	u32 SelectIndex;
+	struct sk_buff  *skb;
 
-    PSDevice     pDevice = (PSDevice)hDeviceContext;
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
-    unsigned int            ii;
-    unsigned int            BigestCount = 0;
-    unsigned int            SelectIndex;
-    struct sk_buff  *skb;
     // Index = 0 reserved for AP Node (In STA mode)
     // Index = 0 reserved for Broadcast/MultiCast (In AP mode)
     SelectIndex = 1;
@@ -749,13 +742,11 @@ void BSSvCreateOneNode(void *hDeviceContext, unsigned int *puNodeIndex)
  *
 -*/
 
-void BSSvRemoveOneNode(void *hDeviceContext, unsigned int uNodeIndex)
+void BSSvRemoveOneNode(struct vnt_private *pDevice, u32 uNodeIndex)
 {
-
-    PSDevice        pDevice = (PSDevice)hDeviceContext;
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
-    BYTE            byMask[8] = {1, 2, 4, 8, 0x10, 0x20, 0x40, 0x80};
-    struct sk_buff  *skb;
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	u8 byMask[8] = {1, 2, 4, 8, 0x10, 0x20, 0x40, 0x80};
+	struct sk_buff  *skb;
 

     while ((skb = skb_dequeue(&pMgmt->sNodeDBTable[uNodeIndex].sTxPSQueue)) != NULL)
@@ -776,14 +767,11 @@ void BSSvRemoveOneNode(void *hDeviceContext, unsigned int uNodeIndex)
  *
 -*/
 
-void BSSvUpdateAPNode(void *hDeviceContext,
-		      PWORD pwCapInfo,
-		      PWLAN_IE_SUPP_RATES pSuppRates,
-		      PWLAN_IE_SUPP_RATES pExtSuppRates)
+void BSSvUpdateAPNode(struct vnt_private *pDevice, u16 *pwCapInfo,
+	PWLAN_IE_SUPP_RATES pSuppRates, PWLAN_IE_SUPP_RATES pExtSuppRates)
 {
-    PSDevice     pDevice = (PSDevice)hDeviceContext;
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
-    unsigned int            uRateLen = WLAN_RATES_MAXLEN;
+	struct vnt_manager *pMgmt = &(pDevice->sMgmtObj);
+	u32 uRateLen = WLAN_RATES_MAXLEN;
 
     memset(&pMgmt->sNodeDBTable[0], 0, sizeof(KnownNodeDB));
 
@@ -828,10 +816,9 @@ void BSSvUpdateAPNode(void *hDeviceContext,
  *
 -*/
 
-void BSSvAddMulticastNode(void *hDeviceContext)
+void BSSvAddMulticastNode(struct vnt_private *pDevice)
 {
-    PSDevice     pDevice = (PSDevice)hDeviceContext;
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 
     if (!pDevice->bEnableHostWEP)
         memset(&pMgmt->sNodeDBTable[0], 0, sizeof(KnownNodeDB));
@@ -867,15 +854,14 @@ void BSSvAddMulticastNode(void *hDeviceContext)
  *
 -*/
 
-void BSSvSecondCallBack(void *hDeviceContext)
+void BSSvSecondCallBack(struct vnt_private *pDevice)
 {
-    PSDevice        pDevice = (PSDevice)hDeviceContext;
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
-    unsigned int            ii;
-    PWLAN_IE_SSID   pItemSSID, pCurrSSID;
-    unsigned int            uSleepySTACnt = 0;
-    unsigned int            uNonShortSlotSTACnt = 0;
-    unsigned int            uLongPreambleSTACnt = 0;
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	int ii;
+	PWLAN_IE_SSID pItemSSID, pCurrSSID;
+	u32 uSleepySTACnt = 0;
+	u32 uNonShortSlotSTACnt = 0;
+	u32 uLongPreambleSTACnt = 0;
 
     spin_lock_irq(&pDevice->lock);
 
@@ -921,7 +907,7 @@ if(pDevice->byReAssocCount > 0) {
 
  pMgmt->eLastState = pMgmt->eCurrState ;
 
-   s_uCalculateLinkQual((void *)pDevice);
+	s_uCalculateLinkQual(pDevice);
 
     for (ii = 0; ii < (MAX_NODE_NUM + 1); ii++) {
 
@@ -1061,8 +1047,8 @@ if(pDevice->byReAssocCount > 0) {
         if (pMgmt->sNodeDBTable[0].bActive) { // Assoc with BSS
 
             if (pDevice->bUpdateBBVGA) {
-		/* s_vCheckSensitivity((void *) pDevice); */
-		s_vCheckPreEDThreshold((void *) pDevice);
+		s_vCheckSensitivity(pDevice);
+		s_vCheckPreEDThreshold(pDevice);
             }
 
     	    if ((pMgmt->sNodeDBTable[0].uInActiveCount >= (LOST_BEACON_COUNT/2)) &&
@@ -1163,8 +1149,8 @@ else {
         if (pMgmt->eCurrState == WMAC_STATE_JOINTED) {
 
 		if (pDevice->bUpdateBBVGA) {
-			/* s_vCheckSensitivity((void *) pDevice); */
-			s_vCheckPreEDThreshold((void *) pDevice);
+			s_vCheckSensitivity(pDevice);
+			s_vCheckPreEDThreshold(pDevice);
 		}
         	if (pMgmt->sNodeDBTable[0].uInActiveCount >=ADHOC_LOST_BEACON_COUNT) {
         	    DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Lost other STA beacon [%d] sec, started !\n", pMgmt->sNodeDBTable[0].uInActiveCount);
@@ -1201,22 +1187,19 @@ else {
  *
 -*/
 
-void BSSvUpdateNodeTxCounter(void *hDeviceContext,
-			     PSStatCounter pStatistic,
-			     BYTE byTSR,
-			     BYTE byPktNO)
+void BSSvUpdateNodeTxCounter(struct vnt_private *pDevice,
+	PSStatCounter pStatistic, u8 byTSR, u8 byPktNO)
 {
-    PSDevice        pDevice = (PSDevice)hDeviceContext;
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
-    unsigned int            uNodeIndex = 0;
-    BYTE            byTxRetry;
-    WORD            wRate;
-    WORD            wFallBackRate = RATE_1M;
-    BYTE            byFallBack;
-    unsigned int            ii;
-    PBYTE           pbyDestAddr;
-    BYTE            byPktNum;
-    WORD            wFIFOCtl;
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	u32 uNodeIndex = 0;
+	u8 byTxRetry;
+	u16 wRate;
+	u16 wFallBackRate = RATE_1M;
+	u8 byFallBack;
+	int ii;
+	u8 *pbyDestAddr;
+	u8 byPktNum;
+	u16 wFIFOCtl;
 
     byPktNum = (byPktNO & 0x0F) >> 4;
     byTxRetry = (byTSR & 0xF0) >> 4;
@@ -1364,13 +1347,11 @@ void BSSvUpdateNodeTxCounter(void *hDeviceContext,
  *
 -*/
 
-void BSSvClearNodeDBTable(void *hDeviceContext,
-			  unsigned int uStartIndex)
+void BSSvClearNodeDBTable(struct vnt_private *pDevice, u32 uStartIndex)
 {
-    PSDevice     pDevice = (PSDevice)hDeviceContext;
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
-    struct sk_buff  *skb;
-    unsigned int            ii;
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	struct sk_buff  *skb;
+	int ii;
 
     for (ii = uStartIndex; ii < (MAX_NODE_NUM + 1); ii++) {
         if (pMgmt->sNodeDBTable[ii].bActive) {
@@ -1386,12 +1367,11 @@ void BSSvClearNodeDBTable(void *hDeviceContext,
     }
 };
 
-void s_vCheckSensitivity(void *hDeviceContext)
+static void s_vCheckSensitivity(struct vnt_private *pDevice)
 {
-    PSDevice        pDevice = (PSDevice)hDeviceContext;
-    PKnownBSS       pBSSList = NULL;
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
-    int             ii;
+	PKnownBSS pBSSList = NULL;
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	int ii;
 
     if ((pMgmt->eCurrState == WMAC_STATE_ASSOC) ||
         ((pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) && (pMgmt->eCurrState == WMAC_STATE_JOINTED))) {
@@ -1418,7 +1398,7 @@ void s_vCheckSensitivity(void *hDeviceContext)
                 if (pDevice->byBBVGANew != pDevice->byBBVGACurrent) {
                     pDevice->uBBVGADiffCount++;
                     if (pDevice->uBBVGADiffCount >= BB_VGA_CHANGE_THRESHOLD)
-			bScheduleCommand((void *) pDevice,
+			bScheduleCommand(pDevice,
 					 WLAN_CMD_CHANGE_BBSENSITIVITY,
 					 NULL);
                 } else {
@@ -1429,13 +1409,12 @@ void s_vCheckSensitivity(void *hDeviceContext)
     }
 }
 
-void s_uCalculateLinkQual(void *hDeviceContext)
+static void s_uCalculateLinkQual(struct vnt_private *pDevice)
 {
-   PSDevice        pDevice = (PSDevice)hDeviceContext;
-   unsigned long TxOkRatio, TxCnt;
-   unsigned long RxOkRatio, RxCnt;
-   unsigned long RssiRatio;
-   long ldBm;
+	unsigned long TxOkRatio, TxCnt;
+	unsigned long RxOkRatio, RxCnt;
+	unsigned long RssiRatio;
+	long ldBm;
 
 TxCnt = pDevice->scStatistic.TxNoRetryOkCount +
 	      pDevice->scStatistic.TxRetryOkCount +
@@ -1472,21 +1451,21 @@ else
    pDevice->scStatistic.TxRetryOkCount = 0;
 }
 
-void BSSvClearAnyBSSJoinRecord(void *hDeviceContext)
+void BSSvClearAnyBSSJoinRecord(struct vnt_private *pDevice)
 {
-    PSDevice        pDevice = (PSDevice)hDeviceContext;
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
-    unsigned int            ii;
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	int ii;
 
 	for (ii = 0; ii < MAX_BSS_NUM; ii++)
-        pMgmt->sBSSList[ii].bSelected = FALSE;
+		pMgmt->sBSSList[ii].bSelected = FALSE;
+
+	return;
 }
 
-void s_vCheckPreEDThreshold(void *hDeviceContext)
+static void s_vCheckPreEDThreshold(struct vnt_private *pDevice)
 {
-    PSDevice        pDevice = (PSDevice)hDeviceContext;
-    PKnownBSS       pBSSList = NULL;
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
+	PKnownBSS pBSSList = NULL;
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 
     if ((pMgmt->eCurrState == WMAC_STATE_ASSOC) ||
         ((pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) && (pMgmt->eCurrState == WMAC_STATE_JOINTED))) {
diff --git a/drivers/staging/vt6656/bssdb.h b/drivers/staging/vt6656/bssdb.h
index 125edc2..9b1bf6a 100644
--- a/drivers/staging/vt6656/bssdb.h
+++ b/drivers/staging/vt6656/bssdb.h
@@ -226,80 +226,70 @@ typedef struct tagKnownNodeDB {
 
 /*---------------------  Export Functions  --------------------------*/
 
-PKnownBSS BSSpSearchBSSList(void *hDeviceContext,
-			    PBYTE pbyDesireBSSID,
-			    PBYTE pbyDesireSSID,
-			    CARD_PHY_TYPE ePhyType);
+PKnownBSS BSSpSearchBSSList(struct vnt_private *, u8 *pbyDesireBSSID,
+	u8 *pbyDesireSSID, CARD_PHY_TYPE ePhyType);
 
-PKnownBSS BSSpAddrIsInBSSList(void *hDeviceContext,
-			      PBYTE abyBSSID,
-			      PWLAN_IE_SSID pSSID);
+PKnownBSS BSSpAddrIsInBSSList(struct vnt_private *, u8 *abyBSSID,
+	PWLAN_IE_SSID pSSID);
 
-void BSSvClearBSSList(void *hDeviceContext, BOOL bKeepCurrBSSID);
+void BSSvClearBSSList(struct vnt_private *, int bKeepCurrBSSID);
 
-BOOL BSSbInsertToBSSList(void *hDeviceContext,
-			 PBYTE abyBSSIDAddr,
+int BSSbInsertToBSSList(struct vnt_private *,
+			u8 *abyBSSIDAddr,
 			u64 qwTimestamp,
-			 WORD wBeaconInterval,
-			 WORD wCapInfo,
-			 BYTE byCurrChannel,
-			 PWLAN_IE_SSID pSSID,
-			 PWLAN_IE_SUPP_RATES pSuppRates,
-			 PWLAN_IE_SUPP_RATES pExtSuppRates,
-			 PERPObject psERP,
-			 PWLAN_IE_RSN pRSN,
-			 PWLAN_IE_RSN_EXT pRSNWPA,
-			 PWLAN_IE_COUNTRY pIE_Country,
-			 PWLAN_IE_QUIET pIE_Quiet,
-			 unsigned int uIELength,
-			 PBYTE pbyIEs,
-			 void *pRxPacketContext);
-
-BOOL BSSbUpdateToBSSList(void *hDeviceContext,
+			u16 wBeaconInterval,
+			u16 wCapInfo,
+			u8 byCurrChannel,
+			PWLAN_IE_SSID pSSID,
+			PWLAN_IE_SUPP_RATES pSuppRates,
+			PWLAN_IE_SUPP_RATES pExtSuppRates,
+			PERPObject psERP,
+			PWLAN_IE_RSN pRSN,
+			PWLAN_IE_RSN_EXT pRSNWPA,
+			PWLAN_IE_COUNTRY pIE_Country,
+			PWLAN_IE_QUIET pIE_Quiet,
+			u32 uIELength,
+			u8 *pbyIEs,
+			void *pRxPacketContext);
+
+int BSSbUpdateToBSSList(struct vnt_private *,
 			u64 qwTimestamp,
-			 WORD wBeaconInterval,
-			 WORD wCapInfo,
-			 BYTE byCurrChannel,
-			 BOOL bChannelHit,
-			 PWLAN_IE_SSID pSSID,
-			 PWLAN_IE_SUPP_RATES pSuppRates,
-			 PWLAN_IE_SUPP_RATES pExtSuppRates,
-			 PERPObject psERP,
-			 PWLAN_IE_RSN pRSN,
-			 PWLAN_IE_RSN_EXT pRSNWPA,
-			 PWLAN_IE_COUNTRY pIE_Country,
-			 PWLAN_IE_QUIET pIE_Quiet,
-			 PKnownBSS pBSSList,
-			 unsigned int uIELength,
-			 PBYTE pbyIEs,
-			 void *pRxPacketContext);
-
-BOOL BSSbIsSTAInNodeDB(void *hDeviceContext,
-		       PBYTE abyDstAddr,
-		       unsigned int *puNodeIndex);
-
-void BSSvCreateOneNode(void *hDeviceContext, unsigned int *puNodeIndex);
-
-void BSSvUpdateAPNode(void *hDeviceContext,
-		      PWORD pwCapInfo,
-		      PWLAN_IE_SUPP_RATES pItemRates,
-		      PWLAN_IE_SUPP_RATES pExtSuppRates);
-
-void BSSvSecondCallBack(void *hDeviceContext);
-
-void BSSvUpdateNodeTxCounter(void *hDeviceContext,
-			     PSStatCounter pStatistic,
-			     BYTE byTSR,
-			     BYTE byPktNO);
-
-void BSSvRemoveOneNode(void *hDeviceContext,
-		       unsigned int uNodeIndex);
-
-void BSSvAddMulticastNode(void *hDeviceContext);
-
-void BSSvClearNodeDBTable(void *hDeviceContext,
-			  unsigned int uStartIndex);
-
-void BSSvClearAnyBSSJoinRecord(void *hDeviceContext);
+			u16 wBeaconInterval,
+			u16 wCapInfo,
+			u8 byCurrChannel,
+			int bChannelHit,
+			PWLAN_IE_SSID pSSID,
+			PWLAN_IE_SUPP_RATES pSuppRates,
+			PWLAN_IE_SUPP_RATES pExtSuppRates,
+			PERPObject psERP,
+			PWLAN_IE_RSN pRSN,
+			PWLAN_IE_RSN_EXT pRSNWPA,
+			PWLAN_IE_COUNTRY pIE_Country,
+			PWLAN_IE_QUIET pIE_Quiet,
+			PKnownBSS pBSSList,
+			u32 uIELength,
+			u8 *pbyIEs,
+			void *pRxPacketContext);
+
+int BSSbIsSTAInNodeDB(struct vnt_private *, PBYTE abyDstAddr,
+	u32 *puNodeIndex);
+
+void BSSvCreateOneNode(struct vnt_private *, u32 *puNodeIndex);
+
+void BSSvUpdateAPNode(struct vnt_private *, u16 *pwCapInfo,
+	PWLAN_IE_SUPP_RATES pItemRates, PWLAN_IE_SUPP_RATES pExtSuppRates);
+
+void BSSvSecondCallBack(struct vnt_private *);
+
+void BSSvUpdateNodeTxCounter(struct vnt_private *, PSStatCounter pStatistic,
+	u8 byTSR, u8 byPktNO);
+
+void BSSvRemoveOneNode(struct vnt_private *, u32 uNodeIndex);
+
+void BSSvAddMulticastNode(struct vnt_private *);
+
+void BSSvClearNodeDBTable(struct vnt_private *, u32 uStartIndex);
+
+void BSSvClearAnyBSSJoinRecord(struct vnt_private *);
 
 #endif /* __BSSDB_H__ */
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 83c04e1..bb014c0 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -106,174 +106,64 @@ const WORD wFB_Opt1[2][5] = {
 
 /*---------------------  Static Functions  --------------------------*/
 
-static
-void
-s_vSaveTxPktInfo(
-     PSDevice pDevice,
-     BYTE byPktNum,
-     PBYTE pbyDestAddr,
-     WORD wPktLength,
-     WORD wFIFOCtl
-);
-
-static
-void *
-s_vGetFreeContext(
-    PSDevice pDevice
-    );
-
-
-static
-void
-s_vGenerateTxParameter(
-     PSDevice         pDevice,
-     BYTE             byPktType,
-     WORD             wCurrentRate,
-     void *pTxBufHead,
-     void *pvRrvTime,
-     void *pvRTS,
-     void *pvCTS,
-     unsigned int             cbFrameSize,
-     BOOL             bNeedACK,
-     unsigned int             uDMAIdx,
-     PSEthernetHeader psEthHeader
-    );
-
-
-static unsigned int s_uFillDataHead(
-     PSDevice pDevice,
-     BYTE     byPktType,
-     WORD     wCurrentRate,
-     void *pTxDataHead,
-     unsigned int     cbFrameLength,
-     unsigned int     uDMAIdx,
-     BOOL     bNeedAck,
-     unsigned int     uFragIdx,
-     unsigned int     cbLastFragmentSize,
-     unsigned int     uMACfragNum,
-     BYTE     byFBOption
-    );
-
-
-
-
-static
-void
-s_vGenerateMACHeader (
-     PSDevice         pDevice,
-     PBYTE            pbyBufferAddr,
-     WORD             wDuration,
-     PSEthernetHeader psEthHeader,
-     BOOL             bNeedEncrypt,
-     WORD             wFragType,
-     unsigned int             uDMAIdx,
-     unsigned int             uFragIdx
-    );
-
-static
-void
-s_vFillTxKey(
-      PSDevice   pDevice,
-      PBYTE      pbyBuf,
-      PBYTE      pbyIVHead,
-      PSKeyItem  pTransmitKey,
-      PBYTE      pbyHdrBuf,
-      WORD       wPayloadLen,
-     PBYTE      pMICHDR
-    );
-
-static
-void
-s_vSWencryption (
-      PSDevice         pDevice,
-      PSKeyItem        pTransmitKey,
-      PBYTE            pbyPayloadHead,
-      WORD             wPayloadSize
-    );
-
-static unsigned int s_uGetTxRsvTime(
-     PSDevice pDevice,
-     BYTE     byPktType,
-     unsigned int     cbFrameLength,
-     WORD     wRate,
-     BOOL     bNeedAck
-    );
-
-
-static unsigned int s_uGetRTSCTSRsvTime(
-     PSDevice pDevice,
-     BYTE byRTSRsvType,
-     BYTE byPktType,
-     unsigned int cbFrameLength,
-     WORD wCurrentRate
-    );
-
-static
-void
-s_vFillCTSHead (
-     PSDevice pDevice,
-     unsigned int     uDMAIdx,
-     BYTE     byPktType,
-     void *pvCTS,
-     unsigned int     cbFrameLength,
-     BOOL     bNeedAck,
-     BOOL     bDisCRC,
-     WORD     wCurrentRate,
-     BYTE     byFBOption
-    );
-
-static
-void
-s_vFillRTSHead(
-     PSDevice         pDevice,
-     BYTE             byPktType,
-     void *pvRTS,
-     unsigned int             cbFrameLength,
-     BOOL             bNeedAck,
-     BOOL             bDisCRC,
-     PSEthernetHeader psEthHeader,
-     WORD             wCurrentRate,
-     BYTE             byFBOption
-    );
-
-static unsigned int s_uGetDataDuration(
-     PSDevice pDevice,
-     BYTE     byDurType,
-     unsigned int     cbFrameLength,
-     BYTE     byPktType,
-     WORD     wRate,
-     BOOL     bNeedAck,
-     unsigned int     uFragIdx,
-     unsigned int     cbLastFragmentSize,
-     unsigned int     uMACfragNum,
-     BYTE     byFBOption
-    );
-
-
-static
-unsigned int
-s_uGetRTSCTSDuration (
-     PSDevice pDevice,
-     BYTE byDurType,
-     unsigned int cbFrameLength,
-     BYTE byPktType,
-     WORD wRate,
-     BOOL bNeedAck,
-     BYTE byFBOption
-    );
+static void s_vSaveTxPktInfo(struct vnt_private *pDevice, u8 byPktNum,
+	u8 *pbyDestAddr, u16 wPktLength, u16 wFIFOCtl);
+
+static void *s_vGetFreeContext(struct vnt_private *pDevice);
+
+static void s_vGenerateTxParameter(struct vnt_private *pDevice,
+	u8 byPktType, u16 wCurrentRate,	void *pTxBufHead, void *pvRrvTime,
+	void *pvRTS, void *pvCTS, u32 cbFrameSize, int bNeedACK, u32 uDMAIdx,
+	PSEthernetHeader psEthHeader);
+
+static u32 s_uFillDataHead(struct vnt_private *pDevice,
+	u8 byPktType, u16 wCurrentRate, void *pTxDataHead, u32 cbFrameLength,
+	u32 uDMAIdx, int bNeedAck, u32 uFragIdx, u32 cbLastFragmentSize,
+	u32 uMACfragNum, u8 byFBOption);
+
+
+static void s_vGenerateMACHeader(struct vnt_private *pDevice,
+	u8 *pbyBufferAddr, u16 wDuration, PSEthernetHeader psEthHeader,
+	int bNeedEncrypt, u16 wFragType, u32 uDMAIdx, u32 uFragIdx);
+
+static void s_vFillTxKey(struct vnt_private *pDevice, u8 *pbyBuf,
+	u8 *pbyIVHead, PSKeyItem pTransmitKey, u8 *pbyHdrBuf, u16 wPayloadLen,
+	u8 *pMICHDR);
+
+static void s_vSWencryption(struct vnt_private *pDevice,
+	PSKeyItem pTransmitKey, u8 *pbyPayloadHead, u16 wPayloadSize);
+
+static unsigned int s_uGetTxRsvTime(struct vnt_private *pDevice, u8 byPktType,
+	u32 cbFrameLength, u16 wRate, int bNeedAck);
+
+static u32 s_uGetRTSCTSRsvTime(struct vnt_private *pDevice, u8 byRTSRsvType,
+	u8 byPktType, u32 cbFrameLength, u16 wCurrentRate);
+
+static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
+	u8 byPktType, void *pvCTS, u32 cbFrameLength, int bNeedAck,
+	int bDisCRC, u16 wCurrentRate, u8 byFBOption);
+
+static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
+	void *pvRTS, u32 cbFrameLength, int bNeedAck, int bDisCRC,
+	PSEthernetHeader psEthHeader, u16 wCurrentRate, u8 byFBOption);
+
+static u32 s_uGetDataDuration(struct vnt_private *pDevice, u8 byDurType,
+	u32 cbFrameLength, u8 byPktType, u16 wRate, int bNeedAck,
+	u32 uFragIdx, u32 cbLastFragmentSize, u32 uMACfragNum,
+	u8 byFBOption);
+
+static unsigned int s_uGetRTSCTSDuration(struct vnt_private *pDevice,
+	u8 byDurType, u32 cbFrameLength, u8 byPktType, u16 wRate,
+	int bNeedAck, u8 byFBOption);
 

 /*---------------------  Export Variables  --------------------------*/
 
-static
-void *
-s_vGetFreeContext(
-    PSDevice pDevice
-    )
+static void *s_vGetFreeContext(struct vnt_private *pDevice)
 {
-    PUSB_SEND_CONTEXT   pContext = NULL;
-    PUSB_SEND_CONTEXT   pReturnContext = NULL;
-    unsigned int                ii;
+	PUSB_SEND_CONTEXT pContext = NULL;
+	PUSB_SEND_CONTEXT pReturnContext = NULL;
+	int ii;
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"GetFreeContext()\n");
 
@@ -292,11 +182,10 @@ s_vGetFreeContext(
 }
 

-static
-void
-s_vSaveTxPktInfo(PSDevice pDevice, BYTE byPktNum, PBYTE pbyDestAddr, WORD wPktLength, WORD wFIFOCtl)
+static void s_vSaveTxPktInfo(struct vnt_private *pDevice, u8 byPktNum,
+	u8 *pbyDestAddr, u16 wPktLength, u16 wFIFOCtl)
 {
-    PSStatCounter           pStatistic=&(pDevice->scStatistic);
+	PSStatCounter pStatistic = &pDevice->scStatistic;
 
     if (is_broadcast_ether_addr(pbyDestAddr))
         pStatistic->abyTxPktInfo[byPktNum].byBroadMultiUni = TX_PKT_BROAD;
@@ -312,24 +201,15 @@ s_vSaveTxPktInfo(PSDevice pDevice, BYTE byPktNum, PBYTE pbyDestAddr, WORD wPktLe
 	   ETH_ALEN);
 }
 
-static
-void
-s_vFillTxKey (
-      PSDevice   pDevice,
-      PBYTE      pbyBuf,
-      PBYTE      pbyIVHead,
-      PSKeyItem  pTransmitKey,
-      PBYTE      pbyHdrBuf,
-      WORD       wPayloadLen,
-     PBYTE      pMICHDR
-    )
+static void s_vFillTxKey(struct vnt_private *pDevice, u8 *pbyBuf,
+	u8 *pbyIVHead, PSKeyItem pTransmitKey, u8 *pbyHdrBuf,
+	u16 wPayloadLen, u8 *pMICHDR)
 {
-    PDWORD          pdwIV = (PDWORD) pbyIVHead;
-    PDWORD          pdwExtIV = (PDWORD) ((PBYTE)pbyIVHead+4);
-    WORD            wValue;
-    PS802_11Header  pMACHeader = (PS802_11Header)pbyHdrBuf;
-    DWORD           dwRevIVCounter;
-
+	u32 *pdwIV = (u32 *)pbyIVHead;
+	u32 *pdwExtIV = (u32 *)((u8 *)pbyIVHead + 4);
+	u16 wValue;
+	PS802_11Header pMACHeader = (PS802_11Header)pbyHdrBuf;
+	u32 dwRevIVCounter;
 

     //Fill TXKEY
@@ -430,18 +310,12 @@ s_vFillTxKey (
 }
 

-static
-void
-s_vSWencryption (
-      PSDevice            pDevice,
-      PSKeyItem           pTransmitKey,
-      PBYTE               pbyPayloadHead,
-      WORD                wPayloadSize
-    )
+static void s_vSWencryption(struct vnt_private *pDevice,
+	PSKeyItem pTransmitKey, u8 *pbyPayloadHead, u16 wPayloadSize)
 {
-    unsigned int   cbICVlen = 4;
-    DWORD  dwICV = 0xFFFFFFFFL;
-    PDWORD pdwICV;
+	u32 cbICVlen = 4;
+	u32 dwICV = 0xffffffff;
+	u32 *pdwICV;
 
     if (pTransmitKey == NULL)
         return;
@@ -479,17 +353,10 @@ s_vSWencryption (
              PK_TYPE_11GB    2
              PK_TYPE_11GA    3
 */
-static
-unsigned int
-s_uGetTxRsvTime (
-     PSDevice pDevice,
-     BYTE     byPktType,
-     unsigned int     cbFrameLength,
-     WORD     wRate,
-     BOOL     bNeedAck
-    )
+static u32 s_uGetTxRsvTime(struct vnt_private *pDevice, u8 byPktType,
+	u32 cbFrameLength, u16 wRate, int bNeedAck)
 {
-    unsigned int uDataTime, uAckTime;
+	u32 uDataTime, uAckTime;
 
     uDataTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, cbFrameLength, wRate);
     if (byPktType == PK_TYPE_11B) {//llb,CCK mode
@@ -507,17 +374,10 @@ s_uGetTxRsvTime (
 }
 
 //byFreqType: 0=>5GHZ 1=>2.4GHZ
-static
-unsigned int
-s_uGetRTSCTSRsvTime (
-     PSDevice pDevice,
-     BYTE byRTSRsvType,
-     BYTE byPktType,
-     unsigned int cbFrameLength,
-     WORD wCurrentRate
-    )
+static u32 s_uGetRTSCTSRsvTime(struct vnt_private *pDevice,
+	u8 byRTSRsvType, u8 byPktType, u32 cbFrameLength, u16 wCurrentRate)
 {
-    unsigned int uRrvTime  , uRTSTime, uCTSTime, uAckTime, uDataTime;
+	u32 uRrvTime, uRTSTime, uCTSTime, uAckTime, uDataTime;
 
     uRrvTime = uRTSTime = uCTSTime = uAckTime = uDataTime = 0;
 
@@ -549,23 +409,13 @@ s_uGetRTSCTSRsvTime (
 }
 
 //byFreqType 0: 5GHz, 1:2.4Ghz
-static
-unsigned int
-s_uGetDataDuration (
-     PSDevice pDevice,
-     BYTE     byDurType,
-     unsigned int     cbFrameLength,
-     BYTE     byPktType,
-     WORD     wRate,
-     BOOL     bNeedAck,
-     unsigned int     uFragIdx,
-     unsigned int     cbLastFragmentSize,
-     unsigned int     uMACfragNum,
-     BYTE     byFBOption
-    )
+static u32 s_uGetDataDuration(struct vnt_private *pDevice, u8 byDurType,
+	u32 cbFrameLength, u8 byPktType, u16 wRate, int bNeedAck,
+	u32 uFragIdx, u32 cbLastFragmentSize, u32 uMACfragNum,
+	u8 byFBOption)
 {
-    BOOL bLastFrag = 0;
-    unsigned int uAckTime = 0, uNextPktTime = 0;
+	int bLastFrag = 0;
+	u32 uAckTime = 0, uNextPktTime = 0;
 
     if (uFragIdx == (uMACfragNum-1)) {
         bLastFrag = 1;
@@ -718,19 +568,11 @@ s_uGetDataDuration (
 

 //byFreqType: 0=>5GHZ 1=>2.4GHZ
-static
-unsigned int
-s_uGetRTSCTSDuration (
-     PSDevice pDevice,
-     BYTE byDurType,
-     unsigned int cbFrameLength,
-     BYTE byPktType,
-     WORD wRate,
-     BOOL bNeedAck,
-     BYTE byFBOption
-    )
+static u32 s_uGetRTSCTSDuration(struct vnt_private *pDevice, u8 byDurType,
+	u32 cbFrameLength, u8 byPktType, u16 wRate, int bNeedAck,
+	u8 byFBOption)
 {
-    unsigned int uCTSTime = 0, uDurTime = 0;
+	u32 uCTSTime = 0, uDurTime = 0;
 

     switch (byDurType) {
@@ -814,24 +656,10 @@ s_uGetRTSCTSDuration (
 
 }
 
-
-
-
-static
-unsigned int
-s_uFillDataHead (
-     PSDevice pDevice,
-     BYTE     byPktType,
-     WORD     wCurrentRate,
-     void *pTxDataHead,
-     unsigned int     cbFrameLength,
-     unsigned int     uDMAIdx,
-     BOOL     bNeedAck,
-     unsigned int     uFragIdx,
-     unsigned int     cbLastFragmentSize,
-     unsigned int     uMACfragNum,
-     BYTE     byFBOption
-    )
+static u32 s_uFillDataHead(struct vnt_private *pDevice,
+	u8 byPktType, u16 wCurrentRate, void *pTxDataHead, u32 cbFrameLength,
+	u32 uDMAIdx, int bNeedAck, u32 uFragIdx, u32 cbLastFragmentSize,
+	u32 uMACfragNum, u8 byFBOption)
 {
 
     if (pTxDataHead == NULL) {
@@ -959,25 +787,12 @@ s_uFillDataHead (
     return 0;
 }
 
-
-
-
-static
-void
-s_vFillRTSHead (
-     PSDevice         pDevice,
-     BYTE             byPktType,
-     void *pvRTS,
-     unsigned int             cbFrameLength,
-     BOOL             bNeedAck,
-     BOOL             bDisCRC,
-     PSEthernetHeader psEthHeader,
-     WORD             wCurrentRate,
-     BYTE             byFBOption
-    )
+static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
+	void *pvRTS, u32 cbFrameLength, int bNeedAck, int bDisCRC,
+	PSEthernetHeader psEthHeader, u16 wCurrentRate, u8 byFBOption)
 {
-    unsigned int uRTSFrameLen = 20;
-    WORD  wLen = 0x0000;
+	u32 uRTSFrameLen = 20;
+	u16 wLen = 0;
 
     if (pvRTS == NULL)
     	return;
@@ -1190,22 +1005,12 @@ s_vFillRTSHead (
     }
 }
 
-static
-void
-s_vFillCTSHead (
-     PSDevice pDevice,
-     unsigned int     uDMAIdx,
-     BYTE     byPktType,
-     void *pvCTS,
-     unsigned int     cbFrameLength,
-     BOOL     bNeedAck,
-     BOOL     bDisCRC,
-     WORD     wCurrentRate,
-     BYTE     byFBOption
-    )
+static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
+	u8 byPktType, void *pvCTS, u32 cbFrameLength, int bNeedAck,
+	int bDisCRC, u16 wCurrentRate, u8 byFBOption)
 {
-    unsigned int uCTSFrameLen = 14;
-    WORD  wLen = 0x0000;
+	u32 uCTSFrameLen = 14;
+	u16 wLen = 0;
 
     if (pvCTS == NULL) {
         return;
@@ -1290,27 +1095,15 @@ s_vFillCTSHead (
  *
 -*/
 
-static
-void
-s_vGenerateTxParameter (
-     PSDevice         pDevice,
-     BYTE             byPktType,
-     WORD             wCurrentRate,
-     void *pTxBufHead,
-     void *pvRrvTime,
-     void *pvRTS,
-     void *pvCTS,
-     unsigned int             cbFrameSize,
-     BOOL             bNeedACK,
-     unsigned int             uDMAIdx,
-     PSEthernetHeader psEthHeader
-    )
+static void s_vGenerateTxParameter(struct vnt_private *pDevice,
+	u8 byPktType, u16 wCurrentRate,	void *pTxBufHead, void *pvRrvTime,
+	void *pvRTS, void *pvCTS, u32 cbFrameSize, int bNeedACK, u32 uDMAIdx,
+	PSEthernetHeader psEthHeader)
 {
-	unsigned int cbMACHdLen = WLAN_HDR_ADDR3_LEN; /* 24 */
-    WORD wFifoCtl;
-    BOOL bDisCRC = FALSE;
-    BYTE byFBOption = AUTO_FB_NONE;
-//    WORD wCurrentRate = pDevice->wCurrentRate;
+	u32 cbMACHdLen = WLAN_HDR_ADDR3_LEN; /* 24 */
+	u16 wFifoCtl;
+	int bDisCRC = FALSE;
+	u8 byFBOption = AUTO_FB_NONE;
 
     //DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"s_vGenerateTxParameter...\n");
     PSTxBufHead pFifoHead = (PSTxBufHead)pTxBufHead;
@@ -1407,52 +1200,37 @@ s_vGenerateTxParameter (
     unsigned int  cbFragmentSize,//Hdr+payoad+FCS
 */
 
-
-BOOL
-s_bPacketToWirelessUsb(
-      PSDevice         pDevice,
-      BYTE             byPktType,
-      PBYTE            usbPacketBuf,
-      BOOL             bNeedEncryption,
-      unsigned int             uSkbPacketLen,
-      unsigned int             uDMAIdx,
-      PSEthernetHeader psEthHeader,
-      PBYTE            pPacket,
-      PSKeyItem        pTransmitKey,
-      unsigned int             uNodeIndex,
-      WORD             wCurrentRate,
-     unsigned int             *pcbHeaderLen,
-     unsigned int             *pcbTotalLen
-    )
+static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
+	u8 *usbPacketBuf, int bNeedEncryption, u32 uSkbPacketLen, u32 uDMAIdx,
+	PSEthernetHeader psEthHeader, u8 *pPacket, PSKeyItem pTransmitKey,
+	u32 uNodeIndex, u16 wCurrentRate, u32 *pcbHeaderLen, u32 *pcbTotalLen)
 {
-    PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
-    unsigned int cbFrameSize, cbFrameBodySize;
-    PTX_BUFFER          pTxBufHead;
-    unsigned int cb802_1_H_len;
-    unsigned int cbIVlen = 0, cbICVlen = 0, cbMIClen = 0,
-	    cbMACHdLen = 0, cbFCSlen = 4;
-    unsigned int cbMICHDR = 0;
-    BOOL                bNeedACK,bRTS;
-    PBYTE               pbyType,pbyMacHdr,pbyIVHead,pbyPayloadHead,pbyTxBufferAddr;
-    BYTE abySNAP_RFC1042[ETH_ALEN] = {0xAA, 0xAA, 0x03, 0x00, 0x00, 0x00};
-    BYTE abySNAP_Bridgetunnel[ETH_ALEN] = {0xAA, 0xAA, 0x03, 0x00, 0x00, 0xF8};
-    unsigned int uDuration;
-    unsigned int cbHeaderLength = 0, uPadding = 0;
-    void *pvRrvTime;
-    PSMICHDRHead        pMICHDR;
-    void *pvRTS;
-    void *pvCTS;
-    void *pvTxDataHd;
-    BYTE                byFBOption = AUTO_FB_NONE,byFragType;
-    WORD                wTxBufSize;
-    DWORD               dwMICKey0,dwMICKey1,dwMIC_Priority,dwCRC;
-    PDWORD              pdwMIC_L,pdwMIC_R;
-    BOOL                bSoftWEP = FALSE;
-
-
-
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	u32 cbFrameSize, cbFrameBodySize;
+	PTX_BUFFER pTxBufHead;
+	u32 cb802_1_H_len;
+	u32 cbIVlen = 0, cbICVlen = 0, cbMIClen = 0, cbMACHdLen = 0;
+	u32 cbFCSlen = 4, cbMICHDR = 0;
+	int bNeedACK, bRTS;
+	u8 *pbyType, *pbyMacHdr, *pbyIVHead, *pbyPayloadHead, *pbyTxBufferAddr;
+	u8 abySNAP_RFC1042[ETH_ALEN] = {0xAA, 0xAA, 0x03, 0x00, 0x00, 0x00};
+	u8 abySNAP_Bridgetunnel[ETH_ALEN]
+		= {0xAA, 0xAA, 0x03, 0x00, 0x00, 0xF8};
+	u32 uDuration;
+	u32 cbHeaderLength = 0, uPadding = 0;
+	void *pvRrvTime;
+	PSMICHDRHead pMICHDR;
+	void *pvRTS;
+	void *pvCTS;
+	void *pvTxDataHd;
+	u8 byFBOption = AUTO_FB_NONE, byFragType;
+	u16 wTxBufSize;
+	u32 dwMICKey0, dwMICKey1, dwMIC_Priority, dwCRC;
+	u32 *pdwMIC_L, *pdwMIC_R;
+	int bSoftWEP = FALSE;
+
+	pvRrvTime = pMICHDR = pvRTS = pvCTS = pvTxDataHd = NULL;
 
-    pvRrvTime = pMICHDR = pvRTS = pvCTS = pvTxDataHd = NULL;
 	if (bNeedEncryption && pTransmitKey->pvKeyTable) {
 		if (((PSKeyTable)&pTransmitKey->pvKeyTable)->bSoftWEP == TRUE)
 			bSoftWEP = TRUE; /* WEP 256 */
@@ -1839,19 +1617,11 @@ s_bPacketToWirelessUsb(
  *
 -*/
 
-void
-s_vGenerateMACHeader (
-     PSDevice         pDevice,
-     PBYTE            pbyBufferAddr,
-     WORD             wDuration,
-     PSEthernetHeader psEthHeader,
-     BOOL             bNeedEncrypt,
-     WORD             wFragType,
-     unsigned int             uDMAIdx,
-     unsigned int             uFragIdx
-    )
+static void s_vGenerateMACHeader(struct vnt_private *pDevice,
+	u8 *pbyBufferAddr, u16 wDuration, PSEthernetHeader psEthHeader,
+	int bNeedEncrypt, u16 wFragType, u32 uDMAIdx, u32 uFragIdx)
 {
-    PS802_11Header  pMACHeader = (PS802_11Header)pbyBufferAddr;
+	PS802_11Header pMACHeader = (PS802_11Header)pbyBufferAddr;
 
     memset(pMACHeader, 0, (sizeof(S802_11Header)));  //- sizeof(pMACHeader->dwIV)));
 
@@ -1940,39 +1710,25 @@ s_vGenerateMACHeader (
  *
 -*/
 
-CMD_STATUS csMgmt_xmit(
-      PSDevice pDevice,
-      PSTxMgmtPacket pPacket
-    )
+CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
+	struct vnt_tx_mgmt *pPacket)
 {
-    BYTE            byPktType;
-    PBYTE           pbyTxBufferAddr;
-    void *pvRTS;
-    PSCTS           pCTS;
-    void *pvTxDataHd;
-    unsigned int            uDuration;
-    unsigned int            cbReqCount;
-    PS802_11Header  pMACHeader;
-    unsigned int            cbHeaderSize;
-    unsigned int            cbFrameBodySize;
-    BOOL            bNeedACK;
-    BOOL            bIsPSPOLL = FALSE;
-    PSTxBufHead     pTxBufHead;
-    unsigned int            cbFrameSize;
-    unsigned int            cbIVlen = 0;
-    unsigned int            cbICVlen = 0;
-    unsigned int            cbMIClen = 0;
-    unsigned int            cbFCSlen = 4;
-    unsigned int            uPadding = 0;
-    WORD            wTxBufSize;
-    unsigned int            cbMacHdLen;
-    SEthernetHeader sEthHeader;
-    void *pvRrvTime;
-    void *pMICHDR;
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
-    WORD            wCurrentRate = RATE_1M;
-    PTX_BUFFER          pTX_Buffer;
-    PUSB_SEND_CONTEXT   pContext;
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	PTX_BUFFER pTX_Buffer;
+	PSTxBufHead pTxBufHead;
+	PUSB_SEND_CONTEXT pContext;
+	PS802_11Header pMACHeader;
+	PSCTS pCTS;
+	SEthernetHeader sEthHeader;
+	u8 byPktType, *pbyTxBufferAddr;
+	void *pvRTS, *pvTxDataHd, *pvRrvTime, *pMICHDR;
+	u32 uDuration, cbReqCount, cbHeaderSize, cbFrameBodySize, cbFrameSize;
+	int bNeedACK, bIsPSPOLL = FALSE;
+	u32 cbIVlen = 0, cbICVlen = 0, cbMIClen = 0, cbFCSlen = 4;
+	u32 uPadding = 0;
+	u16 wTxBufSize;
+	u32 cbMacHdLen;
+	u16 wCurrentRate = RATE_1M;
 


@@ -2231,26 +1987,22 @@ CMD_STATUS csMgmt_xmit(
 }
 

-CMD_STATUS
-csBeacon_xmit(
-      PSDevice pDevice,
-      PSTxMgmtPacket pPacket
-    )
+CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice,
+	struct vnt_tx_mgmt *pPacket)
 {
-
-    unsigned int                cbFrameSize = pPacket->cbMPDULen + WLAN_FCS_LEN;
-    unsigned int                cbHeaderSize = 0;
-    WORD                wTxBufSize = sizeof(STxShortBufHead);
-    PSTxShortBufHead    pTxBufHead;
-    PS802_11Header      pMACHeader;
-    PSTxDataHead_ab     pTxDataHead;
-    WORD                wCurrentRate;
-    unsigned int                cbFrameBodySize;
-    unsigned int                cbReqCount;
-    PBEACON_BUFFER      pTX_Buffer;
-    PBYTE               pbyTxBufferAddr;
-    PUSB_SEND_CONTEXT   pContext;
-    CMD_STATUS          status;
+	u32 cbFrameSize = pPacket->cbMPDULen + WLAN_FCS_LEN;
+	u32 cbHeaderSize = 0;
+	u16 wTxBufSize = sizeof(STxShortBufHead);
+	PSTxShortBufHead pTxBufHead;
+	PS802_11Header pMACHeader;
+	PSTxDataHead_ab pTxDataHead;
+	u16 wCurrentRate;
+	u32 cbFrameBodySize;
+	u32 cbReqCount;
+	PBEACON_BUFFER pTX_Buffer;
+	u8 *pbyTxBufferAddr;
+	PUSB_SEND_CONTEXT pContext;
+	CMD_STATUS status;
 

     pContext = (PUSB_SEND_CONTEXT)s_vGetFreeContext(pDevice);
@@ -2321,56 +2073,38 @@ csBeacon_xmit(
 }
 

-
-
-
-void
-vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb) {
-
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
-    BYTE            byPktType;
-    PBYTE           pbyTxBufferAddr;
-    void *pvRTS;
-    void *pvCTS;
-    void *pvTxDataHd;
-    unsigned int            uDuration;
-    unsigned int            cbReqCount;
-    PS802_11Header  pMACHeader;
-    unsigned int            cbHeaderSize;
-    unsigned int            cbFrameBodySize;
-    BOOL            bNeedACK;
-    BOOL            bIsPSPOLL = FALSE;
-    PSTxBufHead     pTxBufHead;
-    unsigned int            cbFrameSize;
-    unsigned int            cbIVlen = 0;
-    unsigned int            cbICVlen = 0;
-    unsigned int            cbMIClen = 0;
-    unsigned int            cbFCSlen = 4;
-    unsigned int            uPadding = 0;
-    unsigned int            cbMICHDR = 0;
-    unsigned int            uLength = 0;
-    DWORD           dwMICKey0, dwMICKey1;
-    DWORD           dwMIC_Priority;
-    PDWORD          pdwMIC_L;
-    PDWORD          pdwMIC_R;
-    WORD            wTxBufSize;
-    unsigned int            cbMacHdLen;
-    SEthernetHeader sEthHeader;
-    void *pvRrvTime;
-    void *pMICHDR;
-    WORD            wCurrentRate = RATE_1M;
-    PUWLAN_80211HDR  p80211Header;
-    unsigned int             uNodeIndex = 0;
-    BOOL            bNodeExist = FALSE;
-    SKeyItem        STempKey;
-    PSKeyItem       pTransmitKey = NULL;
-    PBYTE           pbyIVHead;
-    PBYTE           pbyPayloadHead;
-    PBYTE           pbyMacHdr;
-    unsigned int            cbExtSuppRate = 0;
-    PTX_BUFFER          pTX_Buffer;
-    PUSB_SEND_CONTEXT   pContext;
-//    PWLAN_IE        pItem;
+void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
+{
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	u8 byPktType;
+	u8 *pbyTxBufferAddr;
+	void *pvRTS, *pvCTS, *pvTxDataHd;
+	u32 uDuration, cbReqCount;
+	PS802_11Header  pMACHeader;
+	u32 cbHeaderSize, cbFrameBodySize;
+	int bNeedACK, bIsPSPOLL = FALSE;
+	PSTxBufHead pTxBufHead;
+	u32 cbFrameSize;
+	u32 cbIVlen = 0, cbICVlen = 0, cbMIClen = 0, cbFCSlen = 4;
+	u32 uPadding = 0;
+	u32 cbMICHDR = 0, uLength = 0;
+	u32 dwMICKey0, dwMICKey1;
+	u32 dwMIC_Priority;
+	u32 *pdwMIC_L, *pdwMIC_R;
+	u16 wTxBufSize;
+	u32 cbMacHdLen;
+	SEthernetHeader sEthHeader;
+	void *pvRrvTime, *pMICHDR;
+	u32 wCurrentRate = RATE_1M;
+	PUWLAN_80211HDR  p80211Header;
+	u32 uNodeIndex = 0;
+	int bNodeExist = FALSE;
+	SKeyItem STempKey;
+	PSKeyItem pTransmitKey = NULL;
+	u8 *pbyIVHead, *pbyPayloadHead, *pbyMacHdr;
+	u32 cbExtSuppRate = 0;
+	PTX_BUFFER pTX_Buffer;
+	PUSB_SEND_CONTEXT pContext;
 

     pvRrvTime = pMICHDR = pvRTS = pvCTS = pvTxDataHd = NULL;
@@ -2729,29 +2463,30 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb) {
  * Return Value: NULL
  */
 
-int nsDMA_tx_packet(PSDevice pDevice, unsigned int uDMAIdx, struct sk_buff *skb)
+int nsDMA_tx_packet(struct vnt_private *pDevice,
+	u32 uDMAIdx, struct sk_buff *skb)
 {
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
-    unsigned int BytesToWrite = 0, uHeaderLen = 0;
-    unsigned int            uNodeIndex = 0;
-    BYTE            byMask[8] = {1, 2, 4, 8, 0x10, 0x20, 0x40, 0x80};
-    WORD            wAID;
-    BYTE            byPktType;
-    BOOL            bNeedEncryption = FALSE;
-    PSKeyItem       pTransmitKey = NULL;
-    SKeyItem        STempKey;
-    unsigned int            ii;
-    BOOL            bTKIP_UseGTK = FALSE;
-    BOOL            bNeedDeAuth = FALSE;
-    PBYTE           pbyBSSID;
-    BOOL            bNodeExist = FALSE;
-    PUSB_SEND_CONTEXT pContext;
-    BOOL            fConvertedPacket;
-    PTX_BUFFER      pTX_Buffer;
-    unsigned int            status;
-    WORD            wKeepRate = pDevice->wCurrentRate;
-    struct net_device_stats* pStats = &pDevice->stats;
-     BOOL            bTxeapol_key = FALSE;
+	struct net_device_stats *pStats = &pDevice->stats;
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	u32 BytesToWrite = 0, uHeaderLen = 0;
+	u32 uNodeIndex = 0;
+	u8 byMask[8] = {1, 2, 4, 8, 0x10, 0x20, 0x40, 0x80};
+	u16 wAID;
+	u8 byPktType;
+	int bNeedEncryption = FALSE;
+	PSKeyItem pTransmitKey = NULL;
+	SKeyItem STempKey;
+	int ii;
+	int bTKIP_UseGTK = FALSE;
+	int bNeedDeAuth = FALSE;
+	u8 *pbyBSSID;
+	int bNodeExist = FALSE;
+	PUSB_SEND_CONTEXT pContext;
+	BOOL fConvertedPacket;
+	PTX_BUFFER pTX_Buffer;
+	u32 status;
+	u16 wKeepRate = pDevice->wCurrentRate;
+	int bTxeapol_key = FALSE;
 

     if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
@@ -3125,28 +2860,22 @@ int nsDMA_tx_packet(PSDevice pDevice, unsigned int uDMAIdx, struct sk_buff *skb)
  * Return Value: Return TRUE if packet is copy to dma1; otherwise FALSE
  */
 
-
-BOOL
-bRelayPacketSend (
-      PSDevice pDevice,
-      PBYTE    pbySkbData,
-      unsigned int     uDataLen,
-      unsigned int     uNodeIndex
-    )
+int bRelayPacketSend(struct vnt_private *pDevice, u8 *pbySkbData, u32 uDataLen,
+	u32 uNodeIndex)
 {
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
-    unsigned int BytesToWrite = 0, uHeaderLen = 0;
-    BYTE            byPktType = PK_TYPE_11B;
-    BOOL            bNeedEncryption = FALSE;
-    SKeyItem        STempKey;
-    PSKeyItem       pTransmitKey = NULL;
-    PBYTE           pbyBSSID;
-    PUSB_SEND_CONTEXT   pContext;
-    BYTE            byPktTyp;
-    BOOL            fConvertedPacket;
-    PTX_BUFFER      pTX_Buffer;
-    unsigned int            status;
-    WORD            wKeepRate = pDevice->wCurrentRate;
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	u32 BytesToWrite = 0, uHeaderLen = 0;
+	u8 byPktType = PK_TYPE_11B;
+	int bNeedEncryption = FALSE;
+	SKeyItem STempKey;
+	PSKeyItem pTransmitKey = NULL;
+	u8 *pbyBSSID;
+	PUSB_SEND_CONTEXT pContext;
+	u8 byPktTyp;
+	int fConvertedPacket;
+	PTX_BUFFER pTX_Buffer;
+	u32 status;
+	u16 wKeepRate = pDevice->wCurrentRate;
 


diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index dd2198a..9f53702 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -665,30 +665,11 @@ typedef struct tagSBEACON_BUFFER
 
 /*---------------------  Export Functions  --------------------------*/
 
-BOOL
-bPacketToWirelessUsb(
-      PSDevice         pDevice,
-      BYTE             byPktType,
-      PBYTE            usbPacketBuf,
-      BOOL             bNeedEncrypt,
-      unsigned int             cbPayloadSize,
-      unsigned int             uDMAIdx,
-      PSEthernetHeader psEthHeader,
-      PBYTE            pPacket,
-      PSKeyItem        pTransmitKey,
-      unsigned int             uNodeIndex,
-      WORD             wCurrentRate,
-     unsigned int             *pcbHeaderLen,
-     unsigned int             *pcbTotalLen
-    );
-
-void vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb);
-int nsDMA_tx_packet(PSDevice pDevice,
-		    unsigned int uDMAIdx,
-		    struct sk_buff *skb);
-CMD_STATUS csMgmt_xmit(PSDevice pDevice, PSTxMgmtPacket pPacket);
-CMD_STATUS csBeacon_xmit(PSDevice pDevice, PSTxMgmtPacket pPacket);
-BOOL bRelayPacketSend(PSDevice pDevice, PBYTE pbySkbData,
-		      unsigned int uDataLen, unsigned int uNodeIndex);
+void vDMA0_tx_80211(struct vnt_private *, struct sk_buff *skb);
+int nsDMA_tx_packet(struct vnt_private *, u32 uDMAIdx, struct sk_buff *skb);
+CMD_STATUS csMgmt_xmit(struct vnt_private *, struct vnt_tx_mgmt *);
+CMD_STATUS csBeacon_xmit(struct vnt_private *, struct vnt_tx_mgmt *);
+int bRelayPacketSend(struct vnt_private *, u8 *pbySkbData, u32 uDataLen,
+	u32 uNodeIndex);
 
 #endif /* __RXTX_H__ */
diff --git a/drivers/staging/vt6656/wpa2.c b/drivers/staging/vt6656/wpa2.c
index 616e24d..99b4589 100644
--- a/drivers/staging/vt6656/wpa2.c
+++ b/drivers/staging/vt6656/wpa2.c
@@ -260,19 +260,16 @@ WPA2vParseRSN (
  * Return Value: length of IEs.
  *
 -*/
-unsigned int
-WPA2uSetIEs(void *pMgmtHandle,
-     PWLAN_IE_RSN pRSNIEs
-    )
+unsigned int WPA2uSetIEs(void *pMgmtHandle, PWLAN_IE_RSN pRSNIEs)
 {
-    PSMgmtObject    pMgmt = (PSMgmtObject) pMgmtHandle;
-    PBYTE           pbyBuffer = NULL;
-    unsigned int            ii = 0;
-    PWORD           pwPMKID = NULL;
+	struct vnt_manager *pMgmt = (struct vnt_manager *)pMgmtHandle;
+	u8 *pbyBuffer = NULL;
+	int ii = 0;
+	u16 *pwPMKID = NULL;
+
+	if (pRSNIEs == NULL)
+		return 0;
 
-    if (pRSNIEs == NULL) {
-        return(0);
-    }
     if (((pMgmt->eAuthenMode == WMAC_AUTH_WPA2) ||
          (pMgmt->eAuthenMode == WMAC_AUTH_WPA2PSK)) &&
         (pMgmt->pCurrBSS != NULL)) {
-- 
1.8.0




