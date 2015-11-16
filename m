Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:52965 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbbKPOFZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2015 09:05:25 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 01/19] staging/wilc1000: remove unused functions
Date: Mon, 16 Nov 2015 15:04:52 +0100
Message-Id: <1447682710-2908925-2-git-send-email-arnd@arndb.de> (sfid-20151116_150545_563829_BA95F9D4)
In-Reply-To: <1447682710-2908925-1-git-send-email-arnd@arndb.de>
References: <1447682710-2908925-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A number of symbols in the wilc1000 driver are completely unused
and can be removed.
This includes two variables that are only written but not read.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/host_interface.c         | 295 ----------------------
 drivers/staging/wilc1000/host_interface.h         |  19 --
 drivers/staging/wilc1000/linux_wlan_sdio.c        |  11 -
 drivers/staging/wilc1000/linux_wlan_sdio.h        |   1 -
 drivers/staging/wilc1000/linux_wlan_spi.c         |  14 -
 drivers/staging/wilc1000/linux_wlan_spi.h         |   1 -
 drivers/staging/wilc1000/wilc_sdio.c              |  56 ----
 drivers/staging/wilc1000/wilc_spi.c               | 225 -----------------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  36 ---
 drivers/staging/wilc1000/wilc_wlan.c              |   4 -
 10 files changed, 662 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d5b7725ec2bf..6c205b97293d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3366,36 +3366,6 @@ s32 host_int_set_pmkid_info(struct host_if_drv *hif_drv, struct host_if_pmkid_at
 	return result;
 }
 
