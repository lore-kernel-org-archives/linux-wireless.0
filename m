Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:35402 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbaHJOsD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Aug 2014 10:48:03 -0400
Received: by mail-wg0-f51.google.com with SMTP id b13so7560028wgh.22
        for <linux-wireless@vger.kernel.org>; Sun, 10 Aug 2014 07:47:59 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5/9] staging: vt6655: bssdb/datarate/dpc/power/rxtx use struct vnt_private
Date: Sun, 10 Aug 2014 15:46:59 +0100
Message-Id: <1407682023-2865-5-git-send-email-tvboxspy@gmail.com> (sfid-20140810_164937_275194_44FB10F2)
In-Reply-To: <1407682023-2865-1-git-send-email-tvboxspy@gmail.com>
References: <1407682023-2865-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replacing PSDevice.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/bssdb.c    | 32 +++++++++---------
 drivers/staging/vt6655/datarate.c |  4 +--
 drivers/staging/vt6655/dpc.c      | 23 +++++++------
 drivers/staging/vt6655/dpc.h      |  2 +-
 drivers/staging/vt6655/power.c    | 12 +++----
 drivers/staging/vt6655/rxtx.c     | 70 +++++++++++++++++++++------------------
 drivers/staging/vt6655/rxtx.h     | 22 +++++++-----
 7 files changed, 88 insertions(+), 77 deletions(-)

