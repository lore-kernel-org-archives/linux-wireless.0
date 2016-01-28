Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:12056 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbcA1HQI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 02:16:08 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 01/12] staging: wilc1000: coreconfigurator.c : remove over-commenting
Date: Thu, 28 Jan 2016 16:13:35 +0900
Message-ID: <1453965226-6158-1-git-send-email-leo.kim@atmel.com> (sfid-20160128_081613_824380_30717CEE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are over-commenting in the coreconfigurator.c file and most of them
are not helpful to explain what the code does and generate 80 ending
line over warnings. So, all of comments are removed in this patch and the
comments will later be added if necessary with the preferred Linux style.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 141 +---------------------------
 1 file changed, 1 insertion(+), 140 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index d101393..37d40bb 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -1,13 +1,3 @@
-
-/*!
- *  @file	coreconfigurator.c
- *  @brief
- *  @author
- *  @sa		coreconfigurator.h
- *  @date	1 Mar 2012
- *  @version	1.0
- */
-
 #include "coreconfigurator.h"
 #include "wilc_wlan_if.h"
 #include "wilc_wlan.h"
@@ -16,7 +6,6 @@
 #define TAG_PARAM_OFFSET	(MAC_HDR_LEN + TIME_STAMP_LEN + \
 							BEACON_INTERVAL_LEN + CAP_INFO_LEN)
 
