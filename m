Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:13814 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbbLNFoP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 00:44:15 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 09/12] staging: wilc1000: remove drv of struct host_if_msg
Date: Mon, 14 Dec 2015 14:47:00 +0900
Message-ID: <1450072023-13013-10-git-send-email-glen.lee@atmel.com> (sfid-20151214_064418_781259_242851D6)
In-Reply-To: <1450072023-13013-1-git-send-email-glen.lee@atmel.com>
References: <1450072023-13013-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch remove drv of struct host_if msg and it's related codes.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 50 ++-----------------------------
 1 file changed, 3 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 5bf2a47..39e93fa 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -193,7 +193,6 @@ union message_body {
 struct host_if_msg {
 	u16 id;
 	union message_body body;
-	struct host_if_drv *drv;
 	struct wilc_vif *vif;
 };
 
@@ -2787,7 +2786,6 @@ static int hostIFthread(void *pvArg)
 {
 	u32 u32Ret;
 	struct host_if_msg msg;
-	struct host_if_drv *hif_drv;
 	struct wilc *wilc = (struct wilc*)pvArg;
 	struct wilc_vif *vif;
 
@@ -2795,7 +2793,6 @@ static int hostIFthread(void *pvArg)
 
 	while (1) {
 		wilc_mq_recv(&hif_msg_q, &msg, sizeof(struct host_if_msg), &u32Ret);
-		hif_drv = (struct host_if_drv *)msg.drv;
 		vif = msg.vif;
 		if (msg.id == HOST_IF_MSG_EXIT) {
 			PRINT_D(GENERIC_DBG, "THREAD: Exiting HostIfThread\n");
@@ -2810,7 +2807,7 @@ static int hostIFthread(void *pvArg)
 		}
 
 		if (msg.id == HOST_IF_MSG_CONNECT &&
-		    hif_drv->usr_scan_req.scan_result) {
+		    vif->hif_drv->usr_scan_req.scan_result) {
 			PRINT_D(HOSTINF_DBG, "Requeue connect request till scan done received\n");
 			wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 			usleep_range(2 * 1000, 2 * 1000);
@@ -2860,7 +2857,7 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_RCVD_SCAN_COMPLETE:
-			del_timer(&hif_drv->scan_timer);
+			del_timer(&vif->hif_drv->scan_timer);
 			PRINT_D(HOSTINF_DBG, "scan completed successfully\n");
 
 			if (!wilc_wlan_get_num_conn_ifcs(wilc))
@@ -2868,7 +2865,7 @@ static int hostIFthread(void *pvArg)
 
 			Handle_ScanDone(msg.vif, SCAN_EVENT_DONE);
 
-			if (hif_drv->remain_on_ch_pending)
+			if (vif->hif_drv->remain_on_ch_pending)
 				Handle_RemainOnChan(msg.vif,
 						    &msg.body.remain_on_ch);
 
@@ -3052,7 +3049,6 @@ int wilc_remove_wep_key(struct wilc_vif *vif, u8 index)
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.type = WEP;
 	msg.body.key_info.action = REMOVEKEY;
-	msg.drv = hif_drv;
 	msg.vif = vif;
 	msg.body.key_info.attr.wep.index = index;
 
@@ -3081,7 +3077,6 @@ int wilc_set_wep_default_keyid(struct wilc_vif *vif, u8 index)
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.type = WEP;
 	msg.body.key_info.action = DEFAULTKEY;
-	msg.drv = hif_drv;
 	msg.vif = vif;
 	msg.body.key_info.attr.wep.index = index;
 
@@ -3110,7 +3105,6 @@ int wilc_add_wep_key_bss_sta(struct wilc_vif *vif, const u8 *key, u8 len,
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.type = WEP;
 	msg.body.key_info.action = ADDKEY;
-	msg.drv = hif_drv;
 	msg.vif = vif;
 	msg.body.key_info.attr.wep.key = kmemdup(key, len, GFP_KERNEL);
 	if (!msg.body.key_info.attr.wep.key)
@@ -3149,7 +3143,6 @@ int wilc_add_wep_key_bss_ap(struct wilc_vif *vif, const u8 *key, u8 len,
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.type = WEP;
 	msg.body.key_info.action = ADDKEY_AP;
-	msg.drv = hif_drv;
 	msg.vif = vif;
 	msg.body.key_info.attr.wep.key = kmemdup(key, len, GFP_KERNEL);
 	if (!msg.body.key_info.attr.wep.key)
@@ -3222,7 +3215,6 @@ s32 wilc_add_ptk(struct wilc_vif *vif, const u8 *pu8Ptk, u8 u8PtkKeylen,
 	msg.body.key_info.attr.wpa.key_len = u8KeyLen;
 	msg.body.key_info.attr.wpa.mac_addr = mac_addr;
 	msg.body.key_info.attr.wpa.mode = u8Ciphermode;
-	msg.drv = hif_drv;
 	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
@@ -3264,7 +3256,6 @@ s32 wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *pu8RxGtk, u8 u8GtkKeylen,
 
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.type = WPA_RX_GTK;
-	msg.drv = hif_drv;
 	msg.vif = vif;
 
 	if (mode == AP_MODE) {
@@ -3316,7 +3307,6 @@ s32 wilc_set_pmkid_info(struct wilc_vif *vif,
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.type = PMKSA;
 	msg.body.key_info.action = ADDKEY;
-	msg.drv = hif_drv;
 	msg.vif = vif;
 
 	for (i = 0; i < pu8PmkidInfoArray->numpmkid; i++) {
@@ -3337,13 +3327,11 @@ s32 wilc_get_mac_address(struct wilc_vif *vif, u8 *pu8MacAddress)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
-	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_GET_MAC_ADDRESS;
 	msg.body.get_mac_info.mac_addr = pu8MacAddress;
-	msg.drv = hif_drv;
 	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
@@ -3360,14 +3348,12 @@ s32 wilc_set_mac_address(struct wilc_vif *vif, u8 *pu8MacAddress)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
-	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	PRINT_D(GENERIC_DBG, "mac addr = %x:%x:%x\n", pu8MacAddress[0], pu8MacAddress[1], pu8MacAddress[2]);
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_MAC_ADDRESS;
 	memcpy(msg.body.set_mac_info.mac_addr, pu8MacAddress, ETH_ALEN);
-	msg.drv = hif_drv;
 	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
@@ -3419,7 +3405,6 @@ s32 wilc_set_join_req(struct wilc_vif *vif, u8 *pu8bssid, const u8 *pu8ssid,
 	msg.body.con_info.result = pfConnectResult;
 	msg.body.con_info.arg = pvUserArg;
 	msg.body.con_info.params = pJoinParams;
-	msg.drv = hif_drv ;
 	msg.vif = vif;
 
 	if (pu8bssid) {
@@ -3472,7 +3457,6 @@ s32 wilc_flush_join_req(struct wilc_vif *vif)
 	}
 
 	msg.id = HOST_IF_MSG_FLUSH_CONNECT;
-	msg.drv = hif_drv;
 	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
@@ -3498,7 +3482,6 @@ s32 wilc_disconnect(struct wilc_vif *vif, u16 u16ReasonCode)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_DISCONNECT;
-	msg.drv = hif_drv;
 	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
@@ -3556,7 +3539,6 @@ int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_CHANNEL;
 	msg.body.channel_info.set_ch = channel;
-	msg.drv = hif_drv;
 	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
@@ -3609,12 +3591,10 @@ int wilc_set_operation_mode(struct wilc_vif *vif, u32 mode)
 {
 	int result = 0;
 	struct host_if_msg msg;
-	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_OPERATION_MODE;
 	msg.body.mode.mode = mode;
-	msg.drv = hif_drv;
 	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
@@ -3642,7 +3622,6 @@ s32 wilc_get_inactive_time(struct wilc_vif *vif, const u8 *mac,
 	memcpy(msg.body.mac_info.mac, mac, ETH_ALEN);
 
 	msg.id = HOST_IF_MSG_GET_INACTIVETIME;
-	msg.drv = hif_drv;
 	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
@@ -3664,7 +3643,6 @@ s32 wilc_get_rssi(struct wilc_vif *vif, s8 *ps8Rssi)
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_GET_RSSI;
-	msg.drv = hif_drv;
 	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
@@ -3689,12 +3667,10 @@ s32 wilc_get_statistics(struct wilc_vif *vif, struct rf_info *pstrStatistics)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
-	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_GET_STATISTICS;
 	msg.body.data = (char *)pstrStatistics;
-	msg.drv = hif_drv;
 	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
@@ -3732,7 +3708,6 @@ s32 wilc_scan(struct wilc_vif *vif, u8 u8ScanSource, u8 u8ScanType,
 	} else
 		PRINT_D(HOSTINF_DBG, "pstrHiddenNetwork IS EQUAL TO NULL\n");
 
-	msg.drv = hif_drv;
 	msg.vif = vif;
 	msg.body.scan_info.src = u8ScanSource;
 	msg.body.scan_info.type = u8ScanType;
@@ -3776,7 +3751,6 @@ s32 wilc_hif_set_cfg(struct wilc_vif *vif,
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_CFG_PARAMS;
 	msg.body.cfg_info.cfg_attr_info = *pstrCfgParamVal;
-	msg.drv = hif_drv;
 	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
@@ -3957,7 +3931,6 @@ s32 wilc_deinit(struct wilc_vif *vif)
 			PRINT_D(HOSTINF_DBG, ">> Connect timer is active\n");
 
 		msg.id = HOST_IF_MSG_EXIT;
-		msg.drv = hif_drv;
 		msg.vif = vif;
 
 		result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
@@ -4000,7 +3973,6 @@ void wilc_network_info_received(struct wilc *wilc, u8 *pu8Buffer,
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_RCVD_NTWRK_INFO;
-	msg.drv = hif_drv;
 	msg.vif = vif;
 
 	msg.body.net_info.len = u32Length;
@@ -4048,7 +4020,6 @@ void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *pu8Buffer,
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO;
-	msg.drv = hif_drv;
 	msg.vif = vif;
 
 	msg.body.async_info.len = u32Length;
@@ -4086,7 +4057,6 @@ void wilc_scan_complete_received(struct wilc *wilc, u8 *pu8Buffer,
 		memset(&msg, 0, sizeof(struct host_if_msg));
 
 		msg.id = HOST_IF_MSG_RCVD_SCAN_COMPLETE;
-		msg.drv = hif_drv;
 		msg.vif = vif;
 
 		result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
@@ -4121,7 +4091,6 @@ s32 wilc_remain_on_channel(struct wilc_vif *vif, u32 u32SessionID,
 	msg.body.remain_on_ch.arg = pvUserArg;
 	msg.body.remain_on_ch.u32duration = u32duration;
 	msg.body.remain_on_ch.id = u32SessionID;
-	msg.drv = hif_drv;
 	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
@@ -4146,7 +4115,6 @@ s32 wilc_listen_state_expired(struct wilc_vif *vif, u32 u32SessionID)
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_LISTEN_TIMER_FIRED;
-	msg.drv = hif_drv;
 	msg.vif = vif;
 	msg.body.remain_on_ch.id = u32SessionID;
 
@@ -4188,7 +4156,6 @@ s32 wilc_frame_register(struct wilc_vif *vif, u16 u16FrameType, bool bReg)
 	}
 	msg.body.reg_frame.frame_type = u16FrameType;
 	msg.body.reg_frame.reg = bReg;
-	msg.drv = hif_drv;
 	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
@@ -4216,7 +4183,6 @@ s32 wilc_add_beacon(struct wilc_vif *vif, u32 u32Interval, u32 u32DTIMPeriod,
 	PRINT_D(HOSTINF_DBG, "Setting adding beacon message queue params\n");
 
 	msg.id = HOST_IF_MSG_ADD_BEACON;
-	msg.drv = hif_drv;
 	msg.vif = vif;
 	pstrSetBeaconParam->interval = u32Interval;
 	pstrSetBeaconParam->dtim_period = u32DTIMPeriod;
@@ -4265,7 +4231,6 @@ int wilc_del_beacon(struct wilc_vif *vif)
 	}
 
 	msg.id = HOST_IF_MSG_DEL_BEACON;
-	msg.drv = hif_drv;
 	msg.vif = vif;
 	PRINT_D(HOSTINF_DBG, "Setting deleting beacon message queue params\n");
 
@@ -4293,7 +4258,6 @@ int wilc_add_station(struct wilc_vif *vif, struct add_sta_param *sta_param)
 	PRINT_D(HOSTINF_DBG, "Setting adding station message queue params\n");
 
 	msg.id = HOST_IF_MSG_ADD_STATION;
-	msg.drv = hif_drv;
 	msg.vif = vif;
 
 	memcpy(add_sta_info, sta_param, sizeof(struct add_sta_param));
@@ -4328,7 +4292,6 @@ int wilc_del_station(struct wilc_vif *vif, const u8 *mac_addr)
 	PRINT_D(HOSTINF_DBG, "Setting deleting station message queue params\n");
 
 	msg.id = HOST_IF_MSG_DEL_STATION;
-	msg.drv = hif_drv;
 	msg.vif = vif;
 
 	if (!mac_addr)
@@ -4362,7 +4325,6 @@ s32 wilc_del_allstation(struct wilc_vif *vif, u8 pu8MacAddr[][ETH_ALEN])
 	PRINT_D(HOSTINF_DBG, "Setting deauthenticating station message queue params\n");
 
 	msg.id = HOST_IF_MSG_DEL_ALL_STA;
-	msg.drv = hif_drv;
 	msg.vif = vif;
 
 	for (i = 0; i < MAX_NUM_STA; i++) {
@@ -4412,7 +4374,6 @@ s32 wilc_edit_station(struct wilc_vif *vif,
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_EDIT_STATION;
-	msg.drv = hif_drv;
 	msg.vif = vif;
 
 	memcpy(pstrAddStationMsg, pstrStaParams, sizeof(struct add_sta_param));
@@ -4453,7 +4414,6 @@ s32 wilc_set_power_mgmt(struct wilc_vif *vif, bool bIsEnabled, u32 u32Timeout)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_POWER_MGMT;
-	msg.drv = hif_drv;
 	msg.vif = vif;
 
 	pstrPowerMgmtParam->enabled = bIsEnabled;
@@ -4483,7 +4443,6 @@ s32 wilc_setup_multicast_filter(struct wilc_vif *vif, bool bIsEnabled,
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_SET_MULTICAST_FILTER;
-	msg.drv = hif_drv;
 	msg.vif = vif;
 
 	pstrMulticastFilterParam->enabled = bIsEnabled;
@@ -4678,7 +4637,6 @@ s32 wilc_del_all_rx_ba_session(struct wilc_vif *vif, char *pBSSID, char TID)
 
 	memcpy(pBASessionInfo->bssid, pBSSID, ETH_ALEN);
 	pBASessionInfo->tid = TID;
-	msg.drv = hif_drv;
 	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
@@ -4708,7 +4666,6 @@ s32 wilc_setup_ipaddress(struct wilc_vif *vif, u8 *u16ipadd, u8 idx)
 	msg.id = HOST_IF_MSG_SET_IPADDRESS;
 
 	msg.body.ip_info.ip_addr = u16ipadd;
-	msg.drv = hif_drv;
 	msg.vif = vif;
 	msg.body.ip_info.idx = idx;
 
@@ -4736,7 +4693,6 @@ static s32 host_int_get_ipaddress(struct wilc_vif *vif,
 	msg.id = HOST_IF_MSG_GET_IPADDRESS;
 
 	msg.body.ip_info.ip_addr = u16ipadd;
-	msg.drv = hif_drv;
 	msg.vif = vif;
 	msg.body.ip_info.idx = idx;
 
-- 
1.9.1

