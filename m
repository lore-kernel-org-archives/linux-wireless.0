Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:42174 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122AbbJ1HAi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:00:38 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 30/80] staging: wilc1000: host_interface.h : remove over-commenting
Date: Wed, 28 Oct 2015 15:59:50 +0900
Message-ID: <1446015640-29398-30-git-send-email-glen.lee@atmel.com> (sfid-20151028_081659_127025_795166C2)
In-Reply-To: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

There are over-commenting in the host_interface.h file and most of them
are not helpful to explain what the code does and generate 80 ending
line over warnings. So, all of comments are removed in this patch and the
comments will later be added if necessary with the preferred Linux style.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.h | 740 +-----------------------------
 1 file changed, 4 insertions(+), 736 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 1a41e3f..627ea43 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -1,12 +1,3 @@
-/*!
- *  @file	host_interface.h
- *  @brief	File containg host interface APIs
- *  @author	zsalah
- *  @sa		host_interface.c
- *  @date	8 March 2012
- *  @version	1.0
- */
-
 #ifndef HOST_INT_H
 #define HOST_INT_H
 
@@ -173,31 +164,18 @@ enum KEY_TYPE {
 	PMKSA,
 };
 
-
-/*Scan callBack function definition*/
 typedef void (*wilc_scan_result)(enum scan_event, tstrNetworkInfo *,
 				  void *, void *);
 
-/*Connect callBack function definition*/
 typedef void (*wilc_connect_result)(enum conn_event,
 				     tstrConnectInfo *,
 				     u8,
 				     tstrDisconnectNotifInfo *,
 				     void *);
 
-typedef void (*wilc_remain_on_chan_expired)(void *, u32);  /*Remain on channel expiration callback function*/
-typedef void (*wilc_remain_on_chan_ready)(void *); /*Remain on channel callback function*/
+typedef void (*wilc_remain_on_chan_expired)(void *, u32);
+typedef void (*wilc_remain_on_chan_ready)(void *);
 
