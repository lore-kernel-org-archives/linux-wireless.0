Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:53826 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbbJTWsK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 18:48:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-wireless@vger.kernel.org
Cc: Rachel Kim <rachel.kim@atmel.com>, devel@driverdev.osuosl.org,
	Chris Park <chris.park@atmel.com>, gregkh@linuxfoundation.org,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	linux-kernel@vger.kernel.org, Tony Cho <tony.cho@atmel.com>,
	Glen Lee <glen.lee@atmel.com>, Leo Kim <leo.kim@atmel.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 01/19] staging/wilc1000: remove unused functions
Date: Wed, 21 Oct 2015 00:47:20 +0200
Message-Id: <1445381258-1455986-2-git-send-email-arnd@arndb.de> (sfid-20151021_005414_278174_007CBAEA)
In-Reply-To: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
References: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A number of symbols in the wilc1000 driver are completely unused
and can be removed.
This includes two variables that are only written but not read.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/host_interface.c         | 311 ----------------------
 drivers/staging/wilc1000/host_interface.h         | 208 +--------------
 drivers/staging/wilc1000/wilc_sdio.c              |  56 ----
 drivers/staging/wilc1000/wilc_spi.c               | 225 ----------------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  35 ---
 drivers/staging/wilc1000/wilc_wlan.c              |   4 -
 6 files changed, 1 insertion(+), 838 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 38fead44cce0..194ca3d3e920 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3421,36 +3421,6 @@ s32 host_int_set_pmkid_info(struct host_if_drv *hif_drv, struct host_if_pmkid_at
 	return s32Error;
 }
 