-s32 host_int_get_pmkid_info(struct host_if_drv *hif_drv,
-			    u8 *pu8PmkidInfoArray,
-			    u32 u32PmkidInfoLen)
-{
-	struct wid wid;
-
-	wid.id = (u16)WID_PMKID_INFO;
-	wid.type = WID_STR;
-	wid.size = u32PmkidInfoLen;
-	wid.val = pu8PmkidInfoArray;
-
-	return 0;
-}
-
-s32 host_int_set_RSNAConfigPSKPassPhrase(struct host_if_drv *hif_drv,
-					 u8 *pu8PassPhrase,
-					 u8 u8Psklength)
-{
-	struct wid wid;
-
-	if ((u8Psklength > 7) && (u8Psklength < 65)) {
-		wid.id = (u16)WID_11I_PSK;
-		wid.type = WID_STR;
-		wid.val = pu8PassPhrase;
-		wid.size = u8Psklength;
-	}
-
-	return 0;
-}
-
 s32 hif_get_mac_address(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
 {
 	s32 result = 0;
@@ -3436,19 +3406,6 @@ s32 host_int_set_MacAddress(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
 	return result;
 }
 
-s32 host_int_get_RSNAConfigPSKPassPhrase(struct host_if_drv *hif_drv,
-					 u8 *pu8PassPhrase, u8 u8Psklength)
-{
-	struct wid wid;
-
-	wid.id = (u16)WID_11I_PSK;
-	wid.type = WID_STR;
-	wid.size = u8Psklength;
-	wid.val = pu8PassPhrase;
-
-	return 0;
-}
-
 s32 host_int_set_start_scan_req(struct host_if_drv *hif_drv, u8 scanSource)
 {
 	struct wid wid;
@@ -3461,18 +3418,6 @@ s32 host_int_set_start_scan_req(struct host_if_drv *hif_drv, u8 scanSource)
 	return 0;
 }
 
-s32 host_int_get_start_scan_req(struct host_if_drv *hif_drv, u8 *pu8ScanSource)
-{
-	struct wid wid;
-
-	wid.id = (u16)WID_START_SCAN_REQ;
-	wid.type = WID_CHAR;
-	wid.val = (s8 *)pu8ScanSource;
-	wid.size = sizeof(char);
-
-	return 0;
-}
-
 s32 host_int_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
 			  const u8 *pu8ssid, size_t ssidLen,
 			  const u8 *pu8IEs, size_t IEsLen,
@@ -3589,31 +3534,6 @@ s32 host_int_disconnect(struct host_if_drv *hif_drv, u16 u16ReasonCode)
 	return result;
 }
 
-s32 host_int_disconnect_station(struct host_if_drv *hif_drv, u8 assoc_id)
-{
-	struct wid wid;
-
-	wid.id = (u16)WID_DISCONNECT;
-	wid.type = WID_CHAR;
-	wid.val = (s8 *)&assoc_id;
-	wid.size = sizeof(char);
-
-	return 0;
-}
-
-s32 host_int_get_assoc_req_info(struct host_if_drv *hif_drv,
-				u8 *pu8AssocReqInfo,
-				u32 u32AssocReqInfoLen)
-{
-	struct wid wid;
-
-	wid.id = (u16)WID_ASSOC_REQ_INFO;
-	wid.type = WID_STR;
-	wid.val = pu8AssocReqInfo;
-	wid.size = u32AssocReqInfoLen;
-
-	return 0;
-}
 
 s32 host_int_get_assoc_res_info(struct host_if_drv *hif_drv,
 				u8 *pu8AssocRespInfo,
@@ -3646,20 +3566,6 @@ s32 host_int_get_assoc_res_info(struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 host_int_get_rx_power_level(struct host_if_drv *hif_drv,
-				u8 *pu8RxPowerLevel,
-				u32 u32RxPowerLevelLen)
-{
-	struct wid wid;
-
-	wid.id = (u16)WID_RX_POWER_LEVEL;
-	wid.type = WID_STR;
-	wid.val = pu8RxPowerLevel;
-	wid.size = u32RxPowerLevelLen;
-
-	return 0;
-}
-
 int host_int_set_mac_chnl_num(struct host_if_drv *hif_drv, u8 channel)
 {
 	int result;
@@ -3740,31 +3646,6 @@ int host_int_set_operation_mode(struct host_if_drv *hif_drv, u32 mode)
 	return result;
 }
 
-s32 host_int_get_host_chnl_num(struct host_if_drv *hif_drv, u8 *pu8ChNo)
-{
-	s32 result = 0;
-	struct host_if_msg msg;
-
-	if (!hif_drv) {
-		PRINT_ER("driver is null\n");
-		return -EFAULT;
-	}
-
-	memset(&msg, 0, sizeof(struct host_if_msg));
-
-	msg.id = HOST_IF_MSG_GET_CHNL;
-	msg.drv = hif_drv;
-
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (result)
-		PRINT_ER("wilc mq send fail\n");
-	down(&hif_drv->sem_get_chnl);
-
-	*pu8ChNo = ch_no;
-
-	return result;
-}
-
 s32 host_int_get_inactive_time(struct host_if_drv *hif_drv,
 			       const u8 *mac, u32 *pu32InactiveTime)
 {
@@ -3793,34 +3674,6 @@ s32 host_int_get_inactive_time(struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 host_int_test_get_int_wid(struct host_if_drv *hif_drv, u32 *pu32TestMemAddr)
-{
-	s32 result = 0;
-	struct wid wid;
-
-	if (!hif_drv) {
-		PRINT_ER("driver is null\n");
-		return -EFAULT;
-	}
-
-	wid.id = (u16)WID_MEMORY_ADDRESS;
-	wid.type = WID_INT;
-	wid.val = (s8 *)pu32TestMemAddr;
-	wid.size = sizeof(u32);
-
-	result = send_config_pkt(GET_CFG, &wid, 1,
-				 get_id_from_handler(hif_drv));
-
-	if (result) {
-		PRINT_ER("Failed to get wid value\n");
-		return -EINVAL;
-	} else {
-		PRINT_D(HOSTINF_DBG, "Successfully got wid value\n");
-	}
-
-	return result;
-}
-
 s32 host_int_get_rssi(struct host_if_drv *hif_drv, s8 *ps8Rssi)
 {
 	s32 result = 0;
@@ -3848,33 +3701,6 @@ s32 host_int_get_rssi(struct host_if_drv *hif_drv, s8 *ps8Rssi)
 	return result;
 }
 
-s32 host_int_get_link_speed(struct host_if_drv *hif_drv, s8 *ps8lnkspd)
-{
-	struct host_if_msg msg;
-	s32 result = 0;
-
-	memset(&msg, 0, sizeof(struct host_if_msg));
-	msg.id = HOST_IF_MSG_GET_LINKSPEED;
-	msg.drv = hif_drv;
-
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (result) {
-		PRINT_ER("Failed to send GET_LINKSPEED to message queue ");
-		return -EFAULT;
-	}
-
-	down(&hif_drv->sem_get_link_speed);
-
-	if (!ps8lnkspd) {
-		PRINT_ER("LINKSPEED pointer value is null");
-		return -EFAULT;
-	}
-
-	*ps8lnkspd = link_speed;
-
-	return result;
-}
-
 s32 host_int_get_statistics(struct host_if_drv *hif_drv, struct rf_info *pstrStatistics)
 {
 	s32 result = 0;
@@ -3969,99 +3795,6 @@ s32 hif_set_cfg(struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 hif_get_cfg(struct host_if_drv *hif_drv, u16 u16WID, u16 *pu16WID_Value)
-{
-	s32 result = 0;
-
-	down(&hif_drv->sem_cfg_values);
-
-	if (!hif_drv) {
-		PRINT_ER("hif_drv NULL\n");
-		return -EFAULT;
-	}
-	PRINT_D(HOSTINF_DBG, "Getting configuration parameters\n");
-	switch (u16WID)	{
-	case WID_BSS_TYPE:
-		*pu16WID_Value = (u16)hif_drv->cfg_values.bss_type;
-		break;
-
-	case WID_AUTH_TYPE:
-		*pu16WID_Value = (u16)hif_drv->cfg_values.auth_type;
-		break;
-
-	case WID_AUTH_TIMEOUT:
-		*pu16WID_Value = hif_drv->cfg_values.auth_timeout;
-		break;
-
-	case WID_POWER_MANAGEMENT:
-		*pu16WID_Value = (u16)hif_drv->cfg_values.power_mgmt_mode;
-		break;
-
-	case WID_SHORT_RETRY_LIMIT:
-		*pu16WID_Value = hif_drv->cfg_values.short_retry_limit;
-		break;
-
-	case WID_LONG_RETRY_LIMIT:
-		*pu16WID_Value = hif_drv->cfg_values.long_retry_limit;
-		break;
-
-	case WID_FRAG_THRESHOLD:
-		*pu16WID_Value = hif_drv->cfg_values.frag_threshold;
-		break;
-
-	case WID_RTS_THRESHOLD:
-		*pu16WID_Value = hif_drv->cfg_values.rts_threshold;
-		break;
-
-	case WID_PREAMBLE:
-		*pu16WID_Value = (u16)hif_drv->cfg_values.preamble_type;
-		break;
-
-	case WID_SHORT_SLOT_ALLOWED:
-		*pu16WID_Value = (u16)hif_drv->cfg_values.short_slot_allowed;
-		break;
-
-	case WID_11N_TXOP_PROT_DISABLE:
-		*pu16WID_Value = (u16)hif_drv->cfg_values.txop_prot_disabled;
-		break;
-
-	case WID_BEACON_INTERVAL:
-		*pu16WID_Value = hif_drv->cfg_values.beacon_interval;
-		break;
-
-	case WID_DTIM_PERIOD:
-		*pu16WID_Value = (u16)hif_drv->cfg_values.dtim_period;
-		break;
-
-	case WID_SITE_SURVEY:
-		*pu16WID_Value = (u16)hif_drv->cfg_values.site_survey_enabled;
-		break;
-
-	case WID_SITE_SURVEY_SCAN_TIME:
-		*pu16WID_Value = hif_drv->cfg_values.site_survey_scan_time;
-		break;
-
-	case WID_ACTIVE_SCAN_TIME:
-		*pu16WID_Value = hif_drv->cfg_values.active_scan_time;
-		break;
-
-	case WID_PASSIVE_SCAN_TIME:
-		*pu16WID_Value = hif_drv->cfg_values.passive_scan_time;
-		break;
-
-	case WID_CURRENT_TX_RATE:
-		*pu16WID_Value = hif_drv->cfg_values.curr_tx_rate;
-		break;
-
-	default:
-		break;
-	}
-
-	up(&hif_drv->sem_cfg_values);
-
-	return result;
-}
-
 static void GetPeriodicRSSI(unsigned long arg)
 {
 	struct host_if_drv *hif_drv = (struct host_if_drv *)arg;
@@ -4916,34 +4649,6 @@ void host_int_freeJoinParams(void *pJoinParams)
 		PRINT_ER("Unable to FREE null pointer\n");
 }
 
-s32 host_int_delBASession(struct host_if_drv *hif_drv, char *pBSSID, char TID)
-{
-	s32 result = 0;
-	struct host_if_msg msg;
-	struct ba_session_info *pBASessionInfo = &msg.body.session_info;
-
-	if (!hif_drv) {
-		PRINT_ER("driver is null\n");
-		return -EFAULT;
-	}
-
-	memset(&msg, 0, sizeof(struct host_if_msg));
-
-	msg.id = HOST_IF_MSG_DEL_BA_SESSION;
-
-	memcpy(pBASessionInfo->bssid, pBSSID, ETH_ALEN);
-	pBASessionInfo->tid = TID;
-	msg.drv = hif_drv;
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
 s32 host_int_del_All_Rx_BASession(struct host_if_drv *hif_drv,
 				  char *pBSSID,
 				  char TID)
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 57e1d424afdc..c1ed2e236ee2 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -326,18 +326,10 @@ s32 host_int_add_tx_gtk(struct host_if_drv *hWFIDrv, u8 u8KeyLen,
 			u8 *pu8TxGtk, u8 u8KeyIdx);
 s32 host_int_set_pmkid_info(struct host_if_drv *hWFIDrv,
 			    struct host_if_pmkid_attr *pu8PmkidInfoArray);
-s32 host_int_get_pmkid_info(struct host_if_drv *hWFIDrv, u8 *pu8PmkidInfoArray,
-			    u32 u32PmkidInfoLen);
-s32 host_int_set_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv,
-					 u8 *pu8PassPhrase,
-					 u8 u8Psklength);
-s32 host_int_get_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv,
-					 u8 *pu8PassPhrase, u8 u8Psklength);
 s32 hif_get_mac_address(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress);
 s32 host_int_set_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress);
 int host_int_wait_msg_queue_idle(void);
 s32 host_int_set_start_scan_req(struct host_if_drv *hWFIDrv, u8 scanSource);
-s32 host_int_get_start_scan_req(struct host_if_drv *hWFIDrv, u8 *pu8ScanSource);
 s32 host_int_set_join_req(struct host_if_drv *hWFIDrv, u8 *pu8bssid,
 			  const u8 *pu8ssid, size_t ssidLen,
 			  const u8 *pu8IEs, size_t IEsLen,
@@ -346,21 +338,12 @@ s32 host_int_set_join_req(struct host_if_drv *hWFIDrv, u8 *pu8bssid,
 			  u8 u8channel, void *pJoinParams);
 s32 host_int_flush_join_req(struct host_if_drv *hWFIDrv);
 s32 host_int_disconnect(struct host_if_drv *hWFIDrv, u16 u16ReasonCode);
-s32 host_int_disconnect_station(struct host_if_drv *hWFIDrv, u8 assoc_id);
-s32 host_int_get_assoc_req_info(struct host_if_drv *hWFIDrv,
-				u8 *pu8AssocReqInfo,
-				u32 u32AssocReqInfoLen);
 s32 host_int_get_assoc_res_info(struct host_if_drv *hWFIDrv,
 				u8 *pu8AssocRespInfo,
 				u32 u32MaxAssocRespInfoLen,
 				u32 *pu32RcvdAssocRespInfoLen);
-s32 host_int_get_rx_power_level(struct host_if_drv *hWFIDrv,
-				u8 *pu8RxPowerLevel,
-				u32 u32RxPowerLevelLen);
 int host_int_set_mac_chnl_num(struct host_if_drv *wfi_drv, u8 channel);
-s32 host_int_get_host_chnl_num(struct host_if_drv *hWFIDrv, u8 *pu8ChNo);
 s32 host_int_get_rssi(struct host_if_drv *hWFIDrv, s8 *ps8Rssi);
-s32 host_int_get_link_speed(struct host_if_drv *hWFIDrv, s8 *ps8lnkspd);
 s32 host_int_scan(struct host_if_drv *hWFIDrv, u8 u8ScanSource,
 		  u8 u8ScanType, u8 *pu8ChnlFreqList,
 		  u8 u8ChnlListLen, const u8 *pu8IEs,
@@ -368,7 +351,6 @@ s32 host_int_scan(struct host_if_drv *hWFIDrv, u8 u8ScanSource,
 		  void *pvUserArg, struct hidden_network *pstrHiddenNetwork);
 s32 hif_set_cfg(struct host_if_drv *hWFIDrv,
 		struct cfg_param_val *pstrCfgParamVal);
-s32 hif_get_cfg(struct host_if_drv *hWFIDrv, u16 u16WID, u16 *pu16WID_Value);
 s32 host_int_init(struct net_device *dev, struct host_if_drv **phWFIDrv);
 s32 host_int_deinit(struct host_if_drv *hWFIDrv);
 s32 host_int_add_beacon(struct host_if_drv *hWFIDrv, u32 u32Interval,
@@ -394,7 +376,6 @@ s32 host_int_setup_multicast_filter(struct host_if_drv *hWFIDrv,
 s32 host_int_setup_ipaddress(struct host_if_drv *hWFIDrv,
 			     u8 *pu8IPAddr,
 			     u8 idx);
-s32 host_int_delBASession(struct host_if_drv *hWFIDrv, char *pBSSID, char TID);
 s32 host_int_del_All_Rx_BASession(struct host_if_drv *hWFIDrv,
 				  char *pBSSID,
 				  char TID);
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index e854d376878f..9e8ba04ca9c8 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -226,17 +226,6 @@ int linux_sdio_init(void)
 	return 1;
 }
 
-void linux_sdio_deinit(void *pv)
-{
-
-	/**
-	 *      TODO :
-	 **/
-
-
-	sdio_unregister_driver(&wilc_bus);
-}
-
 int linux_sdio_set_max_speed(void)
 {
 	return linux_sdio_set_speed(MAX_SPEED);
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.h b/drivers/staging/wilc1000/linux_wlan_sdio.h
index 6f42bc75b507..7c59b2f6543a 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.h
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.h
@@ -4,7 +4,6 @@ extern struct sdio_driver wilc_bus;
 #include <linux/mmc/sdio_func.h>
 
 int linux_sdio_init(void);
-void linux_sdio_deinit(void *);
 int linux_sdio_cmd52(sdio_cmd52_t *cmd);
 int linux_sdio_cmd53(sdio_cmd53_t *cmd);
 int enable_sdio_interrupt(void);
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index 73c788f602c0..3655077a936f 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -42,7 +42,6 @@
 static u32 SPEED = MIN_SPEED;
 
 struct spi_device *wilc_spi_dev;
-void linux_spi_deinit(void *vp);
 
 static int __init wilc_bus_probe(struct spi_device *spi)
 {
@@ -80,19 +79,6 @@ struct spi_driver wilc_bus __refdata = {
 	.remove = __exit_p(wilc_bus_remove),
 };
 
-
-void linux_spi_deinit(void *vp)
-{
-
-	spi_unregister_driver(&wilc_bus);
-
-	SPEED = MIN_SPEED;
-	PRINT_ER("@@@@@@@@@@@@ restore SPI speed to %d @@@@@@@@@\n", SPEED);
-
-}
-
-
-
 int linux_spi_init(void)
 {
 	int ret = 1;
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.h b/drivers/staging/wilc1000/linux_wlan_spi.h
index b9561003ecf0..2edd97b4c5cc 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.h
+++ b/drivers/staging/wilc1000/linux_wlan_spi.h
@@ -6,7 +6,6 @@ extern struct spi_device *wilc_spi_dev;
 extern struct spi_driver wilc_bus;
 
 int linux_spi_init(void);
-void linux_spi_deinit(void *vp);
 int linux_spi_write(u8 *b, u32 len);
 int linux_spi_read(u8 *rb, u32 rlen);
 int linux_spi_write_read(u8 *wb, u8 *rb, u32 rlen);
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 8aacf55e5eb8..d26e4cf0f436 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -157,67 +157,11 @@ static int sdio_clear_int(void)
 
 }
 
-u32 sdio_xfer_cnt(void)
-{
-	u32 cnt = 0;
-	sdio_cmd52_t cmd;
-
-	cmd.read_write = 0;
-	cmd.function = 1;
-	cmd.raw = 0;
-	cmd.address = 0x1C;
-	cmd.data = 0;
-	linux_sdio_cmd52(&cmd);
-	cnt = cmd.data;
-
-	cmd.read_write = 0;
-	cmd.function = 1;
-	cmd.raw = 0;
-	cmd.address = 0x1D;
-	cmd.data = 0;
-	linux_sdio_cmd52(&cmd);
-	cnt |= (cmd.data << 8);
-
-	cmd.read_write = 0;
-	cmd.function = 1;
-	cmd.raw = 0;
-	cmd.address = 0x1E;
-	cmd.data = 0;
-	linux_sdio_cmd52(&cmd);
-	cnt |= (cmd.data << 16);
-
-	return cnt;
-}
-
 /********************************************
  *
  *      Sdio interfaces
  *
  ********************************************/
-int sdio_check_bs(void)
-{
-	sdio_cmd52_t cmd;
-
-	/**
-	 *      poll until BS is 0
-	 **/
-	cmd.read_write = 0;
-	cmd.function = 0;
-	cmd.raw = 0;
-	cmd.address = 0xc;
-	cmd.data = 0;
-	if (!linux_sdio_cmd52(&cmd)) {
-		g_sdio.dPrint(N_ERR, "[wilc sdio]: Fail cmd 52, get BS register...\n");
-		goto _fail_;
-	}
-
-	return 1;
-
-_fail_:
-
-	return 0;
-}
-
 static int sdio_write_reg(u32 addr, u32 data)
 {
 #ifdef BIG_ENDIAN
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 3741836dad41..9af35d1ef99e 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -108,163 +108,6 @@ static u8 crc7(u8 crc, const u8 *buffer, u32 len)
 #define DATA_PKT_SZ_8K				(8 * 1024)
 #define DATA_PKT_SZ					DATA_PKT_SZ_8K
 
-static int spi_cmd(u8 cmd, u32 adr, u32 data, u32 sz, u8 clockless)
-{
-	u8 bc[9];
-	int len = 5;
-	int result = N_OK;
-
-	bc[0] = cmd;
-	switch (cmd) {
-	case CMD_SINGLE_READ:                           /* single word (4 bytes) read */
-		bc[1] = (u8)(adr >> 16);
-		bc[2] = (u8)(adr >> 8);
-		bc[3] = (u8)adr;
-		len = 5;
-		break;
-
-	case CMD_INTERNAL_READ:                 /* internal register read */
-		bc[1] = (u8)(adr >> 8);
-		if (clockless)
-			bc[1] |= BIT(7);
-		bc[2] = (u8)adr;
-		bc[3] = 0x00;
-		len = 5;
-		break;
-
-	case CMD_TERMINATE:                                     /* termination */
-		bc[1] = 0x00;
-		bc[2] = 0x00;
-		bc[3] = 0x00;
-		len = 5;
-		break;
-
-	case CMD_REPEAT:                                                /* repeat */
-		bc[1] = 0x00;
-		bc[2] = 0x00;
-		bc[3] = 0x00;
-		len = 5;
-		break;
-
-	case CMD_RESET:                                                 /* reset */
-		bc[1] = 0xff;
-		bc[2] = 0xff;
-		bc[3] = 0xff;
-		len = 5;
-		break;
-
-	case CMD_DMA_WRITE:                                     /* dma write */
-	case CMD_DMA_READ:                                      /* dma read */
-		bc[1] = (u8)(adr >> 16);
-		bc[2] = (u8)(adr >> 8);
-		bc[3] = (u8)adr;
-		bc[4] = (u8)(sz >> 8);
-		bc[5] = (u8)(sz);
-		len = 7;
-		break;
-
-	case CMD_DMA_EXT_WRITE:         /* dma extended write */
-	case CMD_DMA_EXT_READ:                  /* dma extended read */
-		bc[1] = (u8)(adr >> 16);
-		bc[2] = (u8)(adr >> 8);
-		bc[3] = (u8)adr;
-		bc[4] = (u8)(sz >> 16);
-		bc[5] = (u8)(sz >> 8);
-		bc[6] = (u8)(sz);
-		len = 8;
-		break;
-
-	case CMD_INTERNAL_WRITE:                /* internal register write */
-		bc[1] = (u8)(adr >> 8);
-		if (clockless)
-			bc[1] |= BIT(7);
-		bc[2] = (u8)(adr);
-		bc[3] = (u8)(data >> 24);
-		bc[4] = (u8)(data >> 16);
-		bc[5] = (u8)(data >> 8);
-		bc[6] = (u8)(data);
-		len = 8;
-		break;
-
-	case CMD_SINGLE_WRITE:                  /* single word write */
-		bc[1] = (u8)(adr >> 16);
-		bc[2] = (u8)(adr >> 8);
-		bc[3] = (u8)(adr);
-		bc[4] = (u8)(data >> 24);
-		bc[5] = (u8)(data >> 16);
-		bc[6] = (u8)(data >> 8);
-		bc[7] = (u8)(data);
-		len = 9;
-		break;
-
-	default:
-		result = N_FAIL;
-		break;
-	}
-
-	if (result) {
-		if (!g_spi.crc_off)
-			bc[len - 1] = (crc7(0x7f, (const u8 *)&bc[0], len - 1)) << 1;
-		else
-			len -= 1;
-
-		if (!linux_spi_write(bc, len)) {
-			PRINT_ER("[wilc spi]: Failed cmd write, bus error...\n");
-			result = N_FAIL;
-		}
-	}
-
-	return result;
-}
-
-static int spi_cmd_rsp(u8 cmd)
-{
-	u8 rsp;
-	int result = N_OK;
-
-	/**
-	 *      Command/Control response
-	 **/
-	if ((cmd == CMD_RESET) ||
-	    (cmd == CMD_TERMINATE) ||
-	    (cmd == CMD_REPEAT)) {
-		if (!linux_spi_read(&rsp, 1)) {
-			result = N_FAIL;
-			goto _fail_;
-		}
-	}
-
-	if (!linux_spi_read(&rsp, 1)) {
-		PRINT_ER("[wilc spi]: Failed cmd response read, bus error...\n");
-		result = N_FAIL;
-		goto _fail_;
-	}
-
-	if (rsp != cmd) {
-		PRINT_ER("[wilc spi]: Failed cmd response, cmd (%02x), resp (%02x)\n", cmd, rsp);
-		result = N_FAIL;
-		goto _fail_;
-	}
-
-	/**
-	 *      State response
-	 **/
-	if (!linux_spi_read(&rsp, 1)) {
-		PRINT_ER("[wilc spi]: Failed cmd state read, bus error...\n");
-		result = N_FAIL;
-		goto _fail_;
-	}
-
-	if (rsp != 0x00) {
-		PRINT_ER("[wilc spi]: Failed cmd state response state (%02x)\n", rsp);
-		result = N_FAIL;
-	}
-
-_fail_:
-
-	return result;
-}
-
 static int spi_cmd_complete(u8 cmd, u32 adr, u8 *b, u32 sz, u8 clockless)
 {
 	u8 wb[32], rb[32];
@@ -604,74 +447,6 @@ _error_:
 	return result;
 }
 
-static int spi_data_read(u8 *b, u32 sz)
-{
-	int retry, ix, nbytes;
-	int result = N_OK;
-	u8 crc[2];
-	u8 rsp;
-
-	/**
-	 *      Data
-	 **/
-	ix = 0;
-	do {
-		if (sz <= DATA_PKT_SZ)
-			nbytes = sz;
-		else
-			nbytes = DATA_PKT_SZ;
-
-		/**
-		 *      Data Respnose header
-		 **/
-		retry = 10;
-		do {
-			if (!linux_spi_read(&rsp, 1)) {
-				PRINT_ER("[wilc spi]: Failed data response read, bus error...\n");
-				result = N_FAIL;
-				break;
-			}
-			if (((rsp >> 4) & 0xf) == 0xf)
-				break;
-		} while (retry--);
-
-		if (result == N_FAIL)
-			break;
-
-		if (retry <= 0) {
-			PRINT_ER("[wilc spi]: Failed data response read...(%02x)\n", rsp);
-			result = N_FAIL;
-			break;
-		}
-
-		/**
-		 *      Read bytes
-		 **/
-		if (!linux_spi_read(&b[ix], nbytes)) {
-			PRINT_ER("[wilc spi]: Failed data block read, bus error...\n");
-			result = N_FAIL;
-			break;
-		}
-
-		/**
-		 *      Read Crc
-		 **/
-		if (!g_spi.crc_off) {
-			if (!linux_spi_read(crc, 2)) {
-				PRINT_ER("[wilc spi]: Failed data block crc read, bus error...\n");
-				result = N_FAIL;
-				break;
-			}
-		}
-
-		ix += nbytes;
-		sz -= nbytes;
-
-	} while (sz);
-
-	return result;
-}
-
 static int spi_data_write(u8 *b, u32 sz)
 {
 	int ix, nbytes;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 6f405221030c..849f86b5ff30 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -471,42 +471,6 @@ static void CfgScanResult(enum scan_event enuScanEvent, tstrNetworkInfo *pstrNet
 
 
 /**
- *  @brief      WILC_WFI_Set_PMKSA
- *  @details  Check if pmksa is cached and set it.
- *  @param[in]
- *  @return     int : Return 0 on Success
- *  @author	mdaftedar
- *  @date	01 MAR 2012
- *  @version	1.0
- */
-int WILC_WFI_Set_PMKSA(u8 *bssid, struct wilc_priv *priv)
-{
-	u32 i;
-	s32 s32Error = 0;
-
-
-	for (i = 0; i < priv->pmkid_list.numpmkid; i++)	{
-
-		if (!memcmp(bssid, priv->pmkid_list.pmkidlist[i].bssid,
-				 ETH_ALEN)) {
-			PRINT_D(CFG80211_DBG, "PMKID successful comparison");
-
-			/*If bssid is found, set the values*/
-			s32Error = host_int_set_pmkid_info(priv->hWILCWFIDrv, &priv->pmkid_list);
-
-			if (s32Error != 0)
-				PRINT_ER("Error in pmkid\n");
-
-			break;
-		}
-	}
-
-	return s32Error;
-
-
-}
-
-/**
  *  @brief      CfgConnectResult
  *  @details
  *  @param[in] tenuConnDisconnEvent enuConnDisconnEvent: Type of connection response either
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 9d257b06c853..f702cca2095a 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -193,8 +193,6 @@ static int wilc_wlan_txq_add_to_head(struct txq_entry_t *tqe)
 	return 0;
 }
 
-u32 total_acks = 0, dropped_acks = 0;
-
 #ifdef	TCP_ACK_FILTER
 struct ack_session_info;
 struct ack_session_info {
@@ -249,7 +247,6 @@ static inline int update_tcp_session(u32 index, u32 ack)
 static inline int add_tcp_pending_ack(u32 ack, u32 session_index,
 				      struct txq_entry_t *txqe)
 {
-	total_acks++;
 	if (pending_acks < MAX_PENDING_ACKS) {
 		pending_acks_info[pending_base + pending_acks].ack_num = ack;
 		pending_acks_info[pending_base + pending_acks].txqe = txqe;
@@ -361,7 +358,6 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 			tqe = pending_acks_info[i].txqe;
 			if (tqe) {
 				wilc_wlan_txq_remove(tqe);
-				dropped_acks++;
 				tqe->status = 1;
 				if (tqe->tx_complete_func)
 					tqe->tx_complete_func(tqe->priv,
-- 
2.1.0.rc2

