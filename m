Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:11980 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbbJLH4r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 03:56:47 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 03/41] staging: wilc1000: host_interface.c : removes unused local variables
Date: Mon, 12 Oct 2015 16:55:37 +0900
Message-ID: <1444636575-2486-3-git-send-email-tony.cho@atmel.com> (sfid-20151012_095649_687501_FC258DF8)
In-Reply-To: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
References: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes unused local variables from host_interface.c.
The unused local variable, s32Error is used just to return zero, so this
patch calls "returns 0" instead of "return s32Error" after removing
s32Error.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 34 +++++++++----------------------
 1 file changed, 10 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 667eb4f..02bb3f4 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1203,11 +1203,9 @@ ERRORHANDLER:
  */
 static s32 Handle_wait_msg_q_empty(void)
 {
-	s32 s32Error = 0;
-
 	g_wilc_initialized = 0;
 	up(&hWaitResponse);
-	return s32Error;
+	return 0;
 }
 
 /**
@@ -4161,7 +4159,6 @@ static void TimerCB_Connect(unsigned long arg)
 /* Check implementation in core adding 9 bytes to the input! */
 s32 host_int_remove_key(struct host_if_drv *hWFIDrv, const u8 *pu8StaAddress)
 {
-	s32 s32Error = 0;
 	tstrWID strWID;
 
 	strWID.u16WIDid	= (u16)WID_REMOVE_KEY;
@@ -4169,8 +4166,7 @@ s32 host_int_remove_key(struct host_if_drv *hWFIDrv, const u8 *pu8StaAddress)
 	strWID.ps8WidVal	= (s8 *)pu8StaAddress;
 	strWID.s32ValueSize = 6;
 
-	return s32Error;
-
+	return 0;
 }
 
 /**
@@ -4680,7 +4676,6 @@ s32 host_int_set_pmkid_info(struct host_if_drv *hWFIDrv, struct host_if_pmkid_at
 s32 host_int_get_pmkid_info(struct host_if_drv *hWFIDrv, u8 *pu8PmkidInfoArray,
 				    u32 u32PmkidInfoLen)
 {
-	s32 s32Error = 0;
 	tstrWID strWID;
 
 	strWID.u16WIDid	= (u16)WID_PMKID_INFO;
@@ -4688,7 +4683,7 @@ s32 host_int_get_pmkid_info(struct host_if_drv *hWFIDrv, u8 *pu8PmkidInfoArray,
 	strWID.s32ValueSize = u32PmkidInfoLen;
 	strWID.ps8WidVal = pu8PmkidInfoArray;
 
-	return s32Error;
+	return 0;
 }
 
 /**
@@ -4708,7 +4703,6 @@ s32 host_int_get_pmkid_info(struct host_if_drv *hWFIDrv, u8 *pu8PmkidInfoArray,
 s32 host_int_set_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv, u8 *pu8PassPhrase,
 						 u8 u8Psklength)
 {
-	s32 s32Error = 0;
 	tstrWID strWID;
 
 	/*validating psk length*/
@@ -4719,7 +4713,7 @@ s32 host_int_set_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv, u8 *pu8Pas
 		strWID.s32ValueSize = u8Psklength;
 	}
 
