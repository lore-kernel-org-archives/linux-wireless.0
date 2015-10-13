Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:2357 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbbJMKui (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:50:38 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 01/54] staging: wilc1000: host_interface.c : remove over-commenting
Date: Tue, 13 Oct 2015 19:49:26 +0900
Message-ID: <1444733419-17679-1-git-send-email-tony.cho@atmel.com> (sfid-20151013_125101_232397_54AE86A0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

There are over-commenting in the host_interface.c file and most of them
are not helpful to explain what the code does and generate 80 ending
line over warnings. So, all of comments are removed in this patch and the
comments will later be added if necessary with the preferred Linux style.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 1775 ++---------------------------
 1 file changed, 70 insertions(+), 1705 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index ec04aec..15b2770 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -14,7 +14,6 @@ extern struct timer_list hDuringIpTimer;
 
 extern u8 g_wilc_initialized;
 
-/* Message types of the Host IF Message Queue*/
 #define HOST_IF_MSG_SCAN                        0
 #define HOST_IF_MSG_CONNECT                     1
 #define HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO        2
@@ -62,30 +61,10 @@ extern u8 g_wilc_initialized;
 #define BA_SESSION_DEFAULT_TIMEOUT              1000
 #define BLOCK_ACK_REQ_SIZE                      0x14
 
-/*!
- *  @struct             cfg_param_attr
- *  @brief		Structure to hold Host IF CFG Params Attributes
- *  @details
- *  @todo
- *  @sa
- *  @author		Mai Daftedar
- *  @date		02 April 2012
- *  @version		1.0
- */
 struct cfg_param_attr {
 	struct cfg_param_val cfg_attr_info;
 };
 
-/*!
- *  @struct             host_if_wpa_attr
- *  @brief		Structure to hold Host IF Scan Attributes
- *  @details
- *  @todo
- *  @sa
- *  @author		Mai Daftedar
- *  @date		25 March 2012
- *  @version		1.0
- */
 struct host_if_wpa_attr {
 	u8 *pu8key;
 	const u8 *pu8macaddr;
@@ -96,17 +75,6 @@ struct host_if_wpa_attr {
 	u8 u8Ciphermode;
 };
 
-
-/*!
- *  @struct             host_if_wep_attr
- *  @brief		Structure to hold Host IF Scan Attributes
- *  @details
- *  @todo
- *  @sa
- *  @author		Mai Daftedar
- *  @date		25 March 2012
- *  @version		1.0
- */
 struct host_if_wep_attr {
 	u8 *key;
 	u8 key_len;
@@ -115,51 +83,18 @@ struct host_if_wep_attr {
 	enum AUTHTYPE auth_type;
 };
 
-/*!
- *  @struct             host_if_key_attr
- *  @brief		Structure to hold Host IF Scan Attributes
- *  @details
- *  @todo
- *  @sa
- *  @author		Mai Daftedar
- *  @date		25 March 2012
- *  @version		1.0
- */
 union host_if_key_attr {
 	struct host_if_wep_attr wep;
 	struct host_if_wpa_attr wpa;
 	struct host_if_pmkid_attr pmkid;
 };
 
-/*!
- *  @struct             key_attr
- *  @brief		Structure to hold Host IF Scan Attributes
- *  @details
- *  @todo
- *  @sa
- *  @author		Mai Daftedar
- *  @date		25 March 2012
- *  @version		1.0
- */
 struct key_attr {
 	enum KEY_TYPE enuKeyType;
 	u8 u8KeyAction;
 	union host_if_key_attr uniHostIFkeyAttr;
 };
 
-
-
-
-/*!
- *  @struct             scan_attr
- *  @brief		Structure to hold Host IF Scan Attributes
- *  @details
- *  @todo
- *  @sa
- *  @author		Mostafa Abu Bakr
- *  @date		25 March 2012
- *  @version		1.0
- */
 struct scan_attr {
 	u8 u8ScanSource;
 	u8 u8ScanType;
@@ -172,16 +107,6 @@ struct scan_attr {
 	struct hidden_network strHiddenNetwork;
 };
 
-/*!
- *  @struct             connect_attr
- *  @brief		Structure to hold Host IF Connect Attributes
- *  @details
- *  @todo
- *  @sa
- *  @author		Mostafa Abu Bakr
- *  @date		25 March 2012
- *  @version		1.0
- */
 struct connect_attr {
 	u8 *pu8bssid;
 	u8 *pu8ssid;
@@ -196,173 +121,53 @@ struct connect_attr {
 	void *pJoinParams;
 };
 
-/*!
- *  @struct             rcvd_async_info
- *  @brief		Structure to hold Received General Asynchronous info
- *  @details
- *  @todo
- *  @sa
- *  @author		Mostafa Abu Bakr
- *  @date		25 March 2012
- *  @version		1.0
- */
 struct rcvd_async_info {
 	u8 *pu8Buffer;
 	u32 u32Length;
 };
 
-/*!
- *  @struct		channel_attr
- *  @brief		Set Channel  message body
- *  @details
- *  @todo
- *  @sa
- *  @author		Mai Daftedar
- *  @date		25 March 2012
- *  @version		1.0
- */
 struct channel_attr {
 	u8 u8SetChan;
 };
 
-/*!
- *  @struct             tstrScanComplete
- *  @brief			hold received Async. Scan Complete message body
- *  @details
- *  @todo
- *  @sa
- *  @author		zsalah
- *  @date		25 March 2012
- *  @version		1.0
- */
-/*typedef struct _tstrScanComplete
- * {
- *      u8* pu8Buffer;
- *      u32 u32Length;
- * } tstrScanComplete;*/
-
-/*!
- *  @struct             beacon_attr
- *  @brief		Set Beacon  message body
- *  @details
- *  @todo
- *  @sa
- *  @author		Adham Abozaeid
- *  @date		10 July 2012
- *  @version		1.0
- */
 struct beacon_attr {
-	u32 u32Interval;                        /*!< Beacon Interval. Period between two successive beacons on air  */
-	u32 u32DTIMPeriod;              /*!< DTIM Period. Indicates how many Beacon frames
-											*                              (including the current frame) appear before the next DTIM		*/
-	u32 u32HeadLen;                         /*!< Length of the head buffer in bytes		*/
-	u8 *pu8Head;                    /*!< Pointer to the beacon's head buffer. Beacon's head	is the part
-											*              from the beacon's start till the TIM element, NOT including the TIM		*/
-	u32 u32TailLen;                         /*!< Length of the tail buffer in bytes	*/
-	u8 *pu8Tail;                    /*!< Pointer to the beacon's tail buffer. Beacon's tail	starts just
-											*                              after the TIM inormation element	*/
+	u32 u32Interval;
+	u32 u32DTIMPeriod;
+	u32 u32HeadLen;
+	u8 *pu8Head;
+	u32 u32TailLen;
+	u8 *pu8Tail;
 };
 
-/*!
- *  @struct             set_multicast
- *  @brief		set Multicast filter Address
- *  @details
- *  @todo
- *  @sa
- *  @author		Abdelrahman Sobhy
- *  @date		30 August 2013
- *  @version		1.0 Description
- */
-
 struct set_multicast {
 	bool bIsEnabled;
 	u32 u32count;
 };
 
-/*!
- *  @struct             del_all_sta
- *  @brief		Deauth station message body
- *  @details
- *  @todo
- *  @sa
- *  @author		Mai Daftedar
- *  @date		09 April 2014
- *  @version		1.0 Description
- */
 struct del_all_sta {
 	u8 au8Sta_DelAllSta[MAX_NUM_STA][ETH_ALEN];
 	u8 u8Num_AssocSta;
 };
 
-/*!
- *  @struct             del_sta
- *  @brief		Delete station message body
- *  @details
- *  @todo
- *  @sa
- *  @author		Adham Abozaeid
- *  @date		15 July 2012
- *  @version		1.0 Description
- */
 struct del_sta {
 	u8 au8MacAddr[ETH_ALEN];
 };
 
-/*!
- *  @struct     power_mgmt_param
- *  @brief		Power management message body
- *  @details
- *  @todo
- *  @sa
- *  @author		Adham Abozaeid
- *  @date		24 November 2012
- *  @version		1.0
- */
 struct power_mgmt_param {
 
 	bool bIsEnabled;
 	u32 u32Timeout;
 };
 
-/*!
- *  @struct             set_ip_addr
- *  @brief		set IP Address message body
- *  @details
- *  @todo
- *  @sa
- *  @author		Abdelrahman Sobhy
- *  @date		30 August 2013
- *  @version		1.0 Description
- */
 struct set_ip_addr {
 	u8 *au8IPAddr;
 	u8 idx;
 };
 
-/*!
- *  @struct     sta_inactive_t
- *  @brief		Get station message body
- *  @details
- *  @todo
- *  @sa
- *  @author	    Mai Daftedar
- *  @date		16 April 2013
- *  @version		1.0
- */
 struct sta_inactive_t {
 	u8 mac[6];
 };
-/**/
-/*!
- *  @union              message_body
- *  @brief		Message body for the Host Interface message_q
- *  @details
- *  @todo
- *  @sa
- *  @author		Mostafa Abu Bakr
- *  @date		25 March 2012
- *  @version		1.0
- */
+
 union message_body {
 	struct scan_attr scan_info;
 	struct connect_attr con_info;
@@ -390,23 +195,12 @@ union message_body {
 	struct del_all_sta del_all_sta_info;
 };
 
-/*!
- *  @struct             struct host_if_msg
- *  @brief		Host Interface message
- *  @details
- *  @todo
- *  @sa
- *  @author		Mostafa Abu Bakr
- *  @date		25 March 2012
- *  @version		1.0
- */
 struct host_if_msg {
-	u16 id;                                           /*!< Message ID */
-	union message_body body;             /*!< Message body */
+	u16 id;
+	union message_body body;
 	struct host_if_drv *drv;
 };
 
-/*Struct containg joinParam of each AP*/
 struct join_bss_param {
 	BSSTYPE_T bss_type;
 	u8 dtim_period;
@@ -442,12 +236,6 @@ enum scan_conn_timer {
 	SCAN_CONNECT_TIMER_FORCE_32BIT = 0xFFFFFFFF
 };
 
-/*****************************************************************************/
-/*																			 */
-/*							Global Variabls	                                                                 */
-/*																			 */
-/*****************************************************************************/
-/* Zero is not used, because a zero ID means termination */
 static struct host_if_drv *wfidrv_list[NUM_CONCURRENT_IFC + 1];
 struct host_if_drv *terminated_handle;
 struct host_if_drv *gWFiDrvHandle;
@@ -488,7 +276,7 @@ u32 gu32FlushedInfoElemAsocSize;
 struct host_if_drv *gu8FlushedJoinReqDrvHandler;
 #define REAL_JOIN_REQ 0
 #define FLUSHED_JOIN_REQ 1
-#define FLUSHED_BYTE_POS 79     /* Position the byte indicating flushing in the flushed request */
+#define FLUSHED_BYTE_POS 79
 
 static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo);
 
@@ -545,15 +333,6 @@ static struct host_if_drv *get_handler_from_id(int id)
 	return wfidrv_list[id];
 }
 
-/**
- *  @brief Handle_SetChannel
- *  @details    Sending config packet to firmware to set channel
- *  @param[in]   struct channel_attr *pstrHostIFSetChan
- *  @return     Error code.
- *  @author
- *  @date
- *  @version	1.0
- */
 static s32 Handle_SetChannel(struct host_if_drv *hif_drv,
 			     struct channel_attr *pstrHostIFSetChan)
 {
@@ -561,14 +340,13 @@ static s32 Handle_SetChannel(struct host_if_drv *hif_drv,
 	s32 s32Error = 0;
 	struct wid strWID;
 
-	/*prepare configuration packet*/
 	strWID.id = (u16)WID_CURRENT_CHANNEL;
 	strWID.type = WID_CHAR;
 	strWID.val = (char *)&(pstrHostIFSetChan->u8SetChan);
 	strWID.size = sizeof(char);
 
 	PRINT_D(HOSTINF_DBG, "Setting channel\n");
-	/*Sending Cfg*/
+
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
 	if (s32Error) {
@@ -578,16 +356,7 @@ static s32 Handle_SetChannel(struct host_if_drv *hif_drv,
 
 	return s32Error;
 }
-/**
- *  @brief Handle_SetWfiDrvHandler
- *  @details    Sending config packet to firmware to set driver handler
- *  @param[in]   void * drvHandler,
- *		 struct drv_handler *pstrHostIfSetDrvHandler
- *  @return     Error code.
- *  @author
- *  @date
- *  @version	1.0
- */
+
 static s32 Handle_SetWfiDrvHandler(struct host_if_drv *hif_drv,
 				   struct drv_handler *pstrHostIfSetDrvHandler)
 {
@@ -595,14 +364,11 @@ static s32 Handle_SetWfiDrvHandler(struct host_if_drv *hif_drv,
 	s32 s32Error = 0;
 	struct wid strWID;
 
-	/*prepare configuration packet*/
 	strWID.id = (u16)WID_SET_DRV_HANDLER;
 	strWID.type = WID_INT;
 	strWID.val = (s8 *)&(pstrHostIfSetDrvHandler->u32Address);
 	strWID.size = sizeof(u32);
 
-	/*Sending Cfg*/
-
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   pstrHostIfSetDrvHandler->u32Address);
 
@@ -618,15 +384,6 @@ static s32 Handle_SetWfiDrvHandler(struct host_if_drv *hif_drv,
 	return s32Error;
 }
 
-/**
- *  @brief Handle_SetWfiAPDrvHandler
- *  @details    Sending config packet to firmware to set driver handler
- *  @param[in]   void * drvHandler,tstrHostIfSetDrvHandler* pstrHostIfSetDrvHandler
- *  @return     Error code.
- *  @author
- *  @date
- *  @version	1.0
- */
 static s32 Handle_SetOperationMode(struct host_if_drv *hif_drv,
 				   struct op_mode *pstrHostIfSetOperationMode)
 {
@@ -634,7 +391,6 @@ static s32 Handle_SetOperationMode(struct host_if_drv *hif_drv,
 	s32 s32Error = 0;
 	struct wid strWID;
 
-	/*prepare configuration packet*/
 	strWID.id = (u16)WID_SET_OPERATION_MODE;
 	strWID.type = WID_INT;
 	strWID.val = (s8 *)&(pstrHostIfSetOperationMode->u32Mode);
@@ -656,15 +412,6 @@ static s32 Handle_SetOperationMode(struct host_if_drv *hif_drv,
 	return s32Error;
 }
 
-/**
- *  @brief host_int_set_IPAddress
- *  @details       Setting IP address params in message queue
- *  @param[in]    WILC_WFIDrvHandle hWFIDrv, u8* pu8IPAddr
- *  @return         Error code.
- *  @author
- *  @date
- *  @version	1.0
- */
 s32 Handle_set_IPAddress(struct host_if_drv *hif_drv, u8 *pu8IPAddr, u8 idx)
 {
 
@@ -679,7 +426,6 @@ s32 Handle_set_IPAddress(struct host_if_drv *hif_drv, u8 *pu8IPAddr, u8 idx)
 
 	memcpy(gs8SetIP[idx], pu8IPAddr, IP_ALEN);
 
-	/*prepare configuration packet*/
 	strWID.id = (u16)WID_IP_ADDRESS;
 	strWID.type = WID_STR;
 	strWID.val = (u8 *)pu8IPAddr;
@@ -701,23 +447,12 @@ s32 Handle_set_IPAddress(struct host_if_drv *hif_drv, u8 *pu8IPAddr, u8 idx)
 	return s32Error;
 }
 
-
-/**
- *  @brief Handle_get_IPAddress
- *  @details       Setting IP address params in message queue
- *  @param[in]    WILC_WFIDrvHandle hWFIDrv, u8* pu8IPAddr
- *  @return         Error code.
- *  @author
- *  @date
- *  @version	1.0
- */
 s32 Handle_get_IPAddress(struct host_if_drv *hif_drv, u8 *pu8IPAddr, u8 idx)
 {
 
 	s32 s32Error = 0;
 	struct wid strWID;
 
-	/*prepare configuration packet*/
 	strWID.id = (u16)WID_IP_ADDRESS;
 	strWID.type = WID_STR;
 	strWID.val = kmalloc(IP_ALEN, GFP_KERNEL);
@@ -730,7 +465,6 @@ s32 Handle_get_IPAddress(struct host_if_drv *hif_drv, u8 *pu8IPAddr, u8 idx)
 
 	memcpy(gs8GetIP[idx], strWID.val, IP_ALEN);
 
-	/*get the value by searching the local copy*/
 	kfree(strWID.val);
 
 	if (memcmp(gs8GetIP[idx], gs8SetIP[idx], IP_ALEN) != 0)
@@ -748,16 +482,6 @@ s32 Handle_get_IPAddress(struct host_if_drv *hif_drv, u8 *pu8IPAddr, u8 idx)
 	return s32Error;
 }
 
-
-/**
- *  @brief Handle_SetMacAddress
- *  @details    Setting mac address
- *  @param[in]   void * drvHandler,tstrHostIfSetDrvHandler* pstrHostIfSetDrvHandler
- *  @return     Error code.
- *  @author	Amr Abdel-Moghny
- *  @date		November 2013
- *  @version	7.0
- */
 static s32 Handle_SetMacAddress(struct host_if_drv *hif_drv,
 				struct set_mac_addr *pstrHostIfSetMacAddress)
 {
@@ -772,13 +496,12 @@ static s32 Handle_SetMacAddress(struct host_if_drv *hif_drv,
 	}
 	memcpy(mac_buf, pstrHostIfSetMacAddress->u8MacAddress, ETH_ALEN);
 
-	/*prepare configuration packet*/
 	strWID.id = (u16)WID_MAC_ADDR;
 	strWID.type = WID_STR;
 	strWID.val = mac_buf;
 	strWID.size = ETH_ALEN;
 	PRINT_D(GENERIC_DBG, "mac addr = :%pM\n", strWID.val);
-	/*Sending Cfg*/
+
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
 	if (s32Error) {
@@ -790,16 +513,6 @@ static s32 Handle_SetMacAddress(struct host_if_drv *hif_drv,
 	return s32Error;
 }
 
-
-/**
- *  @brief Handle_GetMacAddress
- *  @details    Getting mac address
- *  @param[in]   void * drvHandler,tstrHostIfSetDrvHandler* pstrHostIfSetDrvHandler
- *  @return     Error code.
- *  @author	Amr Abdel-Moghny
- *  @date		JAN 2013
- *  @version	8.0
- */
 static s32 Handle_GetMacAddress(struct host_if_drv *hif_drv,
 				struct get_mac_addr *pstrHostIfGetMacAddress)
 {
@@ -807,13 +520,11 @@ static s32 Handle_GetMacAddress(struct host_if_drv *hif_drv,
 	s32 s32Error = 0;
 	struct wid strWID;
 
-	/*prepare configuration packet*/
 	strWID.id = (u16)WID_MAC_ADDR;
 	strWID.type = WID_STR;
 	strWID.val = pstrHostIfGetMacAddress->u8MacAddress;
 	strWID.size = ETH_ALEN;
 
-	/*Sending Cfg*/
 	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
 	if (s32Error) {
@@ -825,16 +536,6 @@ static s32 Handle_GetMacAddress(struct host_if_drv *hif_drv,
 	return s32Error;
 }
 
-
-/**
- *  @brief Handle_CfgParam
- *  @details    Sending config packet to firmware to set CFG params
- *  @param[in]   struct cfg_param_attr *strHostIFCfgParamAttr
- *  @return     Error code.
- *  @author
- *  @date
- *  @version	1.0
- */
 static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			   struct cfg_param_attr *strHostIFCfgParamAttr)
 {
@@ -848,12 +549,6 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 	PRINT_D(HOSTINF_DBG, "Setting CFG params\n");
 
 	if (strHostIFCfgParamAttr->cfg_attr_info.flag & BSS_TYPE) {
-		/*----------------------------------------------------------*/
-		/*Input Value:	INFRASTRUCTURE = 1,							*/
-		/*				INDEPENDENT= 2,								*/
-		/*				ANY_BSS= 3									*/
-		/*----------------------------------------------------------*/
-		/* validate input then copy>> need to check value 4 and 5 */
 		if (strHostIFCfgParamAttr->cfg_attr_info.bss_type < 6) {
 			strWIDList[u8WidCnt].id = WID_BSS_TYPE;
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.bss_type;
@@ -868,12 +563,6 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		u8WidCnt++;
 	}
 	if (strHostIFCfgParamAttr->cfg_attr_info.flag & AUTH_TYPE) {
-		/*------------------------------------------------------*/
-		/*Input Values: OPEN_SYSTEM     = 0,					*/
-		/*				SHARED_KEY      = 1,					*/
-		/*				ANY             = 2						*/
-		/*------------------------------------------------------*/
-		/*validate Possible values*/
 		if ((strHostIFCfgParamAttr->cfg_attr_info.auth_type) == 1 || (strHostIFCfgParamAttr->cfg_attr_info.auth_type) == 2 || (strHostIFCfgParamAttr->cfg_attr_info.auth_type) == 5) {
 			strWIDList[u8WidCnt].id = WID_AUTH_TYPE;
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.auth_type;
@@ -888,7 +577,6 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		u8WidCnt++;
 	}
 	if (strHostIFCfgParamAttr->cfg_attr_info.flag & AUTHEN_TIMEOUT) {
-		/* range is 1 to 65535. */
 		if (strHostIFCfgParamAttr->cfg_attr_info.auth_timeout > 0 && strHostIFCfgParamAttr->cfg_attr_info.auth_timeout < 65536) {
 			strWIDList[u8WidCnt].id = WID_AUTH_TIMEOUT;
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.auth_timeout;
@@ -903,13 +591,6 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		u8WidCnt++;
 	}
 	if (strHostIFCfgParamAttr->cfg_attr_info.flag & POWER_MANAGEMENT) {
-		/*-----------------------------------------------------------*/
-		/*Input Values:	NO_POWERSAVE     = 0,						*/
-		/*				MIN_FAST_PS      = 1,						*/
-		/*				MAX_FAST_PS      = 2,						*/
-		/*				MIN_PSPOLL_PS    = 3,						*/
-		/*				MAX_PSPOLL_PS    = 4						*/
-		/*----------------------------------------------------------*/
 		if (strHostIFCfgParamAttr->cfg_attr_info.power_mgmt_mode < 5) {
 			strWIDList[u8WidCnt].id = WID_POWER_MANAGEMENT;
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.power_mgmt_mode;
@@ -924,7 +605,6 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		u8WidCnt++;
 	}
 	if (strHostIFCfgParamAttr->cfg_attr_info.flag & RETRY_SHORT) {
-		/* range from 1 to 256 */
 		if ((strHostIFCfgParamAttr->cfg_attr_info.short_retry_limit > 0) && (strHostIFCfgParamAttr->cfg_attr_info.short_retry_limit < 256))	{
 			strWIDList[u8WidCnt].id = WID_SHORT_RETRY_LIMIT;
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.short_retry_limit;
@@ -939,7 +619,6 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		u8WidCnt++;
 	}
 	if (strHostIFCfgParamAttr->cfg_attr_info.flag & RETRY_LONG) {
-		/* range from 1 to 256 */
 		if ((strHostIFCfgParamAttr->cfg_attr_info.long_retry_limit > 0) && (strHostIFCfgParamAttr->cfg_attr_info.long_retry_limit < 256)) {
 			strWIDList[u8WidCnt].id = WID_LONG_RETRY_LIMIT;
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.long_retry_limit;
@@ -970,7 +649,6 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		u8WidCnt++;
 	}
 	if (strHostIFCfgParamAttr->cfg_attr_info.flag & RTS_THRESHOLD) {
-		/* range 256 to 65535 */
 		if (strHostIFCfgParamAttr->cfg_attr_info.rts_threshold > 255 && strHostIFCfgParamAttr->cfg_attr_info.rts_threshold < 65536)	{
 			strWIDList[u8WidCnt].id = WID_RTS_THRESHOLD;
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.rts_threshold;
@@ -985,11 +663,6 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		u8WidCnt++;
 	}
 	if (strHostIFCfgParamAttr->cfg_attr_info.flag & PREAMBLE) {
-		/*-----------------------------------------------------*/
-		/*Input Values: Short= 0,								*/
-		/*				Long= 1,                                */
-		/*				Auto= 2									*/
-		/*------------------------------------------------------*/
 		if (strHostIFCfgParamAttr->cfg_attr_info.preamble_type < 3) {
 			strWIDList[u8WidCnt].id = WID_PREAMBLE;
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.preamble_type;
@@ -1018,10 +691,6 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		u8WidCnt++;
 	}
 	if (strHostIFCfgParamAttr->cfg_attr_info.flag & TXOP_PROT_DISABLE) {
-		/*Description:	used to Disable RTS-CTS protection for TXOP burst*/
-		/*transmission when the acknowledgement policy is No-Ack or Block-Ack	*/
-		/* this information is useful for external supplicant                                   */
-		/*Input Values: 1 for enable and 0 for disable.							*/
 		if (strHostIFCfgParamAttr->cfg_attr_info.txop_prot_disabled < 2) {
 			strWIDList[u8WidCnt].id = WID_11N_TXOP_PROT_DISABLE;
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.txop_prot_disabled;
@@ -1036,7 +705,6 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		u8WidCnt++;
 	}
 	if (strHostIFCfgParamAttr->cfg_attr_info.flag & BEACON_INTERVAL) {
-		/* range is 1 to 65535. */
 		if (strHostIFCfgParamAttr->cfg_attr_info.beacon_interval > 0 && strHostIFCfgParamAttr->cfg_attr_info.beacon_interval < 65536) {
 			strWIDList[u8WidCnt].id = WID_BEACON_INTERVAL;
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.beacon_interval;
@@ -1051,7 +719,6 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		u8WidCnt++;
 	}
 	if (strHostIFCfgParamAttr->cfg_attr_info.flag & DTIM_PERIOD) {
-		/* range is 1 to 255. */
 		if (strHostIFCfgParamAttr->cfg_attr_info.dtim_period > 0 && strHostIFCfgParamAttr->cfg_attr_info.dtim_period < 256) {
 			strWIDList[u8WidCnt].id = WID_DTIM_PERIOD;
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.dtim_period;
@@ -1066,11 +733,6 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		u8WidCnt++;
 	}
 	if (strHostIFCfgParamAttr->cfg_attr_info.flag & SITE_SURVEY) {
-		/*----------------------------------------------------------------------*/
-		/*Input Values: SITE_SURVEY_1CH    = 0, i.e.: currently set channel		*/
-		/*				SITE_SURVEY_ALL_CH = 1,									*/
-		/*				SITE_SURVEY_OFF    = 2									*/
-		/*----------------------------------------------------------------------*/
 		if (strHostIFCfgParamAttr->cfg_attr_info.site_survey_enabled < 3) {
 			strWIDList[u8WidCnt].id = WID_SITE_SURVEY;
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.site_survey_enabled;
@@ -1085,7 +747,6 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		u8WidCnt++;
 	}
 	if (strHostIFCfgParamAttr->cfg_attr_info.flag & SITE_SURVEY_SCAN_TIME) {
-		/* range is 1 to 65535. */
 		if (strHostIFCfgParamAttr->cfg_attr_info.site_survey_scan_time > 0 && strHostIFCfgParamAttr->cfg_attr_info.site_survey_scan_time < 65536) {
 			strWIDList[u8WidCnt].id = WID_SITE_SURVEY_SCAN_TIME;
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.site_survey_scan_time;
@@ -1100,7 +761,6 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		u8WidCnt++;
 	}
 	if (strHostIFCfgParamAttr->cfg_attr_info.flag & ACTIVE_SCANTIME) {
-		/* range is 1 to 65535. */
 		if (strHostIFCfgParamAttr->cfg_attr_info.active_scan_time > 0 && strHostIFCfgParamAttr->cfg_attr_info.active_scan_time < 65536) {
 			strWIDList[u8WidCnt].id = WID_ACTIVE_SCAN_TIME;
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.active_scan_time;
@@ -1115,7 +775,6 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		u8WidCnt++;
 	}
 	if (strHostIFCfgParamAttr->cfg_attr_info.flag & PASSIVE_SCANTIME) {
-		/* range is 1 to 65535. */
 		if (strHostIFCfgParamAttr->cfg_attr_info.passive_scan_time > 0 && strHostIFCfgParamAttr->cfg_attr_info.passive_scan_time < 65536) {
 			strWIDList[u8WidCnt].id = WID_PASSIVE_SCAN_TIME;
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.passive_scan_time;
@@ -1131,11 +790,6 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 	}
 	if (strHostIFCfgParamAttr->cfg_attr_info.flag & CURRENT_TX_RATE) {
 		enum CURRENT_TXRATE curr_tx_rate = strHostIFCfgParamAttr->cfg_attr_info.curr_tx_rate;
-		/*----------------------------------------------------------------------*/
-		/*Rates:		1   2   5.5   11   6  9  12  18  24  36  48   54  Auto	*/
-		/*InputValues:	1   2     3    4   5  6   7   8   9  10  11   12  0		*/
-		/*----------------------------------------------------------------------*/
-		/* validate rate */
 		if (curr_tx_rate == AUTORATE || curr_tx_rate == MBPS_1
 		    || curr_tx_rate == MBPS_2 || curr_tx_rate == MBPS_5_5
 		    || curr_tx_rate == MBPS_11 || curr_tx_rate == MBPS_6
@@ -1165,16 +819,6 @@ ERRORHANDLER:
 	return s32Error;
 }
 
-
-/**
- *  @brief Handle_wait_msg_q_empty
- *  @details       this should be the last msg and then the msg Q becomes idle
- *  @param[in]    tstrHostIFscanAttr* pstrHostIFscanAttr
- *  @return         Error code.
- *  @author
- *  @date
- *  @version	1.0
- */
 static s32 Handle_wait_msg_q_empty(void)
 {
 	g_wilc_initialized = 0;
@@ -1182,15 +826,6 @@ static s32 Handle_wait_msg_q_empty(void)
 	return 0;
 }
 
-/**
- *  @brief Handle_Scan
- *  @details       Sending config packet to firmware to set the scan params
- *  @param[in]    struct scan_attr *pstrHostIFscanAttr
- *  @return         Error code.
- *  @author
- *  @date
- *  @version	1.0
- */
 static s32 Handle_Scan(struct host_if_drv *hif_drv,
 		       struct scan_attr *pstrHostIFscanAttr)
 {
@@ -1209,7 +844,6 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 	hif_drv->strWILC_UsrScanReq.u32UserScanPvoid = pstrHostIFscanAttr->pvUserArg;
 
 	if ((hif_drv->enuHostIFstate >= HOST_IF_SCANNING) && (hif_drv->enuHostIFstate < HOST_IF_CONNECTED)) {
-		/* here we either in HOST_IF_SCANNING, HOST_IF_WAITING_CONN_REQ or HOST_IF_WAITING_CONN_RESP */
 		PRINT_D(GENERIC_DBG, "Don't scan we are already in [%d] state\n", hif_drv->enuHostIFstate);
 		PRINT_ER("Already scan\n");
 		s32Error = -EBUSY;
@@ -1254,11 +888,7 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 		u32WidsCount++;
 	}
 
-	/*filling cfg param array*/
-
-	/* if((pstrHostIFscanAttr->pu8IEs != NULL) && (pstrHostIFscanAttr->IEsLen != 0)) */
 	{
-		/* IEs to be inserted in Probe Request */
 		strWIDList[u32WidsCount].id = WID_INFO_ELEMENT_PROBE;
 		strWIDList[u32WidsCount].type = WID_BIN_DATA;
 		strWIDList[u32WidsCount].val = pstrHostIFscanAttr->pu8IEs;
@@ -1266,14 +896,12 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 		u32WidsCount++;
 	}
 
-	/*Scan Type*/
 	strWIDList[u32WidsCount].id = WID_SCAN_TYPE;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].size = sizeof(char);
 	strWIDList[u32WidsCount].val = (s8 *)(&(pstrHostIFscanAttr->u8ScanType));
 	u32WidsCount++;
 
-	/*list of channels to be scanned*/
 	strWIDList[u32WidsCount].id = WID_SCAN_CHANNEL_LIST;
 	strWIDList[u32WidsCount].type = WID_BIN_DATA;
 
@@ -1290,16 +918,12 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 	strWIDList[u32WidsCount].size = pstrHostIFscanAttr->u8ChnlListLen;
 	u32WidsCount++;
 
-	/*Scan Request*/
 	strWIDList[u32WidsCount].id = WID_START_SCAN_REQ;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].size = sizeof(char);
 	strWIDList[u32WidsCount].val = (s8 *)(&(pstrHostIFscanAttr->u8ScanSource));
 	u32WidsCount++;
 
-	/*keep the state as is , no need to change it*/
-	/* gWFiDrvHandle->enuHostIFstate = HOST_IF_SCANNING; */
-
 	if (hif_drv->enuHostIFstate == HOST_IF_CONNECTED)
 		gbScanWhileConnected = true;
 	else if (hif_drv->enuHostIFstate == HOST_IF_IDLE)
@@ -1316,17 +940,14 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 ERRORHANDLER:
 	if (s32Error) {
 		del_timer(&hif_drv->hScanTimer);
-		/*if there is an ongoing scan request*/
 		Handle_ScanDone(hif_drv, SCAN_EVENT_ABORTED);
 	}
 
-	/* Deallocate pstrHostIFscanAttr->u8ChnlListLen which was prevoisuly allocated by the sending thread */
 	if (pstrHostIFscanAttr->pu8ChnlFreqList != NULL) {
 		kfree(pstrHostIFscanAttr->pu8ChnlFreqList);
 		pstrHostIFscanAttr->pu8ChnlFreqList = NULL;
 	}
 
-	/* Deallocate pstrHostIFscanAttr->pu8IEs which was previously allocated by the sending thread */
 	if (pstrHostIFscanAttr->pu8IEs != NULL)	{
 		kfree(pstrHostIFscanAttr->pu8IEs);
 		pstrHostIFscanAttr->pu8IEs = NULL;
@@ -1336,7 +957,6 @@ ERRORHANDLER:
 		pstrHostIFscanAttr->strHiddenNetwork.pstrHiddenNetworkInfo = NULL;
 	}
 
-	/* Deallocate pstrHostIFscanAttr->u8ChnlListLen which was prevoisuly allocated by the sending thread */
 	if (pstrHostIFscanAttr->pu8ChnlFreqList != NULL) {
 		kfree(pstrHostIFscanAttr->pu8ChnlFreqList);
 		pstrHostIFscanAttr->pu8ChnlFreqList = NULL;
@@ -1348,15 +968,6 @@ ERRORHANDLER:
 	return s32Error;
 }
 
-/**
- *  @brief Handle_ScanDone
- *  @details       Call scan notification callback function
- *  @param[in]    NONE
- *  @return         Error code.
- *  @author
- *  @date
- *  @version	1.0
- */
 static s32 Handle_ScanDone(struct host_if_drv *hif_drv,
 			   enum scan_event enuEvent)
 {
@@ -1367,7 +978,6 @@ static s32 Handle_ScanDone(struct host_if_drv *hif_drv,
 
 	PRINT_D(HOSTINF_DBG, "in Handle_ScanDone()\n");
 
-	/*Ask FW to abort the running scan, if any*/
 	if (enuEvent == SCAN_EVENT_ABORTED) {
 		PRINT_D(GENERIC_DBG, "Abort running scan\n");
 		u8abort_running_scan = 1;
@@ -1376,7 +986,6 @@ static s32 Handle_ScanDone(struct host_if_drv *hif_drv,
 		strWID.val = (s8 *)&u8abort_running_scan;
 		strWID.size = sizeof(char);
 
-		/*Sending Cfg*/
 		s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 					   get_id_from_handler(hif_drv));
 		if (s32Error) {
@@ -1390,26 +999,15 @@ static s32 Handle_ScanDone(struct host_if_drv *hif_drv,
 		return s32Error;
 	}
 
-	/*if there is an ongoing scan request*/
 	if (hif_drv->strWILC_UsrScanReq.pfUserScanResult) {
 		hif_drv->strWILC_UsrScanReq.pfUserScanResult(enuEvent, NULL,
 								hif_drv->strWILC_UsrScanReq.u32UserScanPvoid, NULL);
-		/*delete current scan request*/
 		hif_drv->strWILC_UsrScanReq.pfUserScanResult = NULL;
 	}
 
 	return s32Error;
 }
 
-/**
- *  @brief Handle_Connect
- *  @details       Sending config packet to firmware to starting connection
- *  @param[in]    struct connect_attr *pstrHostIFconnectAttr
- *  @return         Error code.
- *  @author
- *  @date
- *  @version	1.0
- */
 u8 u8ConnectedSSID[6] = {0};
 static s32 Handle_Connect(struct host_if_drv *hif_drv,
 			  struct connect_attr *pstrHostIFconnectAttr)
@@ -1417,14 +1015,11 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	s32 s32Error = 0;
 	struct wid strWIDList[8];
 	u32 u32WidsCount = 0, dummyval = 0;
-	/* char passphrase[] = "12345678"; */
 	u8 *pu8CurrByte = NULL;
 	struct join_bss_param *ptstrJoinBssParam;
 
 	PRINT_D(GENERIC_DBG, "Handling connect request\n");
 
-	/* if we try to connect to an already connected AP then discard the request */
-
 	if (memcmp(pstrHostIFconnectAttr->pu8bssid, u8ConnectedSSID, ETH_ALEN) == 0) {
 
 		s32Error = 0;
@@ -1484,10 +1079,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	strWIDList[u32WidsCount].val = (s8 *)(&(dummyval));
 	u32WidsCount++;
 
-	/* if((gWFiDrvHandle->strWILC_UsrConnReq.pu8ConnReqIEs != NULL) && */
-	/* (gWFiDrvHandle->strWILC_UsrConnReq.ConnReqIEsLen != 0)) */
 	{
-		/* IEs to be inserted in Association Request */
 		strWIDList[u32WidsCount].id = WID_INFO_ELEMENT_ASSOCIATE;
 		strWIDList[u32WidsCount].type = WID_BIN_DATA;
 		strWIDList[u32WidsCount].val = hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs;
@@ -1524,22 +1116,12 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 		gu8FlushedAuthType = (u8)hif_drv->strWILC_UsrConnReq.tenuAuth_type;
 
 	PRINT_INFO(HOSTINF_DBG, "Authentication Type = %x\n", hif_drv->strWILC_UsrConnReq.tenuAuth_type);
-	/*
-	 * strWIDList[u32WidsCount].u16WIDid = (u16)WID_11I_PSK;
-	 * strWIDList[u32WidsCount].enuWIDtype = WID_STR;
-	 * strWIDList[u32WidsCount].s32ValueSize = sizeof(passphrase);
-	 * strWIDList[u32WidsCount].ps8WidVal = (s8*)(passphrase);
-	 * u32WidsCount++;
-	 */
-
 	PRINT_D(HOSTINF_DBG, "Connecting to network of SSID %s on channel %d\n",
 		hif_drv->strWILC_UsrConnReq.pu8ssid, pstrHostIFconnectAttr->u8channel);
 
 	strWIDList[u32WidsCount].id = (u16)WID_JOIN_REQ_EXTENDED;
 	strWIDList[u32WidsCount].type = WID_STR;
-
-	/*Sending NoA attributes during connection*/
-	strWIDList[u32WidsCount].size = 112; /* 79; */
+	strWIDList[u32WidsCount].size = 112;
 	strWIDList[u32WidsCount].val = kmalloc(strWIDList[u32WidsCount].size, GFP_KERNEL);
 
 	if (memcmp("DIRECT-", pstrHostIFconnectAttr->pu8ssid, 7)) {
@@ -1559,71 +1141,55 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 		pu8CurrByte[pstrHostIFconnectAttr->ssidLen] = '\0';
 	}
 	pu8CurrByte += MAX_SSID_LEN;
-
-	/* BSS type*/
 	*(pu8CurrByte++) = INFRASTRUCTURE;
-	/* Channel*/
+
 	if ((pstrHostIFconnectAttr->u8channel >= 1) && (pstrHostIFconnectAttr->u8channel <= 14)) {
 		*(pu8CurrByte++) = pstrHostIFconnectAttr->u8channel;
 	} else {
 		PRINT_ER("Channel out of range\n");
 		*(pu8CurrByte++) = 0xFF;
 	}
-	/* Cap Info*/
 	*(pu8CurrByte++)  = (ptstrJoinBssParam->cap_info) & 0xFF;
 	*(pu8CurrByte++)  = ((ptstrJoinBssParam->cap_info) >> 8) & 0xFF;
 	PRINT_D(HOSTINF_DBG, "* Cap Info %0x*\n", (*(pu8CurrByte - 2) | ((*(pu8CurrByte - 1)) << 8)));
 
-	/* sa*/
 	if (pstrHostIFconnectAttr->pu8bssid != NULL)
 		memcpy(pu8CurrByte, pstrHostIFconnectAttr->pu8bssid, 6);
 	pu8CurrByte += 6;
 
-	/* bssid*/
 	if (pstrHostIFconnectAttr->pu8bssid != NULL)
 		memcpy(pu8CurrByte, pstrHostIFconnectAttr->pu8bssid, 6);
 	pu8CurrByte += 6;
 
-	/* Beacon Period*/
 	*(pu8CurrByte++)  = (ptstrJoinBssParam->beacon_period) & 0xFF;
 	*(pu8CurrByte++)  = ((ptstrJoinBssParam->beacon_period) >> 8) & 0xFF;
 	PRINT_D(HOSTINF_DBG, "* Beacon Period %d*\n", (*(pu8CurrByte - 2) | ((*(pu8CurrByte - 1)) << 8)));
-	/* DTIM Period*/
 	*(pu8CurrByte++)  =  ptstrJoinBssParam->dtim_period;
 	PRINT_D(HOSTINF_DBG, "* DTIM Period %d*\n", (*(pu8CurrByte - 1)));
-	/* Supported rates*/
+
 	memcpy(pu8CurrByte, ptstrJoinBssParam->supp_rates, MAX_RATES_SUPPORTED + 1);
 	pu8CurrByte += (MAX_RATES_SUPPORTED + 1);
 
-	/* wmm cap*/
 	*(pu8CurrByte++)  =  ptstrJoinBssParam->wmm_cap;
 	PRINT_D(HOSTINF_DBG, "* wmm cap%d*\n", (*(pu8CurrByte - 1)));
-	/* uapsd cap*/
 	*(pu8CurrByte++)  = ptstrJoinBssParam->uapsd_cap;
 
-	/* ht cap*/
 	*(pu8CurrByte++)  = ptstrJoinBssParam->ht_capable;
-	/* copy this information to the user request */
 	hif_drv->strWILC_UsrConnReq.IsHTCapable = ptstrJoinBssParam->ht_capable;
 
-	/* rsn found*/
 	*(pu8CurrByte++)  =  ptstrJoinBssParam->rsn_found;
 	PRINT_D(HOSTINF_DBG, "* rsn found %d*\n", *(pu8CurrByte - 1));
-	/* rsn group policy*/
 	*(pu8CurrByte++)  =  ptstrJoinBssParam->rsn_grp_policy;
 	PRINT_D(HOSTINF_DBG, "* rsn group policy %0x*\n", (*(pu8CurrByte - 1)));
-	/* mode_802_11i*/
 	*(pu8CurrByte++) =  ptstrJoinBssParam->mode_802_11i;
 	PRINT_D(HOSTINF_DBG, "* mode_802_11i %d*\n", (*(pu8CurrByte - 1)));
-	/* rsn pcip policy*/
+
 	memcpy(pu8CurrByte, ptstrJoinBssParam->rsn_pcip_policy, sizeof(ptstrJoinBssParam->rsn_pcip_policy));
 	pu8CurrByte += sizeof(ptstrJoinBssParam->rsn_pcip_policy);
 
-	/* rsn auth policy*/
 	memcpy(pu8CurrByte, ptstrJoinBssParam->rsn_auth_policy, sizeof(ptstrJoinBssParam->rsn_auth_policy));
 	pu8CurrByte += sizeof(ptstrJoinBssParam->rsn_auth_policy);
 
-	/* rsn auth policy*/
 	memcpy(pu8CurrByte, ptstrJoinBssParam->rsn_cap, sizeof(ptstrJoinBssParam->rsn_cap));
 	pu8CurrByte += sizeof(ptstrJoinBssParam->rsn_cap);
 
@@ -1662,16 +1228,9 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	} else
 		PRINT_D(HOSTINF_DBG, "NOA not present\n");
 
-	/* keep the buffer at the start of the allocated pointer to use it with the free*/
 	pu8CurrByte = strWIDList[u32WidsCount].val;
 	u32WidsCount++;
-
-	/* A temporary workaround to avoid handling the misleading MAC_DISCONNECTED raised from the
-	 *   firmware at chip reset when processing the WIDs of the Connect Request.
-	 *   (This workaround should be removed in the future when the Chip reset of the Connect WIDs is disabled) */
-	/* ////////////////////// */
 	gu32WidConnRstHack = 0;
-	/* ////////////////////// */
 
 	if (memcmp("DIRECT-", pstrHostIFconnectAttr->pu8ssid, 7)) {
 		memcpy(gu8FlushedJoinReq, pu8CurrByte, gu32FlushedJoinReqSize);
@@ -1725,9 +1284,7 @@ ERRORHANDLER:
 							       MAC_DISCONNECTED,
 							       NULL,
 							       pstrHostIFconnectAttr->pvUserArg);
-			/*Change state to idle*/
 			hif_drv->enuHostIFstate = HOST_IF_IDLE;
-			/* Deallocation */
 			if (strConnectInfo.pu8ReqIEs != NULL) {
 				kfree(strConnectInfo.pu8ReqIEs);
 				strConnectInfo.pu8ReqIEs = NULL;
@@ -1739,19 +1296,16 @@ ERRORHANDLER:
 	}
 
 	PRINT_D(HOSTINF_DBG, "Deallocating connection parameters\n");
-	/* Deallocate pstrHostIFconnectAttr->pu8bssid which was prevoisuly allocated by the sending thread */
 	if (pstrHostIFconnectAttr->pu8bssid != NULL) {
 		kfree(pstrHostIFconnectAttr->pu8bssid);
 		pstrHostIFconnectAttr->pu8bssid = NULL;
 	}
 
-	/* Deallocate pstrHostIFconnectAttr->pu8ssid which was prevoisuly allocated by the sending thread */
 	if (pstrHostIFconnectAttr->pu8ssid != NULL) {
 		kfree(pstrHostIFconnectAttr->pu8ssid);
 		pstrHostIFconnectAttr->pu8ssid = NULL;
 	}
 
-	/* Deallocate pstrHostIFconnectAttr->pu8IEs which was prevoisuly allocated by the sending thread */
 	if (pstrHostIFconnectAttr->pu8IEs != NULL) {
 		kfree(pstrHostIFconnectAttr->pu8IEs);
 		pstrHostIFconnectAttr->pu8IEs = NULL;
@@ -1762,17 +1316,6 @@ ERRORHANDLER:
 	return s32Error;
 }
 
-/**
- *  @brief                      Handle_FlushConnect
- *  @details            Sending config packet to firmware to flush an old connection
- *                              after switching FW from station one to hybrid one
- *  @param[in]          void * drvHandler
- *  @return             Error code.
- *  @author		Amr Abdel-Moghny
- *  @date			19 DEC 2013
- *  @version		8.0
- */
-
 static s32 Handle_FlushConnect(struct host_if_drv *hif_drv)
 {
 	s32 s32Error = 0;
@@ -1780,8 +1323,6 @@ static s32 Handle_FlushConnect(struct host_if_drv *hif_drv)
 	u32 u32WidsCount = 0;
 	u8 *pu8CurrByte = NULL;
 
-
-	/* IEs to be inserted in Association Request */
 	strWIDList[u32WidsCount].id = WID_INFO_ELEMENT_ASSOCIATE;
 	strWIDList[u32WidsCount].type = WID_BIN_DATA;
 	strWIDList[u32WidsCount].val = gu8FlushedInfoElemAsoc;
@@ -1823,15 +1364,6 @@ static s32 Handle_FlushConnect(struct host_if_drv *hif_drv)
 	return s32Error;
 }
 
-/**
- *  @brief                 Handle_ConnectTimeout
- *  @details       Call connect notification callback function indicating connection failure
- *  @param[in]    NONE
- *  @return         Error code.
- *  @author
- *  @date
- *  @version	1.0
- */
 static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 {
 	s32 s32Error = 0;
@@ -1851,10 +1383,6 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 
 	memset(&strConnectInfo, 0, sizeof(tstrConnectInfo));
 
-
-	/* First, we will notify the upper layer with the Connection failure {through the Connect Callback function},
-	 *   then we will notify our firmware also with the Connection failure {through sending to it Cfg packet carrying
-	 *   WID_DISCONNECT} */
 	if (hif_drv->strWILC_UsrConnReq.pfUserConnectResult != NULL)	{
 		if (hif_drv->strWILC_UsrConnReq.pu8bssid != NULL) {
 			memcpy(strConnectInfo.au8bssid,
@@ -1875,7 +1403,6 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 								   NULL,
 								   hif_drv->strWILC_UsrConnReq.u32UserConnectPvoid);
 
-		/* Deallocation of strConnectInfo.pu8ReqIEs */
 		if (strConnectInfo.pu8ReqIEs != NULL) {
 			kfree(strConnectInfo.pu8ReqIEs);
 			strConnectInfo.pu8ReqIEs = NULL;
@@ -1884,8 +1411,6 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 		PRINT_ER("Connect callback function pointer is NULL\n");
 	}
 
-	/* Here we will notify our firmware also with the Connection failure {through sending to it Cfg packet carrying
-	 *   WID_DISCONNECT} */
 	strWID.id = (u16)WID_DISCONNECT;
 	strWID.type = WID_CHAR;
 	strWID.val = (s8 *)&u16DummyReasonCode;
@@ -1898,7 +1423,6 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 	if (s32Error)
 		PRINT_ER("Failed to send dissconect config packet\n");
 
-	/* Deallocation of the Saved Connect Request in the global Handle */
 	hif_drv->strWILC_UsrConnReq.ssidLen = 0;
 	kfree(hif_drv->strWILC_UsrConnReq.pu8ssid);
 	kfree(hif_drv->strWILC_UsrConnReq.pu8bssid);
@@ -1906,7 +1430,7 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 	kfree(hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs);
 
 	eth_zero_addr(u8ConnectedSSID);
-	/*Freeing flushed join request params on connect timeout*/
+
 	if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == hif_drv) {
 		kfree(gu8FlushedJoinReq);
 		gu8FlushedJoinReq = NULL;
@@ -1919,15 +1443,6 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 	return s32Error;
 }
 
-/**
- *  @brief Handle_RcvdNtwrkInfo
- *  @details       Handling received network information
- *  @param[in]    struct rcvd_net_info *pstrRcvdNetworkInfo
- *  @return         Error code.
- *  @author
- *  @date
- *  @version	1.0
- */
 static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *hif_drv,
 				struct rcvd_net_info *pstrRcvdNetworkInfo)
 {
@@ -1943,7 +1458,6 @@ static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *hif_drv,
 	bNewNtwrkFound = true;
 	PRINT_INFO(HOSTINF_DBG, "Handling received network info\n");
 
-	/*if there is a an ongoing scan request*/
 	if (hif_drv->strWILC_UsrScanReq.pfUserScanResult) {
 		PRINT_D(HOSTINF_DBG, "State: Scanning, parsing network information received\n");
 		parse_network_info(pstrRcvdNetworkInfo->pu8Buffer, &pstrNetworkInfo);
@@ -1954,7 +1468,6 @@ static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *hif_drv,
 			goto done;
 		}
 
-		/* check whether this network is discovered before */
 		for (i = 0; i < hif_drv->strWILC_UsrScanReq.u32RcvdChCount; i++) {
 
 			if ((hif_drv->strWILC_UsrScanReq.astrFoundNetworkInfo[i].au8bssid != NULL) &&
@@ -1962,14 +1475,9 @@ static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *hif_drv,
 				if (memcmp(hif_drv->strWILC_UsrScanReq.astrFoundNetworkInfo[i].au8bssid,
 						pstrNetworkInfo->au8bssid, 6) == 0) {
 					if (pstrNetworkInfo->s8rssi <= hif_drv->strWILC_UsrScanReq.astrFoundNetworkInfo[i].s8rssi) {
-						/*we have already found this network with better rssi, so keep the old cached one and don't
-						 *  send anything to the upper layer */
 						PRINT_D(HOSTINF_DBG, "Network previously discovered\n");
 						goto done;
 					} else {
-						/* here the same already found network is found again but with a better rssi, so just update
-						 *   the rssi for this cached network and send this updated network to the upper layer but
-						 *   don't add a new record for it */
 						hif_drv->strWILC_UsrScanReq.astrFoundNetworkInfo[i].s8rssi = pstrNetworkInfo->s8rssi;
 						bNewNtwrkFound = false;
 						break;
@@ -1979,9 +1487,6 @@ static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *hif_drv,
 		}
 
 		if (bNewNtwrkFound == true) {
-			/* here it is confirmed that it is a new discovered network,
-			 * so add its record then call the User CallBack function */
-
 			PRINT_D(HOSTINF_DBG, "New network found\n");
 
 			if (hif_drv->strWILC_UsrScanReq.u32RcvdChCount < MAX_NUM_SCANNED_NETWORKS) {
@@ -1995,7 +1500,6 @@ static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *hif_drv,
 					hif_drv->strWILC_UsrScanReq.u32RcvdChCount++;
 
 					pstrNetworkInfo->bNewNetwork = true;
-					/* add new BSS to JoinBssTable */
 					pJoinParams = host_int_ParseJoinBssParam(pstrNetworkInfo);
 
 					hif_drv->strWILC_UsrScanReq.pfUserScanResult(SCAN_EVENT_NETWORK_FOUND, pstrNetworkInfo,
@@ -2009,20 +1513,17 @@ static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *hif_drv,
 			}
 		} else {
 			pstrNetworkInfo->bNewNetwork = false;
-			/* just call the User CallBack function to send the same discovered network with its updated RSSI */
 			hif_drv->strWILC_UsrScanReq.pfUserScanResult(SCAN_EVENT_NETWORK_FOUND, pstrNetworkInfo,
 									hif_drv->strWILC_UsrScanReq.u32UserScanPvoid, NULL);
 		}
 	}
 
 done:
-	/* Deallocate pstrRcvdNetworkInfo->pu8Buffer which was prevoisuly allocated by the sending thread */
 	if (pstrRcvdNetworkInfo->pu8Buffer != NULL) {
 		kfree(pstrRcvdNetworkInfo->pu8Buffer);
 		pstrRcvdNetworkInfo->pu8Buffer = NULL;
 	}
 
-	/*free structure allocated*/
 	if (pstrNetworkInfo != NULL) {
 		DeallocateNetworkInfo(pstrNetworkInfo);
 		pstrNetworkInfo = NULL;
@@ -2031,20 +1532,9 @@ done:
 	return s32Error;
 }
 
-/**
- *  @brief Handle_RcvdGnrlAsyncInfo
- *  @details       Handling received asynchrous general network information
- *  @param[in]     struct rcvd_async_info *pstrRcvdGnrlAsyncInfo
- *  @return         Error code.
- *  @author
- *  @date
- *  @version	1.0
- */
 static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 				    struct rcvd_async_info *pstrRcvdGnrlAsyncInfo)
 {
-	/* TODO: mostafa: till now, this function just handles only the received mac status msg, */
-	/*				 which carries only 1 WID which have WID ID = WID_STATUS */
 	s32 s32Error = 0;
 	u8 u8MsgType = 0;
 	u8 u8MsgID = 0;
@@ -2076,31 +1566,20 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 
 		u8MsgType = pstrRcvdGnrlAsyncInfo->pu8Buffer[0];
 
-		/* Check whether the received message type is 'I' */
 		if ('I' != u8MsgType) {
 			PRINT_ER("Received Message format incorrect.\n");
 			return -EFAULT;
 		}
 
-		/* Extract message ID */
 		u8MsgID = pstrRcvdGnrlAsyncInfo->pu8Buffer[1];
-
-		/* Extract message Length */
 		u16MsgLen = MAKE_WORD16(pstrRcvdGnrlAsyncInfo->pu8Buffer[2], pstrRcvdGnrlAsyncInfo->pu8Buffer[3]);
-
-		/* Extract WID ID [expected to be = WID_STATUS] */
 		u16WidID = MAKE_WORD16(pstrRcvdGnrlAsyncInfo->pu8Buffer[4], pstrRcvdGnrlAsyncInfo->pu8Buffer[5]);
-
-		/* Extract WID Length [expected to be = 1] */
 		u8WidLen = pstrRcvdGnrlAsyncInfo->pu8Buffer[6];
-
-		/* get the WID value [expected to be one of two values: either MAC_CONNECTED = (1) or MAC_DISCONNECTED = (0)] */
 		u8MacStatus  = pstrRcvdGnrlAsyncInfo->pu8Buffer[7];
 		u8MacStatusReasonCode = pstrRcvdGnrlAsyncInfo->pu8Buffer[8];
 		u8MacStatusAdditionalInfo = pstrRcvdGnrlAsyncInfo->pu8Buffer[9];
 		PRINT_INFO(HOSTINF_DBG, "Recieved MAC status = %d with Reason = %d , Info = %d\n", u8MacStatus, u8MacStatusReasonCode, u8MacStatusAdditionalInfo);
 		if (hif_drv->enuHostIFstate == HOST_IF_WAITING_CONN_RESP) {
-			/* our station had sent Association Request frame, so here it will get the Association Response frame then parse it */
 			u32 u32RcvdAssocRespInfoLen;
 			tstrConnectRespInfo *pstrConnectRespInfo = NULL;
 
@@ -2126,7 +1605,6 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 					if (s32Err) {
 						PRINT_ER("ParseAssocRespInfo() returned error %d\n", s32Err);
 					} else {
-						/* use the necessary parsed Info from the Received Association Response */
 						strConnectInfo.u16ConnectStatus = pstrConnectRespInfo->u16ConnectStatus;
 
 						if (strConnectInfo.u16ConnectStatus == SUCCESSFUL_STATUSCODE) {
@@ -2141,7 +1619,6 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 							}
 						}
 
-						/* deallocate the Assoc. Resp. parsed structure as it is not needed anymore */
 						if (pstrConnectRespInfo != NULL) {
 							DeallocateAssocRespInfo(pstrConnectRespInfo);
 							pstrConnectRespInfo = NULL;
@@ -2150,9 +1627,6 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 				}
 			}
 
-			/* The station has just received mac status and it also received assoc. response which
-			 *   it was waiting for.
-			 *   So check first the matching between the received mac status and the received status code in Asoc Resp */
 			if ((u8MacStatus == MAC_CONNECTED) &&
 			    (strConnectInfo.u16ConnectStatus != SUCCESSFUL_STATUSCODE))	{
 				PRINT_ER("Received MAC status is MAC_CONNECTED while the received status code in Asoc Resp is not SUCCESSFUL_STATUSCODE\n");
@@ -2163,8 +1637,6 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 				eth_zero_addr(u8ConnectedSSID);
 			}
 
-			/* TODO: mostafa: correct BSSID should be retrieved from actual BSSID received from AP */
-			/*               through a structure of type tstrConnectRespInfo */
 			if (hif_drv->strWILC_UsrConnReq.pu8bssid != NULL) {
 				PRINT_D(HOSTINF_DBG, "Retrieving actual BSSID from AP\n");
 				memcpy(strConnectInfo.au8bssid, hif_drv->strWILC_UsrConnReq.pu8bssid, 6);
@@ -2193,10 +1665,6 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 									   NULL,
 									   hif_drv->strWILC_UsrConnReq.u32UserConnectPvoid);
 
-
-			/* if received mac status is MAC_CONNECTED and
-			 *  received status code in Asoc Resp is SUCCESSFUL_STATUSCODE, change state to CONNECTED
-			 *  else change state to IDLE */
 			if ((u8MacStatus == MAC_CONNECTED) &&
 			    (strConnectInfo.u16ConnectStatus == SUCCESSFUL_STATUSCODE))	{
 				host_int_set_power_mgmt(hif_drv, 0, 0);
@@ -2208,17 +1676,12 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 				g_obtainingIP = true;
 				mod_timer(&hDuringIpTimer,
 					  jiffies + msecs_to_jiffies(10000));
-
-				/* open a BA session if possible */
-				/* if(pstrWFIDrv->strWILC_UsrConnReq.IsHTCapable) */
-				/* BA_SESSION_DEFAULT_BUFFER_SIZE,BA_SESSION_DEFAULT_TIMEOUT); */
 			} else {
 				PRINT_D(HOSTINF_DBG, "MAC status : %d and Connect Status : %d\n", u8MacStatus, strConnectInfo.u16ConnectStatus);
 				hif_drv->enuHostIFstate = HOST_IF_IDLE;
 				gbScanWhileConnected = false;
 			}
 
-			/* Deallocation */
 			if (strConnectInfo.pu8RespIEs != NULL) {
 				kfree(strConnectInfo.pu8RespIEs);
 				strConnectInfo.pu8RespIEs = NULL;
@@ -2235,7 +1698,6 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 			kfree(hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs);
 		} else if ((u8MacStatus == MAC_DISCONNECTED) &&
 			   (hif_drv->enuHostIFstate == HOST_IF_CONNECTED)) {
-			/* Disassociation or Deauthentication frame has been received */
 			PRINT_D(HOSTINF_DBG, "Received MAC_DISCONNECTED from the FW\n");
 
 			memset(&strDisconnectNotifInfo, 0, sizeof(tstrDisconnectNotifInfo));
@@ -2266,27 +1728,12 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 
 			eth_zero_addr(hif_drv->au8AssociatedBSSID);
 
-
-			/* Deallocation */
-
-			/* if Information Elements were retrieved from the Received deauth/disassoc frame, then they
-			 *  should be deallocated here */
-			/*
-			 * if(strDisconnectNotifInfo.ie != NULL)
-			 * {
-			 *      kfree(strDisconnectNotifInfo.ie);
-			 *      strDisconnectNotifInfo.ie = NULL;
-			 * }
-			 */
-
 			hif_drv->strWILC_UsrConnReq.ssidLen = 0;
 			kfree(hif_drv->strWILC_UsrConnReq.pu8ssid);
 			kfree(hif_drv->strWILC_UsrConnReq.pu8bssid);
 			hif_drv->strWILC_UsrConnReq.ConnReqIEsLen = 0;
 			kfree(hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs);
 
-			/*Freeing flushed join request params on receiving*/
-			/*MAC_DISCONNECTED while connected*/
 			if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == hif_drv) {
 				kfree(gu8FlushedJoinReq);
 				gu8FlushedJoinReq = NULL;
@@ -2303,7 +1750,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 			   (hif_drv->strWILC_UsrScanReq.pfUserScanResult != NULL)) {
 			PRINT_D(HOSTINF_DBG, "Received MAC_DISCONNECTED from the FW while scanning\n");
 			PRINT_D(HOSTINF_DBG, "\n\n<< Abort the running Scan >>\n\n");
-			/*Abort the running scan*/
+
 			del_timer(&hif_drv->hScanTimer);
 			if (hif_drv->strWILC_UsrScanReq.pfUserScanResult)
 				Handle_ScanDone(hif_drv, SCAN_EVENT_ABORTED);
@@ -2312,7 +1759,6 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 
 	}
 
-	/* Deallocate pstrRcvdGnrlAsyncInfo->pu8Buffer which was prevoisuly allocated by the sending thread */
 	if (pstrRcvdGnrlAsyncInfo->pu8Buffer != NULL) {
 		kfree(pstrRcvdGnrlAsyncInfo->pu8Buffer);
 		pstrRcvdGnrlAsyncInfo->pu8Buffer = NULL;
@@ -2321,15 +1767,6 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 	return s32Error;
 }
 
-/**
- *  @brief Handle_Key
- *  @details       Sending config packet to firmware to set key
- *  @param[in]    struct key_attr *pstrHostIFkeyAttr
- *  @return         Error code.
- *  @author
- *  @date
- *  @version	1.0
- */
 static int Handle_Key(struct host_if_drv *hif_drv,
 		      struct key_attr *pstrHostIFkeyAttr)
 {
@@ -2455,14 +1892,6 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 
 			memset(pu8keybuf, 0, RX_MIC_KEY_MSG_LEN);
 
-
-			/*|----------------------------------------------------------------------------|
-			 * |Sta Address | Key RSC | KeyID | Key Length | Temporal Key	| Rx Michael Key |
-			 * |------------|---------|-------|------------|---------------|----------------|
-			 |	6 bytes	 | 8 byte  |1 byte |  1 byte	|   16 bytes	|	  8 bytes	 |*/
-
-
-
 			if (pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.pu8seq != NULL)
 				memcpy(pu8keybuf + 6, pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.pu8seq, 8);
 
@@ -2473,7 +1902,6 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 
 			memcpy(pu8keybuf + 16, pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.pu8key,
 				    pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.u8Keylen);
-			/* pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Ciphermode =  0X51; */
 			strWIDList[0].id = (u16)WID_11I_MODE;
 			strWIDList[0].type = WID_CHAR;
 			strWIDList[0].size = sizeof(char);
@@ -2488,10 +1916,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 						   get_id_from_handler(hif_drv));
 
 			kfree(pu8keybuf);
-
-			/* ////////////////////////// */
 			up(&hif_drv->hSemTestKeyBlock);
-			/* ///////////////////////// */
 		}
 
 		if (pstrHostIFkeyAttr->u8KeyAction & ADDKEY) {
@@ -2506,12 +1931,6 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 
 			memset(pu8keybuf, 0, RX_MIC_KEY_MSG_LEN);
 
-
-			/*|----------------------------------------------------------------------------|
-			 * |Sta Address | Key RSC | KeyID | Key Length | Temporal Key	| Rx Michael Key |
-			 * |------------|---------|-------|------------|---------------|----------------|
-			 |	6 bytes	 | 8 byte  |1 byte |  1 byte	|   16 bytes	|	  8 bytes	 |*/
-
 			if (hif_drv->enuHostIFstate == HOST_IF_CONNECTED)
 				memcpy(pu8keybuf, hif_drv->au8AssociatedBSSID, ETH_ALEN);
 			else
@@ -2534,10 +1953,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 						   get_id_from_handler(hif_drv));
 
 			kfree(pu8keybuf);
-
-			/* ////////////////////////// */
 			up(&hif_drv->hSemTestKeyBlock);
-			/* ///////////////////////// */
 		}
 _WPARxGtk_end_case_:
 		kfree(pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.pu8key);
@@ -2562,17 +1978,9 @@ _WPARxGtk_end_case_:
 
 			}
 
-			/*|-----------------------------------------------------------------------------|
-			 * |Station address |   keyidx     |Key Length    |Temporal Key  | Rx Michael Key |Tx Michael Key |
-			 * |----------------|------------  |--------------|----------------|---------------|
-			 |	6 bytes    |	1 byte    |   1byte	 |   16 bytes	 |	  8 bytes	  |	   8 bytes	  |
-			 |-----------------------------------------------------------------------------|*/
-
-			memcpy(pu8keybuf, pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.pu8macaddr, 6);  /*1 bytes Key Length */
-
+			memcpy(pu8keybuf, pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.pu8macaddr, 6);
 			memcpy(pu8keybuf + 6, &pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.u8keyidx, 1);
 			memcpy(pu8keybuf + 7, &pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.u8Keylen, 1);
-			/*16 byte TK*/
 			memcpy(pu8keybuf + 8, pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.pu8key,
 				    pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.u8Keylen);
 
@@ -2590,10 +1998,7 @@ _WPARxGtk_end_case_:
 			s32Error = send_config_pkt(SET_CFG, strWIDList, 2,
 						   get_id_from_handler(hif_drv));
 			kfree(pu8keybuf);
-
-			/* ////////////////////////// */
 			up(&hif_drv->hSemTestKeyBlock);
-			/* ///////////////////////// */
 		}
 		if (pstrHostIFkeyAttr->u8KeyAction & ADDKEY) {
 
@@ -2609,16 +2014,8 @@ _WPARxGtk_end_case_:
 
 			}
 
-			/*|-----------------------------------------------------------------------------|
-			 * |Station address | Key Length |	Temporal Key | Rx Michael Key |Tx Michael Key |
-			 * |----------------|------------|--------------|----------------|---------------|
-			 |	6 bytes		 |	1byte	  |   16 bytes	 |	  8 bytes	  |	   8 bytes	  |
-			 |-----------------------------------------------------------------------------|*/
-
-			memcpy(pu8keybuf, pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.pu8macaddr, 6);  /*1 bytes Key Length */
-
+			memcpy(pu8keybuf, pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.pu8macaddr, 6);
 			memcpy(pu8keybuf + 6, &pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.u8Keylen, 1);
-			/*16 byte TK*/
 			memcpy(pu8keybuf + 7, pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.pu8key,
 				    pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.u8Keylen);
 
@@ -2631,10 +2028,7 @@ _WPARxGtk_end_case_:
 			s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 						   get_id_from_handler(hif_drv));
 			kfree(pu8keybuf);
-
-			/* ////////////////////////// */
 			up(&hif_drv->hSemTestKeyBlock);
-			/* ///////////////////////// */
 		}
 
 _WPAPtk_end_case_:
@@ -2682,16 +2076,6 @@ _WPAPtk_end_case_:
 	return s32Error;
 }
 
-
-/**
- *  @brief Handle_Disconnect
- *  @details       Sending config packet to firmware to disconnect
- *  @param[in]    NONE
- *  @return         NONE
- *  @author
- *  @date
- *  @version	1.0
- */
 static void Handle_Disconnect(struct host_if_drv *hif_drv)
 {
 	struct wid strWID;
@@ -2736,8 +2120,6 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 		}
 
 		if (hif_drv->strWILC_UsrConnReq.pfUserConnectResult != NULL)	{
-
-			/*Stop connect timer, if connection in progress*/
 			if (hif_drv->enuHostIFstate == HOST_IF_WAITING_CONN_RESP) {
 				PRINT_D(HOSTINF_DBG, "Upper layer requested termination of connection\n");
 				del_timer(&hif_drv->hConnectTimer);
@@ -2755,8 +2137,6 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 
 		eth_zero_addr(hif_drv->au8AssociatedBSSID);
 
-
-		/* Deallocation */
 		hif_drv->strWILC_UsrConnReq.ssidLen = 0;
 		kfree(hif_drv->strWILC_UsrConnReq.pu8ssid);
 		kfree(hif_drv->strWILC_UsrConnReq.pu8bssid);
@@ -2774,10 +2154,7 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 
 	}
 
-	/* ////////////////////////// */
 	up(&hif_drv->hSemTestDisconnectBlock);
-	/* ///////////////////////// */
-
 }
 
 
@@ -2791,16 +2168,6 @@ void resolve_disconnect_aberration(struct host_if_drv *hif_drv)
 	}
 }
 
-/**
- *  @brief Handle_GetChnl
- *  @details       Sending config packet to get channel
- *  @param[in]    NONE
- *  @return         NONE
- *
- *  @author
- *  @date
- *  @version	1.0
- */
 static s32 Handle_GetChnl(struct host_if_drv *hif_drv)
 {
 
@@ -2816,7 +2183,7 @@ static s32 Handle_GetChnl(struct host_if_drv *hif_drv)
 
 	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
-	/*get the value by searching the local copy*/
+
 	if (s32Error) {
 		PRINT_ER("Failed to get channel number\n");
 		s32Error = -EFAULT;
@@ -2830,16 +2197,6 @@ static s32 Handle_GetChnl(struct host_if_drv *hif_drv)
 
 }
 
-
-/**
- *  @brief Handle_GetRssi
- *  @details       Sending config packet to get RSSI
- *  @param[in]    NONE
- *  @return         NONE
- *  @author
- *  @date
- *  @version	1.0
- */
 static void Handle_GetRssi(struct host_if_drv *hif_drv)
 {
 	s32 s32Error = 0;
@@ -2850,7 +2207,6 @@ static void Handle_GetRssi(struct host_if_drv *hif_drv)
 	strWID.val = &gs8Rssi;
 	strWID.size = sizeof(char);
 
-	/*Sending Cfg*/
 	PRINT_D(HOSTINF_DBG, "Getting RSSI value\n");
 
 	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
@@ -2877,7 +2233,7 @@ static void Handle_GetLinkspeed(struct host_if_drv *hif_drv)
 	strWID.type = WID_CHAR;
 	strWID.val = &gs8lnkspd;
 	strWID.size = sizeof(char);
-	/*Sending Cfg*/
+
 	PRINT_D(HOSTINF_DBG, "Getting LINKSPEED value\n");
 
 	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
@@ -2938,17 +2294,6 @@ s32 Handle_GetStatistics(struct host_if_drv *hif_drv, struct rf_info *pstrStatis
 
 }
 
-/**
- *  @brief Handle_Get_InActiveTime
- *  @details       Sending config packet to set mac adddress for station and
- *                 get inactive time
- *  @param[in]    NONE
- *  @return         NONE
- *
- *  @author
- *  @date
- *  @version	1.0
- */
 static s32 Handle_Get_InActiveTime(struct host_if_drv *hif_drv,
 				   struct sta_inactive_t *strHostIfStaInactiveT)
 {
@@ -2972,7 +2317,7 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *hif_drv,
 
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
-	/*get the value by searching the local copy*/
+
 	if (s32Error) {
 		PRINT_ER("Failed to SET incative time\n");
 		return -EFAULT;
@@ -2987,7 +2332,7 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *hif_drv,
 
 	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
-	/*get the value by searching the local copy*/
+
 	if (s32Error) {
 		PRINT_ER("Failed to get incative time\n");
 		return -EFAULT;
@@ -3004,16 +2349,6 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *hif_drv,
 
 }
 
-
-/**
- *  @brief Handle_AddBeacon
- *  @details       Sending config packet to add beacon
- *  @param[in]    struct beacon_attr *pstrSetBeaconParam
- *  @return         NONE
- *  @author
- *  @date
- *  @version	1.0
- */
 static void Handle_AddBeacon(struct host_if_drv *hif_drv,
 			     struct beacon_attr *pstrSetBeaconParam)
 {
@@ -3058,9 +2393,6 @@ static void Handle_AddBeacon(struct host_if_drv *hif_drv,
 		memcpy(pu8CurrByte, pstrSetBeaconParam->pu8Tail, pstrSetBeaconParam->u32TailLen);
 	pu8CurrByte += pstrSetBeaconParam->u32TailLen;
 
-
-
-	/*Sending Cfg*/
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
 	if (s32Error)
@@ -3072,16 +2404,6 @@ ERRORHANDLER:
 	kfree(pstrSetBeaconParam->pu8Tail);
 }
 
-
-/**
- *  @brief Handle_AddBeacon
- *  @details       Sending config packet to delete beacon
- *  @param[in]	struct host_if_drv *drvHandler
- *  @return         NONE
- *  @author
- *  @date
- *  @version	1.0
- */
 static void Handle_DelBeacon(struct host_if_drv *hif_drv)
 {
 	s32 s32Error = 0;
@@ -3099,25 +2421,13 @@ static void Handle_DelBeacon(struct host_if_drv *hif_drv)
 	pu8CurrByte = strWID.val;
 
 	PRINT_D(HOSTINF_DBG, "Deleting BEACON\n");
-	/* TODO: build del beacon message*/
 
-	/*Sending Cfg*/
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
 	if (s32Error)
 		PRINT_ER("Failed to send delete beacon config packet\n");
 }
 
-
-/**
- *  @brief WILC_HostIf_PackStaParam
- *  @details       Handling packing of the station params in a buffer
- *  @param[in]   u8* pu8Buffer, struct add_sta_param *pstrStationParam
- *  @return         NONE
- *  @author
- *  @date
- *  @version	1.0
- */
 static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer,
 				    struct add_sta_param *pstrStationParam)
 {
@@ -3164,15 +2474,6 @@ static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer,
 	return pu8CurrByte - pu8Buffer;
 }
 
-/**
- *  @brief Handle_AddStation
- *  @details       Sending config packet to add station
- *  @param[in]   struct add_sta_param *pstrStationParam
- *  @return         NONE
- *  @author
- *  @date
- *  @version	1.0
- */
 static void Handle_AddStation(struct host_if_drv *hif_drv,
 			      struct add_sta_param *pstrStationParam)
 {
@@ -3192,7 +2493,6 @@ static void Handle_AddStation(struct host_if_drv *hif_drv,
 	pu8CurrByte = strWID.val;
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
-	/*Sending Cfg*/
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
 	if (s32Error != 0)
@@ -3203,15 +2503,6 @@ ERRORHANDLER:
 	kfree(strWID.val);
 }
 
-/**
- *  @brief Handle_DelAllSta
- *  @details        Sending config packet to delete station
- *  @param[in]   tstrHostIFDelSta* pstrDelStaParam
- *  @return         NONE
- *  @author
- *  @date
- *  @version	1.0
- */
 static void Handle_DelAllSta(struct host_if_drv *hif_drv,
 			     struct del_all_sta *pstrDelAllStaParam)
 {
@@ -3245,7 +2536,6 @@ static void Handle_DelAllSta(struct host_if_drv *hif_drv,
 		pu8CurrByte += ETH_ALEN;
 	}
 
-	/*Sending Cfg*/
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
 	if (s32Error)
@@ -3257,16 +2547,6 @@ ERRORHANDLER:
 	up(&hWaitResponse);
 }
 
-
-/**
- *  @brief Handle_DelStation
- *  @details        Sending config packet to delete station
- *  @param[in]   struct del_sta *pstrDelStaParam
- *  @return         NONE
- *  @author
- *  @date
- *  @version	1.0
- */
 static void Handle_DelStation(struct host_if_drv *hif_drv,
 			      struct del_sta *pstrDelStaParam)
 {
@@ -3288,7 +2568,6 @@ static void Handle_DelStation(struct host_if_drv *hif_drv,
 
 	memcpy(pu8CurrByte, pstrDelStaParam->au8MacAddr, ETH_ALEN);
 
-	/*Sending Cfg*/
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
 	if (s32Error)
@@ -3298,16 +2577,6 @@ ERRORHANDLER:
 	kfree(strWID.val);
 }
 
-
-/**
- *  @brief Handle_EditStation
- *  @details        Sending config packet to edit station
- *  @param[in]   struct add_sta_param *pstrStationParam
- *  @return         NONE
- *  @author
- *  @date
- *  @version	1.0
- */
 static void Handle_EditStation(struct host_if_drv *hif_drv,
 			       struct add_sta_param *pstrStationParam)
 {
@@ -3327,7 +2596,6 @@ static void Handle_EditStation(struct host_if_drv *hif_drv,
 	pu8CurrByte = strWID.val;
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
-	/*Sending Cfg*/
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
 	if (s32Error)
@@ -3338,15 +2606,6 @@ ERRORHANDLER:
 	kfree(strWID.val);
 }
 
-/**
- *  @brief Handle_RemainOnChan
- *  @details        Sending config packet to edit station
- *  @param[in]   tstrWILC_AddStaParam* pstrStationParam
- *  @return         NONE
- *  @author
- *  @date
- *  @version	1.0
- */
 static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
 			       struct remain_ch *pstrHostIfRemainOnChan)
 {
@@ -3354,7 +2613,6 @@ static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
 	u8 u8remain_on_chan_flag;
 	struct wid strWID;
 
-	/*If it's a pendig remain-on-channel, don't overwrite gWFiDrvHandle values (since incoming msg is garbbage)*/
 	if (!hif_drv->u8RemainOnChan_pendingreq) {
 		hif_drv->strHostIfRemainOnChan.pVoid = pstrHostIfRemainOnChan->pVoid;
 		hif_drv->strHostIfRemainOnChan.pRemainOnChanExpired = pstrHostIfRemainOnChan->pRemainOnChanExpired;
@@ -3362,7 +2620,6 @@ static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
 		hif_drv->strHostIfRemainOnChan.u16Channel = pstrHostIfRemainOnChan->u16Channel;
 		hif_drv->strHostIfRemainOnChan.u32ListenSessionID = pstrHostIfRemainOnChan->u32ListenSessionID;
 	} else {
-		/*Set the channel to use it as a wid val*/
 		pstrHostIfRemainOnChan->u16Channel = hif_drv->strHostIfRemainOnChan.u16Channel;
 	}
 
@@ -3400,7 +2657,6 @@ static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
 	strWID.val[0] = u8remain_on_chan_flag;
 	strWID.val[1] = (s8)pstrHostIfRemainOnChan->u16Channel;
 
-	/*Sending Cfg*/
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
 	if (s32Error != 0)
@@ -3414,7 +2670,6 @@ ERRORHANDLER:
 			  jiffies +
 			  msecs_to_jiffies(pstrHostIfRemainOnChan->u32duration));
 
-		/*Calling CFG ready_on_channel*/
 		if (hif_drv->strHostIfRemainOnChan.pRemainOnChanReady)
 			hif_drv->strHostIfRemainOnChan.pRemainOnChanReady(hif_drv->strHostIfRemainOnChan.pVoid);
 
@@ -3424,15 +2679,6 @@ ERRORHANDLER:
 	return s32Error;
 }
 
-/**
- *  @brief Handle_RegisterFrame
- *  @details
- *  @param[in]
- *  @return         NONE
- *  @author
- *  @date
- *  @version	1.0
- */
 static int Handle_RegisterFrame(struct host_if_drv *hif_drv,
 				struct reg_frame *pstrHostIfRegisterFrame)
 {
@@ -3442,7 +2688,6 @@ static int Handle_RegisterFrame(struct host_if_drv *hif_drv,
 
 	PRINT_D(HOSTINF_DBG, "Handling frame register Flag : %d FrameType: %d\n", pstrHostIfRegisterFrame->bReg, pstrHostIfRegisterFrame->u16FrameType);
 
-	/*prepare configuration packet*/
 	strWID.id = (u16)WID_REGISTER_FRAME;
 	strWID.type = WID_STR;
 	strWID.val = kmalloc(sizeof(u16) + 2, GFP_KERNEL);
@@ -3458,8 +2703,6 @@ static int Handle_RegisterFrame(struct host_if_drv *hif_drv,
 
 	strWID.size = sizeof(u16) + 2;
 
-
-	/*Sending Cfg*/
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
 	if (s32Error) {
@@ -3471,15 +2714,6 @@ static int Handle_RegisterFrame(struct host_if_drv *hif_drv,
 
 }
 
-/**
- *  @brief                      Handle_ListenStateExpired
- *  @details            Handle of listen state expiration
- *  @param[in]          NONE
- *  @return             Error code.
- *  @author
- *  @date
- *  @version		1.0
- */
 #define FALSE_FRMWR_CHANNEL 100
 static u32 Handle_ListenStateExpired(struct host_if_drv *hif_drv,
 				     struct remain_ch *pstrHostIfRemainOnChan)
@@ -3490,8 +2724,6 @@ static u32 Handle_ListenStateExpired(struct host_if_drv *hif_drv,
 
 	PRINT_D(HOSTINF_DBG, "CANCEL REMAIN ON CHAN\n");
 
-	/*Make sure we are already in listen state*/
-	/*This is to handle duplicate expiry messages (listen timer fired and supplicant called cancel_remain_on_channel())*/
 	if (P2P_LISTEN_STATE) {
 		u8remain_on_chan_flag = false;
 		strWID.id = (u16)WID_REMAIN_ON_CHAN;
@@ -3505,7 +2737,6 @@ static u32 Handle_ListenStateExpired(struct host_if_drv *hif_drv,
 		strWID.val[0] = u8remain_on_chan_flag;
 		strWID.val[1] = FALSE_FRMWR_CHANNEL;
 
-		/*Sending Cfg*/
 		s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 					   get_id_from_handler(hif_drv));
 		if (s32Error != 0) {
@@ -3527,45 +2758,24 @@ _done_:
 	return s32Error;
 }
 
-
-/**
- *  @brief                      ListenTimerCB
- *  @details            Callback function of remain-on-channel timer
- *  @param[in]          NONE
- *  @return             Error code.
- *  @author
- *  @date
- *  @version		1.0
- */
 static void ListenTimerCB(unsigned long arg)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
 	struct host_if_drv *hif_drv = (struct host_if_drv *)arg;
-	/*Stopping remain-on-channel timer*/
+
 	del_timer(&hif_drv->hRemainOnChannel);
 
-	/* prepare the Timer Callback message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_LISTEN_TIMER_FIRED;
 	msg.drv = hif_drv;
 	msg.body.remain_on_ch.u32ListenSessionID = hif_drv->strHostIfRemainOnChan.u32ListenSessionID;
 
-	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 }
 
-/**
- *  @brief Handle_EditStation
- *  @details        Sending config packet to edit station
- *  @param[in]   tstrWILC_AddStaParam* pstrStationParam
- *  @return         NONE
- *  @author
- *  @date
- *  @version	1.0
- */
 static void Handle_PowerManagement(struct host_if_drv *hif_drv,
 				   struct power_mgmt_param *strPowerMgmtParam)
 {
@@ -3585,22 +2795,12 @@ static void Handle_PowerManagement(struct host_if_drv *hif_drv,
 
 	PRINT_D(HOSTINF_DBG, "Handling Power Management\n");
 
-	/*Sending Cfg*/
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
 	if (s32Error)
 		PRINT_ER("Failed to send power management config packet\n");
 }
 
-/**
- *  @brief Handle_SetMulticastFilter
- *  @details        Set Multicast filter in firmware
- *  @param[in]   struct set_multicast *strHostIfSetMulti
- *  @return         NONE
- *  @author		asobhy
- *  @date
- *  @version	1.0
- */
 static void Handle_SetMulticastFilter(struct host_if_drv *hif_drv,
 				      struct set_multicast *strHostIfSetMulti)
 {
@@ -3631,7 +2831,6 @@ static void Handle_SetMulticastFilter(struct host_if_drv *hif_drv,
 	if ((strHostIfSetMulti->u32count) > 0)
 		memcpy(pu8CurrByte, gau8MulticastMacAddrList, ((strHostIfSetMulti->u32count) * ETH_ALEN));
 
-	/*Sending Cfg*/
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
 	if (s32Error)
@@ -3642,16 +2841,6 @@ ERRORHANDLER:
 
 }
 
-
-/**
- *  @brief                      Handle_AddBASession
- *  @details            Add block ack session
- *  @param[in]          tstrHostIFSetMulti* strHostIfSetMulti
- *  @return             NONE
- *  @author		Amr Abdel-Moghny
- *  @date			Feb. 2014
- *  @version		9.0
- */
 static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 			       struct ba_session_info *strHostIfBASessionInfo)
 {
@@ -3673,27 +2862,20 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 	strWID.val = kmalloc(BLOCK_ACK_REQ_SIZE, GFP_KERNEL);
 	strWID.size = BLOCK_ACK_REQ_SIZE;
 	ptr = strWID.val;
-	/* *ptr++ = 0x14; */
 	*ptr++ = 0x14;
 	*ptr++ = 0x3;
 	*ptr++ = 0x0;
 	memcpy(ptr, strHostIfBASessionInfo->au8Bssid, ETH_ALEN);
 	ptr += ETH_ALEN;
 	*ptr++ = strHostIfBASessionInfo->u8Ted;
-	/* BA Policy*/
 	*ptr++ = 1;
-	/* Buffer size*/
 	*ptr++ = (strHostIfBASessionInfo->u16BufferSize & 0xFF);
 	*ptr++ = ((strHostIfBASessionInfo->u16BufferSize >> 16) & 0xFF);
-	/* BA timeout*/
 	*ptr++ = (strHostIfBASessionInfo->u16SessionTimeout & 0xFF);
 	*ptr++ = ((strHostIfBASessionInfo->u16SessionTimeout >> 16) & 0xFF);
-	/* ADDBA timeout*/
 	*ptr++ = (AddbaTimeout & 0xFF);
 	*ptr++ = ((AddbaTimeout >> 16) & 0xFF);
-	/* Group Buffer Max Frames*/
 	*ptr++ = 8;
-	/* Group Buffer Timeout */
 	*ptr++ = 0;
 
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
@@ -3706,20 +2888,15 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 	strWID.type = WID_STR;
 	strWID.size = 15;
 	ptr = strWID.val;
-	/* *ptr++ = 0x14; */
 	*ptr++ = 15;
 	*ptr++ = 7;
 	*ptr++ = 0x2;
 	memcpy(ptr, strHostIfBASessionInfo->au8Bssid, ETH_ALEN);
 	ptr += ETH_ALEN;
-	/* TID*/
 	*ptr++ = strHostIfBASessionInfo->u8Ted;
-	/* Max Num MSDU */
 	*ptr++ = 8;
-	/* BA timeout*/
 	*ptr++ = (strHostIfBASessionInfo->u16BufferSize & 0xFF);
 	*ptr++ = ((strHostIfBASessionInfo->u16SessionTimeout >> 16) & 0xFF);
-	/*Ack-Policy */
 	*ptr++ = 3;
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
@@ -3731,15 +2908,6 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 
 }
 
-/**
- *  @brief                      Handle_DelAllRxBASessions
- *  @details            Delete all Rx BA sessions
- *  @param[in]          tstrHostIFSetMulti* strHostIfSetMulti
- *  @return             NONE
- *  @author		Abdelrahman Sobhy
- *  @date			Feb. 2013
- *  @version		9.0
- */
 static s32 Handle_DelAllRxBASessions(struct host_if_drv *hif_drv,
 				     struct ba_session_info *strHostIfBASessionInfo)
 {
@@ -3764,10 +2932,8 @@ static s32 Handle_DelAllRxBASessions(struct host_if_drv *hif_drv,
 	memcpy(ptr, strHostIfBASessionInfo->au8Bssid, ETH_ALEN);
 	ptr += ETH_ALEN;
 	*ptr++ = strHostIfBASessionInfo->u8Ted;
-	/* BA direction = recipent*/
 	*ptr++ = 0;
-	/* Delba Reason */
-	*ptr++ = 32; /* Unspecific QOS reason */
+	*ptr++ = 32;
 
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
@@ -3784,15 +2950,6 @@ static s32 Handle_DelAllRxBASessions(struct host_if_drv *hif_drv,
 
 }
 
-/**
- *  @brief hostIFthread
- *  @details        Main thread to handle message queue requests
- *  @param[in]   void* pvArg
- *  @return         NONE
- *  @author
- *  @date
- *  @version	1.0
- */
 static int hostIFthread(void *pvArg)
 {
 	u32 u32Ret;
@@ -3809,8 +2966,6 @@ static int hostIFthread(void *pvArg)
 			break;
 		}
 
-
-		/*Re-Queue HIF message*/
 		if ((!g_wilc_initialized)) {
 			PRINT_D(GENERIC_DBG, "--WAIT--");
 			usleep_range(200 * 1000, 200 * 1000);
@@ -3871,7 +3026,6 @@ static int hostIFthread(void *pvArg)
 			del_timer(&hif_drv->hScanTimer);
 			PRINT_D(HOSTINF_DBG, "scan completed successfully\n");
 
-			/*Allow chip sleep, only if both interfaces are not connected*/
 			if (!linux_wlan_get_num_conn_ifcs())
 				chip_sleep_manually(INFINITE_SLEEP_TIME);
 
@@ -4011,12 +3165,10 @@ static void TimerCB_Scan(unsigned long arg)
 	void *pvArg = (void *)arg;
 	struct host_if_msg msg;
 
-	/* prepare the Timer Callback message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.drv = pvArg;
 	msg.id = HOST_IF_MSG_SCAN_TIMER_FIRED;
 
-	/* send the message */
 	wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 }
 
@@ -4025,29 +3177,13 @@ static void TimerCB_Connect(unsigned long arg)
 	void *pvArg = (void *)arg;
 	struct host_if_msg msg;
 
-	/* prepare the Timer Callback message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.drv = pvArg;
 	msg.id = HOST_IF_MSG_CONNECT_TIMER_FIRED;
 
-	/* send the message */
 	wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 }
 
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
-/* Check implementation in core adding 9 bytes to the input! */
 s32 host_int_remove_key(struct host_if_drv *hif_drv, const u8 *pu8StaAddress)
 {
 	struct wid strWID;
@@ -4060,20 +3196,6 @@ s32 host_int_remove_key(struct host_if_drv *hif_drv, const u8 *pu8StaAddress)
 	return 0;
 }
 
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
 int host_int_remove_wep_key(struct host_if_drv *hif_drv, u8 index)
 {
 	int result = 0;
@@ -4085,7 +3207,6 @@ int host_int_remove_wep_key(struct host_if_drv *hif_drv, u8 index)
 		return result;
 	}
 
-	/* prepare the Remove Wep Key Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_KEY;
@@ -4094,7 +3215,6 @@ int host_int_remove_wep_key(struct host_if_drv *hif_drv, u8 index)
 	msg.drv = hif_drv;
 	msg.body.key_info.uniHostIFkeyAttr.wep.index = index;
 
-	/* send the message */
 	result = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (result)
 		PRINT_ER("Error in sending message queue : Request to remove WEP key\n");
@@ -4103,18 +3223,6 @@ int host_int_remove_wep_key(struct host_if_drv *hif_drv, u8 index)
 	return result;
 }
 
-/**
- *  @brief              sets WEP default key
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
 s32 host_int_set_WEPDefaultKeyID(struct host_if_drv *hif_drv, u8 u8Index)
 {
 	s32 s32Error = 0;
@@ -4127,7 +3235,6 @@ s32 host_int_set_WEPDefaultKeyID(struct host_if_drv *hif_drv, u8 u8Index)
 		return s32Error;
 	}
 
-	/* prepare the Key Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 
@@ -4139,7 +3246,6 @@ s32 host_int_set_WEPDefaultKeyID(struct host_if_drv *hif_drv, u8 u8Index)
 
 	msg.body.key_info.uniHostIFkeyAttr.wep.index = u8Index;
 
-	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Error in sending message queue : Default key index\n");
@@ -4148,25 +3254,6 @@ s32 host_int_set_WEPDefaultKeyID(struct host_if_drv *hif_drv, u8 u8Index)
 	return s32Error;
 }
 
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
 s32 host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 				 const u8 *pu8WepKey,
 				 u8 u8WepKeylen,
@@ -4182,7 +3269,6 @@ s32 host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 		return s32Error;
 	}
 
-	/* prepare the Key Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 
@@ -4203,7 +3289,6 @@ s32 host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 
 	msg.body.key_info.uniHostIFkeyAttr.wep.index = u8Keyidx;
 
-	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Error in sending message queue :WEP Key\n");
@@ -4213,22 +3298,6 @@ s32 host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 
 }
 
-/**
- *
- *  @brief              host_int_add_wep_key_bss_ap
- *  @details    valid only in BSS AP mode if External Supplicant support is enabled.
- *                              sets WEP key entry into MAC hardware when it receives the
- *
- *                              corresponding request from NDIS.
- *  @param[in,out] handle to the wifi driver
- *
- *
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		mdaftedar
- *  @date		28 FEB 2013
- *  @version		1.0
- */
 s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 				const u8 *pu8WepKey,
 				u8 u8WepKeylen,
@@ -4247,7 +3316,6 @@ s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 		return s32Error;
 	}
 
-	/* prepare the Key Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	if (INFO) {
@@ -4275,7 +3343,7 @@ s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 	msg.body.key_info.uniHostIFkeyAttr.wep.mode = u8mode;
 
 	msg.body.key_info.uniHostIFkeyAttr.wep.auth_type = tenuAuth_type;
-	/* send the message */
+
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 
 	if (s32Error)
@@ -4286,22 +3354,6 @@ s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 
 }
 
-/**
- *  @brief              adds ptk Key
- *  @details
- *  @param[in,out] handle to the wifi driver
- *  @param[in]  message containing PTK Key in the following format
- *|-----------------------------------------------------------------------------|
- *|Station address | Key Length |	Temporal Key | Rx Michael Key |Tx Michael Key |
- *|----------------|------------|--------------|----------------|---------------|
- |	6 bytes		 |	1byte	  |   16 bytes	 |	  8 bytes	  |	   8 bytes	  |
- ||-----------------------------------------------------------------------------|
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
 s32 host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
 		     u8 u8PtkKeylen, const u8 *mac_addr,
 		     const u8 *pu8RxMic, const u8 *pu8TxMic,
@@ -4322,7 +3374,6 @@ s32 host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
 	if (pu8TxMic != NULL)
 		u8KeyLen += TX_MIC_KEY_LEN;
 
-	/* prepare the Key Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 
@@ -4368,32 +3419,16 @@ s32 host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
 	msg.body.key_info.uniHostIFkeyAttr.wpa.pu8macaddr = mac_addr;
 	msg.drv = hif_drv;
 
-	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 
 	if (s32Error)
 		PRINT_ER("Error in sending message queue:  PTK Key\n");
 
-	/* ////////////// */
 	down(&hif_drv->hSemTestKeyBlock);
-	/* /////// */
 
 	return s32Error;
 }
 
-/**
- *  @brief              adds Rx GTk Key
- *  @details
- *  @param[in,out] handle to the wifi driver
- *  @param[in]  pu8RxGtk : contains temporal key | Rx Mic | Tx Mic
- *                              u8GtkKeylen :The total key length
- *
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
 s32 host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
 			u8 u8GtkKeylen,	u8 u8KeyIdx,
 			u32 u32KeyRSClen, const u8 *KeyRSC,
@@ -4409,7 +3444,6 @@ s32 host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
 		PRINT_ER("driver is null\n");
 		return s32Error;
 	}
-	/* prepare the Key Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 
@@ -4462,39 +3496,15 @@ s32 host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
 
 	msg.body.key_info.uniHostIFkeyAttr.wpa.u8seqlen = u32KeyRSClen;
 
-
-
-	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Error in sending message queue:  RX GTK\n");
-	/* ////////////// */
+
 	down(&hif_drv->hSemTestKeyBlock);
-	/* /////// */
 
 	return s32Error;
 }
 
-/**
- *  @brief              host_int_set_pmkid_info
- *  @details    caches the pmkid valid only in BSS STA mode if External Supplicant
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
 s32 host_int_set_pmkid_info(struct host_if_drv *hif_drv, struct host_if_pmkid_attr *pu8PmkidInfoArray)
 {
 	s32 s32Error = 0;
@@ -4508,7 +3518,6 @@ s32 host_int_set_pmkid_info(struct host_if_drv *hif_drv, struct host_if_pmkid_at
 		return s32Error;
 	}
 
-	/* prepare the Key Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_KEY;
@@ -4525,7 +3534,6 @@ s32 host_int_set_pmkid_info(struct host_if_drv *hif_drv, struct host_if_pmkid_at
 			    PMKID_LEN);
 	}
 
-	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER(" Error in sending messagequeue: PMKID Info\n");
@@ -4533,27 +3541,6 @@ s32 host_int_set_pmkid_info(struct host_if_drv *hif_drv, struct host_if_pmkid_at
 	return s32Error;
 }
 
-/**
- *  @brief              gets the cached the pmkid info
- *  @details    valid only in BSS STA mode if External Supplicant
- *                              support is enabled. This Function sets the PMKID in firmware
- *                              when host drivr receives the corresponding request from NDIS.
- *                              The firmware then includes theset PMKID in the appropriate
- *                              management frames
- *  @param[in,out] handle to the wifi driver,
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
 s32 host_int_get_pmkid_info(struct host_if_drv *hif_drv,
 			    u8 *pu8PmkidInfoArray,
 			    u32 u32PmkidInfoLen)
@@ -4568,27 +3555,12 @@ s32 host_int_get_pmkid_info(struct host_if_drv *hif_drv,
 	return 0;
 }
 
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
 s32 host_int_set_RSNAConfigPSKPassPhrase(struct host_if_drv *hif_drv,
 					 u8 *pu8PassPhrase,
 					 u8 u8Psklength)
 {
 	struct wid strWID;
 
-	/*validating psk length*/
 	if ((u8Psklength > 7) && (u8Psklength < 65)) {
 		strWID.id = (u16)WID_11I_PSK;
 		strWID.type = WID_STR;
@@ -4598,30 +3570,18 @@ s32 host_int_set_RSNAConfigPSKPassPhrase(struct host_if_drv *hif_drv,
 
 	return 0;
 }
-/**
- *  @brief              host_int_get_MacAddress
- *  @details	gets mac address
- *  @param[in,out] handle to the wifi driver,
- *
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		mdaftedar
- *  @date		19 April 2012
- *  @version		1.0
- */
+
 s32 host_int_get_MacAddress(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
 
-
-	/* prepare the Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_GET_MAC_ADDRESS;
 	msg.body.get_mac_info.u8MacAddress = pu8MacAddress;
 	msg.drv = hif_drv;
-	/* send the message */
+
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("Failed to send get mac address\n");
@@ -4632,17 +3592,6 @@ s32 host_int_get_MacAddress(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
 	return s32Error;
 }
 
-/**
- *  @brief              host_int_set_MacAddress
- *  @details	sets mac address
- *  @param[in,out] handle to the wifi driver,
- *
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		mabubakr
- *  @date		16 July 2012
- *  @version		1.0
- */
 s32 host_int_set_MacAddress(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
 {
 	s32 s32Error = 0;
@@ -4650,7 +3599,6 @@ s32 host_int_set_MacAddress(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
 
 	PRINT_D(GENERIC_DBG, "mac addr = %x:%x:%x\n", pu8MacAddress[0], pu8MacAddress[1], pu8MacAddress[2]);
 
-	/* prepare setting mac address message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_MAC_ADDRESS;
 	memcpy(msg.body.set_mac_info.u8MacAddress, pu8MacAddress, ETH_ALEN);
@@ -4664,20 +3612,6 @@ s32 host_int_set_MacAddress(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
 
 }
 
-/**
- *  @brief              host_int_get_RSNAConfigPSKPassPhrase
- *  @details    gets the pass phrase:AP/STA mode. This function gets the pass phrase used to
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
 s32 host_int_get_RSNAConfigPSKPassPhrase(struct host_if_drv *hif_drv,
 					 u8 *pu8PassPhrase, u8 u8Psklength)
 {
@@ -4691,21 +3625,6 @@ s32 host_int_get_RSNAConfigPSKPassPhrase(struct host_if_drv *hif_drv,
 	return 0;
 }
 
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
 s32 host_int_set_start_scan_req(struct host_if_drv *hif_drv, u8 scanSource)
 {
 	struct wid strWID;
@@ -4718,22 +3637,6 @@ s32 host_int_set_start_scan_req(struct host_if_drv *hif_drv, u8 scanSource)
 	return 0;
 }
 
-/**
- *  @brief                      host_int_get_start_scan_req
- *  @details            gets a start scan request
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
 s32 host_int_get_start_scan_req(struct host_if_drv *hif_drv, u8 *pu8ScanSource)
 {
 	struct wid strWID;
@@ -4746,17 +3649,6 @@ s32 host_int_get_start_scan_req(struct host_if_drv *hif_drv, u8 *pu8ScanSource)
 	return 0;
 }
 
-/**
- *  @brief                      host_int_set_join_req
- *  @details            sets a join request
- *  @param[in,out] handle to the wifi driver,
- *  @param[in]	Index of the bss descriptor
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
 s32 host_int_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
 			  const u8 *pu8ssid, size_t ssidLen,
 			  const u8 *pu8IEs, size_t IEsLen,
@@ -4784,7 +3676,6 @@ s32 host_int_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
 		return -EFAULT;
 	}
 
-	/* prepare the Connect Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_CONNECT;
@@ -4798,14 +3689,14 @@ s32 host_int_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
 	msg.drv = hif_drv ;
 
 	if (pu8bssid != NULL) {
-		msg.body.con_info.pu8bssid = kmalloc(6, GFP_KERNEL); /* will be deallocated by the receiving thread */
+		msg.body.con_info.pu8bssid = kmalloc(6, GFP_KERNEL);
 		memcpy(msg.body.con_info.pu8bssid,
 			    pu8bssid, 6);
 	}
 
 	if (pu8ssid != NULL) {
 		msg.body.con_info.ssidLen = ssidLen;
-		msg.body.con_info.pu8ssid = kmalloc(ssidLen, GFP_KERNEL); /* will be deallocated by the receiving thread */
+		msg.body.con_info.pu8ssid = kmalloc(ssidLen, GFP_KERNEL);
 		memcpy(msg.body.con_info.pu8ssid,
 
 			    pu8ssid, ssidLen);
@@ -4813,7 +3704,7 @@ s32 host_int_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
 
 	if (pu8IEs != NULL) {
 		msg.body.con_info.IEsLen = IEsLen;
-		msg.body.con_info.pu8IEs = kmalloc(IEsLen, GFP_KERNEL); /* will be deallocated by the receiving thread */
+		msg.body.con_info.pu8IEs = kmalloc(IEsLen, GFP_KERNEL);
 		memcpy(msg.body.con_info.pu8IEs,
 			    pu8IEs, IEsLen);
 	}
@@ -4822,7 +3713,6 @@ s32 host_int_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
 	else
 		PRINT_D(GENERIC_DBG, "Don't set state to 'connecting' as state is %d\n", hif_drv->enuHostIFstate);
 
-	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("Failed to send message queue: Set join request\n");
@@ -4837,18 +3727,6 @@ s32 host_int_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
 	return s32Error;
 }
 
-/**
- *  @brief              Flush a join request parameters to FW, but actual connection
- *  @details    The function is called in situation where WILC is connected to AP and
- *                      required to switch to hybrid FW for P2P connection
- *  @param[in] handle to the wifi driver,
- *  @return     Error code indicating success/failure
- *  @note
- *  @author	Amr Abdel-Moghny
- *  @date		19 DEC 2013
- *  @version	8.0
- */
-
 s32 host_int_flush_join_req(struct host_if_drv *hif_drv)
 {
 	s32 s32Error = 0;
@@ -4869,7 +3747,6 @@ s32 host_int_flush_join_req(struct host_if_drv *hif_drv)
 	msg.id = HOST_IF_MSG_FLUSH_CONNECT;
 	msg.drv = hif_drv;
 
-	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("Failed to send message queue: Flush join request\n");
@@ -4879,17 +3756,6 @@ s32 host_int_flush_join_req(struct host_if_drv *hif_drv)
 	return s32Error;
 }
 
-/**
- *  @brief                      host_int_disconnect
- *  @details            disconnects from the currently associated network
- *  @param[in,out] handle to the wifi driver,
- *  @param[in]	Reason Code of the Disconnection
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
 s32 host_int_disconnect(struct host_if_drv *hif_drv, u16 u16ReasonCode)
 {
 	s32 s32Error = 0;
@@ -4900,34 +3766,20 @@ s32 host_int_disconnect(struct host_if_drv *hif_drv, u16 u16ReasonCode)
 		return -EFAULT;
 	}
 
-	/* prepare the Disconnect Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_DISCONNECT;
 	msg.drv = hif_drv;
 
-	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Failed to send message queue: disconnect\n");
-	/* ////////////// */
+
 	down(&hif_drv->hSemTestDisconnectBlock);
-	/* /////// */
 
 	return s32Error;
 }
 
-/**
- *  @brief              host_int_disconnect_station
- *  @details     disconnects a sta
- *  @param[in,out] handle to the wifi driver,
- *  @param[in]	Association Id of the station to be disconnected
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
 s32 host_int_disconnect_station(struct host_if_drv *hif_drv, u8 assoc_id)
 {
 	struct wid strWID;
@@ -4940,32 +3792,6 @@ s32 host_int_disconnect_station(struct host_if_drv *hif_drv, u8 assoc_id)
 	return 0;
 }
 
-/**
- *  @brief                      host_int_get_assoc_req_info
- *  @details            gets a Association request info
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
 s32 host_int_get_assoc_req_info(struct host_if_drv *hif_drv, u8 *pu8AssocReqInfo,
 					u32 u32AssocReqInfoLen)
 {
@@ -4979,17 +3805,6 @@ s32 host_int_get_assoc_req_info(struct host_if_drv *hif_drv, u8 *pu8AssocReqInfo
 	return 0;
 }
 
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
 s32 host_int_get_assoc_res_info(struct host_if_drv *hif_drv, u8 *pu8AssocRespInfo,
 					u32 u32MaxAssocRespInfoLen, u32 *pu32RcvdAssocRespInfoLen)
 {
@@ -5006,8 +3821,6 @@ s32 host_int_get_assoc_res_info(struct host_if_drv *hif_drv, u8 *pu8AssocRespInf
 	strWID.val = pu8AssocRespInfo;
 	strWID.size = u32MaxAssocRespInfoLen;
 
-
-	/* Sending Configuration packet */
 	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
 	if (s32Error) {
@@ -5021,21 +3834,6 @@ s32 host_int_get_assoc_res_info(struct host_if_drv *hif_drv, u8 *pu8AssocRespInf
 	return s32Error;
 }
 
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
 s32 host_int_get_rx_power_level(struct host_if_drv *hif_drv, u8 *pu8RxPowerLevel,
 					u32 u32RxPowerLevelLen)
 {
@@ -5049,21 +3847,6 @@ s32 host_int_get_rx_power_level(struct host_if_drv *hif_drv, u8 *pu8RxPowerLevel
 	return 0;
 }
 
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
 int host_int_set_mac_chnl_num(struct host_if_drv *hif_drv, u8 channel)
 {
 	int result;
@@ -5074,7 +3857,6 @@ int host_int_set_mac_chnl_num(struct host_if_drv *hif_drv, u8 channel)
 		return -EFAULT;
 	}
 
-	/* prepare the set channel message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_CHANNEL;
 	msg.body.channel_info.u8SetChan = channel;
@@ -5094,9 +3876,6 @@ int host_int_wait_msg_queue_idle(void)
 	int result = 0;
 
 	struct host_if_msg msg;
-
-	/* prepare the set driver handler message */
-
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_Q_IDLE;
 	result = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -5105,7 +3884,6 @@ int host_int_wait_msg_queue_idle(void)
 		result = -EINVAL;
 	}
 
-	/* wait untill MSG Q is empty */
 	down(&hWaitResponse);
 
 	return result;
@@ -5116,9 +3894,6 @@ int host_int_set_wfi_drv_handler(struct host_if_drv *hif_drv)
 	int result = 0;
 
 	struct host_if_msg msg;
-
-	/* prepare the set driver handler message */
-
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_WFIDRV_HANDLER;
 	msg.body.drv.u32Address = get_id_from_handler(hif_drv);
@@ -5138,9 +3913,6 @@ int host_int_set_operation_mode(struct host_if_drv *hif_drv, u32 mode)
 	int result = 0;
 
 	struct host_if_msg msg;
-
-	/* prepare the set driver handler message */
-
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_OPERATION_MODE;
 	msg.body.mode.u32Mode = mode;
@@ -5155,21 +3927,6 @@ int host_int_set_operation_mode(struct host_if_drv *hif_drv, u32 mode)
 	return result;
 }
 
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
 s32 host_int_get_host_chnl_num(struct host_if_drv *hif_drv, u8 *pu8ChNo)
 {
 	s32 s32Error = 0;
@@ -5180,18 +3937,15 @@ s32 host_int_get_host_chnl_num(struct host_if_drv *hif_drv, u8 *pu8ChNo)
 		return -EFAULT;
 	}
 
-	/* prepare the Get Channel Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_GET_CHNL;
 	msg.drv = hif_drv;
 
-	/* send the message */
 	s32Error =	wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc mq send fail\n");
 	down(&hif_drv->hSemGetCHNL);
-	/* gu8Chnl = 11; */
 
 	*pu8ChNo = gu8Chnl;
 
@@ -5200,17 +3954,6 @@ s32 host_int_get_host_chnl_num(struct host_if_drv *hif_drv, u8 *pu8ChNo)
 
 }
 
-/**
- *  @brief              host_int_get_inactive_time
- *  @details
- *  @param[in,out] handle to the wifi driver,
- *                              current sta macaddress, inactive_time
- *  @return
- *  @note
- *  @author
- *  @date
- *  @version		1.0
- */
 s32 host_int_get_inactive_time(struct host_if_drv *hif_drv,
 			       const u8 *mac, u32 *pu32InactiveTime)
 {
@@ -5231,7 +3974,6 @@ s32 host_int_get_inactive_time(struct host_if_drv *hif_drv,
 	msg.id = HOST_IF_MSG_GET_INACTIVETIME;
 	msg.drv = hif_drv;
 
-	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Failed to send get host channel param's message queue ");
@@ -5243,16 +3985,6 @@ s32 host_int_get_inactive_time(struct host_if_drv *hif_drv,
 	return s32Error;
 }
 
-/**
- *  @brief              host_int_test_get_int_wid
- *  @details    Test function for getting wids
- *  @param[in,out] WILC_WFIDrvHandle hWFIDrv, u32* pu32TestMemAddr
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
 s32 host_int_test_get_int_wid(struct host_if_drv *hif_drv, u32 *pu32TestMemAddr)
 {
 
@@ -5271,7 +4003,7 @@ s32 host_int_test_get_int_wid(struct host_if_drv *hif_drv, u32 *pu32TestMemAddr)
 
 	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
-	/*get the value by searching the local copy*/
+
 	if (s32Error) {
 		PRINT_ER("Failed to get wid value\n");
 		return -EINVAL;
@@ -5283,32 +4015,15 @@ s32 host_int_test_get_int_wid(struct host_if_drv *hif_drv, u32 *pu32TestMemAddr)
 	return s32Error;
 }
 
-
-/**
- *  @brief              host_int_get_rssi
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
 s32 host_int_get_rssi(struct host_if_drv *hif_drv, s8 *ps8Rssi)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
-
-	/* prepare the Get RSSI Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_GET_RSSI;
 	msg.drv = hif_drv;
 
-	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("Failed to send get host channel param's message queue ");
@@ -5334,14 +4049,11 @@ s32 host_int_get_link_speed(struct host_if_drv *hif_drv, s8 *ps8lnkspd)
 {
 	struct host_if_msg msg;
 	s32 s32Error = 0;
-
-	/* prepare the Get LINKSPEED Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_GET_LINKSPEED;
 	msg.drv = hif_drv;
 
-	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("Failed to send GET_LINKSPEED to message queue ");
@@ -5367,15 +4079,12 @@ s32 host_int_get_statistics(struct host_if_drv *hif_drv, struct rf_info *pstrSta
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
-
-
-	/* prepare the Get RSSI Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_GET_STATISTICS;
 	msg.body.data = (char *)pstrStatistics;
 	msg.drv = hif_drv;
-	/* send the message */
+
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("Failed to send get host channel param's message queue ");
@@ -5386,23 +4095,6 @@ s32 host_int_get_statistics(struct host_if_drv *hif_drv, struct rf_info *pstrSta
 	return s32Error;
 }
 
-
-/**
- *  @brief              host_int_scan
- *  @details    scans a set of channels
- *  @param[in,out] handle to the wifi driver,
- *  @param[in]	Scan source
- *                              Scan Type	PASSIVE_SCAN = 0,
- *                                                      ACTIVE_SCAN  = 1
- *                              Channels Array
- *                              Channels Array length
- *                              Scan Callback function
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
 s32 host_int_scan(struct host_if_drv *hif_drv, u8 u8ScanSource,
 		  u8 u8ScanType, u8 *pu8ChnlFreqList,
 		  u8 u8ChnlListLen, const u8 *pu8IEs,
@@ -5418,7 +4110,6 @@ s32 host_int_scan(struct host_if_drv *hif_drv, u8 u8ScanSource,
 		return -EFAULT;
 	}
 
-	/* prepare the Scan Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_SCAN;
@@ -5437,16 +4128,15 @@ s32 host_int_scan(struct host_if_drv *hif_drv, u8 u8ScanSource,
 	msg.body.scan_info.pvUserArg = pvUserArg;
 
 	msg.body.scan_info.u8ChnlListLen = u8ChnlListLen;
-	msg.body.scan_info.pu8ChnlFreqList = kmalloc(u8ChnlListLen, GFP_KERNEL);        /* will be deallocated by the receiving thread */
+	msg.body.scan_info.pu8ChnlFreqList = kmalloc(u8ChnlListLen, GFP_KERNEL);
 	memcpy(msg.body.scan_info.pu8ChnlFreqList,
 		    pu8ChnlFreqList, u8ChnlListLen);
 
 	msg.body.scan_info.IEsLen = IEsLen;
-	msg.body.scan_info.pu8IEs = kmalloc(IEsLen, GFP_KERNEL);        /* will be deallocated by the receiving thread */
+	msg.body.scan_info.pu8IEs = kmalloc(IEsLen, GFP_KERNEL);
 	memcpy(msg.body.scan_info.pu8IEs,
 		    pu8IEs, IEsLen);
 
-	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("Error in sending message queue\n");
@@ -5462,17 +4152,7 @@ s32 host_int_scan(struct host_if_drv *hif_drv, u8 u8ScanSource,
 	return s32Error;
 
 }
-/**
- *  @brief                      hif_set_cfg
- *  @details            sets configuration wids values
- *  @param[in,out] handle to the wifi driver,
- *  @param[in]	WID, WID value
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
+
 s32 hif_set_cfg(struct host_if_drv *hif_drv,
 		struct cfg_param_val *pstrCfgParamVal)
 {
@@ -5485,7 +4165,7 @@ s32 hif_set_cfg(struct host_if_drv *hif_drv,
 		PRINT_ER("hif_drv NULL\n");
 		return -EFAULT;
 	}
-	/* prepare the WiphyParams Message */
+
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_CFG_PARAMS;
 	msg.body.cfg_info.cfg_attr_info = *pstrCfgParamVal;
@@ -5497,20 +4177,6 @@ s32 hif_set_cfg(struct host_if_drv *hif_drv,
 
 }
 
-
-/**
- *  @brief              hif_get_cfg
- *  @details    gets configuration wids values
- *  @param[in,out] handle to the wifi driver,
- *                              WID value
- *  @param[in]	WID,
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *
- *  @date		8 March 2012
- *  @version		1.0
- */
 s32 hif_get_cfg(struct host_if_drv *hif_drv, u16 u16WID, u16 *pu16WID_Value)
 {
 	s32 s32Error = 0;
@@ -5606,41 +4272,10 @@ s32 hif_get_cfg(struct host_if_drv *hif_drv, u16 u16WID, u16 *pu16WID_Value)
 
 }
 
-/*****************************************************************************/
-/*							Notification Functions							 */
-/*****************************************************************************/
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
 void host_int_send_join_leave_info_to_host
 	(u16 assocId, u8 *stationAddr, bool joining)
 {
 }
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
 
 static void GetPeriodicRSSI(unsigned long arg)
 {
@@ -5655,13 +4290,11 @@ static void GetPeriodicRSSI(unsigned long arg)
 		s32 s32Error = 0;
 		struct host_if_msg msg;
 
-		/* prepare the Get RSSI Message */
 		memset(&msg, 0, sizeof(struct host_if_msg));
 
 		msg.id = HOST_IF_MSG_GET_RSSI;
 		msg.drv = hif_drv;
 
-		/* send the message */
 		s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 		if (s32Error) {
 			PRINT_ER("Failed to send get host channel param's message queue ");
@@ -5677,15 +4310,7 @@ void host_int_send_network_info_to_host
 	(u8 *macStartAddress, u16 u16RxFrameLen, s8 s8Rssi)
 {
 }
-/**
- *  @brief              host_int_init
- *  @details    host interface initialization function
- *  @param[in,out] handle to the wifi driver,
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
+
 static u32 clients_count;
 
 s32 host_int_init(struct host_if_drv **hif_drv_handler)
@@ -5700,7 +4325,6 @@ s32 host_int_init(struct host_if_drv **hif_drv_handler)
 
 	sema_init(&hWaitResponse, 0);
 
-	/*Allocate host interface private structure*/
 	hif_drv  = kzalloc(sizeof(struct host_if_drv), GFP_KERNEL);
 	if (!hif_drv) {
 		result = -ENOMEM;
@@ -5753,16 +4377,12 @@ s32 host_int_init(struct host_if_drv **hif_drv_handler)
 
 	setup_timer(&hif_drv->hConnectTimer, TimerCB_Connect, 0);
 
-	/*Remain on channel timer*/
 	setup_timer(&hif_drv->hRemainOnChannel, ListenTimerCB, 0);
 
 	sema_init(&(hif_drv->gtOsCfgValuesSem), 1);
 	down(&hif_drv->gtOsCfgValuesSem);
 
 	hif_drv->enuHostIFstate = HOST_IF_IDLE;
-
-	/*Initialize CFG WIDS Defualt Values*/
-
 	hif_drv->strCfgValues.site_survey_enabled = SITE_SURVEY_OFF;
 	hif_drv->strCfgValues.scan_source = DEFAULT_SCAN;
 	hif_drv->strCfgValues.active_scan_time = ACTIVE_SCAN_TIME;
@@ -5779,7 +4399,7 @@ s32 host_int_init(struct host_if_drv **hif_drv_handler)
 
 	up(&hif_drv->gtOsCfgValuesSem);
 
-	clients_count++; /* increase number of created entities */
+	clients_count++;
 
 	return result;
 
@@ -5793,15 +4413,6 @@ _fail_mq_:
 _fail_:
 	return result;
 }
-/**
- *  @brief              host_int_deinit
- *  @details    host interface initialization function
- *  @param[in,out] handle to the wifi driver,
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
 
 s32 host_int_deinit(struct host_if_drv *hif_drv)
 {
@@ -5809,8 +4420,6 @@ s32 host_int_deinit(struct host_if_drv *hif_drv)
 	struct host_if_msg msg;
 	int ret;
 
-	/*obtain driver handle*/
-
 	if (!hif_drv)	{
 		PRINT_ER("hif_drv = NULL\n");
 		return 0;
@@ -5821,32 +4430,24 @@ s32 host_int_deinit(struct host_if_drv *hif_drv)
 	terminated_handle = hif_drv;
 	PRINT_D(HOSTINF_DBG, "De-initializing host interface for client %d\n", clients_count);
 
-	/*Destroy all timers before acquiring hSemDeinitDrvHandle*/
-	/*to guarantee handling all messages befor proceeding*/
 	if (del_timer_sync(&hif_drv->hScanTimer)) {
 		PRINT_D(HOSTINF_DBG, ">> Scan timer is active\n");
-		/* msleep(HOST_IF_SCAN_TIMEOUT+1000); */
 	}
 
 	if (del_timer_sync(&hif_drv->hConnectTimer)) {
 		PRINT_D(HOSTINF_DBG, ">> Connect timer is active\n");
-		/* msleep(HOST_IF_CONNECT_TIMEOUT+1000); */
 	}
 
 
 	if (del_timer_sync(&g_hPeriodicRSSI)) {
 		PRINT_D(HOSTINF_DBG, ">> Connect timer is active\n");
-		/* msleep(HOST_IF_CONNECT_TIMEOUT+1000); */
 	}
 
-	/*Destroy Remain-onchannel Timer*/
 	del_timer_sync(&hif_drv->hRemainOnChannel);
 
 	host_int_set_wfi_drv_handler(NULL);
 	down(&hSemDeinitDrvHandle);
 
-
-	/*Calling the CFG80211 scan done function with the abort flag set to true*/
 	if (hif_drv->strWILC_UsrScanReq.pfUserScanResult) {
 		hif_drv->strWILC_UsrScanReq.pfUserScanResult(SCAN_EVENT_ABORTED, NULL,
 								hif_drv->strWILC_UsrScanReq.u32UserScanPvoid, NULL);
@@ -5863,7 +4464,6 @@ s32 host_int_deinit(struct host_if_drv *hif_drv)
 	if (clients_count == 1)	{
 		if (del_timer_sync(&g_hPeriodicRSSI)) {
 			PRINT_D(HOSTINF_DBG, ">> Connect timer is active\n");
-			/* msleep(HOST_IF_CONNECT_TIMEOUT+1000); */
 		}
 		msg.id = HOST_IF_MSG_EXIT;
 		msg.drv = hif_drv;
@@ -5880,32 +4480,18 @@ s32 host_int_deinit(struct host_if_drv *hif_drv)
 
 	down(&(hif_drv->gtOsCfgValuesSem));
 
-	/*Setting the gloabl driver handler with NULL*/
-	/* gWFiDrvHandle = NULL; */
 	ret = remove_handler_in_list(hif_drv);
 	if (ret)
 		s32Error = -ENOENT;
 
 	kfree(hif_drv);
 
-	clients_count--; /* Decrease number of created entities */
+	clients_count--;
 	terminated_handle = NULL;
 	up(&hSemHostIntDeinit);
 	return s32Error;
 }
 
-
-/**
- *  @brief              NetworkInfoReceived
- *  @details    function to to be called when network info packet is received
- *  @param[in]	pu8Buffer the received packet
- *  @param[in]   u32Length  length of the received packet
- *  @return             none
- *  @note
- *  @author
- *  @date		1 Mar 2012
- *  @version		1.0
- */
 void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 {
 	s32 s32Error = 0;
@@ -5924,34 +4510,21 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 		return;
 	}
 
-	/* prepare the Asynchronous Network Info message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_RCVD_NTWRK_INFO;
 	msg.drv = hif_drv;
 
 	msg.body.net_info.u32Length = u32Length;
-	msg.body.net_info.pu8Buffer = kmalloc(u32Length, GFP_KERNEL); /* will be deallocated by the receiving thread */
+	msg.body.net_info.pu8Buffer = kmalloc(u32Length, GFP_KERNEL);
 	memcpy(msg.body.net_info.pu8Buffer,
 		    pu8Buffer, u32Length);
 
-	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Error in sending network info message queue message parameters: Error(%d)\n", s32Error);
 }
 
-/**
- *  @brief              GnrlAsyncInfoReceived
- *  @details    function to be called when general Asynchronous info packet is received
- *  @param[in]	pu8Buffer the received packet
- *  @param[in]   u32Length  length of the received packet
- *  @return             none
- *  @note
- *  @author
- *  @date		15 Mar 2012
- *  @version		1.0
- */
 void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 {
 	s32 s32Error = 0;
@@ -5973,13 +4546,11 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	}
 
 	if (!hif_drv->strWILC_UsrConnReq.pfUserConnectResult) {
-		/* received mac status is not needed when there is no current Connect Request */
 		PRINT_ER("Received mac status is not needed when there is no current Connect Reques\n");
 		up(&hSemHostIntDeinit);
 		return;
 	}
 
-	/* prepare the General Asynchronous Info message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 
@@ -5988,11 +4559,10 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 
 
 	msg.body.async_info.u32Length = u32Length;
-	msg.body.async_info.pu8Buffer = kmalloc(u32Length, GFP_KERNEL); /* will be deallocated by the receiving thread */
+	msg.body.async_info.pu8Buffer = kmalloc(u32Length, GFP_KERNEL);
 	memcpy(msg.body.async_info.pu8Buffer,
 		    pu8Buffer, u32Length);
 
-	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Error in sending message queue asynchronous message info: Error(%d)\n", s32Error);
@@ -6000,15 +4570,6 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	up(&hSemHostIntDeinit);
 }
 
-/**
- *  @brief host_int_ScanCompleteReceived
- *  @details        Setting scan complete received notifcation in message queue
- *  @param[in]     u8* pu8Buffer, u32 u32Length
- *  @return         Error code.
- *  @author
- *  @date
- *  @version	1.0
- */
 void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 {
 	s32 s32Error = 0;
@@ -6025,24 +4586,12 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 	if (!hif_drv || hif_drv == terminated_handle)
 		return;
 
-	/*if there is an ongoing scan request*/
 	if (hif_drv->strWILC_UsrScanReq.pfUserScanResult) {
-		/* prepare theScan Done message */
 		memset(&msg, 0, sizeof(struct host_if_msg));
 
 		msg.id = HOST_IF_MSG_RCVD_SCAN_COMPLETE;
 		msg.drv = hif_drv;
 
-
-		/* will be deallocated by the receiving thread */
-		/*no need to send message body*/
-
-		/*msg.body.strScanComplete.u32Length = u32Length;
-		 * msg.body.strScanComplete.pu8Buffer  = (u8*)WILC_MALLOC(u32Length);
-		 * memcpy(msg.body.strScanComplete.pu8Buffer,
-		 *                        pu8Buffer, u32Length); */
-
-		/* send the message */
 		s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 		if (s32Error)
 			PRINT_ER("Error in sending message queue scan complete parameters: Error(%d)\n", s32Error);
@@ -6053,20 +4602,6 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 
 }
 
-/**
- *  @brief              host_int_remain_on_channel
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
 s32 host_int_remain_on_channel(struct host_if_drv *hif_drv, u32 u32SessionID,
 			       u32 u32duration, u16 chan,
 			       wilc_remain_on_chan_expired RemainOnChanExpired,
@@ -6081,10 +4616,8 @@ s32 host_int_remain_on_channel(struct host_if_drv *hif_drv, u32 u32SessionID,
 		return -EFAULT;
 	}
 
-	/* prepare the remainonchan Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_REMAIN_ON_CHAN;
 	msg.body.remain_on_ch.u16Channel = chan;
 	msg.body.remain_on_ch.pRemainOnChanExpired = RemainOnChanExpired;
@@ -6101,20 +4634,6 @@ s32 host_int_remain_on_channel(struct host_if_drv *hif_drv, u32 u32SessionID,
 	return s32Error;
 }
 
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
 s32 host_int_ListenStateExpired(struct host_if_drv *hif_drv, u32 u32SessionID)
 {
 	s32 s32Error = 0;
@@ -6125,10 +4644,8 @@ s32 host_int_ListenStateExpired(struct host_if_drv *hif_drv, u32 u32SessionID)
 		return -EFAULT;
 	}
 
-	/*Stopping remain-on-channel timer*/
 	del_timer(&hif_drv->hRemainOnChannel);
 
-	/* prepare the timer fire Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_LISTEN_TIMER_FIRED;
 	msg.drv = hif_drv;
@@ -6141,14 +4658,6 @@ s32 host_int_ListenStateExpired(struct host_if_drv *hif_drv, u32 u32SessionID)
 	return s32Error;
 }
 
-/**
- *  @brief              host_int_frame_register
- *  @details
- *  @param[in]          Handle to wifi driver
- *  @return             Error code.
- *  @author
- *  @date
- *  @version		1.0*/
 s32 host_int_frame_register(struct host_if_drv *hif_drv, u16 u16FrameType, bool bReg)
 {
 	s32 s32Error = 0;
@@ -6161,7 +4670,6 @@ s32 host_int_frame_register(struct host_if_drv *hif_drv, u16 u16FrameType, bool
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_REGISTER_FRAME;
 	switch (u16FrameType) {
 	case ACTION:
@@ -6191,17 +4699,6 @@ s32 host_int_frame_register(struct host_if_drv *hif_drv, u16 u16FrameType, bool
 
 }
 
-/**
- *  @brief host_int_add_beacon
- *  @details       Setting add beacon params in message queue
- *  @param[in]    WILC_WFIDrvHandle hWFIDrv, u32 u32Interval,
- *                         u32 u32DTIMPeriod,u32 u32HeadLen, u8* pu8Head,
- *                         u32 u32TailLen, u8* pu8Tail
- *  @return         Error code.
- *  @author
- *  @date
- *  @version	1.0
- */
 s32 host_int_add_beacon(struct host_if_drv *hif_drv, u32 u32Interval,
 			u32 u32DTIMPeriod, u32 u32HeadLen, u8 *pu8Head,
 			u32 u32TailLen, u8 *pu8Tail)
@@ -6219,8 +4716,6 @@ s32 host_int_add_beacon(struct host_if_drv *hif_drv, u32 u32Interval,
 
 	PRINT_D(HOSTINF_DBG, "Setting adding beacon message queue params\n");
 
-
-	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_ADD_BEACON;
 	msg.drv = hif_drv;
 	pstrSetBeaconParam->u32Interval = u32Interval;
@@ -6262,16 +4757,6 @@ ERRORHANDLER:
 
 }
 
-
-/**
- *  @brief host_int_del_beacon
- *  @details       Setting add beacon params in message queue
- *  @param[in]    WILC_WFIDrvHandle hWFIDrv
- *  @return         Error code.
- *  @author
- *  @date
- *  @version	1.0
- */
 s32 host_int_del_beacon(struct host_if_drv *hif_drv)
 {
 	s32 s32Error = 0;
@@ -6282,7 +4767,6 @@ s32 host_int_del_beacon(struct host_if_drv *hif_drv)
 		return -EFAULT;
 	}
 
-	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_DEL_BEACON;
 	msg.drv = hif_drv;
 	PRINT_D(HOSTINF_DBG, "Setting deleting beacon message queue params\n");
@@ -6294,16 +4778,6 @@ s32 host_int_del_beacon(struct host_if_drv *hif_drv)
 	return s32Error;
 }
 
-
-/**
- *  @brief host_int_add_station
- *  @details       Setting add station params in message queue
- *  @param[in]    WILC_WFIDrvHandle hWFIDrv, struct add_sta_param *pstrStaParams
- *  @return         Error code.
- *  @author
- *  @date
- *  @version	1.0
- */
 s32 host_int_add_station(struct host_if_drv *hif_drv,
 			 struct add_sta_param *pstrStaParams)
 {
@@ -6321,8 +4795,6 @@ s32 host_int_add_station(struct host_if_drv *hif_drv,
 
 	PRINT_D(HOSTINF_DBG, "Setting adding station message queue params\n");
 
-
-	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_ADD_STATION;
 	msg.drv = hif_drv;
 
@@ -6344,15 +4816,6 @@ s32 host_int_add_station(struct host_if_drv *hif_drv,
 	return s32Error;
 }
 
-/**
- *  @brief host_int_del_station
- *  @details       Setting delete station params in message queue
- *  @param[in]    WILC_WFIDrvHandle hWFIDrv, u8* pu8MacAddr
- *  @return         Error code.
- *  @author
- *  @date
- *  @version	1.0
- */
 s32 host_int_del_station(struct host_if_drv *hif_drv, const u8 *pu8MacAddr)
 {
 	s32 s32Error = 0;
@@ -6368,9 +4831,6 @@ s32 host_int_del_station(struct host_if_drv *hif_drv, const u8 *pu8MacAddr)
 
 	PRINT_D(HOSTINF_DBG, "Setting deleting station message queue params\n");
 
-
-
-	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_DEL_STATION;
 	msg.drv = hif_drv;
 
@@ -6384,15 +4844,7 @@ s32 host_int_del_station(struct host_if_drv *hif_drv, const u8 *pu8MacAddr)
 		PRINT_ER("wilc_mq_send fail\n");
 	return s32Error;
 }
-/**
- *  @brief      host_int_del_allstation
- *  @details    Setting del station params in message queue
- *  @param[in]  WILC_WFIDrvHandle hWFIDrv, u8 pu8MacAddr[][ETH_ALEN]s
- *  @return        Error code.
- *  @author
- *  @date
- *  @version	1.0
- */
+
 s32 host_int_del_allstation(struct host_if_drv *hif_drv,
 			    u8 pu8MacAddr[][ETH_ALEN])
 {
@@ -6413,11 +4865,9 @@ s32 host_int_del_allstation(struct host_if_drv *hif_drv,
 
 	PRINT_D(HOSTINF_DBG, "Setting deauthenticating station message queue params\n");
 
-	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_DEL_ALL_STA;
 	msg.drv = hif_drv;
 
-	/* Handling situation of deauthenticing all associated stations*/
 	for (i = 0; i < MAX_NUM_STA; i++) {
 		if (memcmp(pu8MacAddr[i], au8Zero_Buff, ETH_ALEN)) {
 			memcpy(pstrDelAllStationMsg->au8Sta_DelAllSta[i], pu8MacAddr[i], ETH_ALEN);
@@ -6444,15 +4894,6 @@ s32 host_int_del_allstation(struct host_if_drv *hif_drv,
 
 }
 
-/**
- *  @brief host_int_edit_station
- *  @details       Setting edit station params in message queue
- *  @param[in]    WILC_WFIDrvHandle hWFIDrv, struct add_sta_param *pstrStaParams
- *  @return         Error code.
- *  @author
- *  @date
- *  @version	1.0
- */
 s32 host_int_edit_station(struct host_if_drv *hif_drv,
 			  struct add_sta_param *pstrStaParams)
 {
@@ -6469,8 +4910,6 @@ s32 host_int_edit_station(struct host_if_drv *hif_drv,
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-
-	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_EDIT_STATION;
 	msg.drv = hif_drv;
 
@@ -6511,8 +4950,6 @@ s32 host_int_set_power_mgmt(struct host_if_drv *hif_drv,
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-
-	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_POWER_MGMT;
 	msg.drv = hif_drv;
 
@@ -6544,8 +4981,6 @@ s32 host_int_setup_multicast_filter(struct host_if_drv *hif_drv,
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-
-	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_SET_MULTICAST_FILTER;
 	msg.drv = hif_drv;
 
@@ -6558,14 +4993,6 @@ s32 host_int_setup_multicast_filter(struct host_if_drv *hif_drv,
 	return s32Error;
 }
 
-/**
- *  @brief              host_int_ParseJoinBssParam
- *  @details            Parse Needed Join Parameters and save it in a new JoinBssParam entry
- *  @param[in]          tstrNetworkInfo* ptstrNetworkInfo
- *  @return
- *  @author		zsalah
- *  @date
- *  @version		1.0**/
 static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 {
 	struct join_bss_param *pNewJoinBssParam = NULL;
@@ -6591,88 +5018,66 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 		pNewJoinBssParam->beacon_period = ptstrNetworkInfo->u16BeaconPeriod;
 		pNewJoinBssParam->cap_info = ptstrNetworkInfo->u16CapInfo;
 		memcpy(pNewJoinBssParam->au8bssid, ptstrNetworkInfo->au8bssid, 6);
-		/*for(i=0; i<6;i++)
-		 *      PRINT_D(HOSTINF_DBG,"%c",pNewJoinBssParam->au8bssid[i]);*/
 		memcpy((u8 *)pNewJoinBssParam->ssid, ptstrNetworkInfo->au8ssid, ptstrNetworkInfo->u8SsidLen + 1);
 		pNewJoinBssParam->ssidLen = ptstrNetworkInfo->u8SsidLen;
 		memset(pNewJoinBssParam->rsn_pcip_policy, 0xFF, 3);
 		memset(pNewJoinBssParam->rsn_auth_policy, 0xFF, 3);
-		/*for(i=0; i<pNewJoinBssParam->ssidLen;i++)
-		 *      PRINT_D(HOSTINF_DBG,"%c",pNewJoinBssParam->ssid[i]);*/
 
-		/* parse supported rates: */
 		while (index < u16IEsLen) {
-			/* supportedRates IE */
 			if (pu8IEs[index] == SUPP_RATES_IE) {
-				/* PRINT_D(HOSTINF_DBG, "Supported Rates\n"); */
 				suppRatesNo = pu8IEs[index + 1];
 				pNewJoinBssParam->supp_rates[0] = suppRatesNo;
-				index += 2; /* skipping ID and length bytes; */
+				index += 2;
 
 				for (i = 0; i < suppRatesNo; i++) {
 					pNewJoinBssParam->supp_rates[i + 1] = pu8IEs[index + i];
-					/* PRINT_D(HOSTINF_DBG,"%0x ",pNewJoinBssParam->supp_rates[i+1]); */
 				}
 				index += suppRatesNo;
 				continue;
-			}
-			/* Ext SupportedRates IE */
-			else if (pu8IEs[index] == EXT_SUPP_RATES_IE) {
-				/* PRINT_D(HOSTINF_DBG, "Extended Supported Rates\n"); */
-				/* checking if no of ext. supp and supp rates < max limit */
+			} else if (pu8IEs[index] == EXT_SUPP_RATES_IE) {
 				extSuppRatesNo = pu8IEs[index + 1];
 				if (extSuppRatesNo > (MAX_RATES_SUPPORTED - suppRatesNo))
 					pNewJoinBssParam->supp_rates[0] = MAX_RATES_SUPPORTED;
 				else
 					pNewJoinBssParam->supp_rates[0] += extSuppRatesNo;
 				index += 2;
-				/* pNewJoinBssParam.supp_rates[0] contains now old number not the ext. no */
 				for (i = 0; i < (pNewJoinBssParam->supp_rates[0] - suppRatesNo); i++) {
 					pNewJoinBssParam->supp_rates[suppRatesNo + i + 1] = pu8IEs[index + i];
-					/* PRINT_D(HOSTINF_DBG,"%0x ",pNewJoinBssParam->supp_rates[suppRatesNo+i+1]); */
 				}
 				index += extSuppRatesNo;
 				continue;
-			}
-			/* HT Cap. IE */
-			else if (pu8IEs[index] == HT_CAPABILITY_IE) {
-				/* if IE found set the flag */
+			} else if (pu8IEs[index] == HT_CAPABILITY_IE) {
 				pNewJoinBssParam->ht_capable = true;
-				index += pu8IEs[index + 1] + 2; /* ID,Length bytes and IE body */
-				/* PRINT_D(HOSTINF_DBG,"HT_CAPABALE\n"); */
+				index += pu8IEs[index + 1] + 2;
 				continue;
-			} else if ((pu8IEs[index] == WMM_IE) && /* WMM Element ID */
+			} else if ((pu8IEs[index] == WMM_IE) &&
 				   (pu8IEs[index + 2] == 0x00) && (pu8IEs[index + 3] == 0x50) &&
-				   (pu8IEs[index + 4] == 0xF2) && /* OUI */
-				   (pu8IEs[index + 5] == 0x02) && /* OUI Type     */
-				   ((pu8IEs[index + 6] == 0x00) || (pu8IEs[index + 6] == 0x01)) && /* OUI Sub Type */
+				   (pu8IEs[index + 4] == 0xF2) &&
+				   (pu8IEs[index + 5] == 0x02) &&
+				   ((pu8IEs[index + 6] == 0x00) || (pu8IEs[index + 6] == 0x01)) &&
 				   (pu8IEs[index + 7] == 0x01)) {
-				/* Presence of WMM Info/Param element indicates WMM capability */
 				pNewJoinBssParam->wmm_cap = true;
 
-				/* Check if Bit 7 is set indicating U-APSD capability */
 				if (pu8IEs[index + 8] & BIT(7))
 					pNewJoinBssParam->uapsd_cap = true;
 				index += pu8IEs[index + 1] + 2;
 				continue;
-			}
-			else if ((pu8IEs[index] == P2P_IE) && /* P2P Element ID */
+			} else if ((pu8IEs[index] == P2P_IE) &&
 				 (pu8IEs[index + 2] == 0x50) && (pu8IEs[index + 3] == 0x6f) &&
-				 (pu8IEs[index + 4] == 0x9a) && /* OUI */
-				 (pu8IEs[index + 5] == 0x09) && (pu8IEs[index + 6] == 0x0c)) { /* OUI Type     */
+				 (pu8IEs[index + 4] == 0x9a) &&
+				 (pu8IEs[index + 5] == 0x09) && (pu8IEs[index + 6] == 0x0c)) {
 				u16 u16P2P_count;
 
 				pNewJoinBssParam->tsf = ptstrNetworkInfo->u32Tsf;
 				pNewJoinBssParam->u8NoaEnbaled = 1;
 				pNewJoinBssParam->u8Index = pu8IEs[index + 9];
 
-				/* Check if Bit 7 is set indicating Opss capability */
 				if (pu8IEs[index + 10] & BIT(7)) {
 					pNewJoinBssParam->u8OppEnable = 1;
 					pNewJoinBssParam->u8CtWindow = pu8IEs[index + 10];
 				} else
 					pNewJoinBssParam->u8OppEnable = 0;
-				/* HOSTINF_DBG */
+
 				PRINT_D(GENERIC_DBG, "P2P Dump\n");
 				for (i = 0; i < pu8IEs[index + 7]; i++)
 					PRINT_D(GENERIC_DBG, " %x\n", pu8IEs[index + 9 + i]);
@@ -6691,73 +5096,54 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 				index += pu8IEs[index + 1] + 2;
 				continue;
 
-			}
-			else if ((pu8IEs[index] == RSN_IE) ||
+			} else if ((pu8IEs[index] == RSN_IE) ||
 				 ((pu8IEs[index] == WPA_IE) && (pu8IEs[index + 2] == 0x00) &&
 				  (pu8IEs[index + 3] == 0x50) && (pu8IEs[index + 4] == 0xF2) &&
 				  (pu8IEs[index + 5] == 0x01)))	{
 				u16 rsnIndex = index;
-				/*PRINT_D(HOSTINF_DBG,"RSN IE Length:%d\n",pu8IEs[rsnIndex+1]);
-				 * for(i=0; i<pu8IEs[rsnIndex+1]; i++)
-				 * {
-				 *      PRINT_D(HOSTINF_DBG,"%0x ",pu8IEs[rsnIndex+2+i]);
-				 * }*/
+
 				if (pu8IEs[rsnIndex] == RSN_IE)	{
 					pNewJoinBssParam->mode_802_11i = 2;
-					/* PRINT_D(HOSTINF_DBG,"\nRSN_IE\n"); */
-				} else { /* check if rsn was previously parsed */
+				} else {
 					if (pNewJoinBssParam->mode_802_11i == 0)
 						pNewJoinBssParam->mode_802_11i = 1;
-					/* PRINT_D(HOSTINF_DBG,"\nWPA_IE\n"); */
 					rsnIndex += 4;
 				}
-				rsnIndex += 7; /* skipping id, length, version(2B) and first 3 bytes of gcipher */
+
+				rsnIndex += 7;
 				pNewJoinBssParam->rsn_grp_policy = pu8IEs[rsnIndex];
 				rsnIndex++;
-				/* PRINT_D(HOSTINF_DBG,"Group Policy: %0x\n",pNewJoinBssParam->rsn_grp_policy); */
-				/* initialize policies with invalid values */
-
-				jumpOffset = pu8IEs[rsnIndex] * 4; /* total no.of bytes of pcipher field (count*4) */
-
-				/*parsing pairwise cipher*/
-
-				/* saving 3 pcipher max. */
+				jumpOffset = pu8IEs[rsnIndex] * 4;
 				pcipherCount = (pu8IEs[rsnIndex] > 3) ? 3 : pu8IEs[rsnIndex];
-				rsnIndex += 2; /* jump 2 bytes of pcipher count */
+				rsnIndex += 2;
 
-				/* PRINT_D(HOSTINF_DBG,"\npcipher:%d\n",pcipherCount); */
 				for (i = pcipherTotalCount, j = 0; i < pcipherCount + pcipherTotalCount && i < 3; i++, j++) {
-					/* each count corresponds to 4 bytes, only last byte is saved */
 					pNewJoinBssParam->rsn_pcip_policy[i] = pu8IEs[rsnIndex + ((j + 1) * 4) - 1];
-					/* PRINT_D(HOSTINF_DBG,"PAIR policy = [%0x,%0x]\n",pNewJoinBssParam->rsn_pcip_policy[i],i); */
 				}
 				pcipherTotalCount += pcipherCount;
 				rsnIndex += jumpOffset;
 
 				jumpOffset = pu8IEs[rsnIndex] * 4;
 
-				/*parsing AKM suite (auth_policy)*/
-				/* saving 3 auth policies max. */
 				authCount = (pu8IEs[rsnIndex] > 3) ? 3 : pu8IEs[rsnIndex];
-				rsnIndex += 2; /* jump 2 bytes of pcipher count */
+				rsnIndex += 2;
 
 				for (i = authTotalCount, j = 0; i < authTotalCount + authCount; i++, j++) {
-					/* each count corresponds to 4 bytes, only last byte is saved */
 					pNewJoinBssParam->rsn_auth_policy[i] = pu8IEs[rsnIndex + ((j + 1) * 4) - 1];
 				}
 				authTotalCount += authCount;
 				rsnIndex += jumpOffset;
-				/*pasring rsn cap. only if rsn IE*/
+
 				if (pu8IEs[index] == RSN_IE) {
 					pNewJoinBssParam->rsn_cap[0] = pu8IEs[rsnIndex];
 					pNewJoinBssParam->rsn_cap[1] = pu8IEs[rsnIndex + 1];
 					rsnIndex += 2;
 				}
 				pNewJoinBssParam->rsn_found = true;
-				index += pu8IEs[index + 1] + 2; /* ID,Length bytes and IE body */
+				index += pu8IEs[index + 1] + 2;
 				continue;
 			} else
-				index += pu8IEs[index + 1] + 2;  /* ID,Length bytes and IE body */
+				index += pu8IEs[index + 1] + 2;
 
 		}
 
@@ -6789,7 +5175,6 @@ s32 host_int_delBASession(struct host_if_drv *hif_drv, char *pBSSID, char TID)
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_DEL_BA_SESSION;
 
 	memcpy(pBASessionInfo->au8Bssid, pBSSID, ETH_ALEN);
@@ -6820,7 +5205,6 @@ s32 host_int_del_All_Rx_BASession(struct host_if_drv *hif_drv,
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_DEL_ALL_RX_BA_SESSIONS;
 
 	memcpy(pBASessionInfo->au8Bssid, pBSSID, ETH_ALEN);
@@ -6836,20 +5220,11 @@ s32 host_int_del_All_Rx_BASession(struct host_if_drv *hif_drv,
 	return s32Error;
 }
 
-/**
- *  @brief              host_int_setup_ipaddress
- *  @details            setup IP in firmware
- *  @param[in]          Handle to wifi driver
- *  @return             Error code.
- *  @author		Abdelrahman Sobhy
- *  @date
- *  @version		1.0*/
 s32 host_int_setup_ipaddress(struct host_if_drv *hif_drv, u8 *u16ipadd, u8 idx)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
 
-	/* TODO: Enable This feature on softap firmware */
 	return 0;
 
 	if (!hif_drv) {
@@ -6859,7 +5234,6 @@ s32 host_int_setup_ipaddress(struct host_if_drv *hif_drv, u8 *u16ipadd, u8 idx)
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_SET_IPADDRESS;
 
 	msg.body.ip_info.au8IPAddr = u16ipadd;
@@ -6875,14 +5249,6 @@ s32 host_int_setup_ipaddress(struct host_if_drv *hif_drv, u8 *u16ipadd, u8 idx)
 
 }
 
-/**
- *  @brief              host_int_get_ipaddress
- *  @details            Get IP from firmware
- *  @param[in]          Handle to wifi driver
- *  @return             Error code.
- *  @author		Abdelrahman Sobhy
- *  @date
- *  @version		1.0*/
 s32 host_int_get_ipaddress(struct host_if_drv *hif_drv, u8 *u16ipadd, u8 idx)
 {
 	s32 s32Error = 0;
@@ -6895,7 +5261,6 @@ s32 host_int_get_ipaddress(struct host_if_drv *hif_drv, u8 *u16ipadd, u8 idx)
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_GET_IPADDRESS;
 
 	msg.body.ip_info.au8IPAddr = u16ipadd;
-- 
1.9.1