-/*!
- *  @struct             rcvd_net_info
- *  @brief		Structure to hold Received Asynchronous Network info
- *  @details
- *  @todo
- *  @sa
- *  @author		Mostafa Abu Bakr
- *  @date		25 March 2012
- *  @version		1.0
- */
 struct rcvd_net_info {
 	u8 *buffer;
 	u32 len;
@@ -214,10 +192,7 @@ struct hidden_network {
 };
 
 struct user_scan_req {
-	/* Scan user call back function */
 	wilc_scan_result pfUserScanResult;
-
-	/* User specific parameter to be delivered through the Scan User Callback function */
 	void *u32UserScanPvoid;
 
 	u32 u32RcvdChCount;
@@ -232,10 +207,8 @@ struct user_conn_req {
 	size_t ssidLen;
 	u8 *pu8ConnReqIEs;
 	size_t ConnReqIEsLen;
-	/* Connect user call back function */
 	wilc_connect_result pfUserConnectResult;
 	bool IsHTCapable;
-	/* User specific parameter to be delivered through the Connect User Callback function */
 	void *u32UserConnectPvoid;
 };
 
@@ -331,332 +304,34 @@ struct add_sta_param {
 	u16 u16HTExtParams;
 	u32 u32TxBeamformingCap;
 	u8 u8ASELCap;
-	u16 u16FlagsMask;               /*<! Determines which of u16FlagsSet were changed>*/
-	u16 u16FlagsSet;                /*<! Decoded according to tenuWILC_StaFlag */
+	u16 u16FlagsMask;
+	u16 u16FlagsSet;
 };
 
-/*****************************************************************************/
-/*																			 */
-/*							Host Interface API								 */
-/*																			 */
-/*****************************************************************************/
-
-/**
- *  @brief              removes wpa/wpa2 keys
- *  @details    only in BSS STA mode if External Supplicant support is enabled.
- *                              removes all WPA/WPA2 station key entries from MAC hardware.
- *  @param[in,out] handle to the wifi driver
- *  @param[in]  6 bytes of Station Adress in the station entry table
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
 s32 host_int_remove_key(struct host_if_drv *hWFIDrv, const u8 *pu8StaAddress);
-/**
- *  @brief              removes WEP key
- *  @details    valid only in BSS STA mode if External Supplicant support is enabled.
- *                              remove a WEP key entry from MAC HW.
- *                              The BSS Station automatically finds the index of the entry using its
- *                              BSS ID and removes that entry from the MAC hardware.
- *  @param[in,out] handle to the wifi driver
- *  @param[in]  6 bytes of Station Adress in the station entry table
- *  @return             Error code indicating success/failure
- *  @note               NO need for the STA add since it is not used for processing
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
 int host_int_remove_wep_key(struct host_if_drv *wfi_drv, u8 index);
-/**
- *  @brief              sets WEP deafault key
- *  @details    Sets the index of the WEP encryption key in use,
- *                              in the key table
- *  @param[in,out] handle to the wifi driver
- *  @param[in]  key index ( 0, 1, 2, 3)
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
 int host_int_set_wep_default_key(struct host_if_drv *hif_drv, u8 index);
-
-/**
- *  @brief              sets WEP deafault key
- *  @details    valid only in BSS STA mode if External Supplicant support is enabled.
- *                              sets WEP key entry into MAC hardware when it receives the
- *                              corresponding request from NDIS.
- *  @param[in,out] handle to the wifi driver
- *  @param[in]  message containing WEP Key in the following format
- *|---------------------------------------|
- *|Key ID Value | Key Length |	Key		|
- *|-------------|------------|------------|
- |	1byte	  |		1byte  | Key Length	|
- ||---------------------------------------|
- |
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
 s32 host_int_add_wep_key_bss_sta(struct host_if_drv *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx);
-/**
- *  @brief              host_int_add_wep_key_bss_ap
- *  @details    valid only in AP mode if External Supplicant support is enabled.
- *                              sets WEP key entry into MAC hardware when it receives the
- *                              corresponding request from NDIS.
- *  @param[in,out] handle to the wifi driver
- *
- *
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		mdaftedar
- *  @date		28 Feb 2013
- *  @version		1.0
- */
 s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx, u8 u8mode, enum AUTHTYPE tenuAuth_type);
-
-/**
- *  @brief              adds ptk Key
- *  @details
- *  @param[in,out] handle to the wifi driver
- *  @param[in]  message containing PTK Key in the following format
- *|-------------------------------------------------------------------------|
- *|Sta Adress | Key Length |	Temporal Key | Rx Michael Key |Tx Michael Key |
- *|-----------|------------|---------------|----------------|---------------|
- |	6 bytes |	1byte	 |   16 bytes	 |	  8 bytes	  |	   8 bytes	  |
- ||-------------------------------------------------------------------------|
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
 s32 host_int_add_ptk(struct host_if_drv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 			     const u8 *mac_addr, const u8 *pu8RxMic, const u8 *pu8TxMic, u8 mode, u8 u8Ciphermode, u8 u8Idx);
-
-/**
- *  @brief              host_int_get_inactive_time
- *  @details
- *  @param[in,out] handle to the wifi driver
- *  @param[in]  message containing inactive time
- *
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		mdaftedar
- *  @date		15 April 2013
- *  @version		1.0
- */
 s32 host_int_get_inactive_time(struct host_if_drv *hWFIDrv, const u8 *mac, u32 *pu32InactiveTime);
-
-/**
- *  @brief              adds Rx GTk Key
- *  @details
- *  @param[in,out] handle to the wifi driver
- *  @param[in]  message containing Rx GTK Key in the following format
- *|----------------------------------------------------------------------------|
- *|Sta Address | Key RSC | KeyID | Key Length | Temporal Key	| Rx Michael Key |
- *|------------|---------|-------|------------|---------------|----------------|
- |	6 bytes	 | 8 byte  |1 byte |  1 byte	|   16 bytes	|	  8 bytes	 |
- ||----------------------------------------------------------------------------|
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
 s32 host_int_add_rx_gtk(struct host_if_drv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKeylen,
 				u8 u8KeyIdx, u32 u32KeyRSClen, const u8 *KeyRSC,
 				const u8 *pu8RxMic, const u8 *pu8TxMic, u8 mode, u8 u8Ciphermode);
-
-
-/**
- *  @brief              adds Tx GTk Key
- *  @details
- *  @param[in,out] handle to the wifi driver
- *  @param[in]  message containing Tx GTK Key in the following format
- *|----------------------------------------------------|
- | KeyID | Key Length | Temporal Key	| Tx Michael Key |
- ||-------|------------|--------------|----------------|
- ||1 byte |  1 byte	 |   16 bytes	|	  8 bytes	 |
- ||----------------------------------------------------|
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
 s32 host_int_add_tx_gtk(struct host_if_drv *hWFIDrv, u8 u8KeyLen, u8 *pu8TxGtk, u8 u8KeyIdx);
-
-/**
- *  @brief              caches the pmkid
- *  @details    valid only in BSS STA mode if External Supplicant
- *                              support is enabled. This Function sets the PMKID in firmware
- *                              when host drivr receives the corresponding request from NDIS.
- *                              The firmware then includes theset PMKID in the appropriate
- *                              management frames
- *  @param[in,out] handle to the wifi driver
- *  @param[in]  message containing PMKID Info in the following format
- *|-----------------------------------------------------------------|
- *|NumEntries |	BSSID[1] | PMKID[1] |  ...	| BSSID[K] | PMKID[K] |
- *|-----------|------------|----------|-------|----------|----------|
- |	   1	|		6	 |   16		|  ...	|	 6	   |	16	  |
- ||-----------------------------------------------------------------|
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
-
 s32 host_int_set_pmkid_info(struct host_if_drv *hWFIDrv, struct host_if_pmkid_attr *pu8PmkidInfoArray);
-/**
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
 s32 host_int_get_pmkid_info(struct host_if_drv *hWFIDrv, u8 *pu8PmkidInfoArray,
 				    u32 u32PmkidInfoLen);
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
 s32 host_int_set_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv, u8 *pu8PassPhrase,
 						 u8 u8Psklength);
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
 s32 host_int_get_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv,
 						 u8 *pu8PassPhrase, u8 u8Psklength);
-
-/**
- *  @brief              gets mac address
- *  @details
- *  @param[in,out] handle to the wifi driver,
- *
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		mdaftedar
- *  @date		19 April 2012
- *  @version		1.0
- */
 s32 host_int_get_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress);