-s32 host_int_get_pmkid_info(struct host_if_drv *hif_drv,
-			    u8 *pu8PmkidInfoArray,
-			    u32 u32PmkidInfoLen)
-{
-	struct wid strWID;
-
-	strWID.id = (u16)WID_PMKID_INFO;
-	strWID.type = WID_STR;
-	strWID.size = u32PmkidInfoLen;
-	strWID.val = pu8PmkidInfoArray;
-
-	return 0;
-}
-
-s32 host_int_set_RSNAConfigPSKPassPhrase(struct host_if_drv *hif_drv,
-					 u8 *pu8PassPhrase,
-					 u8 u8Psklength)
-{
-	struct wid strWID;
-
-	if ((u8Psklength > 7) && (u8Psklength < 65)) {
-		strWID.id = (u16)WID_11I_PSK;
-		strWID.type = WID_STR;
-		strWID.val = pu8PassPhrase;
-		strWID.size = u8Psklength;
-	}
-
-	return 0;
-}
-
 s32 host_int_get_MacAddress(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
 {
 	s32 s32Error = 0;
@@ -3492,19 +3462,6 @@ s32 host_int_set_MacAddress(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
 
 }
 
-s32 host_int_get_RSNAConfigPSKPassPhrase(struct host_if_drv *hif_drv,
-					 u8 *pu8PassPhrase, u8 u8Psklength)
-{
-	struct wid strWID;
-
-	strWID.id = (u16)WID_11I_PSK;
-	strWID.type = WID_STR;
-	strWID.size = u8Psklength;
-	strWID.val = pu8PassPhrase;
-
-	return 0;
-}
-
 s32 host_int_set_start_scan_req(struct host_if_drv *hif_drv, u8 scanSource)
 {
 	struct wid strWID;
@@ -3517,18 +3474,6 @@ s32 host_int_set_start_scan_req(struct host_if_drv *hif_drv, u8 scanSource)
 	return 0;
 }
 
-s32 host_int_get_start_scan_req(struct host_if_drv *hif_drv, u8 *pu8ScanSource)
-{
-	struct wid strWID;
-
-	strWID.id = (u16)WID_START_SCAN_REQ;
-	strWID.type = WID_CHAR;
-	strWID.val = (s8 *)pu8ScanSource;
-	strWID.size = sizeof(char);
-
-	return 0;
-}
-
 s32 host_int_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
 			  const u8 *pu8ssid, size_t ssidLen,
 			  const u8 *pu8IEs, size_t IEsLen,
@@ -3649,31 +3594,6 @@ s32 host_int_disconnect(struct host_if_drv *hif_drv, u16 u16ReasonCode)
 	return s32Error;
 }
 
-s32 host_int_disconnect_station(struct host_if_drv *hif_drv, u8 assoc_id)
-{
-	struct wid strWID;
-
-	strWID.id = (u16)WID_DISCONNECT;
-	strWID.type = WID_CHAR;
-	strWID.val = (s8 *)&assoc_id;
-	strWID.size = sizeof(char);
-
-	return 0;
-}
-
-s32 host_int_get_assoc_req_info(struct host_if_drv *hif_drv, u8 *pu8AssocReqInfo,
-					u32 u32AssocReqInfoLen)
-{
-	struct wid strWID;
-
-	strWID.id = (u16)WID_ASSOC_REQ_INFO;
-	strWID.type = WID_STR;
-	strWID.val = pu8AssocReqInfo;
-	strWID.size = u32AssocReqInfoLen;
-
-	return 0;
-}
-
 s32 host_int_get_assoc_res_info(struct host_if_drv *hif_drv, u8 *pu8AssocRespInfo,
 					u32 u32MaxAssocRespInfoLen, u32 *pu32RcvdAssocRespInfoLen)
 {
@@ -3703,19 +3623,6 @@ s32 host_int_get_assoc_res_info(struct host_if_drv *hif_drv, u8 *pu8AssocRespInf
 	return s32Error;
 }
 
-s32 host_int_get_rx_power_level(struct host_if_drv *hif_drv, u8 *pu8RxPowerLevel,
-					u32 u32RxPowerLevelLen)
-{
-	struct wid strWID;
-
-	strWID.id = (u16)WID_RX_POWER_LEVEL;
-	strWID.type = WID_STR;
-	strWID.val = pu8RxPowerLevel;
-	strWID.size = u32RxPowerLevelLen;
-
-	return 0;
-}
-
 int host_int_set_mac_chnl_num(struct host_if_drv *hif_drv, u8 channel)
 {
 	int result;
@@ -3796,33 +3703,6 @@ int host_int_set_operation_mode(struct host_if_drv *hif_drv, u32 mode)
 	return result;
 }
 
-s32 host_int_get_host_chnl_num(struct host_if_drv *hif_drv, u8 *pu8ChNo)
-{
-	s32 s32Error = 0;
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
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (s32Error)
-		PRINT_ER("wilc mq send fail\n");
-	down(&hif_drv->hSemGetCHNL);
-
-	*pu8ChNo = ch_no;
-
-	return s32Error;
-
-
-}
-
 s32 host_int_get_inactive_time(struct host_if_drv *hif_drv,
 			       const u8 *mac, u32 *pu32InactiveTime)
 {
@@ -3854,36 +3734,6 @@ s32 host_int_get_inactive_time(struct host_if_drv *hif_drv,
 	return s32Error;
 }
 
-s32 host_int_test_get_int_wid(struct host_if_drv *hif_drv, u32 *pu32TestMemAddr)
-{
-
-	s32 s32Error = 0;
-	struct wid strWID;
-
-	if (!hif_drv) {
-		PRINT_ER("driver is null\n");
-		return -EFAULT;
-	}
-
-	strWID.id = (u16)WID_MEMORY_ADDRESS;
-	strWID.type = WID_INT;
-	strWID.val = (s8 *)pu32TestMemAddr;
-	strWID.size = sizeof(u32);
-
-	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
-				   get_id_from_handler(hif_drv));
-
-	if (s32Error) {
-		PRINT_ER("Failed to get wid value\n");
-		return -EINVAL;
-	} else {
-		PRINT_D(HOSTINF_DBG, "Successfully got wid value\n");
-
-	}
-
-	return s32Error;
-}
-
 s32 host_int_get_rssi(struct host_if_drv *hif_drv, s8 *ps8Rssi)
 {
 	s32 s32Error = 0;
@@ -3912,34 +3762,6 @@ s32 host_int_get_rssi(struct host_if_drv *hif_drv, s8 *ps8Rssi)
 	return s32Error;
 }
 
-s32 host_int_get_link_speed(struct host_if_drv *hif_drv, s8 *ps8lnkspd)
-{
-	struct host_if_msg msg;
-	s32 s32Error = 0;
-	memset(&msg, 0, sizeof(struct host_if_msg));
-
-	msg.id = HOST_IF_MSG_GET_LINKSPEED;
-	msg.drv = hif_drv;
-
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (s32Error) {
-		PRINT_ER("Failed to send GET_LINKSPEED to message queue ");
-		return -EFAULT;
-	}
-
-	down(&hif_drv->hSemGetLINKSPEED);
-
-
-	if (ps8lnkspd == NULL) {
-		PRINT_ER("LINKSPEED pointer value is null");
-		return -EFAULT;
-	}
-
-	*ps8lnkspd = link_speed;
-
-	return s32Error;
-}
-
 s32 host_int_get_statistics(struct host_if_drv *hif_drv, struct rf_info *pstrStatistics)
 {
 	s32 s32Error = 0;
@@ -4038,106 +3860,6 @@ s32 hif_set_cfg(struct host_if_drv *hif_drv,
 
 }
 
-s32 hif_get_cfg(struct host_if_drv *hif_drv, u16 u16WID, u16 *pu16WID_Value)
-{
-	s32 s32Error = 0;
-
-	down(&hif_drv->gtOsCfgValuesSem);
-
-	if (!hif_drv) {
-		PRINT_ER("hif_drv NULL\n");
-		return -EFAULT;
-	}
-	PRINT_D(HOSTINF_DBG, "Getting configuration parameters\n");
-	switch (u16WID)	{
-
-	case WID_BSS_TYPE:
-		*pu16WID_Value = (u16)hif_drv->strCfgValues.bss_type;
-		break;
-
-	case WID_AUTH_TYPE:
-		*pu16WID_Value = (u16)hif_drv->strCfgValues.auth_type;
-		break;
-
-	case WID_AUTH_TIMEOUT:
-		*pu16WID_Value = hif_drv->strCfgValues.auth_timeout;
-		break;
-
-	case WID_POWER_MANAGEMENT:
-		*pu16WID_Value = (u16)hif_drv->strCfgValues.power_mgmt_mode;
-		break;
-
-	case WID_SHORT_RETRY_LIMIT:
-		*pu16WID_Value =       hif_drv->strCfgValues.short_retry_limit;
-		break;
-
-	case WID_LONG_RETRY_LIMIT:
-		*pu16WID_Value = hif_drv->strCfgValues.long_retry_limit;
-		break;
-
-	case WID_FRAG_THRESHOLD:
-		*pu16WID_Value = hif_drv->strCfgValues.frag_threshold;
-		break;
-
-	case WID_RTS_THRESHOLD:
-		*pu16WID_Value = hif_drv->strCfgValues.rts_threshold;
-		break;
-
-	case WID_PREAMBLE:
-		*pu16WID_Value = (u16)hif_drv->strCfgValues.preamble_type;
-		break;
-
-	case WID_SHORT_SLOT_ALLOWED:
-		*pu16WID_Value = (u16) hif_drv->strCfgValues.short_slot_allowed;
-		break;
-
-	case WID_11N_TXOP_PROT_DISABLE:
-		*pu16WID_Value = (u16)hif_drv->strCfgValues.txop_prot_disabled;
-		break;
-
-	case WID_BEACON_INTERVAL:
-		*pu16WID_Value = hif_drv->strCfgValues.beacon_interval;
-		break;
-
-	case WID_DTIM_PERIOD:
-		*pu16WID_Value = (u16)hif_drv->strCfgValues.dtim_period;
-		break;
-
-	case WID_SITE_SURVEY:
-		*pu16WID_Value = (u16)hif_drv->strCfgValues.site_survey_enabled;
-		break;
-
-	case WID_SITE_SURVEY_SCAN_TIME:
-		*pu16WID_Value = hif_drv->strCfgValues.site_survey_scan_time;
-		break;
-
-	case WID_ACTIVE_SCAN_TIME:
-		*pu16WID_Value = hif_drv->strCfgValues.active_scan_time;
-		break;
-
-	case WID_PASSIVE_SCAN_TIME:
-		*pu16WID_Value = hif_drv->strCfgValues.passive_scan_time;
-		break;
-
-	case WID_CURRENT_TX_RATE:
-		*pu16WID_Value = hif_drv->strCfgValues.curr_tx_rate;
-		break;
-
-	default:
-		break;
-	}
-
-	up(&hif_drv->gtOsCfgValuesSem);
-
-	return s32Error;
-
-}
-
-void host_int_send_join_leave_info_to_host
-	(u16 assocId, u8 *stationAddr, bool joining)
-{
-}
-
 static void GetPeriodicRSSI(unsigned long arg)
 {
 	struct host_if_drv *hif_drv = (struct host_if_drv *)arg;
@@ -4167,11 +3889,6 @@ static void GetPeriodicRSSI(unsigned long arg)
 }
 
 
-void host_int_send_network_info_to_host
-	(u8 *macStartAddress, u16 u16RxFrameLen, s8 s8Rssi)
-{
-}
-
 static u32 clients_count;
 
 s32 host_int_init(struct host_if_drv **hif_drv_handler)
@@ -5018,34 +4735,6 @@ void host_int_freeJoinParams(void *pJoinParams)
 		PRINT_ER("Unable to FREE null pointer\n");
 }
 
-s32 host_int_delBASession(struct host_if_drv *hif_drv, char *pBSSID, char TID)
-{
-	s32 s32Error = 0;
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
-	memcpy(pBASessionInfo->au8Bssid, pBSSID, ETH_ALEN);
-	pBASessionInfo->u8Ted = TID;
-	msg.drv = hif_drv;
-
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (s32Error)
-		PRINT_ER("wilc_mq_send fail\n");
-
-	down(&hif_sema_wait_response);
-
-	return s32Error;
-}
-
 s32 host_int_del_All_Rx_BASession(struct host_if_drv *hif_drv,
 				  char *pBSSID,
 				  char TID)
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 146a60f52cb7..3df74f1bf9ff 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -517,65 +517,6 @@ s32 host_int_add_tx_gtk(struct host_if_drv *hWFIDrv, u8 u8KeyLen, u8 *pu8TxGtk,
 
 s32 host_int_set_pmkid_info(struct host_if_drv *hWFIDrv, struct host_if_pmkid_attr *pu8PmkidInfoArray);
 /**
- *  @brief              gets the cached the pmkid info
- *  @details    valid only in BSS STA mode if External Supplicant
- *                              support is enabled. This Function sets the PMKID in firmware
- *                              when host drivr receives the corresponding request from NDIS.
- *                              The firmware then includes theset PMKID in the appropriate
- *                              management frames
- *  @param[in,out] handle to the wifi driver,
- *
- *                                message containing PMKID Info in the following format
- *|-----------------------------------------------------------------|
- *|NumEntries |	BSSID[1] | PMKID[1] |  ...	| BSSID[K] | PMKID[K] |
- *|-----------|------------|----------|-------|----------|----------|
- |	   1	|		6	 |   16		|  ...	|	 6	   |	16	  |
- ||-----------------------------------------------------------------|
- *  @param[in]
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
-
-s32 host_int_get_pmkid_info(struct host_if_drv *hWFIDrv, u8 *pu8PmkidInfoArray,
-				    u32 u32PmkidInfoLen);
-
-/**
- *  @brief              sets the pass phrase
- *  @details    AP/STA mode. This function gives the pass phrase used to
- *                              generate the Pre-Shared Key when WPA/WPA2 is enabled
- *                              The length of the field can vary from 8 to 64 bytes,
- *                              the lower layer should get the
- *  @param[in,out] handle to the wifi driver,
- *  @param[in]   String containing PSK
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
-s32 host_int_set_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv, u8 *pu8PassPhrase,
-						 u8 u8Psklength);
-/**
- *  @brief              gets the pass phrase
- *  @details    AP/STA mode. This function gets the pass phrase used to
- *                              generate the Pre-Shared Key when WPA/WPA2 is enabled
- *                              The length of the field can vary from 8 to 64 bytes,
- *                              the lower layer should get the
- *  @param[in,out] handle to the wifi driver,
- *                                String containing PSK
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
-s32 host_int_get_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv,
-						 u8 *pu8PassPhrase, u8 u8Psklength);
-
-/**
  *  @brief              gets mac address
  *  @details
  *  @param[in,out] handle to the wifi driver,
@@ -631,22 +572,6 @@ int host_int_wait_msg_queue_idle(void);
  */
 
 s32 host_int_set_start_scan_req(struct host_if_drv *hWFIDrv, u8 scanSource);
-/**
- *  @brief              gets scan source of the last scan
- *  @details
- *  @param[in,out] handle to the wifi driver,
- *                              Scan Source one of the following values
- *                              DEFAULT_SCAN        0
- *                              USER_SCAN           BIT0
- *                              OBSS_PERIODIC_SCAN  BIT1
- *                              OBSS_ONETIME_SCAN   BIT2
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
-s32 host_int_get_start_scan_req(struct host_if_drv *hWFIDrv, u8 *pu8ScanSource);
 
 /**
  *  @brief              sets a join request
@@ -697,46 +622,6 @@ s32 host_int_flush_join_req(struct host_if_drv *hWFIDrv);
 s32 host_int_disconnect(struct host_if_drv *hWFIDrv, u16 u16ReasonCode);
 
 /**
- *  @brief              disconnects a sta
- *  @details
- *  @param[in,out] handle to the wifi driver,
- *  @param[in]	Association Id of the station to be disconnected
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
-s32 host_int_disconnect_station(struct host_if_drv *hWFIDrv, u8 assoc_id);
-/**
- *  @brief              gets a Association request info
- *  @details
- *  @param[in,out] handle to the wifi driver,
- *                              Message containg assoc. req info in the following format
- * ------------------------------------------------------------------------
- |                        Management Frame Format                    |
- ||-------------------------------------------------------------------|
- ||Frame Control|Duration|DA|SA|BSSID|Sequence Control|Frame Body|FCS |
- ||-------------|--------|--|--|-----|----------------|----------|----|
- | 2           |2       |6 |6 |6    |		2       |0 - 2312  | 4  |
- ||-------------------------------------------------------------------|
- |                                                                   |
- |             Association Request Frame - Frame Body                |
- ||-------------------------------------------------------------------|
- | Capability Information | Listen Interval | SSID | Supported Rates |
- ||------------------------|-----------------|------|-----------------|
- |			2            |		 2         | 2-34 |		3-10        |
- | ---------------------------------------------------------------------
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
-
-s32 host_int_get_assoc_req_info(struct host_if_drv *hWFIDrv, u8 *pu8AssocReqInfo,
-					u32 u32AssocReqInfoLen);
-/**
  *  @brief              gets a Association Response info
  *  @details
  *  @param[in,out] handle to the wifi driver,
@@ -750,23 +635,6 @@ s32 host_int_get_assoc_req_info(struct host_if_drv *hWFIDrv, u8 *pu8AssocReqInfo
 
 s32 host_int_get_assoc_res_info(struct host_if_drv *hWFIDrv, u8 *pu8AssocRespInfo,
 					u32 u32MaxAssocRespInfoLen, u32 *pu32RcvdAssocRespInfoLen);
-/**
- *  @brief              gets a Association Response info
- *  @details    Valid only in STA mode. This function gives the RSSI
- *                              values observed in all the channels at the time of scanning.
- *                              The length of the field is 1 greater that the total number of
- *                              channels supported. Byte 0 contains the number of channels while
- *                              each of Byte N contains	the observed RSSI value for the channel index N.
- *  @param[in,out] handle to the wifi driver,
- *                              array of scanned channels' RSSI
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
-s32 host_int_get_rx_power_level(struct host_if_drv *hWFIDrv, u8 *pu8RxPowerLevel,
-					u32 u32RxPowerLevelLen);
 
 /**
  *  @brief              sets a channel
@@ -786,22 +654,6 @@ s32 host_int_get_rx_power_level(struct host_if_drv *hWFIDrv, u8 *pu8RxPowerLevel
 int host_int_set_mac_chnl_num(struct host_if_drv *wfi_drv, u8 channel);
 
 /**
- *  @brief              gets the current channel index
- *  @details
- *  @param[in,out] handle to the wifi driver,
- *                              current channel index
- *|-----------------------------------------------------------------------|
- |          CHANNEL1      CHANNEL2 ....                     CHANNEL14	|
- |  Input:         1             2                                 14	|
- ||-----------------------------------------------------------------------|
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
-s32 host_int_get_host_chnl_num(struct host_if_drv *hWFIDrv, u8 *pu8ChNo);
-/**
  *  @brief              gets the sta rssi
  *  @details    gets the currently maintained RSSI value for the station.
  *                              The received signal strength value in dB.
@@ -815,7 +667,7 @@ s32 host_int_get_host_chnl_num(struct host_if_drv *hWFIDrv, u8 *pu8ChNo);
  *  @version		1.0
  */
 s32 host_int_get_rssi(struct host_if_drv *hWFIDrv, s8 *ps8Rssi);
-s32 host_int_get_link_speed(struct host_if_drv *hWFIDrv, s8 *ps8lnkspd);
+
 /**
  *  @brief              scans a set of channels
  *  @details
@@ -852,55 +704,9 @@ s32 host_int_scan(struct host_if_drv *hWFIDrv, u8 u8ScanSource,
  */
 s32 hif_set_cfg(struct host_if_drv *hWFIDrv, struct cfg_param_val *pstrCfgParamVal);
 
-/**
- *  @brief              gets configuration wids values
- *  @details
- *  @param[in,out] handle to the wifi driver,
- *                              WID value
- *  @param[in]	WID,
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
-s32 hif_get_cfg(struct host_if_drv *hWFIDrv, u16 u16WID, u16 *pu16WID_Value);
 /*****************************************************************************/
 /*							Notification Functions							 */
 /*****************************************************************************/
-/**
- *  @brief              notifies host with join and leave requests
- *  @details    This function prepares an Information frame having the
- *                              information about a joining/leaving station.
- *  @param[in,out] handle to the wifi driver,
- *  @param[in]	6 byte Sta Adress
- *                              Join or leave flag:
- *                              Join = 1,
- *                              Leave =0
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
-void host_int_send_join_leave_info_to_host
-	(u16 assocId, u8 *stationAddr, bool joining);
-
-/**
- *  @brief              notifies host with stations found in scan
- *  @details    sends the beacon/probe response from scan
- *  @param[in,out] handle to the wifi driver,
- *  @param[in]	Sta Address,
- *                              Frame length,
- *                              Rssi of the Station found
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
-void host_int_send_network_info_to_host
-	(u8 *macStartAddress, u16 u16RxFrameLen, s8 s8Rssi);
 
 /**
  *  @brief              host interface initialization function
@@ -1070,18 +876,6 @@ s32 host_int_setup_multicast_filter(struct host_if_drv *hWFIDrv, bool bIsEnabled
  */
 s32 host_int_setup_ipaddress(struct host_if_drv *hWFIDrv, u8 *pu8IPAddr, u8 idx);
 
-
-/**
- *  @brief           host_int_delBASession
- *  @details       Delete single Rx BA session
- *  @param[in]
- *  @return         Error code.
- *  @author		Abdelrahman Sobhy
- *  @date
- *  @version	1.0
- */
-s32 host_int_delBASession(struct host_if_drv *hWFIDrv, char *pBSSID, char TID);
-
 /**
  *  @brief           host_int_delBASession
  *  @details       Delete all Rx BA session
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 300c571e4e2d..4425b5f369e0 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -160,67 +160,11 @@ static int sdio_clear_int(void)
 
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
-	g_sdio.sdio_cmd52(&cmd);
-	cnt = cmd.data;
-
-	cmd.read_write = 0;
-	cmd.function = 1;
-	cmd.raw = 0;
-	cmd.address = 0x1D;
-	cmd.data = 0;
-	g_sdio.sdio_cmd52(&cmd);
-	cnt |= (cmd.data << 8);
-
-	cmd.read_write = 0;
-	cmd.function = 1;
-	cmd.raw = 0;
-	cmd.address = 0x1E;
-	cmd.data = 0;
-	g_sdio.sdio_cmd52(&cmd);
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
-	if (!g_sdio.sdio_cmd52(&cmd)) {
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
index 599508beabf8..732c3f8c7f32 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -111,163 +111,6 @@ static u8 crc7(u8 crc, const u8 *buffer, u32 len)
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
-		if (!g_spi.spi_tx(bc, len)) {
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
-		if (!g_spi.spi_rx(&rsp, 1)) {
-			result = N_FAIL;
-			goto _fail_;
-		}
-	}
-
-	if (!g_spi.spi_rx(&rsp, 1)) {
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
-	if (!g_spi.spi_rx(&rsp, 1)) {
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
@@ -607,74 +450,6 @@ _error_:
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
-			if (!g_spi.spi_rx(&rsp, 1)) {
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
-		if (!g_spi.spi_rx(&b[ix], nbytes)) {
-			PRINT_ER("[wilc spi]: Failed data block read, bus error...\n");
-			result = N_FAIL;
-			break;
-		}
-
-		/**
-		 *      Read Crc
-		 **/
-		if (!g_spi.crc_off) {
-			if (!g_spi.spi_rx(crc, 2)) {
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
index bcbf1bd29a50..18e40e515a48 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -473,41 +473,6 @@ static void CfgScanResult(enum scan_event enuScanEvent, tstrNetworkInfo *pstrNet
 }
 
 
-/**
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
 int linux_wlan_set_bssid(struct net_device *wilc_netdev, u8 *pBSSID);
 
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index c73164165323..c8564249092c 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -254,8 +254,6 @@ static int wilc_wlan_txq_add_to_head(struct txq_entry_t *tqe)
 
 }
 
-u32 Statisitcs_totalAcks = 0, Statisitcs_DroppedAcks = 0;
-
 #ifdef	TCP_ACK_FILTER
 struct Ack_session_info;
 struct Ack_session_info {
@@ -319,7 +317,6 @@ static inline int Update_TCP_track_session(u32 index, u32 Ack)
 }
 static inline int add_TCP_Pending_Ack(u32 Ack, u32 Session_index, struct txq_entry_t  *txqe)
 {
-	Statisitcs_totalAcks++;
 	if (Pending_Acks < MAX_PENDING_ACKS) {
 		Pending_Acks_info[PendingAcks_arrBase + Pending_Acks].ack_num = Ack;
 		Pending_Acks_info[PendingAcks_arrBase + Pending_Acks].txqe = txqe;
@@ -422,7 +419,6 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(void)
 			tqe = Pending_Acks_info[i].txqe;
 			if (tqe) {
 				wilc_wlan_txq_remove(tqe);
-				Statisitcs_DroppedAcks++;
 				tqe->status = 1;                                /* mark the packet send */
 				if (tqe->tx_complete_func)
 					tqe->tx_complete_func(tqe->priv, tqe->status);
-- 
2.1.0.rc2