-	return s32Error;
+	return 0;
 }
 /**
  *  @brief              host_int_get_MacAddress
@@ -4804,7 +4798,6 @@ s32 host_int_set_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress)
 s32 host_int_get_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv,
 						 u8 *pu8PassPhrase, u8 u8Psklength)
 {
-	s32 s32Error = 0;
 	tstrWID strWID;
 
 	strWID.u16WIDid	= (u16)WID_11I_PSK;
@@ -4812,7 +4805,7 @@ s32 host_int_get_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv,
 	strWID.s32ValueSize = u8Psklength;
 	strWID.ps8WidVal	= pu8PassPhrase;
 
-	return s32Error;
+	return 0;
 }
 
 /**
@@ -4832,7 +4825,6 @@ s32 host_int_get_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv,
  */
 s32 host_int_set_start_scan_req(struct host_if_drv *hWFIDrv, u8 scanSource)
 {
-	s32 s32Error = 0;
 	tstrWID strWID;
 
 	strWID.u16WIDid = (u16)WID_START_SCAN_REQ;
@@ -4840,7 +4832,7 @@ s32 host_int_set_start_scan_req(struct host_if_drv *hWFIDrv, u8 scanSource)
 	strWID.ps8WidVal = (s8 *)&scanSource;
 	strWID.s32ValueSize = sizeof(char);
 
-	return s32Error;
+	return 0;
 }
 
 /**
@@ -4861,7 +4853,6 @@ s32 host_int_set_start_scan_req(struct host_if_drv *hWFIDrv, u8 scanSource)
 
 s32 host_int_get_start_scan_req(struct host_if_drv *hWFIDrv, u8 *pu8ScanSource)
 {
-	s32 s32Error = 0;
 	tstrWID strWID;
 
 	strWID.u16WIDid = (u16)WID_START_SCAN_REQ;
@@ -4869,7 +4860,7 @@ s32 host_int_get_start_scan_req(struct host_if_drv *hWFIDrv, u8 *pu8ScanSource)
 	strWID.ps8WidVal = (s8 *)pu8ScanSource;
 	strWID.s32ValueSize = sizeof(char);
 
-	return s32Error;
+	return 0;
 }
 
 /**
@@ -5059,7 +5050,6 @@ s32 host_int_disconnect(struct host_if_drv *hWFIDrv, u16 u16ReasonCode)
  */
 s32 host_int_disconnect_station(struct host_if_drv *hWFIDrv, u8 assoc_id)
 {
-	s32 s32Error = 0;
 	tstrWID strWID;
 
 	strWID.u16WIDid = (u16)WID_DISCONNECT;
@@ -5067,7 +5057,7 @@ s32 host_int_disconnect_station(struct host_if_drv *hWFIDrv, u8 assoc_id)
 	strWID.ps8WidVal = (s8 *)&assoc_id;
 	strWID.s32ValueSize = sizeof(char);
 
-	return s32Error;
+	return 0;
 }
 
 /**
@@ -5099,7 +5089,6 @@ s32 host_int_disconnect_station(struct host_if_drv *hWFIDrv, u8 assoc_id)
 s32 host_int_get_assoc_req_info(struct host_if_drv *hWFIDrv, u8 *pu8AssocReqInfo,
 					u32 u32AssocReqInfoLen)
 {
-	s32 s32Error = 0;
 	tstrWID strWID;
 
 	strWID.u16WIDid = (u16)WID_ASSOC_REQ_INFO;
@@ -5107,8 +5096,7 @@ s32 host_int_get_assoc_req_info(struct host_if_drv *hWFIDrv, u8 *pu8AssocReqInfo
 	strWID.ps8WidVal = pu8AssocReqInfo;
 	strWID.s32ValueSize = u32AssocReqInfoLen;
 
-
-	return s32Error;
+	return 0;
 }
 
 /**
@@ -5172,7 +5160,6 @@ s32 host_int_get_assoc_res_info(struct host_if_drv *hWFIDrv, u8 *pu8AssocRespInf
 s32 host_int_get_rx_power_level(struct host_if_drv *hWFIDrv, u8 *pu8RxPowerLevel,
 					u32 u32RxPowerLevelLen)
 {
-	s32 s32Error = 0;
 	tstrWID strWID;
 
 	strWID.u16WIDid = (u16)WID_RX_POWER_LEVEL;
@@ -5180,8 +5167,7 @@ s32 host_int_get_rx_power_level(struct host_if_drv *hWFIDrv, u8 *pu8RxPowerLevel
 	strWID.ps8WidVal = pu8RxPowerLevel;
 	strWID.s32ValueSize = u32RxPowerLevelLen;
 
-
-	return s32Error;
+	return 0;
 }
 
 /**
-- 
1.9.1