diff --git a/drivers/staging/vt6655/bssdb.c b/drivers/staging/vt6655/bssdb.c
index 0d6b27e..bb59b98 100644
--- a/drivers/staging/vt6655/bssdb.c
+++ b/drivers/staging/vt6655/bssdb.c
@@ -117,7 +117,7 @@ BSSpSearchBSSList(
 	CARD_PHY_TYPE  ePhyType
 )
 {
-	PSDevice        pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
 	unsigned char *pbyBSSID = NULL;
 	PWLAN_IE_SSID   pSSID = NULL;
@@ -240,7 +240,7 @@ BSSvClearBSSList(
 	bool bKeepCurrBSSID
 )
 {
-	PSDevice     pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
 	unsigned int ii;
 
@@ -280,7 +280,7 @@ BSSpAddrIsInBSSList(
 	PWLAN_IE_SSID pSSID
 )
 {
-	PSDevice     pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
 	PKnownBSS       pBSSList = NULL;
 	unsigned int ii;
@@ -333,7 +333,7 @@ BSSbInsertToBSSList(
 	void *pRxPacketContext
 )
 {
-	PSDevice     pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
 	PSRxMgmtPacket  pRxPacket = (PSRxMgmtPacket)pRxPacketContext;
 	PKnownBSS       pBSSList = NULL;
@@ -540,7 +540,7 @@ BSSbUpdateToBSSList(
 )
 {
 	int             ii;
-	PSDevice        pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
 	PSRxMgmtPacket  pRxPacket = (PSRxMgmtPacket)pRxPacketContext;
 	long            ldBm;
@@ -715,7 +715,7 @@ BSSDBbIsSTAInNodeDB(void *pMgmtObject, unsigned char *abyDstAddr,
 void
 BSSvCreateOneNode(void *hDeviceContext, unsigned int *puNodeIndex)
 {
-	PSDevice     pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
 	unsigned int ii;
 	unsigned int BigestCount = 0;
@@ -777,7 +777,7 @@ BSSvRemoveOneNode(
 	unsigned int uNodeIndex
 )
 {
-	PSDevice        pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
 	unsigned char byMask[8] = {1, 2, 4, 8, 0x10, 0x20, 0x40, 0x80};
 	struct sk_buff  *skb;
@@ -810,7 +810,7 @@ BSSvUpdateAPNode(
 	PWLAN_IE_SUPP_RATES pExtSuppRates
 )
 {
-	PSDevice     pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
 	unsigned int uRateLen = WLAN_RATES_MAXLEN;
 
@@ -861,7 +861,7 @@ BSSvAddMulticastNode(
 	void *hDeviceContext
 )
 {
-	PSDevice     pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
 
 	if (!pDevice->bEnableHostWEP)
@@ -904,7 +904,7 @@ BSSvSecondCallBack(
 	void *hDeviceContext
 )
 {
-	PSDevice        pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
 	unsigned int ii;
 	PWLAN_IE_SSID   pItemSSID, pCurrSSID;
@@ -1207,7 +1207,7 @@ BSSvUpdateNodeTxCounter(
 	unsigned int uFIFOHeaderSize
 )
 {
-	PSDevice        pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
 	unsigned int uNodeIndex = 0;
 	unsigned char byTxRetry = (byTsr0 & TSR0_NCR);
@@ -1360,7 +1360,7 @@ BSSvClearNodeDBTable(
 )
 
 {
-	PSDevice     pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
 	struct sk_buff  *skb;
 	unsigned int ii;
@@ -1385,7 +1385,7 @@ void s_vCheckSensitivity(
 	void *hDeviceContext
 )
 {
-	PSDevice        pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 	PKnownBSS       pBSSList = NULL;
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
 	int             ii;
@@ -1435,7 +1435,7 @@ BSSvClearAnyBSSJoinRecord(
 	void *hDeviceContext
 )
 {
-	PSDevice        pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
 	unsigned int ii;
 
@@ -1448,7 +1448,7 @@ void s_uCalculateLinkQual(
 	void *hDeviceContext
 )
 {
-	PSDevice        pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 	unsigned long TxOkRatio, TxCnt;
 	unsigned long RxOkRatio, RxCnt;
 	unsigned long RssiRatio;
@@ -1488,7 +1488,7 @@ void s_vCheckPreEDThreshold(
 	void *hDeviceContext
 )
 {
-	PSDevice        pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 	PKnownBSS       pBSSList = NULL;
 	PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
 
diff --git a/drivers/staging/vt6655/datarate.c b/drivers/staging/vt6655/datarate.c
index 565028c..d489fe4 100644
--- a/drivers/staging/vt6655/datarate.c
+++ b/drivers/staging/vt6655/datarate.c
@@ -195,7 +195,7 @@ RATEvParseMaxRate(
 	unsigned char *pbyTopOFDMRate
 )
 {
-	PSDevice  pDevice = (PSDevice) pDeviceHandler;
+	struct vnt_private *pDevice = pDeviceHandler;
 	unsigned int ii;
 	unsigned char byHighSuppRate = 0;
 	unsigned char byRate = 0;
@@ -295,7 +295,7 @@ RATEvTxRateFallBack(
 	PKnownNodeDB psNodeDBTable
 )
 {
-	PSDevice        pDevice = (PSDevice) pDeviceHandler;
+	struct vnt_private *pDevice = pDeviceHandler;
 	unsigned short wIdxDownRate = 0;
 	unsigned int ii;
 	bool bAutoRate[MAX_RATE]    = {true, true, true, true, false, false, true, true, true, true, true, true};
diff --git a/drivers/staging/vt6655/dpc.c b/drivers/staging/vt6655/dpc.c
index 4497419..d26ca96 100644
--- a/drivers/staging/vt6655/dpc.c
+++ b/drivers/staging/vt6655/dpc.c
@@ -79,18 +79,18 @@ s_vGetDASA(unsigned char *pbyRxBufferAddr, unsigned int *pcbHeaderSize,
 	   PSEthernetHeader psEthHeader);
 
 static void
-s_vProcessRxMACHeader(PSDevice pDevice, unsigned char *pbyRxBufferAddr,
+s_vProcessRxMACHeader(struct vnt_private *pDevice, unsigned char *pbyRxBufferAddr,
 		      unsigned int cbPacketSize, bool bIsWEP, bool bExtIV,
 		      unsigned int *pcbHeadSize);
 
 static bool s_bAPModeRxCtl(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	unsigned char *pbyFrame,
 	int      iSANodeIndex
 );
 
 static bool s_bAPModeRxData(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	struct sk_buff *skb,
 	unsigned int FrameSize,
 	unsigned int cbHeaderOffset,
@@ -99,7 +99,7 @@ static bool s_bAPModeRxData(
 );
 
 static bool s_bHandleRxEncryption(
-	PSDevice     pDevice,
+	struct vnt_private *pDevice,
 	unsigned char *pbyFrame,
 	unsigned int FrameSize,
 	unsigned char *pbyRsr,
@@ -112,7 +112,7 @@ static bool s_bHandleRxEncryption(
 
 static bool s_bHostWepRxEncryption(
 
-	PSDevice     pDevice,
+	struct vnt_private *pDevice,
 	unsigned char *pbyFrame,
 	unsigned int FrameSize,
 	unsigned char *pbyRsr,
@@ -145,7 +145,8 @@ static bool s_bHostWepRxEncryption(
  *
  -*/
 static void
-s_vProcessRxMACHeader(PSDevice pDevice, unsigned char *pbyRxBufferAddr,
+s_vProcessRxMACHeader(struct vnt_private *pDevice,
+		      unsigned char *pbyRxBufferAddr,
 		      unsigned int cbPacketSize, bool bIsWEP, bool bExtIV,
 		      unsigned int *pcbHeadSize)
 {
@@ -270,7 +271,7 @@ s_vGetDASA(unsigned char *pbyRxBufferAddr, unsigned int *pcbHeaderSize,
 
 bool
 device_receive_frame(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSRxDesc pCurrRD
 )
 {
@@ -871,7 +872,7 @@ device_receive_frame(
 }
 
 static bool s_bAPModeRxCtl(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	unsigned char *pbyFrame,
 	int      iSANodeIndex
 )
@@ -969,7 +970,7 @@ static bool s_bAPModeRxCtl(
 }
 
 static bool s_bHandleRxEncryption(
-	PSDevice     pDevice,
+	struct vnt_private *pDevice,
 	unsigned char *pbyFrame,
 	unsigned int FrameSize,
 	unsigned char *pbyRsr,
@@ -1106,7 +1107,7 @@ static bool s_bHandleRxEncryption(
 }
 
 static bool s_bHostWepRxEncryption(
-	PSDevice     pDevice,
+	struct vnt_private *pDevice,
 	unsigned char *pbyFrame,
 	unsigned int FrameSize,
 	unsigned char *pbyRsr,
@@ -1226,7 +1227,7 @@ static bool s_bHostWepRxEncryption(
 }
 
 static bool s_bAPModeRxData(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	struct sk_buff *skb,
 	unsigned int FrameSize,
 	unsigned int cbHeaderOffset,
diff --git a/drivers/staging/vt6655/dpc.h b/drivers/staging/vt6655/dpc.h
index 4914890..a068b84 100644
--- a/drivers/staging/vt6655/dpc.h
+++ b/drivers/staging/vt6655/dpc.h
@@ -35,7 +35,7 @@
 
 bool
 device_receive_frame(
-	PSDevice pDevice,
+	struct vnt_private *,
 	PSRxDesc pCurrRD
 );
 
diff --git a/drivers/staging/vt6655/power.c b/drivers/staging/vt6655/power.c
index f08c26f..de23f2d 100644
--- a/drivers/staging/vt6655/power.c
+++ b/drivers/staging/vt6655/power.c
@@ -74,7 +74,7 @@ PSvEnablePowerSaving(
 	unsigned short wListenInterval
 )
 {
-	PSDevice        pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
 	unsigned short wAID = pMgmt->wCurrAID | BIT14 | BIT15;
 
@@ -131,7 +131,7 @@ PSvDisablePowerSaving(
 	void *hDeviceContext
 )
 {
-	PSDevice        pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 
 	// disable power saving hw function
 	MACbPSWakeup(pDevice->PortOffset);
@@ -167,7 +167,7 @@ PSbConsiderPowerDown(
 	bool bCheckCountToWakeUp
 )
 {
-	PSDevice        pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
 	unsigned int uIdx;
 
@@ -229,7 +229,7 @@ PSvSendPSPOLL(
 	void *hDeviceContext
 )
 {
-	PSDevice            pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 	PSMgmtObject        pMgmt = pDevice->pMgmt;
 	PSTxMgmtPacket      pTxPacket = NULL;
 
@@ -266,7 +266,7 @@ PSbSendNullPacket(
 	void *hDeviceContext
 )
 {
-	PSDevice            pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 	PSTxMgmtPacket      pTxPacket = NULL;
 	PSMgmtObject        pMgmt = pDevice->pMgmt;
 	unsigned int uIdx;
@@ -336,7 +336,7 @@ PSbIsNextTBTTWakeUp(
 	void *hDeviceContext
 )
 {
-	PSDevice         pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 	PSMgmtObject        pMgmt = pDevice->pMgmt;
 	bool bWakeUp = false;
 
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 2270e2a..b625358 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -112,7 +112,7 @@ static const unsigned short wFB_Opt1[2][5] = {
 static
 void
 s_vFillTxKey(
-	PSDevice   pDevice,
+	struct vnt_private *pDevice,
 	unsigned char *pbyBuf,
 	unsigned char *pbyIVHead,
 	PSKeyItem  pTransmitKey,
@@ -124,7 +124,7 @@ s_vFillTxKey(
 static
 void
 s_vFillRTSHead(
-	PSDevice         pDevice,
+	struct vnt_private *pDevice,
 	unsigned char byPktType,
 	void *pvRTS,
 	unsigned int	cbFrameLength,
@@ -138,7 +138,7 @@ s_vFillRTSHead(
 static
 void
 s_vGenerateTxParameter(
-	PSDevice         pDevice,
+	struct vnt_private *pDevice,
 	unsigned char byPktType,
 	void *pTxBufHead,
 	void *pvRrvTime,
@@ -152,7 +152,7 @@ s_vGenerateTxParameter(
 );
 
 static void s_vFillFragParameter(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	unsigned char *pbyBuffer,
 	unsigned int	uTxType,
 	void *pvtdCurr,
@@ -161,15 +161,17 @@ static void s_vFillFragParameter(
 );
 
 static unsigned int
-s_cbFillTxBufHead(PSDevice pDevice, unsigned char byPktType, unsigned char *pbyTxBufferAddr,
-		  unsigned int cbFrameBodySize, unsigned int uDMAIdx, PSTxDesc pHeadTD,
-		  PSEthernetHeader psEthHeader, unsigned char *pPacket, bool bNeedEncrypt,
-		  PSKeyItem pTransmitKey, unsigned int uNodeIndex, unsigned int *puMACfragNum);
+s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
+		  unsigned char *pbyTxBufferAddr, unsigned int cbFrameBodySize,
+		  unsigned int uDMAIdx, PSTxDesc pHeadTD,
+		  PSEthernetHeader psEthHeader, unsigned char *pPacket,
+		  bool bNeedEncrypt, PSKeyItem pTransmitKey,
+		  unsigned int uNodeIndex, unsigned int *puMACfragNum);
 
 static
 unsigned int
 s_uFillDataHead(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	unsigned char byPktType,
 	void *pTxDataHead,
 	unsigned int cbFrameLength,
@@ -187,7 +189,7 @@ s_uFillDataHead(
 static
 void
 s_vFillTxKey(
-	PSDevice   pDevice,
+	struct vnt_private *pDevice,
 	unsigned char *pbyBuf,
 	unsigned char *pbyIVHead,
 	PSKeyItem  pTransmitKey,
@@ -300,7 +302,7 @@ s_vFillTxKey(
 static
 void
 s_vSWencryption(
-	PSDevice            pDevice,
+	struct vnt_private *pDevice,
 	PSKeyItem           pTransmitKey,
 	unsigned char *pbyPayloadHead,
 	unsigned short wPayloadSize
@@ -346,7 +348,7 @@ s_vSWencryption(
 static
 unsigned int
 s_uGetTxRsvTime(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	unsigned char byPktType,
 	unsigned int cbFrameLength,
 	unsigned short wRate,
@@ -371,7 +373,7 @@ s_uGetTxRsvTime(
 static
 unsigned int
 s_uGetRTSCTSRsvTime(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	unsigned char byRTSRsvType,
 	unsigned char byPktType,
 	unsigned int cbFrameLength,
@@ -409,7 +411,7 @@ s_uGetRTSCTSRsvTime(
 static
 unsigned int
 s_uGetDataDuration(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	unsigned char byDurType,
 	unsigned int cbFrameLength,
 	unsigned char byPktType,
@@ -568,7 +570,7 @@ s_uGetDataDuration(
 static
 unsigned int
 s_uGetRTSCTSDuration(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	unsigned char byDurType,
 	unsigned int cbFrameLength,
 	unsigned char byPktType,
@@ -661,7 +663,7 @@ s_uGetRTSCTSDuration(
 static
 unsigned int
 s_uFillDataHead(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	unsigned char byPktType,
 	void *pTxDataHead,
 	unsigned int cbFrameLength,
@@ -790,7 +792,7 @@ s_uFillDataHead(
 static
 void
 s_vFillRTSHead(
-	PSDevice         pDevice,
+	struct vnt_private *pDevice,
 	unsigned char byPktType,
 	void *pvRTS,
 	unsigned int cbFrameLength,
@@ -965,7 +967,7 @@ s_vFillRTSHead(
 static
 void
 s_vFillCTSHead(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	unsigned int uDMAIdx,
 	unsigned char byPktType,
 	void *pvCTS,
@@ -1063,7 +1065,7 @@ s_vFillCTSHead(
 static
 void
 s_vGenerateTxParameter(
-	PSDevice         pDevice,
+	struct vnt_private *pDevice,
 	unsigned char byPktType,
 	void *pTxBufHead,
 	void *pvRrvTime,
@@ -1169,7 +1171,7 @@ s_vGenerateTxParameter(
 static
 void
 s_vFillFragParameter(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	unsigned char *pbyBuffer,
 	unsigned int uTxType,
 	void *pvtdCurr,
@@ -1205,10 +1207,12 @@ s_vFillFragParameter(
 }
 
 static unsigned int
-s_cbFillTxBufHead(PSDevice pDevice, unsigned char byPktType, unsigned char *pbyTxBufferAddr,
-		  unsigned int cbFrameBodySize, unsigned int uDMAIdx, PSTxDesc pHeadTD,
-		  PSEthernetHeader psEthHeader, unsigned char *pPacket, bool bNeedEncrypt,
-		  PSKeyItem pTransmitKey, unsigned int uNodeIndex, unsigned int *puMACfragNum)
+s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
+		  unsigned char *pbyTxBufferAddr, unsigned int cbFrameBodySize,
+		  unsigned int uDMAIdx, PSTxDesc pHeadTD,
+		  PSEthernetHeader psEthHeader, unsigned char *pPacket,
+		  bool bNeedEncrypt, PSKeyItem pTransmitKey,
+		  unsigned int uNodeIndex, unsigned int *puMACfragNum)
 {
 	unsigned int cbMACHdLen;
 	unsigned int cbFrameSize;
@@ -1859,8 +1863,9 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byPktType, unsigned char *pbyT
 }
 
 void
-vGenerateFIFOHeader(PSDevice pDevice, unsigned char byPktType, unsigned char *pbyTxBufferAddr,
-		    bool bNeedEncrypt, unsigned int cbPayloadSize, unsigned int uDMAIdx,
+vGenerateFIFOHeader(struct vnt_private *pDevice, unsigned char byPktType,
+		    unsigned char *pbyTxBufferAddr, bool bNeedEncrypt,
+		    unsigned int cbPayloadSize, unsigned int uDMAIdx,
 		    PSTxDesc pHeadTD, PSEthernetHeader psEthHeader, unsigned char *pPacket,
 		    PSKeyItem pTransmitKey, unsigned int uNodeIndex, unsigned int *puMACfragNum,
 		    unsigned int *pcbHeaderSize)
@@ -1986,7 +1991,7 @@ vGenerateFIFOHeader(PSDevice pDevice, unsigned char byPktType, unsigned char *pb
 
 void
 vGenerateMACHeader(
-	PSDevice         pDevice,
+	struct vnt_private *pDevice,
 	unsigned char *pbyBufferAddr,
 	unsigned short wDuration,
 	PSEthernetHeader psEthHeader,
@@ -2049,7 +2054,7 @@ vGenerateMACHeader(
 		pMACHeader->wFrameCtl |= FC_MOREFRAG;
 }
 
-CMD_STATUS csMgmt_xmit(PSDevice pDevice, PSTxMgmtPacket pPacket)
+CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice, PSTxMgmtPacket pPacket)
 {
 	PSTxDesc        pFrstTD;
 	unsigned char byPktType;
@@ -2334,7 +2339,7 @@ CMD_STATUS csMgmt_xmit(PSDevice pDevice, PSTxMgmtPacket pPacket)
 	return CMD_STATUS_PENDING;
 }
 
-CMD_STATUS csBeacon_xmit(PSDevice pDevice, PSTxMgmtPacket pPacket)
+CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice, PSTxMgmtPacket pPacket)
 {
 	unsigned char byPktType;
 	unsigned char *pbyBuffer = (unsigned char *)pDevice->tx_beacon_bufs;
@@ -2408,7 +2413,7 @@ CMD_STATUS csBeacon_xmit(PSDevice pDevice, PSTxMgmtPacket pPacket)
 
 unsigned int
 cbGetFragCount(
-	PSDevice         pDevice,
+	struct vnt_private *pDevice,
 	PSKeyItem        pTransmitKey,
 	unsigned int cbFrameBodySize,
 	PSEthernetHeader psEthHeader
@@ -2485,8 +2490,9 @@ cbGetFragCount(
 	return uMACfragNum;
 }
 
-void
-vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb, unsigned char *pbMPDU, unsigned int cbMPDULen) {
+void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb,
+		    unsigned char *pbMPDU, unsigned int cbMPDULen)
+{
 	PSTxDesc        pFrstTD;
 	unsigned char byPktType;
 	unsigned char *pbyTxBufferAddr;
diff --git a/drivers/staging/vt6655/rxtx.h b/drivers/staging/vt6655/rxtx.h
index a9a8ede..26baf3b 100644
--- a/drivers/staging/vt6655/rxtx.h
+++ b/drivers/staging/vt6655/rxtx.h
@@ -58,7 +58,7 @@ struct vnt_mic_hdr {
 
 void
 vGenerateMACHeader(
-	PSDevice         pDevice,
+	struct vnt_private *,
 	unsigned char *pbyBufferAddr,
 	unsigned short wDuration,
 	PSEthernetHeader psEthHeader,
@@ -70,20 +70,24 @@ vGenerateMACHeader(
 
 unsigned int
 cbGetFragCount(
-	PSDevice         pDevice,
+	struct vnt_private *,
 	PSKeyItem        pTransmitKey,
 	unsigned int	cbFrameBodySize,
 	PSEthernetHeader psEthHeader
 );
 
 void
-vGenerateFIFOHeader(PSDevice pDevice, unsigned char byPktTyp, unsigned char *pbyTxBufferAddr,
-		    bool bNeedEncrypt, unsigned int	cbPayloadSize, unsigned int uDMAIdx, PSTxDesc pHeadTD,
-		    PSEthernetHeader psEthHeader, unsigned char *pPacket, PSKeyItem pTransmitKey,
-		    unsigned int uNodeIndex, unsigned int *puMACfragNum, unsigned int *pcbHeaderSize);
+vGenerateFIFOHeader(struct vnt_private *, unsigned char byPktTyp,
+		    unsigned char *pbyTxBufferAddr, bool bNeedEncrypt,
+		    unsigned int cbPayloadSize, unsigned int uDMAIdx,
+		    PSTxDesc pHeadTD, PSEthernetHeader psEthHeader,
+		    unsigned char *pPacket, PSKeyItem pTransmitKey,
+		    unsigned int uNodeIndex, unsigned int *puMACfragNum,
+		    unsigned int *pcbHeaderSize);
 
-void vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb, unsigned char *pbMPDU, unsigned int cbMPDULen);
-CMD_STATUS csMgmt_xmit(PSDevice pDevice, PSTxMgmtPacket pPacket);
-CMD_STATUS csBeacon_xmit(PSDevice pDevice, PSTxMgmtPacket pPacket);
+void vDMA0_tx_80211(struct vnt_private *, struct sk_buff *skb,
+		    unsigned char *pbMPDU, unsigned int cbMPDULen);
+CMD_STATUS csMgmt_xmit(struct vnt_private *, PSTxMgmtPacket pPacket);
+CMD_STATUS csBeacon_xmit(struct vnt_private *, PSTxMgmtPacket pPacket);
 
 #endif // __RXTX_H__
-- 
1.9.1

