Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:38002 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbbHMElo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 00:41:44 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <jude.lee@atmel.com>, <robin.hwang@atmel.com>
Subject: [PATCH 1/5] staging: wilc1000: replace WILC_WFIDrvHandle by tstrWILC_WFIDrv
Date: Thu, 13 Aug 2015 13:41:19 +0900
Message-ID: <1439440883-16061-2-git-send-email-tony.cho@atmel.com> (sfid-20150813_064156_088995_D5088B0C)
In-Reply-To: <1439440883-16061-1-git-send-email-tony.cho@atmel.com>
References: <1439440883-16061-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johnny Kim <johnny.kim@atmel.com>

The structure, WILC_WFIDrvHandle is used to save the pointer address
for the driver handler which is used throughout the driver but it's
not easy to understand what it means. In addition, it doesn't support
the 64 bit machine and also causes the warnings for the 64 bit build.

This patch replaces the WILC_WFIDrvHandle by the tstrWILC_WFIDrv
because the tstrWILC_WFIDrv is real structure to represent the driver
handler and reduces the 64 bit compile warnings. Also, typecasting to
WILC_WFIDrvHandle is not needed by using tstrWILC_WFIDrv as is.

Signed-off-by: Johnny Kim <johnny.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         | 126 +++++++++++-----------
 drivers/staging/wilc1000/host_interface.h         | 104 +++++++++---------
 drivers/staging/wilc1000/linux_wlan.c             |  16 +--
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  22 ++--
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |   4 +-
 5 files changed, 136 insertions(+), 136 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index cc549c2..20a554f 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -751,7 +751,7 @@ s32 Handle_set_IPAddress(void *drvHandler, u8 *pu8IPAddr, u8 idx)
 
 
 