-
-/**
- *  @brief              sets mac address
- *  @details
- *  @param[in,out] handle to the wifi driver,
- *
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		mabubakr
- *  @date		16 July 2012
- *  @version		1.0
- */
 s32 host_int_set_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress);
-
-/**
- *  @brief              wait until msg q is empty
- *  @details
- *  @param[in,out]
- *
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		asobhy
- *  @date		19 march 2014
- *  @version		1.0
- */
 int host_int_wait_msg_queue_idle(void);
-
-/**
- *  @brief              sets a start scan request
- *  @details
- *  @param[in,out] handle to the wifi driver,
- *  @param[in]	Scan Source one of the following values
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
-
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
 s32 host_int_get_start_scan_req(struct host_if_drv *hWFIDrv, u8 *pu8ScanSource);
-
-/**
- *  @brief              sets a join request
- *  @details
- *  @param[in,out] handle to the wifi driver,
- *  @param[in]	Index of the bss descriptor
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
-
 s32 host_int_set_join_req(struct host_if_drv *hWFIDrv, u8 *pu8bssid,
 				  const u8 *pu8ssid, size_t ssidLen,
 				  const u8 *pu8IEs, size_t IEsLen,
@@ -664,456 +339,49 @@ s32 host_int_set_join_req(struct host_if_drv *hWFIDrv, u8 *pu8bssid,
 				  u8 u8security, enum AUTHTYPE tenuAuth_type,
 				  u8 u8channel,
 				  void *pJoinParams);
-
-/**
- *  @brief              Flush a join request parameters to FW, but actual connection
- *  @details    The function is called in situation where WILC is connected to AP and
- *                      required to switch to hybrid FW for P2P connection
- *  @param[in] handle to the wifi driver,
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		Amr Abdel-Moghny
- *  @date		19 DEC 2013
- *  @version		8.0
- */
-
 s32 host_int_flush_join_req(struct host_if_drv *hWFIDrv);
