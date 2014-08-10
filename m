Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:56588 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbaHJOr7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Aug 2014 10:47:59 -0400
Received: by mail-we0-f174.google.com with SMTP id x48so7480432wes.5
        for <linux-wireless@vger.kernel.org>; Sun, 10 Aug 2014 07:47:57 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/9] staging: vt6655: channel/wcmd/wctl/wmgr use struct vnt_private *
Date: Sun, 10 Aug 2014 15:46:58 +0100
Message-Id: <1407682023-2865-4-git-send-email-tvboxspy@gmail.com> (sfid-20140810_164804_827640_DE52892C)
In-Reply-To: <1407682023-2865-1-git-send-email-tvboxspy@gmail.com>
References: <1407682023-2865-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replacing PSDevice.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/channel.c |  10 ++--
 drivers/staging/vt6655/wcmd.c    |  28 ++++-----
 drivers/staging/vt6655/wctl.c    |   8 ++-
 drivers/staging/vt6655/wctl.h    |   6 +-
 drivers/staging/vt6655/wmgr.c    | 120 +++++++++++++++++++--------------------
 5 files changed, 87 insertions(+), 85 deletions(-)

diff --git a/drivers/staging/vt6655/channel.c b/drivers/staging/vt6655/channel.c
index d5b89b7..753d523 100644
--- a/drivers/staging/vt6655/channel.c
+++ b/drivers/staging/vt6655/channel.c
@@ -416,7 +416,7 @@ bool channel_get_list(unsigned int uCountryCodeIdx, unsigned char *pbyChannelTab
 
 void init_channel_table(void *pDeviceHandler)
 {
-	PSDevice    pDevice = (PSDevice) pDeviceHandler;
+	struct vnt_private *pDevice = pDeviceHandler;
 	bool bMultiBand = false;
 	unsigned int ii;
 
@@ -521,7 +521,7 @@ unsigned char get_channel_number(void *pDeviceHandler, unsigned char byChannelIn
  */
 bool set_channel(void *pDeviceHandler, unsigned int uConnectionChannel)
 {
-	PSDevice pDevice = (PSDevice) pDeviceHandler;
+	struct vnt_private *pDevice = pDeviceHandler;
 	bool bResult = true;
 
 	if (pDevice->byCurrentCh == uConnectionChannel)
@@ -583,7 +583,7 @@ bool set_channel(void *pDeviceHandler, unsigned int uConnectionChannel)
 
 void set_country_info(void *pDeviceHandler, CARD_PHY_TYPE ePHYType, void *pIE)
 {
-	PSDevice pDevice = (PSDevice) pDeviceHandler;
+	struct vnt_private *pDevice = pDeviceHandler;
 	unsigned int ii = 0;
 	unsigned int uu = 0;
 	unsigned int step = 0;
@@ -632,7 +632,7 @@ void set_country_info(void *pDeviceHandler, CARD_PHY_TYPE ePHYType, void *pIE)
 
 unsigned char set_support_channels(void *pDeviceHandler, unsigned char *pbyIEs)
 {
-	PSDevice pDevice = (PSDevice) pDeviceHandler;
+	struct vnt_private *pDevice = pDeviceHandler;
 	unsigned int ii;
 	unsigned char byCount;
 	PWLAN_IE_SUPP_CH pIE = (PWLAN_IE_SUPP_CH) pbyIEs;
@@ -703,7 +703,7 @@ unsigned char set_support_channels(void *pDeviceHandler, unsigned char *pbyIEs)
 
 void set_country_IE(void *pDeviceHandler, void *pIE)
 {
-	PSDevice pDevice = (PSDevice) pDeviceHandler;
+	struct vnt_private *pDevice = pDeviceHandler;
 	unsigned int ii;
 	PWLAN_IE_COUNTRY pIECountry = (PWLAN_IE_COUNTRY) pIE;
 
diff --git a/drivers/staging/vt6655/wcmd.c b/drivers/staging/vt6655/wcmd.c
index b7e68a0..0045f7f 100644
--- a/drivers/staging/vt6655/wcmd.c
+++ b/drivers/staging/vt6655/wcmd.c
@@ -65,13 +65,13 @@ static int msglevel = MSG_LEVEL_INFO;
 static
 void
 s_vProbeChannel(
-	PSDevice pDevice
+	struct vnt_private *pDevice
 );
 
 static
 PSTxMgmtPacket
 s_MgrMakeProbeRequest(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	unsigned char *pScanBSSID,
 	PWLAN_IE_SSID pSSID,
@@ -82,7 +82,7 @@ s_MgrMakeProbeRequest(
 static
 bool
 s_bCommandComplete(
-	PSDevice pDevice
+	struct vnt_private *pDevice
 );
 
 /*---------------------  Export Variables  --------------------------*/
@@ -104,7 +104,7 @@ s_bCommandComplete(
  */
 static
 void
-vAdHocBeaconStop(PSDevice  pDevice)
+vAdHocBeaconStop(struct vnt_private *pDevice)
 {
 	PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
 	bool bStop;
@@ -151,7 +151,7 @@ vAdHocBeaconStop(PSDevice  pDevice)
  */
 static
 void
-vAdHocBeaconRestart(PSDevice pDevice)
+vAdHocBeaconRestart(struct vnt_private *pDevice)
 {
 	PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
 
@@ -181,7 +181,7 @@ vAdHocBeaconRestart(PSDevice pDevice)
 static
 void
 s_vProbeChannel(
-	PSDevice pDevice
+	struct vnt_private *pDevice
 )
 {
 	//1M,   2M,   5M,   11M,  18M,  24M,  36M,  54M
@@ -236,7 +236,7 @@ s_vProbeChannel(
 
 static PSTxMgmtPacket
 s_MgrMakeProbeRequest(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	unsigned char *pScanBSSID,
 	PWLAN_IE_SSID pSSID,
@@ -287,7 +287,7 @@ vCommandTimerWait(
 	unsigned int MSecond
 )
 {
-	PSDevice        pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 
 	init_timer(&pDevice->sTimerCommand);
 	pDevice->sTimerCommand.data = (unsigned long) pDevice;
@@ -302,7 +302,7 @@ vCommandTimer(
 	void *hDeviceContext
 )
 {
-	PSDevice        pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
 	PWLAN_IE_SSID   pItemSSID;
 	PWLAN_IE_SSID   pItemSSIDCurr;
@@ -801,7 +801,7 @@ vCommandTimer(
 static
 bool
 s_bCommandComplete(
-	PSDevice pDevice
+	struct vnt_private *pDevice
 )
 {
 	PWLAN_IE_SSID pSSID;
@@ -875,7 +875,7 @@ bool bScheduleCommand(
 	unsigned char *pbyItem0
 )
 {
-	PSDevice        pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 
 	if (pDevice->cbFreeCmdQueue == 0)
 		return false;
@@ -944,7 +944,7 @@ bool bClearBSSID_SCAN(
 	void *hDeviceContext
 )
 {
-	PSDevice        pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 	unsigned int uCmdDequeueIdx = pDevice->uCmdDequeueIdx;
 	unsigned int ii;
 
@@ -966,7 +966,7 @@ vResetCommandTimer(
 	void *hDeviceContext
 )
 {
-	PSDevice        pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 
 	//delete timer
 	del_timer(&pDevice->sTimerCommand);
@@ -988,7 +988,7 @@ BSSvSecondTxData(
 	void *hDeviceContext
 )
 {
-	PSDevice        pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 	PSMgmtObject  pMgmt = &(pDevice->sMgmtObj);
 
 	pDevice->nTxDataTimeCout++;
diff --git a/drivers/staging/vt6655/wctl.c b/drivers/staging/vt6655/wctl.c
index fddea9f..5a54d98 100644
--- a/drivers/staging/vt6655/wctl.c
+++ b/drivers/staging/vt6655/wctl.c
@@ -105,7 +105,8 @@ bool WCTLbIsDuplicate(PSCache pCache, PS802_11Header pMACHeader)
  * Return Value: index number in Defragment Database
  *
  */
-unsigned int WCTLuSearchDFCB(PSDevice pDevice, PS802_11Header pMACHeader)
+unsigned int WCTLuSearchDFCB(struct vnt_private *pDevice,
+			     PS802_11Header pMACHeader)
 {
 	unsigned int ii;
 
@@ -133,7 +134,7 @@ unsigned int WCTLuSearchDFCB(PSDevice pDevice, PS802_11Header pMACHeader)
  * Return Value: index number in Defragment Database
  *
  */
-unsigned int WCTLuInsertDFCB(PSDevice pDevice, PS802_11Header pMACHeader)
+unsigned int WCTLuInsertDFCB(struct vnt_private *pDevice, PS802_11Header pMACHeader)
 {
 	unsigned int ii;
 
@@ -169,7 +170,8 @@ unsigned int WCTLuInsertDFCB(PSDevice pDevice, PS802_11Header pMACHeader)
  * Return Value: true if it is valid fragment packet and we have resource to defragment; otherwise false
  *
  */
-bool WCTLbHandleFragment(PSDevice pDevice, PS802_11Header pMACHeader, unsigned int cbFrameLength, bool bWEP, bool bExtIV)
+bool WCTLbHandleFragment(struct vnt_private *pDevice, PS802_11Header pMACHeader,
+			 unsigned int cbFrameLength, bool bWEP, bool bExtIV)
 {
 	unsigned int uHeaderSize;
 
diff --git a/drivers/staging/vt6655/wctl.h b/drivers/staging/vt6655/wctl.h
index 1ffb273..f0995d8 100644
--- a/drivers/staging/vt6655/wctl.h
+++ b/drivers/staging/vt6655/wctl.h
@@ -97,9 +97,9 @@ do {							\
 /*---------------------  Export Functions  --------------------------*/
 
 bool WCTLbIsDuplicate(PSCache pCache, PS802_11Header pMACHeader);
-bool WCTLbHandleFragment(PSDevice pDevice, PS802_11Header pMACHeader,
+bool WCTLbHandleFragment(struct vnt_private *, PS802_11Header pMACHeader,
 			 unsigned int cbFrameLength, bool bWEP, bool bExtIV);
-unsigned int WCTLuSearchDFCB(PSDevice pDevice, PS802_11Header pMACHeader);
-unsigned int WCTLuInsertDFCB(PSDevice pDevice, PS802_11Header pMACHeader);
+unsigned int WCTLuSearchDFCB(struct vnt_private *, PS802_11Header pMACHeader);
+unsigned int WCTLuInsertDFCB(struct vnt_private *, PS802_11Header pMACHeader);
 
 #endif // __WCTL_H__
diff --git a/drivers/staging/vt6655/wmgr.c b/drivers/staging/vt6655/wmgr.c
index 79ba37b..d696f5b 100644
--- a/drivers/staging/vt6655/wmgr.c
+++ b/drivers/staging/vt6655/wmgr.c
@@ -92,7 +92,7 @@ static int msglevel = MSG_LEVEL_INFO;
 /*---------------------  Static Functions  --------------------------*/
 //2008-8-4 <add> by chester
 static bool ChannelExceedZoneType(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	unsigned char byCurrChannel
 );
 
@@ -100,7 +100,7 @@ static bool ChannelExceedZoneType(
 static
 PSTxMgmtPacket
 s_MgrMakeAssocRequest(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	unsigned char *pDAddr,
 	unsigned short wCurrCapInfo,
@@ -113,7 +113,7 @@ s_MgrMakeAssocRequest(
 static
 void
 s_vMgrRxAssocRequest(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	PSRxMgmtPacket pRxPacket,
 	unsigned int uNodeIndex
@@ -122,7 +122,7 @@ s_vMgrRxAssocRequest(
 static
 PSTxMgmtPacket
 s_MgrMakeReAssocRequest(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	unsigned char *pDAddr,
 	unsigned short wCurrCapInfo,
@@ -135,7 +135,7 @@ s_MgrMakeReAssocRequest(
 static
 void
 s_vMgrRxAssocResponse(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	PSRxMgmtPacket pRxPacket,
 	bool bReAssocType
@@ -144,7 +144,7 @@ s_vMgrRxAssocResponse(
 static
 void
 s_vMgrRxDisassociation(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	PSRxMgmtPacket pRxPacket
 );
@@ -153,7 +153,7 @@ s_vMgrRxDisassociation(
 static
 void
 s_vMgrRxAuthenSequence_1(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	PWLAN_FR_AUTHEN pFrame
 );
@@ -161,7 +161,7 @@ s_vMgrRxAuthenSequence_1(
 static
 void
 s_vMgrRxAuthenSequence_2(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	PWLAN_FR_AUTHEN pFrame
 );
@@ -169,7 +169,7 @@ s_vMgrRxAuthenSequence_2(
 static
 void
 s_vMgrRxAuthenSequence_3(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	PWLAN_FR_AUTHEN pFrame
 );
@@ -177,7 +177,7 @@ s_vMgrRxAuthenSequence_3(
 static
 void
 s_vMgrRxAuthenSequence_4(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	PWLAN_FR_AUTHEN pFrame
 );
@@ -185,7 +185,7 @@ s_vMgrRxAuthenSequence_4(
 static
 void
 s_vMgrRxAuthentication(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	PSRxMgmtPacket pRxPacket
 );
@@ -193,7 +193,7 @@ s_vMgrRxAuthentication(
 static
 void
 s_vMgrRxDeauthentication(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	PSRxMgmtPacket pRxPacket
 );
@@ -203,7 +203,7 @@ s_vMgrRxDeauthentication(
 static
 void
 s_vMgrRxProbeRequest(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	PSRxMgmtPacket pRxPacket
 );
@@ -211,7 +211,7 @@ s_vMgrRxProbeRequest(
 static
 void
 s_vMgrRxProbeResponse(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	PSRxMgmtPacket pRxPacket
 );
@@ -220,7 +220,7 @@ s_vMgrRxProbeResponse(
 static
 void
 s_vMgrRxBeacon(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	PSRxMgmtPacket pRxPacket,
 	bool bInScan
@@ -236,7 +236,7 @@ s_vMgrFormatTIM(
 static
 PSTxMgmtPacket
 s_MgrMakeBeacon(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	unsigned short wCurrCapInfo,
 	unsigned short wCurrBeaconPeriod,
@@ -252,7 +252,7 @@ s_MgrMakeBeacon(
 static
 PSTxMgmtPacket
 s_MgrMakeAssocResponse(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	unsigned short wCurrCapInfo,
 	unsigned short wAssocStatus,
@@ -266,7 +266,7 @@ s_MgrMakeAssocResponse(
 static
 PSTxMgmtPacket
 s_MgrMakeReAssocResponse(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	unsigned short wCurrCapInfo,
 	unsigned short wAssocStatus,
@@ -280,7 +280,7 @@ s_MgrMakeReAssocResponse(
 static
 PSTxMgmtPacket
 s_MgrMakeProbeResponse(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	unsigned short wCurrCapInfo,
 	unsigned short wCurrBeaconPeriod,
@@ -305,7 +305,7 @@ s_vMgrLogStatus(
 static
 void
 s_vMgrSynchBSS(
-	PSDevice      pDevice,
+	struct vnt_private *pDevice,
 	unsigned int uBSSMode,
 	PKnownBSS     pCurr,
 	PCMD_STATUS  pStatus
@@ -320,7 +320,7 @@ s_bCipherMatch(
 );
 
 static void  Encyption_Rebuild(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PKnownBSS pCurr
 );
 
@@ -343,7 +343,7 @@ vMgrObjectInit(
 	void *hDeviceContext
 )
 {
-	PSDevice     pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
 	int ii;
 
@@ -375,7 +375,7 @@ vMgrTimerInit(
 	void *hDeviceContext
 )
 {
-	PSDevice     pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
 
 	init_timer(&pMgmt->sTimerSecondCallback);
@@ -416,7 +416,7 @@ vMgrObjectReset(
 	void *hDeviceContext
 )
 {
-	PSDevice         pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 	PSMgmtObject        pMgmt = pDevice->pMgmt;
 
 	pMgmt->eCurrMode = WMAC_MODE_STANDBY;
@@ -443,7 +443,7 @@ vMgrAssocBeginSta(
 	PCMD_STATUS pStatus
 )
 {
-	PSDevice             pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 	PSTxMgmtPacket          pTxPacket;
 
 	pMgmt->wCurrCapInfo = 0;
@@ -509,7 +509,7 @@ vMgrReAssocBeginSta(
 	PCMD_STATUS pStatus
 )
 {
-	PSDevice             pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 	PSTxMgmtPacket          pTxPacket;
 
 	pMgmt->wCurrCapInfo = 0;
@@ -576,7 +576,7 @@ vMgrDisassocBeginSta(
 	PCMD_STATUS pStatus
 )
 {
-	PSDevice            pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 	PSTxMgmtPacket      pTxPacket = NULL;
 	WLAN_FR_DISASSOC    sFrame;
 
@@ -628,7 +628,7 @@ vMgrDisassocBeginSta(
 static
 void
 s_vMgrRxAssocRequest(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	PSRxMgmtPacket pRxPacket,
 	unsigned int uNodeIndex
@@ -778,7 +778,7 @@ s_vMgrRxAssocRequest(
 static
 void
 s_vMgrRxReAssocRequest(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	PSRxMgmtPacket pRxPacket,
 	unsigned int uNodeIndex
@@ -920,7 +920,7 @@ s_vMgrRxReAssocRequest(
 static
 void
 s_vMgrRxAssocResponse(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	PSRxMgmtPacket pRxPacket,
 	bool bReAssocType
@@ -1073,7 +1073,7 @@ vMgrAuthenBeginSta(
 	PCMD_STATUS pStatus
 )
 {
-	PSDevice     pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 	WLAN_FR_AUTHEN  sFrame;
 	PSTxMgmtPacket  pTxPacket = NULL;
 
@@ -1129,7 +1129,7 @@ vMgrDeAuthenBeginSta(
 	PCMD_STATUS pStatus
 )
 {
-	PSDevice            pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 	WLAN_FR_DEAUTHEN    sFrame;
 	PSTxMgmtPacket      pTxPacket = NULL;
 
@@ -1173,7 +1173,7 @@ vMgrDeAuthenBeginSta(
 static
 void
 s_vMgrRxAuthentication(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	PSRxMgmtPacket pRxPacket
 )
@@ -1227,7 +1227,7 @@ s_vMgrRxAuthentication(
 static
 void
 s_vMgrRxAuthenSequence_1(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	PWLAN_FR_AUTHEN pFrame
 )
@@ -1239,7 +1239,7 @@ s_vMgrRxAuthenSequence_1(
 
 	// Insert a Node entry
 	if (!BSSDBbIsSTAInNodeDB(pMgmt, pFrame->pHdr->sA3.abyAddr2, &uNodeIndex)) {
-		BSSvCreateOneNode((PSDevice)pDevice, &uNodeIndex);
+		BSSvCreateOneNode(pDevice, &uNodeIndex);
 		memcpy(pMgmt->sNodeDBTable[uNodeIndex].abyMACAddr, pFrame->pHdr->sA3.abyAddr2,
 		       WLAN_ADDR_LEN);
 	}
@@ -1326,7 +1326,7 @@ s_vMgrRxAuthenSequence_1(
 static
 void
 s_vMgrRxAuthenSequence_2(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	PWLAN_FR_AUTHEN pFrame
 )
@@ -1411,7 +1411,7 @@ s_vMgrRxAuthenSequence_2(
 static
 void
 s_vMgrRxAuthenSequence_3(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	PWLAN_FR_AUTHEN pFrame
 )
@@ -1493,7 +1493,7 @@ reply:
 static
 void
 s_vMgrRxAuthenSequence_4(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	PWLAN_FR_AUTHEN pFrame
 )
@@ -1523,7 +1523,7 @@ s_vMgrRxAuthenSequence_4(
 static
 void
 s_vMgrRxDisassociation(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	PSRxMgmtPacket pRxPacket
 )
@@ -1593,7 +1593,7 @@ s_vMgrRxDisassociation(
 static
 void
 s_vMgrRxDeauthentication(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	PSRxMgmtPacket pRxPacket
 )
@@ -1676,7 +1676,7 @@ s_vMgrRxDeauthentication(
  -*/
 static bool
 ChannelExceedZoneType(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	unsigned char byCurrChannel
 )
 {
@@ -1713,7 +1713,7 @@ ChannelExceedZoneType(
 static
 void
 s_vMgrRxBeacon(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	PSRxMgmtPacket pRxPacket,
 	bool bInScan
@@ -2026,7 +2026,7 @@ s_vMgrRxBeacon(
 				// send out ps-poll packet
 
 				if (pMgmt->bInTIM)
-					PSvSendPSPOLL((PSDevice)pDevice);
+					PSvSendPSPOLL(pDevice);
 
 			} else {
 				pMgmt->bInTIMWake = false;
@@ -2077,7 +2077,7 @@ s_vMgrRxBeacon(
 				pMgmt->sNodeDBTable[uNodeIndex].uInActiveCount = 0;
 			} else {
 				// Todo, initial Node content
-				BSSvCreateOneNode((PSDevice)pDevice, &uNodeIndex);
+				BSSvCreateOneNode(pDevice, &uNodeIndex);
 
 				pMgmt->abyCurrSuppRates[1] = RATEuSetIE((PWLAN_IE_SUPP_RATES)sFrame.pSuppRates,
 									(PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates,
@@ -2178,7 +2178,7 @@ vMgrCreateOwnIBSS(
 	PCMD_STATUS pStatus
 )
 {
-	PSDevice            pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 	PSMgmtObject        pMgmt = pDevice->pMgmt;
 	unsigned short wMaxBasicRate;
 	unsigned short wMaxSuppRate;
@@ -2414,7 +2414,7 @@ vMgrJoinBSSBegin(
 	PCMD_STATUS pStatus
 )
 {
-	PSDevice     pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
 	PKnownBSS       pCurr = NULL;
 	unsigned int ii, uu;
@@ -2629,7 +2629,7 @@ vMgrJoinBSSBegin(
 static
 void
 s_vMgrSynchBSS(
-	PSDevice      pDevice,
+	struct vnt_private *pDevice,
 	unsigned int uBSSMode,
 	PKnownBSS     pCurr,
 	PCMD_STATUS  pStatus
@@ -2767,7 +2767,7 @@ s_vMgrSynchBSS(
 //mike add: fix NetworkManager 0.7.0 hidden ssid mode in WPA encryption
 //                   ,need reset eAuthenMode and eEncryptionStatus
 static void  Encyption_Rebuild(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PKnownBSS pCurr
 )
 {
@@ -2882,7 +2882,7 @@ s_vMgrFormatTIM(
 static
 PSTxMgmtPacket
 s_MgrMakeBeacon(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	unsigned short wCurrCapInfo,
 	unsigned short wCurrBeaconPeriod,
@@ -3101,7 +3101,7 @@ s_MgrMakeBeacon(
 
 static PSTxMgmtPacket
 s_MgrMakeProbeResponse(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	unsigned short wCurrCapInfo,
 	unsigned short wCurrBeaconPeriod,
@@ -3283,7 +3283,7 @@ s_MgrMakeProbeResponse(
 
 static PSTxMgmtPacket
 s_MgrMakeAssocRequest(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	unsigned char *pDAddr,
 	unsigned short wCurrCapInfo,
@@ -3543,7 +3543,7 @@ s_MgrMakeAssocRequest(
 
 static PSTxMgmtPacket
 s_MgrMakeReAssocRequest(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	unsigned char *pDAddr,
 	unsigned short wCurrCapInfo,
@@ -3788,7 +3788,7 @@ s_MgrMakeReAssocRequest(
 
 static PSTxMgmtPacket
 s_MgrMakeAssocResponse(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	unsigned short wCurrCapInfo,
 	unsigned short wAssocStatus,
@@ -3859,7 +3859,7 @@ s_MgrMakeAssocResponse(
 
 static PSTxMgmtPacket
 s_MgrMakeReAssocResponse(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	unsigned short wCurrCapInfo,
 	unsigned short wAssocStatus,
@@ -3931,7 +3931,7 @@ s_MgrMakeReAssocResponse(
 static
 void
 s_vMgrRxProbeResponse(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	PSRxMgmtPacket pRxPacket
 )
@@ -4050,7 +4050,7 @@ s_vMgrRxProbeResponse(
 static
 void
 s_vMgrRxProbeRequest(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	PSMgmtObject pMgmt,
 	PSRxMgmtPacket pRxPacket
 )
@@ -4129,7 +4129,7 @@ vMgrRxManagePacket(
 	PSRxMgmtPacket pRxPacket
 )
 {
-	PSDevice    pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 	bool bInScan = false;
 	unsigned int uNodeIndex = 0;
 	NODE_STATE  eNodeState = 0;
@@ -4267,7 +4267,7 @@ bMgrPrepareBeaconToSend(
 	PSMgmtObject pMgmt
 )
 {
-	PSDevice            pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 	PSTxMgmtPacket      pTxPacket;
 
 	if (pDevice->bEncryptionEnable || pDevice->bEnable8021x)
@@ -4386,7 +4386,7 @@ bAdd_PMKID_Candidate(
 	PSRSNCapObject psRSNCapObj
 )
 {
-	PSDevice         pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 	struct pmkid_candidate *pCandidateList;
 	unsigned int ii = 0;
 
@@ -4443,7 +4443,7 @@ vFlush_PMKID_Candidate(
 	void *hDeviceContext
 )
 {
-	PSDevice        pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 
 	if (pDevice == NULL)
 		return;
-- 
1.9.1