-/* Basic Frame Type Codes (2-bit) */
 enum basic_frame_type {
 	FRAME_TYPE_CONTROL     = 0x04,
 	FRAME_TYPE_DATA        = 0x08,
@@ -25,7 +14,6 @@ enum basic_frame_type {
 	FRAME_TYPE_FORCE_32BIT = 0xFFFFFFFF
 };
 
-/* Frame Type and Subtype Codes (6-bit) */
 enum sub_frame_type {
 	ASSOC_REQ             = 0x00,
 	ASSOC_RSP             = 0x10,
@@ -65,7 +53,6 @@ enum sub_frame_type {
 	FRAME_SUBTYPE_FORCE_32BIT  = 0xFFFFFFFF
 };
 
-/* Element ID  of various Information Elements */
 enum info_element_id {
 	ISSID               = 0,   /* Service Set Identifier         */
 	ISUPRATES           = 1,   /* Supported Rates                */
@@ -109,8 +96,6 @@ enum info_element_id {
 	INFOELEM_ID_FORCE_32BIT  = 0xFFFFFFFF
 };
 
-/* This function extracts the beacon period field from the beacon or probe   */
-/* response frame.                                                           */
 static inline u16 get_beacon_period(u8 *data)
 {
 	u16 bcn_per;
@@ -147,54 +132,36 @@ static inline u32 get_beacon_timestamp_hi(u8 *data)
 	return time_stamp;
 }
 
-/* This function extracts the 'frame type and sub type' bits from the MAC    */
-/* header of the input frame.                                                */
-/* Returns the value in the LSB of the returned value.                       */
 static inline enum sub_frame_type get_sub_type(u8 *header)
 {
 	return ((enum sub_frame_type)(header[0] & 0xFC));
 }
 
-/* This function extracts the 'to ds' bit from the MAC header of the input   */
-/* frame.                                                                    */
-/* Returns the value in the LSB of the returned value.                       */
 static inline u8 get_to_ds(u8 *header)
 {
 	return (header[1] & 0x01);
 }
 
-/* This function extracts the 'from ds' bit from the MAC header of the input */
-/* frame.                                                                    */
-/* Returns the value in the LSB of the returned value.                       */
 static inline u8 get_from_ds(u8 *header)
 {
 	return ((header[1] & 0x02) >> 1);
 }
 
-/* This function extracts the MAC Address in 'address1' field of the MAC     */
-/* header and updates the MAC Address in the allocated 'addr' variable.      */
 static inline void get_address1(u8 *pu8msa, u8 *addr)
 {
 	memcpy(addr, pu8msa + 4, 6);
 }
 
-/* This function extracts the MAC Address in 'address2' field of the MAC     */
-/* header and updates the MAC Address in the allocated 'addr' variable.      */
 static inline void get_address2(u8 *pu8msa, u8 *addr)
 {
 	memcpy(addr, pu8msa + 10, 6);
 }
 
-/* This function extracts the MAC Address in 'address3' field of the MAC     */
-/* header and updates the MAC Address in the allocated 'addr' variable.      */
 static inline void get_address3(u8 *pu8msa, u8 *addr)
 {
 	memcpy(addr, pu8msa + 16, 6);
 }
 
-/* This function extracts the BSSID from the incoming WLAN packet based on   */
-/* the 'from ds' bit, and updates the MAC Address in the allocated 'addr'    */
-/* variable.                                                                 */
 static inline void get_BSSID(u8 *data, u8 *bssid)
 {
 	if (get_from_ds(data) == 1)
@@ -205,7 +172,6 @@ static inline void get_BSSID(u8 *data, u8 *bssid)
 		get_address3(data, bssid);
 }
 
-/* This function extracts the SSID from a beacon/probe response frame        */
 static inline void get_ssid(u8 *data, u8 *ssid, u8 *p_ssid_len)
 {
 	u8 len = 0;
@@ -217,8 +183,6 @@ static inline void get_ssid(u8 *data, u8 *ssid, u8 *p_ssid_len)
 	j   = MAC_HDR_LEN + TIME_STAMP_LEN + BEACON_INTERVAL_LEN +
 		CAP_INFO_LEN + 2;
 
-	/* If the SSID length field is set wrongly to a value greater than the   */
-	/* allowed maximum SSID length limit, reset the length to 0              */
 	if (len >= MAX_SSID_LEN)
 		len = 0;
 
@@ -230,8 +194,6 @@ static inline void get_ssid(u8 *data, u8 *ssid, u8 *p_ssid_len)
 	*p_ssid_len = len;
 }
 
-/* This function extracts the capability info field from the beacon or probe */
-/* response frame.                                                           */
 static inline u16 get_cap_info(u8 *data)
 {
 	u16 cap_info = 0;
@@ -240,8 +202,6 @@ static inline u16 get_cap_info(u8 *data)
 
 	st = get_sub_type(data);
 
-	/* Location of the Capability field is different for Beacon and */
-	/* Association frames.                                          */
 	if ((st == BEACON) || (st == PROBE_RSP))
 		index += TIME_STAMP_LEN + BEACON_INTERVAL_LEN;
 
@@ -251,8 +211,6 @@ static inline u16 get_cap_info(u8 *data)
 	return cap_info;
 }
 
-/* This function extracts the capability info field from the Association */
-/* response frame.                                                                       */
 static inline u16 get_assoc_resp_cap_info(u8 *data)
 {
 	u16 cap_info;
@@ -263,8 +221,6 @@ static inline u16 get_assoc_resp_cap_info(u8 *data)
 	return cap_info;
 }
 
-/* This function extracts the association status code from the incoming       */
-/* association response frame and returns association status code            */
 static inline u16 get_asoc_status(u8 *data)
 {
 	u16 asoc_status;
@@ -275,8 +231,6 @@ static inline u16 get_asoc_status(u8 *data)
 	return asoc_status;
 }
 
-/* This function extracts association ID from the incoming association       */
-/* response frame							                                     */
 static inline u16 get_asoc_id(u8 *data)
 {
 	u16 asoc_id;
@@ -291,19 +245,8 @@ static u8 *get_tim_elm(u8 *pu8msa, u16 u16RxLen, u16 u16TagParamOffset)
 {
 	u16 u16index;
 
-	/*************************************************************************/
-	/*                       Beacon Frame - Frame Body                       */
-	/* --------------------------------------------------------------------- */
-	/* |Timestamp |BeaconInt |CapInfo |SSID |SupRates |DSParSet |TIM elm   | */
-	/* --------------------------------------------------------------------- */
-	/* |8         |2         |2       |2-34 |3-10     |3        |4-256     | */
-	/* --------------------------------------------------------------------- */
-	/*                                                                       */
-	/*************************************************************************/
-
 	u16index = u16TagParamOffset;
 
-	/* Search for the TIM Element Field and return if the element is found */
 	while (u16index < (u16RxLen - FCS_LEN)) {
 		if (pu8msa[u16index] == ITIM)
 			return &pu8msa[u16index];
@@ -313,8 +256,6 @@ static u8 *get_tim_elm(u8 *pu8msa, u16 u16RxLen, u16 u16TagParamOffset)
 	return NULL;
 }
 
-/* This function gets the current channel information from
- * the 802.11n beacon/probe response frame */
 static u8 get_current_channel_802_11n(u8 *pu8msa, u16 u16RxLen)
 {
 	u16 index;
@@ -323,27 +264,12 @@ static u8 get_current_channel_802_11n(u8 *pu8msa, u16 u16RxLen)
 	while (index < (u16RxLen - FCS_LEN)) {
 		if (pu8msa[index] == IDSPARMS)
 			return pu8msa[index + 2];
-		/* Increment index by length information and header */
 		index += pu8msa[index + 1] + IE_HDR_LEN;
 	}
 
-	/* Return current channel information from the MIB, if beacon/probe  */
-	/* response frame does not contain the DS parameter set IE           */
-	/* return (mget_CurrentChannel() + 1); */
-	return 0;  /* no MIB here */
+	return 0;
 }
 
-/**
- *  @brief                      parses the received 'N' message
- *  @details
- *  @param[in]  pu8MsgBuffer The message to be parsed
- *  @param[out]         ppstrNetworkInfo pointer to pointer to the structure containing the parsed Network Info
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		mabubakr
- *  @date			1 Mar 2012
- *  @version		1.0
- */
 s32 wilc_parse_network_info(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
 {
 	tstrNetworkInfo *pstrNetworkInfo = NULL;
@@ -357,28 +283,17 @@ s32 wilc_parse_network_info(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo
 
 	u8MsgType = pu8MsgBuffer[0];
 
-	/* Check whether the received message type is 'N' */
 	if ('N' != u8MsgType) {
 		PRINT_ER("Received Message format incorrect.\n");
 		return -EFAULT;
 	}
 
-	/* Extract message ID */
 	u8MsgID = pu8MsgBuffer[1];
-
-	/* Extract message Length */
 	u16MsgLen = MAKE_WORD16(pu8MsgBuffer[2], pu8MsgBuffer[3]);
-
-	/* Extract WID ID */
 	u16WidID = MAKE_WORD16(pu8MsgBuffer[4], pu8MsgBuffer[5]);
-
-	/* Extract WID Length */
 	u16WidLen = MAKE_WORD16(pu8MsgBuffer[6], pu8MsgBuffer[7]);
-
-	/* Assign a pointer to the WID value */
 	pu8WidVal  = &pu8MsgBuffer[8];
 
-	/* parse the WID value of the WID "WID_NEWORK_INFO" */
 	{
 		u8  *pu8msa = NULL;
 		u16 u16RxLen = 0;
@@ -395,46 +310,30 @@ s32 wilc_parse_network_info(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo
 
 		pstrNetworkInfo->s8rssi = pu8WidVal[0];
 
-		/* Assign a pointer to msa "Mac Header Start Address" */
 		pu8msa = &pu8WidVal[1];
 
 		u16RxLen = u16WidLen - 1;
-
-		/* parse msa*/
-
-		/* Get the cap_info */
 		pstrNetworkInfo->u16CapInfo = get_cap_info(pu8msa);
-		/* Get time-stamp [Low only 32 bit] */
 		pstrNetworkInfo->u32Tsf = get_beacon_timestamp_lo(pu8msa);
 		PRINT_D(CORECONFIG_DBG, "TSF :%x\n", pstrNetworkInfo->u32Tsf);
 
-		/* Get full time-stamp [Low and High 64 bit] */
 		u32Tsf_Lo = get_beacon_timestamp_lo(pu8msa);
 		u32Tsf_Hi = get_beacon_timestamp_hi(pu8msa);
 
 		pstrNetworkInfo->u64Tsf = u32Tsf_Lo | ((u64)u32Tsf_Hi << 32);
 
-		/* Get SSID */
 		get_ssid(pu8msa, pstrNetworkInfo->au8ssid, &pstrNetworkInfo->u8SsidLen);
-
-		/* Get BSSID */
 		get_BSSID(pu8msa, pstrNetworkInfo->au8bssid);
 
-		/*
-		 * Extract current channel information from
-		 * the beacon/probe response frame
-		 */
 		pstrNetworkInfo->u8channel = get_current_channel_802_11n(pu8msa,
 							u16RxLen + FCS_LEN);
 
-		/* Get beacon period */
 		u8index = MAC_HDR_LEN + TIME_STAMP_LEN;
 
 		pstrNetworkInfo->u16BeaconPeriod = get_beacon_period(pu8msa + u8index);
 
 		u8index += BEACON_INTERVAL_LEN + CAP_INFO_LEN;
 
-		/* Get DTIM Period */
 		pu8TimElm = get_tim_elm(pu8msa, u16RxLen + FCS_LEN, u8index);
 		if (pu8TimElm)
 			pstrNetworkInfo->u8DtimPeriod = pu8TimElm[3];
@@ -456,16 +355,6 @@ s32 wilc_parse_network_info(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo
 	return 0;
 }
 
-/**
- *  @brief              Deallocates the parsed Network Info
- *  @details
- *  @param[in]  pstrNetworkInfo Network Info to be deallocated
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		mabubakr
- *  @date		1 Mar 2012
- *  @version		1.0
- */
 s32 wilc_dealloc_network_info(tstrNetworkInfo *pstrNetworkInfo)
 {
 	s32 s32Error = 0;
@@ -488,17 +377,6 @@ s32 wilc_dealloc_network_info(tstrNetworkInfo *pstrNetworkInfo)
 	return s32Error;
 }
 
-/**
- *  @brief                      parses the received Association Response frame
- *  @details
- *  @param[in]  pu8Buffer The Association Response frame to be parsed
- *  @param[out]         ppstrConnectRespInfo pointer to pointer to the structure containing the parsed Association Response Info
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		mabubakr
- *  @date			2 Apr 2012
- *  @version		1.0
- */
 s32 wilc_parse_assoc_resp_info(u8 *pu8Buffer, u32 u32BufferLen,
 			       tstrConnectRespInfo **ppstrConnectRespInfo)
 {
@@ -512,20 +390,13 @@ s32 wilc_parse_assoc_resp_info(u8 *pu8Buffer, u32 u32BufferLen,
 	if (!pstrConnectRespInfo)
 		return -ENOMEM;
 
-	/* u16AssocRespLen = pu8Buffer[0]; */
 	u16AssocRespLen = (u16)u32BufferLen;
 
-	/* get the status code */
 	pstrConnectRespInfo->u16ConnectStatus = get_asoc_status(pu8Buffer);
 	if (pstrConnectRespInfo->u16ConnectStatus == SUCCESSFUL_STATUSCODE) {
-
-		/* get the capability */
 		pstrConnectRespInfo->u16capability = get_assoc_resp_cap_info(pu8Buffer);
-
-		/* get the Association ID */
 		pstrConnectRespInfo->u16AssocID = get_asoc_id(pu8Buffer);
 
-		/* get the Information Elements */
 		pu8IEs = &pu8Buffer[CAP_INFO_LEN + STATUS_CODE_LEN + AID_LEN];
 		u16IEsLen = u16AssocRespLen - (CAP_INFO_LEN + STATUS_CODE_LEN + AID_LEN);
 
@@ -541,16 +412,6 @@ s32 wilc_parse_assoc_resp_info(u8 *pu8Buffer, u32 u32BufferLen,
 	return s32Error;
 }
 
-/**
- *  @brief                      Deallocates the parsed Association Response Info
- *  @details
- *  @param[in]  pstrNetworkInfo Network Info to be deallocated
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		mabubakr
- *  @date			2 Apr 2012
- *  @version		1.0
- */
 s32 wilc_dealloc_assoc_resp_info(tstrConnectRespInfo *pstrConnectRespInfo)
 {
 	s32 s32Error = 0;
-- 
1.9.1

