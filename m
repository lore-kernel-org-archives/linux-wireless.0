Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:34978 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933458AbbFJS6C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 14:58:02 -0400
From: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
To: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
Subject: [PATCH v5 3/3] staging: wilc1000: coreconfigurator: Align enums and defines
Date: Wed, 10 Jun 2015 21:57:26 +0300
Message-Id: <1433962646-4278-3-git-send-email-kholmanskikh.s.s@gmail.com> (sfid-20150610_205850_690404_0355DD3A)
In-Reply-To: <1433962646-4278-2-git-send-email-kholmanskikh.s.s@gmail.com>
References: <1433962646-4278-1-git-send-email-kholmanskikh.s.s@gmail.com>
 <1433962646-4278-2-git-send-email-kholmanskikh.s.s@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Aligned enum members and defines to follow a common style
per enum/(group of defines).

Signed-off-by: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 29 +++++++-------
 drivers/staging/wilc1000/coreconfigurator.h | 62 ++++++++++++++---------------
 2 files changed, 46 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index b90eaf1..3a6c5ba 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
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
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 73cdbef..b8e5241 100644
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
 
-- 
1.9.1

