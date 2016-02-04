Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:9198 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755811AbcBDJXF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 04:23:05 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 02/70] staging: wilc1000: remove unused functions
Date: Thu, 4 Feb 2016 18:15:19 +0900
Message-ID: <1454577387-509-3-git-send-email-glen.lee@atmel.com> (sfid-20160204_102310_894889_AD587EFA)
In-Reply-To: <1454577387-509-1-git-send-email-glen.lee@atmel.com>
References: <1454577387-509-1-git-send-email-glen.lee@atmel.com>
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
index 7c75d0e..1dc6af0 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3342,25 +3342,6 @@ int wilc_get_mac_address(struct wilc_vif *vif, u8 *mac_addr)
 	return result;
 }
 
-int wilc_set_mac_address(struct wilc_vif *vif, u8 *mac_addr)
-{
-	int result = 0;
-	struct host_if_msg msg;
-
-	PRINT_D(GENERIC_DBG, "mac addr = %x:%x:%x\n", mac_addr[0], mac_addr[1], mac_addr[2]);
-
-	memset(&msg, 0, sizeof(struct host_if_msg));
-	msg.id = HOST_IF_MSG_SET_MAC_ADDRESS;
-	memcpy(msg.body.set_mac_info.mac_addr, mac_addr, ETH_ALEN);
-	msg.vif = vif;
-
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (result)
-		PRINT_ER("Failed to send message queue: Set mac address\n");
-
-	return result;
-}
-
 int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 		      size_t ssid_len, const u8 *ies, size_t ies_len,
 		      wilc_connect_result connect_result, void *user_arg,
@@ -3431,32 +3412,6 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 	return result;
 }
 
-int wilc_flush_join_req(struct wilc_vif *vif)
-{
-	int result = 0;
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
 int wilc_disconnect(struct wilc_vif *vif, u16 reason_code)
 {
 	int result = 0;
@@ -3539,24 +3494,6 @@ int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel)
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
@@ -4606,35 +4543,6 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 	return (void *)pNewJoinBssParam;
 }
 
-int wilc_del_all_rx_ba_session(struct wilc_vif *vif, char *bssid, char tid)
-{
-	int result = 0;
-	struct host_if_msg msg;
-	struct ba_session_info *ba_session_info = &msg.body.session_info;
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
-	memcpy(ba_session_info->bssid, bssid, ETH_ALEN);
-	ba_session_info->tid = tid;
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
 int wilc_setup_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 {
 	int result = 0;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index b828791..3302a5b 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -325,14 +325,11 @@ int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *rx_gtk, u8 gtk_key_len,
 int wilc_set_pmkid_info(struct wilc_vif *vif,
 			struct host_if_pmkid_attr *pmkid);
 int wilc_get_mac_address(struct wilc_vif *vif, u8 *mac_addr);
-int wilc_set_mac_address(struct wilc_vif *vif, u8 *mac_addr);
-int wilc_wait_msg_queue_idle(void);
 int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 		      size_t ssid_len, const u8 *ies, size_t ies_len,
 		      wilc_connect_result connect_result, void *user_arg,
 		      u8 security, enum AUTHTYPE auth_type,
 		      u8 channel, void *join_params);
-int wilc_flush_join_req(struct wilc_vif *vif);
 int wilc_disconnect(struct wilc_vif *vif, u16 reason_code);
 int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel);
 int wilc_get_rssi(struct wilc_vif *vif, s8 *rssi_level);
@@ -356,7 +353,6 @@ int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 timeout);
 int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled,
 				u32 count);
 int wilc_setup_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx);
-int wilc_del_all_rx_ba_session(struct wilc_vif *vif, char *bssid, char tid);
 int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
 			   u32 duration, u16 chan,
 			   wilc_remain_on_chan_expired expired,
-- 
1.9.1