-	host_int_get_ipaddress((WILC_WFIDrvHandle)drvHandler, firmwareIPAddress, idx);
+	host_int_get_ipaddress(drvHandler, firmwareIPAddress, idx);
 
 	if (s32Error) {
 		PRINT_D(HOSTINF_DBG, "Failed to set IP address\n");
@@ -801,7 +801,7 @@ s32 Handle_get_IPAddress(void *drvHandler, u8 *pu8IPAddr, u8 idx)
 	WILC_FREE(strWID.ps8WidVal);
 
 	if (memcmp(gs8GetIP[idx], gs8SetIP[idx], IP_ALEN) != 0)
-		host_int_setup_ipaddress((WILC_WFIDrvHandle)pstrWFIDrv, gs8SetIP[idx], idx);
+		host_int_setup_ipaddress(pstrWFIDrv, gs8SetIP[idx], idx);
 
 	if (s32Error != WILC_SUCCESS) {
 		PRINT_ER("Failed to get IP address\n");
@@ -1497,7 +1497,7 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 
 
 	PRINT_D(HOSTINF_DBG, "Getting site survey results\n");
-	s32Err = host_int_get_site_survey_results((WILC_WFIDrvHandle)pstrWFIDrv,
+	s32Err = host_int_get_site_survey_results(pstrWFIDrv,
 						  gapu8RcvdSurveyResults,
 						  MAX_SURVEY_RESULT_FRAG_SIZE);
 	if (s32Err) {
@@ -2402,7 +2402,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
 			if (u8MacStatus == MAC_CONNECTED) {
 				memset(gapu8RcvdAssocResp, 0, MAX_ASSOC_RESP_FRAME_SIZE);
 
-				host_int_get_assoc_res_info((WILC_WFIDrvHandle)pstrWFIDrv,
+				host_int_get_assoc_res_info(pstrWFIDrv,
 							    gapu8RcvdAssocResp,
 							    MAX_ASSOC_RESP_FRAME_SIZE,
 							    &u32RcvdAssocRespInfoLen);
@@ -2492,7 +2492,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
 			    (strConnectInfo.u16ConnectStatus == SUCCESSFUL_STATUSCODE))	{
 				#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 
-				host_int_set_power_mgmt((WILC_WFIDrvHandle)pstrWFIDrv, 0, 0);
+				host_int_set_power_mgmt(pstrWFIDrv, 0, 0);
 				#endif
 
 				PRINT_D(HOSTINF_DBG, "MAC status : CONNECTED and Connect Status : Successful\n");
@@ -2568,7 +2568,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
 				#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 
 				g_obtainingIP = false;
-				host_int_set_power_mgmt((WILC_WFIDrvHandle)pstrWFIDrv, 0, 0);
+				host_int_set_power_mgmt(pstrWFIDrv, 0, 0);
 				#endif
 
 				pstrWFIDrv->strWILC_UsrConnReq.pfUserConnectResult(CONN_DISCONN_EVENT_DISCONN_NOTIF,
@@ -3047,7 +3047,7 @@ static void Handle_Disconnect(void *drvHandler)
 	#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 
 	g_obtainingIP = false;
-	host_int_set_power_mgmt((WILC_WFIDrvHandle)pstrWFIDrv, 0, 0);
+	host_int_set_power_mgmt(pstrWFIDrv, 0, 0);
 	#endif
 
 	memset(u8ConnectedSSID, 0, ETH_ALEN);
@@ -3148,7 +3148,7 @@ void resolve_disconnect_aberration(void *drvHandler)
 		return;
 	if ((pstrWFIDrv->enuHostIFstate == HOST_IF_WAITING_CONN_RESP) || (pstrWFIDrv->enuHostIFstate == HOST_IF_CONNECTING)) {
 		PRINT_D(HOSTINF_DBG, "\n\n<< correcting Supplicant state machine >>\n\n");
-		host_int_disconnect((WILC_WFIDrvHandle)pstrWFIDrv, 1);
+		host_int_disconnect(pstrWFIDrv, 1);
 	}
 }
 static s32 Switch_Log_Terminal(void *drvHandler)
@@ -4582,7 +4582,7 @@ static void TimerCB_Connect(void *pvArg)
  *  @version		1.0
  */
 /* Check implementation in core adding 9 bytes to the input! */
-s32 host_int_remove_key(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8StaAddress)
+s32 host_int_remove_key(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8StaAddress)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -4611,7 +4611,7 @@ s32 host_int_remove_key(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8StaAddress)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_remove_wep_key(WILC_WFIDrvHandle hWFIDrv, u8 u8keyIdx)
+s32 host_int_remove_wep_key(tstrWILC_WFIDrv *hWFIDrv, u8 u8keyIdx)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -4660,7 +4660,7 @@ s32 host_int_remove_wep_key(WILC_WFIDrvHandle hWFIDrv, u8 u8keyIdx)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_WEPDefaultKeyID(WILC_WFIDrvHandle hWFIDrv, u8 u8Index)
+s32 host_int_set_WEPDefaultKeyID(tstrWILC_WFIDrv *hWFIDrv, u8 u8Index)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -4716,7 +4716,7 @@ s32 host_int_set_WEPDefaultKeyID(WILC_WFIDrvHandle hWFIDrv, u8 u8Index)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_add_wep_key_bss_sta(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx)
+s32 host_int_add_wep_key_bss_sta(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx)
 {
 
 	s32 s32Error = WILC_SUCCESS;
@@ -4781,7 +4781,7 @@ s32 host_int_add_wep_key_bss_sta(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8WepKey,
  *  @date		28 FEB 2013
  *  @version		1.0
  */
-s32 host_int_add_wep_key_bss_ap(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx, u8 u8mode, AUTHTYPE_T tenuAuth_type)
+s32 host_int_add_wep_key_bss_ap(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx, u8 u8mode, AUTHTYPE_T tenuAuth_type)
 {
 
 	s32 s32Error = WILC_SUCCESS;
@@ -4856,7 +4856,7 @@ s32 host_int_add_wep_key_bss_ap(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8WepKey,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_add_ptk(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
+s32 host_int_add_ptk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 			     const u8 *mac_addr, const u8 *pu8RxMic, const u8 *pu8TxMic, u8 mode, u8 u8Ciphermode, u8 u8Idx)
 {
 	s32 s32Error = WILC_SUCCESS;
@@ -4956,7 +4956,7 @@ s32 host_int_add_ptk(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_add_rx_gtk(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKeylen,
+s32 host_int_add_rx_gtk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKeylen,
 				u8 u8KeyIdx, u32 u32KeyRSClen, const u8 *KeyRSC,
 				const u8 *pu8RxMic, const u8 *pu8TxMic, u8 mode, u8 u8Ciphermode)
 {
@@ -5063,7 +5063,7 @@ s32 host_int_add_rx_gtk(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkK
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_pmkid_info(WILC_WFIDrvHandle hWFIDrv, tstrHostIFpmkidAttr *pu8PmkidInfoArray)
+s32 host_int_set_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, tstrHostIFpmkidAttr *pu8PmkidInfoArray)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -5125,7 +5125,7 @@ s32 host_int_set_pmkid_info(WILC_WFIDrvHandle hWFIDrv, tstrHostIFpmkidAttr *pu8P
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_pmkid_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8PmkidInfoArray,
+s32 host_int_get_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8PmkidInfoArray,
 				    u32 u32PmkidInfoLen)
 {
 	s32 s32Error = WILC_SUCCESS;
@@ -5154,7 +5154,7 @@ s32 host_int_get_pmkid_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8PmkidInfoArray,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_RSNAConfigPSKPassPhrase(WILC_WFIDrvHandle hWFIDrv, u8 *pu8PassPhrase,
+s32 host_int_set_RSNAConfigPSKPassPhrase(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8PassPhrase,
 						 u8 u8Psklength)
 {
 	s32 s32Error = WILC_SUCCESS;
@@ -5183,7 +5183,7 @@ s32 host_int_set_RSNAConfigPSKPassPhrase(WILC_WFIDrvHandle hWFIDrv, u8 *pu8PassP
  *  @date		19 April 2012
  *  @version		1.0
  */
-s32 host_int_get_MacAddress(WILC_WFIDrvHandle hWFIDrv, u8 *pu8MacAddress)
+s32 host_int_get_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
@@ -5217,7 +5217,7 @@ s32 host_int_get_MacAddress(WILC_WFIDrvHandle hWFIDrv, u8 *pu8MacAddress)
  *  @date		16 July 2012
  *  @version		1.0
  */
-s32 host_int_set_MacAddress(WILC_WFIDrvHandle hWFIDrv, u8 *pu8MacAddress)
+s32 host_int_set_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
@@ -5258,7 +5258,7 @@ s32 host_int_set_MacAddress(WILC_WFIDrvHandle hWFIDrv, u8 *pu8MacAddress)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_RSNAConfigPSKPassPhrase(WILC_WFIDrvHandle hWFIDrv,
+s32 host_int_get_RSNAConfigPSKPassPhrase(tstrWILC_WFIDrv *hWFIDrv,
 						 u8 *pu8PassPhrase, u8 u8Psklength)
 {
 	s32 s32Error = WILC_SUCCESS;
@@ -5305,7 +5305,7 @@ s32 host_int_get_RSNAConfigPSKPassPhrase(WILC_WFIDrvHandle hWFIDrv,
  *  @version		1.0
  */
 #ifndef CONNECT_DIRECT
-s32 host_int_get_site_survey_results(WILC_WFIDrvHandle hWFIDrv,
+s32 host_int_get_site_survey_results(tstrWILC_WFIDrv *hWFIDrv,
 					     u8 ppu8RcvdSiteSurveyResults[][MAX_SURVEY_RESULT_FRAG_SIZE],
 					     u32 u32MaxSiteSrvyFragLen)
 {
@@ -5355,7 +5355,7 @@ s32 host_int_get_site_survey_results(WILC_WFIDrvHandle hWFIDrv,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_start_scan_req(WILC_WFIDrvHandle hWFIDrv, u8 scanSource)
+s32 host_int_set_start_scan_req(tstrWILC_WFIDrv *hWFIDrv, u8 scanSource)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -5385,7 +5385,7 @@ s32 host_int_set_start_scan_req(WILC_WFIDrvHandle hWFIDrv, u8 scanSource)
  *  @version		1.0
  */
 
-s32 host_int_get_start_scan_req(WILC_WFIDrvHandle hWFIDrv, u8 *pu8ScanSource)
+s32 host_int_get_start_scan_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8ScanSource)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -5410,7 +5410,7 @@ s32 host_int_get_start_scan_req(WILC_WFIDrvHandle hWFIDrv, u8 *pu8ScanSource)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_join_req(WILC_WFIDrvHandle hWFIDrv, u8 *pu8bssid,
+s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 				  const u8 *pu8ssid, size_t ssidLen,
 				  const u8 *pu8IEs, size_t IEsLen,
 				  tWILCpfConnectResult pfConnectResult, void *pvUserArg,
@@ -5511,7 +5511,7 @@ s32 host_int_set_join_req(WILC_WFIDrvHandle hWFIDrv, u8 *pu8bssid,
  *  @version	8.0
  */
 
-s32 host_int_flush_join_req(WILC_WFIDrvHandle hWFIDrv)
+s32 host_int_flush_join_req(tstrWILC_WFIDrv *hWFIDrv)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
@@ -5554,7 +5554,7 @@ s32 host_int_flush_join_req(WILC_WFIDrvHandle hWFIDrv)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_disconnect(WILC_WFIDrvHandle hWFIDrv, u16 u16ReasonCode)
+s32 host_int_disconnect(tstrWILC_WFIDrv *hWFIDrv, u16 u16ReasonCode)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
@@ -5603,7 +5603,7 @@ s32 host_int_disconnect(WILC_WFIDrvHandle hWFIDrv, u16 u16ReasonCode)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_disconnect_station(WILC_WFIDrvHandle hWFIDrv, u8 assoc_id)
+s32 host_int_disconnect_station(tstrWILC_WFIDrv *hWFIDrv, u8 assoc_id)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -5643,7 +5643,7 @@ s32 host_int_disconnect_station(WILC_WFIDrvHandle hWFIDrv, u8 assoc_id)
  *  @version		1.0
  */
 
-s32 host_int_get_assoc_req_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8AssocReqInfo,
+s32 host_int_get_assoc_req_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8AssocReqInfo,
 					u32 u32AssocReqInfoLen)
 {
 	s32 s32Error = WILC_SUCCESS;
@@ -5670,7 +5670,7 @@ s32 host_int_get_assoc_req_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8AssocReqInfo,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_assoc_res_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8AssocRespInfo,
+s32 host_int_get_assoc_res_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8AssocRespInfo,
 					u32 u32MaxAssocRespInfoLen, u32 *pu32RcvdAssocRespInfoLen)
 {
 	s32 s32Error = WILC_SUCCESS;
@@ -5720,7 +5720,7 @@ s32 host_int_get_assoc_res_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8AssocRespInfo,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_rx_power_level(WILC_WFIDrvHandle hWFIDrv, u8 *pu8RxPowerLevel,
+s32 host_int_get_rx_power_level(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8RxPowerLevel,
 					u32 u32RxPowerLevelLen)
 {
 	s32 s32Error = WILC_SUCCESS;
@@ -5751,7 +5751,7 @@ s32 host_int_get_rx_power_level(WILC_WFIDrvHandle hWFIDrv, u8 *pu8RxPowerLevel,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_mac_chnl_num(WILC_WFIDrvHandle hWFIDrv, u8 u8ChNum)
+s32 host_int_set_mac_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 u8ChNum)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -5803,7 +5803,7 @@ s32 host_int_wait_msg_queue_idle(void)
 
 }
 
-s32 host_int_set_wfi_drv_handler(u32 u32address)
+s32 host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *u32address)
 {
 	s32 s32Error = WILC_SUCCESS;
 
@@ -5830,7 +5830,7 @@ s32 host_int_set_wfi_drv_handler(u32 u32address)
 
 
 
-s32 host_int_set_operation_mode(WILC_WFIDrvHandle hWFIDrv, u32 u32mode)
+s32 host_int_set_operation_mode(tstrWILC_WFIDrv *hWFIDrv, u32 u32mode)
 {
 	s32 s32Error = WILC_SUCCESS;
 
@@ -5870,7 +5870,7 @@ s32 host_int_set_operation_mode(WILC_WFIDrvHandle hWFIDrv, u32 u32mode)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_host_chnl_num(WILC_WFIDrvHandle hWFIDrv, u8 *pu8ChNo)
+s32 host_int_get_host_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8ChNo)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -5916,7 +5916,7 @@ s32 host_int_get_host_chnl_num(WILC_WFIDrvHandle hWFIDrv, u8 *pu8ChNo)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_test_set_int_wid(WILC_WFIDrvHandle hWFIDrv, u32 u32TestMemAddr)
+s32 host_int_test_set_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 u32TestMemAddr)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID	strWID;
@@ -5963,7 +5963,7 @@ s32 host_int_test_set_int_wid(WILC_WFIDrvHandle hWFIDrv, u32 u32TestMemAddr)
  *  @date
  *  @version		1.0
  */
-s32 host_int_get_inactive_time(WILC_WFIDrvHandle hWFIDrv, const u8 *mac, u32 *pu32InactiveTime)
+s32 host_int_get_inactive_time(tstrWILC_WFIDrv *hWFIDrv, const u8 *mac, u32 *pu32InactiveTime)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -6009,7 +6009,7 @@ s32 host_int_get_inactive_time(WILC_WFIDrvHandle hWFIDrv, const u8 *mac, u32 *pu
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_test_get_int_wid(WILC_WFIDrvHandle hWFIDrv, u32 *pu32TestMemAddr)
+s32 host_int_test_get_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 *pu32TestMemAddr)
 {
 
 	s32 s32Error = WILC_SUCCESS;
@@ -6058,7 +6058,7 @@ s32 host_int_test_get_int_wid(WILC_WFIDrvHandle hWFIDrv, u32 *pu32TestMemAddr)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_rssi(WILC_WFIDrvHandle hWFIDrv, s8 *ps8Rssi)
+s32 host_int_get_rssi(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8Rssi)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
@@ -6093,7 +6093,7 @@ s32 host_int_get_rssi(WILC_WFIDrvHandle hWFIDrv, s8 *ps8Rssi)
 	return s32Error;
 }
 
-s32 host_int_get_link_speed(WILC_WFIDrvHandle hWFIDrv, s8 *ps8lnkspd)
+s32 host_int_get_link_speed(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8lnkspd)
 {
 	tstrHostIFmsg strHostIFmsg;
 	s32 s32Error = WILC_SUCCESS;
@@ -6130,7 +6130,7 @@ s32 host_int_get_link_speed(WILC_WFIDrvHandle hWFIDrv, s8 *ps8lnkspd)
 	return s32Error;
 }
 
-s32 host_int_get_statistics(WILC_WFIDrvHandle hWFIDrv, tstrStatistics *pstrStatistics)
+s32 host_int_get_statistics(tstrWILC_WFIDrv *hWFIDrv, tstrStatistics *pstrStatistics)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
@@ -6170,7 +6170,7 @@ s32 host_int_get_statistics(WILC_WFIDrvHandle hWFIDrv, tstrStatistics *pstrStati
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_scan(WILC_WFIDrvHandle hWFIDrv, u8 u8ScanSource,
+s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
 			  u8 u8ScanType, u8 *pu8ChnlFreqList,
 			  u8 u8ChnlListLen, const u8 *pu8IEs,
 			  size_t IEsLen, tWILCpfScanResult ScanResult,
@@ -6243,7 +6243,7 @@ s32 host_int_scan(WILC_WFIDrvHandle hWFIDrv, u8 u8ScanSource,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 hif_set_cfg(WILC_WFIDrvHandle hWFIDrv, tstrCfgParamVal *pstrCfgParamVal)
+s32 hif_set_cfg(tstrWILC_WFIDrv *hWFIDrv, tstrCfgParamVal *pstrCfgParamVal)
 {
 
 	s32 s32Error = WILC_SUCCESS;
@@ -6284,7 +6284,7 @@ s32 hif_set_cfg(WILC_WFIDrvHandle hWFIDrv, tstrCfgParamVal *pstrCfgParamVal)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 hif_get_cfg(WILC_WFIDrvHandle hWFIDrv, u16 u16WID, u16 *pu16WID_Value)
+s32 hif_get_cfg(tstrWILC_WFIDrv *hWFIDrv, u16 u16WID, u16 *pu16WID_Value)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -6466,7 +6466,7 @@ static u32 u32Intialized;
 static u32 msgQ_created;
 static u32 clients_count;
 
-s32 host_int_init(WILC_WFIDrvHandle *phWFIDrv)
+s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv;
@@ -6495,7 +6495,7 @@ s32 host_int_init(WILC_WFIDrvHandle *phWFIDrv)
 	}
 	memset(pstrWFIDrv, 0, sizeof(tstrWILC_WFIDrv));
 	/*return driver handle to user*/
-	*phWFIDrv = (WILC_WFIDrvHandle)pstrWFIDrv;
+	*phWFIDrv = pstrWFIDrv;
 	/*save into globl handle*/
 
 	#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
@@ -6648,7 +6648,7 @@ _fail_:
  *  @version		1.0
  */
 
-s32 host_int_deinit(WILC_WFIDrvHandle hWFIDrv)
+s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
@@ -6698,7 +6698,7 @@ s32 host_int_deinit(WILC_WFIDrvHandle hWFIDrv)
 	WILC_TimerDestroy(&(pstrWFIDrv->hRemainOnChannel), NULL);
 	#endif
 
-	host_int_set_wfi_drv_handler((u32)NULL);
+	host_int_set_wfi_drv_handler(NULL);
 	down(&hSemDeinitDrvHandle);
 
 
@@ -6938,7 +6938,7 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
  *  @date
  *  @version		1.0
  */
-s32 host_int_remain_on_channel(WILC_WFIDrvHandle hWFIDrv, u32 u32SessionID, u32 u32duration, u16 chan, tWILCpfRemainOnChanExpired RemainOnChanExpired, tWILCpfRemainOnChanReady RemainOnChanReady, void *pvUserArg)
+s32 host_int_remain_on_channel(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID, u32 u32duration, u16 chan, tWILCpfRemainOnChanExpired RemainOnChanExpired, tWILCpfRemainOnChanReady RemainOnChanReady, void *pvUserArg)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -6985,7 +6985,7 @@ s32 host_int_remain_on_channel(WILC_WFIDrvHandle hWFIDrv, u32 u32SessionID, u32
  *  @date
  *  @version		1.0
  */
-s32 host_int_ListenStateExpired(WILC_WFIDrvHandle hWFIDrv, u32 u32SessionID)
+s32 host_int_ListenStateExpired(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -7021,7 +7021,7 @@ s32 host_int_ListenStateExpired(WILC_WFIDrvHandle hWFIDrv, u32 u32SessionID)
  *  @author
  *  @date
  *  @version		1.0*/
-s32 host_int_frame_register(WILC_WFIDrvHandle hWFIDrv, u16 u16FrameType, bool bReg)
+s32 host_int_frame_register(tstrWILC_WFIDrv *hWFIDrv, u16 u16FrameType, bool bReg)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -7079,7 +7079,7 @@ s32 host_int_frame_register(WILC_WFIDrvHandle hWFIDrv, u16 u16FrameType, bool bR
  *  @date
  *  @version	1.0
  */
-s32 host_int_add_beacon(WILC_WFIDrvHandle hWFIDrv, u32 u32Interval,
+s32 host_int_add_beacon(tstrWILC_WFIDrv *hWFIDrv, u32 u32Interval,
 				u32 u32DTIMPeriod,
 				u32 u32HeadLen, u8 *pu8Head,
 				u32 u32TailLen, u8 *pu8Tail)
@@ -7146,7 +7146,7 @@ s32 host_int_add_beacon(WILC_WFIDrvHandle hWFIDrv, u32 u32Interval,
  *  @date
  *  @version	1.0
  */
-s32 host_int_del_beacon(WILC_WFIDrvHandle hWFIDrv)
+s32 host_int_del_beacon(tstrWILC_WFIDrv *hWFIDrv)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -7179,7 +7179,7 @@ s32 host_int_del_beacon(WILC_WFIDrvHandle hWFIDrv)
  *  @date
  *  @version	1.0
  */
-s32 host_int_add_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam *pstrStaParams)
+s32 host_int_add_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrStaParams)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -7229,7 +7229,7 @@ s32 host_int_add_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam *pstrSt
  *  @date
  *  @version	1.0
  */
-s32 host_int_del_station(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8MacAddr)
+s32 host_int_del_station(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8MacAddr)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -7273,7 +7273,7 @@ s32 host_int_del_station(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8MacAddr)
  *  @date
  *  @version	1.0
  */
-s32 host_int_del_allstation(WILC_WFIDrvHandle hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
+s32 host_int_del_allstation(tstrWILC_WFIDrv *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -7335,7 +7335,7 @@ s32 host_int_del_allstation(WILC_WFIDrvHandle hWFIDrv, u8 pu8MacAddr[][ETH_ALEN]
  *  @date
  *  @version	1.0
  */
-s32 host_int_edit_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam *pstrStaParams)
+s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrStaParams)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -7374,7 +7374,7 @@ s32 host_int_edit_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam *pstrS
 #endif /*WILC_AP_EXTERNAL_MLME*/
 uint32_t wilc_get_chipid(uint8_t);
 
-s32 host_int_set_power_mgmt(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled, u32 u32Timeout)
+s32 host_int_set_power_mgmt(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32Timeout)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -7408,7 +7408,7 @@ s32 host_int_set_power_mgmt(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled, u32 u32T
 	return s32Error;
 }
 
-s32 host_int_setup_multicast_filter(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled, u32 u32count)
+s32 host_int_setup_multicast_filter(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32count)
 {
 	s32 s32Error = WILC_SUCCESS;
 
@@ -7712,7 +7712,7 @@ static int host_int_addBASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char T
 }
 
 
-s32 host_int_delBASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char TID)
+s32 host_int_delBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -7745,7 +7745,7 @@ s32 host_int_delBASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char TID)
 	return s32Error;
 }
 
-s32 host_int_del_All_Rx_BASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char TID)
+s32 host_int_del_All_Rx_BASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -7786,7 +7786,7 @@ s32 host_int_del_All_Rx_BASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char
  *  @author		Abdelrahman Sobhy
  *  @date
  *  @version		1.0*/
-s32 host_int_setup_ipaddress(WILC_WFIDrvHandle hWFIDrv, u8 *u16ipadd, u8 idx)
+s32 host_int_setup_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -7828,7 +7828,7 @@ s32 host_int_setup_ipaddress(WILC_WFIDrvHandle hWFIDrv, u8 *u16ipadd, u8 idx)
  *  @author		Abdelrahman Sobhy
  *  @date
  *  @version		1.0*/
-s32 host_int_get_ipaddress(WILC_WFIDrvHandle hWFIDrv, u8 *u16ipadd, u8 idx)
+s32 host_int_get_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index cdfb43a..2d97e9f 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -432,7 +432,7 @@ typedef struct {
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_remove_key(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8StaAddress);
+s32 host_int_remove_key(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8StaAddress);
 /**
  *  @brief              removes WEP key
  *  @details    valid only in BSS STA mode if External Supplicant support is enabled.
@@ -447,7 +447,7 @@ s32 host_int_remove_key(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8StaAddress);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_remove_wep_key(WILC_WFIDrvHandle hWFIDrv, u8 u8Index);
+s32 host_int_remove_wep_key(tstrWILC_WFIDrv *hWFIDrv, u8 u8Index);
 /**
  *  @brief              sets WEP deafault key
  *  @details    Sets the index of the WEP encryption key in use,
@@ -460,7 +460,7 @@ s32 host_int_remove_wep_key(WILC_WFIDrvHandle hWFIDrv, u8 u8Index);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_WEPDefaultKeyID(WILC_WFIDrvHandle hWFIDrv, u8 u8Index);
+s32 host_int_set_WEPDefaultKeyID(tstrWILC_WFIDrv *hWFIDrv, u8 u8Index);
 
 /**
  *  @brief              sets WEP deafault key
@@ -481,7 +481,7 @@ s32 host_int_set_WEPDefaultKeyID(WILC_WFIDrvHandle hWFIDrv, u8 u8Index);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_add_wep_key_bss_sta(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx);
+s32 host_int_add_wep_key_bss_sta(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx);
 /**
  *  @brief              host_int_add_wep_key_bss_ap
  *  @details    valid only in AP mode if External Supplicant support is enabled.
@@ -496,7 +496,7 @@ s32 host_int_add_wep_key_bss_sta(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8WepKey,
  *  @date		28 Feb 2013
  *  @version		1.0
  */
-s32 host_int_add_wep_key_bss_ap(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx, u8 u8mode, AUTHTYPE_T tenuAuth_type);
+s32 host_int_add_wep_key_bss_ap(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx, u8 u8mode, AUTHTYPE_T tenuAuth_type);
 
 /**
  *  @brief              adds ptk Key
@@ -514,7 +514,7 @@ s32 host_int_add_wep_key_bss_ap(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8WepKey,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_add_ptk(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
+s32 host_int_add_ptk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 			     const u8 *mac_addr, const u8 *pu8RxMic, const u8 *pu8TxMic, u8 mode, u8 u8Ciphermode, u8 u8Idx);
 
 /**
@@ -529,7 +529,7 @@ s32 host_int_add_ptk(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen
  *  @date		15 April 2013
  *  @version		1.0
  */
-s32 host_int_get_inactive_time(WILC_WFIDrvHandle hWFIDrv, const u8 *mac, u32 *pu32InactiveTime);
+s32 host_int_get_inactive_time(tstrWILC_WFIDrv *hWFIDrv, const u8 *mac, u32 *pu32InactiveTime);
 
 /**
  *  @brief              adds Rx GTk Key
@@ -547,7 +547,7 @@ s32 host_int_get_inactive_time(WILC_WFIDrvHandle hWFIDrv, const u8 *mac, u32 *pu
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_add_rx_gtk(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKeylen,
+s32 host_int_add_rx_gtk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKeylen,
 				u8 u8KeyIdx, u32 u32KeyRSClen, const u8 *KeyRSC,
 				const u8 *pu8RxMic, const u8 *pu8TxMic, u8 mode, u8 u8Ciphermode);
 
@@ -568,7 +568,7 @@ s32 host_int_add_rx_gtk(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkK
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_add_tx_gtk(WILC_WFIDrvHandle hWFIDrv, u8 u8KeyLen, u8 *pu8TxGtk, u8 u8KeyIdx);
+s32 host_int_add_tx_gtk(tstrWILC_WFIDrv *hWFIDrv, u8 u8KeyLen, u8 *pu8TxGtk, u8 u8KeyIdx);
 
 /**
  *  @brief              caches the pmkid
@@ -591,7 +591,7 @@ s32 host_int_add_tx_gtk(WILC_WFIDrvHandle hWFIDrv, u8 u8KeyLen, u8 *pu8TxGtk, u8
  *  @version		1.0
  */
 
-s32 host_int_set_pmkid_info(WILC_WFIDrvHandle hWFIDrv, tstrHostIFpmkidAttr *pu8PmkidInfoArray);
+s32 host_int_set_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, tstrHostIFpmkidAttr *pu8PmkidInfoArray);
 /**
  *  @brief              gets the cached the pmkid info
  *  @details    valid only in BSS STA mode if External Supplicant
@@ -615,7 +615,7 @@ s32 host_int_set_pmkid_info(WILC_WFIDrvHandle hWFIDrv, tstrHostIFpmkidAttr *pu8P
  *  @version		1.0
  */
 
-s32 host_int_get_pmkid_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8PmkidInfoArray,
+s32 host_int_get_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8PmkidInfoArray,
 				    u32 u32PmkidInfoLen);
 
 /**
@@ -632,7 +632,7 @@ s32 host_int_get_pmkid_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8PmkidInfoArray,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_RSNAConfigPSKPassPhrase(WILC_WFIDrvHandle hWFIDrv, u8 *pu8PassPhrase,
+s32 host_int_set_RSNAConfigPSKPassPhrase(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8PassPhrase,
 						 u8 u8Psklength);
 /**
  *  @brief              gets the pass phrase
@@ -648,7 +648,7 @@ s32 host_int_set_RSNAConfigPSKPassPhrase(WILC_WFIDrvHandle hWFIDrv, u8 *pu8PassP
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_RSNAConfigPSKPassPhrase(WILC_WFIDrvHandle hWFIDrv,
+s32 host_int_get_RSNAConfigPSKPassPhrase(tstrWILC_WFIDrv *hWFIDrv,
 						 u8 *pu8PassPhrase, u8 u8Psklength);
 
 /**
@@ -662,7 +662,7 @@ s32 host_int_get_RSNAConfigPSKPassPhrase(WILC_WFIDrvHandle hWFIDrv,
  *  @date		19 April 2012
  *  @version		1.0
  */
-s32 host_int_get_MacAddress(WILC_WFIDrvHandle hWFIDrv, u8 *pu8MacAddress);
+s32 host_int_get_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress);
 
 /**
  *  @brief              sets mac address
@@ -675,7 +675,7 @@ s32 host_int_get_MacAddress(WILC_WFIDrvHandle hWFIDrv, u8 *pu8MacAddress);
  *  @date		16 July 2012
  *  @version		1.0
  */
-s32 host_int_set_MacAddress(WILC_WFIDrvHandle hWFIDrv, u8 *pu8MacAddress);
+s32 host_int_set_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress);
 
 /**
  *  @brief              wait until msg q is empty
@@ -720,7 +720,7 @@ s32 host_int_wait_msg_queue_idle(void);
  *  @version		1.0
  */
 #ifndef CONNECT_DIRECT
-s32 host_int_get_site_survey_results(WILC_WFIDrvHandle hWFIDrv,
+s32 host_int_get_site_survey_results(tstrWILC_WFIDrv *hWFIDrv,
 					     u8 ppu8RcvdSiteSurveyResults[][MAX_SURVEY_RESULT_FRAG_SIZE],
 					     u32 u32MaxSiteSrvyFragLen);
 #endif
@@ -741,7 +741,7 @@ s32 host_int_get_site_survey_results(WILC_WFIDrvHandle hWFIDrv,
  *  @version		1.0
  */
 
-s32 host_int_set_start_scan_req(WILC_WFIDrvHandle hWFIDrv, u8 scanSource);
+s32 host_int_set_start_scan_req(tstrWILC_WFIDrv *hWFIDrv, u8 scanSource);
 /**
  *  @brief              gets scan source of the last scan
  *  @details
@@ -757,7 +757,7 @@ s32 host_int_set_start_scan_req(WILC_WFIDrvHandle hWFIDrv, u8 scanSource);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_start_scan_req(WILC_WFIDrvHandle hWFIDrv, u8 *pu8ScanSource);
+s32 host_int_get_start_scan_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8ScanSource);
 
 /**
  *  @brief              sets a join request
@@ -771,7 +771,7 @@ s32 host_int_get_start_scan_req(WILC_WFIDrvHandle hWFIDrv, u8 *pu8ScanSource);
  *  @version		1.0
  */
 
-s32 host_int_set_join_req(WILC_WFIDrvHandle hWFIDrv, u8 *pu8bssid,
+s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 				  const u8 *pu8ssid, size_t ssidLen,
 				  const u8 *pu8IEs, size_t IEsLen,
 				  tWILCpfConnectResult pfConnectResult, void *pvUserArg,
@@ -791,7 +791,7 @@ s32 host_int_set_join_req(WILC_WFIDrvHandle hWFIDrv, u8 *pu8bssid,
  *  @version		8.0
  */
 
-s32 host_int_flush_join_req(WILC_WFIDrvHandle hWFIDrv);
+s32 host_int_flush_join_req(tstrWILC_WFIDrv *hWFIDrv);
 
 
 /**
@@ -805,7 +805,7 @@ s32 host_int_flush_join_req(WILC_WFIDrvHandle hWFIDrv);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_disconnect(WILC_WFIDrvHandle hWFIDrv, u16 u16ReasonCode);
+s32 host_int_disconnect(tstrWILC_WFIDrv *hWFIDrv, u16 u16ReasonCode);
 
 /**
  *  @brief              disconnects a sta
@@ -818,7 +818,7 @@ s32 host_int_disconnect(WILC_WFIDrvHandle hWFIDrv, u16 u16ReasonCode);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_disconnect_station(WILC_WFIDrvHandle hWFIDrv, u8 assoc_id);
+s32 host_int_disconnect_station(tstrWILC_WFIDrv *hWFIDrv, u8 assoc_id);
 /**
  *  @brief              gets a Association request info
  *  @details
@@ -845,7 +845,7 @@ s32 host_int_disconnect_station(WILC_WFIDrvHandle hWFIDrv, u8 assoc_id);
  *  @version		1.0
  */
 
-s32 host_int_get_assoc_req_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8AssocReqInfo,
+s32 host_int_get_assoc_req_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8AssocReqInfo,
 					u32 u32AssocReqInfoLen);
 /**
  *  @brief              gets a Association Response info
@@ -859,7 +859,7 @@ s32 host_int_get_assoc_req_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8AssocReqInfo,
  *  @version		1.0
  */
 
-s32 host_int_get_assoc_res_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8AssocRespInfo,
+s32 host_int_get_assoc_res_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8AssocRespInfo,
 					u32 u32MaxAssocRespInfoLen, u32 *pu32RcvdAssocRespInfoLen);
 /**
  *  @brief              gets a Association Response info
@@ -876,7 +876,7 @@ s32 host_int_get_assoc_res_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8AssocRespInfo,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_rx_power_level(WILC_WFIDrvHandle hWFIDrv, u8 *pu8RxPowerLevel,
+s32 host_int_get_rx_power_level(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8RxPowerLevel,
 					u32 u32RxPowerLevelLen);
 
 /**
@@ -894,7 +894,7 @@ s32 host_int_get_rx_power_level(WILC_WFIDrvHandle hWFIDrv, u8 *pu8RxPowerLevel,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_mac_chnl_num(WILC_WFIDrvHandle hWFIDrv, u8 u8ChNum);
+s32 host_int_set_mac_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 u8ChNum);
 
 /**
  *  @brief              gets the current channel index
@@ -911,7 +911,7 @@ s32 host_int_set_mac_chnl_num(WILC_WFIDrvHandle hWFIDrv, u8 u8ChNum);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_host_chnl_num(WILC_WFIDrvHandle hWFIDrv, u8 *pu8ChNo);
+s32 host_int_get_host_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8ChNo);
 /**
  *  @brief              gets the sta rssi
  *  @details    gets the currently maintained RSSI value for the station.
@@ -925,8 +925,8 @@ s32 host_int_get_host_chnl_num(WILC_WFIDrvHandle hWFIDrv, u8 *pu8ChNo);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_rssi(WILC_WFIDrvHandle hWFIDrv, s8 *ps8Rssi);
-s32 host_int_get_link_speed(WILC_WFIDrvHandle hWFIDrv, s8 *ps8lnkspd);
+s32 host_int_get_rssi(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8Rssi);
+s32 host_int_get_link_speed(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8lnkspd);
 /**
  *  @brief              scans a set of channels
  *  @details
@@ -944,7 +944,7 @@ s32 host_int_get_link_speed(WILC_WFIDrvHandle hWFIDrv, s8 *ps8lnkspd);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_scan(WILC_WFIDrvHandle hWFIDrv, u8 u8ScanSource,
+s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
 			  u8 u8ScanType, u8 *pu8ChnlFreqList,
 			  u8 u8ChnlListLen, const u8 *pu8IEs,
 			  size_t IEsLen, tWILCpfScanResult ScanResult,
@@ -960,7 +960,7 @@ s32 host_int_scan(WILC_WFIDrvHandle hWFIDrv, u8 u8ScanSource,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 hif_set_cfg(WILC_WFIDrvHandle hWFIDrv, tstrCfgParamVal *pstrCfgParamVal);
+s32 hif_set_cfg(tstrWILC_WFIDrv *hWFIDrv, tstrCfgParamVal *pstrCfgParamVal);
 
 /**
  *  @brief              gets configuration wids values
@@ -974,7 +974,7 @@ s32 hif_set_cfg(WILC_WFIDrvHandle hWFIDrv, tstrCfgParamVal *pstrCfgParamVal);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 hif_get_cfg(WILC_WFIDrvHandle hWFIDrv, u16 u16WID, u16 *pu16WID_Value);
+s32 hif_get_cfg(tstrWILC_WFIDrv *hWFIDrv, u16 u16WID, u16 *pu16WID_Value);
 /*****************************************************************************/
 /*							Notification Functions							 */
 /*****************************************************************************/
@@ -1021,7 +1021,7 @@ void host_int_send_network_info_to_host
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_init(WILC_WFIDrvHandle *phWFIDrv);
+s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv);
 
 /**
  *  @brief              host interface initialization function
@@ -1032,7 +1032,7 @@ s32 host_int_init(WILC_WFIDrvHandle *phWFIDrv);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_deinit(WILC_WFIDrvHandle hWFIDrv);
+s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv);
 
 
 /*!
@@ -1057,7 +1057,7 @@ s32 host_int_deinit(WILC_WFIDrvHandle hWFIDrv);
  *  @version		1.0 Description
  *
  */
-s32 host_int_add_beacon(WILC_WFIDrvHandle hWFIDrv, u32 u32Interval,
+s32 host_int_add_beacon(tstrWILC_WFIDrv *hWFIDrv, u32 u32Interval,
 				u32 u32DTIMPeriod,
 				u32 u32HeadLen, u8 *pu8Head,
 				u32 u32TailLen, u8 *pu8tail);
@@ -1075,7 +1075,7 @@ s32 host_int_add_beacon(WILC_WFIDrvHandle hWFIDrv, u32 u32Interval,
  *  @date		10 Julys 2012
  *  @version		1.0 Description
  */
-s32 host_int_del_beacon(WILC_WFIDrvHandle hWFIDrv);
+s32 host_int_del_beacon(tstrWILC_WFIDrv *hWFIDrv);
 
 /*!
  *  @fn		s32 host_int_add_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam strStaParams)
@@ -1090,7 +1090,7 @@ s32 host_int_del_beacon(WILC_WFIDrvHandle hWFIDrv);
  *  @date		12 July 2012
  *  @version		1.0 Description
  */
-s32 host_int_add_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam *pstrStaParams);
+s32 host_int_add_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrStaParams);
 
 /*!
  *  @fn		s32 host_int_del_allstation(WILC_WFIDrvHandle hWFIDrv, const u8* pu8MacAddr)
@@ -1105,7 +1105,7 @@ s32 host_int_add_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam *pstrSt
  *  @date		09 April 2014
  *  @version		1.0 Description
  */
-s32 host_int_del_allstation(WILC_WFIDrvHandle hWFIDrv, u8 pu8MacAddr[][ETH_ALEN]);
+s32 host_int_del_allstation(tstrWILC_WFIDrv *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN]);
 
 /*!
  *  @fn		s32 host_int_del_station(WILC_WFIDrvHandle hWFIDrv, u8* pu8MacAddr)
@@ -1120,7 +1120,7 @@ s32 host_int_del_allstation(WILC_WFIDrvHandle hWFIDrv, u8 pu8MacAddr[][ETH_ALEN]
  *  @date		15 July 2012
  *  @version		1.0 Description
  */
-s32 host_int_del_station(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8MacAddr);
+s32 host_int_del_station(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8MacAddr);
 
 /*!
  *  @fn		s32 host_int_edit_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam strStaParams)
@@ -1135,7 +1135,7 @@ s32 host_int_del_station(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8MacAddr);
  *  @date		15 July 2012
  *  @version		1.0 Description
  */
-s32 host_int_edit_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam *pstrStaParams);
+s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrStaParams);
 
 /*!
  *  @fn		s32 host_int_set_power_mgmt(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled, u32 u32Timeout)
@@ -1152,7 +1152,7 @@ s32 host_int_edit_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam *pstrS
  *  @date		24 November 2012
  *  @version		1.0 Description
  */
-s32 host_int_set_power_mgmt(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled, u32 u32Timeout);
+s32 host_int_set_power_mgmt(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32Timeout);
 /*  @param[in,out]	hWFIDrv		handle to the wifi driver
  *  @param[in]	bIsEnabled	TRUE if enabled, FALSE otherwise
  *  @param[in]	u8count		count of mac address entries in the filter table
@@ -1164,7 +1164,7 @@ s32 host_int_set_power_mgmt(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled, u32 u32T
  *  @date		24 November 2012
  *  @version		1.0 Description
  */
-s32 host_int_setup_multicast_filter(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled, u32 u32count);
+s32 host_int_setup_multicast_filter(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32count);
 /**
  *  @brief           host_int_setup_ipaddress
  *  @details       set IP address on firmware
@@ -1174,7 +1174,7 @@ s32 host_int_setup_multicast_filter(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled,
  *  @date
  *  @version	1.0
  */
-s32 host_int_setup_ipaddress(WILC_WFIDrvHandle hWFIDrv, u8 *pu8IPAddr, u8 idx);
+s32 host_int_setup_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8IPAddr, u8 idx);
 
 
 /**
@@ -1186,7 +1186,7 @@ s32 host_int_setup_ipaddress(WILC_WFIDrvHandle hWFIDrv, u8 *pu8IPAddr, u8 idx);
  *  @date
  *  @version	1.0
  */
-s32 host_int_delBASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char TID);
+s32 host_int_delBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID);
 
 /**
  *  @brief           host_int_delBASession
@@ -1197,7 +1197,7 @@ s32 host_int_delBASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char TID);
  *  @date
  *  @version	1.0
  */
-s32 host_int_del_All_Rx_BASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char TID);
+s32 host_int_del_All_Rx_BASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID);
 
 
 /**
@@ -1209,7 +1209,7 @@ s32 host_int_del_All_Rx_BASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char
  *  @date
  *  @version	1.0
  */
-s32 host_int_get_ipaddress(WILC_WFIDrvHandle hWFIDrv, u8 *pu8IPAddr, u8 idx);
+s32 host_int_get_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8IPAddr, u8 idx);
 
 #ifdef WILC_P2P
 /**
@@ -1221,7 +1221,7 @@ s32 host_int_get_ipaddress(WILC_WFIDrvHandle hWFIDrv, u8 *pu8IPAddr, u8 idx);
  *  @date
  *  @version	1.0
  */
-s32 host_int_remain_on_channel(WILC_WFIDrvHandle hWFIDrv, u32 u32SessionID, u32 u32duration, u16 chan, tWILCpfRemainOnChanExpired RemainOnChanExpired, tWILCpfRemainOnChanReady RemainOnChanReady, void *pvUserArg);
+s32 host_int_remain_on_channel(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID, u32 u32duration, u16 chan, tWILCpfRemainOnChanExpired RemainOnChanExpired, tWILCpfRemainOnChanReady RemainOnChanReady, void *pvUserArg);
 
 /**
  *  @brief              host_int_ListenStateExpired
@@ -1237,7 +1237,7 @@ s32 host_int_remain_on_channel(WILC_WFIDrvHandle hWFIDrv, u32 u32SessionID, u32
  *  @date
  *  @version		1.0
  */
-s32 host_int_ListenStateExpired(WILC_WFIDrvHandle hWFIDrv, u32 u32SessionID);
+s32 host_int_ListenStateExpired(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID);
 
 /**
  *  @brief           host_int_frame_register
@@ -1248,7 +1248,7 @@ s32 host_int_ListenStateExpired(WILC_WFIDrvHandle hWFIDrv, u32 u32SessionID);
  *  @date
  *  @version	1.0
  */
-s32 host_int_frame_register(WILC_WFIDrvHandle hWFIDrv, u16 u16FrameType, bool bReg);
+s32 host_int_frame_register(tstrWILC_WFIDrv *hWFIDrv, u16 u16FrameType, bool bReg);
 #endif
 /**
  *  @brief           host_int_set_wfi_drv_handler
@@ -1259,8 +1259,8 @@ s32 host_int_frame_register(WILC_WFIDrvHandle hWFIDrv, u16 u16FrameType, bool bR
  *  @date
  *  @version	1.0
  */
-s32 host_int_set_wfi_drv_handler(u32 u32address);
-s32 host_int_set_operation_mode(WILC_WFIDrvHandle hWFIDrv, u32 u32mode);
+s32 host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *u32address);
+s32 host_int_set_operation_mode(tstrWILC_WFIDrv *hWFIDrv, u32 u32mode);
 
 static s32 Handle_ScanDone(void *drvHandler, tenuScanEvent enuEvent);
 
@@ -1270,7 +1270,7 @@ static int host_int_addBASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char T
 
 void host_int_freeJoinParams(void *pJoinParams);
 
-s32 host_int_get_statistics(WILC_WFIDrvHandle hWFIDrv, tstrStatistics *pstrStatistics);
+s32 host_int_get_statistics(tstrWILC_WFIDrv *hWFIDrv, tstrStatistics *pstrStatistics);
 
 /*****************************************************************************/
 /*																			 */
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 1384846..e233271 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -291,13 +291,13 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 		}
 
 		if (bEnablePS)
-			host_int_set_power_mgmt((WILC_WFIDrvHandle)pstrWFIDrv, 1, 0);
+			host_int_set_power_mgmt(pstrWFIDrv, 1, 0);
 
 		PRINT_D(GENERIC_DBG, "[%s] Up IP\n", dev_iface->ifa_label);
 
 		pIP_Add_buff = (char *) (&(dev_iface->ifa_address));
 		PRINT_D(GENERIC_DBG, "IP add=%d:%d:%d:%d\n", pIP_Add_buff[0], pIP_Add_buff[1], pIP_Add_buff[2], pIP_Add_buff[3]);
-		host_int_setup_ipaddress((WILC_WFIDrvHandle)pstrWFIDrv, pIP_Add_buff, nic->u8IfIdx);
+		host_int_setup_ipaddress(pstrWFIDrv, pIP_Add_buff, nic->u8IfIdx);
 
 		break;
 
@@ -311,7 +311,7 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 		}
 
 		if (memcmp(dev_iface->ifa_label, wlan_dev_name, 5) == 0)
-			host_int_set_power_mgmt((WILC_WFIDrvHandle)pstrWFIDrv, 0, 0);
+			host_int_set_power_mgmt(pstrWFIDrv, 0, 0);
 
 		resolve_disconnect_aberration(pstrWFIDrv);
 
@@ -320,7 +320,7 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 		pIP_Add_buff = null_ip;
 		PRINT_D(GENERIC_DBG, "IP add=%d:%d:%d:%d\n", pIP_Add_buff[0], pIP_Add_buff[1], pIP_Add_buff[2], pIP_Add_buff[3]);
 
-		host_int_setup_ipaddress((WILC_WFIDrvHandle)pstrWFIDrv, pIP_Add_buff, nic->u8IfIdx);
+		host_int_setup_ipaddress(pstrWFIDrv, pIP_Add_buff, nic->u8IfIdx);
 
 		break;
 
@@ -2007,7 +2007,7 @@ int mac_open(struct net_device *ndev)
 	for (i = 0; i < g_linux_wlan->u8NoIfcs; i++) {
 		if (ndev == g_linux_wlan->strInterfaceInfo[i].wilc_netdev) {
 			memcpy(g_linux_wlan->strInterfaceInfo[i].aSrcAddress, mac_add, ETH_ALEN);
-			g_linux_wlan->strInterfaceInfo[i].drvHandler = (u32)priv->hWILCWFIDrv;
+			g_linux_wlan->strInterfaceInfo[i].drvHandler = priv->hWILCWFIDrv;
 			break;
 		}
 	}
@@ -2091,14 +2091,14 @@ static void wilc_set_multicast_list(struct net_device *dev)
 	if ((dev->flags & IFF_ALLMULTI) || (dev->mc.count) > WILC_MULTICAST_TABLE_SIZE) {
 		PRINT_D(INIT_DBG, "Disable multicast filter, retrive all multicast packets\n");
 		/* get all multicast packets */
-		host_int_setup_multicast_filter((WILC_WFIDrvHandle)pstrWFIDrv, false, 0);
+		host_int_setup_multicast_filter(pstrWFIDrv, false, 0);
 		return;
 	}
 
 	/* No multicast?  Just get our own stuff */
 	if ((dev->mc.count) == 0) {
 		PRINT_D(INIT_DBG, "Enable multicast filter, retrive directed packets only.\n");
-		host_int_setup_multicast_filter((WILC_WFIDrvHandle)pstrWFIDrv, true, 0);
+		host_int_setup_multicast_filter(pstrWFIDrv, true, 0);
 		return;
 	}
 
@@ -2111,7 +2111,7 @@ static void wilc_set_multicast_list(struct net_device *dev)
 		i++;
 	}
 
-	host_int_setup_multicast_filter((WILC_WFIDrvHandle)pstrWFIDrv, true, (dev->mc.count));
+	host_int_setup_multicast_filter(pstrWFIDrv, true, (dev->mc.count));
 
 	return;
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 5c45967..b163ff7 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -734,7 +734,7 @@ static int WILC_WFI_CfgScan(struct wiphy *wiphy, struct cfg80211_scan_request *r
 
 	priv->u32RcvdChCount = 0;
 
-	host_int_set_wfi_drv_handler((u32)priv->hWILCWFIDrv);
+	host_int_set_wfi_drv_handler(priv->hWILCWFIDrv);
 
 
 	reset_shadow_found(priv);
@@ -829,7 +829,7 @@ static int WILC_WFI_CfgConnect(struct wiphy *wiphy, struct net_device *dev,
 	priv = wiphy_priv(wiphy);
 	pstrWFIDrv = (tstrWILC_WFIDrv *)(priv->hWILCWFIDrv);
 
-	host_int_set_wfi_drv_handler((u32)priv->hWILCWFIDrv);
+	host_int_set_wfi_drv_handler(priv->hWILCWFIDrv);
 
 	PRINT_D(CFG80211_DBG, "Connecting to SSID [%s] on netdev [%p] host if [%p]\n", sme->ssid, dev, priv->hWILCWFIDrv);
 	#ifdef WILC_P2P
@@ -2887,15 +2887,15 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
 
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
@@ -2973,15 +2973,15 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
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
@@ -3101,15 +3101,15 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
 
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
index 0dfe108..77f320d 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -144,7 +144,7 @@ struct WILC_WFI_priv {
 	spinlock_t lock;
 	struct net_device *dev;
 	struct napi_struct napi;
-	WILC_WFIDrvHandle hWILCWFIDrv;
+	tstrWILC_WFIDrv *hWILCWFIDrv;
 	WILC_WFIDrvHandle hWILCWFIDrv_2;
 	tstrHostIFpmkidAttr pmkid_list;
 	struct WILC_WFI_stats netstats;
@@ -176,7 +176,7 @@ typedef struct {
 typedef struct {
 	uint8_t aSrcAddress[ETH_ALEN];
 	uint8_t aBSSID[ETH_ALEN];
-	uint32_t drvHandler;
+	tstrWILC_WFIDrv *drvHandler;
 	struct net_device *wilc_netdev;
 } tstrInterfaceInfo;
 typedef struct {
-- 
1.9.1