-
-
-/**
- *  @brief              disconnects from the currently associated network
- *  @details
- *  @param[in,out] handle to the wifi driver,
- *  @param[in]	Reason Code of the Disconnection
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
 s32 host_int_disconnect(struct host_if_drv *hWFIDrv, u16 u16ReasonCode);
-
-/**
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
 s32 host_int_disconnect_station(struct host_if_drv *hWFIDrv, u8 assoc_id);
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
 s32 host_int_get_assoc_req_info(struct host_if_drv *hWFIDrv, u8 *pu8AssocReqInfo,
 					u32 u32AssocReqInfoLen);
-/**
- *  @brief              gets a Association Response info
- *  @details
- *  @param[in,out] handle to the wifi driver,
- *                              Message containg assoc. resp info
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
-
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
 s32 host_int_get_rx_power_level(struct host_if_drv *hWFIDrv, u8 *pu8RxPowerLevel,
 					u32 u32RxPowerLevelLen);
-
-/**
- *  @brief              sets a channel
- *  @details
- *  @param[in,out] handle to the wifi driver,
- *  @param[in]	Index of the channel to be set
- *|-------------------------------------------------------------------|
- |          CHANNEL1      CHANNEL2 ....		             CHANNEL14	|
- |  Input:         1             2					            14	|
- ||-------------------------------------------------------------------|
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
 int host_int_set_mac_chnl_num(struct host_if_drv *wfi_drv, u8 channel);
-
-/**
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
 s32 host_int_get_host_chnl_num(struct host_if_drv *hWFIDrv, u8 *pu8ChNo);
-/**
- *  @brief              gets the sta rssi
- *  @details    gets the currently maintained RSSI value for the station.
- *                              The received signal strength value in dB.
- *                              The range of valid values is -128 to 0.
- *  @param[in,out] handle to the wifi driver,
- *                              rssi value in dB
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
 s32 host_int_get_rssi(struct host_if_drv *hWFIDrv, s8 *ps8Rssi);
 s32 host_int_get_link_speed(struct host_if_drv *hWFIDrv, s8 *ps8lnkspd);
-/**
- *  @brief              scans a set of channels
- *  @details
- *  @param[in,out] handle to the wifi driver,
- *  @param[in]		Scan source
- *                              Scan Type	PASSIVE_SCAN = 0,
- *                                                      ACTIVE_SCAN  = 1
- *                              Channels Array
- *                              Channels Array length
- *                              Scan Callback function
- *                              User Argument to be delivered back through the Scan Cllback function
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
 s32 host_int_scan(struct host_if_drv *hWFIDrv, u8 u8ScanSource,
 			  u8 u8ScanType, u8 *pu8ChnlFreqList,
 			  u8 u8ChnlListLen, const u8 *pu8IEs,
 			  size_t IEsLen, wilc_scan_result ScanResult,
 			  void *pvUserArg,
 			  struct hidden_network *pstrHiddenNetwork);
-/**
- *  @brief              sets configuration wids values
- *  @details
- *  @param[in,out] handle to the wifi driver,
- *  @param[in]	WID, WID value
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
 s32 hif_set_cfg(struct host_if_drv *hWFIDrv, struct cfg_param_val *pstrCfgParamVal);
-
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
 s32 hif_get_cfg(struct host_if_drv *hWFIDrv, u16 u16WID, u16 *pu16WID_Value);
-/*****************************************************************************/
-/*							Notification Functions							 */
-/*****************************************************************************/
-/**
- *  @brief              host interface initialization function
- *  @details
- *  @param[in,out] handle to the wifi driver,
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
 s32 host_int_init(struct net_device *dev, struct host_if_drv **phWFIDrv);
-
-/**
- *  @brief              host interface initialization function
- *  @details
- *  @param[in,out] handle to the wifi driver,
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
 s32 host_int_deinit(struct host_if_drv *hWFIDrv);
-
-
-/*!
- *  @fn		s32 host_int_add_beacon(WILC_WFIDrvHandle hWFIDrv,u8 u8Index)
- *  @brief		Sends a beacon to the firmware to be transmitted over the air
- *  @details
- *  @param[in,out]	hWFIDrv		handle to the wifi driver
- *  @param[in]	u32Interval	Beacon Interval. Period between two successive beacons on air
- *  @param[in]	u32DTIMPeriod DTIM Period. Indicates how many Beacon frames
- *              (including the current frame) appear before the next DTIM
- *  @param[in]	u32Headlen	Length of the head buffer in bytes
- *  @param[in]	pu8Head		Pointer to the beacon's head buffer. Beacon's head
- *		is the part from the beacon's start till the TIM element, NOT including the TIM
- *  @param[in]	u32Taillen	Length of the tail buffer in bytes
- *  @param[in]	pu8Tail		Pointer to the beacon's tail buffer. Beacon's tail
- *		starts just after the TIM inormation element
- *  @return	0 for Success, error otherwise
- *  @todo
- *  @sa
- *  @author		Adham Abozaeid
- *  @date		10 Julys 2012
- *  @version		1.0 Description
- *
- */
 s32 host_int_add_beacon(struct host_if_drv *hWFIDrv, u32 u32Interval,
 				u32 u32DTIMPeriod,
 				u32 u32HeadLen, u8 *pu8Head,
 				u32 u32TailLen, u8 *pu8tail);
