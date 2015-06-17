Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:35985 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756597AbbFQNQc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 09:16:32 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] staging: wilc1000: remove WILC_WFIDrvHandle
Date: Wed, 17 Jun 2015 18:46:20 +0530
Message-Id: <1434546980-19094-1-git-send-email-sudipm.mukherjee@gmail.com> (sfid-20150617_151646_856535_8F4A8960)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WILC_WFIDrvHandle was:

typedef struct {
       s32 s32Dummy;
} *WILC_WFIDrvHandle;

which basically meant a pointer to an integer.
so removed the typedef and replaced all WILC_WFIDrvHandle with int *

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---

replacement was done by using sed, just manually removed the typedef.
build ok, before this change total 77 build warning, after this patch
same number of warnings. Might not apply because of some other pending
patch.

 drivers/staging/wilc1000/host_interface.c         | 148 +++++++++++-----------
 drivers/staging/wilc1000/host_interface.h         | 122 +++++++++---------
 drivers/staging/wilc1000/linux_wlan.c             |  14 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  18 +--
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |   4 +-
 5 files changed, 151 insertions(+), 155 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 3228824..76711e8 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -726,7 +726,7 @@ static s32 Handle_SetOperationMode(void *drvHandler, tstrHostIfSetOperationMode
 /**
  *  @brief host_int_set_IPAddress
  *  @details       Setting IP address params in message queue
- *  @param[in]    WILC_WFIDrvHandle hWFIDrv, u8* pu8IPAddr
+ *  @param[in]    int *hWFIDrv, u8* pu8IPAddr
  *  @return         Error code.
  *  @author
  *  @date
@@ -757,7 +757,7 @@ s32 Handle_set_IPAddress(void *drvHandler, u8 *pu8IPAddr, u8 idx)
 
 
 
-	host_int_get_ipaddress((WILC_WFIDrvHandle)drvHandler, firmwareIPAddress, idx);
+	host_int_get_ipaddress((int *)drvHandler, firmwareIPAddress, idx);
 
 	if (s32Error) {
 		PRINT_D(HOSTINF_DBG, "Failed to set IP address\n");
@@ -778,7 +778,7 @@ s32 Handle_set_IPAddress(void *drvHandler, u8 *pu8IPAddr, u8 idx)
 /**
  *  @brief Handle_get_IPAddress
  *  @details       Setting IP address params in message queue
- *  @param[in]    WILC_WFIDrvHandle hWFIDrv, u8* pu8IPAddr
+ *  @param[in]    int *hWFIDrv, u8* pu8IPAddr
  *  @return         Error code.
  *  @author
  *  @date
@@ -807,7 +807,7 @@ s32 Handle_get_IPAddress(void *drvHandler, u8 *pu8IPAddr, u8 idx)
 	WILC_FREE(strWID.ps8WidVal);
 
 	if (WILC_memcmp(gs8GetIP[idx], gs8SetIP[idx], IP_ALEN) != 0)
-		host_int_setup_ipaddress((WILC_WFIDrvHandle)pstrWFIDrv, gs8SetIP[idx], idx);
+		host_int_setup_ipaddress((int *)pstrWFIDrv, gs8SetIP[idx], idx);
 
 	if (s32Error != WILC_SUCCESS) {
 		PRINT_ER("Failed to get IP address\n");
@@ -1513,7 +1513,7 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 
 
 	PRINT_D(HOSTINF_DBG, "Getting site survey results\n");
-	s32Err = host_int_get_site_survey_results((WILC_WFIDrvHandle)pstrWFIDrv,
+	s32Err = host_int_get_site_survey_results((int *)pstrWFIDrv,
 						  gapu8RcvdSurveyResults,
 						  MAX_SURVEY_RESULT_FRAG_SIZE);
 	if (s32Err) {
@@ -2441,7 +2441,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
 			if (u8MacStatus == MAC_CONNECTED) {
 				WILC_memset(gapu8RcvdAssocResp, 0, MAX_ASSOC_RESP_FRAME_SIZE);
 
-				host_int_get_assoc_res_info((WILC_WFIDrvHandle)pstrWFIDrv,
+				host_int_get_assoc_res_info((int *)pstrWFIDrv,
 							    gapu8RcvdAssocResp,
 							    MAX_ASSOC_RESP_FRAME_SIZE,
 							    &u32RcvdAssocRespInfoLen);
@@ -2531,7 +2531,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
 			    (strConnectInfo.u16ConnectStatus == SUCCESSFUL_STATUSCODE))	{
 				#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 
-				host_int_set_power_mgmt((WILC_WFIDrvHandle)pstrWFIDrv, 0, 0);
+				host_int_set_power_mgmt((int *)pstrWFIDrv, 0, 0);
 				#endif
 
 				PRINT_D(HOSTINF_DBG, "MAC status : CONNECTED and Connect Status : Successful\n");
@@ -2607,7 +2607,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
 				#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 
 				g_obtainingIP = false;
-				host_int_set_power_mgmt((WILC_WFIDrvHandle)pstrWFIDrv, 0, 0);
+				host_int_set_power_mgmt((int *)pstrWFIDrv, 0, 0);
 				#endif
 
 				pstrWFIDrv->strWILC_UsrConnReq.pfUserConnectResult(CONN_DISCONN_EVENT_DISCONN_NOTIF,
@@ -3088,7 +3088,7 @@ static void Handle_Disconnect(void *drvHandler)
 	#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 
 	g_obtainingIP = false;
-	host_int_set_power_mgmt((WILC_WFIDrvHandle)pstrWFIDrv, 0, 0);
+	host_int_set_power_mgmt((int *)pstrWFIDrv, 0, 0);
 	#endif
 
 	WILC_memset(u8ConnectedSSID, 0, ETH_ALEN);
@@ -3189,7 +3189,7 @@ void resolve_disconnect_aberration(void *drvHandler)
 		return;
 	if ((pstrWFIDrv->enuHostIFstate == HOST_IF_WAITING_CONN_RESP) || (pstrWFIDrv->enuHostIFstate == HOST_IF_CONNECTING)) {
 		PRINT_D(HOSTINF_DBG, "\n\n<< correcting Supplicant state machine >>\n\n");
-		host_int_disconnect((WILC_WFIDrvHandle)pstrWFIDrv, 1);
+		host_int_disconnect((int *)pstrWFIDrv, 1);
 	}
 }
 static s32 Switch_Log_Terminal(void *drvHandler)
@@ -4632,7 +4632,7 @@ static void TimerCB_Connect(void *pvArg)
  *  @version		1.0
  */
 /* Check implementation in core adding 9 bytes to the input! */
-s32 host_int_remove_key(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8StaAddress)
+s32 host_int_remove_key(int *hWFIDrv, const u8 *pu8StaAddress)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -4661,7 +4661,7 @@ s32 host_int_remove_key(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8StaAddress)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_remove_wep_key(WILC_WFIDrvHandle hWFIDrv, u8 u8keyIdx)
+s32 host_int_remove_wep_key(int *hWFIDrv, u8 u8keyIdx)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -4711,7 +4711,7 @@ s32 host_int_remove_wep_key(WILC_WFIDrvHandle hWFIDrv, u8 u8keyIdx)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_WEPDefaultKeyID(WILC_WFIDrvHandle hWFIDrv, u8 u8Index)
+s32 host_int_set_WEPDefaultKeyID(int *hWFIDrv, u8 u8Index)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -4768,7 +4768,7 @@ s32 host_int_set_WEPDefaultKeyID(WILC_WFIDrvHandle hWFIDrv, u8 u8Index)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_add_wep_key_bss_sta(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx)
+s32 host_int_add_wep_key_bss_sta(int *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx)
 {
 
 	s32 s32Error = WILC_SUCCESS;
@@ -4834,7 +4834,7 @@ s32 host_int_add_wep_key_bss_sta(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8WepKey,
  *  @date		28 FEB 2013
  *  @version		1.0
  */
-s32 host_int_add_wep_key_bss_ap(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx, u8 u8mode, AUTHTYPE_T tenuAuth_type)
+s32 host_int_add_wep_key_bss_ap(int *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx, u8 u8mode, AUTHTYPE_T tenuAuth_type)
 {
 
 	s32 s32Error = WILC_SUCCESS;
@@ -4910,7 +4910,7 @@ s32 host_int_add_wep_key_bss_ap(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8WepKey,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_add_ptk(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
+s32 host_int_add_ptk(int *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 			     const u8 *mac_addr, const u8 *pu8RxMic, const u8 *pu8TxMic, u8 mode, u8 u8Ciphermode, u8 u8Idx)
 {
 	s32 s32Error = WILC_SUCCESS;
@@ -5012,7 +5012,7 @@ s32 host_int_add_ptk(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_add_rx_gtk(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKeylen,
+s32 host_int_add_rx_gtk(int *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKeylen,
 				u8 u8KeyIdx, u32 u32KeyRSClen, const u8 *KeyRSC,
 				const u8 *pu8RxMic, const u8 *pu8TxMic, u8 mode, u8 u8Ciphermode)
 {
@@ -5118,7 +5118,7 @@ s32 host_int_add_rx_gtk(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkK
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_add_tx_gtk(WILC_WFIDrvHandle hWFIDrv, u8 u8KeyLen, u8 *pu8TxGtk, u8 u8KeyIdx)
+s32 host_int_add_tx_gtk(int *hWFIDrv, u8 u8KeyLen, u8 *pu8TxGtk, u8 u8KeyIdx)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -5180,7 +5180,7 @@ s32 host_int_add_tx_gtk(WILC_WFIDrvHandle hWFIDrv, u8 u8KeyLen, u8 *pu8TxGtk, u8
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_pmkid_info(WILC_WFIDrvHandle hWFIDrv, tstrHostIFpmkidAttr *pu8PmkidInfoArray)
+s32 host_int_set_pmkid_info(int *hWFIDrv, tstrHostIFpmkidAttr *pu8PmkidInfoArray)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -5243,7 +5243,7 @@ s32 host_int_set_pmkid_info(WILC_WFIDrvHandle hWFIDrv, tstrHostIFpmkidAttr *pu8P
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_pmkid_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8PmkidInfoArray,
+s32 host_int_get_pmkid_info(int *hWFIDrv, u8 *pu8PmkidInfoArray,
 				    u32 u32PmkidInfoLen)
 {
 	s32 s32Error = WILC_SUCCESS;
@@ -5272,7 +5272,7 @@ s32 host_int_get_pmkid_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8PmkidInfoArray,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_RSNAConfigPSKPassPhrase(WILC_WFIDrvHandle hWFIDrv, u8 *pu8PassPhrase,
+s32 host_int_set_RSNAConfigPSKPassPhrase(int *hWFIDrv, u8 *pu8PassPhrase,
 						 u8 u8Psklength)
 {
 	s32 s32Error = WILC_SUCCESS;
@@ -5301,7 +5301,7 @@ s32 host_int_set_RSNAConfigPSKPassPhrase(WILC_WFIDrvHandle hWFIDrv, u8 *pu8PassP
  *  @date		19 April 2012
  *  @version		1.0
  */
-s32 host_int_get_MacAddress(WILC_WFIDrvHandle hWFIDrv, u8 *pu8MacAddress)
+s32 host_int_get_MacAddress(int *hWFIDrv, u8 *pu8MacAddress)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
@@ -5335,7 +5335,7 @@ s32 host_int_get_MacAddress(WILC_WFIDrvHandle hWFIDrv, u8 *pu8MacAddress)
  *  @date		16 July 2012
  *  @version		1.0
  */
-s32 host_int_set_MacAddress(WILC_WFIDrvHandle hWFIDrv, u8 *pu8MacAddress)
+s32 host_int_set_MacAddress(int *hWFIDrv, u8 *pu8MacAddress)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
@@ -5376,7 +5376,7 @@ s32 host_int_set_MacAddress(WILC_WFIDrvHandle hWFIDrv, u8 *pu8MacAddress)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_RSNAConfigPSKPassPhrase(WILC_WFIDrvHandle hWFIDrv,
+s32 host_int_get_RSNAConfigPSKPassPhrase(int *hWFIDrv,
 						 u8 *pu8PassPhrase, u8 u8Psklength)
 {
 	s32 s32Error = WILC_SUCCESS;
@@ -5423,7 +5423,7 @@ s32 host_int_get_RSNAConfigPSKPassPhrase(WILC_WFIDrvHandle hWFIDrv,
  *  @version		1.0
  */
 #ifndef CONNECT_DIRECT
-s32 host_int_get_site_survey_results(WILC_WFIDrvHandle hWFIDrv,
+s32 host_int_get_site_survey_results(int *hWFIDrv,
 					     u8 ppu8RcvdSiteSurveyResults[][MAX_SURVEY_RESULT_FRAG_SIZE],
 					     u32 u32MaxSiteSrvyFragLen)
 {
@@ -5473,7 +5473,7 @@ s32 host_int_get_site_survey_results(WILC_WFIDrvHandle hWFIDrv,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_start_scan_req(WILC_WFIDrvHandle hWFIDrv, u8 scanSource)
+s32 host_int_set_start_scan_req(int *hWFIDrv, u8 scanSource)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -5503,7 +5503,7 @@ s32 host_int_set_start_scan_req(WILC_WFIDrvHandle hWFIDrv, u8 scanSource)
  *  @version		1.0
  */
 
-s32 host_int_get_start_scan_req(WILC_WFIDrvHandle hWFIDrv, u8 *pu8ScanSource)
+s32 host_int_get_start_scan_req(int *hWFIDrv, u8 *pu8ScanSource)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -5528,7 +5528,7 @@ s32 host_int_get_start_scan_req(WILC_WFIDrvHandle hWFIDrv, u8 *pu8ScanSource)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_join_req(WILC_WFIDrvHandle hWFIDrv, u8 *pu8bssid,
+s32 host_int_set_join_req(int *hWFIDrv, u8 *pu8bssid,
 				  const u8 *pu8ssid, size_t ssidLen,
 				  const u8 *pu8IEs, size_t IEsLen,
 				  tWILCpfConnectResult pfConnectResult, void *pvUserArg,
@@ -5630,7 +5630,7 @@ s32 host_int_set_join_req(WILC_WFIDrvHandle hWFIDrv, u8 *pu8bssid,
  *  @version	8.0
  */
 
-s32 host_int_flush_join_req(WILC_WFIDrvHandle hWFIDrv)
+s32 host_int_flush_join_req(int *hWFIDrv)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
@@ -5674,7 +5674,7 @@ s32 host_int_flush_join_req(WILC_WFIDrvHandle hWFIDrv)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_disconnect(WILC_WFIDrvHandle hWFIDrv, u16 u16ReasonCode)
+s32 host_int_disconnect(int *hWFIDrv, u16 u16ReasonCode)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
@@ -5723,7 +5723,7 @@ s32 host_int_disconnect(WILC_WFIDrvHandle hWFIDrv, u16 u16ReasonCode)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_disconnect_station(WILC_WFIDrvHandle hWFIDrv, u8 assoc_id)
+s32 host_int_disconnect_station(int *hWFIDrv, u8 assoc_id)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -5763,7 +5763,7 @@ s32 host_int_disconnect_station(WILC_WFIDrvHandle hWFIDrv, u8 assoc_id)
  *  @version		1.0
  */
 
-s32 host_int_get_assoc_req_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8AssocReqInfo,
+s32 host_int_get_assoc_req_info(int *hWFIDrv, u8 *pu8AssocReqInfo,
 					u32 u32AssocReqInfoLen)
 {
 	s32 s32Error = WILC_SUCCESS;
@@ -5790,7 +5790,7 @@ s32 host_int_get_assoc_req_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8AssocReqInfo,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_assoc_res_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8AssocRespInfo,
+s32 host_int_get_assoc_res_info(int *hWFIDrv, u8 *pu8AssocRespInfo,
 					u32 u32MaxAssocRespInfoLen, u32 *pu32RcvdAssocRespInfoLen)
 {
 	s32 s32Error = WILC_SUCCESS;
@@ -5840,7 +5840,7 @@ s32 host_int_get_assoc_res_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8AssocRespInfo,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_rx_power_level(WILC_WFIDrvHandle hWFIDrv, u8 *pu8RxPowerLevel,
+s32 host_int_get_rx_power_level(int *hWFIDrv, u8 *pu8RxPowerLevel,
 					u32 u32RxPowerLevelLen)
 {
 	s32 s32Error = WILC_SUCCESS;
@@ -5871,7 +5871,7 @@ s32 host_int_get_rx_power_level(WILC_WFIDrvHandle hWFIDrv, u8 *pu8RxPowerLevel,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_mac_chnl_num(WILC_WFIDrvHandle hWFIDrv, u8 u8ChNum)
+s32 host_int_set_mac_chnl_num(int *hWFIDrv, u8 u8ChNum)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -5954,7 +5954,7 @@ s32 host_int_set_wfi_drv_handler(u32 u32address)
 
 
 
-s32 host_int_set_operation_mode(WILC_WFIDrvHandle hWFIDrv, u32 u32mode)
+s32 host_int_set_operation_mode(int *hWFIDrv, u32 u32mode)
 {
 	s32 s32Error = WILC_SUCCESS;
 
@@ -5995,7 +5995,7 @@ s32 host_int_set_operation_mode(WILC_WFIDrvHandle hWFIDrv, u32 u32mode)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_host_chnl_num(WILC_WFIDrvHandle hWFIDrv, u8 *pu8ChNo)
+s32 host_int_get_host_chnl_num(int *hWFIDrv, u8 *pu8ChNo)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -6034,14 +6034,14 @@ s32 host_int_get_host_chnl_num(WILC_WFIDrvHandle hWFIDrv, u8 *pu8ChNo)
 /**
  *  @brief                       host_int_test_set_int_wid
  *  @details             Test function for setting wids
- *  @param[in,out]   WILC_WFIDrvHandle hWFIDrv, u32 u32TestMemAddr
+ *  @param[in,out]   int *hWFIDrv, u32 u32TestMemAddr
  *  @return              Error code indicating success/failure
  *  @note
  *  @author		zsalah
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_test_set_int_wid(WILC_WFIDrvHandle hWFIDrv, u32 u32TestMemAddr)
+s32 host_int_test_set_int_wid(int *hWFIDrv, u32 u32TestMemAddr)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID	strWID;
@@ -6088,7 +6088,7 @@ s32 host_int_test_set_int_wid(WILC_WFIDrvHandle hWFIDrv, u32 u32TestMemAddr)
  *  @date
  *  @version		1.0
  */
-s32 host_int_get_inactive_time(WILC_WFIDrvHandle hWFIDrv, const u8 *mac, u32 *pu32InactiveTime)
+s32 host_int_get_inactive_time(int *hWFIDrv, const u8 *mac, u32 *pu32InactiveTime)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -6127,14 +6127,14 @@ s32 host_int_get_inactive_time(WILC_WFIDrvHandle hWFIDrv, const u8 *mac, u32 *pu
 /**
  *  @brief              host_int_test_get_int_wid
  *  @details    Test function for getting wids
- *  @param[in,out] WILC_WFIDrvHandle hWFIDrv, u32* pu32TestMemAddr
+ *  @param[in,out] int *hWFIDrv, u32* pu32TestMemAddr
  *  @return             Error code indicating success/failure
  *  @note
  *  @author		zsalah
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_test_get_int_wid(WILC_WFIDrvHandle hWFIDrv, u32 *pu32TestMemAddr)
+s32 host_int_test_get_int_wid(int *hWFIDrv, u32 *pu32TestMemAddr)
 {
 
 	s32 s32Error = WILC_SUCCESS;
@@ -6183,7 +6183,7 @@ s32 host_int_test_get_int_wid(WILC_WFIDrvHandle hWFIDrv, u32 *pu32TestMemAddr)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_rssi(WILC_WFIDrvHandle hWFIDrv, s8 *ps8Rssi)
+s32 host_int_get_rssi(int *hWFIDrv, s8 *ps8Rssi)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
@@ -6218,7 +6218,7 @@ s32 host_int_get_rssi(WILC_WFIDrvHandle hWFIDrv, s8 *ps8Rssi)
 	return s32Error;
 }
 
-s32 host_int_get_link_speed(WILC_WFIDrvHandle hWFIDrv, s8 *ps8lnkspd)
+s32 host_int_get_link_speed(int *hWFIDrv, s8 *ps8lnkspd)
 {
 	tstrHostIFmsg strHostIFmsg;
 	s32 s32Error = WILC_SUCCESS;
@@ -6255,7 +6255,7 @@ s32 host_int_get_link_speed(WILC_WFIDrvHandle hWFIDrv, s8 *ps8lnkspd)
 	return s32Error;
 }
 
-s32 host_int_get_statistics(WILC_WFIDrvHandle hWFIDrv, tstrStatistics *pstrStatistics)
+s32 host_int_get_statistics(int *hWFIDrv, tstrStatistics *pstrStatistics)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
@@ -6295,7 +6295,7 @@ s32 host_int_get_statistics(WILC_WFIDrvHandle hWFIDrv, tstrStatistics *pstrStati
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_scan(WILC_WFIDrvHandle hWFIDrv, u8 u8ScanSource,
+s32 host_int_scan(int *hWFIDrv, u8 u8ScanSource,
 			  u8 u8ScanType, u8 *pu8ChnlFreqList,
 			  u8 u8ChnlListLen, const u8 *pu8IEs,
 			  size_t IEsLen, tWILCpfScanResult ScanResult,
@@ -6369,7 +6369,7 @@ s32 host_int_scan(WILC_WFIDrvHandle hWFIDrv, u8 u8ScanSource,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 hif_set_cfg(WILC_WFIDrvHandle hWFIDrv, tstrCfgParamVal *pstrCfgParamVal)
+s32 hif_set_cfg(int *hWFIDrv, tstrCfgParamVal *pstrCfgParamVal)
 {
 
 	s32 s32Error = WILC_SUCCESS;
@@ -6411,7 +6411,7 @@ s32 hif_set_cfg(WILC_WFIDrvHandle hWFIDrv, tstrCfgParamVal *pstrCfgParamVal)
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 hif_get_cfg(WILC_WFIDrvHandle hWFIDrv, u16 u16WID, u16 *pu16WID_Value)
+s32 hif_get_cfg(int *hWFIDrv, u16 u16WID, u16 *pu16WID_Value)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -6592,7 +6592,7 @@ static u32 u32Intialized;
 static u32 msgQ_created;
 static u32 clients_count;
 
-s32 host_int_init(WILC_WFIDrvHandle *phWFIDrv)
+s32 host_int_init(int **phWFIDrv)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv;
@@ -6600,7 +6600,7 @@ s32 host_int_init(WILC_WFIDrvHandle *phWFIDrv)
 	/*if(u32Intialized == 1)
 	 * {
 	 *      PRINT_D(HOSTINF_DBG,"Host interface is previously initialized\n");
-	 * *phWFIDrv = (WILC_WFIDrvHandle)gWFiDrvHandle; //Will be adjusted later for P2P
+	 * *phWFIDrv = (int *)gWFiDrvHandle; //Will be adjusted later for P2P
 	 *      return 0;
 	 * }	*/
 	PRINT_D(HOSTINF_DBG, "Initializing host interface for client %d\n", clients_count + 1);
@@ -6621,7 +6621,7 @@ s32 host_int_init(WILC_WFIDrvHandle *phWFIDrv)
 	}
 	WILC_memset(pstrWFIDrv, 0, sizeof(tstrWILC_WFIDrv));
 	/*return driver handle to user*/
-	*phWFIDrv = (WILC_WFIDrvHandle)pstrWFIDrv;
+	*phWFIDrv = (int *)pstrWFIDrv;
 	/*save into globl handle*/
 
 	#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
@@ -6785,7 +6785,7 @@ _fail_:
  *  @version		1.0
  */
 
-s32 host_int_deinit(WILC_WFIDrvHandle hWFIDrv)
+s32 host_int_deinit(int *hWFIDrv)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
@@ -7085,7 +7085,7 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
  *  @date
  *  @version		1.0
  */
-s32 host_int_remain_on_channel(WILC_WFIDrvHandle hWFIDrv, u32 u32SessionID, u32 u32duration, u16 chan, tWILCpfRemainOnChanExpired RemainOnChanExpired, tWILCpfRemainOnChanReady RemainOnChanReady, void *pvUserArg)
+s32 host_int_remain_on_channel(int *hWFIDrv, u32 u32SessionID, u32 u32duration, u16 chan, tWILCpfRemainOnChanExpired RemainOnChanExpired, tWILCpfRemainOnChanReady RemainOnChanReady, void *pvUserArg)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -7134,7 +7134,7 @@ s32 host_int_remain_on_channel(WILC_WFIDrvHandle hWFIDrv, u32 u32SessionID, u32
  *  @date
  *  @version		1.0
  */
-s32 host_int_ListenStateExpired(WILC_WFIDrvHandle hWFIDrv, u32 u32SessionID)
+s32 host_int_ListenStateExpired(int *hWFIDrv, u32 u32SessionID)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -7172,7 +7172,7 @@ s32 host_int_ListenStateExpired(WILC_WFIDrvHandle hWFIDrv, u32 u32SessionID)
  *  @author
  *  @date
  *  @version		1.0*/
-s32 host_int_frame_register(WILC_WFIDrvHandle hWFIDrv, u16 u16FrameType, bool bReg)
+s32 host_int_frame_register(int *hWFIDrv, u16 u16FrameType, bool bReg)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -7224,7 +7224,7 @@ s32 host_int_frame_register(WILC_WFIDrvHandle hWFIDrv, u16 u16FrameType, bool bR
 /**
  *  @brief host_int_add_beacon
  *  @details       Setting add beacon params in message queue
- *  @param[in]    WILC_WFIDrvHandle hWFIDrv, u32 u32Interval,
+ *  @param[in]    int *hWFIDrv, u32 u32Interval,
  *                         u32 u32DTIMPeriod,u32 u32HeadLen, u8* pu8Head,
  *                         u32 u32TailLen, u8* pu8Tail
  *  @return         Error code.
@@ -7232,7 +7232,7 @@ s32 host_int_frame_register(WILC_WFIDrvHandle hWFIDrv, u16 u16FrameType, bool bR
  *  @date
  *  @version	1.0
  */
-s32 host_int_add_beacon(WILC_WFIDrvHandle hWFIDrv, u32 u32Interval,
+s32 host_int_add_beacon(int *hWFIDrv, u32 u32Interval,
 				u32 u32DTIMPeriod,
 				u32 u32HeadLen, u8 *pu8Head,
 				u32 u32TailLen, u8 *pu8Tail)
@@ -7299,13 +7299,13 @@ s32 host_int_add_beacon(WILC_WFIDrvHandle hWFIDrv, u32 u32Interval,
 /**
  *  @brief host_int_del_beacon
  *  @details       Setting add beacon params in message queue
- *  @param[in]    WILC_WFIDrvHandle hWFIDrv
+ *  @param[in]    int *hWFIDrv
  *  @return         Error code.
  *  @author
  *  @date
  *  @version	1.0
  */
-s32 host_int_del_beacon(WILC_WFIDrvHandle hWFIDrv)
+s32 host_int_del_beacon(int *hWFIDrv)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -7333,13 +7333,13 @@ s32 host_int_del_beacon(WILC_WFIDrvHandle hWFIDrv)
 /**
  *  @brief host_int_add_station
  *  @details       Setting add station params in message queue
- *  @param[in]    WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam* pstrStaParams
+ *  @param[in]    int *hWFIDrv, tstrWILC_AddStaParam* pstrStaParams
  *  @return         Error code.
  *  @author
  *  @date
  *  @version	1.0
  */
-s32 host_int_add_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam *pstrStaParams)
+s32 host_int_add_station(int *hWFIDrv, tstrWILC_AddStaParam *pstrStaParams)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -7384,13 +7384,13 @@ s32 host_int_add_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam *pstrSt
 /**
  *  @brief host_int_del_station
  *  @details       Setting delete station params in message queue
- *  @param[in]    WILC_WFIDrvHandle hWFIDrv, u8* pu8MacAddr
+ *  @param[in]    int *hWFIDrv, u8* pu8MacAddr
  *  @return         Error code.
  *  @author
  *  @date
  *  @version	1.0
  */
-s32 host_int_del_station(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8MacAddr)
+s32 host_int_del_station(int *hWFIDrv, const u8 *pu8MacAddr)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -7430,13 +7430,13 @@ s32 host_int_del_station(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8MacAddr)
 /**
  *  @brief      host_int_del_allstation
  *  @details    Setting del station params in message queue
- *  @param[in]  WILC_WFIDrvHandle hWFIDrv, u8 pu8MacAddr[][ETH_ALEN]s
+ *  @param[in]  int *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN]s
  *  @return        Error code.
  *  @author
  *  @date
  *  @version	1.0
  */
-s32 host_int_del_allstation(WILC_WFIDrvHandle hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
+s32 host_int_del_allstation(int *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -7494,13 +7494,13 @@ s32 host_int_del_allstation(WILC_WFIDrvHandle hWFIDrv, u8 pu8MacAddr[][ETH_ALEN]
 /**
  *  @brief host_int_edit_station
  *  @details       Setting edit station params in message queue
- *  @param[in]    WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam* pstrStaParams
+ *  @param[in]    int *hWFIDrv, tstrWILC_AddStaParam* pstrStaParams
  *  @return         Error code.
  *  @author
  *  @date
  *  @version	1.0
  */
-s32 host_int_edit_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam *pstrStaParams)
+s32 host_int_edit_station(int *hWFIDrv, tstrWILC_AddStaParam *pstrStaParams)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -7540,7 +7540,7 @@ s32 host_int_edit_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam *pstrS
 #endif /*WILC_AP_EXTERNAL_MLME*/
 uint32_t wilc_get_chipid(uint8_t);
 
-s32 host_int_set_power_mgmt(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled, u32 u32Timeout)
+s32 host_int_set_power_mgmt(int *hWFIDrv, bool bIsEnabled, u32 u32Timeout)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -7576,7 +7576,7 @@ s32 host_int_set_power_mgmt(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled, u32 u32T
 	return s32Error;
 }
 
-s32 host_int_setup_multicast_filter(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled, u32 u32count)
+s32 host_int_setup_multicast_filter(int *hWFIDrv, bool bIsEnabled, u32 u32count)
 {
 	s32 s32Error = WILC_SUCCESS;
 
@@ -7848,7 +7848,7 @@ void host_int_freeJoinParams(void *pJoinParams)
  *  @date
  *  @version		1.0**/
 
-static int host_int_addBASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char TID, short int BufferSize,
+static int host_int_addBASession(int *hWFIDrv, char *pBSSID, char TID, short int BufferSize,
 				 short int SessionTimeout, void *drvHandler)
 {
 	s32 s32Error = WILC_SUCCESS;
@@ -7884,7 +7884,7 @@ static int host_int_addBASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char T
 }
 
 
-s32 host_int_delBASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char TID)
+s32 host_int_delBASession(int *hWFIDrv, char *pBSSID, char TID)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -7919,7 +7919,7 @@ s32 host_int_delBASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char TID)
 	return s32Error;
 }
 
-s32 host_int_del_All_Rx_BASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char TID)
+s32 host_int_del_All_Rx_BASession(int *hWFIDrv, char *pBSSID, char TID)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -7962,7 +7962,7 @@ s32 host_int_del_All_Rx_BASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char
  *  @author		Abdelrahman Sobhy
  *  @date
  *  @version		1.0*/
-s32 host_int_setup_ipaddress(WILC_WFIDrvHandle hWFIDrv, u8 *u16ipadd, u8 idx)
+s32 host_int_setup_ipaddress(int *hWFIDrv, u8 *u16ipadd, u8 idx)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -8006,7 +8006,7 @@ s32 host_int_setup_ipaddress(WILC_WFIDrvHandle hWFIDrv, u8 *u16ipadd, u8 idx)
  *  @author		Abdelrahman Sobhy
  *  @date
  *  @version		1.0*/
-s32 host_int_get_ipaddress(WILC_WFIDrvHandle hWFIDrv, u8 *u16ipadd, u8 idx)
+s32 host_int_get_ipaddress(int *hWFIDrv, u8 *u16ipadd, u8 idx)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index dcd1275..54a764f 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -275,10 +275,6 @@ typedef void (*tWILCpfRemainOnChanExpired)(void *, u32);  /*Remain on channel ex
 typedef void (*tWILCpfRemainOnChanReady)(void *); /*Remain on channel callback function*/
 #endif
 
-/* typedef u32 WILC_WFIDrvHandle; */
-typedef struct {
-	s32 s32Dummy;
-} *WILC_WFIDrvHandle;
 
 /*!
  *  @struct             tstrRcvdNetworkInfo
@@ -496,7 +492,7 @@ typedef struct {
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_remove_key(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8StaAddress);
+s32 host_int_remove_key(int *hWFIDrv, const u8 *pu8StaAddress);
 /**
  *  @brief              removes WEP key
  *  @details    valid only in BSS STA mode if External Supplicant support is enabled.
@@ -511,7 +507,7 @@ s32 host_int_remove_key(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8StaAddress);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_remove_wep_key(WILC_WFIDrvHandle hWFIDrv, u8 u8Index);
+s32 host_int_remove_wep_key(int *hWFIDrv, u8 u8Index);
 /**
  *  @brief              sets WEP deafault key
  *  @details    Sets the index of the WEP encryption key in use,
@@ -524,7 +520,7 @@ s32 host_int_remove_wep_key(WILC_WFIDrvHandle hWFIDrv, u8 u8Index);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_WEPDefaultKeyID(WILC_WFIDrvHandle hWFIDrv, u8 u8Index);
+s32 host_int_set_WEPDefaultKeyID(int *hWFIDrv, u8 u8Index);
 
 /**
  *  @brief              sets WEP deafault key
@@ -545,7 +541,7 @@ s32 host_int_set_WEPDefaultKeyID(WILC_WFIDrvHandle hWFIDrv, u8 u8Index);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_add_wep_key_bss_sta(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx);
+s32 host_int_add_wep_key_bss_sta(int *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx);
 /**
  *  @brief              host_int_add_wep_key_bss_ap
  *  @details    valid only in AP mode if External Supplicant support is enabled.
@@ -560,7 +556,7 @@ s32 host_int_add_wep_key_bss_sta(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8WepKey,
  *  @date		28 Feb 2013
  *  @version		1.0
  */
-s32 host_int_add_wep_key_bss_ap(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx, u8 u8mode, AUTHTYPE_T tenuAuth_type);
+s32 host_int_add_wep_key_bss_ap(int *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx, u8 u8mode, AUTHTYPE_T tenuAuth_type);
 
 /**
  *  @brief              adds ptk Key
@@ -578,7 +574,7 @@ s32 host_int_add_wep_key_bss_ap(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8WepKey,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_add_ptk(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
+s32 host_int_add_ptk(int *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 			     const u8 *mac_addr, const u8 *pu8RxMic, const u8 *pu8TxMic, u8 mode, u8 u8Ciphermode, u8 u8Idx);
 
 /**
@@ -593,7 +589,7 @@ s32 host_int_add_ptk(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen
  *  @date		15 April 2013
  *  @version		1.0
  */
-s32 host_int_get_inactive_time(WILC_WFIDrvHandle hWFIDrv, const u8 *mac, u32 *pu32InactiveTime);
+s32 host_int_get_inactive_time(int *hWFIDrv, const u8 *mac, u32 *pu32InactiveTime);
 
 /**
  *  @brief              adds Rx GTk Key
@@ -611,7 +607,7 @@ s32 host_int_get_inactive_time(WILC_WFIDrvHandle hWFIDrv, const u8 *mac, u32 *pu
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_add_rx_gtk(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKeylen,
+s32 host_int_add_rx_gtk(int *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKeylen,
 				u8 u8KeyIdx, u32 u32KeyRSClen, const u8 *KeyRSC,
 				const u8 *pu8RxMic, const u8 *pu8TxMic, u8 mode, u8 u8Ciphermode);
 
@@ -632,7 +628,7 @@ s32 host_int_add_rx_gtk(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkK
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_add_tx_gtk(WILC_WFIDrvHandle hWFIDrv, u8 u8KeyLen, u8 *pu8TxGtk, u8 u8KeyIdx);
+s32 host_int_add_tx_gtk(int *hWFIDrv, u8 u8KeyLen, u8 *pu8TxGtk, u8 u8KeyIdx);
 
 /**
  *  @brief              caches the pmkid
@@ -655,7 +651,7 @@ s32 host_int_add_tx_gtk(WILC_WFIDrvHandle hWFIDrv, u8 u8KeyLen, u8 *pu8TxGtk, u8
  *  @version		1.0
  */
 
-s32 host_int_set_pmkid_info(WILC_WFIDrvHandle hWFIDrv, tstrHostIFpmkidAttr *pu8PmkidInfoArray);
+s32 host_int_set_pmkid_info(int *hWFIDrv, tstrHostIFpmkidAttr *pu8PmkidInfoArray);
 /**
  *  @brief              gets the cached the pmkid info
  *  @details    valid only in BSS STA mode if External Supplicant
@@ -679,7 +675,7 @@ s32 host_int_set_pmkid_info(WILC_WFIDrvHandle hWFIDrv, tstrHostIFpmkidAttr *pu8P
  *  @version		1.0
  */
 
-s32 host_int_get_pmkid_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8PmkidInfoArray,
+s32 host_int_get_pmkid_info(int *hWFIDrv, u8 *pu8PmkidInfoArray,
 				    u32 u32PmkidInfoLen);
 
 /**
@@ -696,7 +692,7 @@ s32 host_int_get_pmkid_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8PmkidInfoArray,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_RSNAConfigPSKPassPhrase(WILC_WFIDrvHandle hWFIDrv, u8 *pu8PassPhrase,
+s32 host_int_set_RSNAConfigPSKPassPhrase(int *hWFIDrv, u8 *pu8PassPhrase,
 						 u8 u8Psklength);
 /**
  *  @brief              gets the pass phrase
@@ -712,7 +708,7 @@ s32 host_int_set_RSNAConfigPSKPassPhrase(WILC_WFIDrvHandle hWFIDrv, u8 *pu8PassP
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_RSNAConfigPSKPassPhrase(WILC_WFIDrvHandle hWFIDrv,
+s32 host_int_get_RSNAConfigPSKPassPhrase(int *hWFIDrv,
 						 u8 *pu8PassPhrase, u8 u8Psklength);
 
 /**
@@ -726,7 +722,7 @@ s32 host_int_get_RSNAConfigPSKPassPhrase(WILC_WFIDrvHandle hWFIDrv,
  *  @date		19 April 2012
  *  @version		1.0
  */
-s32 host_int_get_MacAddress(WILC_WFIDrvHandle hWFIDrv, u8 *pu8MacAddress);
+s32 host_int_get_MacAddress(int *hWFIDrv, u8 *pu8MacAddress);
 
 /**
  *  @brief              sets mac address
@@ -739,7 +735,7 @@ s32 host_int_get_MacAddress(WILC_WFIDrvHandle hWFIDrv, u8 *pu8MacAddress);
  *  @date		16 July 2012
  *  @version		1.0
  */
-s32 host_int_set_MacAddress(WILC_WFIDrvHandle hWFIDrv, u8 *pu8MacAddress);
+s32 host_int_set_MacAddress(int *hWFIDrv, u8 *pu8MacAddress);
 
 /**
  *  @brief              wait until msg q is empty
@@ -784,7 +780,7 @@ s32 host_int_wait_msg_queue_idle(void);
  *  @version		1.0
  */
 #ifndef CONNECT_DIRECT
-s32 host_int_get_site_survey_results(WILC_WFIDrvHandle hWFIDrv,
+s32 host_int_get_site_survey_results(int *hWFIDrv,
 					     u8 ppu8RcvdSiteSurveyResults[][MAX_SURVEY_RESULT_FRAG_SIZE],
 					     u32 u32MaxSiteSrvyFragLen);
 #endif
@@ -805,7 +801,7 @@ s32 host_int_get_site_survey_results(WILC_WFIDrvHandle hWFIDrv,
  *  @version		1.0
  */
 
-s32 host_int_set_start_scan_req(WILC_WFIDrvHandle hWFIDrv, u8 scanSource);
+s32 host_int_set_start_scan_req(int *hWFIDrv, u8 scanSource);
 /**
  *  @brief              gets scan source of the last scan
  *  @details
@@ -821,7 +817,7 @@ s32 host_int_set_start_scan_req(WILC_WFIDrvHandle hWFIDrv, u8 scanSource);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_start_scan_req(WILC_WFIDrvHandle hWFIDrv, u8 *pu8ScanSource);
+s32 host_int_get_start_scan_req(int *hWFIDrv, u8 *pu8ScanSource);
 
 /**
  *  @brief              sets a join request
@@ -835,7 +831,7 @@ s32 host_int_get_start_scan_req(WILC_WFIDrvHandle hWFIDrv, u8 *pu8ScanSource);
  *  @version		1.0
  */
 
-s32 host_int_set_join_req(WILC_WFIDrvHandle hWFIDrv, u8 *pu8bssid,
+s32 host_int_set_join_req(int *hWFIDrv, u8 *pu8bssid,
 				  const u8 *pu8ssid, size_t ssidLen,
 				  const u8 *pu8IEs, size_t IEsLen,
 				  tWILCpfConnectResult pfConnectResult, void *pvUserArg,
@@ -855,7 +851,7 @@ s32 host_int_set_join_req(WILC_WFIDrvHandle hWFIDrv, u8 *pu8bssid,
  *  @version		8.0
  */
 
-s32 host_int_flush_join_req(WILC_WFIDrvHandle hWFIDrv);
+s32 host_int_flush_join_req(int *hWFIDrv);
 
 
 /**
@@ -869,7 +865,7 @@ s32 host_int_flush_join_req(WILC_WFIDrvHandle hWFIDrv);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_disconnect(WILC_WFIDrvHandle hWFIDrv, u16 u16ReasonCode);
+s32 host_int_disconnect(int *hWFIDrv, u16 u16ReasonCode);
 
 /**
  *  @brief              disconnects a sta
@@ -882,7 +878,7 @@ s32 host_int_disconnect(WILC_WFIDrvHandle hWFIDrv, u16 u16ReasonCode);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_disconnect_station(WILC_WFIDrvHandle hWFIDrv, u8 assoc_id);
+s32 host_int_disconnect_station(int *hWFIDrv, u8 assoc_id);
 /**
  *  @brief              gets a Association request info
  *  @details
@@ -909,7 +905,7 @@ s32 host_int_disconnect_station(WILC_WFIDrvHandle hWFIDrv, u8 assoc_id);
  *  @version		1.0
  */
 
-s32 host_int_get_assoc_req_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8AssocReqInfo,
+s32 host_int_get_assoc_req_info(int *hWFIDrv, u8 *pu8AssocReqInfo,
 					u32 u32AssocReqInfoLen);
 /**
  *  @brief              gets a Association Response info
@@ -923,7 +919,7 @@ s32 host_int_get_assoc_req_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8AssocReqInfo,
  *  @version		1.0
  */
 
-s32 host_int_get_assoc_res_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8AssocRespInfo,
+s32 host_int_get_assoc_res_info(int *hWFIDrv, u8 *pu8AssocRespInfo,
 					u32 u32MaxAssocRespInfoLen, u32 *pu32RcvdAssocRespInfoLen);
 /**
  *  @brief              gets a Association Response info
@@ -940,7 +936,7 @@ s32 host_int_get_assoc_res_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8AssocRespInfo,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_rx_power_level(WILC_WFIDrvHandle hWFIDrv, u8 *pu8RxPowerLevel,
+s32 host_int_get_rx_power_level(int *hWFIDrv, u8 *pu8RxPowerLevel,
 					u32 u32RxPowerLevelLen);
 
 /**
@@ -958,7 +954,7 @@ s32 host_int_get_rx_power_level(WILC_WFIDrvHandle hWFIDrv, u8 *pu8RxPowerLevel,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_mac_chnl_num(WILC_WFIDrvHandle hWFIDrv, u8 u8ChNum);
+s32 host_int_set_mac_chnl_num(int *hWFIDrv, u8 u8ChNum);
 
 /**
  *  @brief              gets the current channel index
@@ -975,7 +971,7 @@ s32 host_int_set_mac_chnl_num(WILC_WFIDrvHandle hWFIDrv, u8 u8ChNum);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_host_chnl_num(WILC_WFIDrvHandle hWFIDrv, u8 *pu8ChNo);
+s32 host_int_get_host_chnl_num(int *hWFIDrv, u8 *pu8ChNo);
 /**
  *  @brief              gets the sta rssi
  *  @details    gets the currently maintained RSSI value for the station.
@@ -989,8 +985,8 @@ s32 host_int_get_host_chnl_num(WILC_WFIDrvHandle hWFIDrv, u8 *pu8ChNo);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_rssi(WILC_WFIDrvHandle hWFIDrv, s8 *ps8Rssi);
-s32 host_int_get_link_speed(WILC_WFIDrvHandle hWFIDrv, s8 *ps8lnkspd);
+s32 host_int_get_rssi(int *hWFIDrv, s8 *ps8Rssi);
+s32 host_int_get_link_speed(int *hWFIDrv, s8 *ps8lnkspd);
 /**
  *  @brief              scans a set of channels
  *  @details
@@ -1008,7 +1004,7 @@ s32 host_int_get_link_speed(WILC_WFIDrvHandle hWFIDrv, s8 *ps8lnkspd);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_scan(WILC_WFIDrvHandle hWFIDrv, u8 u8ScanSource,
+s32 host_int_scan(int *hWFIDrv, u8 u8ScanSource,
 			  u8 u8ScanType, u8 *pu8ChnlFreqList,
 			  u8 u8ChnlListLen, const u8 *pu8IEs,
 			  size_t IEsLen, tWILCpfScanResult ScanResult,
@@ -1024,7 +1020,7 @@ s32 host_int_scan(WILC_WFIDrvHandle hWFIDrv, u8 u8ScanSource,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 hif_set_cfg(WILC_WFIDrvHandle hWFIDrv, tstrCfgParamVal *pstrCfgParamVal);
+s32 hif_set_cfg(int *hWFIDrv, tstrCfgParamVal *pstrCfgParamVal);
 
 /**
  *  @brief              gets configuration wids values
@@ -1038,7 +1034,7 @@ s32 hif_set_cfg(WILC_WFIDrvHandle hWFIDrv, tstrCfgParamVal *pstrCfgParamVal);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 hif_get_cfg(WILC_WFIDrvHandle hWFIDrv, u16 u16WID, u16 *pu16WID_Value);
+s32 hif_get_cfg(int *hWFIDrv, u16 u16WID, u16 *pu16WID_Value);
 /*****************************************************************************/
 /*							Notification Functions							 */
 /*****************************************************************************/
@@ -1085,7 +1081,7 @@ void host_int_send_network_info_to_host
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_init(WILC_WFIDrvHandle *phWFIDrv);
+s32 host_int_init(int **phWFIDrv);
 
 /**
  *  @brief              host interface initialization function
@@ -1096,11 +1092,11 @@ s32 host_int_init(WILC_WFIDrvHandle *phWFIDrv);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_deinit(WILC_WFIDrvHandle hWFIDrv);
+s32 host_int_deinit(int *hWFIDrv);
 
 
 /*!
- *  @fn		s32 host_int_add_beacon(WILC_WFIDrvHandle hWFIDrv,u8 u8Index)
+ *  @fn		s32 host_int_add_beacon(int *hWFIDrv,u8 u8Index)
  *  @brief		Sends a beacon to the firmware to be transmitted over the air
  *  @details
  *  @param[in,out]	hWFIDrv		handle to the wifi driver
@@ -1121,14 +1117,14 @@ s32 host_int_deinit(WILC_WFIDrvHandle hWFIDrv);
  *  @version		1.0 Description
  *
  */
-s32 host_int_add_beacon(WILC_WFIDrvHandle hWFIDrv, u32 u32Interval,
+s32 host_int_add_beacon(int *hWFIDrv, u32 u32Interval,
 				u32 u32DTIMPeriod,
 				u32 u32HeadLen, u8 *pu8Head,
 				u32 u32TailLen, u8 *pu8tail);
 
 
 /*!
- *  @fn		s32 host_int_del_beacon(WILC_WFIDrvHandle hWFIDrv)
+ *  @fn		s32 host_int_del_beacon(int *hWFIDrv)
  *  @brief		Removes the beacon and stops trawilctting it over the air
  *  @details
  *  @param[in,out]	hWFIDrv		handle to the wifi driver
@@ -1139,10 +1135,10 @@ s32 host_int_add_beacon(WILC_WFIDrvHandle hWFIDrv, u32 u32Interval,
  *  @date		10 Julys 2012
  *  @version		1.0 Description
  */
-s32 host_int_del_beacon(WILC_WFIDrvHandle hWFIDrv);
+s32 host_int_del_beacon(int *hWFIDrv);
 
 /*!
- *  @fn		s32 host_int_add_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam strStaParams)
+ *  @fn		s32 host_int_add_station(int *hWFIDrv, tstrWILC_AddStaParam strStaParams)
  *  @brief		Notifies the firmware with a new associated stations
  *  @details
  *  @param[in,out]	hWFIDrv		handle to the wifi driver
@@ -1154,10 +1150,10 @@ s32 host_int_del_beacon(WILC_WFIDrvHandle hWFIDrv);
  *  @date		12 July 2012
  *  @version		1.0 Description
  */
-s32 host_int_add_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam *pstrStaParams);
+s32 host_int_add_station(int *hWFIDrv, tstrWILC_AddStaParam *pstrStaParams);
 
 /*!
- *  @fn		s32 host_int_del_allstation(WILC_WFIDrvHandle hWFIDrv, const u8* pu8MacAddr)
+ *  @fn		s32 host_int_del_allstation(int *hWFIDrv, const u8* pu8MacAddr)
  *  @brief		Deauthenticates clients when group is terminating
  *  @details
  *  @param[in,out]	hWFIDrv		handle to the wifi driver
@@ -1169,10 +1165,10 @@ s32 host_int_add_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam *pstrSt
  *  @date		09 April 2014
  *  @version		1.0 Description
  */
-s32 host_int_del_allstation(WILC_WFIDrvHandle hWFIDrv, u8 pu8MacAddr[][ETH_ALEN]);
+s32 host_int_del_allstation(int *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN]);
 
 /*!
- *  @fn		s32 host_int_del_station(WILC_WFIDrvHandle hWFIDrv, u8* pu8MacAddr)
+ *  @fn		s32 host_int_del_station(int *hWFIDrv, u8* pu8MacAddr)
  *  @brief		Notifies the firmware with a new deleted station
  *  @details
  *  @param[in,out]	hWFIDrv		handle to the wifi driver
@@ -1184,10 +1180,10 @@ s32 host_int_del_allstation(WILC_WFIDrvHandle hWFIDrv, u8 pu8MacAddr[][ETH_ALEN]
  *  @date		15 July 2012
  *  @version		1.0 Description
  */
-s32 host_int_del_station(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8MacAddr);
+s32 host_int_del_station(int *hWFIDrv, const u8 *pu8MacAddr);
 
 /*!
- *  @fn		s32 host_int_edit_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam strStaParams)
+ *  @fn		s32 host_int_edit_station(int *hWFIDrv, tstrWILC_AddStaParam strStaParams)
  *  @brief		Notifies the firmware with new parameters of an already associated station
  *  @details
  *  @param[in,out]	hWFIDrv		handle to the wifi driver
@@ -1199,10 +1195,10 @@ s32 host_int_del_station(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8MacAddr);
  *  @date		15 July 2012
  *  @version		1.0 Description
  */
-s32 host_int_edit_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam *pstrStaParams);
+s32 host_int_edit_station(int *hWFIDrv, tstrWILC_AddStaParam *pstrStaParams);
 
 /*!
- *  @fn		s32 host_int_set_power_mgmt(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled, u32 u32Timeout)
+ *  @fn		s32 host_int_set_power_mgmt(int *hWFIDrv, bool bIsEnabled, u32 u32Timeout)
  *  @brief		Set the power management mode to enabled or disabled
  *  @details
  *  @param[in,out]	hWFIDrv		handle to the wifi driver
@@ -1216,7 +1212,7 @@ s32 host_int_edit_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam *pstrS
  *  @date		24 November 2012
  *  @version		1.0 Description
  */
-s32 host_int_set_power_mgmt(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled, u32 u32Timeout);
+s32 host_int_set_power_mgmt(int *hWFIDrv, bool bIsEnabled, u32 u32Timeout);
 /*  @param[in,out]	hWFIDrv		handle to the wifi driver
  *  @param[in]	bIsEnabled	TRUE if enabled, FALSE otherwise
  *  @param[in]	u8count		count of mac address entries in the filter table
@@ -1228,7 +1224,7 @@ s32 host_int_set_power_mgmt(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled, u32 u32T
  *  @date		24 November 2012
  *  @version		1.0 Description
  */
-s32 host_int_setup_multicast_filter(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled, u32 u32count);
+s32 host_int_setup_multicast_filter(int *hWFIDrv, bool bIsEnabled, u32 u32count);
 /**
  *  @brief           host_int_setup_ipaddress
  *  @details       set IP address on firmware
@@ -1238,7 +1234,7 @@ s32 host_int_setup_multicast_filter(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled,
  *  @date
  *  @version	1.0
  */
-s32 host_int_setup_ipaddress(WILC_WFIDrvHandle hWFIDrv, u8 *pu8IPAddr, u8 idx);
+s32 host_int_setup_ipaddress(int *hWFIDrv, u8 *pu8IPAddr, u8 idx);
 
 
 /**
@@ -1250,7 +1246,7 @@ s32 host_int_setup_ipaddress(WILC_WFIDrvHandle hWFIDrv, u8 *pu8IPAddr, u8 idx);
  *  @date
  *  @version	1.0
  */
-s32 host_int_delBASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char TID);
+s32 host_int_delBASession(int *hWFIDrv, char *pBSSID, char TID);
 
 /**
  *  @brief           host_int_delBASession
@@ -1261,7 +1257,7 @@ s32 host_int_delBASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char TID);
  *  @date
  *  @version	1.0
  */
-s32 host_int_del_All_Rx_BASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char TID);
+s32 host_int_del_All_Rx_BASession(int *hWFIDrv, char *pBSSID, char TID);
 
 
 /**
@@ -1273,7 +1269,7 @@ s32 host_int_del_All_Rx_BASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char
  *  @date
  *  @version	1.0
  */
-s32 host_int_get_ipaddress(WILC_WFIDrvHandle hWFIDrv, u8 *pu8IPAddr, u8 idx);
+s32 host_int_get_ipaddress(int *hWFIDrv, u8 *pu8IPAddr, u8 idx);
 
 #ifdef WILC_P2P
 /**
@@ -1285,7 +1281,7 @@ s32 host_int_get_ipaddress(WILC_WFIDrvHandle hWFIDrv, u8 *pu8IPAddr, u8 idx);
  *  @date
  *  @version	1.0
  */
-s32 host_int_remain_on_channel(WILC_WFIDrvHandle hWFIDrv, u32 u32SessionID, u32 u32duration, u16 chan, tWILCpfRemainOnChanExpired RemainOnChanExpired, tWILCpfRemainOnChanReady RemainOnChanReady, void *pvUserArg);
+s32 host_int_remain_on_channel(int *hWFIDrv, u32 u32SessionID, u32 u32duration, u16 chan, tWILCpfRemainOnChanExpired RemainOnChanExpired, tWILCpfRemainOnChanReady RemainOnChanReady, void *pvUserArg);
 
 /**
  *  @brief              host_int_ListenStateExpired
@@ -1301,7 +1297,7 @@ s32 host_int_remain_on_channel(WILC_WFIDrvHandle hWFIDrv, u32 u32SessionID, u32
  *  @date
  *  @version		1.0
  */
-s32 host_int_ListenStateExpired(WILC_WFIDrvHandle hWFIDrv, u32 u32SessionID);
+s32 host_int_ListenStateExpired(int *hWFIDrv, u32 u32SessionID);
 
 /**
  *  @brief           host_int_frame_register
@@ -1312,7 +1308,7 @@ s32 host_int_ListenStateExpired(WILC_WFIDrvHandle hWFIDrv, u32 u32SessionID);
  *  @date
  *  @version	1.0
  */
-s32 host_int_frame_register(WILC_WFIDrvHandle hWFIDrv, u16 u16FrameType, bool bReg);
+s32 host_int_frame_register(int *hWFIDrv, u16 u16FrameType, bool bReg);
 #endif
 /**
  *  @brief           host_int_set_wfi_drv_handler
@@ -1324,17 +1320,17 @@ s32 host_int_frame_register(WILC_WFIDrvHandle hWFIDrv, u16 u16FrameType, bool bR
  *  @version	1.0
  */
 s32 host_int_set_wfi_drv_handler(u32 u32address);
-s32 host_int_set_operation_mode(WILC_WFIDrvHandle hWFIDrv, u32 u32mode);
+s32 host_int_set_operation_mode(int *hWFIDrv, u32 u32mode);
 
 static s32 Handle_ScanDone(void *drvHandler, tenuScanEvent enuEvent);
 
-static int host_int_addBASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char TID, short int BufferSize,
+static int host_int_addBASession(int *hWFIDrv, char *pBSSID, char TID, short int BufferSize,
 				 short int SessionTimeout, void *drvHandler);
 
 
 void host_int_freeJoinParams(void *pJoinParams);
 
-s32 host_int_get_statistics(WILC_WFIDrvHandle hWFIDrv, tstrStatistics *pstrStatistics);
+s32 host_int_get_statistics(int *hWFIDrv, tstrStatistics *pstrStatistics);
 
 /*****************************************************************************/
 /*																			 */
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 8ecbb2d..61a71ef 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -310,13 +310,13 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 
 
 		if (bEnablePS)
-			host_int_set_power_mgmt((WILC_WFIDrvHandle)pstrWFIDrv, 1, 0);
+			host_int_set_power_mgmt((int *)pstrWFIDrv, 1, 0);
 
 		PRINT_D(GENERIC_DBG, "[%s] Up IP\n", dev_iface->ifa_label);
 
 		pIP_Add_buff = (char *) (&(dev_iface->ifa_address));
 		PRINT_D(GENERIC_DBG, "IP add=%d:%d:%d:%d \n", pIP_Add_buff[0], pIP_Add_buff[1], pIP_Add_buff[2], pIP_Add_buff[3]);
-		host_int_setup_ipaddress((WILC_WFIDrvHandle)pstrWFIDrv, pIP_Add_buff, nic->u8IfIdx);
+		host_int_setup_ipaddress((int *)pstrWFIDrv, pIP_Add_buff, nic->u8IfIdx);
 
 		break;
 
@@ -330,7 +330,7 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 		}
 
 		if (memcmp(dev_iface->ifa_label, wlan_dev_name, 5) == 0)
-			host_int_set_power_mgmt((WILC_WFIDrvHandle)pstrWFIDrv, 0, 0);
+			host_int_set_power_mgmt((int *)pstrWFIDrv, 0, 0);
 
 		resolve_disconnect_aberration(pstrWFIDrv);
 
@@ -340,7 +340,7 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 		pIP_Add_buff = null_ip;
 		PRINT_D(GENERIC_DBG, "IP add=%d:%d:%d:%d \n", pIP_Add_buff[0], pIP_Add_buff[1], pIP_Add_buff[2], pIP_Add_buff[3]);
 
-		host_int_setup_ipaddress((WILC_WFIDrvHandle)pstrWFIDrv, pIP_Add_buff, nic->u8IfIdx);
+		host_int_setup_ipaddress((int *)pstrWFIDrv, pIP_Add_buff, nic->u8IfIdx);
 
 		break;
 
@@ -2187,14 +2187,14 @@ static void wilc_set_multicast_list(struct net_device *dev)
 	if ((dev->flags & IFF_ALLMULTI) || (dev->mc.count) > WILC_MULTICAST_TABLE_SIZE) {
 		PRINT_D(INIT_DBG, "Disable multicast filter, retrive all multicast packets\n");
 		/* get all multicast packets */
-		host_int_setup_multicast_filter((WILC_WFIDrvHandle)pstrWFIDrv, false, 0);
+		host_int_setup_multicast_filter((int *)pstrWFIDrv, false, 0);
 		return;
 	}
 
 	/* No multicast?  Just get our own stuff */
 	if ((dev->mc.count) == 0) {
 		PRINT_D(INIT_DBG, "Enable multicast filter, retrive directed packets only.\n");
-		host_int_setup_multicast_filter((WILC_WFIDrvHandle)pstrWFIDrv, true, 0);
+		host_int_setup_multicast_filter((int *)pstrWFIDrv, true, 0);
 		return;
 	}
 
@@ -2207,7 +2207,7 @@ static void wilc_set_multicast_list(struct net_device *dev)
 		i++;
 	}
 
-	host_int_setup_multicast_filter((WILC_WFIDrvHandle)pstrWFIDrv, true, (dev->mc.count));
+	host_int_setup_multicast_filter((int *)pstrWFIDrv, true, (dev->mc.count));
 
 	return;
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 92064db..1e911aa 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2907,15 +2907,15 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
 
 			/*Setting interface 1 drv handler and mac address in newly downloaded FW*/
 			host_int_set_wfi_drv_handler(g_linux_wlan->strInterfaceInfo[0].drvHandler);
-			host_int_set_MacAddress((WILC_WFIDrvHandle)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
+			host_int_set_MacAddress((int *)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
 						g_linux_wlan->strInterfaceInfo[0].aSrcAddress);
 			host_int_set_operation_mode(priv->hWILCWFIDrv, STATION_MODE);
 
 			/*Add saved WEP keys, if any*/
 			if (g_wep_keys_saved) {
-				host_int_set_WEPDefaultKeyID((WILC_WFIDrvHandle)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
+				host_int_set_WEPDefaultKeyID((int *)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
 							     g_key_wep_params.key_idx);
-				host_int_add_wep_key_bss_sta((WILC_WFIDrvHandle)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
+				host_int_add_wep_key_bss_sta((int *)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
 							     g_key_wep_params.key,
 							     g_key_wep_params.key_len,
 							     g_key_wep_params.key_idx);
@@ -2995,15 +2995,15 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
 			g_wilc_initialized = 1;
 
 			host_int_set_wfi_drv_handler(g_linux_wlan->strInterfaceInfo[0].drvHandler);
-			host_int_set_MacAddress((WILC_WFIDrvHandle)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
+			host_int_set_MacAddress((int *)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
 						g_linux_wlan->strInterfaceInfo[0].aSrcAddress);
 			host_int_set_operation_mode(priv->hWILCWFIDrv, STATION_MODE);
 
 			/*Add saved WEP keys, if any*/
 			if (g_wep_keys_saved) {
-				host_int_set_WEPDefaultKeyID((WILC_WFIDrvHandle)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
+				host_int_set_WEPDefaultKeyID((int *)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
 							     g_key_wep_params.key_idx);
-				host_int_add_wep_key_bss_sta((WILC_WFIDrvHandle)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
+				host_int_add_wep_key_bss_sta((int *)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
 							     g_key_wep_params.key,
 							     g_key_wep_params.key_len,
 							     g_key_wep_params.key_idx);
@@ -3127,15 +3127,15 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
 
 		/*Setting interface 1 drv handler and mac address in newly downloaded FW*/
 		host_int_set_wfi_drv_handler(g_linux_wlan->strInterfaceInfo[0].drvHandler);
-		host_int_set_MacAddress((WILC_WFIDrvHandle)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
+		host_int_set_MacAddress((int *)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
 					g_linux_wlan->strInterfaceInfo[0].aSrcAddress);
 		host_int_set_operation_mode(priv->hWILCWFIDrv, AP_MODE);
 
 		/*Add saved WEP keys, if any*/
 		if (g_wep_keys_saved) {
-			host_int_set_WEPDefaultKeyID((WILC_WFIDrvHandle)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
+			host_int_set_WEPDefaultKeyID((int *)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
 						     g_key_wep_params.key_idx);
-			host_int_add_wep_key_bss_sta((WILC_WFIDrvHandle)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
+			host_int_add_wep_key_bss_sta((int *)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
 						     g_key_wep_params.key,
 						     g_key_wep_params.key_len,
 						     g_key_wep_params.key_idx);
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 2331a00..952152e 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -153,8 +153,8 @@ struct WILC_WFI_priv {
 	spinlock_t lock;
 	struct net_device *dev;
 	struct napi_struct napi;
-	WILC_WFIDrvHandle hWILCWFIDrv;
-	WILC_WFIDrvHandle hWILCWFIDrv_2;
+	int *hWILCWFIDrv;
+	int *hWILCWFIDrv_2;
 	tstrHostIFpmkidAttr pmkid_list;
 	struct WILC_WFI_stats netstats;
 	u8 WILC_WFI_wep_default;
-- 
1.8.1.2

