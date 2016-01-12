Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:52682 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933315AbcALHhR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2016 02:37:17 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 16/26] staging: wilc1000: remove unused functions
Date: Tue, 12 Jan 2016 16:39:45 +0900
Message-ID: <1452584395-24910-17-git-send-email-glen.lee@atmel.com> (sfid-20160112_083724_799158_F3FE1493)
In-Reply-To: <1452584395-24910-1-git-send-email-glen.lee@atmel.com>
References: <1452584395-24910-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unused following functions.
wilc_del_all_rx_ba_session
wilc_flush_join_req
wilc_wait_msg_queue_idle
wilc_set_mac_address

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 92 -------------------------------
 drivers/staging/wilc1000/host_interface.h |  4 --
 2 files changed, 96 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 9ffed32..bc8357d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3346,25 +3346,6 @@ s32 wilc_get_mac_address(struct wilc_vif *vif, u8 *pu8MacAddress)
 	return result;
 }
 
-s32 wilc_set_mac_address(struct wilc_vif *vif, u8 *pu8MacAddress)
-{
-	s32 result = 0;
-	struct host_if_msg msg;
-
-	PRINT_D(GENERIC_DBG, "mac addr = %x:%x:%x\n", pu8MacAddress[0], pu8MacAddress[1], pu8MacAddress[2]);
-
-	memset(&msg, 0, sizeof(struct host_if_msg));
-	msg.id = HOST_IF_MSG_SET_MAC_ADDRESS;
-	memcpy(msg.body.set_mac_info.mac_addr, pu8MacAddress, ETH_ALEN);
-	msg.vif = vif;
-
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (result)
-		PRINT_ER("Failed to send message queue: Set mac address\n");
-
-	return result;
-}
-
 s32 wilc_set_join_req(struct wilc_vif *vif, u8 *pu8bssid, const u8 *pu8ssid,
 		      size_t ssidLen, const u8 *pu8IEs, size_t IEsLen,
 		      wilc_connect_result pfConnectResult, void *pvUserArg,
@@ -3432,32 +3413,6 @@ s32 wilc_set_join_req(struct wilc_vif *vif, u8 *pu8bssid, const u8 *pu8ssid,
 	return result;
 }
 
-s32 wilc_flush_join_req(struct wilc_vif *vif)
-{
-	s32 result = 0;
-	struct host_if_msg msg;
-	struct host_if_drv *hif_drv = vif->hif_drv;
-
-	if (!join_req)
-		return -EFAULT;
-
-	if (!hif_drv) {
-		PRINT_ER("Driver is null\n");
-		return -EFAULT;
-	}
-
-	msg.id = HOST_IF_MSG_FLUSH_CONNECT;
-	msg.vif = vif;
-
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (result) {
-		PRINT_ER("Failed to send message queue: Flush join request\n");
-		return -EFAULT;
-	}
-
-	return result;
-}
-
 s32 wilc_disconnect(struct wilc_vif *vif, u16 u16ReasonCode)
 {
 	s32 result = 0;
@@ -3540,24 +3495,6 @@ int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel)
 	return 0;
 }
 
-int wilc_wait_msg_queue_idle(void)
-{
-	int result = 0;
-	struct host_if_msg msg;
-
-	memset(&msg, 0, sizeof(struct host_if_msg));
-	msg.id = HOST_IF_MSG_Q_IDLE;
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (result) {
-		PRINT_ER("wilc mq send fail\n");
-		result = -EINVAL;
-	}
-
-	down(&hif_sema_wait_response);
-
-	return result;
-}
-
 int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mac_idx)
 {
 	int result = 0;
@@ -4615,35 +4552,6 @@ void wilc_free_join_params(void *pJoinParams)
 		PRINT_ER("Unable to FREE null pointer\n");
 }
 
-s32 wilc_del_all_rx_ba_session(struct wilc_vif *vif, char *pBSSID, char TID)
-{
-	s32 result = 0;
-	struct host_if_msg msg;
-	struct ba_session_info *pBASessionInfo = &msg.body.session_info;
-	struct host_if_drv *hif_drv = vif->hif_drv;
-
-	if (!hif_drv) {
-		PRINT_ER("driver is null\n");
-		return -EFAULT;
-	}
-
-	memset(&msg, 0, sizeof(struct host_if_msg));
-
-	msg.id = HOST_IF_MSG_DEL_ALL_RX_BA_SESSIONS;
-
-	memcpy(pBASessionInfo->bssid, pBSSID, ETH_ALEN);
-	pBASessionInfo->tid = TID;
-	msg.vif = vif;
-
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (result)
-		PRINT_ER("wilc_mq_send fail\n");
-
-	down(&hif_sema_wait_response);
-
-	return result;
-}
-
 s32 wilc_setup_ipaddress(struct wilc_vif *vif, u8 *u16ipadd, u8 idx)
 {
 	s32 result = 0;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 5794246..2893b2e 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -327,15 +327,12 @@ s32 wilc_add_tx_gtk(struct host_if_drv *hWFIDrv, u8 u8KeyLen,
 s32 wilc_set_pmkid_info(struct wilc_vif *vif,
 			struct host_if_pmkid_attr *pu8PmkidInfoArray);
 s32 wilc_get_mac_address(struct wilc_vif *vif, u8 *pu8MacAddress);
-s32 wilc_set_mac_address(struct wilc_vif *vif, u8 *pu8MacAddress);
-int wilc_wait_msg_queue_idle(void);
 s32 wilc_set_start_scan_req(struct host_if_drv *hWFIDrv, u8 scanSource);
 s32 wilc_set_join_req(struct wilc_vif *vif, u8 *pu8bssid, const u8 *pu8ssid,
 		      size_t ssidLen, const u8 *pu8IEs, size_t IEsLen,
 		      wilc_connect_result pfConnectResult, void *pvUserArg,
 		      u8 u8security, enum AUTHTYPE tenuAuth_type,
 		      u8 u8channel, void *pJoinParams);
-s32 wilc_flush_join_req(struct wilc_vif *vif);
 s32 wilc_disconnect(struct wilc_vif *vif, u16 u16ReasonCode);
 int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel);
 s32 wilc_get_rssi(struct wilc_vif *vif, s8 *ps8Rssi);
@@ -359,7 +356,6 @@ s32 wilc_set_power_mgmt(struct wilc_vif *vif, bool bIsEnabled, u32 u32Timeout);
 s32 wilc_setup_multicast_filter(struct wilc_vif *vif, bool bIsEnabled,
 				u32 u32count);
 s32 wilc_setup_ipaddress(struct wilc_vif *vif, u8 *u16ipadd, u8 idx);
-s32 wilc_del_all_rx_ba_session(struct wilc_vif *vif, char *pBSSID, char TID);
 s32 wilc_remain_on_channel(struct wilc_vif *vif, u32 u32SessionID,
 			   u32 u32duration, u16 chan,
 			   wilc_remain_on_chan_expired RemainOnChanExpired,
-- 
1.9.1