-
-
-/*!
- *  @fn		s32 host_int_del_beacon(WILC_WFIDrvHandle hWFIDrv)
- *  @brief		Removes the beacon and stops trawilctting it over the air
- *  @details
- *  @param[in,out]	hWFIDrv		handle to the wifi driver
- *  @return	0 for Success, error otherwise
- *  @todo
- *  @sa
- *  @author		Adham Abozaeid
- *  @date		10 Julys 2012
- *  @version		1.0 Description
- */
 s32 host_int_del_beacon(struct host_if_drv *hWFIDrv);
-
-/*!
- *  @fn		s32 host_int_add_station(WILC_WFIDrvHandle hWFIDrv,
- *					 struct add_sta_param *pstrStaParams)
- *  @brief		Notifies the firmware with a new associated stations
- *  @details
- *  @param[in,out]	hWFIDrv		handle to the wifi driver
- *  @param[in]	pstrStaParams	Station's parameters
- *  @return	0 for Success, error otherwise
- *  @todo
- *  @sa
- *  @author		Adham Abozaeid
- *  @date		12 July 2012
- *  @version		1.0 Description
- */
 s32 host_int_add_station(struct host_if_drv *hWFIDrv,
 			 struct add_sta_param *pstrStaParams);
-
-/*!
- *  @fn		s32 host_int_del_allstation(WILC_WFIDrvHandle hWFIDrv, const u8* pu8MacAddr)
- *  @brief		Deauthenticates clients when group is terminating
- *  @details
- *  @param[in,out]	hWFIDrv		handle to the wifi driver
- *  @param[in]	pu8MacAddr	Station's mac address
- *  @return	0 for Success, error otherwise
- *  @todo
- *  @sa
- *  @author		Mai Daftedar
- *  @date		09 April 2014
- *  @version		1.0 Description
- */
 s32 host_int_del_allstation(struct host_if_drv *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN]);
-
-/*!
- *  @fn		s32 host_int_del_station(WILC_WFIDrvHandle hWFIDrv, u8* pu8MacAddr)
- *  @brief		Notifies the firmware with a new deleted station
- *  @details
- *  @param[in,out]	hWFIDrv		handle to the wifi driver
- *  @param[in]	pu8MacAddr	Station's mac address
- *  @return	0 for Success, error otherwise
- *  @todo
- *  @sa
- *  @author		Adham Abozaeid
- *  @date		15 July 2012
- *  @version		1.0 Description
- */
 s32 host_int_del_station(struct host_if_drv *hWFIDrv, const u8 *pu8MacAddr);
-
-/*!
- *  @fn		s32 host_int_edit_station(WILC_WFIDrvHandle hWFIDrv,
- *					  struct add_sta_param *pstrStaParams)
- *  @brief		Notifies the firmware with new parameters of an already associated station
- *  @details
- *  @param[in,out]	hWFIDrv		handle to the wifi driver
- *  @param[in]	pstrStaParams	Station's parameters
- *  @return	0 for Success, error otherwise
- *  @todo
- *  @sa
- *  @author		Adham Abozaeid
- *  @date		15 July 2012
- *  @version		1.0 Description
- */
 s32 host_int_edit_station(struct host_if_drv *hWFIDrv,
 			  struct add_sta_param *pstrStaParams);
