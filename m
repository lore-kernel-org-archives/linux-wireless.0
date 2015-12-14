Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:13642 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbbLNFnc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 00:43:32 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 02/12] staging: wilc1000: remove argument hif_drv
Date: Mon, 14 Dec 2015 14:46:53 +0900
Message-ID: <1450072023-13013-3-git-send-email-glen.lee@atmel.com> (sfid-20151214_064400_927571_6A3C2B10)
In-Reply-To: <1450072023-13013-1-git-send-email-glen.lee@atmel.com>
References: <1450072023-13013-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In previous patch we add new argument vif which has hif_drv in it's member.
Therefore, no need to pass hif_drv in those functions. Remove argument
struct host_if_drv and use hif_drv of vif.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         | 176 ++++++++---------
 drivers/staging/wilc1000/host_interface.h         | 127 +++++-------
 drivers/staging/wilc1000/linux_wlan.c             |  20 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 223 +++++++++++-----------
 4 files changed, 264 insertions(+), 282 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c52a8e1..d4bcf39 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -451,7 +451,7 @@ static s32 handle_get_ip_address(struct wilc_vif *vif,
 	kfree(wid.val);
 
 	if (memcmp(get_ip[idx], set_ip[idx], IP_ALEN) != 0)
-		wilc_setup_ipaddress(vif, hif_drv, set_ip[idx], idx);
+		wilc_setup_ipaddress(vif, set_ip[idx], idx);
 
 	if (result != 0) {
 		PRINT_ER("Failed to get IP address\n");
@@ -1626,7 +1626,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 
 			if ((u8MacStatus == MAC_CONNECTED) &&
 			    (strConnectInfo.u16ConnectStatus == SUCCESSFUL_STATUSCODE))	{
-				wilc_set_power_mgmt(vif, hif_drv, 0, 0);
+				wilc_set_power_mgmt(vif, 0, 0);
 
 				PRINT_D(HOSTINF_DBG, "MAC status : CONNECTED and Connect Status : Successful\n");
 				hif_drv->hif_state = HOST_IF_CONNECTED;
@@ -1669,7 +1669,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 
 			if (hif_drv->usr_conn_req.conn_result) {
 				wilc_optaining_ip = false;
-				wilc_set_power_mgmt(vif, hif_drv, 0, 0);
+				wilc_set_power_mgmt(vif, 0, 0);
 
 				hif_drv->usr_conn_req.conn_result(CONN_DISCONN_EVENT_DISCONN_NOTIF,
 								  NULL,
@@ -2007,7 +2007,7 @@ static void Handle_Disconnect(struct wilc_vif *vif,
 	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
 
 	wilc_optaining_ip = false;
-	wilc_set_power_mgmt(vif, hif_drv, 0, 0);
+	wilc_set_power_mgmt(vif, 0, 0);
 
 	eth_zero_addr(wilc_connected_ssid);
 
@@ -2075,15 +2075,14 @@ static void Handle_Disconnect(struct wilc_vif *vif,
 	up(&hif_drv->sem_test_disconn_block);
 }
 
-void wilc_resolve_disconnect_aberration(struct wilc_vif *vif,
-					struct host_if_drv *hif_drv)
+void wilc_resolve_disconnect_aberration(struct wilc_vif *vif)
 {
-	if (!hif_drv)
+	if (!vif->hif_drv)
 		return;
-	if ((hif_drv->hif_state == HOST_IF_WAITING_CONN_RESP) ||
-	    (hif_drv->hif_state == HOST_IF_CONNECTING)) {
+	if ((vif->hif_drv->hif_state == HOST_IF_WAITING_CONN_RESP) ||
+	    (vif->hif_drv->hif_state == HOST_IF_CONNECTING)) {
 		PRINT_D(HOSTINF_DBG, "\n\n<< correcting Supplicant state machine >>\n\n");
-		wilc_disconnect(vif, hif_drv, 1);
+		wilc_disconnect(vif, 1);
 	}
 }
 
@@ -3033,11 +3032,11 @@ s32 wilc_remove_key(struct host_if_drv *hif_drv, const u8 *pu8StaAddress)
 	return 0;
 }
 
-int wilc_remove_wep_key(struct wilc_vif *vif,
-			struct host_if_drv *hif_drv, u8 index)
+int wilc_remove_wep_key(struct wilc_vif *vif, u8 index)
 {
 	int result = 0;
 	struct host_if_msg msg;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
 		result = -EFAULT;
@@ -3062,11 +3061,11 @@ int wilc_remove_wep_key(struct wilc_vif *vif,
 	return result;
 }
 
-int wilc_set_wep_default_keyid(struct wilc_vif *vif,
-			       struct host_if_drv *hif_drv, u8 index)
+int wilc_set_wep_default_keyid(struct wilc_vif *vif, u8 index)
 {
 	int result = 0;
 	struct host_if_msg msg;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
 		result = -EFAULT;
@@ -3091,11 +3090,12 @@ int wilc_set_wep_default_keyid(struct wilc_vif *vif,
 	return result;
 }
 
-int wilc_add_wep_key_bss_sta(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-			     const u8 *key, u8 len, u8 index)
+int wilc_add_wep_key_bss_sta(struct wilc_vif *vif, const u8 *key, u8 len,
+			     u8 index)
 {
 	int result = 0;
 	struct host_if_msg msg;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
@@ -3124,12 +3124,12 @@ int wilc_add_wep_key_bss_sta(struct wilc_vif *vif, struct host_if_drv *hif_drv,
 	return result;
 }
 
-int wilc_add_wep_key_bss_ap(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-			    const u8 *key, u8 len, u8 index, u8 mode,
-			    enum AUTHTYPE auth_type)
+int wilc_add_wep_key_bss_ap(struct wilc_vif *vif, const u8 *key, u8 len,
+			    u8 index, u8 mode, enum AUTHTYPE auth_type)
 {
 	int result = 0;
 	struct host_if_msg msg;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 	int i;
 
 	if (!hif_drv) {
@@ -3166,13 +3166,13 @@ int wilc_add_wep_key_bss_ap(struct wilc_vif *vif, struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 wilc_add_ptk(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-		 const u8 *pu8Ptk, u8 u8PtkKeylen, const u8 *mac_addr,
-		 const u8 *pu8RxMic, const u8 *pu8TxMic,
+s32 wilc_add_ptk(struct wilc_vif *vif, const u8 *pu8Ptk, u8 u8PtkKeylen,
+		 const u8 *mac_addr, const u8 *pu8RxMic, const u8 *pu8TxMic,
 		 u8 mode, u8 u8Ciphermode, u8 u8Idx)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 	u8 u8KeyLen = u8PtkKeylen;
 	u32 i;
 
@@ -3232,14 +3232,14 @@ s32 wilc_add_ptk(struct wilc_vif *vif, struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 wilc_add_rx_gtk(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-		    const u8 *pu8RxGtk, u8 u8GtkKeylen, u8 u8KeyIdx,
-		    u32 u32KeyRSClen, const u8 *KeyRSC,
-		    const u8 *pu8RxMic, const u8 *pu8TxMic,
-		    u8 mode, u8 u8Ciphermode)
+s32 wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *pu8RxGtk, u8 u8GtkKeylen,
+		    u8 u8KeyIdx, u32 u32KeyRSClen, const u8 *KeyRSC,
+		    const u8 *pu8RxMic, const u8 *pu8TxMic, u8 mode,
+		    u8 u8Ciphermode)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 	u8 u8KeyLen = u8GtkKeylen;
 
 	if (!hif_drv) {
@@ -3295,11 +3295,12 @@ s32 wilc_add_rx_gtk(struct wilc_vif *vif, struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 wilc_set_pmkid_info(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+s32 wilc_set_pmkid_info(struct wilc_vif *vif,
 			struct host_if_pmkid_attr *pu8PmkidInfoArray)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 	u32 i;
 
 	if (!hif_drv) {
@@ -3329,11 +3330,11 @@ s32 wilc_set_pmkid_info(struct wilc_vif *vif, struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 wilc_get_mac_address(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-			 u8 *pu8MacAddress)
+s32 wilc_get_mac_address(struct wilc_vif *vif, u8 *pu8MacAddress)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
@@ -3352,11 +3353,11 @@ s32 wilc_get_mac_address(struct wilc_vif *vif, struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 wilc_set_mac_address(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-			 u8 *pu8MacAddress)
+s32 wilc_set_mac_address(struct wilc_vif *vif, u8 *pu8MacAddress)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	PRINT_D(GENERIC_DBG, "mac addr = %x:%x:%x\n", pu8MacAddress[0], pu8MacAddress[1], pu8MacAddress[2]);
 
@@ -3385,15 +3386,15 @@ s32 host_int_set_start_scan_req(struct host_if_drv *hif_drv, u8 scanSource)
 	return 0;
 }
 
-s32 wilc_set_join_req(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-		      u8 *pu8bssid, const u8 *pu8ssid, size_t ssidLen,
-		      const u8 *pu8IEs, size_t IEsLen,
+s32 wilc_set_join_req(struct wilc_vif *vif, u8 *pu8bssid, const u8 *pu8ssid,
+		      size_t ssidLen, const u8 *pu8IEs, size_t IEsLen,
 		      wilc_connect_result pfConnectResult, void *pvUserArg,
 		      u8 u8security, enum AUTHTYPE tenuAuth_type,
 		      u8 u8channel, void *pJoinParams)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv || !pfConnectResult) {
 		PRINT_ER("Driver is null\n");
@@ -3453,10 +3454,11 @@ s32 wilc_set_join_req(struct wilc_vif *vif, struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 wilc_flush_join_req(struct wilc_vif *vif, struct host_if_drv *hif_drv)
+s32 wilc_flush_join_req(struct wilc_vif *vif)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!join_req)
 		return -EFAULT;
@@ -3479,11 +3481,11 @@ s32 wilc_flush_join_req(struct wilc_vif *vif, struct host_if_drv *hif_drv)
 	return result;
 }
 
-s32 wilc_disconnect(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-		    u16 u16ReasonCode)
+s32 wilc_disconnect(struct wilc_vif *vif, u16 u16ReasonCode)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
 		PRINT_ER("Driver is null\n");
@@ -3536,11 +3538,11 @@ static s32 host_int_get_assoc_res_info(struct host_if_drv *hif_drv,
 	return result;
 }
 
-int wilc_set_mac_chnl_num(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-			  u8 channel)
+int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel)
 {
 	int result;
 	struct host_if_msg msg;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
@@ -3600,11 +3602,11 @@ int wilc_set_wfi_drv_handler(struct wilc_vif *vif, struct host_if_drv *hif_drv)
 	return result;
 }
 
-int wilc_set_operation_mode(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-			    u32 mode)
+int wilc_set_operation_mode(struct wilc_vif *vif, u32 mode)
 {
 	int result = 0;
 	struct host_if_msg msg;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_OPERATION_MODE;
@@ -3621,11 +3623,12 @@ int wilc_set_operation_mode(struct wilc_vif *vif, struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 wilc_get_inactive_time(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-			       const u8 *mac, u32 *pu32InactiveTime)
+s32 wilc_get_inactive_time(struct wilc_vif *vif, const u8 *mac,
+			   u32 *pu32InactiveTime)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
@@ -3650,11 +3653,11 @@ s32 wilc_get_inactive_time(struct wilc_vif *vif, struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 wilc_get_rssi(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-		  s8 *ps8Rssi)
+s32 wilc_get_rssi(struct wilc_vif *vif, s8 *ps8Rssi)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_GET_RSSI;
@@ -3679,11 +3682,11 @@ s32 wilc_get_rssi(struct wilc_vif *vif, struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 wilc_get_statistics(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-			struct rf_info *pstrStatistics)
+s32 wilc_get_statistics(struct wilc_vif *vif, struct rf_info *pstrStatistics)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_GET_STATISTICS;
@@ -3701,14 +3704,14 @@ s32 wilc_get_statistics(struct wilc_vif *vif, struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 wilc_scan(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-	      u8 u8ScanSource, u8 u8ScanType, u8 *pu8ChnlFreqList,
-	      u8 u8ChnlListLen, const u8 *pu8IEs,
-	      size_t IEsLen, wilc_scan_result ScanResult,
-	      void *pvUserArg, struct hidden_network *pstrHiddenNetwork)
+s32 wilc_scan(struct wilc_vif *vif, u8 u8ScanSource, u8 u8ScanType,
+	      u8 *pu8ChnlFreqList, u8 u8ChnlListLen, const u8 *pu8IEs,
+	      size_t IEsLen, wilc_scan_result ScanResult, void *pvUserArg,
+	      struct hidden_network *pstrHiddenNetwork)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv || !ScanResult) {
 		PRINT_ER("hif_drv or ScanResult = NULL\n");
@@ -3755,11 +3758,12 @@ s32 wilc_scan(struct wilc_vif *vif, struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 wilc_hif_set_cfg(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-		struct cfg_param_val *pstrCfgParamVal)
+s32 wilc_hif_set_cfg(struct wilc_vif *vif,
+		     struct cfg_param_val *pstrCfgParamVal)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
 		PRINT_ER("hif_drv NULL\n");
@@ -3913,10 +3917,11 @@ _fail_:
 	return result;
 }
 
-s32 wilc_deinit(struct wilc_vif *vif, struct host_if_drv *hif_drv)
+s32 wilc_deinit(struct wilc_vif *vif)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 	int ret;
 
 	if (!hif_drv)	{
@@ -4083,14 +4088,15 @@ void wilc_scan_complete_received(u8 *pu8Buffer, u32 u32Length)
 	return;
 }
 
-s32 wilc_remain_on_channel(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-			   u32 u32SessionID, u32 u32duration, u16 chan,
+s32 wilc_remain_on_channel(struct wilc_vif *vif, u32 u32SessionID,
+			   u32 u32duration, u16 chan,
 			   wilc_remain_on_chan_expired RemainOnChanExpired,
 			   wilc_remain_on_chan_ready RemainOnChanReady,
 			   void *pvUserArg)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
@@ -4116,11 +4122,11 @@ s32 wilc_remain_on_channel(struct wilc_vif *vif, struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 wilc_listen_state_expired(struct wilc_vif *vif,
-			      struct host_if_drv *hif_drv, u32 u32SessionID)
+s32 wilc_listen_state_expired(struct wilc_vif *vif, u32 u32SessionID)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
@@ -4142,11 +4148,11 @@ s32 wilc_listen_state_expired(struct wilc_vif *vif,
 	return result;
 }
 
-s32 wilc_frame_register(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-			u16 u16FrameType, bool bReg)
+s32 wilc_frame_register(struct wilc_vif *vif, u16 u16FrameType, bool bReg)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
@@ -4183,14 +4189,13 @@ s32 wilc_frame_register(struct wilc_vif *vif, struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 wilc_add_beacon(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-		    u32 u32Interval,
-		    u32 u32DTIMPeriod, u32 u32HeadLen, u8 *pu8Head,
-		    u32 u32TailLen, u8 *pu8Tail)
+s32 wilc_add_beacon(struct wilc_vif *vif, u32 u32Interval, u32 u32DTIMPeriod,
+		    u32 u32HeadLen, u8 *pu8Head, u32 u32TailLen, u8 *pu8Tail)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
 	struct beacon_attr *pstrSetBeaconParam = &msg.body.beacon_info;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
@@ -4239,10 +4244,11 @@ ERRORHANDLER:
 	return result;
 }
 
-int wilc_del_beacon(struct wilc_vif *vif, struct host_if_drv *hif_drv)
+int wilc_del_beacon(struct wilc_vif *vif)
 {
 	int result = 0;
 	struct host_if_msg msg;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
@@ -4261,12 +4267,12 @@ int wilc_del_beacon(struct wilc_vif *vif, struct host_if_drv *hif_drv)
 	return result;
 }
 
-int wilc_add_station(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-		     struct add_sta_param *sta_param)
+int wilc_add_station(struct wilc_vif *vif, struct add_sta_param *sta_param)
 {
 	int result = 0;
 	struct host_if_msg msg;
 	struct add_sta_param *add_sta_info = &msg.body.add_sta_info;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
@@ -4296,12 +4302,12 @@ int wilc_add_station(struct wilc_vif *vif, struct host_if_drv *hif_drv,
 	return result;
 }
 
-int wilc_del_station(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-		     const u8 *mac_addr)
+int wilc_del_station(struct wilc_vif *vif, const u8 *mac_addr)
 {
 	int result = 0;
 	struct host_if_msg msg;
 	struct del_sta *del_sta_info = &msg.body.del_sta_info;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
@@ -4327,12 +4333,12 @@ int wilc_del_station(struct wilc_vif *vif, struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 wilc_del_allstation(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-			    u8 pu8MacAddr[][ETH_ALEN])
+s32 wilc_del_allstation(struct wilc_vif *vif, u8 pu8MacAddr[][ETH_ALEN])
 {
 	s32 result = 0;
 	struct host_if_msg msg;
 	struct del_all_sta *pstrDelAllStationMsg = &msg.body.del_all_sta_info;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 	u8 au8Zero_Buff[ETH_ALEN] = {0};
 	u32 i;
 	u8 u8AssocNumb = 0;
@@ -4379,12 +4385,13 @@ s32 wilc_del_allstation(struct wilc_vif *vif, struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 wilc_edit_station(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-			  struct add_sta_param *pstrStaParams)
+s32 wilc_edit_station(struct wilc_vif *vif,
+		      struct add_sta_param *pstrStaParams)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
 	struct add_sta_param *pstrAddStationMsg = &msg.body.add_sta_info;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
@@ -4418,12 +4425,12 @@ s32 wilc_edit_station(struct wilc_vif *vif, struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 wilc_set_power_mgmt(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-			    bool bIsEnabled, u32 u32Timeout)
+s32 wilc_set_power_mgmt(struct wilc_vif *vif, bool bIsEnabled, u32 u32Timeout)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
 	struct power_mgmt_param *pstrPowerMgmtParam = &msg.body.pwr_mgmt_info;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	PRINT_INFO(HOSTINF_DBG, "\n\n>> Setting PS to %d <<\n\n", bIsEnabled);
 
@@ -4449,14 +4456,13 @@ s32 wilc_set_power_mgmt(struct wilc_vif *vif, struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 wilc_setup_multicast_filter(struct wilc_vif *vif,
-				struct host_if_drv *hif_drv,
-				bool bIsEnabled,
+s32 wilc_setup_multicast_filter(struct wilc_vif *vif, bool bIsEnabled,
 				u32 u32count)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
 	struct set_multicast *pstrMulticastFilterParam = &msg.body.multicast_info;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
@@ -4645,14 +4651,12 @@ void wilc_free_join_params(void *pJoinParams)
 		PRINT_ER("Unable to FREE null pointer\n");
 }
 
-s32 wilc_del_all_rx_ba_session(struct wilc_vif *vif,
-			       struct host_if_drv *hif_drv,
-			       char *pBSSID,
-			       char TID)
+s32 wilc_del_all_rx_ba_session(struct wilc_vif *vif, char *pBSSID, char TID)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
 	struct ba_session_info *pBASessionInfo = &msg.body.session_info;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
@@ -4677,11 +4681,11 @@ s32 wilc_del_all_rx_ba_session(struct wilc_vif *vif,
 	return result;
 }
 
-s32 wilc_setup_ipaddress(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-			 u8 *u16ipadd, u8 idx)
+s32 wilc_setup_ipaddress(struct wilc_vif *vif, u8 *u16ipadd, u8 idx)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	return 0;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index ccbbe73..9716bc8 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -307,102 +307,73 @@ struct add_sta_param {
 
 struct wilc_vif;
 s32 wilc_remove_key(struct host_if_drv *hWFIDrv, const u8 *pu8StaAddress);
-int wilc_remove_wep_key(struct wilc_vif *vif,
-			struct host_if_drv *hif_drv, u8 index);
-int wilc_set_wep_default_keyid(struct wilc_vif *vif,
-			       struct host_if_drv *hif_drv, u8 index);
-int wilc_add_wep_key_bss_sta(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-			     const u8 *key, u8 len, u8 index);
-int wilc_add_wep_key_bss_ap(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-			    const u8 *key, u8 len, u8 index, u8 mode,
-			    enum AUTHTYPE auth_type);
-s32 wilc_add_ptk(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-		 const u8 *pu8Ptk, u8 u8PtkKeylen, const u8 *mac_addr,
-		 const u8 *pu8RxMic, const u8 *pu8TxMic,
+int wilc_remove_wep_key(struct wilc_vif *vif, u8 index);
+int wilc_set_wep_default_keyid(struct wilc_vif *vif, u8 index);
+int wilc_add_wep_key_bss_sta(struct wilc_vif *vif, const u8 *key, u8 len,
+			     u8 index);
+int wilc_add_wep_key_bss_ap(struct wilc_vif *vif, const u8 *key, u8 len,
+			    u8 index, u8 mode, enum AUTHTYPE auth_type);
+s32 wilc_add_ptk(struct wilc_vif *vif, const u8 *pu8Ptk, u8 u8PtkKeylen,
+		 const u8 *mac_addr, const u8 *pu8RxMic, const u8 *pu8TxMic,
 		 u8 mode, u8 u8Ciphermode, u8 u8Idx);
-s32 wilc_get_inactive_time(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-			       const u8 *mac, u32 *pu32InactiveTime);
-s32 wilc_add_rx_gtk(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-		    const u8 *pu8RxGtk, u8 u8GtkKeylen, u8 u8KeyIdx,
-		    u32 u32KeyRSClen, const u8 *KeyRSC,
-		    const u8 *pu8RxMic, const u8 *pu8TxMic,
-		    u8 mode, u8 u8Ciphermode);
+s32 wilc_get_inactive_time(struct wilc_vif *vif, const u8 *mac,
+			   u32 *pu32InactiveTime);
+s32 wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *pu8RxGtk, u8 u8GtkKeylen,
+		    u8 u8KeyIdx, u32 u32KeyRSClen, const u8 *KeyRSC,
+		    const u8 *pu8RxMic, const u8 *pu8TxMic, u8 mode,
+		    u8 u8Ciphermode);
 s32 wilc_add_tx_gtk(struct host_if_drv *hWFIDrv, u8 u8KeyLen,
 			u8 *pu8TxGtk, u8 u8KeyIdx);
-s32 wilc_set_pmkid_info(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+s32 wilc_set_pmkid_info(struct wilc_vif *vif,
 			struct host_if_pmkid_attr *pu8PmkidInfoArray);
-s32 wilc_get_mac_address(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-			 u8 *pu8MacAddress);
-s32 wilc_set_mac_address(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-			 u8 *pu8MacAddress);
+s32 wilc_get_mac_address(struct wilc_vif *vif, u8 *pu8MacAddress);
+s32 wilc_set_mac_address(struct wilc_vif *vif, u8 *pu8MacAddress);
 int wilc_wait_msg_queue_idle(void);
 s32 wilc_set_start_scan_req(struct host_if_drv *hWFIDrv, u8 scanSource);
-s32 wilc_set_join_req(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-		      u8 *pu8bssid, const u8 *pu8ssid, size_t ssidLen,
-		      const u8 *pu8IEs, size_t IEsLen,
+s32 wilc_set_join_req(struct wilc_vif *vif, u8 *pu8bssid, const u8 *pu8ssid,
+		      size_t ssidLen, const u8 *pu8IEs, size_t IEsLen,
 		      wilc_connect_result pfConnectResult, void *pvUserArg,
 		      u8 u8security, enum AUTHTYPE tenuAuth_type,
 		      u8 u8channel, void *pJoinParams);
-s32 wilc_flush_join_req(struct wilc_vif *vif, struct host_if_drv *hif_drv);
-s32 wilc_disconnect(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-		    u16 u16ReasonCode);
-int wilc_set_mac_chnl_num(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-			  u8 channel);
-s32 wilc_get_rssi(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-		  s8 *ps8Rssi);
-s32 wilc_scan(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-	      u8 u8ScanSource, u8 u8ScanType, u8 *pu8ChnlFreqList,
-	      u8 u8ChnlListLen, const u8 *pu8IEs,
-	      size_t IEsLen, wilc_scan_result ScanResult,
-	      void *pvUserArg, struct hidden_network *pstrHiddenNetwork);
-s32 wilc_hif_set_cfg(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-		struct cfg_param_val *pstrCfgParamVal);
+s32 wilc_flush_join_req(struct wilc_vif *vif);
+s32 wilc_disconnect(struct wilc_vif *vif, u16 u16ReasonCode);
+int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel);
+s32 wilc_get_rssi(struct wilc_vif *vif, s8 *ps8Rssi);
+s32 wilc_scan(struct wilc_vif *vif, u8 u8ScanSource, u8 u8ScanType,
+	      u8 *pu8ChnlFreqList, u8 u8ChnlListLen, const u8 *pu8IEs,
+	      size_t IEsLen, wilc_scan_result ScanResult, void *pvUserArg,
+	      struct hidden_network *pstrHiddenNetwork);
+s32 wilc_hif_set_cfg(struct wilc_vif *vif,
+		     struct cfg_param_val *pstrCfgParamVal);
 s32 wilc_init(struct net_device *dev, struct host_if_drv **phWFIDrv);
-s32 wilc_deinit(struct wilc_vif *vif, struct host_if_drv *hif_drv);
-s32 wilc_add_beacon(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-		    u32 u32Interval,
-		    u32 u32DTIMPeriod, u32 u32HeadLen, u8 *pu8Head,
-		    u32 u32TailLen, u8 *pu8Tail);
-int wilc_del_beacon(struct wilc_vif *vif, struct host_if_drv *hif_drv);
-int wilc_add_station(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-		     struct add_sta_param *sta_param);
-s32 wilc_del_allstation(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-			    u8 pu8MacAddr[][ETH_ALEN]);
-int wilc_del_station(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-		     const u8 *mac_addr);
-s32 wilc_edit_station(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-			  struct add_sta_param *pstrStaParams);
-s32 wilc_set_power_mgmt(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-			    bool bIsEnabled, u32 u32Timeout);
-s32 wilc_setup_multicast_filter(struct wilc_vif *vif,
-				struct host_if_drv *hif_drv,
-				bool bIsEnabled,
+s32 wilc_deinit(struct wilc_vif *vif);
+s32 wilc_add_beacon(struct wilc_vif *vif, u32 u32Interval, u32 u32DTIMPeriod,
+		    u32 u32HeadLen, u8 *pu8Head, u32 u32TailLen, u8 *pu8Tail);
+int wilc_del_beacon(struct wilc_vif *vif);
+int wilc_add_station(struct wilc_vif *vif, struct add_sta_param *sta_param);
+s32 wilc_del_allstation(struct wilc_vif *vif, u8 pu8MacAddr[][ETH_ALEN]);
+int wilc_del_station(struct wilc_vif *vif, const u8 *mac_addr);
+s32 wilc_edit_station(struct wilc_vif *vif,
+		      struct add_sta_param *pstrStaParams);
+s32 wilc_set_power_mgmt(struct wilc_vif *vif, bool bIsEnabled, u32 u32Timeout);
+s32 wilc_setup_multicast_filter(struct wilc_vif *vif, bool bIsEnabled,
 				u32 u32count);
-s32 wilc_setup_ipaddress(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-			 u8 *u16ipadd, u8 idx);
-s32 wilc_del_all_rx_ba_session(struct wilc_vif *vif,
-			       struct host_if_drv *hif_drv,
-			       char *pBSSID,
-			       char TID);
-s32 wilc_remain_on_channel(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-			   u32 u32SessionID, u32 u32duration, u16 chan,
+s32 wilc_setup_ipaddress(struct wilc_vif *vif, u8 *u16ipadd, u8 idx);
+s32 wilc_del_all_rx_ba_session(struct wilc_vif *vif, char *pBSSID, char TID);
+s32 wilc_remain_on_channel(struct wilc_vif *vif, u32 u32SessionID,
+			   u32 u32duration, u16 chan,
 			   wilc_remain_on_chan_expired RemainOnChanExpired,
 			   wilc_remain_on_chan_ready RemainOnChanReady,
 			   void *pvUserArg);
-s32 wilc_listen_state_expired(struct wilc_vif *vif,
-			      struct host_if_drv *hif_drv, u32 u32SessionID);
-s32 wilc_frame_register(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-			u16 u16FrameType, bool bReg);
+s32 wilc_listen_state_expired(struct wilc_vif *vif, u32 u32SessionID);
+s32 wilc_frame_register(struct wilc_vif *vif, u16 u16FrameType, bool bReg);
 int wilc_set_wfi_drv_handler(struct wilc_vif *vif, struct host_if_drv *hif_drv);
-int wilc_set_operation_mode(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-			    u32 mode);
+int wilc_set_operation_mode(struct wilc_vif *vif, u32 mode);
 
 void wilc_free_join_params(void *pJoinParams);
 
-s32 wilc_get_statistics(struct wilc_vif *vif, struct host_if_drv *hif_drv,
-			struct rf_info *pstrStatistics);
-void wilc_resolve_disconnect_aberration(struct wilc_vif *vif,
-					struct host_if_drv *hif_drv);
+s32 wilc_get_statistics(struct wilc_vif *vif, struct rf_info *pstrStatistics);
+void wilc_resolve_disconnect_aberration(struct wilc_vif *vif);
 
 extern bool wilc_optaining_ip;
 extern u8 wilc_connected_ssid[6];
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 6074996..a50e3ff 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -112,7 +112,7 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 		}
 
 		if (wilc_enable_ps)
-			wilc_set_power_mgmt(vif, hif_drv, 1, 0);
+			wilc_set_power_mgmt(vif, 1, 0);
 
 		PRINT_D(GENERIC_DBG, "[%s] Up IP\n", dev_iface->ifa_label);
 
@@ -120,7 +120,7 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 		PRINT_D(GENERIC_DBG, "IP add=%d:%d:%d:%d\n",
 			ip_addr_buf[0], ip_addr_buf[1],
 			ip_addr_buf[2], ip_addr_buf[3]);
-		wilc_setup_ipaddress(vif, hif_drv, ip_addr_buf, vif->u8IfIdx);
+		wilc_setup_ipaddress(vif, ip_addr_buf, vif->u8IfIdx);
 
 		break;
 
@@ -134,9 +134,9 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 		}
 
 		if (memcmp(dev_iface->ifa_label, wlan_dev_name, 5) == 0)
-			wilc_set_power_mgmt(vif, hif_drv, 0, 0);
+			wilc_set_power_mgmt(vif, 0, 0);
 
-		wilc_resolve_disconnect_aberration(vif, hif_drv);
+		wilc_resolve_disconnect_aberration(vif);
 
 		PRINT_D(GENERIC_DBG, "[%s] Down IP\n", dev_iface->ifa_label);
 
@@ -145,7 +145,7 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 			ip_addr_buf[0], ip_addr_buf[1],
 			ip_addr_buf[2], ip_addr_buf[3]);
 
-		wilc_setup_ipaddress(vif, hif_drv, ip_addr_buf, vif->u8IfIdx);
+		wilc_setup_ipaddress(vif, ip_addr_buf, vif->u8IfIdx);
 
 		break;
 
@@ -1030,7 +1030,7 @@ int wilc_mac_open(struct net_device *ndev)
 
 	wilc_set_machw_change_vir_if(ndev, false);
 
-	wilc_get_mac_address(vif, priv->hWILCWFIDrv, mac_add);
+	wilc_get_mac_address(vif, mac_add);
 	PRINT_D(INIT_DBG, "Mac address: %pM\n", mac_add);
 
 	for (i = 0; i < wl->vif_num; i++) {
@@ -1097,13 +1097,13 @@ static void wilc_set_multicast_list(struct net_device *dev)
 	if ((dev->flags & IFF_ALLMULTI) ||
 	    (dev->mc.count) > WILC_MULTICAST_TABLE_SIZE) {
 		PRINT_D(INIT_DBG, "Disable multicast filter, retrive all multicast packets\n");
-		wilc_setup_multicast_filter(vif, hif_drv, false, 0);
+		wilc_setup_multicast_filter(vif, false, 0);
 		return;
 	}
 
 	if ((dev->mc.count) == 0) {
 		PRINT_D(INIT_DBG, "Enable multicast filter, retrive directed packets only.\n");
-		wilc_setup_multicast_filter(vif, hif_drv, true, 0);
+		wilc_setup_multicast_filter(vif, true, 0);
 		return;
 	}
 
@@ -1119,7 +1119,7 @@ static void wilc_set_multicast_list(struct net_device *dev)
 		i++;
 	}
 
-	wilc_setup_multicast_filter(vif, hif_drv, true, (dev->mc.count));
+	wilc_setup_multicast_filter(vif, true, (dev->mc.count));
 
 	return;
 }
@@ -1291,7 +1291,7 @@ static int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 
 			if (strncasecmp(buff, "RSSI", length) == 0) {
 				priv = wiphy_priv(vif->ndev->ieee80211_ptr->wiphy);
-				ret = wilc_get_rssi(vif, priv->hWILCWFIDrv, &rssi);
+				ret = wilc_get_rssi(vif, &rssi);
 				if (ret)
 					PRINT_ER("Failed to send get rssi param's message queue ");
 				PRINT_INFO(GENERIC_DBG, "RSSI :%d\n", rssi);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 309a0cc..da4c4ad 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -604,7 +604,7 @@ static int set_channel(struct wiphy *wiphy,
 	PRINT_D(CFG80211_DBG, "Setting channel %d with frequency %d\n", channelnum, chandef->chan->center_freq);
 
 	curr_channel = channelnum;
-	result = wilc_set_mac_chnl_num(vif, priv->hWILCWFIDrv, channelnum);
+	result = wilc_set_mac_chnl_num(vif, channelnum);
 
 	if (result != 0)
 		PRINT_ER("Error in setting channel %d\n", channelnum);
@@ -660,16 +660,20 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 				}
 			}
 			PRINT_D(CFG80211_DBG, "Trigger Scan Request\n");
-			s32Error = wilc_scan(vif, priv->hWILCWFIDrv, USER_SCAN, ACTIVE_SCAN,
-						 au8ScanChanList, request->n_channels,
-						 (const u8 *)request->ie, request->ie_len,
-						 CfgScanResult, (void *)priv, &strHiddenNetwork);
+			s32Error = wilc_scan(vif, USER_SCAN, ACTIVE_SCAN,
+					     au8ScanChanList,
+					     request->n_channels,
+					     (const u8 *)request->ie,
+					     request->ie_len, CfgScanResult,
+					     (void *)priv, &strHiddenNetwork);
 		} else {
 			PRINT_D(CFG80211_DBG, "Trigger Scan Request\n");
-			s32Error = wilc_scan(vif, priv->hWILCWFIDrv, USER_SCAN, ACTIVE_SCAN,
-						 au8ScanChanList, request->n_channels,
-						 (const u8 *)request->ie, request->ie_len,
-						 CfgScanResult, (void *)priv, NULL);
+			s32Error = wilc_scan(vif, USER_SCAN, ACTIVE_SCAN,
+					     au8ScanChanList,
+					     request->n_channels,
+					     (const u8 *)request->ie,
+					     request->ie_len, CfgScanResult,
+					     (void *)priv, NULL);
 		}
 	} else {
 		PRINT_ER("Requested num of scanned channels is greater than the max, supported"
@@ -792,8 +796,9 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 			g_key_wep_params.key_idx = sme->key_idx;
 			g_wep_keys_saved = true;
 
-			wilc_set_wep_default_keyid(vif, priv->hWILCWFIDrv, sme->key_idx);
-			wilc_add_wep_key_bss_sta(vif, priv->hWILCWFIDrv, sme->key, sme->key_len, sme->key_idx);
+			wilc_set_wep_default_keyid(vif, sme->key_idx);
+			wilc_add_wep_key_bss_sta(vif, sme->key, sme->key_len,
+						 sme->key_idx);
 		} else if (sme->crypto.cipher_group == WLAN_CIPHER_SUITE_WEP104)   {
 			u8security = ENCRYPT_ENABLED | WEP | WEP_EXTENDED;
 			pcgroup_encrypt_val = "WEP104";
@@ -809,8 +814,9 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 			g_key_wep_params.key_idx = sme->key_idx;
 			g_wep_keys_saved = true;
 
-			wilc_set_wep_default_keyid(vif, priv->hWILCWFIDrv, sme->key_idx);
-			wilc_add_wep_key_bss_sta(vif, priv->hWILCWFIDrv, sme->key, sme->key_len, sme->key_idx);
+			wilc_set_wep_default_keyid(vif, sme->key_idx);
+			wilc_add_wep_key_bss_sta(vif, sme->key, sme->key_len,
+						 sme->key_idx);
 		} else if (sme->crypto.wpa_versions & NL80211_WPA_VERSION_2)   {
 			if (sme->crypto.cipher_group == WLAN_CIPHER_SUITE_TKIP)	{
 				u8security = ENCRYPT_ENABLED | WPA2 | TKIP;
@@ -895,11 +901,12 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 
 	wilc_wlan_set_bssid(dev, pstrNetworkInfo->au8bssid);
 
-	s32Error = wilc_set_join_req(vif, priv->hWILCWFIDrv, pstrNetworkInfo->au8bssid, sme->ssid,
-					 sme->ssid_len, sme->ie, sme->ie_len,
-					 CfgConnectResult, (void *)priv, u8security,
-					 tenuAuth_type, pstrNetworkInfo->u8channel,
-					 pstrNetworkInfo->pJoinParams);
+	s32Error = wilc_set_join_req(vif, pstrNetworkInfo->au8bssid, sme->ssid,
+				     sme->ssid_len, sme->ie, sme->ie_len,
+				     CfgConnectResult, (void *)priv,
+				     u8security, tenuAuth_type,
+				     pstrNetworkInfo->u8channel,
+				     pstrNetworkInfo->pJoinParams);
 	if (s32Error != 0) {
 		PRINT_ER("wilc_set_join_req(): Error(%d)\n", s32Error);
 		s32Error = -ENOENT;
@@ -935,7 +942,7 @@ static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_co
 	wilc_ie = false;
 	pstrWFIDrv->p2p_timeout = 0;
 
-	s32Error = wilc_disconnect(vif, priv->hWILCWFIDrv, reason_code);
+	s32Error = wilc_disconnect(vif, reason_code);
 	if (s32Error != 0) {
 		PRINT_ER("Error in disconnecting: Error(%d)\n", s32Error);
 		s32Error = -EINVAL;
@@ -995,7 +1002,9 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 			else
 				u8mode = ENCRYPT_ENABLED | WEP | WEP_EXTENDED;
 
-			wilc_add_wep_key_bss_ap(vif, priv->hWILCWFIDrv, params->key, params->key_len, key_index, u8mode, tenuAuth_type);
+			wilc_add_wep_key_bss_ap(vif, params->key,
+						params->key_len, key_index,
+						u8mode, tenuAuth_type);
 			break;
 		}
 		if (memcmp(params->key, priv->WILC_WFI_wep_key[key_index], params->key_len)) {
@@ -1009,7 +1018,8 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 				for (i = 0; i < params->key_len; i++)
 					PRINT_INFO(CFG80211_DBG, "WEP key value[%d] = %d\n", i, params->key[i]);
 			}
-			wilc_add_wep_key_bss_sta(vif, priv->hWILCWFIDrv, params->key, params->key_len, key_index);
+			wilc_add_wep_key_bss_sta(vif, params->key,
+						 params->key_len, key_index);
 		}
 
 		break;
@@ -1066,8 +1076,10 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 				}
 
 
-				wilc_add_rx_gtk(vif, priv->hWILCWFIDrv, params->key, KeyLen,
-						    key_index, params->seq_len, params->seq, pu8RxMic, pu8TxMic, AP_MODE, u8gmode);
+				wilc_add_rx_gtk(vif, params->key, KeyLen,
+						key_index, params->seq_len,
+						params->seq, pu8RxMic,
+						pu8TxMic, AP_MODE, u8gmode);
 
 			} else {
 				PRINT_INFO(CFG80211_DBG, "STA Address: %x%x%x%x%x\n", mac_addr[0], mac_addr[1], mac_addr[2], mac_addr[3], mac_addr[4]);
@@ -1110,8 +1122,9 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 				priv->wilc_ptk[key_index]->key_len = params->key_len;
 				priv->wilc_ptk[key_index]->seq_len = params->seq_len;
 
-				wilc_add_ptk(vif, priv->hWILCWFIDrv, params->key, KeyLen, mac_addr,
-						 pu8RxMic, pu8TxMic, AP_MODE, u8pmode, key_index);
+				wilc_add_ptk(vif, params->key, KeyLen,
+					     mac_addr, pu8RxMic, pu8TxMic,
+					     AP_MODE, u8pmode, key_index);
 			}
 			break;
 		}
@@ -1150,8 +1163,11 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 					g_gtk_keys_saved = true;
 				}
 
-				wilc_add_rx_gtk(vif, priv->hWILCWFIDrv, params->key, KeyLen,
-						    key_index, params->seq_len, params->seq, pu8RxMic, pu8TxMic, STATION_MODE, u8mode);
+				wilc_add_rx_gtk(vif, params->key, KeyLen,
+						key_index, params->seq_len,
+						params->seq, pu8RxMic,
+						pu8TxMic, STATION_MODE,
+						u8mode);
 			} else {
 				if (params->key_len > 16 && params->cipher == WLAN_CIPHER_SUITE_TKIP) {
 					pu8RxMic = params->key + 24;
@@ -1184,8 +1200,9 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 					g_ptk_keys_saved = true;
 				}
 
-				wilc_add_ptk(vif, priv->hWILCWFIDrv, params->key, KeyLen, mac_addr,
-						 pu8RxMic, pu8TxMic, STATION_MODE, u8mode, key_index);
+				wilc_add_ptk(vif, params->key, KeyLen,
+					     mac_addr, pu8RxMic, pu8TxMic,
+					     STATION_MODE, u8mode, key_index);
 				PRINT_D(CFG80211_DBG, "Adding pairwise key\n");
 				if (INFO) {
 					for (i = 0; i < params->key_len; i++)
@@ -1261,7 +1278,7 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 		priv->WILC_WFI_wep_key_len[key_index] = 0;
 
 		PRINT_D(CFG80211_DBG, "Removing WEP key with index = %d\n", key_index);
-		wilc_remove_wep_key(vif, priv->hWILCWFIDrv, key_index);
+		wilc_remove_wep_key(vif, key_index);
 	} else {
 		PRINT_D(CFG80211_DBG, "Removing all installed keys\n");
 		wilc_remove_key(priv->hWILCWFIDrv, mac_addr);
@@ -1320,7 +1337,7 @@ static int set_default_key(struct wiphy *wiphy, struct net_device *netdev, u8 ke
 	PRINT_D(CFG80211_DBG, "Setting default key with idx = %d\n", key_index);
 
 	if (key_index != priv->WILC_WFI_wep_default) {
-		wilc_set_wep_default_keyid(vif, priv->hWILCWFIDrv, key_index);
+		wilc_set_wep_default_keyid(vif, key_index);
 	}
 
 	return 0;
@@ -1356,7 +1373,7 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 
 		sinfo->filled |= BIT(NL80211_STA_INFO_INACTIVE_TIME);
 
-		wilc_get_inactive_time(vif, priv->hWILCWFIDrv, mac, &(inactive_time));
+		wilc_get_inactive_time(vif, mac, &inactive_time);
 		sinfo->inactive_time = 1000 * inactive_time;
 		PRINT_D(CFG80211_DBG, "Inactive time %d\n", sinfo->inactive_time);
 	}
@@ -1364,7 +1381,7 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 	if (vif->iftype == STATION_MODE) {
 		struct rf_info strStatistics;
 
-		wilc_get_statistics(vif, priv->hWILCWFIDrv, &strStatistics);
+		wilc_get_statistics(vif, &strStatistics);
 
 		sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL) |
 						BIT(NL80211_STA_INFO_RX_PACKETS) |
@@ -1435,7 +1452,7 @@ static int set_wiphy_params(struct wiphy *wiphy, u32 changed)
 	}
 
 	PRINT_D(CFG80211_DBG, "Setting CFG params in the host interface\n");
-	s32Error = wilc_hif_set_cfg(vif, priv->hWILCWFIDrv, &pstrCfgParamVal);
+	s32Error = wilc_hif_set_cfg(vif, &pstrCfgParamVal);
 	if (s32Error)
 		PRINT_ER("Error in setting WIPHY PARAMS\n");
 
@@ -1479,7 +1496,7 @@ static int set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 
 	if (!s32Error) {
 		PRINT_D(CFG80211_DBG, "Setting pmkid in the host interface\n");
-		s32Error = wilc_set_pmkid_info(vif, priv->hWILCWFIDrv, &priv->pmkid_list);
+		s32Error = wilc_set_pmkid_info(vif, &priv->pmkid_list);
 	}
 	return s32Error;
 }
@@ -1789,13 +1806,11 @@ static int remain_on_channel(struct wiphy *wiphy,
 	priv->strRemainOnChanParams.u32ListenDuration = duration;
 	priv->strRemainOnChanParams.u32ListenSessionID++;
 
-	s32Error = wilc_remain_on_channel(vif, priv->hWILCWFIDrv
-					      , priv->strRemainOnChanParams.u32ListenSessionID
-					      , duration
-					      , chan->hw_value
-					      , WILC_WFI_RemainOnChannelExpired
-					      , WILC_WFI_RemainOnChannelReady
-					      , (void *)priv);
+	s32Error = wilc_remain_on_channel(vif,
+				priv->strRemainOnChanParams.u32ListenSessionID,
+				duration, chan->hw_value,
+				WILC_WFI_RemainOnChannelExpired,
+				WILC_WFI_RemainOnChannelReady, (void *)priv);
 
 	return s32Error;
 }
@@ -1813,7 +1828,7 @@ static int cancel_remain_on_channel(struct wiphy *wiphy,
 
 	PRINT_D(CFG80211_DBG, "Cancel remain on channel\n");
 
-	s32Error = wilc_listen_state_expired(vif, priv->hWILCWFIDrv, priv->strRemainOnChanParams.u32ListenSessionID);
+	s32Error = wilc_listen_state_expired(vif, priv->strRemainOnChanParams.u32ListenSessionID);
 	return s32Error;
 }
 
@@ -1861,7 +1876,7 @@ static int mgmt_tx(struct wiphy *wiphy,
 		if (ieee80211_is_probe_resp(mgmt->frame_control)) {
 			PRINT_D(GENERIC_DBG, "TX: Probe Response\n");
 			PRINT_D(GENERIC_DBG, "Setting channel: %d\n", chan->hw_value);
-			wilc_set_mac_chnl_num(vif, priv->hWILCWFIDrv, chan->hw_value);
+			wilc_set_mac_chnl_num(vif, chan->hw_value);
 			curr_channel = chan->hw_value;
 		} else if (ieee80211_is_action(mgmt->frame_control))   {
 			PRINT_D(GENERIC_DBG, "ACTION FRAME:%x\n", (u16)mgmt->frame_control);
@@ -1871,7 +1886,8 @@ static int mgmt_tx(struct wiphy *wiphy,
 				if (buf[ACTION_SUBTYPE_ID] != PUBLIC_ACT_VENDORSPEC ||
 				    buf[P2P_PUB_ACTION_SUBTYPE] != GO_NEG_CONF)	{
 					PRINT_D(GENERIC_DBG, "Setting channel: %d\n", chan->hw_value);
-					wilc_set_mac_chnl_num(vif, priv->hWILCWFIDrv, chan->hw_value);
+					wilc_set_mac_chnl_num(vif,
+							      chan->hw_value);
 					curr_channel = chan->hw_value;
 				}
 				switch (buf[ACTION_SUBTYPE_ID])	{
@@ -2017,7 +2033,7 @@ void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
 		PRINT_D(GENERIC_DBG, "Return since mac is closed\n");
 		return;
 	}
-	wilc_frame_register(vif, priv->hWILCWFIDrv, frame_type, reg);
+	wilc_frame_register(vif, frame_type, reg);
 }
 
 static int set_cqm_rssi_config(struct wiphy *wiphy, struct net_device *dev,
@@ -2043,7 +2059,7 @@ static int dump_station(struct wiphy *wiphy, struct net_device *dev,
 
 	sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
 
-	wilc_get_rssi(vif, priv->hWILCWFIDrv, &(sinfo->signal));
+	wilc_get_rssi(vif, &sinfo->signal);
 
 	return 0;
 }
@@ -2067,7 +2083,7 @@ static int set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	if (wilc_enable_ps)
-		wilc_set_power_mgmt(vif, priv->hWILCWFIDrv, enabled, timeout);
+		wilc_set_power_mgmt(vif, enabled, timeout);
 
 
 	return 0;
@@ -2115,8 +2131,8 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		vif->iftype = STATION_MODE;
 
 		if (wl->initialized) {
-			wilc_del_all_rx_ba_session(vif, priv->hWILCWFIDrv,
-						   wl->vif[0]->bssid, TID);
+			wilc_del_all_rx_ba_session(vif, wl->vif[0]->bssid,
+						   TID);
 			wilc_wait_msg_queue_idle();
 
 			up(&wl->cfg_event);
@@ -2127,20 +2143,19 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			vif->iftype = interface_type;
 
 			wilc_set_wfi_drv_handler(vif, wl->vif[0]->hif_drv);
-			wilc_set_mac_address(vif, wl->vif[0]->hif_drv,
-						wl->vif[0]->src_addr);
-			wilc_set_operation_mode(vif, priv->hWILCWFIDrv, STATION_MODE);
+			wilc_set_mac_address(wl->vif[0], wl->vif[0]->src_addr);
+			wilc_set_operation_mode(vif, STATION_MODE);
 
 			if (g_wep_keys_saved) {
-				wilc_set_wep_default_keyid(vif, wl->vif[0]->hif_drv,
-							     g_key_wep_params.key_idx);
-				wilc_add_wep_key_bss_sta(vif, wl->vif[0]->hif_drv,
-							     g_key_wep_params.key,
-							     g_key_wep_params.key_len,
-							     g_key_wep_params.key_idx);
+				wilc_set_wep_default_keyid(wl->vif[0],
+						g_key_wep_params.key_idx);
+				wilc_add_wep_key_bss_sta(wl->vif[0],
+						g_key_wep_params.key,
+						g_key_wep_params.key_len,
+						g_key_wep_params.key_idx);
 			}
 
-			wilc_flush_join_req(vif, priv->hWILCWFIDrv);
+			wilc_flush_join_req(vif);
 
 			if (g_ptk_keys_saved && g_gtk_keys_saved) {
 				PRINT_D(CFG80211_DBG, "ptk %x %x %x\n", g_key_ptk_params.key[0],
@@ -2168,25 +2183,24 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 				for (i = 0; i < num_reg_frame; i++) {
 					PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", vif->g_struct_frame_reg[i].frame_type,
 						vif->g_struct_frame_reg[i].reg);
-					wilc_frame_register(vif, priv->hWILCWFIDrv,
+					wilc_frame_register(vif,
 								vif->g_struct_frame_reg[i].frame_type,
 								vif->g_struct_frame_reg[i].reg);
 				}
 			}
 
 			wilc_enable_ps = true;
-			wilc_set_power_mgmt(vif, priv->hWILCWFIDrv, 1, 0);
+			wilc_set_power_mgmt(vif, 1, 0);
 		}
 		break;
 
 	case NL80211_IFTYPE_P2P_CLIENT:
 		wilc_enable_ps = false;
-		wilc_set_power_mgmt(vif, priv->hWILCWFIDrv, 0, 0);
+		wilc_set_power_mgmt(vif, 0, 0);
 		wilc_connecting = 0;
 		PRINT_D(HOSTAPD_DBG, "Interface type = NL80211_IFTYPE_P2P_CLIENT\n");
 
-		wilc_del_all_rx_ba_session(vif, priv->hWILCWFIDrv,
-					   wl->vif[0]->bssid, TID);
+		wilc_del_all_rx_ba_session(vif, wl->vif[0]->bssid, TID);
 
 		dev->ieee80211_ptr->iftype = type;
 		priv->wdev->iftype = type;
@@ -2204,20 +2218,19 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			wilc_initialized = 1;
 
 			wilc_set_wfi_drv_handler(vif, wl->vif[0]->hif_drv);
-			wilc_set_mac_address(vif, wl->vif[0]->hif_drv,
-						wl->vif[0]->src_addr);
-			wilc_set_operation_mode(vif, priv->hWILCWFIDrv, STATION_MODE);
+			wilc_set_mac_address(wl->vif[0], wl->vif[0]->src_addr);
+			wilc_set_operation_mode(vif, STATION_MODE);
 
 			if (g_wep_keys_saved) {
-				wilc_set_wep_default_keyid(vif, wl->vif[0]->hif_drv,
-							   g_key_wep_params.key_idx);
-				wilc_add_wep_key_bss_sta(vif, wl->vif[0]->hif_drv,
-							 g_key_wep_params.key,
-							 g_key_wep_params.key_len,
-							 g_key_wep_params.key_idx);
+				wilc_set_wep_default_keyid(wl->vif[0],
+						g_key_wep_params.key_idx);
+				wilc_add_wep_key_bss_sta(wl->vif[0],
+						g_key_wep_params.key,
+						g_key_wep_params.key_len,
+						g_key_wep_params.key_idx);
 			}
 
-			wilc_flush_join_req(vif, priv->hWILCWFIDrv);
+			wilc_flush_join_req(vif);
 
 			if (g_ptk_keys_saved && g_gtk_keys_saved) {
 				PRINT_D(CFG80211_DBG, "ptk %x %x %x\n", g_key_ptk_params.key[0],
@@ -2248,7 +2261,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 				for (i = 0; i < num_reg_frame; i++) {
 					PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", vif->g_struct_frame_reg[i].frame_type,
 						vif->g_struct_frame_reg[i].reg);
-					wilc_frame_register(vif, priv->hWILCWFIDrv,
+					wilc_frame_register(vif,
 								vif->g_struct_frame_reg[i].frame_type,
 								vif->g_struct_frame_reg[i].reg);
 				}
@@ -2275,7 +2288,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			for (i = 0; i < num_reg_frame; i++) {
 				PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", vif->g_struct_frame_reg[i].frame_type,
 					vif->g_struct_frame_reg[i].reg);
-				wilc_frame_register(vif, priv->hWILCWFIDrv,
+				wilc_frame_register(vif,
 							vif->g_struct_frame_reg[i].frame_type,
 							vif->g_struct_frame_reg[i].reg);
 			}
@@ -2288,9 +2301,8 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		wilc_optaining_ip = true;
 		mod_timer(&wilc_during_ip_timer,
 			  jiffies + msecs_to_jiffies(during_ip_time));
-		wilc_set_power_mgmt(vif, priv->hWILCWFIDrv, 0, 0);
-		wilc_del_all_rx_ba_session(vif, priv->hWILCWFIDrv,
-					   wl->vif[0]->bssid, TID);
+		wilc_set_power_mgmt(vif, 0, 0);
+		wilc_del_all_rx_ba_session(vif, wl->vif[0]->bssid, TID);
 		wilc_enable_ps = false;
 		PRINT_D(HOSTAPD_DBG, "Interface type = NL80211_IFTYPE_GO\n");
 		dev->ieee80211_ptr->iftype = type;
@@ -2309,20 +2321,19 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		wilc_initialized = 1;
 
 		wilc_set_wfi_drv_handler(vif, wl->vif[0]->hif_drv);
-		wilc_set_mac_address(vif, wl->vif[0]->hif_drv,
-				     wl->vif[0]->src_addr);
-		wilc_set_operation_mode(vif, priv->hWILCWFIDrv, AP_MODE);
+		wilc_set_mac_address(wl->vif[0], wl->vif[0]->src_addr);
+		wilc_set_operation_mode(vif, AP_MODE);
 
 		if (g_wep_keys_saved) {
-			wilc_set_wep_default_keyid(vif, wl->vif[0]->hif_drv,
+			wilc_set_wep_default_keyid(wl->vif[0],
 						   g_key_wep_params.key_idx);
-			wilc_add_wep_key_bss_sta(vif, wl->vif[0]->hif_drv,
-						     g_key_wep_params.key,
-						     g_key_wep_params.key_len,
-						     g_key_wep_params.key_idx);
+			wilc_add_wep_key_bss_sta(wl->vif[0],
+						 g_key_wep_params.key,
+						 g_key_wep_params.key_len,
+						 g_key_wep_params.key_idx);
 		}
 
-		wilc_flush_join_req(vif, priv->hWILCWFIDrv);
+		wilc_flush_join_req(vif);
 
 		if (g_ptk_keys_saved && g_gtk_keys_saved) {
 			PRINT_D(CFG80211_DBG, "ptk %x %x %x cipher %x\n", g_key_ptk_params.key[0],
@@ -2352,7 +2363,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			for (i = 0; i < num_reg_frame; i++) {
 				PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", vif->g_struct_frame_reg[i].frame_type,
 					vif->g_struct_frame_reg[i].reg);
-				wilc_frame_register(vif, priv->hWILCWFIDrv,
+				wilc_frame_register(vif,
 							vif->g_struct_frame_reg[i].frame_type,
 							vif->g_struct_frame_reg[i].reg);
 			}
@@ -2391,11 +2402,10 @@ static int start_ap(struct wiphy *wiphy, struct net_device *dev,
 
 	wilc_wlan_set_bssid(dev, wl->vif[0]->src_addr);
 
-	s32Error = wilc_add_beacon(vif, priv->hWILCWFIDrv,
-					settings->beacon_interval,
-					settings->dtim_period,
-					beacon->head_len, (u8 *)beacon->head,
-					beacon->tail_len, (u8 *)beacon->tail);
+	s32Error = wilc_add_beacon(vif, settings->beacon_interval,
+				   settings->dtim_period, beacon->head_len,
+				   (u8 *)beacon->head, beacon->tail_len,
+				   (u8 *)beacon->tail);
 
 	return s32Error;
 }
@@ -2412,11 +2422,9 @@ static int change_beacon(struct wiphy *wiphy, struct net_device *dev,
 	PRINT_D(HOSTAPD_DBG, "Setting beacon\n");
 
 
-	s32Error = wilc_add_beacon(vif, priv->hWILCWFIDrv,
-					0,
-					0,
-					beacon->head_len, (u8 *)beacon->head,
-					beacon->tail_len, (u8 *)beacon->tail);
+	s32Error = wilc_add_beacon(vif, 0, 0, beacon->head_len,
+				   (u8 *)beacon->head, beacon->tail_len,
+				   (u8 *)beacon->tail);
 
 	return s32Error;
 }
@@ -2438,7 +2446,7 @@ static int stop_ap(struct wiphy *wiphy, struct net_device *dev)
 
 	wilc_wlan_set_bssid(dev, NullBssid);
 
-	s32Error = wilc_del_beacon(vif, priv->hWILCWFIDrv);
+	s32Error = wilc_del_beacon(vif);
 
 	if (s32Error)
 		PRINT_ER("Host delete beacon fail\n");
@@ -2509,8 +2517,7 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(HOSTAPD_DBG, "Flag Set = %d\n",
 			strStaParams.flags_set);
 
-		s32Error = wilc_add_station(vif, priv->hWILCWFIDrv,
-					    &strStaParams);
+		s32Error = wilc_add_station(vif, &strStaParams);
 		if (s32Error)
 			PRINT_ER("Host add station fail\n");
 	}
@@ -2538,12 +2545,13 @@ static int del_station(struct wiphy *wiphy, struct net_device *dev,
 
 		if (!mac) {
 			PRINT_D(HOSTAPD_DBG, "All associated stations\n");
-			s32Error = wilc_del_allstation(vif, priv->hWILCWFIDrv, priv->assoc_stainfo.au8Sta_AssociatedBss);
+			s32Error = wilc_del_allstation(vif,
+				     priv->assoc_stainfo.au8Sta_AssociatedBss);
 		} else {
 			PRINT_D(HOSTAPD_DBG, "With mac address: %x%x%x%x%x%x\n", mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
 		}
 
-		s32Error = wilc_del_station(vif, priv->hWILCWFIDrv, mac);
+		s32Error = wilc_del_station(vif, mac);
 
 		if (s32Error)
 			PRINT_ER("Host delete station fail\n");
@@ -2616,8 +2624,7 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(HOSTAPD_DBG, "Flag Set = %d\n",
 			strStaParams.flags_set);
 
-		s32Error = wilc_edit_station(vif, priv->hWILCWFIDrv,
-					     &strStaParams);
+		s32Error = wilc_edit_station(vif, &strStaParams);
 		if (s32Error)
 			PRINT_ER("Host edit station fail\n");
 	}
@@ -2862,7 +2869,7 @@ int wilc_deinit_host_int(struct net_device *net)
 
 	op_ifcs--;
 
-	s32Error = wilc_deinit(vif, priv->hWILCWFIDrv);
+	s32Error = wilc_deinit(vif);
 
 	clear_shadow_scan();
 	if (op_ifcs == 0) {
-- 
1.9.1

