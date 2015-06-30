Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:38532 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbbF3Ifv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2015 04:35:51 -0400
From: Dean Lee <dean.lee@atmel.com>
To: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<linux-wireless@vger.kernel.org>
CC: <johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <dean.lee@atmel.com>,
	<nicolas.ferre@atmel.com>
Subject: [PATCH 2/6] staging: wilc1000: delete 'WILC_WFIDrvHandle' structure
Date: Tue, 30 Jun 2015 17:34:34 +0900
Message-ID: <1435653278-5168-2-git-send-email-dean.lee@atmel.com> (sfid-20150630_103608_521937_F10DDEA3)
In-Reply-To: <1435653278-5168-1-git-send-email-dean.lee@atmel.com>
References: <1435653278-5168-1-git-send-email-dean.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

delete odd structure and rework it.

Signed-off-by: Dean Lee <dean.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         | 149 +++++++++++-----------
 drivers/staging/wilc1000/host_interface.h         | 123 +++++++++---------
 drivers/staging/wilc1000/linux_wlan.c             |  14 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  18 +--
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |   3 +-
 5 files changed, 150 insertions(+), 157 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 6b10bbb..55572bd 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -725,7 +725,7 @@ static s32 Handle_SetOperationMode(void *drvHandler, tstrHostIfSetOperationMode
 /**
  *  @brief host_int_set_IPAddress
  *  @details       Setting IP address params in message queue
- *  @param[in]    WILC_WFIDrvHandle hWFIDrv, u8* pu8IPAddr
+ *  @param[in]    void* hWFIDrv, u8* pu8IPAddr
  *  @return         Error code.
  *  @author
  *  @date
@@ -756,7 +756,7 @@ s32 Handle_set_IPAddress(void *drvHandler, u8 *pu8IPAddr, u8 idx)
 
 
 
-	host_int_get_ipaddress((WILC_WFIDrvHandle)drvHandler, firmwareIPAddress, idx);
+	host_int_get_ipaddress(drvHandler, firmwareIPAddress, idx);
 
 	if (s32Error) {
 		PRINT_D(HOSTINF_DBG, "Failed to set IP address\n");
@@ -777,7 +777,7 @@ s32 Handle_set_IPAddress(void *drvHandler, u8 *pu8IPAddr, u8 idx)
 /**
  *  @brief Handle_get_IPAddress
  *  @details       Setting IP address params in message queue
- *  @param[in]    WILC_WFIDrvHandle hWFIDrv, u8* pu8IPAddr
+ *  @param[in]    void* hWFIDrv, u8* pu8IPAddr
  *  @return         Error code.
  *  @author
  *  @date
@@ -806,7 +806,7 @@ s32 Handle_get_IPAddress(void *drvHandler, u8 *pu8IPAddr, u8 idx)
 	WILC_FREE(strWID.ps8WidVal);
 
 	if (WILC_memcmp(gs8GetIP[idx], gs8SetIP[idx], IP_ALEN) != 0)
-		host_int_setup_ipaddress((WILC_WFIDrvHandle)pstrWFIDrv, gs8SetIP[idx], idx);
+		host_int_setup_ipaddress(pstrWFIDrv, gs8SetIP[idx], idx);
 
 	if (s32Error != WILC_SUCCESS) {
 		PRINT_ER("Failed to get IP address\n");
@@ -1505,7 +1505,7 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 
 
 	PRINT_D(HOSTINF_DBG, "Getting site survey results\n");
-	s32Err = host_int_get_site_survey_results((WILC_WFIDrvHandle)pstrWFIDrv,
+	s32Err = host_int_get_site_survey_results(drvHandler,
 						  gapu8RcvdSurveyResults,
 						  MAX_SURVEY_RESULT_FRAG_SIZE);
 	if (s32Err) {
@@ -2422,7 +2422,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
 			if (u8MacStatus == MAC_CONNECTED) {
 				WILC_memset(gapu8RcvdAssocResp, 0, MAX_ASSOC_RESP_FRAME_SIZE);
 
-				host_int_get_assoc_res_info((WILC_WFIDrvHandle)pstrWFIDrv,
+				host_int_get_assoc_res_info(drvHandler,
 							    gapu8RcvdAssocResp,
 							    MAX_ASSOC_RESP_FRAME_SIZE,
 							    &u32RcvdAssocRespInfoLen);
@@ -2512,7 +2512,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
 			    (strConnectInfo.u16ConnectStatus == SUCCESSFUL_STATUSCODE))	{
 				#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 
-				host_int_set_power_mgmt((WILC_WFIDrvHandle)pstrWFIDrv, 0, 0);
+				host_int_set_power_mgmt(drvHandler, 0, 0);
 				#endif
 
 				PRINT_D(HOSTINF_DBG, "MAC status : CONNECTED and Connect Status : Successful\n");
@@ -2588,7 +2588,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
 				#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 
 				g_obtainingIP = false;
-				host_int_set_power_mgmt((WILC_WFIDrvHandle)pstrWFIDrv, 0, 0);
+				host_int_set_power_mgmt(drvHandler, 0, 0);
 				#endif
 
 				pstrWFIDrv->strWILC_UsrConnReq.pfUserConnectResult(CONN_DISCONN_EVENT_DISCONN_NOTIF,
@@ -3069,7 +3069,7 @@ static void Handle_Disconnect(void *drvHandler)
 	#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 
 	g_obtainingIP = false;
-	host_int_set_power_mgmt((WILC_WFIDrvHandle)pstrWFIDrv, 0, 0);
+	host_int_set_power_mgmt(drvHandler, 0, 0);
 	#endif
 
 	WILC_memset(u8ConnectedSSID, 0, ETH_ALEN);
@@ -3170,7 +3170,7 @@ void resolve_disconnect_aberration(void *drvHandler)
 		return;
 	if ((pstrWFIDrv->enuHostIFstate == HOST_IF_WAITING_CONN_RESP) || (pstrWFIDrv->enuHostIFstate == HOST_IF_CONNECTING)) {
 		PRINT_D(HOSTINF_DBG, "\n\n<< correcting Supplicant state machine >>\n\n");
-		host_int_disconnect((WILC_WFIDrvHandle)pstrWFIDrv, 1);
+		host_int_disconnect(drvHandler, 1);
 	}
 }
 static s32 Switch_Log_Terminal(void *drvHandler)
@@ -4613,7 +4613,7 @@ static void TimerCB_Connect(void *pvArg)
  *  @version		1.0
  */
 /* Check implementation in core adding 9 bytes to the input! */
-s32 host_int_remove_key(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8StaAddress)
+s32 host_int_remove_key(void *hWFIDrv, const u8 *pu8StaAddress)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -4642,7 +4642,7 @@ s32 host_int_remove_key(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8StaAddress)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_remove_wep_key(WILC_WFIDrvHandle hWFIDrv, u8 u8keyIdx)
+s32 host_int_remove_wep_key(void *hWFIDrv, u8 u8keyIdx)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -4692,7 +4692,7 @@ s32 host_int_remove_wep_key(WILC_WFIDrvHandle hWFIDrv, u8 u8keyIdx)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_WEPDefaultKeyID(WILC_WFIDrvHandle hWFIDrv, u8 u8Index)
+s32 host_int_set_WEPDefaultKeyID(void *hWFIDrv, u8 u8Index)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -4749,7 +4749,7 @@ s32 host_int_set_WEPDefaultKeyID(WILC_WFIDrvHandle hWFIDrv, u8 u8Index)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_add_wep_key_bss_sta(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx)
+s32 host_int_add_wep_key_bss_sta(void *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx)
 {
 
 	s32 s32Error = WILC_SUCCESS;
@@ -4815,7 +4815,7 @@ s32 host_int_add_wep_key_bss_sta(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8WepKey,
  *  @date		28 FEB 2013
  *  @version		1.0
  */
-s32 host_int_add_wep_key_bss_ap(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx, u8 u8mode, AUTHTYPE_T tenuAuth_type)
+s32 host_int_add_wep_key_bss_ap(void *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx, u8 u8mode, AUTHTYPE_T tenuAuth_type)
 {
 
 	s32 s32Error = WILC_SUCCESS;
@@ -4891,7 +4891,7 @@ s32 host_int_add_wep_key_bss_ap(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8WepKey,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_add_ptk(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
+s32 host_int_add_ptk(void *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 			     const u8 *mac_addr, const u8 *pu8RxMic, const u8 *pu8TxMic, u8 mode, u8 u8Ciphermode, u8 u8Idx)
 {
 	s32 s32Error = WILC_SUCCESS;
@@ -4993,7 +4993,7 @@ s32 host_int_add_ptk(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_add_rx_gtk(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKeylen,
+s32 host_int_add_rx_gtk(void *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKeylen,
 				u8 u8KeyIdx, u32 u32KeyRSClen, const u8 *KeyRSC,
 				const u8 *pu8RxMic, const u8 *pu8TxMic, u8 mode, u8 u8Ciphermode)
 {
@@ -5103,7 +5103,7 @@ s32 host_int_add_rx_gtk(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkK
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_pmkid_info(WILC_WFIDrvHandle hWFIDrv, tstrHostIFpmkidAttr *pu8PmkidInfoArray)
+s32 host_int_set_pmkid_info(void *hWFIDrv, tstrHostIFpmkidAttr *pu8PmkidInfoArray)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -5166,7 +5166,7 @@ s32 host_int_set_pmkid_info(WILC_WFIDrvHandle hWFIDrv, tstrHostIFpmkidAttr *pu8P
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_pmkid_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8PmkidInfoArray,
+s32 host_int_get_pmkid_info(void *hWFIDrv, u8 *pu8PmkidInfoArray,
 				    u32 u32PmkidInfoLen)
 {
 	s32 s32Error = WILC_SUCCESS;
@@ -5195,7 +5195,7 @@ s32 host_int_get_pmkid_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8PmkidInfoArray,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_RSNAConfigPSKPassPhrase(WILC_WFIDrvHandle hWFIDrv, u8 *pu8PassPhrase,
+s32 host_int_set_RSNAConfigPSKPassPhrase(void *hWFIDrv, u8 *pu8PassPhrase,
 						 u8 u8Psklength)
 {
 	s32 s32Error = WILC_SUCCESS;
@@ -5224,7 +5224,7 @@ s32 host_int_set_RSNAConfigPSKPassPhrase(WILC_WFIDrvHandle hWFIDrv, u8 *pu8PassP
  *  @date		19 April 2012
  *  @version		1.0
  */
-s32 host_int_get_MacAddress(WILC_WFIDrvHandle hWFIDrv, u8 *pu8MacAddress)
+s32 host_int_get_MacAddress(void *hWFIDrv, u8 *pu8MacAddress)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
@@ -5258,7 +5258,7 @@ s32 host_int_get_MacAddress(WILC_WFIDrvHandle hWFIDrv, u8 *pu8MacAddress)
  *  @date		16 July 2012
  *  @version		1.0
  */
-s32 host_int_set_MacAddress(WILC_WFIDrvHandle hWFIDrv, u8 *pu8MacAddress)
+s32 host_int_set_MacAddress(void *hWFIDrv, u8 *pu8MacAddress)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
@@ -5299,8 +5299,7 @@ s32 host_int_set_MacAddress(WILC_WFIDrvHandle hWFIDrv, u8 *pu8MacAddress)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_RSNAConfigPSKPassPhrase(WILC_WFIDrvHandle hWFIDrv,
-						 u8 *pu8PassPhrase, u8 u8Psklength)
+s32 host_int_get_RSNAConfigPSKPassPhrase(void *hWFIDrv, u8 *pu8PassPhrase, u8 u8Psklength)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -5346,7 +5345,7 @@ s32 host_int_get_RSNAConfigPSKPassPhrase(WILC_WFIDrvHandle hWFIDrv,
  *  @version		1.0
  */
 #ifndef CONNECT_DIRECT
-s32 host_int_get_site_survey_results(WILC_WFIDrvHandle hWFIDrv,
+s32 host_int_get_site_survey_results(void *hWFIDrv,
 					     u8 ppu8RcvdSiteSurveyResults[][MAX_SURVEY_RESULT_FRAG_SIZE],
 					     u32 u32MaxSiteSrvyFragLen)
 {
@@ -5396,7 +5395,7 @@ s32 host_int_get_site_survey_results(WILC_WFIDrvHandle hWFIDrv,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_start_scan_req(WILC_WFIDrvHandle hWFIDrv, u8 scanSource)
+s32 host_int_set_start_scan_req(void *hWFIDrv, u8 scanSource)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -5426,7 +5425,7 @@ s32 host_int_set_start_scan_req(WILC_WFIDrvHandle hWFIDrv, u8 scanSource)
  *  @version		1.0
  */
 
-s32 host_int_get_start_scan_req(WILC_WFIDrvHandle hWFIDrv, u8 *pu8ScanSource)
+s32 host_int_get_start_scan_req(void *hWFIDrv, u8 *pu8ScanSource)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -5451,7 +5450,7 @@ s32 host_int_get_start_scan_req(WILC_WFIDrvHandle hWFIDrv, u8 *pu8ScanSource)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_join_req(WILC_WFIDrvHandle hWFIDrv, u8 *pu8bssid,
+s32 host_int_set_join_req(void *hWFIDrv, u8 *pu8bssid,
 				  const u8 *pu8ssid, size_t ssidLen,
 				  const u8 *pu8IEs, size_t IEsLen,
 				  tWILCpfConnectResult pfConnectResult, void *pvUserArg,
@@ -5531,7 +5530,7 @@ s32 host_int_set_join_req(WILC_WFIDrvHandle hWFIDrv, u8 *pu8bssid,
 	}
 
 	enuScanConnTimer = CONNECT_TIMER;
-	WILC_TimerStart(&(pstrWFIDrv->hConnectTimer), HOST_IF_CONNECT_TIMEOUT, (void *) hWFIDrv, NULL);
+	WILC_TimerStart(&(pstrWFIDrv->hConnectTimer), HOST_IF_CONNECT_TIMEOUT, hWFIDrv, NULL);
 
 	WILC_CATCH(s32Error)
 	{
@@ -5553,7 +5552,7 @@ s32 host_int_set_join_req(WILC_WFIDrvHandle hWFIDrv, u8 *pu8bssid,
  *  @version	8.0
  */
 
-s32 host_int_flush_join_req(WILC_WFIDrvHandle hWFIDrv)
+s32 host_int_flush_join_req(void *hWFIDrv)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
@@ -5597,7 +5596,7 @@ s32 host_int_flush_join_req(WILC_WFIDrvHandle hWFIDrv)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_disconnect(WILC_WFIDrvHandle hWFIDrv, u16 u16ReasonCode)
+s32 host_int_disconnect(void *hWFIDrv, u16 u16ReasonCode)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
@@ -5646,7 +5645,7 @@ s32 host_int_disconnect(WILC_WFIDrvHandle hWFIDrv, u16 u16ReasonCode)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_disconnect_station(WILC_WFIDrvHandle hWFIDrv, u8 assoc_id)
+s32 host_int_disconnect_station(void *hWFIDrv, u8 assoc_id)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -5686,7 +5685,7 @@ s32 host_int_disconnect_station(WILC_WFIDrvHandle hWFIDrv, u8 assoc_id)
  *  @version		1.0
  */
 
-s32 host_int_get_assoc_req_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8AssocReqInfo,
+s32 host_int_get_assoc_req_info(void *hWFIDrv, u8 *pu8AssocReqInfo,
 					u32 u32AssocReqInfoLen)
 {
 	s32 s32Error = WILC_SUCCESS;
@@ -5713,7 +5712,7 @@ s32 host_int_get_assoc_req_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8AssocReqInfo,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_assoc_res_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8AssocRespInfo,
+s32 host_int_get_assoc_res_info(void *hWFIDrv, u8 *pu8AssocRespInfo,
 					u32 u32MaxAssocRespInfoLen, u32 *pu32RcvdAssocRespInfoLen)
 {
 	s32 s32Error = WILC_SUCCESS;
@@ -5763,7 +5762,7 @@ s32 host_int_get_assoc_res_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8AssocRespInfo,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_rx_power_level(WILC_WFIDrvHandle hWFIDrv, u8 *pu8RxPowerLevel,
+s32 host_int_get_rx_power_level(void *hWFIDrv, u8 *pu8RxPowerLevel,
 					u32 u32RxPowerLevelLen)
 {
 	s32 s32Error = WILC_SUCCESS;
@@ -5794,7 +5793,7 @@ s32 host_int_get_rx_power_level(WILC_WFIDrvHandle hWFIDrv, u8 *pu8RxPowerLevel,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_mac_chnl_num(WILC_WFIDrvHandle hWFIDrv, u8 u8ChNum)
+s32 host_int_set_mac_chnl_num(void *hWFIDrv, u8 u8ChNum)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -5877,7 +5876,7 @@ s32 host_int_set_wfi_drv_handler(u32 u32address)
 
 
 
-s32 host_int_set_operation_mode(WILC_WFIDrvHandle hWFIDrv, u32 u32mode)
+s32 host_int_set_operation_mode(void *hWFIDrv, u32 u32mode)
 {
 	s32 s32Error = WILC_SUCCESS;
 
@@ -5918,7 +5917,7 @@ s32 host_int_set_operation_mode(WILC_WFIDrvHandle hWFIDrv, u32 u32mode)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_host_chnl_num(WILC_WFIDrvHandle hWFIDrv, u8 *pu8ChNo)
+s32 host_int_get_host_chnl_num(void *hWFIDrv, u8 *pu8ChNo)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -5957,14 +5956,14 @@ s32 host_int_get_host_chnl_num(WILC_WFIDrvHandle hWFIDrv, u8 *pu8ChNo)
 /**
  *  @brief                       host_int_test_set_int_wid
  *  @details             Test function for setting wids
- *  @param[in,out]   WILC_WFIDrvHandle hWFIDrv, u32 u32TestMemAddr
+ *  @param[in,out]   void* hWFIDrv, u32 u32TestMemAddr
  *  @return              Error code indicating success/failure
  *  @note
  *  @author		zsalah
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_test_set_int_wid(WILC_WFIDrvHandle hWFIDrv, u32 u32TestMemAddr)
+s32 host_int_test_set_int_wid(void *hWFIDrv, u32 u32TestMemAddr)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID	strWID;
@@ -6011,7 +6010,7 @@ s32 host_int_test_set_int_wid(WILC_WFIDrvHandle hWFIDrv, u32 u32TestMemAddr)
  *  @date
  *  @version		1.0
  */
-s32 host_int_get_inactive_time(WILC_WFIDrvHandle hWFIDrv, const u8 *mac, u32 *pu32InactiveTime)
+s32 host_int_get_inactive_time(void *hWFIDrv, const u8 *mac, u32 *pu32InactiveTime)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -6050,14 +6049,14 @@ s32 host_int_get_inactive_time(WILC_WFIDrvHandle hWFIDrv, const u8 *mac, u32 *pu
 /**
  *  @brief              host_int_test_get_int_wid
  *  @details    Test function for getting wids
- *  @param[in,out] WILC_WFIDrvHandle hWFIDrv, u32* pu32TestMemAddr
+ *  @param[in,out] void* hWFIDrv, u32* pu32TestMemAddr
  *  @return             Error code indicating success/failure
  *  @note
  *  @author		zsalah
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_test_get_int_wid(WILC_WFIDrvHandle hWFIDrv, u32 *pu32TestMemAddr)
+s32 host_int_test_get_int_wid(void *hWFIDrv, u32 *pu32TestMemAddr)
 {
 
 	s32 s32Error = WILC_SUCCESS;
@@ -6106,7 +6105,7 @@ s32 host_int_test_get_int_wid(WILC_WFIDrvHandle hWFIDrv, u32 *pu32TestMemAddr)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_rssi(WILC_WFIDrvHandle hWFIDrv, s8 *ps8Rssi)
+s32 host_int_get_rssi(void *hWFIDrv, s8 *ps8Rssi)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
@@ -6141,7 +6140,7 @@ s32 host_int_get_rssi(WILC_WFIDrvHandle hWFIDrv, s8 *ps8Rssi)
 	return s32Error;
 }
 
-s32 host_int_get_link_speed(WILC_WFIDrvHandle hWFIDrv, s8 *ps8lnkspd)
+s32 host_int_get_link_speed(void *hWFIDrv, s8 *ps8lnkspd)
 {
 	tstrHostIFmsg strHostIFmsg;
 	s32 s32Error = WILC_SUCCESS;
@@ -6178,7 +6177,7 @@ s32 host_int_get_link_speed(WILC_WFIDrvHandle hWFIDrv, s8 *ps8lnkspd)
 	return s32Error;
 }
 
-s32 host_int_get_statistics(WILC_WFIDrvHandle hWFIDrv, tstrStatistics *pstrStatistics)
+s32 host_int_get_statistics(void *hWFIDrv, tstrStatistics *pstrStatistics)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
@@ -6218,7 +6217,7 @@ s32 host_int_get_statistics(WILC_WFIDrvHandle hWFIDrv, tstrStatistics *pstrStati
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_scan(WILC_WFIDrvHandle hWFIDrv, u8 u8ScanSource,
+s32 host_int_scan(void *hWFIDrv, u8 u8ScanSource,
 			  u8 u8ScanType, u8 *pu8ChnlFreqList,
 			  u8 u8ChnlListLen, const u8 *pu8IEs,
 			  size_t IEsLen, tWILCpfScanResult ScanResult,
@@ -6292,7 +6291,7 @@ s32 host_int_scan(WILC_WFIDrvHandle hWFIDrv, u8 u8ScanSource,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 hif_set_cfg(WILC_WFIDrvHandle hWFIDrv, tstrCfgParamVal *pstrCfgParamVal)
+s32 hif_set_cfg(void *hWFIDrv, tstrCfgParamVal *pstrCfgParamVal)
 {
 
 	s32 s32Error = WILC_SUCCESS;
@@ -6334,7 +6333,7 @@ s32 hif_set_cfg(WILC_WFIDrvHandle hWFIDrv, tstrCfgParamVal *pstrCfgParamVal)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 hif_get_cfg(WILC_WFIDrvHandle hWFIDrv, u16 u16WID, u16 *pu16WID_Value)
+s32 hif_get_cfg(void *hWFIDrv, u16 u16WID, u16 *pu16WID_Value)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -6515,7 +6514,7 @@ static u32 u32Intialized;
 static u32 msgQ_created;
 static u32 clients_count;
 
-s32 host_int_init(WILC_WFIDrvHandle *phWFIDrv)
+s32 host_int_init(void **phWFIDrv)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv;
@@ -6523,7 +6522,7 @@ s32 host_int_init(WILC_WFIDrvHandle *phWFIDrv)
 	/*if(u32Intialized == 1)
 	 * {
 	 *      PRINT_D(HOSTINF_DBG,"Host interface is previously initialized\n");
-	 * *phWFIDrv = (WILC_WFIDrvHandle)gWFiDrvHandle; //Will be adjusted later for P2P
+	 * *phWFIDrv = (void *)gWFiDrvHandle; //Will be adjusted later for P2P
 	 *      return 0;
 	 * }	*/
 	PRINT_D(HOSTINF_DBG, "Initializing host interface for client %d\n", clients_count + 1);
@@ -6544,7 +6543,7 @@ s32 host_int_init(WILC_WFIDrvHandle *phWFIDrv)
 	}
 	WILC_memset(pstrWFIDrv, 0, sizeof(tstrWILC_WFIDrv));
 	/*return driver handle to user*/
-	*phWFIDrv = (WILC_WFIDrvHandle)pstrWFIDrv;
+	*phWFIDrv = (void *)pstrWFIDrv;
 	/*save into globl handle*/
 
 	#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
@@ -6708,7 +6707,7 @@ _fail_:
  *  @version		1.0
  */
 
-s32 host_int_deinit(WILC_WFIDrvHandle hWFIDrv)
+s32 host_int_deinit(void *hWFIDrv)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
@@ -7008,7 +7007,7 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
  *  @date
  *  @version		1.0
  */
-s32 host_int_remain_on_channel(WILC_WFIDrvHandle hWFIDrv, u32 u32SessionID, u32 u32duration, u16 chan, tWILCpfRemainOnChanExpired RemainOnChanExpired, tWILCpfRemainOnChanReady RemainOnChanReady, void *pvUserArg)
+s32 host_int_remain_on_channel(void *hWFIDrv, u32 u32SessionID, u32 u32duration, u16 chan, tWILCpfRemainOnChanExpired RemainOnChanExpired, tWILCpfRemainOnChanReady RemainOnChanReady, void *pvUserArg)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -7057,7 +7056,7 @@ s32 host_int_remain_on_channel(WILC_WFIDrvHandle hWFIDrv, u32 u32SessionID, u32
  *  @date
  *  @version		1.0
  */
-s32 host_int_ListenStateExpired(WILC_WFIDrvHandle hWFIDrv, u32 u32SessionID)
+s32 host_int_ListenStateExpired(void *hWFIDrv, u32 u32SessionID)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -7095,7 +7094,7 @@ s32 host_int_ListenStateExpired(WILC_WFIDrvHandle hWFIDrv, u32 u32SessionID)
  *  @author
  *  @date
  *  @version		1.0*/
-s32 host_int_frame_register(WILC_WFIDrvHandle hWFIDrv, u16 u16FrameType, bool bReg)
+s32 host_int_frame_register(void *hWFIDrv, u16 u16FrameType, bool bReg)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -7147,7 +7146,7 @@ s32 host_int_frame_register(WILC_WFIDrvHandle hWFIDrv, u16 u16FrameType, bool bR
 /**
  *  @brief host_int_add_beacon
  *  @details       Setting add beacon params in message queue
- *  @param[in]    WILC_WFIDrvHandle hWFIDrv, u32 u32Interval,
+ *  @param[in]    void* hWFIDrv, u32 u32Interval,
  *                         u32 u32DTIMPeriod,u32 u32HeadLen, u8* pu8Head,
  *                         u32 u32TailLen, u8* pu8Tail
  *  @return         Error code.
@@ -7155,7 +7154,7 @@ s32 host_int_frame_register(WILC_WFIDrvHandle hWFIDrv, u16 u16FrameType, bool bR
  *  @date
  *  @version	1.0
  */
-s32 host_int_add_beacon(WILC_WFIDrvHandle hWFIDrv, u32 u32Interval,
+s32 host_int_add_beacon(void *hWFIDrv, u32 u32Interval,
 				u32 u32DTIMPeriod,
 				u32 u32HeadLen, u8 *pu8Head,
 				u32 u32TailLen, u8 *pu8Tail)
@@ -7222,13 +7221,13 @@ s32 host_int_add_beacon(WILC_WFIDrvHandle hWFIDrv, u32 u32Interval,
 /**
  *  @brief host_int_del_beacon
  *  @details       Setting add beacon params in message queue
- *  @param[in]    WILC_WFIDrvHandle hWFIDrv
+ *  @param[in]    void* hWFIDrv
  *  @return         Error code.
  *  @author
  *  @date
  *  @version	1.0
  */
-s32 host_int_del_beacon(WILC_WFIDrvHandle hWFIDrv)
+s32 host_int_del_beacon(void *hWFIDrv)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -7256,13 +7255,13 @@ s32 host_int_del_beacon(WILC_WFIDrvHandle hWFIDrv)
 /**
  *  @brief host_int_add_station
  *  @details       Setting add station params in message queue
- *  @param[in]    WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam* pstrStaParams
+ *  @param[in]    void* hWFIDrv, tstrWILC_AddStaParam* pstrStaParams
  *  @return         Error code.
  *  @author
  *  @date
  *  @version	1.0
  */
-s32 host_int_add_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam *pstrStaParams)
+s32 host_int_add_station(void *hWFIDrv, tstrWILC_AddStaParam *pstrStaParams)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -7307,13 +7306,13 @@ s32 host_int_add_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam *pstrSt
 /**
  *  @brief host_int_del_station
  *  @details       Setting delete station params in message queue
- *  @param[in]    WILC_WFIDrvHandle hWFIDrv, u8* pu8MacAddr
+ *  @param[in]    void* hWFIDrv, u8* pu8MacAddr
  *  @return         Error code.
  *  @author
  *  @date
  *  @version	1.0
  */
-s32 host_int_del_station(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8MacAddr)
+s32 host_int_del_station(void *hWFIDrv, const u8 *pu8MacAddr)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -7353,13 +7352,13 @@ s32 host_int_del_station(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8MacAddr)
 /**
  *  @brief      host_int_del_allstation
  *  @details    Setting del station params in message queue
- *  @param[in]  WILC_WFIDrvHandle hWFIDrv, u8 pu8MacAddr[][ETH_ALEN]s
+ *  @param[in]  void* hWFIDrv, u8 pu8MacAddr[][ETH_ALEN]s
  *  @return        Error code.
  *  @author
  *  @date
  *  @version	1.0
  */
-s32 host_int_del_allstation(WILC_WFIDrvHandle hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
+s32 host_int_del_allstation(void *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -7417,13 +7416,13 @@ s32 host_int_del_allstation(WILC_WFIDrvHandle hWFIDrv, u8 pu8MacAddr[][ETH_ALEN]
 /**
  *  @brief host_int_edit_station
  *  @details       Setting edit station params in message queue
- *  @param[in]    WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam* pstrStaParams
+ *  @param[in]    void* hWFIDrv, tstrWILC_AddStaParam* pstrStaParams
  *  @return         Error code.
  *  @author
  *  @date
  *  @version	1.0
  */
-s32 host_int_edit_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam *pstrStaParams)
+s32 host_int_edit_station(void *hWFIDrv, tstrWILC_AddStaParam *pstrStaParams)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -7463,7 +7462,7 @@ s32 host_int_edit_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam *pstrS
 #endif /*WILC_AP_EXTERNAL_MLME*/
 uint32_t wilc_get_chipid(uint8_t);
 
-s32 host_int_set_power_mgmt(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled, u32 u32Timeout)
+s32 host_int_set_power_mgmt(void *hWFIDrv, bool bIsEnabled, u32 u32Timeout)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -7499,7 +7498,7 @@ s32 host_int_set_power_mgmt(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled, u32 u32T
 	return s32Error;
 }
 
-s32 host_int_setup_multicast_filter(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled, u32 u32count)
+s32 host_int_setup_multicast_filter(void *hWFIDrv, bool bIsEnabled, u32 u32count)
 {
 	s32 s32Error = WILC_SUCCESS;
 
@@ -7771,7 +7770,7 @@ void host_int_freeJoinParams(void *pJoinParams)
  *  @date
  *  @version		1.0**/
 
-static int host_int_addBASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char TID, short int BufferSize,
+static int host_int_addBASession(void *hWFIDrv, char *pBSSID, char TID, short int BufferSize,
 				 short int SessionTimeout, void *drvHandler)
 {
 	s32 s32Error = WILC_SUCCESS;
@@ -7807,7 +7806,7 @@ static int host_int_addBASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char T
 }
 
 
-s32 host_int_delBASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char TID)
+s32 host_int_delBASession(void *hWFIDrv, char *pBSSID, char TID)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -7842,7 +7841,7 @@ s32 host_int_delBASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char TID)
 	return s32Error;
 }
 
-s32 host_int_del_All_Rx_BASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char TID)
+s32 host_int_del_All_Rx_BASession(void *hWFIDrv, char *pBSSID, char TID)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -7885,7 +7884,7 @@ s32 host_int_del_All_Rx_BASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char
  *  @author		Abdelrahman Sobhy
  *  @date
  *  @version		1.0*/
-s32 host_int_setup_ipaddress(WILC_WFIDrvHandle hWFIDrv, u8 *u16ipadd, u8 idx)
+s32 host_int_setup_ipaddress(void *hWFIDrv, u8 *u16ipadd, u8 idx)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -7929,7 +7928,7 @@ s32 host_int_setup_ipaddress(WILC_WFIDrvHandle hWFIDrv, u8 *u16ipadd, u8 idx)
  *  @author		Abdelrahman Sobhy
  *  @date
  *  @version		1.0*/
-s32 host_int_get_ipaddress(WILC_WFIDrvHandle hWFIDrv, u8 *u16ipadd, u8 idx)
+s32 host_int_get_ipaddress(void *hWFIDrv, u8 *u16ipadd, u8 idx)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 38db740..fc07fd2 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -212,11 +212,6 @@ typedef void (*tWILCpfRemainOnChanExpired)(void *, u32);  /*Remain on channel ex
 typedef void (*tWILCpfRemainOnChanReady)(void *); /*Remain on channel callback function*/
 #endif
 
-/* typedef u32 WILC_WFIDrvHandle; */
-typedef struct {
-	s32 s32Dummy;
-} *WILC_WFIDrvHandle;
-
 /*!
  *  @struct             tstrRcvdNetworkInfo
  *  @brief		Structure to hold Received Asynchronous Network info
@@ -433,7 +428,7 @@ typedef struct {
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_remove_key(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8StaAddress);
+s32 host_int_remove_key(void *hWFIDrv, const u8 *pu8StaAddress);
 /**
  *  @brief              removes WEP key
  *  @details    valid only in BSS STA mode if External Supplicant support is enabled.
@@ -448,7 +443,7 @@ s32 host_int_remove_key(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8StaAddress);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_remove_wep_key(WILC_WFIDrvHandle hWFIDrv, u8 u8Index);
+s32 host_int_remove_wep_key(void *hWFIDrv, u8 u8Index);
 /**
  *  @brief              sets WEP deafault key
  *  @details    Sets the index of the WEP encryption key in use,
@@ -461,7 +456,7 @@ s32 host_int_remove_wep_key(WILC_WFIDrvHandle hWFIDrv, u8 u8Index);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_WEPDefaultKeyID(WILC_WFIDrvHandle hWFIDrv, u8 u8Index);
+s32 host_int_set_WEPDefaultKeyID(void *hWFIDrv, u8 u8Index);
 
 /**
  *  @brief              sets WEP deafault key
@@ -482,7 +477,7 @@ s32 host_int_set_WEPDefaultKeyID(WILC_WFIDrvHandle hWFIDrv, u8 u8Index);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_add_wep_key_bss_sta(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx);
+s32 host_int_add_wep_key_bss_sta(void *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx);
 /**
  *  @brief              host_int_add_wep_key_bss_ap
  *  @details    valid only in AP mode if External Supplicant support is enabled.
@@ -497,7 +492,7 @@ s32 host_int_add_wep_key_bss_sta(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8WepKey,
  *  @date		28 Feb 2013
  *  @version		1.0
  */
-s32 host_int_add_wep_key_bss_ap(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx, u8 u8mode, AUTHTYPE_T tenuAuth_type);
+s32 host_int_add_wep_key_bss_ap(void *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx, u8 u8mode, AUTHTYPE_T tenuAuth_type);
 
 /**
  *  @brief              adds ptk Key
@@ -515,7 +510,7 @@ s32 host_int_add_wep_key_bss_ap(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8WepKey,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_add_ptk(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
+s32 host_int_add_ptk(void *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 			     const u8 *mac_addr, const u8 *pu8RxMic, const u8 *pu8TxMic, u8 mode, u8 u8Ciphermode, u8 u8Idx);
 
 /**
@@ -530,7 +525,7 @@ s32 host_int_add_ptk(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen
  *  @date		15 April 2013
  *  @version		1.0
  */
-s32 host_int_get_inactive_time(WILC_WFIDrvHandle hWFIDrv, const u8 *mac, u32 *pu32InactiveTime);
+s32 host_int_get_inactive_time(void *hWFIDrv, const u8 *mac, u32 *pu32InactiveTime);
 
 /**
  *  @brief              adds Rx GTk Key
@@ -548,7 +543,7 @@ s32 host_int_get_inactive_time(WILC_WFIDrvHandle hWFIDrv, const u8 *mac, u32 *pu
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_add_rx_gtk(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKeylen,
+s32 host_int_add_rx_gtk(void *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKeylen,
 				u8 u8KeyIdx, u32 u32KeyRSClen, const u8 *KeyRSC,
 				const u8 *pu8RxMic, const u8 *pu8TxMic, u8 mode, u8 u8Ciphermode);
 
@@ -569,7 +564,7 @@ s32 host_int_add_rx_gtk(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkK
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_add_tx_gtk(WILC_WFIDrvHandle hWFIDrv, u8 u8KeyLen, u8 *pu8TxGtk, u8 u8KeyIdx);
+s32 host_int_add_tx_gtk(void *hWFIDrv, u8 u8KeyLen, u8 *pu8TxGtk, u8 u8KeyIdx);
 
 /**
  *  @brief              caches the pmkid
@@ -592,7 +587,7 @@ s32 host_int_add_tx_gtk(WILC_WFIDrvHandle hWFIDrv, u8 u8KeyLen, u8 *pu8TxGtk, u8
  *  @version		1.0
  */
 
-s32 host_int_set_pmkid_info(WILC_WFIDrvHandle hWFIDrv, tstrHostIFpmkidAttr *pu8PmkidInfoArray);
+s32 host_int_set_pmkid_info(void *hWFIDrv, tstrHostIFpmkidAttr *pu8PmkidInfoArray);
 /**
  *  @brief              gets the cached the pmkid info
  *  @details    valid only in BSS STA mode if External Supplicant
@@ -616,7 +611,7 @@ s32 host_int_set_pmkid_info(WILC_WFIDrvHandle hWFIDrv, tstrHostIFpmkidAttr *pu8P
  *  @version		1.0
  */
 
-s32 host_int_get_pmkid_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8PmkidInfoArray,
+s32 host_int_get_pmkid_info(void *hWFIDrv, u8 *pu8PmkidInfoArray,
 				    u32 u32PmkidInfoLen);
 
 /**
@@ -633,7 +628,7 @@ s32 host_int_get_pmkid_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8PmkidInfoArray,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_RSNAConfigPSKPassPhrase(WILC_WFIDrvHandle hWFIDrv, u8 *pu8PassPhrase,
+s32 host_int_set_RSNAConfigPSKPassPhrase(void *hWFIDrv, u8 *pu8PassPhrase,
 						 u8 u8Psklength);
 /**
  *  @brief              gets the pass phrase
@@ -649,7 +644,7 @@ s32 host_int_set_RSNAConfigPSKPassPhrase(WILC_WFIDrvHandle hWFIDrv, u8 *pu8PassP
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_RSNAConfigPSKPassPhrase(WILC_WFIDrvHandle hWFIDrv,
+s32 host_int_get_RSNAConfigPSKPassPhrase(void *hWFIDrv,
 						 u8 *pu8PassPhrase, u8 u8Psklength);
 
 /**
@@ -663,7 +658,7 @@ s32 host_int_get_RSNAConfigPSKPassPhrase(WILC_WFIDrvHandle hWFIDrv,
  *  @date		19 April 2012
  *  @version		1.0
  */
-s32 host_int_get_MacAddress(WILC_WFIDrvHandle hWFIDrv, u8 *pu8MacAddress);
+s32 host_int_get_MacAddress(void *hWFIDrv, u8 *pu8MacAddress);
 
 /**
  *  @brief              sets mac address
@@ -676,7 +671,7 @@ s32 host_int_get_MacAddress(WILC_WFIDrvHandle hWFIDrv, u8 *pu8MacAddress);
  *  @date		16 July 2012
  *  @version		1.0
  */
-s32 host_int_set_MacAddress(WILC_WFIDrvHandle hWFIDrv, u8 *pu8MacAddress);
+s32 host_int_set_MacAddress(void *hWFIDrv, u8 *pu8MacAddress);
 
 /**
  *  @brief              wait until msg q is empty
@@ -721,7 +716,7 @@ s32 host_int_wait_msg_queue_idle(void);
  *  @version		1.0
  */
 #ifndef CONNECT_DIRECT
-s32 host_int_get_site_survey_results(WILC_WFIDrvHandle hWFIDrv,
+s32 host_int_get_site_survey_results(void *hWFIDrv,
 					     u8 ppu8RcvdSiteSurveyResults[][MAX_SURVEY_RESULT_FRAG_SIZE],
 					     u32 u32MaxSiteSrvyFragLen);
 #endif
@@ -742,7 +737,7 @@ s32 host_int_get_site_survey_results(WILC_WFIDrvHandle hWFIDrv,
  *  @version		1.0
  */
 
-s32 host_int_set_start_scan_req(WILC_WFIDrvHandle hWFIDrv, u8 scanSource);
+s32 host_int_set_start_scan_req(void *hWFIDrv, u8 scanSource);
 /**
  *  @brief              gets scan source of the last scan
  *  @details
@@ -758,7 +753,7 @@ s32 host_int_set_start_scan_req(WILC_WFIDrvHandle hWFIDrv, u8 scanSource);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_start_scan_req(WILC_WFIDrvHandle hWFIDrv, u8 *pu8ScanSource);
+s32 host_int_get_start_scan_req(void *hWFIDrv, u8 *pu8ScanSource);
 
 /**
  *  @brief              sets a join request
@@ -772,7 +767,7 @@ s32 host_int_get_start_scan_req(WILC_WFIDrvHandle hWFIDrv, u8 *pu8ScanSource);
  *  @version		1.0
  */
 
-s32 host_int_set_join_req(WILC_WFIDrvHandle hWFIDrv, u8 *pu8bssid,
+s32 host_int_set_join_req(void *hWFIDrv, u8 *pu8bssid,
 				  const u8 *pu8ssid, size_t ssidLen,
 				  const u8 *pu8IEs, size_t IEsLen,
 				  tWILCpfConnectResult pfConnectResult, void *pvUserArg,
@@ -792,7 +787,7 @@ s32 host_int_set_join_req(WILC_WFIDrvHandle hWFIDrv, u8 *pu8bssid,
  *  @version		8.0
  */
 
-s32 host_int_flush_join_req(WILC_WFIDrvHandle hWFIDrv);
+s32 host_int_flush_join_req(void *hWFIDrv);
 
 
 /**
@@ -806,7 +801,7 @@ s32 host_int_flush_join_req(WILC_WFIDrvHandle hWFIDrv);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_disconnect(WILC_WFIDrvHandle hWFIDrv, u16 u16ReasonCode);
+s32 host_int_disconnect(void *hWFIDrv, u16 u16ReasonCode);
 
 /**
  *  @brief              disconnects a sta
@@ -819,7 +814,7 @@ s32 host_int_disconnect(WILC_WFIDrvHandle hWFIDrv, u16 u16ReasonCode);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_disconnect_station(WILC_WFIDrvHandle hWFIDrv, u8 assoc_id);
+s32 host_int_disconnect_station(void *hWFIDrv, u8 assoc_id);
 /**
  *  @brief              gets a Association request info
  *  @details
@@ -846,7 +841,7 @@ s32 host_int_disconnect_station(WILC_WFIDrvHandle hWFIDrv, u8 assoc_id);
  *  @version		1.0
  */
 
-s32 host_int_get_assoc_req_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8AssocReqInfo,
+s32 host_int_get_assoc_req_info(void *hWFIDrv, u8 *pu8AssocReqInfo,
 					u32 u32AssocReqInfoLen);
 /**
  *  @brief              gets a Association Response info
@@ -860,7 +855,7 @@ s32 host_int_get_assoc_req_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8AssocReqInfo,
  *  @version		1.0
  */
 
-s32 host_int_get_assoc_res_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8AssocRespInfo,
+s32 host_int_get_assoc_res_info(void *hWFIDrv, u8 *pu8AssocRespInfo,
 					u32 u32MaxAssocRespInfoLen, u32 *pu32RcvdAssocRespInfoLen);
 /**
  *  @brief              gets a Association Response info
@@ -877,7 +872,7 @@ s32 host_int_get_assoc_res_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8AssocRespInfo,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_rx_power_level(WILC_WFIDrvHandle hWFIDrv, u8 *pu8RxPowerLevel,
+s32 host_int_get_rx_power_level(void *hWFIDrv, u8 *pu8RxPowerLevel,
 					u32 u32RxPowerLevelLen);
 
 /**
@@ -895,7 +890,7 @@ s32 host_int_get_rx_power_level(WILC_WFIDrvHandle hWFIDrv, u8 *pu8RxPowerLevel,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_mac_chnl_num(WILC_WFIDrvHandle hWFIDrv, u8 u8ChNum);
+s32 host_int_set_mac_chnl_num(void *hWFIDrv, u8 u8ChNum);
 
 /**
  *  @brief              gets the current channel index
@@ -912,7 +907,7 @@ s32 host_int_set_mac_chnl_num(WILC_WFIDrvHandle hWFIDrv, u8 u8ChNum);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_host_chnl_num(WILC_WFIDrvHandle hWFIDrv, u8 *pu8ChNo);
+s32 host_int_get_host_chnl_num(void *hWFIDrv, u8 *pu8ChNo);
 /**
  *  @brief              gets the sta rssi
  *  @details    gets the currently maintained RSSI value for the station.
@@ -926,8 +921,8 @@ s32 host_int_get_host_chnl_num(WILC_WFIDrvHandle hWFIDrv, u8 *pu8ChNo);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_rssi(WILC_WFIDrvHandle hWFIDrv, s8 *ps8Rssi);
-s32 host_int_get_link_speed(WILC_WFIDrvHandle hWFIDrv, s8 *ps8lnkspd);
+s32 host_int_get_rssi(void *hWFIDrv, s8 *ps8Rssi);
+s32 host_int_get_link_speed(void *hWFIDrv, s8 *ps8lnkspd);
 /**
  *  @brief              scans a set of channels
  *  @details
@@ -945,7 +940,7 @@ s32 host_int_get_link_speed(WILC_WFIDrvHandle hWFIDrv, s8 *ps8lnkspd);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_scan(WILC_WFIDrvHandle hWFIDrv, u8 u8ScanSource,
+s32 host_int_scan(void *hWFIDrv, u8 u8ScanSource,
 			  u8 u8ScanType, u8 *pu8ChnlFreqList,
 			  u8 u8ChnlListLen, const u8 *pu8IEs,
 			  size_t IEsLen, tWILCpfScanResult ScanResult,
@@ -961,7 +956,7 @@ s32 host_int_scan(WILC_WFIDrvHandle hWFIDrv, u8 u8ScanSource,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 hif_set_cfg(WILC_WFIDrvHandle hWFIDrv, tstrCfgParamVal *pstrCfgParamVal);
+s32 hif_set_cfg(void *hWFIDrv, tstrCfgParamVal *pstrCfgParamVal);
 
 /**
  *  @brief              gets configuration wids values
@@ -975,7 +970,7 @@ s32 hif_set_cfg(WILC_WFIDrvHandle hWFIDrv, tstrCfgParamVal *pstrCfgParamVal);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 hif_get_cfg(WILC_WFIDrvHandle hWFIDrv, u16 u16WID, u16 *pu16WID_Value);
+s32 hif_get_cfg(void *hWFIDrv, u16 u16WID, u16 *pu16WID_Value);
 /*****************************************************************************/
 /*							Notification Functions							 */
 /*****************************************************************************/
@@ -1022,7 +1017,7 @@ void host_int_send_network_info_to_host
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_init(WILC_WFIDrvHandle *phWFIDrv);
+s32 host_int_init(void **phWFIDrv);
 
 /**
  *  @brief              host interface initialization function
@@ -1033,11 +1028,11 @@ s32 host_int_init(WILC_WFIDrvHandle *phWFIDrv);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_deinit(WILC_WFIDrvHandle hWFIDrv);
+s32 host_int_deinit(void *hWFIDrv);
 
 
 /*!
- *  @fn		s32 host_int_add_beacon(WILC_WFIDrvHandle hWFIDrv,u8 u8Index)
+ *  @fn		s32 host_int_add_beacon(void *hWFIDrv,u8 u8Index)
  *  @brief		Sends a beacon to the firmware to be transmitted over the air
  *  @details
  *  @param[in,out]	hWFIDrv		handle to the wifi driver
@@ -1058,14 +1053,14 @@ s32 host_int_deinit(WILC_WFIDrvHandle hWFIDrv);
  *  @version		1.0 Description
  *
  */
-s32 host_int_add_beacon(WILC_WFIDrvHandle hWFIDrv, u32 u32Interval,
+s32 host_int_add_beacon(void *hWFIDrv, u32 u32Interval,
 				u32 u32DTIMPeriod,
 				u32 u32HeadLen, u8 *pu8Head,
 				u32 u32TailLen, u8 *pu8tail);
 
 
 /*!
- *  @fn		s32 host_int_del_beacon(WILC_WFIDrvHandle hWFIDrv)
+ *  @fn		s32 host_int_del_beacon(void *hWFIDrv)
  *  @brief		Removes the beacon and stops trawilctting it over the air
  *  @details
  *  @param[in,out]	hWFIDrv		handle to the wifi driver
@@ -1076,10 +1071,10 @@ s32 host_int_add_beacon(WILC_WFIDrvHandle hWFIDrv, u32 u32Interval,
  *  @date		10 Julys 2012
  *  @version		1.0 Description
  */
-s32 host_int_del_beacon(WILC_WFIDrvHandle hWFIDrv);
+s32 host_int_del_beacon(void *hWFIDrv);
 
 /*!
- *  @fn		s32 host_int_add_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam strStaParams)
+ *  @fn		s32 host_int_add_station(void *hWFIDrv, tstrWILC_AddStaParam strStaParams)
  *  @brief		Notifies the firmware with a new associated stations
  *  @details
  *  @param[in,out]	hWFIDrv		handle to the wifi driver
@@ -1091,10 +1086,10 @@ s32 host_int_del_beacon(WILC_WFIDrvHandle hWFIDrv);
  *  @date		12 July 2012
  *  @version		1.0 Description
  */
-s32 host_int_add_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam *pstrStaParams);
+s32 host_int_add_station(void *hWFIDrv, tstrWILC_AddStaParam *pstrStaParams);
 
 /*!
- *  @fn		s32 host_int_del_allstation(WILC_WFIDrvHandle hWFIDrv, const u8* pu8MacAddr)
+ *  @fn		s32 host_int_del_allstation(void *hWFIDrv, const u8* pu8MacAddr)
  *  @brief		Deauthenticates clients when group is terminating
  *  @details
  *  @param[in,out]	hWFIDrv		handle to the wifi driver
@@ -1106,10 +1101,10 @@ s32 host_int_add_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam *pstrSt
  *  @date		09 April 2014
  *  @version		1.0 Description
  */
-s32 host_int_del_allstation(WILC_WFIDrvHandle hWFIDrv, u8 pu8MacAddr[][ETH_ALEN]);
+s32 host_int_del_allstation(void *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN]);
 
 /*!
- *  @fn		s32 host_int_del_station(WILC_WFIDrvHandle hWFIDrv, u8* pu8MacAddr)
+ *  @fn		s32 host_int_del_station(void *hWFIDrv, u8* pu8MacAddr)
  *  @brief		Notifies the firmware with a new deleted station
  *  @details
  *  @param[in,out]	hWFIDrv		handle to the wifi driver
@@ -1121,10 +1116,10 @@ s32 host_int_del_allstation(WILC_WFIDrvHandle hWFIDrv, u8 pu8MacAddr[][ETH_ALEN]
  *  @date		15 July 2012
  *  @version		1.0 Description
  */
-s32 host_int_del_station(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8MacAddr);
+s32 host_int_del_station(void *hWFIDrv, const u8 *pu8MacAddr);
 
 /*!
- *  @fn		s32 host_int_edit_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam strStaParams)
+ *  @fn		s32 host_int_edit_station(void *hWFIDrv, tstrWILC_AddStaParam strStaParams)
  *  @brief		Notifies the firmware with new parameters of an already associated station
  *  @details
  *  @param[in,out]	hWFIDrv		handle to the wifi driver
@@ -1136,10 +1131,10 @@ s32 host_int_del_station(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8MacAddr);
  *  @date		15 July 2012
  *  @version		1.0 Description
  */
-s32 host_int_edit_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam *pstrStaParams);
+s32 host_int_edit_station(void *hWFIDrv, tstrWILC_AddStaParam *pstrStaParams);
 
 /*!
- *  @fn		s32 host_int_set_power_mgmt(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled, u32 u32Timeout)
+ *  @fn		s32 host_int_set_power_mgmt(void *hWFIDrv, bool bIsEnabled, u32 u32Timeout)
  *  @brief		Set the power management mode to enabled or disabled
  *  @details
  *  @param[in,out]	hWFIDrv		handle to the wifi driver
@@ -1153,7 +1148,7 @@ s32 host_int_edit_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam *pstrS
  *  @date		24 November 2012
  *  @version		1.0 Description
  */
-s32 host_int_set_power_mgmt(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled, u32 u32Timeout);
+s32 host_int_set_power_mgmt(void *hWFIDrv, bool bIsEnabled, u32 u32Timeout);
 /*  @param[in,out]	hWFIDrv		handle to the wifi driver
  *  @param[in]	bIsEnabled	TRUE if enabled, FALSE otherwise
  *  @param[in]	u8count		count of mac address entries in the filter table
@@ -1165,7 +1160,7 @@ s32 host_int_set_power_mgmt(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled, u32 u32T
  *  @date		24 November 2012
  *  @version		1.0 Description
  */
-s32 host_int_setup_multicast_filter(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled, u32 u32count);
+s32 host_int_setup_multicast_filter(void *hWFIDrv, bool bIsEnabled, u32 u32count);
 /**
  *  @brief           host_int_setup_ipaddress
  *  @details       set IP address on firmware
@@ -1175,7 +1170,7 @@ s32 host_int_setup_multicast_filter(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled,
  *  @date
  *  @version	1.0
  */
-s32 host_int_setup_ipaddress(WILC_WFIDrvHandle hWFIDrv, u8 *pu8IPAddr, u8 idx);
+s32 host_int_setup_ipaddress(void *hWFIDrv, u8 *pu8IPAddr, u8 idx);
 
 
 /**
@@ -1187,7 +1182,7 @@ s32 host_int_setup_ipaddress(WILC_WFIDrvHandle hWFIDrv, u8 *pu8IPAddr, u8 idx);
  *  @date
  *  @version	1.0
  */
-s32 host_int_delBASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char TID);
+s32 host_int_delBASession(void *hWFIDrv, char *pBSSID, char TID);
 
 /**
  *  @brief           host_int_delBASession
@@ -1198,7 +1193,7 @@ s32 host_int_delBASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char TID);
  *  @date
  *  @version	1.0
  */
-s32 host_int_del_All_Rx_BASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char TID);
+s32 host_int_del_All_Rx_BASession(void *hWFIDrv, char *pBSSID, char TID);
 
 
 /**
@@ -1210,7 +1205,7 @@ s32 host_int_del_All_Rx_BASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char
  *  @date
  *  @version	1.0
  */
-s32 host_int_get_ipaddress(WILC_WFIDrvHandle hWFIDrv, u8 *pu8IPAddr, u8 idx);
+s32 host_int_get_ipaddress(void *hWFIDrv, u8 *pu8IPAddr, u8 idx);
 
 #ifdef WILC_P2P
 /**
@@ -1222,7 +1217,7 @@ s32 host_int_get_ipaddress(WILC_WFIDrvHandle hWFIDrv, u8 *pu8IPAddr, u8 idx);
  *  @date
  *  @version	1.0
  */
-s32 host_int_remain_on_channel(WILC_WFIDrvHandle hWFIDrv, u32 u32SessionID, u32 u32duration, u16 chan, tWILCpfRemainOnChanExpired RemainOnChanExpired, tWILCpfRemainOnChanReady RemainOnChanReady, void *pvUserArg);
+s32 host_int_remain_on_channel(void *hWFIDrv, u32 u32SessionID, u32 u32duration, u16 chan, tWILCpfRemainOnChanExpired RemainOnChanExpired, tWILCpfRemainOnChanReady RemainOnChanReady, void *pvUserArg);
 
 /**
  *  @brief              host_int_ListenStateExpired
@@ -1238,7 +1233,7 @@ s32 host_int_remain_on_channel(WILC_WFIDrvHandle hWFIDrv, u32 u32SessionID, u32
  *  @date
  *  @version		1.0
  */
-s32 host_int_ListenStateExpired(WILC_WFIDrvHandle hWFIDrv, u32 u32SessionID);
+s32 host_int_ListenStateExpired(void *hWFIDrv, u32 u32SessionID);
 
 /**
  *  @brief           host_int_frame_register
@@ -1249,7 +1244,7 @@ s32 host_int_ListenStateExpired(WILC_WFIDrvHandle hWFIDrv, u32 u32SessionID);
  *  @date
  *  @version	1.0
  */
-s32 host_int_frame_register(WILC_WFIDrvHandle hWFIDrv, u16 u16FrameType, bool bReg);
+s32 host_int_frame_register(void *hWFIDrv, u16 u16FrameType, bool bReg);
 #endif
 /**
  *  @brief           host_int_set_wfi_drv_handler
@@ -1261,17 +1256,17 @@ s32 host_int_frame_register(WILC_WFIDrvHandle hWFIDrv, u16 u16FrameType, bool bR
  *  @version	1.0
  */
 s32 host_int_set_wfi_drv_handler(u32 u32address);
-s32 host_int_set_operation_mode(WILC_WFIDrvHandle hWFIDrv, u32 u32mode);
+s32 host_int_set_operation_mode(void *hWFIDrv, u32 u32mode);
 
 static s32 Handle_ScanDone(void *drvHandler, tenuScanEvent enuEvent);
 
-static int host_int_addBASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char TID, short int BufferSize,
+static int host_int_addBASession(void *hWFIDrv, char *pBSSID, char TID, short int BufferSize,
 				 short int SessionTimeout, void *drvHandler);
 
 
 void host_int_freeJoinParams(void *pJoinParams);
 
-s32 host_int_get_statistics(WILC_WFIDrvHandle hWFIDrv, tstrStatistics *pstrStatistics);
+s32 host_int_get_statistics(void *hWFIDrv, tstrStatistics *pstrStatistics);
 
 /*****************************************************************************/
 /*																			 */
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index b352c50..c6bf7e3 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -310,13 +310,13 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 
 
 		if (bEnablePS)
-			host_int_set_power_mgmt((WILC_WFIDrvHandle)pstrWFIDrv, 1, 0);
+			host_int_set_power_mgmt((void *)pstrWFIDrv, 1, 0);
 
 		PRINT_D(GENERIC_DBG, "[%s] Up IP\n", dev_iface->ifa_label);
 
 		pIP_Add_buff = (char *) (&(dev_iface->ifa_address));
 		PRINT_D(GENERIC_DBG, "IP add=%d:%d:%d:%d \n", pIP_Add_buff[0], pIP_Add_buff[1], pIP_Add_buff[2], pIP_Add_buff[3]);
-		host_int_setup_ipaddress((WILC_WFIDrvHandle)pstrWFIDrv, pIP_Add_buff, nic->u8IfIdx);
+		host_int_setup_ipaddress((void *)pstrWFIDrv, pIP_Add_buff, nic->u8IfIdx);
 
 		break;
 
@@ -330,7 +330,7 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 		}
 
 		if (memcmp(dev_iface->ifa_label, wlan_dev_name, 5) == 0)
-			host_int_set_power_mgmt((WILC_WFIDrvHandle)pstrWFIDrv, 0, 0);
+			host_int_set_power_mgmt((void *)pstrWFIDrv, 0, 0);
 
 		resolve_disconnect_aberration(pstrWFIDrv);
 
@@ -340,7 +340,7 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 		pIP_Add_buff = null_ip;
 		PRINT_D(GENERIC_DBG, "IP add=%d:%d:%d:%d \n", pIP_Add_buff[0], pIP_Add_buff[1], pIP_Add_buff[2], pIP_Add_buff[3]);
 
-		host_int_setup_ipaddress((WILC_WFIDrvHandle)pstrWFIDrv, pIP_Add_buff, nic->u8IfIdx);
+		host_int_setup_ipaddress((void *)pstrWFIDrv, pIP_Add_buff, nic->u8IfIdx);
 
 		break;
 
@@ -2165,14 +2165,14 @@ static void wilc_set_multicast_list(struct net_device *dev)
 	if ((dev->flags & IFF_ALLMULTI) || (dev->mc.count) > WILC_MULTICAST_TABLE_SIZE) {
 		PRINT_D(INIT_DBG, "Disable multicast filter, retrive all multicast packets\n");
 		/* get all multicast packets */
-		host_int_setup_multicast_filter((WILC_WFIDrvHandle)pstrWFIDrv, false, 0);
+		host_int_setup_multicast_filter((void *)pstrWFIDrv, false, 0);
 		return;
 	}
 
 	/* No multicast?  Just get our own stuff */
 	if ((dev->mc.count) == 0) {
 		PRINT_D(INIT_DBG, "Enable multicast filter, retrive directed packets only.\n");
-		host_int_setup_multicast_filter((WILC_WFIDrvHandle)pstrWFIDrv, true, 0);
+		host_int_setup_multicast_filter((void *)pstrWFIDrv, true, 0);
 		return;
 	}
 
@@ -2185,7 +2185,7 @@ static void wilc_set_multicast_list(struct net_device *dev)
 		i++;
 	}
 
-	host_int_setup_multicast_filter((WILC_WFIDrvHandle)pstrWFIDrv, true, (dev->mc.count));
+	host_int_setup_multicast_filter((void *)pstrWFIDrv, true, (dev->mc.count));
 
 	return;
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index a8974c2..28ec14d 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2907,15 +2907,15 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
 
 			/*Setting interface 1 drv handler and mac address in newly downloaded FW*/
 			host_int_set_wfi_drv_handler(g_linux_wlan->strInterfaceInfo[0].drvHandler);
-			host_int_set_MacAddress((WILC_WFIDrvHandle)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
+			host_int_set_MacAddress(g_linux_wlan->strInterfaceInfo[0].drvHandler,
 						g_linux_wlan->strInterfaceInfo[0].aSrcAddress);
 			host_int_set_operation_mode(priv->hWILCWFIDrv, STATION_MODE);
 
 			/*Add saved WEP keys, if any*/
 			if (g_wep_keys_saved) {
-				host_int_set_WEPDefaultKeyID((WILC_WFIDrvHandle)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
+				host_int_set_WEPDefaultKeyID(g_linux_wlan->strInterfaceInfo[0].drvHandler,
 							     g_key_wep_params.key_idx);
-				host_int_add_wep_key_bss_sta((WILC_WFIDrvHandle)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
+				host_int_add_wep_key_bss_sta(g_linux_wlan->strInterfaceInfo[0].drvHandler,
 							     g_key_wep_params.key,
 							     g_key_wep_params.key_len,
 							     g_key_wep_params.key_idx);
@@ -2995,15 +2995,15 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
 			g_wilc_initialized = 1;
 
 			host_int_set_wfi_drv_handler(g_linux_wlan->strInterfaceInfo[0].drvHandler);
-			host_int_set_MacAddress((WILC_WFIDrvHandle)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
+			host_int_set_MacAddress(g_linux_wlan->strInterfaceInfo[0].drvHandler,
 						g_linux_wlan->strInterfaceInfo[0].aSrcAddress);
 			host_int_set_operation_mode(priv->hWILCWFIDrv, STATION_MODE);
 
 			/*Add saved WEP keys, if any*/
 			if (g_wep_keys_saved) {
-				host_int_set_WEPDefaultKeyID((WILC_WFIDrvHandle)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
+				host_int_set_WEPDefaultKeyID(g_linux_wlan->strInterfaceInfo[0].drvHandler,
 							     g_key_wep_params.key_idx);
-				host_int_add_wep_key_bss_sta((WILC_WFIDrvHandle)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
+				host_int_add_wep_key_bss_sta(g_linux_wlan->strInterfaceInfo[0].drvHandler,
 							     g_key_wep_params.key,
 							     g_key_wep_params.key_len,
 							     g_key_wep_params.key_idx);
@@ -3127,15 +3127,15 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
 
 		/*Setting interface 1 drv handler and mac address in newly downloaded FW*/
 		host_int_set_wfi_drv_handler(g_linux_wlan->strInterfaceInfo[0].drvHandler);
-		host_int_set_MacAddress((WILC_WFIDrvHandle)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
+		host_int_set_MacAddress(g_linux_wlan->strInterfaceInfo[0].drvHandler,
 					g_linux_wlan->strInterfaceInfo[0].aSrcAddress);
 		host_int_set_operation_mode(priv->hWILCWFIDrv, AP_MODE);
 
 		/*Add saved WEP keys, if any*/
 		if (g_wep_keys_saved) {
-			host_int_set_WEPDefaultKeyID((WILC_WFIDrvHandle)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
+			host_int_set_WEPDefaultKeyID(g_linux_wlan->strInterfaceInfo[0].drvHandler,
 						     g_key_wep_params.key_idx);
-			host_int_add_wep_key_bss_sta((WILC_WFIDrvHandle)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
+			host_int_add_wep_key_bss_sta(g_linux_wlan->strInterfaceInfo[0].drvHandler,
 						     g_key_wep_params.key,
 						     g_key_wep_params.key_len,
 						     g_key_wep_params.key_idx);
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index d413fa3..4f76015 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -143,8 +143,7 @@ struct WILC_WFI_priv {
 	spinlock_t lock;
 	struct net_device *dev;
 	struct napi_struct napi;
-	WILC_WFIDrvHandle hWILCWFIDrv;
-	WILC_WFIDrvHandle hWILCWFIDrv_2;
+	void *hWILCWFIDrv;
 	tstrHostIFpmkidAttr pmkid_list;
 	struct WILC_WFI_stats netstats;
 	u8 WILC_WFI_wep_default;
-- 
2.4.4

