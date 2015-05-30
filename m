Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:32913 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbbE3Uot (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 May 2015 16:44:49 -0400
From: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
To: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
Subject: [PATCH 2/2] staging: wilc1000: Cleanup to coreconfigurator
Date: Sat, 30 May 2015 23:44:19 +0300
Message-Id: <1433018659-25958-2-git-send-email-kholmanskikh.s.s@gmail.com> (sfid-20150530_224515_595317_574BD457)
In-Reply-To: <1433018659-25958-1-git-send-email-kholmanskikh.s.s@gmail.com>
References: <1433018659-25958-1-git-send-email-kholmanskikh.s.s@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixed several syntax/style issues found with checkpatch.pl, plus
aligned structs/enums to follow a common style per struct/enum.

Signed-off-by: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 53 ++++++++++++------------
 drivers/staging/wilc1000/coreconfigurator.h | 64 ++++++++++++++---------------
 2 files changed, 58 insertions(+), 59 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 01625bd..5c6d29f 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -28,7 +28,7 @@
 #define INVALID         255
 #define MAC_ADDR_LEN    6
 #define TAG_PARAM_OFFSET	(MAC_HDR_LEN + TIME_STAMP_LEN + \
-							BEACON_INTERVAL_LEN + CAP_INFO_LEN)
+				 BEACON_INTERVAL_LEN + CAP_INFO_LEN)
 
 /*****************************************************************************/
 /* Function Macros                                                           */
@@ -40,11 +40,12 @@
 /*****************************************************************************/
 
 /* Basic Frame Type Codes (2-bit) */
