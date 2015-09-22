Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34035 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933384AbbIVNsI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 09:48:08 -0400
Received: by padhy16 with SMTP id hy16so10101324pad.1
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2015 06:48:07 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 6/9] staging: wilc1000: remove useless comment
Date: Tue, 22 Sep 2015 22:47:42 +0900
Message-Id: <1442929665-19709-6-git-send-email-chaehyun.lim@gmail.com> (sfid-20150922_154813_201821_8E9991EF)
In-Reply-To: <1442929665-19709-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442929665-19709-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes useless comment in coreconfigurator.c

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 38 -----------------------------
 drivers/staging/wilc1000/coreconfigurator.h | 29 ++++++----------------
 2 files changed, 8 insertions(+), 59 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 8b56b92..47a37fa 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -9,26 +9,11 @@
  */
 
 
-/*****************************************************************************/
-/* File Includes                                                             */
-/*****************************************************************************/
 #include "coreconfigurator.h"
 #include <linux/errno.h>
-/*****************************************************************************/
-/* Constants                                                                 */
-/*****************************************************************************/
 #define TAG_PARAM_OFFSET	(MAC_HDR_LEN + TIME_STAMP_LEN + \
 							BEACON_INTERVAL_LEN + CAP_INFO_LEN)
 
-/*****************************************************************************/
-/* Function Macros                                                           */
-/*****************************************************************************/
-
-
-/*****************************************************************************/
-/* Type Definitions                                                          */
-/*****************************************************************************/
-
 /* Basic Frame Type Codes (2-bit) */
 typedef enum {
 	FRAME_TYPE_CONTROL     = 0x04,
@@ -130,25 +115,6 @@ typedef struct {
 	bool bRespRequired;
 } tstrConfigPktInfo;
 
-
-
-/*****************************************************************************/
-/* Extern Variable Declarations                                              */
-/*****************************************************************************/
-
-/*****************************************************************************/
-/* Global Variables                                                          */
-/*****************************************************************************/
-/*****************************************************************************/
-/* Static Function Declarations                                              */
-/*****************************************************************************/
-
-
-
-/*****************************************************************************/
-/* Functions                                                                 */
-/*****************************************************************************/
-
 /* This function extracts the beacon period field from the beacon or probe   */
 /* response frame.                                                           */
 static inline u16 get_beacon_period(u8 *data)
@@ -688,7 +654,6 @@ s32 DeallocateSurveyResults(wid_site_survey_reslts_s *pstrSurveyResults)
 }
 #endif
 
-/*Using the global handle of the driver*/
 extern wilc_wlan_oup_t *gpstrWlanOps;
 /**
  *  @brief              sends certain Configuration Packet based on the input WIDs pstrWIDs
@@ -735,9 +700,6 @@ s32 send_config_pkt(u8 u8Mode, tstrWID *pstrWIDs,
 				break;
 			}
 		}
-		/**
-		 *      get the value
-		 **/
 		counter = 0;
 		for (counter = 0; counter < u32WIDsCount; counter++) {
 			pstrWIDs[counter].s32ValueSize = gpstrWlanOps->wlan_cfg_get_value(
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 7227c0f..e2b7b09 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -12,10 +12,7 @@
 #define CORECONFIGURATOR_H
 
 #include "wilc_wlan_if.h"
-/*****************************************************************************/
-/* Constants                                                                 */
-/*****************************************************************************/
-/* Number of WID Options Supported */
+
 #define NUM_BASIC_SWITCHES      45
 #define NUM_FHSS_SWITCHES       0
 
@@ -24,12 +21,12 @@
 #ifdef MAC_802_11N
 #define NUM_11N_BASIC_SWITCHES  25
 #define NUM_11N_HUT_SWITCHES    47
-#else /* MAC_802_11N */
+#else
 #define NUM_11N_BASIC_SWITCHES  0
 #define NUM_11N_HUT_SWITCHES    0
-#endif /* MAC_802_11N */
+#endif
 
-#define MAC_HDR_LEN             24          /* No Address4 - non-ESS         */
+#define MAC_HDR_LEN             24
 #define MAX_SSID_LEN            33
 #define FCS_LEN                 4
 #define TIME_STAMP_LEN          8
@@ -39,9 +36,7 @@
 #define AID_LEN                 2
 #define IE_HDR_LEN              2
 
-/* Operating Mode: SET */
 #define SET_CFG              0
-/* Operating Mode: GET */
 #define GET_CFG              1
 
 #define MAX_STRING_LEN               256
@@ -52,16 +47,9 @@
 #define MAC_CONNECTED                1
 #define MAC_DISCONNECTED             0
 
-/*****************************************************************************/
-/* Function Macros                                                           */
-/*****************************************************************************/
 #define MAKE_WORD16(lsb, msb) ((((u16)(msb) << 8) & 0xFF00) | (lsb))
 #define MAKE_WORD32(lsw, msw) ((((u32)(msw) << 16) & 0xFFFF0000) | (lsw))
 
-/*****************************************************************************/
-/* Type Definitions                                                                                                                       */
-/*****************************************************************************/
-/* Status Codes for Authentication and Association Frames */
 typedef enum {
 	SUCCESSFUL_STATUSCODE    = 0,
 	UNSPEC_FAIL              = 1,
@@ -95,7 +83,7 @@ typedef struct {
 	u8 u8Index;
 	s8 as8RSSI[NUM_RSSI];
 } tstrRSSI;
-/* This structure is used to support parsing of the received 'N' message */
+
 typedef struct {
 	s8 s8rssi;
 	u16 u16CapInfo;
@@ -105,21 +93,20 @@ typedef struct {
 	u16 u16BeaconPeriod;
 	u8 u8DtimPeriod;
 	u8 u8channel;
-	unsigned long u32TimeRcvdInScanCached; /* of type unsigned long to be accepted by the linux kernel macro time_after() */
+	unsigned long u32TimeRcvdInScanCached;
 	unsigned long u32TimeRcvdInScan;
 	bool bNewNetwork;
 #ifdef AGING_ALG
 	u8 u8Found;
 #endif
-	u32 u32Tsf; /* time-stamp [Low only 32 bit] */
+	u32 u32Tsf;
 	u8 *pu8IEs;
 	u16 u16IEsLen;
 	void *pJoinParams;
 	tstrRSSI strRssi;
-	u64 u64Tsf; /* time-stamp [Low and High 64 bit] */
+	u64 u64Tsf;
 } tstrNetworkInfo;
 
-/* This structure is used to support parsing of the received Association Response frame */
 typedef struct {
 	u16 u16capability;
 	u16 u16ConnectStatus;
-- 
2.5.1