-
-/*!
- *  @fn		s32 host_int_set_power_mgmt(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled, u32 u32Timeout)
- *  @brief		Set the power management mode to enabled or disabled
- *  @details
- *  @param[in,out]	hWFIDrv		handle to the wifi driver
- *  @param[in]	bIsEnabled	TRUE if enabled, FALSE otherwise
- *  @param[in]	u32Timeout	A timeout value of -1 allows the driver to adjust
- *							the dynamic ps timeout value
- *  @return	0 for Success, error otherwise
- *  @todo
- *  @sa
- *  @author		Adham Abozaeid
- *  @date		24 November 2012
- *  @version		1.0 Description
- */
 s32 host_int_set_power_mgmt(struct host_if_drv *hWFIDrv, bool bIsEnabled, u32 u32Timeout);
-/*  @param[in,out]	hWFIDrv		handle to the wifi driver
- *  @param[in]	bIsEnabled	TRUE if enabled, FALSE otherwise
- *  @param[in]	u8count		count of mac address entries in the filter table
- *
- *  @return	0 for Success, error otherwise
- *  @todo
- *  @sa
- *  @author		Adham Abozaeid
- *  @date		24 November 2012
- *  @version		1.0 Description
- */
 s32 host_int_setup_multicast_filter(struct host_if_drv *hWFIDrv, bool bIsEnabled, u32 u32count);
-/**
- *  @brief           host_int_setup_ipaddress
- *  @details       set IP address on firmware
- *  @param[in]
- *  @return         Error code.
- *  @author		Abdelrahman Sobhy
- *  @date
- *  @version	1.0
- */
 s32 host_int_setup_ipaddress(struct host_if_drv *hWFIDrv, u8 *pu8IPAddr, u8 idx);
-
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
 s32 host_int_delBASession(struct host_if_drv *hWFIDrv, char *pBSSID, char TID);
-
-/**
- *  @brief           host_int_delBASession
- *  @details       Delete all Rx BA session
- *  @param[in]
- *  @return         Error code.
- *  @author		Abdelrahman Sobhy
- *  @date
- *  @version	1.0
- */
 s32 host_int_del_All_Rx_BASession(struct host_if_drv *hWFIDrv, char *pBSSID, char TID);
-
-
-/**
- *  @brief           host_int_get_ipaddress
- *  @details       get IP address on firmware
- *  @param[in]
- *  @return         Error code.
- *  @author		Abdelrahman Sobhy
- *  @date
- *  @version	1.0
- */
 s32 host_int_get_ipaddress(struct host_if_drv *hWFIDrv, u8 *pu8IPAddr, u8 idx);
-
-/**
- *  @brief           host_int_remain_on_channel
- *  @details
- *  @param[in]
- *  @return         Error code.
- *  @author
- *  @date
- *  @version	1.0
- */
 s32 host_int_remain_on_channel(struct host_if_drv *hWFIDrv, u32 u32SessionID, u32 u32duration, u16 chan, wilc_remain_on_chan_expired RemainOnChanExpired, wilc_remain_on_chan_ready RemainOnChanReady, void *pvUserArg);
-
-/**
- *  @brief              host_int_ListenStateExpired
- *  @details
- *  @param[in]          Handle to wifi driver
- *                              Duration to remain on channel
- *                              Channel to remain on
- *                              Pointer to fn to be called on receive frames in listen state
- *                              Pointer to remain-on-channel expired fn
- *                              Priv
- *  @return             Error code.
- *  @author
- *  @date
- *  @version		1.0
- */
 s32 host_int_ListenStateExpired(struct host_if_drv *hWFIDrv, u32 u32SessionID);
-
-/**
- *  @brief           host_int_frame_register
- *  @details
- *  @param[in]
- *  @return         Error code.
- *  @author
- *  @date
- *  @version	1.0
- */
 s32 host_int_frame_register(struct host_if_drv *hWFIDrv, u16 u16FrameType, bool bReg);
-/**
- *  @brief           host_int_set_wfi_drv_handler
- *  @details
- *  @param[in]
- *  @return         Error code.
- *  @author
- *  @date
- *  @version	1.0
- */
 int host_int_set_wfi_drv_handler(struct host_if_drv *address);
 int host_int_set_operation_mode(struct host_if_drv *wfi_drv, u32 mode);
 
-- 
1.9.1