-typedef enum {FRAME_TYPE_CONTROL = 0x04,
-	      FRAME_TYPE_DATA        = 0x08,
-	      FRAME_TYPE_MANAGEMENT            = 0x00,
-	      FRAME_TYPE_RESERVED              = 0x0C,
-	      FRAME_TYPE_FORCE_32BIT  = 0xFFFFFFFF
+typedef enum {
+	FRAME_TYPE_CONTROL     = 0x04,
+	FRAME_TYPE_DATA        = 0x08,
+	FRAME_TYPE_MANAGEMENT  = 0x00,
+	FRAME_TYPE_RESERVED    = 0x0C,
+	FRAME_TYPE_FORCE_32BIT = 0xFFFFFFFF
 } tenuBasicFrmType;
 
 /* Frame Type and Subtype Codes (6-bit) */
@@ -188,7 +189,7 @@ static tstrWID gastrWIDs[] = {
 	{WID_QOS_ENABLE,                WID_CHAR},
 	{WID_11I_MODE,                  WID_CHAR},
 	{WID_CURRENT_TX_RATE,           WID_CHAR},
-	{WID_LINKSPEED,           WID_CHAR},
+	{WID_LINKSPEED,                 WID_CHAR},
 	{WID_RTS_THRESHOLD,             WID_SHORT},
 	{WID_FRAG_THRESHOLD,            WID_SHORT},
 	{WID_SSID,                      WID_STR},
@@ -223,14 +224,14 @@ static tstrWID gastrWIDs[] = {
 	{WID_MEMORY_ACCESS_32BIT,       WID_INT},
 	{WID_MEMORY_ACCESS_16BIT,       WID_SHORT},
 	{WID_MEMORY_ACCESS_8BIT,        WID_CHAR},
-	{WID_SITE_SURVEY_RESULTS,		WID_STR},
-	{WID_PMKID_INFO,				WID_STR},
-	{WID_ASSOC_RES_INFO,			WID_STR},
-	{WID_MANUFACTURER,				WID_STR}, /* 4 Wids added for the CAPI tool*/
-	{WID_MODEL_NAME,				WID_STR},
-	{WID_MODEL_NUM,					WID_STR},
-	{WID_DEVICE_NAME,				WID_STR},
-	{WID_SSID_PROBE_REQ, WID_STR},
+	{WID_SITE_SURVEY_RESULTS,       WID_STR},
+	{WID_PMKID_INFO,                WID_STR},
+	{WID_ASSOC_RES_INFO,            WID_STR},
+	{WID_MANUFACTURER,              WID_STR}, /* 4 Wids added for the CAPI tool*/
+	{WID_MODEL_NAME,                WID_STR},
+	{WID_MODEL_NUM,                 WID_STR},
+	{WID_DEVICE_NAME,               WID_STR},
+	{WID_SSID_PROBE_REQ,            WID_STR},
 
 #ifdef MAC_802_11N
 	{WID_11N_ENABLE,                WID_CHAR},
@@ -675,7 +676,7 @@ WILC_Sint32 CoreConfiguratorInit(void)
 	tstrWILC_SemaphoreAttrs strSemSendPktAttrs;
 	tstrWILC_SemaphoreAttrs strSemPktRespAttrs;
 
-	PRINT_D(CORECONFIG_DBG, "CoreConfiguratorInit() \n");
+	PRINT_D(CORECONFIG_DBG, "CoreConfiguratorInit()\n");
 
 	WILC_SemaphoreFillDefault(&strSemSendPktAttrs);
 	strSemSendPktAttrs.u32InitCount = 1;
@@ -687,7 +688,7 @@ WILC_Sint32 CoreConfiguratorInit(void)
 
 	gps8ConfigPacket = (WILC_Sint8 *)WILC_MALLOC(MAX_PACKET_BUFF_SIZE);
 	if (gps8ConfigPacket == NULL) {
-		PRINT_ER("failed in gps8ConfigPacket allocation \n");
+		PRINT_ER("failed in gps8ConfigPacket allocation\n");
 		s32Error = WILC_NO_MEM;
 		goto _fail_;
 	}
@@ -718,13 +719,13 @@ WILC_Uint8 *get_tim_elm(WILC_Uint8 *pu8msa, WILC_Uint16 u16RxLen, WILC_Uint16 u1
 	/* Search for the TIM Element Field and return if the element is found */
 	while (u16index < (u16RxLen - FCS_LEN)) {
 		if (pu8msa[u16index] == ITIM) {
-			return(&pu8msa[u16index]);
+			return &pu8msa[u16index];
 		} else {
 			u16index += (IE_HDR_LEN + pu8msa[u16index + 1]);
 		}
 	}
 
-	return(0);
+	return 0;
 }
 
 /* This function gets the current channel information from
@@ -736,7 +737,7 @@ WILC_Uint8 get_current_channel_802_11n(WILC_Uint8 *pu8msa, WILC_Uint16 u16RxLen)
 	index = TAG_PARAM_OFFSET;
 	while (index < (u16RxLen - FCS_LEN)) {
 		if (pu8msa[index] == IDSPARMS)
-			return (pu8msa[index + 2]);
+			return pu8msa[index + 2];
 		else
 			/* Increment index by length information and header */
 			index += pu8msa[index + 1] + IE_HDR_LEN;
@@ -758,7 +759,7 @@ WILC_Uint8 get_current_channel(WILC_Uint8 *pu8msa, WILC_Uint16 u16RxLen)
 #else /* FIVE_GHZ_BAND */
 	/* Extract current channel information from */
 	/* the beacon/probe response frame          */
-	return (get_current_channel_802_11n(pu8msa, u16RxLen));
+	return get_current_channel_802_11n(pu8msa, u16RxLen);
 #endif /* FIVE_GHZ_BAND */
 #else
 	return 0;
@@ -1452,7 +1453,7 @@ void ProcessAdrWid(WILC_Char *pcPacket, WILC_Sint32 *ps32PktLen,
 void ProcessBinWid(WILC_Char *pcPacket, WILC_Sint32 *ps32PktLen,
 		   tstrWID *pstrWID, WILC_Uint8 *pu8val, WILC_Sint32 s32ValueSize)
 {
-	/* WILC_ERROR("processing Binary WIDs is not supported \n"); */
+	/* WILC_ERROR("processing Binary WIDs is not supported\n"); */
 
 	WILC_Uint16 u16MsgLen = 0;
 	WILC_Uint16 idx    = 0;
@@ -1591,7 +1592,7 @@ WILC_Sint32 further_process_response(WILC_Uint8 *resp,
 			WILC_memcpy(pstrWIDresult->ps8WidVal, cfg_str, cfg_len); /* mostafa: no need currently for the extra NULL byte */
 			pstrWIDresult->s32ValueSize = cfg_len;
 		} else {
-			PRINT_ER("allocated WID buffer length is smaller than the received WID Length \n");
+			PRINT_ER("allocated WID buffer length is smaller than the received WID Length\n");
 			retval = -2;
 		}
 
@@ -2035,7 +2036,7 @@ WILC_Sint32 ConfigProvideResponse(WILC_Char *pcRespBuffer, WILC_Sint32 s32RespLe
 		} else {
 			WILC_memcpy(gstrConfigPktInfo.pcRespBuffer, pcRespBuffer, gstrConfigPktInfo.s32MaxRespBuffLen);
 			gstrConfigPktInfo.s32BytesRead = gstrConfigPktInfo.s32MaxRespBuffLen;
-			PRINT_ER("BusProvideResponse() Response greater than the prepared Buffer Size \n");
+			PRINT_ER("BusProvideResponse() Response greater than the prepared Buffer Size\n");
 		}
 
 		WILC_SemaphoreRelease(&SemHandlePktResp, WILC_NULL);
@@ -2084,7 +2085,7 @@ WILC_Sint32 ConfigPktReceived(WILC_Uint8 *pu8RxPacket, WILC_Sint32 s32RxPacketLe
 		break;
 
 	default:
-		PRINT_ER("ConfigPktReceived(): invalid received msg type at the Core Configurator \n");
+		PRINT_ER("ConfigPktReceived(): invalid received msg type at the Core Configurator\n");
 		break;
 	}
 
@@ -2105,7 +2106,7 @@ WILC_Sint32 CoreConfiguratorDeInit(void)
 {
 	WILC_Sint32 s32Error = WILC_SUCCESS;
 
-	PRINT_D(CORECONFIG_DBG, "CoreConfiguratorDeInit() \n");
+	PRINT_D(CORECONFIG_DBG, "CoreConfiguratorDeInit()\n");
 
 
 	WILC_SemaphoreDestroy(&SemHandleSendPkt, WILC_NULL);
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 9cdfa2a..1799717 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -19,9 +19,9 @@
 /*****************************************************************************/
 /* Number of WID Options Supported */
 #define NUM_BASIC_SWITCHES      45
-#define NUM_FHSS_SWITCHES        0
+#define NUM_FHSS_SWITCHES       0
 
-#define NUM_RSSI	5
+#define NUM_RSSI                5
 
 #ifdef MAC_802_11N
 #define NUM_11N_BASIC_SWITCHES  25
@@ -51,14 +51,14 @@ extern WILC_Uint16 g_num_total_switches;
 
 #define MAX_PACKET_BUFF_SIZE 1596
 
-#define MAX_STRING_LEN					256
-#define MAX_SURVEY_RESULT_FRAG_SIZE MAX_STRING_LEN
-#define SURVEY_RESULT_LENGTH		44
-#define MAX_ASSOC_RESP_FRAME_SIZE MAX_STRING_LEN
+#define MAX_STRING_LEN               256
+#define MAX_SURVEY_RESULT_FRAG_SIZE  MAX_STRING_LEN
+#define SURVEY_RESULT_LENGTH         44
+#define MAX_ASSOC_RESP_FRAME_SIZE    MAX_STRING_LEN
 
-#define STATUS_MSG_LEN			12
-#define MAC_CONNECTED			1
-#define MAC_DISCONNECTED		0
+#define STATUS_MSG_LEN               12
+#define MAC_CONNECTED                1
+#define MAC_DISCONNECTED             0
 
 
 
@@ -327,10 +327,10 @@ typedef enum {
 	WID_SUPP_PASSWORD                  = 0x3011,
 	WID_SITE_SURVEY_RESULTS            = 0x3012,
 	WID_RX_POWER_LEVEL                 = 0x3013,
-	WID_MANUFACTURER                   = 0x3026,             /*Added for CAPI tool */
-	WID_MODEL_NAME                                         = 0x3027,             /*Added for CAPI tool */
-	WID_MODEL_NUM                      = 0x3028,             /*Added for CAPI tool */
-	WID_DEVICE_NAME                                        = 0x3029,             /*Added for CAPI tool */
+	WID_MANUFACTURER                   = 0x3026,    /*Added for CAPI tool */
+	WID_MODEL_NAME                     = 0x3027,    /*Added for CAPI tool */
+	WID_MODEL_NUM                      = 0x3028,    /*Added for CAPI tool */
+	WID_DEVICE_NAME                    = 0x3029,    /*Added for CAPI tool */
 
 	WID_ASSOC_RES_INFO                 = 0x3020,
 
@@ -362,9 +362,9 @@ typedef enum {
 	WID_HUT_LOG_STATS                  = 0x4083,
 
 	/*BugID_3746 WID to add IE to be added in next probe request*/
-	WID_INFO_ELEMENT_PROBE	= 0x4085,
+	WID_INFO_ELEMENT_PROBE             = 0x4085,
 	/*BugID_3746 WID to add IE to be added in next associate request*/
-	WID_INFO_ELEMENT_ASSOCIATE	= 0x4086,
+	WID_INFO_ELEMENT_ASSOCIATE         = 0x4086,
 
 	/* Miscellaneous WIDs */
 	WID_ALL                            = 0x7FFE,
@@ -374,22 +374,22 @@ typedef enum {
 
 /* Status Codes for Authentication and Association Frames */
 typedef enum {
-	SUCCESSFUL_STATUSCODE	= 0,
-	UNSPEC_FAIL				  = 1,
-	UNSUP_CAP				  = 10,
-	REASOC_NO_ASOC				  = 11,
-	FAIL_OTHER				  = 12,
-	UNSUPT_ALG				  = 13,
-	AUTH_SEQ_FAIL			  = 14,
-	CHLNG_FAIL				  = 15,
-	AUTH_TIMEOUT			  = 16,
-	AP_FULL					  = 17,
-	UNSUP_RATE				  = 18,
-	SHORT_PREAMBLE_UNSUP	  = 19,
-	PBCC_UNSUP				  = 20,
-	CHANNEL_AGIL_UNSUP	  = 21,
-	SHORT_SLOT_UNSUP		  = 25,
-	OFDM_DSSS_UNSUP			  = 26,
+	SUCCESSFUL_STATUSCODE    = 0,
+	UNSPEC_FAIL              = 1,
+	UNSUP_CAP                = 10,
+	REASOC_NO_ASOC           = 11,
+	FAIL_OTHER               = 12,
+	UNSUPT_ALG               = 13,
+	AUTH_SEQ_FAIL            = 14,
+	CHLNG_FAIL               = 15,
+	AUTH_TIMEOUT             = 16,
+	AP_FULL                  = 17,
+	UNSUP_RATE               = 18,
+	SHORT_PREAMBLE_UNSUP     = 19,
+	PBCC_UNSUP               = 20,
+	CHANNEL_AGIL_UNSUP       = 21,
+	SHORT_SLOT_UNSUP         = 25,
+	OFDM_DSSS_UNSUP          = 26,
 	CONNECT_STS_FORCE_16_BIT = 0xFFFF
 } tenuConnectSts;
 
@@ -398,7 +398,6 @@ typedef struct {
 	tenuWIDtype enuWIDtype;
 	WILC_Sint32 s32ValueSize;
 	WILC_Sint8      *ps8WidVal;
-
 } tstrWID;
 
 typedef struct {
@@ -468,7 +467,6 @@ typedef struct wid_site_survey_reslts {
 	WILC_Uint8 BSSID[6];
 	WILC_Char RxPower;
 	WILC_Uint8 Reserved;
-
 } wid_site_survey_reslts_s;
 #endif
 
-- 
1.9.1

