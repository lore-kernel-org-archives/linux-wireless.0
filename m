Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:54088 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845AbbAaPG2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jan 2015 10:06:28 -0500
Received: by mail-wi0-f180.google.com with SMTP id h11so7634086wiw.1
        for <linux-wireless@vger.kernel.org>; Sat, 31 Jan 2015 07:06:27 -0800 (PST)
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Roberta Dobrescu <roberta.dobrescu@gmail.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8723au: hal: rtl8723a_bt-coexist: Removed variables that is never used
Date: Sat, 31 Jan 2015 16:09:48 +0100
Message-Id: <1422716988-5387-1-git-send-email-rickard_strandqvist@spectrumdigital.se> (sfid-20150131_160643_900645_FDE4DAF3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Variable was assigned a value that was never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 .../staging/rtl8723au/hal/rtl8723a_bt-coexist.c    |   27 +++-----------------
 1 file changed, 3 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c b/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
index 86a8397..dae3a33 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
@@ -219,7 +219,6 @@ static void bthci_DecideBTChannel(struct rtw_adapter *padapter, u8 EntryNum)
 	struct chnl_txpower_triple *pTriple_subband = NULL;
 	struct common_triple *pTriple;
 	u8 i, j, localchnl, firstRemoteLegalChnlInTriplet = 0;
-	u8 regulatory_skipLen = 0;
 	u8 subbandTripletCnt = 0;
 
 	pmlmepriv = &padapter->mlmepriv;
@@ -243,7 +242,6 @@ static void bthci_DecideBTChannel(struct rtw_adapter *padapter, u8 EntryNum)
 			/*  Regulatory Extension Identifier, skip it */
 			RTPRINT(FIOCTL, (IOCTL_BT_HCICMD|IOCTL_BT_LOGO),
 				("Find Regulatory ID, regulatory class = %d\n", pTriple->byte_2nd));
-			regulatory_skipLen += 3;
 			pTriple_subband = NULL;
 			continue;
 		} else {	/*  Sub-band triplet */
@@ -5203,12 +5201,8 @@ static void btdm_NotifyFwScan(struct rtw_adapter *padapter, u8 scanType)
 static void btdm_1AntSetPSMode(struct rtw_adapter *padapter,
 			       u8 enable, u8 smartps, u8 mode)
 {
-	struct pwrctrl_priv *pwrctrl;
-
 	RTPRINT(FBT, BT_TRACE, ("[BTCoex], Current LPS(%s, %d), smartps =%d\n", enable == true?"ON":"OFF", mode, smartps));
 
-	pwrctrl = &padapter->pwrctrlpriv;
-
 	if (enable == true) {
 		rtw_set_ps_mode23a(padapter, PS_MODE_MIN, smartps, mode);
 	} else {
@@ -5549,7 +5543,7 @@ static s8 btdm_1AntTdmaJudgement(struct rtw_adapter *padapter, u8 retry)
 {
 	struct hal_data_8723a *pHalData;
 	struct btdm_8723a_1ant *pBtdm8723;
-	static s8 up, dn, m = 1, n = 3, WaitCount;
+	static s8 up, dn, m = 1, WaitCount;
 	s8 ret;
 
 	pHalData = GET_HAL_DATA(padapter);
@@ -5560,7 +5554,6 @@ static s8 btdm_1AntTdmaJudgement(struct rtw_adapter *padapter, u8 retry)
 		up = 0;
 		dn = 0;
 		m = 1;
-		n = 3;
 		WaitCount = 0;
 	} else {
 		WaitCount++;
@@ -5576,7 +5569,6 @@ static s8 btdm_1AntTdmaJudgement(struct rtw_adapter *padapter, u8 retry)
 			/*  retry = 0 in consecutive 3m*(2s), add WiFi duration */
 			ret = 1;
 
-			n = 3;
 			up = 0;
 			dn = 0;
 			WaitCount = 0;
@@ -5693,13 +5685,11 @@ static void btdm_1AntTdmaDurationAdjustForACL(struct rtw_adapter *padapter)
 
 static void btdm_1AntCoexProcessForWifiConnect(struct rtw_adapter *padapter)
 {
-	struct mlme_priv *pmlmepriv;
 	struct hal_data_8723a *pHalData;
 	struct bt_coexist_8723a *pBtCoex;
 	struct btdm_8723a_1ant *pBtdm8723;
 	u8 BtState;
 
-	pmlmepriv = &padapter->mlmepriv;
 	pHalData = GET_HAL_DATA(padapter);
 	pBtCoex = &pHalData->bt_coexist.halCoex8723;
 	pBtdm8723 = &pBtCoex->btdm1Ant;
@@ -6272,12 +6262,10 @@ void BTDM_1AntForDhcp(struct rtw_adapter *padapter)
 	struct hal_data_8723a *pHalData;
 	u8 BtState;
 	struct bt_coexist_8723a *pBtCoex;
-	struct btdm_8723a_1ant *pBtdm8723;
 
 	pHalData = GET_HAL_DATA(padapter);
 	pBtCoex = &pHalData->bt_coexist.halCoex8723;
 	BtState = pBtCoex->c2hBtInfo;
-	pBtdm8723 = &pBtCoex->btdm1Ant;
 
 	RTPRINT(FBT, BT_TRACE, ("\n[BTCoex], 1Ant for DHCP\n"));
 	RTPRINT(FBT, BT_TRACE, ("[BTCoex], 1Ant for DHCP, WiFi is %s\n",
@@ -6421,11 +6409,9 @@ static void BTDM_1AntFwC2hBtInfo8723A(struct rtw_adapter *padapter)
 void BTDM_1AntBtCoexist8723A(struct rtw_adapter *padapter)
 {
 	struct mlme_priv *pmlmepriv;
-	struct hal_data_8723a *pHalData;
 	unsigned long delta_time;
 
 	pmlmepriv = &padapter->mlmepriv;
-	pHalData = GET_HAL_DATA(padapter);
 
 	if (check_fwstate(pmlmepriv, WIFI_SITE_MONITOR)) {
 		/*  already done in BTDM_1AntForScan() */
@@ -8463,10 +8449,7 @@ static void btdm_2Ant8723AHIDA2DPAction(struct rtw_adapter *padapter)
 
 static void btdm_2Ant8723AA2dp(struct rtw_adapter *padapter)
 {
-	struct hal_data_8723a *pHalData = GET_HAL_DATA(padapter);
-	u8 btRssiState, btRssiState1, btInfoExt;
-
-	btInfoExt = pHalData->bt_coexist.halCoex8723.btInfoExt;
+	u8 btRssiState, btRssiState1;
 
 	if (btdm_NeedToDecBtPwr(padapter))
 		btdm_2AntDecBtPwr(padapter, true);
@@ -8602,7 +8585,7 @@ static void BTDM_2AntFwC2hBtInfo8723A(struct rtw_adapter *padapter)
 	struct btdm_8723a_2ant *pBtdm8723 = &pHalData->bt_coexist.halCoex8723.btdm2Ant;
 	u8 btInfo = 0;
 	u8 algorithm = BT_2ANT_COEX_ALGO_UNDEFINED;
-	u8 bBtLinkExist = false, bBtHsModeExist = false;
+	u8 bBtHsModeExist = false;
 
 	btInfo = pHalData->bt_coexist.halCoex8723.c2hBtInfoOriginal;
 	pBtdm8723->btStatus = BT_2ANT_BT_STATUS_IDLE;
@@ -8636,7 +8619,6 @@ static void BTDM_2AntFwC2hBtInfo8723A(struct rtw_adapter *padapter)
 		btInfo, pHalData->bt_coexist.halCoex8723.c2hBtInfoOriginal));
 	if (btInfo&BT_INFO_ACL) {
 		RTPRINT(FBT, BT_TRACE, ("[BTC2H], BTInfo: bConnect = true   btInfo =%x\n", btInfo));
-		bBtLinkExist = true;
 		if (((btInfo&(BT_INFO_FTP|BT_INFO_A2DP|BT_INFO_HID|BT_INFO_SCO_BUSY)) != 0) ||
 		    pHalData->bt_coexist.halCoex8723.btRetryCnt > 0) {
 			pBtdm8723->btStatus = BT_2ANT_BT_STATUS_NON_IDLE;
@@ -8769,7 +8751,6 @@ void BTDM_2AntBtCoexist8723A(struct rtw_adapter *padapter)
 	struct bt_30info *pBTInfo = GET_BT_INFO(padapter);
 	struct bt_mgnt *pBtMgnt = &pBTInfo->BtMgnt;
 	struct bt_dgb *pBtDbg = &pBTInfo->BtDbg;
-	u8 btInfoOriginal = 0;
 	struct hal_data_8723a *pHalData = GET_HAL_DATA(padapter);
 	struct btdm_8723a_2ant *pBtdm8723 = &pHalData->bt_coexist.halCoex8723.btdm2Ant;
 
@@ -8855,8 +8836,6 @@ void BTDM_2AntBtCoexist8723A(struct rtw_adapter *padapter)
 		if (pHalData->bt_coexist.halCoex8723.bC2hBtInfoReqSent)
 			RTPRINT(FBT, BT_TRACE, ("[BTCoex] c2h for btInfo not rcvd yet!!\n"));
 
-		btInfoOriginal = pHalData->bt_coexist.halCoex8723.c2hBtInfoOriginal;
-
 		if (pBtMgnt->ExtConfig.bHoldForBtOperation) {
 			RTPRINT(FBT, BT_TRACE, ("Action for BT Operation adjust!!\n"));
 			return;
-- 
1.7.10.4

