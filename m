Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:13612 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbbLNFnY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 00:43:24 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 01/12] staging: wilc1000: pass vif to hostIFthread
Date: Mon, 14 Dec 2015 14:46:52 +0900
Message-ID: <1450072023-13013-2-git-send-email-glen.lee@atmel.com> (sfid-20151214_064354_457412_88B6D0EF)
In-Reply-To: <1450072023-13013-1-git-send-email-glen.lee@atmel.com>
References: <1450072023-13013-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We will pass vif, which is currently being used as net_device, instead of
hif_dev. This is the first step to use index of vif to pass to the driver.
Add new argument vif to all the functions that send message to hostIFthread and
set vif to msg.vif. As a result, hostIfthread will get vif.
In later patch, we will remove drv of host_if_msg and use vif instead of it.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         | 235 ++++++++++++++--------
 drivers/staging/wilc1000/host_interface.h         | 165 +++++++--------
 drivers/staging/wilc1000/linux_wlan.c             |  22 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 166 ++++++++-------
 4 files changed, 342 insertions(+), 246 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index f7e560e..c52a8e1 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -194,6 +194,7 @@ struct host_if_msg {
 	u16 id;
 	union message_body body;
 	struct host_if_drv *drv;
+	struct wilc_vif *vif;
 };
 
 struct join_bss_param {
@@ -389,9 +390,13 @@ static s32 handle_set_operation_mode(struct host_if_drv *hif_drv,
 	return result;
 }
 
-static s32 host_int_get_ipaddress(struct host_if_drv *hif_drv, u8 *u16ipadd, u8 idx);
+static s32 host_int_get_ipaddress(struct wilc_vif *vif,
+				  struct host_if_drv *hif_drv,
+				  u8 *u16ipadd, u8 idx);
 
-static s32 handle_set_ip_address(struct host_if_drv *hif_drv, u8 *ip_addr, u8 idx)
+static s32 handle_set_ip_address(struct wilc_vif *vif,
+				 struct host_if_drv *hif_drv, u8 *ip_addr,
+				 u8 idx)
 {
 	s32 result = 0;
 	struct wid wid;
@@ -413,7 +418,7 @@ static s32 handle_set_ip_address(struct host_if_drv *hif_drv, u8 *ip_addr, u8 id
 	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
-	host_int_get_ipaddress(hif_drv, firmware_ip_addr, idx);
+	host_int_get_ipaddress(vif, hif_drv, firmware_ip_addr, idx);
 
 	if (result) {
 		PRINT_ER("Failed to set IP address\n");
@@ -425,7 +430,8 @@ static s32 handle_set_ip_address(struct host_if_drv *hif_drv, u8 *ip_addr, u8 id
 	return result;
 }
 
-static s32 handle_get_ip_address(struct host_if_drv *hif_drv, u8 idx)
+static s32 handle_get_ip_address(struct wilc_vif *vif,
+				 struct host_if_drv *hif_drv, u8 idx)
 {
 	s32 result = 0;
 	struct wid wid;
@@ -445,7 +451,7 @@ static s32 handle_get_ip_address(struct host_if_drv *hif_drv, u8 idx)
 	kfree(wid.val);
 
 	if (memcmp(get_ip[idx], set_ip[idx], IP_ALEN) != 0)
-		wilc_setup_ipaddress(hif_drv, set_ip[idx], idx);
+		wilc_setup_ipaddress(vif, hif_drv, set_ip[idx], idx);
 
 	if (result != 0) {
 		PRINT_ER("Failed to get IP address\n");
@@ -1490,7 +1496,8 @@ static s32 host_int_get_assoc_res_info(struct host_if_drv *hif_drv,
 				       u32 u32MaxAssocRespInfoLen,
 				       u32 *pu32RcvdAssocRespInfoLen);
 
-static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
+static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
+				    struct host_if_drv *hif_drv,
 				    struct rcvd_async_info *pstrRcvdGnrlAsyncInfo)
 {
 	s32 result = 0;
@@ -1619,7 +1626,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 
 			if ((u8MacStatus == MAC_CONNECTED) &&
 			    (strConnectInfo.u16ConnectStatus == SUCCESSFUL_STATUSCODE))	{
-				wilc_set_power_mgmt(hif_drv, 0, 0);
+				wilc_set_power_mgmt(vif, hif_drv, 0, 0);
 
 				PRINT_D(HOSTINF_DBG, "MAC status : CONNECTED and Connect Status : Successful\n");
 				hif_drv->hif_state = HOST_IF_CONNECTED;
@@ -1662,7 +1669,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 
 			if (hif_drv->usr_conn_req.conn_result) {
 				wilc_optaining_ip = false;
-				wilc_set_power_mgmt(hif_drv, 0, 0);
+				wilc_set_power_mgmt(vif, hif_drv, 0, 0);
 
 				hif_drv->usr_conn_req.conn_result(CONN_DISCONN_EVENT_DISCONN_NOTIF,
 								  NULL,
@@ -1984,7 +1991,8 @@ _WPAPtk_end_case_:
 	return result;
 }
 
-static void Handle_Disconnect(struct host_if_drv *hif_drv)
+static void Handle_Disconnect(struct wilc_vif *vif,
+			      struct host_if_drv *hif_drv)
 {
 	struct wid wid;
 
@@ -1999,7 +2007,7 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
 
 	wilc_optaining_ip = false;
-	wilc_set_power_mgmt(hif_drv, 0, 0);
+	wilc_set_power_mgmt(vif, hif_drv, 0, 0);
 
 	eth_zero_addr(wilc_connected_ssid);
 
@@ -2067,14 +2075,15 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 	up(&hif_drv->sem_test_disconn_block);
 }
 
-void wilc_resolve_disconnect_aberration(struct host_if_drv *hif_drv)
+void wilc_resolve_disconnect_aberration(struct wilc_vif *vif,
+					struct host_if_drv *hif_drv)
 {
 	if (!hif_drv)
 		return;
 	if ((hif_drv->hif_state == HOST_IF_WAITING_CONN_RESP) ||
 	    (hif_drv->hif_state == HOST_IF_CONNECTING)) {
 		PRINT_D(HOSTINF_DBG, "\n\n<< correcting Supplicant state machine >>\n\n");
-		wilc_disconnect(hif_drv, 1);
+		wilc_disconnect(vif, hif_drv, 1);
 	}
 }
 
@@ -2780,12 +2789,14 @@ static int hostIFthread(void *pvArg)
 	struct host_if_msg msg;
 	struct host_if_drv *hif_drv;
 	struct wilc *wilc = (struct wilc*)pvArg;
+	struct wilc_vif *vif;
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	while (1) {
 		wilc_mq_recv(&hif_msg_q, &msg, sizeof(struct host_if_msg), &u32Ret);
 		hif_drv = (struct host_if_drv *)msg.drv;
+		vif = msg.vif;
 		if (msg.id == HOST_IF_MSG_EXIT) {
 			PRINT_D(GENERIC_DBG, "THREAD: Exiting HostIfThread\n");
 			break;
@@ -2828,7 +2839,8 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO:
-			Handle_RcvdGnrlAsyncInfo(msg.drv, &msg.body.async_info);
+			Handle_RcvdGnrlAsyncInfo(vif, msg.drv,
+						 &msg.body.async_info);
 			break;
 
 		case HOST_IF_MSG_KEY:
@@ -2844,7 +2856,7 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_DISCONNECT:
-			Handle_Disconnect(msg.drv);
+			Handle_Disconnect(vif, msg.drv);
 			break;
 
 		case HOST_IF_MSG_RCVD_SCAN_COMPLETE:
@@ -2926,14 +2938,15 @@ static int hostIFthread(void *pvArg)
 
 		case HOST_IF_MSG_SET_IPADDRESS:
 			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_SET_IPADDRESS\n");
-			handle_set_ip_address(msg.drv,
+			handle_set_ip_address(vif, msg.drv,
 					      msg.body.ip_info.ip_addr,
 					      msg.body.ip_info.idx);
 			break;
 
 		case HOST_IF_MSG_GET_IPADDRESS:
 			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_SET_IPADDRESS\n");
-			handle_get_ip_address(msg.drv, msg.body.ip_info.idx);
+			handle_get_ip_address(vif, msg.drv,
+					      msg.body.ip_info.idx);
 			break;
 
 		case HOST_IF_MSG_SET_MAC_ADDRESS:
@@ -3020,7 +3033,8 @@ s32 wilc_remove_key(struct host_if_drv *hif_drv, const u8 *pu8StaAddress)
 	return 0;
 }
 
-int wilc_remove_wep_key(struct host_if_drv *hif_drv, u8 index)
+int wilc_remove_wep_key(struct wilc_vif *vif,
+			struct host_if_drv *hif_drv, u8 index)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -3037,6 +3051,7 @@ int wilc_remove_wep_key(struct host_if_drv *hif_drv, u8 index)
 	msg.body.key_info.type = WEP;
 	msg.body.key_info.action = REMOVEKEY;
 	msg.drv = hif_drv;
+	msg.vif = vif;
 	msg.body.key_info.attr.wep.index = index;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
@@ -3047,7 +3062,8 @@ int wilc_remove_wep_key(struct host_if_drv *hif_drv, u8 index)
 	return result;
 }
 
-int wilc_set_wep_default_keyid(struct host_if_drv *hif_drv, u8 index)
+int wilc_set_wep_default_keyid(struct wilc_vif *vif,
+			       struct host_if_drv *hif_drv, u8 index)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -3064,6 +3080,7 @@ int wilc_set_wep_default_keyid(struct host_if_drv *hif_drv, u8 index)
 	msg.body.key_info.type = WEP;
 	msg.body.key_info.action = DEFAULTKEY;
 	msg.drv = hif_drv;
+	msg.vif = vif;
 	msg.body.key_info.attr.wep.index = index;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
@@ -3074,10 +3091,8 @@ int wilc_set_wep_default_keyid(struct host_if_drv *hif_drv, u8 index)
 	return result;
 }
 
-int wilc_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
-				 const u8 *key,
-				 u8 len,
-				 u8 index)
+int wilc_add_wep_key_bss_sta(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+			     const u8 *key, u8 len, u8 index)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -3093,6 +3108,7 @@ int wilc_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 	msg.body.key_info.type = WEP;
 	msg.body.key_info.action = ADDKEY;
 	msg.drv = hif_drv;
+	msg.vif = vif;
 	msg.body.key_info.attr.wep.key = kmemdup(key, len, GFP_KERNEL);
 	if (!msg.body.key_info.attr.wep.key)
 		return -ENOMEM;
@@ -3108,11 +3124,8 @@ int wilc_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 	return result;
 }
 
-int wilc_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
-			    const u8 *key,
-			    u8 len,
-			    u8 index,
-			    u8 mode,
+int wilc_add_wep_key_bss_ap(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+			    const u8 *key, u8 len, u8 index, u8 mode,
 			    enum AUTHTYPE auth_type)
 {
 	int result = 0;
@@ -3134,6 +3147,7 @@ int wilc_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 	msg.body.key_info.type = WEP;
 	msg.body.key_info.action = ADDKEY_AP;
 	msg.drv = hif_drv;
+	msg.vif = vif;
 	msg.body.key_info.attr.wep.key = kmemdup(key, len, GFP_KERNEL);
 	if (!msg.body.key_info.attr.wep.key)
 		return -ENOMEM;
@@ -3152,10 +3166,10 @@ int wilc_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 wilc_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
-		     u8 u8PtkKeylen, const u8 *mac_addr,
-		     const u8 *pu8RxMic, const u8 *pu8TxMic,
-		     u8 mode, u8 u8Ciphermode, u8 u8Idx)
+s32 wilc_add_ptk(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+		 const u8 *pu8Ptk, u8 u8PtkKeylen, const u8 *mac_addr,
+		 const u8 *pu8RxMic, const u8 *pu8TxMic,
+		 u8 mode, u8 u8Ciphermode, u8 u8Idx)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
@@ -3206,6 +3220,7 @@ s32 wilc_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
 	msg.body.key_info.attr.wpa.mac_addr = mac_addr;
 	msg.body.key_info.attr.wpa.mode = u8Ciphermode;
 	msg.drv = hif_drv;
+	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 
@@ -3217,11 +3232,11 @@ s32 wilc_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
 	return result;
 }
 
-s32 wilc_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
-			u8 u8GtkKeylen,	u8 u8KeyIdx,
-			u32 u32KeyRSClen, const u8 *KeyRSC,
-			const u8 *pu8RxMic, const u8 *pu8TxMic,
-			u8 mode, u8 u8Ciphermode)
+s32 wilc_add_rx_gtk(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+		    const u8 *pu8RxGtk, u8 u8GtkKeylen, u8 u8KeyIdx,
+		    u32 u32KeyRSClen, const u8 *KeyRSC,
+		    const u8 *pu8RxMic, const u8 *pu8TxMic,
+		    u8 mode, u8 u8Ciphermode)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
@@ -3247,6 +3262,7 @@ s32 wilc_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.type = WPA_RX_GTK;
 	msg.drv = hif_drv;
+	msg.vif = vif;
 
 	if (mode == AP_MODE) {
 		msg.body.key_info.action = ADDKEY_AP;
@@ -3279,7 +3295,8 @@ s32 wilc_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
 	return result;
 }
 
-s32 wilc_set_pmkid_info(struct host_if_drv *hif_drv, struct host_if_pmkid_attr *pu8PmkidInfoArray)
+s32 wilc_set_pmkid_info(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+			struct host_if_pmkid_attr *pu8PmkidInfoArray)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
@@ -3296,6 +3313,7 @@ s32 wilc_set_pmkid_info(struct host_if_drv *hif_drv, struct host_if_pmkid_attr *
 	msg.body.key_info.type = PMKSA;
 	msg.body.key_info.action = ADDKEY;
 	msg.drv = hif_drv;
+	msg.vif = vif;
 
 	for (i = 0; i < pu8PmkidInfoArray->numpmkid; i++) {
 		memcpy(msg.body.key_info.attr.pmkid.pmkidlist[i].bssid,
@@ -3311,7 +3329,8 @@ s32 wilc_set_pmkid_info(struct host_if_drv *hif_drv, struct host_if_pmkid_attr *
 	return result;
 }
 
-s32 wilc_get_mac_address(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
+s32 wilc_get_mac_address(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+			 u8 *pu8MacAddress)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
@@ -3321,6 +3340,7 @@ s32 wilc_get_mac_address(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
 	msg.id = HOST_IF_MSG_GET_MAC_ADDRESS;
 	msg.body.get_mac_info.mac_addr = pu8MacAddress;
 	msg.drv = hif_drv;
+	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result) {
@@ -3332,7 +3352,8 @@ s32 wilc_get_mac_address(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
 	return result;
 }
 
-s32 wilc_set_mac_address(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
+s32 wilc_set_mac_address(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+			 u8 *pu8MacAddress)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
@@ -3343,6 +3364,7 @@ s32 wilc_set_mac_address(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
 	msg.id = HOST_IF_MSG_SET_MAC_ADDRESS;
 	memcpy(msg.body.set_mac_info.mac_addr, pu8MacAddress, ETH_ALEN);
 	msg.drv = hif_drv;
+	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
@@ -3363,12 +3385,12 @@ s32 host_int_set_start_scan_req(struct host_if_drv *hif_drv, u8 scanSource)
 	return 0;
 }
 
-s32 wilc_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
-			  const u8 *pu8ssid, size_t ssidLen,
-			  const u8 *pu8IEs, size_t IEsLen,
-			  wilc_connect_result pfConnectResult, void *pvUserArg,
-			  u8 u8security, enum AUTHTYPE tenuAuth_type,
-			  u8 u8channel, void *pJoinParams)
+s32 wilc_set_join_req(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+		      u8 *pu8bssid, const u8 *pu8ssid, size_t ssidLen,
+		      const u8 *pu8IEs, size_t IEsLen,
+		      wilc_connect_result pfConnectResult, void *pvUserArg,
+		      u8 u8security, enum AUTHTYPE tenuAuth_type,
+		      u8 u8channel, void *pJoinParams)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
@@ -3394,6 +3416,7 @@ s32 wilc_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
 	msg.body.con_info.arg = pvUserArg;
 	msg.body.con_info.params = pJoinParams;
 	msg.drv = hif_drv ;
+	msg.vif = vif;
 
 	if (pu8bssid) {
 		msg.body.con_info.bssid = kmalloc(6, GFP_KERNEL);
@@ -3430,7 +3453,7 @@ s32 wilc_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
 	return result;
 }
 
-s32 wilc_flush_join_req(struct host_if_drv *hif_drv)
+s32 wilc_flush_join_req(struct wilc_vif *vif, struct host_if_drv *hif_drv)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
@@ -3445,6 +3468,7 @@ s32 wilc_flush_join_req(struct host_if_drv *hif_drv)
 
 	msg.id = HOST_IF_MSG_FLUSH_CONNECT;
 	msg.drv = hif_drv;
+	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result) {
@@ -3455,7 +3479,8 @@ s32 wilc_flush_join_req(struct host_if_drv *hif_drv)
 	return result;
 }
 
-s32 wilc_disconnect(struct host_if_drv *hif_drv, u16 u16ReasonCode)
+s32 wilc_disconnect(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+		    u16 u16ReasonCode)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
@@ -3469,6 +3494,7 @@ s32 wilc_disconnect(struct host_if_drv *hif_drv, u16 u16ReasonCode)
 
 	msg.id = HOST_IF_MSG_DISCONNECT;
 	msg.drv = hif_drv;
+	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
@@ -3510,7 +3536,8 @@ static s32 host_int_get_assoc_res_info(struct host_if_drv *hif_drv,
 	return result;
 }
 
-int wilc_set_mac_chnl_num(struct host_if_drv *hif_drv, u8 channel)
+int wilc_set_mac_chnl_num(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+			  u8 channel)
 {
 	int result;
 	struct host_if_msg msg;
@@ -3524,6 +3551,7 @@ int wilc_set_mac_chnl_num(struct host_if_drv *hif_drv, u8 channel)
 	msg.id = HOST_IF_MSG_SET_CHANNEL;
 	msg.body.channel_info.set_ch = channel;
 	msg.drv = hif_drv;
+	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result) {
@@ -3552,7 +3580,7 @@ int wilc_wait_msg_queue_idle(void)
 	return result;
 }
 
-int wilc_set_wfi_drv_handler(struct host_if_drv *hif_drv)
+int wilc_set_wfi_drv_handler(struct wilc_vif *vif, struct host_if_drv *hif_drv)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -3561,6 +3589,7 @@ int wilc_set_wfi_drv_handler(struct host_if_drv *hif_drv)
 	msg.id = HOST_IF_MSG_SET_WFIDRV_HANDLER;
 	msg.body.drv.handler = get_id_from_handler(hif_drv);
 	msg.drv = hif_drv;
+	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result) {
@@ -3571,7 +3600,8 @@ int wilc_set_wfi_drv_handler(struct host_if_drv *hif_drv)
 	return result;
 }
 
-int wilc_set_operation_mode(struct host_if_drv *hif_drv, u32 mode)
+int wilc_set_operation_mode(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+			    u32 mode)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -3580,6 +3610,7 @@ int wilc_set_operation_mode(struct host_if_drv *hif_drv, u32 mode)
 	msg.id = HOST_IF_MSG_SET_OPERATION_MODE;
 	msg.body.mode.mode = mode;
 	msg.drv = hif_drv;
+	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result) {
@@ -3590,7 +3621,7 @@ int wilc_set_operation_mode(struct host_if_drv *hif_drv, u32 mode)
 	return result;
 }
 
-s32 wilc_get_inactive_time(struct host_if_drv *hif_drv,
+s32 wilc_get_inactive_time(struct wilc_vif *vif, struct host_if_drv *hif_drv,
 			       const u8 *mac, u32 *pu32InactiveTime)
 {
 	s32 result = 0;
@@ -3606,6 +3637,7 @@ s32 wilc_get_inactive_time(struct host_if_drv *hif_drv,
 
 	msg.id = HOST_IF_MSG_GET_INACTIVETIME;
 	msg.drv = hif_drv;
+	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
@@ -3618,7 +3650,8 @@ s32 wilc_get_inactive_time(struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 wilc_get_rssi(struct host_if_drv *hif_drv, s8 *ps8Rssi)
+s32 wilc_get_rssi(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+		  s8 *ps8Rssi)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
@@ -3626,6 +3659,7 @@ s32 wilc_get_rssi(struct host_if_drv *hif_drv, s8 *ps8Rssi)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_GET_RSSI;
 	msg.drv = hif_drv;
+	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result) {
@@ -3645,7 +3679,8 @@ s32 wilc_get_rssi(struct host_if_drv *hif_drv, s8 *ps8Rssi)
 	return result;
 }
 
-s32 wilc_get_statistics(struct host_if_drv *hif_drv, struct rf_info *pstrStatistics)
+s32 wilc_get_statistics(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+			struct rf_info *pstrStatistics)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
@@ -3654,6 +3689,7 @@ s32 wilc_get_statistics(struct host_if_drv *hif_drv, struct rf_info *pstrStatist
 	msg.id = HOST_IF_MSG_GET_STATISTICS;
 	msg.body.data = (char *)pstrStatistics;
 	msg.drv = hif_drv;
+	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result) {
@@ -3665,11 +3701,11 @@ s32 wilc_get_statistics(struct host_if_drv *hif_drv, struct rf_info *pstrStatist
 	return result;
 }
 
-s32 wilc_scan(struct host_if_drv *hif_drv, u8 u8ScanSource,
-		  u8 u8ScanType, u8 *pu8ChnlFreqList,
-		  u8 u8ChnlListLen, const u8 *pu8IEs,
-		  size_t IEsLen, wilc_scan_result ScanResult,
-		  void *pvUserArg, struct hidden_network *pstrHiddenNetwork)
+s32 wilc_scan(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+	      u8 u8ScanSource, u8 u8ScanType, u8 *pu8ChnlFreqList,
+	      u8 u8ChnlListLen, const u8 *pu8IEs,
+	      size_t IEsLen, wilc_scan_result ScanResult,
+	      void *pvUserArg, struct hidden_network *pstrHiddenNetwork)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
@@ -3691,6 +3727,7 @@ s32 wilc_scan(struct host_if_drv *hif_drv, u8 u8ScanSource,
 		PRINT_D(HOSTINF_DBG, "pstrHiddenNetwork IS EQUAL TO NULL\n");
 
 	msg.drv = hif_drv;
+	msg.vif = vif;
 	msg.body.scan_info.src = u8ScanSource;
 	msg.body.scan_info.type = u8ScanType;
 	msg.body.scan_info.result = ScanResult;
@@ -3718,7 +3755,7 @@ s32 wilc_scan(struct host_if_drv *hif_drv, u8 u8ScanSource,
 	return result;
 }
 
-s32 wilc_hif_set_cfg(struct host_if_drv *hif_drv,
+s32 wilc_hif_set_cfg(struct wilc_vif *vif, struct host_if_drv *hif_drv,
 		struct cfg_param_val *pstrCfgParamVal)
 {
 	s32 result = 0;
@@ -3733,6 +3770,7 @@ s32 wilc_hif_set_cfg(struct host_if_drv *hif_drv,
 	msg.id = HOST_IF_MSG_CFG_PARAMS;
 	msg.body.cfg_info.cfg_attr_info = *pstrCfgParamVal;
 	msg.drv = hif_drv;
+	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 
@@ -3875,7 +3913,7 @@ _fail_:
 	return result;
 }
 
-s32 wilc_deinit(struct host_if_drv *hif_drv)
+s32 wilc_deinit(struct wilc_vif *vif, struct host_if_drv *hif_drv)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
@@ -3902,7 +3940,7 @@ s32 wilc_deinit(struct host_if_drv *hif_drv)
 
 	del_timer_sync(&hif_drv->remain_on_ch_timer);
 
-	wilc_set_wfi_drv_handler(NULL);
+	wilc_set_wfi_drv_handler(vif, NULL);
 	down(&hif_sema_driver);
 
 	if (hif_drv->usr_scan_req.scan_result) {
@@ -3923,6 +3961,7 @@ s32 wilc_deinit(struct host_if_drv *hif_drv)
 
 		msg.id = HOST_IF_MSG_EXIT;
 		msg.drv = hif_drv;
+		msg.vif = vif;
 
 		result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 		if (result != 0)
@@ -4044,11 +4083,11 @@ void wilc_scan_complete_received(u8 *pu8Buffer, u32 u32Length)
 	return;
 }
 
-s32 wilc_remain_on_channel(struct host_if_drv *hif_drv, u32 u32SessionID,
-			       u32 u32duration, u16 chan,
-			       wilc_remain_on_chan_expired RemainOnChanExpired,
-			       wilc_remain_on_chan_ready RemainOnChanReady,
-			       void *pvUserArg)
+s32 wilc_remain_on_channel(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+			   u32 u32SessionID, u32 u32duration, u16 chan,
+			   wilc_remain_on_chan_expired RemainOnChanExpired,
+			   wilc_remain_on_chan_ready RemainOnChanReady,
+			   void *pvUserArg)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
@@ -4068,6 +4107,7 @@ s32 wilc_remain_on_channel(struct host_if_drv *hif_drv, u32 u32SessionID,
 	msg.body.remain_on_ch.u32duration = u32duration;
 	msg.body.remain_on_ch.id = u32SessionID;
 	msg.drv = hif_drv;
+	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
@@ -4076,7 +4116,8 @@ s32 wilc_remain_on_channel(struct host_if_drv *hif_drv, u32 u32SessionID,
 	return result;
 }
 
-s32 wilc_listen_state_expired(struct host_if_drv *hif_drv, u32 u32SessionID)
+s32 wilc_listen_state_expired(struct wilc_vif *vif,
+			      struct host_if_drv *hif_drv, u32 u32SessionID)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
@@ -4091,6 +4132,7 @@ s32 wilc_listen_state_expired(struct host_if_drv *hif_drv, u32 u32SessionID)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_LISTEN_TIMER_FIRED;
 	msg.drv = hif_drv;
+	msg.vif = vif;
 	msg.body.remain_on_ch.id = u32SessionID;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
@@ -4100,7 +4142,8 @@ s32 wilc_listen_state_expired(struct host_if_drv *hif_drv, u32 u32SessionID)
 	return result;
 }
 
-s32 wilc_frame_register(struct host_if_drv *hif_drv, u16 u16FrameType, bool bReg)
+s32 wilc_frame_register(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+			u16 u16FrameType, bool bReg)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
@@ -4131,6 +4174,7 @@ s32 wilc_frame_register(struct host_if_drv *hif_drv, u16 u16FrameType, bool bReg
 	msg.body.reg_frame.frame_type = u16FrameType;
 	msg.body.reg_frame.reg = bReg;
 	msg.drv = hif_drv;
+	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
@@ -4139,9 +4183,10 @@ s32 wilc_frame_register(struct host_if_drv *hif_drv, u16 u16FrameType, bool bReg
 	return result;
 }
 
-s32 wilc_add_beacon(struct host_if_drv *hif_drv, u32 u32Interval,
-			u32 u32DTIMPeriod, u32 u32HeadLen, u8 *pu8Head,
-			u32 u32TailLen, u8 *pu8Tail)
+s32 wilc_add_beacon(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+		    u32 u32Interval,
+		    u32 u32DTIMPeriod, u32 u32HeadLen, u8 *pu8Head,
+		    u32 u32TailLen, u8 *pu8Tail)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
@@ -4158,6 +4203,7 @@ s32 wilc_add_beacon(struct host_if_drv *hif_drv, u32 u32Interval,
 
 	msg.id = HOST_IF_MSG_ADD_BEACON;
 	msg.drv = hif_drv;
+	msg.vif = vif;
 	pstrSetBeaconParam->interval = u32Interval;
 	pstrSetBeaconParam->dtim_period = u32DTIMPeriod;
 	pstrSetBeaconParam->head_len = u32HeadLen;
@@ -4193,7 +4239,7 @@ ERRORHANDLER:
 	return result;
 }
 
-int wilc_del_beacon(struct host_if_drv *hif_drv)
+int wilc_del_beacon(struct wilc_vif *vif, struct host_if_drv *hif_drv)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -4205,6 +4251,7 @@ int wilc_del_beacon(struct host_if_drv *hif_drv)
 
 	msg.id = HOST_IF_MSG_DEL_BEACON;
 	msg.drv = hif_drv;
+	msg.vif = vif;
 	PRINT_D(HOSTINF_DBG, "Setting deleting beacon message queue params\n");
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
@@ -4214,7 +4261,7 @@ int wilc_del_beacon(struct host_if_drv *hif_drv)
 	return result;
 }
 
-int wilc_add_station(struct host_if_drv *hif_drv,
+int wilc_add_station(struct wilc_vif *vif, struct host_if_drv *hif_drv,
 		     struct add_sta_param *sta_param)
 {
 	int result = 0;
@@ -4232,6 +4279,7 @@ int wilc_add_station(struct host_if_drv *hif_drv,
 
 	msg.id = HOST_IF_MSG_ADD_STATION;
 	msg.drv = hif_drv;
+	msg.vif = vif;
 
 	memcpy(add_sta_info, sta_param, sizeof(struct add_sta_param));
 	if (add_sta_info->rates_len > 0) {
@@ -4248,7 +4296,8 @@ int wilc_add_station(struct host_if_drv *hif_drv,
 	return result;
 }
 
-int wilc_del_station(struct host_if_drv *hif_drv, const u8 *mac_addr)
+int wilc_del_station(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+		     const u8 *mac_addr)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -4265,6 +4314,7 @@ int wilc_del_station(struct host_if_drv *hif_drv, const u8 *mac_addr)
 
 	msg.id = HOST_IF_MSG_DEL_STATION;
 	msg.drv = hif_drv;
+	msg.vif = vif;
 
 	if (!mac_addr)
 		eth_broadcast_addr(del_sta_info->mac_addr);
@@ -4277,7 +4327,7 @@ int wilc_del_station(struct host_if_drv *hif_drv, const u8 *mac_addr)
 	return result;
 }
 
-s32 wilc_del_allstation(struct host_if_drv *hif_drv,
+s32 wilc_del_allstation(struct wilc_vif *vif, struct host_if_drv *hif_drv,
 			    u8 pu8MacAddr[][ETH_ALEN])
 {
 	s32 result = 0;
@@ -4298,6 +4348,7 @@ s32 wilc_del_allstation(struct host_if_drv *hif_drv,
 
 	msg.id = HOST_IF_MSG_DEL_ALL_STA;
 	msg.drv = hif_drv;
+	msg.vif = vif;
 
 	for (i = 0; i < MAX_NUM_STA; i++) {
 		if (memcmp(pu8MacAddr[i], au8Zero_Buff, ETH_ALEN)) {
@@ -4328,7 +4379,7 @@ s32 wilc_del_allstation(struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 wilc_edit_station(struct host_if_drv *hif_drv,
+s32 wilc_edit_station(struct wilc_vif *vif, struct host_if_drv *hif_drv,
 			  struct add_sta_param *pstrStaParams)
 {
 	s32 result = 0;
@@ -4346,6 +4397,7 @@ s32 wilc_edit_station(struct host_if_drv *hif_drv,
 
 	msg.id = HOST_IF_MSG_EDIT_STATION;
 	msg.drv = hif_drv;
+	msg.vif = vif;
 
 	memcpy(pstrAddStationMsg, pstrStaParams, sizeof(struct add_sta_param));
 	if (pstrAddStationMsg->rates_len > 0) {
@@ -4366,9 +4418,8 @@ s32 wilc_edit_station(struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 wilc_set_power_mgmt(struct host_if_drv *hif_drv,
-			    bool bIsEnabled,
-			    u32 u32Timeout)
+s32 wilc_set_power_mgmt(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+			    bool bIsEnabled, u32 u32Timeout)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
@@ -4387,6 +4438,7 @@ s32 wilc_set_power_mgmt(struct host_if_drv *hif_drv,
 
 	msg.id = HOST_IF_MSG_POWER_MGMT;
 	msg.drv = hif_drv;
+	msg.vif = vif;
 
 	pstrPowerMgmtParam->enabled = bIsEnabled;
 	pstrPowerMgmtParam->timeout = u32Timeout;
@@ -4397,9 +4449,10 @@ s32 wilc_set_power_mgmt(struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 wilc_setup_multicast_filter(struct host_if_drv *hif_drv,
-				    bool bIsEnabled,
-				    u32 u32count)
+s32 wilc_setup_multicast_filter(struct wilc_vif *vif,
+				struct host_if_drv *hif_drv,
+				bool bIsEnabled,
+				u32 u32count)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
@@ -4416,6 +4469,7 @@ s32 wilc_setup_multicast_filter(struct host_if_drv *hif_drv,
 
 	msg.id = HOST_IF_MSG_SET_MULTICAST_FILTER;
 	msg.drv = hif_drv;
+	msg.vif = vif;
 
 	pstrMulticastFilterParam->enabled = bIsEnabled;
 	pstrMulticastFilterParam->cnt = u32count;
@@ -4591,9 +4645,10 @@ void wilc_free_join_params(void *pJoinParams)
 		PRINT_ER("Unable to FREE null pointer\n");
 }
 
-s32 wilc_del_all_rx_ba_session(struct host_if_drv *hif_drv,
-				  char *pBSSID,
-				  char TID)
+s32 wilc_del_all_rx_ba_session(struct wilc_vif *vif,
+			       struct host_if_drv *hif_drv,
+			       char *pBSSID,
+			       char TID)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
@@ -4611,6 +4666,7 @@ s32 wilc_del_all_rx_ba_session(struct host_if_drv *hif_drv,
 	memcpy(pBASessionInfo->bssid, pBSSID, ETH_ALEN);
 	pBASessionInfo->tid = TID;
 	msg.drv = hif_drv;
+	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
@@ -4621,7 +4677,8 @@ s32 wilc_del_all_rx_ba_session(struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 wilc_setup_ipaddress(struct host_if_drv *hif_drv, u8 *u16ipadd, u8 idx)
+s32 wilc_setup_ipaddress(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+			 u8 *u16ipadd, u8 idx)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
@@ -4639,6 +4696,7 @@ s32 wilc_setup_ipaddress(struct host_if_drv *hif_drv, u8 *u16ipadd, u8 idx)
 
 	msg.body.ip_info.ip_addr = u16ipadd;
 	msg.drv = hif_drv;
+	msg.vif = vif;
 	msg.body.ip_info.idx = idx;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
@@ -4648,7 +4706,9 @@ s32 wilc_setup_ipaddress(struct host_if_drv *hif_drv, u8 *u16ipadd, u8 idx)
 	return result;
 }
 
-static s32 host_int_get_ipaddress(struct host_if_drv *hif_drv, u8 *u16ipadd, u8 idx)
+static s32 host_int_get_ipaddress(struct wilc_vif *vif,
+				  struct host_if_drv *hif_drv,
+				  u8 *u16ipadd, u8 idx)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
@@ -4664,6 +4724,7 @@ static s32 host_int_get_ipaddress(struct host_if_drv *hif_drv, u8 *u16ipadd, u8
 
 	msg.body.ip_info.ip_addr = u16ipadd;
 	msg.drv = hif_drv;
+	msg.vif = vif;
 	msg.body.ip_info.idx = idx;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 4f5300d..ccbbe73 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -305,97 +305,104 @@ struct add_sta_param {
 	u16 flags_set;
 };
 
+struct wilc_vif;
 s32 wilc_remove_key(struct host_if_drv *hWFIDrv, const u8 *pu8StaAddress);
-int wilc_remove_wep_key(struct host_if_drv *wfi_drv, u8 index);
-int wilc_set_wep_default_keyid(struct host_if_drv *hif_drv, u8 index);
-int wilc_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
-				 const u8 *key, u8 len, u8 index);
-int wilc_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
-				const u8 *key, u8 len, u8 index, u8 mode,
-				enum AUTHTYPE auth_type);
-s32 wilc_add_ptk(struct host_if_drv *hWFIDrv, const u8 *pu8Ptk,
-		     u8 u8PtkKeylen, const u8 *mac_addr,
-		     const u8 *pu8RxMic, const u8 *pu8TxMic,
-		     u8 mode, u8 u8Ciphermode, u8 u8Idx);
-s32 wilc_get_inactive_time(struct host_if_drv *hWFIDrv, const u8 *mac,
-			       u32 *pu32InactiveTime);
-s32 wilc_add_rx_gtk(struct host_if_drv *hWFIDrv, const u8 *pu8RxGtk,
-			u8 u8GtkKeylen,	u8 u8KeyIdx,
-			u32 u32KeyRSClen, const u8 *KeyRSC,
-			const u8 *pu8RxMic, const u8 *pu8TxMic,
-			u8 mode, u8 u8Ciphermode);
+int wilc_remove_wep_key(struct wilc_vif *vif,
+			struct host_if_drv *hif_drv, u8 index);
+int wilc_set_wep_default_keyid(struct wilc_vif *vif,
+			       struct host_if_drv *hif_drv, u8 index);
+int wilc_add_wep_key_bss_sta(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+			     const u8 *key, u8 len, u8 index);
+int wilc_add_wep_key_bss_ap(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+			    const u8 *key, u8 len, u8 index, u8 mode,
+			    enum AUTHTYPE auth_type);
+s32 wilc_add_ptk(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+		 const u8 *pu8Ptk, u8 u8PtkKeylen, const u8 *mac_addr,
+		 const u8 *pu8RxMic, const u8 *pu8TxMic,
+		 u8 mode, u8 u8Ciphermode, u8 u8Idx);
+s32 wilc_get_inactive_time(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+			       const u8 *mac, u32 *pu32InactiveTime);
+s32 wilc_add_rx_gtk(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+		    const u8 *pu8RxGtk, u8 u8GtkKeylen, u8 u8KeyIdx,
+		    u32 u32KeyRSClen, const u8 *KeyRSC,
+		    const u8 *pu8RxMic, const u8 *pu8TxMic,
+		    u8 mode, u8 u8Ciphermode);
 s32 wilc_add_tx_gtk(struct host_if_drv *hWFIDrv, u8 u8KeyLen,
 			u8 *pu8TxGtk, u8 u8KeyIdx);
-s32 wilc_set_pmkid_info(struct host_if_drv *hWFIDrv,
-			    struct host_if_pmkid_attr *pu8PmkidInfoArray);
-s32 wilc_get_mac_address(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress);
-s32 wilc_set_mac_address(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress);
+s32 wilc_set_pmkid_info(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+			struct host_if_pmkid_attr *pu8PmkidInfoArray);
+s32 wilc_get_mac_address(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+			 u8 *pu8MacAddress);
+s32 wilc_set_mac_address(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+			 u8 *pu8MacAddress);
 int wilc_wait_msg_queue_idle(void);
 s32 wilc_set_start_scan_req(struct host_if_drv *hWFIDrv, u8 scanSource);
-s32 wilc_set_join_req(struct host_if_drv *hWFIDrv, u8 *pu8bssid,
-			  const u8 *pu8ssid, size_t ssidLen,
-			  const u8 *pu8IEs, size_t IEsLen,
-			  wilc_connect_result pfConnectResult, void *pvUserArg,
-			  u8 u8security, enum AUTHTYPE tenuAuth_type,
-			  u8 u8channel, void *pJoinParams);
-s32 wilc_flush_join_req(struct host_if_drv *hWFIDrv);
-s32 wilc_disconnect(struct host_if_drv *hWFIDrv, u16 u16ReasonCode);
-int wilc_set_mac_chnl_num(struct host_if_drv *wfi_drv, u8 channel);
-s32 wilc_get_rssi(struct host_if_drv *hWFIDrv, s8 *ps8Rssi);
-s32 wilc_scan(struct host_if_drv *hWFIDrv, u8 u8ScanSource,
-		  u8 u8ScanType, u8 *pu8ChnlFreqList,
-		  u8 u8ChnlListLen, const u8 *pu8IEs,
-		  size_t IEsLen, wilc_scan_result ScanResult,
-		  void *pvUserArg, struct hidden_network *pstrHiddenNetwork);
-s32 wilc_hif_set_cfg(struct host_if_drv *hWFIDrv,
+s32 wilc_set_join_req(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+		      u8 *pu8bssid, const u8 *pu8ssid, size_t ssidLen,
+		      const u8 *pu8IEs, size_t IEsLen,
+		      wilc_connect_result pfConnectResult, void *pvUserArg,
+		      u8 u8security, enum AUTHTYPE tenuAuth_type,
+		      u8 u8channel, void *pJoinParams);
+s32 wilc_flush_join_req(struct wilc_vif *vif, struct host_if_drv *hif_drv);
+s32 wilc_disconnect(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+		    u16 u16ReasonCode);
+int wilc_set_mac_chnl_num(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+			  u8 channel);
+s32 wilc_get_rssi(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+		  s8 *ps8Rssi);
+s32 wilc_scan(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+	      u8 u8ScanSource, u8 u8ScanType, u8 *pu8ChnlFreqList,
+	      u8 u8ChnlListLen, const u8 *pu8IEs,
+	      size_t IEsLen, wilc_scan_result ScanResult,
+	      void *pvUserArg, struct hidden_network *pstrHiddenNetwork);
+s32 wilc_hif_set_cfg(struct wilc_vif *vif, struct host_if_drv *hif_drv,
 		struct cfg_param_val *pstrCfgParamVal);
 s32 wilc_init(struct net_device *dev, struct host_if_drv **phWFIDrv);
-s32 wilc_deinit(struct host_if_drv *hWFIDrv);
-s32 wilc_add_beacon(struct host_if_drv *hWFIDrv, u32 u32Interval,
-			u32 u32DTIMPeriod,
-			u32 u32HeadLen,
-			u8 *pu8Head,
-			u32 u32TailLen,
-			u8 *pu8tail);
-int wilc_del_beacon(struct host_if_drv *hif_drv);
-int wilc_add_station(struct host_if_drv *hif_drv,
-			 struct add_sta_param *sta_param);
-s32 wilc_del_allstation(struct host_if_drv *hWFIDrv,
+s32 wilc_deinit(struct wilc_vif *vif, struct host_if_drv *hif_drv);
+s32 wilc_add_beacon(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+		    u32 u32Interval,
+		    u32 u32DTIMPeriod, u32 u32HeadLen, u8 *pu8Head,
+		    u32 u32TailLen, u8 *pu8Tail);
+int wilc_del_beacon(struct wilc_vif *vif, struct host_if_drv *hif_drv);
+int wilc_add_station(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+		     struct add_sta_param *sta_param);
+s32 wilc_del_allstation(struct wilc_vif *vif, struct host_if_drv *hif_drv,
 			    u8 pu8MacAddr[][ETH_ALEN]);
-int wilc_del_station(struct host_if_drv *hif_drv, const u8 *mac_addr);
-s32 wilc_edit_station(struct host_if_drv *hWFIDrv,
+int wilc_del_station(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+		     const u8 *mac_addr);
+s32 wilc_edit_station(struct wilc_vif *vif, struct host_if_drv *hif_drv,
 			  struct add_sta_param *pstrStaParams);
-s32 wilc_set_power_mgmt(struct host_if_drv *hWFIDrv,
-			    bool bIsEnabled,
-			    u32 u32Timeout);
-s32 wilc_setup_multicast_filter(struct host_if_drv *hWFIDrv,
-				    bool bIsEnabled,
-				    u32 u32count);
-s32 wilc_setup_ipaddress(struct host_if_drv *hWFIDrv,
-			     u8 *pu8IPAddr,
-			     u8 idx);
-s32 wilc_del_all_rx_ba_session(struct host_if_drv *hWFIDrv,
-				  char *pBSSID,
-				  char TID);
-s32 wilc_remain_on_channel(struct host_if_drv *hWFIDrv,
-			       u32 u32SessionID,
-			       u32 u32duration,
-			       u16 chan,
-			       wilc_remain_on_chan_expired RemainOnChanExpired,
-			       wilc_remain_on_chan_ready RemainOnChanReady,
-			       void *pvUserArg);
-s32 wilc_listen_state_expired(struct host_if_drv *hWFIDrv, u32 u32SessionID);
-s32 wilc_frame_register(struct host_if_drv *hWFIDrv,
-			    u16 u16FrameType,
-			    bool bReg);
-int wilc_set_wfi_drv_handler(struct host_if_drv *address);
-int wilc_set_operation_mode(struct host_if_drv *wfi_drv, u32 mode);
+s32 wilc_set_power_mgmt(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+			    bool bIsEnabled, u32 u32Timeout);
+s32 wilc_setup_multicast_filter(struct wilc_vif *vif,
+				struct host_if_drv *hif_drv,
+				bool bIsEnabled,
+				u32 u32count);
+s32 wilc_setup_ipaddress(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+			 u8 *u16ipadd, u8 idx);
+s32 wilc_del_all_rx_ba_session(struct wilc_vif *vif,
+			       struct host_if_drv *hif_drv,
+			       char *pBSSID,
+			       char TID);
+s32 wilc_remain_on_channel(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+			   u32 u32SessionID, u32 u32duration, u16 chan,
+			   wilc_remain_on_chan_expired RemainOnChanExpired,
+			   wilc_remain_on_chan_ready RemainOnChanReady,
+			   void *pvUserArg);
+s32 wilc_listen_state_expired(struct wilc_vif *vif,
+			      struct host_if_drv *hif_drv, u32 u32SessionID);
+s32 wilc_frame_register(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+			u16 u16FrameType, bool bReg);
+int wilc_set_wfi_drv_handler(struct wilc_vif *vif, struct host_if_drv *hif_drv);
+int wilc_set_operation_mode(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+			    u32 mode);
 
 void wilc_free_join_params(void *pJoinParams);
 
-s32 wilc_get_statistics(struct host_if_drv *hWFIDrv,
-			    struct rf_info *pstrStatistics);
-void wilc_resolve_disconnect_aberration(struct host_if_drv *hif_drv);
+s32 wilc_get_statistics(struct wilc_vif *vif, struct host_if_drv *hif_drv,
+			struct rf_info *pstrStatistics);
+void wilc_resolve_disconnect_aberration(struct wilc_vif *vif,
+					struct host_if_drv *hif_drv);
 
 extern bool wilc_optaining_ip;
 extern u8 wilc_connected_ssid[6];
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index bb3ff49..6074996 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -112,7 +112,7 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 		}
 
 		if (wilc_enable_ps)
-			wilc_set_power_mgmt(hif_drv, 1, 0);
+			wilc_set_power_mgmt(vif, hif_drv, 1, 0);
 
 		PRINT_D(GENERIC_DBG, "[%s] Up IP\n", dev_iface->ifa_label);
 
@@ -120,7 +120,7 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 		PRINT_D(GENERIC_DBG, "IP add=%d:%d:%d:%d\n",
 			ip_addr_buf[0], ip_addr_buf[1],
 			ip_addr_buf[2], ip_addr_buf[3]);
-		wilc_setup_ipaddress(hif_drv, ip_addr_buf, vif->u8IfIdx);
+		wilc_setup_ipaddress(vif, hif_drv, ip_addr_buf, vif->u8IfIdx);
 
 		break;
 
@@ -134,9 +134,9 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 		}
 
 		if (memcmp(dev_iface->ifa_label, wlan_dev_name, 5) == 0)
-			wilc_set_power_mgmt(hif_drv, 0, 0);
+			wilc_set_power_mgmt(vif, hif_drv, 0, 0);
 
-		wilc_resolve_disconnect_aberration(hif_drv);
+		wilc_resolve_disconnect_aberration(vif, hif_drv);
 
 		PRINT_D(GENERIC_DBG, "[%s] Down IP\n", dev_iface->ifa_label);
 
@@ -145,7 +145,7 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 			ip_addr_buf[0], ip_addr_buf[1],
 			ip_addr_buf[2], ip_addr_buf[3]);
 
-		wilc_setup_ipaddress(hif_drv, ip_addr_buf, vif->u8IfIdx);
+		wilc_setup_ipaddress(vif, hif_drv, ip_addr_buf, vif->u8IfIdx);
 
 		break;
 
@@ -1030,7 +1030,7 @@ int wilc_mac_open(struct net_device *ndev)
 
 	wilc_set_machw_change_vir_if(ndev, false);
 
-	wilc_get_mac_address(priv->hWILCWFIDrv, mac_add);
+	wilc_get_mac_address(vif, priv->hWILCWFIDrv, mac_add);
 	PRINT_D(INIT_DBG, "Mac address: %pM\n", mac_add);
 
 	for (i = 0; i < wl->vif_num; i++) {
@@ -1076,9 +1076,11 @@ static void wilc_set_multicast_list(struct net_device *dev)
 	struct netdev_hw_addr *ha;
 	struct wilc_priv *priv;
 	struct host_if_drv *hif_drv;
+	struct wilc_vif *vif;
 	int i = 0;
 
 	priv = wiphy_priv(dev->ieee80211_ptr->wiphy);
+	vif = netdev_priv(dev);
 	hif_drv = (struct host_if_drv *)priv->hWILCWFIDrv;
 
 	if (!dev)
@@ -1095,13 +1097,13 @@ static void wilc_set_multicast_list(struct net_device *dev)
 	if ((dev->flags & IFF_ALLMULTI) ||
 	    (dev->mc.count) > WILC_MULTICAST_TABLE_SIZE) {
 		PRINT_D(INIT_DBG, "Disable multicast filter, retrive all multicast packets\n");
-		wilc_setup_multicast_filter(hif_drv, false, 0);
+		wilc_setup_multicast_filter(vif, hif_drv, false, 0);
 		return;
 	}
 
 	if ((dev->mc.count) == 0) {
 		PRINT_D(INIT_DBG, "Enable multicast filter, retrive directed packets only.\n");
-		wilc_setup_multicast_filter(hif_drv, true, 0);
+		wilc_setup_multicast_filter(vif, hif_drv, true, 0);
 		return;
 	}
 
@@ -1117,7 +1119,7 @@ static void wilc_set_multicast_list(struct net_device *dev)
 		i++;
 	}
 
-	wilc_setup_multicast_filter(hif_drv, true, (dev->mc.count));
+	wilc_setup_multicast_filter(vif, hif_drv, true, (dev->mc.count));
 
 	return;
 }
@@ -1289,7 +1291,7 @@ static int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 
 			if (strncasecmp(buff, "RSSI", length) == 0) {
 				priv = wiphy_priv(vif->ndev->ieee80211_ptr->wiphy);
-				ret = wilc_get_rssi(priv->hWILCWFIDrv, &rssi);
+				ret = wilc_get_rssi(vif, priv->hWILCWFIDrv, &rssi);
 				if (ret)
 					PRINT_ER("Failed to send get rssi param's message queue ");
 				PRINT_INFO(GENERIC_DBG, "RSSI :%d\n", rssi);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 87f8d0d..309a0cc 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -595,14 +595,16 @@ static int set_channel(struct wiphy *wiphy,
 	u32 channelnum = 0;
 	struct wilc_priv *priv;
 	int result = 0;
+	struct wilc_vif *vif;
 
 	priv = wiphy_priv(wiphy);
+	vif = netdev_priv(priv->dev);
 
 	channelnum = ieee80211_frequency_to_channel(chandef->chan->center_freq);
 	PRINT_D(CFG80211_DBG, "Setting channel %d with frequency %d\n", channelnum, chandef->chan->center_freq);
 
 	curr_channel = channelnum;
-	result = wilc_set_mac_chnl_num(priv->hWILCWFIDrv, channelnum);
+	result = wilc_set_mac_chnl_num(vif, priv->hWILCWFIDrv, channelnum);
 
 	if (result != 0)
 		PRINT_ER("Error in setting channel %d\n", channelnum);
@@ -617,14 +619,16 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 	s32 s32Error = 0;
 	u8 au8ScanChanList[MAX_NUM_SCANNED_NETWORKS];
 	struct hidden_network strHiddenNetwork;
+	struct wilc_vif *vif;
 
 	priv = wiphy_priv(wiphy);
+	vif = netdev_priv(priv->dev);
 
 	priv->pstrScanReq = request;
 
 	priv->u32RcvdChCount = 0;
 
-	wilc_set_wfi_drv_handler(priv->hWILCWFIDrv);
+	wilc_set_wfi_drv_handler(vif, priv->hWILCWFIDrv);
 	reset_shadow_found();
 
 	priv->bCfgScanning = true;
@@ -656,13 +660,13 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 				}
 			}
 			PRINT_D(CFG80211_DBG, "Trigger Scan Request\n");
-			s32Error = wilc_scan(priv->hWILCWFIDrv, USER_SCAN, ACTIVE_SCAN,
+			s32Error = wilc_scan(vif, priv->hWILCWFIDrv, USER_SCAN, ACTIVE_SCAN,
 						 au8ScanChanList, request->n_channels,
 						 (const u8 *)request->ie, request->ie_len,
 						 CfgScanResult, (void *)priv, &strHiddenNetwork);
 		} else {
 			PRINT_D(CFG80211_DBG, "Trigger Scan Request\n");
-			s32Error = wilc_scan(priv->hWILCWFIDrv, USER_SCAN, ACTIVE_SCAN,
+			s32Error = wilc_scan(vif, priv->hWILCWFIDrv, USER_SCAN, ACTIVE_SCAN,
 						 au8ScanChanList, request->n_channels,
 						 (const u8 *)request->ie, request->ie_len,
 						 CfgScanResult, (void *)priv, NULL);
@@ -694,13 +698,14 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	struct wilc_priv *priv;
 	struct host_if_drv *pstrWFIDrv;
 	tstrNetworkInfo *pstrNetworkInfo = NULL;
-
+	struct wilc_vif *vif;
 
 	wilc_connecting = 1;
 	priv = wiphy_priv(wiphy);
+	vif = netdev_priv(priv->dev);
 	pstrWFIDrv = (struct host_if_drv *)(priv->hWILCWFIDrv);
 
-	wilc_set_wfi_drv_handler(priv->hWILCWFIDrv);
+	wilc_set_wfi_drv_handler(vif, priv->hWILCWFIDrv);
 
 	PRINT_D(CFG80211_DBG, "Connecting to SSID [%s] on netdev [%p] host if [%p]\n", sme->ssid, dev, priv->hWILCWFIDrv);
 	if (!(strncmp(sme->ssid, "DIRECT-", 7))) {
@@ -787,8 +792,8 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 			g_key_wep_params.key_idx = sme->key_idx;
 			g_wep_keys_saved = true;
 
-			wilc_set_wep_default_keyid(priv->hWILCWFIDrv, sme->key_idx);
-			wilc_add_wep_key_bss_sta(priv->hWILCWFIDrv, sme->key, sme->key_len, sme->key_idx);
+			wilc_set_wep_default_keyid(vif, priv->hWILCWFIDrv, sme->key_idx);
+			wilc_add_wep_key_bss_sta(vif, priv->hWILCWFIDrv, sme->key, sme->key_len, sme->key_idx);
 		} else if (sme->crypto.cipher_group == WLAN_CIPHER_SUITE_WEP104)   {
 			u8security = ENCRYPT_ENABLED | WEP | WEP_EXTENDED;
 			pcgroup_encrypt_val = "WEP104";
@@ -804,8 +809,8 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 			g_key_wep_params.key_idx = sme->key_idx;
 			g_wep_keys_saved = true;
 
-			wilc_set_wep_default_keyid(priv->hWILCWFIDrv, sme->key_idx);
-			wilc_add_wep_key_bss_sta(priv->hWILCWFIDrv, sme->key, sme->key_len, sme->key_idx);
+			wilc_set_wep_default_keyid(vif, priv->hWILCWFIDrv, sme->key_idx);
+			wilc_add_wep_key_bss_sta(vif, priv->hWILCWFIDrv, sme->key, sme->key_len, sme->key_idx);
 		} else if (sme->crypto.wpa_versions & NL80211_WPA_VERSION_2)   {
 			if (sme->crypto.cipher_group == WLAN_CIPHER_SUITE_TKIP)	{
 				u8security = ENCRYPT_ENABLED | WPA2 | TKIP;
@@ -890,7 +895,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 
 	wilc_wlan_set_bssid(dev, pstrNetworkInfo->au8bssid);
 
-	s32Error = wilc_set_join_req(priv->hWILCWFIDrv, pstrNetworkInfo->au8bssid, sme->ssid,
+	s32Error = wilc_set_join_req(vif, priv->hWILCWFIDrv, pstrNetworkInfo->au8bssid, sme->ssid,
 					 sme->ssid_len, sme->ie, sme->ie_len,
 					 CfgConnectResult, (void *)priv, u8security,
 					 tenuAuth_type, pstrNetworkInfo->u8channel,
@@ -911,10 +916,12 @@ static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_co
 	s32 s32Error = 0;
 	struct wilc_priv *priv;
 	struct host_if_drv *pstrWFIDrv;
+	struct wilc_vif *vif;
 	u8 NullBssid[ETH_ALEN] = {0};
 
 	wilc_connecting = 0;
 	priv = wiphy_priv(wiphy);
+	vif = netdev_priv(priv->dev);
 
 	pstrWFIDrv = (struct host_if_drv *)priv->hWILCWFIDrv;
 	if (!pstrWFIDrv->p2p_connect)
@@ -928,7 +935,7 @@ static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_co
 	wilc_ie = false;
 	pstrWFIDrv->p2p_timeout = 0;
 
-	s32Error = wilc_disconnect(priv->hWILCWFIDrv, reason_code);
+	s32Error = wilc_disconnect(vif, priv->hWILCWFIDrv, reason_code);
 	if (s32Error != 0) {
 		PRINT_ER("Error in disconnecting: Error(%d)\n", s32Error);
 		s32Error = -EINVAL;
@@ -988,7 +995,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 			else
 				u8mode = ENCRYPT_ENABLED | WEP | WEP_EXTENDED;
 
-			wilc_add_wep_key_bss_ap(priv->hWILCWFIDrv, params->key, params->key_len, key_index, u8mode, tenuAuth_type);
+			wilc_add_wep_key_bss_ap(vif, priv->hWILCWFIDrv, params->key, params->key_len, key_index, u8mode, tenuAuth_type);
 			break;
 		}
 		if (memcmp(params->key, priv->WILC_WFI_wep_key[key_index], params->key_len)) {
@@ -1002,7 +1009,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 				for (i = 0; i < params->key_len; i++)
 					PRINT_INFO(CFG80211_DBG, "WEP key value[%d] = %d\n", i, params->key[i]);
 			}
-			wilc_add_wep_key_bss_sta(priv->hWILCWFIDrv, params->key, params->key_len, key_index);
+			wilc_add_wep_key_bss_sta(vif, priv->hWILCWFIDrv, params->key, params->key_len, key_index);
 		}
 
 		break;
@@ -1059,7 +1066,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 				}
 
 
-				wilc_add_rx_gtk(priv->hWILCWFIDrv, params->key, KeyLen,
+				wilc_add_rx_gtk(vif, priv->hWILCWFIDrv, params->key, KeyLen,
 						    key_index, params->seq_len, params->seq, pu8RxMic, pu8TxMic, AP_MODE, u8gmode);
 
 			} else {
@@ -1103,7 +1110,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 				priv->wilc_ptk[key_index]->key_len = params->key_len;
 				priv->wilc_ptk[key_index]->seq_len = params->seq_len;
 
-				wilc_add_ptk(priv->hWILCWFIDrv, params->key, KeyLen, mac_addr,
+				wilc_add_ptk(vif, priv->hWILCWFIDrv, params->key, KeyLen, mac_addr,
 						 pu8RxMic, pu8TxMic, AP_MODE, u8pmode, key_index);
 			}
 			break;
@@ -1143,7 +1150,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 					g_gtk_keys_saved = true;
 				}
 
-				wilc_add_rx_gtk(priv->hWILCWFIDrv, params->key, KeyLen,
+				wilc_add_rx_gtk(vif, priv->hWILCWFIDrv, params->key, KeyLen,
 						    key_index, params->seq_len, params->seq, pu8RxMic, pu8TxMic, STATION_MODE, u8mode);
 			} else {
 				if (params->key_len > 16 && params->cipher == WLAN_CIPHER_SUITE_TKIP) {
@@ -1177,7 +1184,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 					g_ptk_keys_saved = true;
 				}
 
-				wilc_add_ptk(priv->hWILCWFIDrv, params->key, KeyLen, mac_addr,
+				wilc_add_ptk(vif, priv->hWILCWFIDrv, params->key, KeyLen, mac_addr,
 						 pu8RxMic, pu8TxMic, STATION_MODE, u8mode, key_index);
 				PRINT_D(CFG80211_DBG, "Adding pairwise key\n");
 				if (INFO) {
@@ -1254,7 +1261,7 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 		priv->WILC_WFI_wep_key_len[key_index] = 0;
 
 		PRINT_D(CFG80211_DBG, "Removing WEP key with index = %d\n", key_index);
-		wilc_remove_wep_key(priv->hWILCWFIDrv, key_index);
+		wilc_remove_wep_key(vif, priv->hWILCWFIDrv, key_index);
 	} else {
 		PRINT_D(CFG80211_DBG, "Removing all installed keys\n");
 		wilc_remove_key(priv->hWILCWFIDrv, mac_addr);
@@ -1305,14 +1312,15 @@ static int set_default_key(struct wiphy *wiphy, struct net_device *netdev, u8 ke
 			   bool unicast, bool multicast)
 {
 	struct wilc_priv *priv;
-
+	struct wilc_vif *vif;
 
 	priv = wiphy_priv(wiphy);
+	vif = netdev_priv(priv->dev);
 
 	PRINT_D(CFG80211_DBG, "Setting default key with idx = %d\n", key_index);
 
 	if (key_index != priv->WILC_WFI_wep_default) {
-		wilc_set_wep_default_keyid(priv->hWILCWFIDrv, key_index);
+		wilc_set_wep_default_keyid(vif, priv->hWILCWFIDrv, key_index);
 	}
 
 	return 0;
@@ -1348,7 +1356,7 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 
 		sinfo->filled |= BIT(NL80211_STA_INFO_INACTIVE_TIME);
 
-		wilc_get_inactive_time(priv->hWILCWFIDrv, mac, &(inactive_time));
+		wilc_get_inactive_time(vif, priv->hWILCWFIDrv, mac, &(inactive_time));
 		sinfo->inactive_time = 1000 * inactive_time;
 		PRINT_D(CFG80211_DBG, "Inactive time %d\n", sinfo->inactive_time);
 	}
@@ -1356,7 +1364,7 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 	if (vif->iftype == STATION_MODE) {
 		struct rf_info strStatistics;
 
-		wilc_get_statistics(priv->hWILCWFIDrv, &strStatistics);
+		wilc_get_statistics(vif, priv->hWILCWFIDrv, &strStatistics);
 
 		sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL) |
 						BIT(NL80211_STA_INFO_RX_PACKETS) |
@@ -1394,8 +1402,10 @@ static int set_wiphy_params(struct wiphy *wiphy, u32 changed)
 	s32 s32Error = 0;
 	struct cfg_param_val pstrCfgParamVal;
 	struct wilc_priv *priv;
+	struct wilc_vif *vif;
 
 	priv = wiphy_priv(wiphy);
+	vif = netdev_priv(priv->dev);
 
 	pstrCfgParamVal.flag = 0;
 	PRINT_D(CFG80211_DBG, "Setting Wiphy params\n");
@@ -1425,7 +1435,7 @@ static int set_wiphy_params(struct wiphy *wiphy, u32 changed)
 	}
 
 	PRINT_D(CFG80211_DBG, "Setting CFG params in the host interface\n");
-	s32Error = wilc_hif_set_cfg(priv->hWILCWFIDrv, &pstrCfgParamVal);
+	s32Error = wilc_hif_set_cfg(vif, priv->hWILCWFIDrv, &pstrCfgParamVal);
 	if (s32Error)
 		PRINT_ER("Error in setting WIPHY PARAMS\n");
 
@@ -1439,9 +1449,10 @@ static int set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 	u32 i;
 	s32 s32Error = 0;
 	u8 flag = 0;
-
+	struct wilc_vif *vif;
 	struct wilc_priv *priv = wiphy_priv(wiphy);
 
+	vif = netdev_priv(priv->dev);
 	PRINT_D(CFG80211_DBG, "Setting PMKSA\n");
 
 
@@ -1468,7 +1479,7 @@ static int set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 
 	if (!s32Error) {
 		PRINT_D(CFG80211_DBG, "Setting pmkid in the host interface\n");
-		s32Error = wilc_set_pmkid_info(priv->hWILCWFIDrv, &priv->pmkid_list);
+		s32Error = wilc_set_pmkid_info(vif, priv->hWILCWFIDrv, &priv->pmkid_list);
 	}
 	return s32Error;
 }
@@ -1758,8 +1769,10 @@ static int remain_on_channel(struct wiphy *wiphy,
 {
 	s32 s32Error = 0;
 	struct wilc_priv *priv;
+	struct wilc_vif *vif;
 
 	priv = wiphy_priv(wiphy);
+	vif = netdev_priv(priv->dev);
 
 	PRINT_D(GENERIC_DBG, "Remaining on channel %d\n", chan->hw_value);
 
@@ -1776,7 +1789,7 @@ static int remain_on_channel(struct wiphy *wiphy,
 	priv->strRemainOnChanParams.u32ListenDuration = duration;
 	priv->strRemainOnChanParams.u32ListenSessionID++;
 
-	s32Error = wilc_remain_on_channel(priv->hWILCWFIDrv
+	s32Error = wilc_remain_on_channel(vif, priv->hWILCWFIDrv
 					      , priv->strRemainOnChanParams.u32ListenSessionID
 					      , duration
 					      , chan->hw_value
@@ -1793,12 +1806,14 @@ static int cancel_remain_on_channel(struct wiphy *wiphy,
 {
 	s32 s32Error = 0;
 	struct wilc_priv *priv;
+	struct wilc_vif *vif;
 
 	priv = wiphy_priv(wiphy);
+	vif = netdev_priv(priv->dev);
 
 	PRINT_D(CFG80211_DBG, "Cancel remain on channel\n");
 
-	s32Error = wilc_listen_state_expired(priv->hWILCWFIDrv, priv->strRemainOnChanParams.u32ListenSessionID);
+	s32Error = wilc_listen_state_expired(vif, priv->hWILCWFIDrv, priv->strRemainOnChanParams.u32ListenSessionID);
 	return s32Error;
 }
 
@@ -1846,7 +1861,7 @@ static int mgmt_tx(struct wiphy *wiphy,
 		if (ieee80211_is_probe_resp(mgmt->frame_control)) {
 			PRINT_D(GENERIC_DBG, "TX: Probe Response\n");
 			PRINT_D(GENERIC_DBG, "Setting channel: %d\n", chan->hw_value);
-			wilc_set_mac_chnl_num(priv->hWILCWFIDrv, chan->hw_value);
+			wilc_set_mac_chnl_num(vif, priv->hWILCWFIDrv, chan->hw_value);
 			curr_channel = chan->hw_value;
 		} else if (ieee80211_is_action(mgmt->frame_control))   {
 			PRINT_D(GENERIC_DBG, "ACTION FRAME:%x\n", (u16)mgmt->frame_control);
@@ -1856,7 +1871,7 @@ static int mgmt_tx(struct wiphy *wiphy,
 				if (buf[ACTION_SUBTYPE_ID] != PUBLIC_ACT_VENDORSPEC ||
 				    buf[P2P_PUB_ACTION_SUBTYPE] != GO_NEG_CONF)	{
 					PRINT_D(GENERIC_DBG, "Setting channel: %d\n", chan->hw_value);
-					wilc_set_mac_chnl_num(priv->hWILCWFIDrv, chan->hw_value);
+					wilc_set_mac_chnl_num(vif, priv->hWILCWFIDrv, chan->hw_value);
 					curr_channel = chan->hw_value;
 				}
 				switch (buf[ACTION_SUBTYPE_ID])	{
@@ -2002,7 +2017,7 @@ void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
 		PRINT_D(GENERIC_DBG, "Return since mac is closed\n");
 		return;
 	}
-	wilc_frame_register(priv->hWILCWFIDrv, frame_type, reg);
+	wilc_frame_register(vif, priv->hWILCWFIDrv, frame_type, reg);
 }
 
 static int set_cqm_rssi_config(struct wiphy *wiphy, struct net_device *dev,
@@ -2016,6 +2031,7 @@ static int dump_station(struct wiphy *wiphy, struct net_device *dev,
 			int idx, u8 *mac, struct station_info *sinfo)
 {
 	struct wilc_priv *priv;
+	struct wilc_vif *vif;
 
 	PRINT_D(CFG80211_DBG, "Dumping station information\n");
 
@@ -2023,10 +2039,11 @@ static int dump_station(struct wiphy *wiphy, struct net_device *dev,
 		return -ENOENT;
 
 	priv = wiphy_priv(wiphy);
+	vif = netdev_priv(priv->dev);
 
 	sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
 
-	wilc_get_rssi(priv->hWILCWFIDrv, &(sinfo->signal));
+	wilc_get_rssi(vif, priv->hWILCWFIDrv, &(sinfo->signal));
 
 	return 0;
 }
@@ -2035,6 +2052,7 @@ static int set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 			  bool enabled, int timeout)
 {
 	struct wilc_priv *priv;
+	struct wilc_vif *vif;
 
 	PRINT_D(CFG80211_DBG, " Power save Enabled= %d , TimeOut = %d\n", enabled, timeout);
 
@@ -2042,13 +2060,14 @@ static int set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 		return -ENOENT;
 
 	priv = wiphy_priv(wiphy);
+	vif = netdev_priv(priv->dev);
 	if (!priv->hWILCWFIDrv) {
 		PRINT_ER("Driver is NULL\n");
 		return -EIO;
 	}
 
 	if (wilc_enable_ps)
-		wilc_set_power_mgmt(priv->hWILCWFIDrv, enabled, timeout);
+		wilc_set_power_mgmt(vif, priv->hWILCWFIDrv, enabled, timeout);
 
 
 	return 0;
@@ -2096,7 +2115,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		vif->iftype = STATION_MODE;
 
 		if (wl->initialized) {
-			wilc_del_all_rx_ba_session(priv->hWILCWFIDrv,
+			wilc_del_all_rx_ba_session(vif, priv->hWILCWFIDrv,
 						   wl->vif[0]->bssid, TID);
 			wilc_wait_msg_queue_idle();
 
@@ -2107,21 +2126,21 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			wilc_initialized = 1;
 			vif->iftype = interface_type;
 
-			wilc_set_wfi_drv_handler(wl->vif[0]->hif_drv);
-			wilc_set_mac_address(wl->vif[0]->hif_drv,
+			wilc_set_wfi_drv_handler(vif, wl->vif[0]->hif_drv);
+			wilc_set_mac_address(vif, wl->vif[0]->hif_drv,
 						wl->vif[0]->src_addr);
-			wilc_set_operation_mode(priv->hWILCWFIDrv, STATION_MODE);
+			wilc_set_operation_mode(vif, priv->hWILCWFIDrv, STATION_MODE);
 
 			if (g_wep_keys_saved) {
-				wilc_set_wep_default_keyid(wl->vif[0]->hif_drv,
+				wilc_set_wep_default_keyid(vif, wl->vif[0]->hif_drv,
 							     g_key_wep_params.key_idx);
-				wilc_add_wep_key_bss_sta(wl->vif[0]->hif_drv,
+				wilc_add_wep_key_bss_sta(vif, wl->vif[0]->hif_drv,
 							     g_key_wep_params.key,
 							     g_key_wep_params.key_len,
 							     g_key_wep_params.key_idx);
 			}
 
-			wilc_flush_join_req(priv->hWILCWFIDrv);
+			wilc_flush_join_req(vif, priv->hWILCWFIDrv);
 
 			if (g_ptk_keys_saved && g_gtk_keys_saved) {
 				PRINT_D(CFG80211_DBG, "ptk %x %x %x\n", g_key_ptk_params.key[0],
@@ -2149,24 +2168,24 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 				for (i = 0; i < num_reg_frame; i++) {
 					PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", vif->g_struct_frame_reg[i].frame_type,
 						vif->g_struct_frame_reg[i].reg);
-					wilc_frame_register(priv->hWILCWFIDrv,
+					wilc_frame_register(vif, priv->hWILCWFIDrv,
 								vif->g_struct_frame_reg[i].frame_type,
 								vif->g_struct_frame_reg[i].reg);
 				}
 			}
 
 			wilc_enable_ps = true;
-			wilc_set_power_mgmt(priv->hWILCWFIDrv, 1, 0);
+			wilc_set_power_mgmt(vif, priv->hWILCWFIDrv, 1, 0);
 		}
 		break;
 
 	case NL80211_IFTYPE_P2P_CLIENT:
 		wilc_enable_ps = false;
-		wilc_set_power_mgmt(priv->hWILCWFIDrv, 0, 0);
+		wilc_set_power_mgmt(vif, priv->hWILCWFIDrv, 0, 0);
 		wilc_connecting = 0;
 		PRINT_D(HOSTAPD_DBG, "Interface type = NL80211_IFTYPE_P2P_CLIENT\n");
 
-		wilc_del_all_rx_ba_session(priv->hWILCWFIDrv,
+		wilc_del_all_rx_ba_session(vif, priv->hWILCWFIDrv,
 					   wl->vif[0]->bssid, TID);
 
 		dev->ieee80211_ptr->iftype = type;
@@ -2184,21 +2203,21 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			wilc1000_wlan_init(dev, vif);
 			wilc_initialized = 1;
 
-			wilc_set_wfi_drv_handler(wl->vif[0]->hif_drv);
-			wilc_set_mac_address(wl->vif[0]->hif_drv,
+			wilc_set_wfi_drv_handler(vif, wl->vif[0]->hif_drv);
+			wilc_set_mac_address(vif, wl->vif[0]->hif_drv,
 						wl->vif[0]->src_addr);
-			wilc_set_operation_mode(priv->hWILCWFIDrv, STATION_MODE);
+			wilc_set_operation_mode(vif, priv->hWILCWFIDrv, STATION_MODE);
 
 			if (g_wep_keys_saved) {
-				wilc_set_wep_default_keyid(wl->vif[0]->hif_drv,
+				wilc_set_wep_default_keyid(vif, wl->vif[0]->hif_drv,
 							   g_key_wep_params.key_idx);
-				wilc_add_wep_key_bss_sta(wl->vif[0]->hif_drv,
+				wilc_add_wep_key_bss_sta(vif, wl->vif[0]->hif_drv,
 							 g_key_wep_params.key,
 							 g_key_wep_params.key_len,
 							 g_key_wep_params.key_idx);
 			}
 
-			wilc_flush_join_req(priv->hWILCWFIDrv);
+			wilc_flush_join_req(vif, priv->hWILCWFIDrv);
 
 			if (g_ptk_keys_saved && g_gtk_keys_saved) {
 				PRINT_D(CFG80211_DBG, "ptk %x %x %x\n", g_key_ptk_params.key[0],
@@ -2229,7 +2248,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 				for (i = 0; i < num_reg_frame; i++) {
 					PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", vif->g_struct_frame_reg[i].frame_type,
 						vif->g_struct_frame_reg[i].reg);
-					wilc_frame_register(priv->hWILCWFIDrv,
+					wilc_frame_register(vif, priv->hWILCWFIDrv,
 								vif->g_struct_frame_reg[i].frame_type,
 								vif->g_struct_frame_reg[i].reg);
 				}
@@ -2256,7 +2275,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			for (i = 0; i < num_reg_frame; i++) {
 				PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", vif->g_struct_frame_reg[i].frame_type,
 					vif->g_struct_frame_reg[i].reg);
-				wilc_frame_register(priv->hWILCWFIDrv,
+				wilc_frame_register(vif, priv->hWILCWFIDrv,
 							vif->g_struct_frame_reg[i].frame_type,
 							vif->g_struct_frame_reg[i].reg);
 			}
@@ -2269,8 +2288,8 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		wilc_optaining_ip = true;
 		mod_timer(&wilc_during_ip_timer,
 			  jiffies + msecs_to_jiffies(during_ip_time));
-		wilc_set_power_mgmt(priv->hWILCWFIDrv, 0, 0);
-		wilc_del_all_rx_ba_session(priv->hWILCWFIDrv,
+		wilc_set_power_mgmt(vif, priv->hWILCWFIDrv, 0, 0);
+		wilc_del_all_rx_ba_session(vif, priv->hWILCWFIDrv,
 					   wl->vif[0]->bssid, TID);
 		wilc_enable_ps = false;
 		PRINT_D(HOSTAPD_DBG, "Interface type = NL80211_IFTYPE_GO\n");
@@ -2289,21 +2308,21 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		wilc1000_wlan_init(dev, vif);
 		wilc_initialized = 1;
 
-		wilc_set_wfi_drv_handler(wl->vif[0]->hif_drv);
-		wilc_set_mac_address(wl->vif[0]->hif_drv,
+		wilc_set_wfi_drv_handler(vif, wl->vif[0]->hif_drv);
+		wilc_set_mac_address(vif, wl->vif[0]->hif_drv,
 				     wl->vif[0]->src_addr);
-		wilc_set_operation_mode(priv->hWILCWFIDrv, AP_MODE);
+		wilc_set_operation_mode(vif, priv->hWILCWFIDrv, AP_MODE);
 
 		if (g_wep_keys_saved) {
-			wilc_set_wep_default_keyid(wl->vif[0]->hif_drv,
+			wilc_set_wep_default_keyid(vif, wl->vif[0]->hif_drv,
 						   g_key_wep_params.key_idx);
-			wilc_add_wep_key_bss_sta(wl->vif[0]->hif_drv,
+			wilc_add_wep_key_bss_sta(vif, wl->vif[0]->hif_drv,
 						     g_key_wep_params.key,
 						     g_key_wep_params.key_len,
 						     g_key_wep_params.key_idx);
 		}
 
-		wilc_flush_join_req(priv->hWILCWFIDrv);
+		wilc_flush_join_req(vif, priv->hWILCWFIDrv);
 
 		if (g_ptk_keys_saved && g_gtk_keys_saved) {
 			PRINT_D(CFG80211_DBG, "ptk %x %x %x cipher %x\n", g_key_ptk_params.key[0],
@@ -2333,7 +2352,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			for (i = 0; i < num_reg_frame; i++) {
 				PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", vif->g_struct_frame_reg[i].frame_type,
 					vif->g_struct_frame_reg[i].reg);
-				wilc_frame_register(priv->hWILCWFIDrv,
+				wilc_frame_register(vif, priv->hWILCWFIDrv,
 							vif->g_struct_frame_reg[i].frame_type,
 							vif->g_struct_frame_reg[i].reg);
 			}
@@ -2372,7 +2391,7 @@ static int start_ap(struct wiphy *wiphy, struct net_device *dev,
 
 	wilc_wlan_set_bssid(dev, wl->vif[0]->src_addr);
 
-	s32Error = wilc_add_beacon(priv->hWILCWFIDrv,
+	s32Error = wilc_add_beacon(vif, priv->hWILCWFIDrv,
 					settings->beacon_interval,
 					settings->dtim_period,
 					beacon->head_len, (u8 *)beacon->head,
@@ -2385,13 +2404,15 @@ static int change_beacon(struct wiphy *wiphy, struct net_device *dev,
 			 struct cfg80211_beacon_data *beacon)
 {
 	struct wilc_priv *priv;
+	struct wilc_vif *vif;
 	s32 s32Error = 0;
 
 	priv = wiphy_priv(wiphy);
+	vif = netdev_priv(priv->dev);
 	PRINT_D(HOSTAPD_DBG, "Setting beacon\n");
 
 
-	s32Error = wilc_add_beacon(priv->hWILCWFIDrv,
+	s32Error = wilc_add_beacon(vif, priv->hWILCWFIDrv,
 					0,
 					0,
 					beacon->head_len, (u8 *)beacon->head,
@@ -2404,18 +2425,20 @@ static int stop_ap(struct wiphy *wiphy, struct net_device *dev)
 {
 	s32 s32Error = 0;
 	struct wilc_priv *priv;
+	struct wilc_vif *vif;
 	u8 NullBssid[ETH_ALEN] = {0};
 
 	if (!wiphy)
 		return -EFAULT;
 
 	priv = wiphy_priv(wiphy);
+	vif = netdev_priv(priv->dev);
 
 	PRINT_D(HOSTAPD_DBG, "Deleting beacon\n");
 
 	wilc_wlan_set_bssid(dev, NullBssid);
 
-	s32Error = wilc_del_beacon(priv->hWILCWFIDrv);
+	s32Error = wilc_del_beacon(vif, priv->hWILCWFIDrv);
 
 	if (s32Error)
 		PRINT_ER("Host delete beacon fail\n");
@@ -2486,7 +2509,8 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(HOSTAPD_DBG, "Flag Set = %d\n",
 			strStaParams.flags_set);
 
-		s32Error = wilc_add_station(priv->hWILCWFIDrv, &strStaParams);
+		s32Error = wilc_add_station(vif, priv->hWILCWFIDrv,
+					    &strStaParams);
 		if (s32Error)
 			PRINT_ER("Host add station fail\n");
 	}
@@ -2514,12 +2538,12 @@ static int del_station(struct wiphy *wiphy, struct net_device *dev,
 
 		if (!mac) {
 			PRINT_D(HOSTAPD_DBG, "All associated stations\n");
-			s32Error = wilc_del_allstation(priv->hWILCWFIDrv, priv->assoc_stainfo.au8Sta_AssociatedBss);
+			s32Error = wilc_del_allstation(vif, priv->hWILCWFIDrv, priv->assoc_stainfo.au8Sta_AssociatedBss);
 		} else {
 			PRINT_D(HOSTAPD_DBG, "With mac address: %x%x%x%x%x%x\n", mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
 		}
 
-		s32Error = wilc_del_station(priv->hWILCWFIDrv, mac);
+		s32Error = wilc_del_station(vif, priv->hWILCWFIDrv, mac);
 
 		if (s32Error)
 			PRINT_ER("Host delete station fail\n");
@@ -2592,7 +2616,8 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(HOSTAPD_DBG, "Flag Set = %d\n",
 			strStaParams.flags_set);
 
-		s32Error = wilc_edit_station(priv->hWILCWFIDrv, &strStaParams);
+		s32Error = wilc_edit_station(vif, priv->hWILCWFIDrv,
+					     &strStaParams);
 		if (s32Error)
 			PRINT_ER("Host edit station fail\n");
 	}
@@ -2825,10 +2850,11 @@ int wilc_init_host_int(struct net_device *net)
 int wilc_deinit_host_int(struct net_device *net)
 {
 	int s32Error = 0;
-
+	struct wilc_vif *vif;
 	struct wilc_priv *priv;
 
 	priv = wdev_priv(net->ieee80211_ptr);
+	vif = netdev_priv(priv->dev);
 
 	priv->gbAutoRateAdjusted = false;
 
@@ -2836,7 +2862,7 @@ int wilc_deinit_host_int(struct net_device *net)
 
 	op_ifcs--;
 
-	s32Error = wilc_deinit(priv->hWILCWFIDrv);
+	s32Error = wilc_deinit(vif, priv->hWILCWFIDrv);
 
 	clear_shadow_scan();
 	if (op_ifcs == 0) {
-- 
1.9.1

