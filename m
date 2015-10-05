Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37063 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbbJEK2p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 06:28:45 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 3/6] staging: wilc1000: host_interface.c : removes unused local variables
Date: Mon, 5 Oct 2015 19:28:11 +0900
Message-ID: <1444040894-18709-3-git-send-email-tony.cho@atmel.com> (sfid-20151005_122848_157141_AF440F5A)
In-Reply-To: <1444040894-18709-1-git-send-email-tony.cho@atmel.com>
References: <1444040894-18709-1-git-send-email-tony.cho@atmel.com>
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
index d59fcaa..b12801b 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1202,11 +1202,9 @@ ERRORHANDLER:
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
@@ -4160,7 +4158,6 @@ static void TimerCB_Connect(unsigned long arg)
 /* Check implementation in core adding 9 bytes to the input! */
 s32 host_int_remove_key(struct host_if_drv *hWFIDrv, const u8 *pu8StaAddress)
 {
-	s32 s32Error = 0;
 	tstrWID strWID;
 
 	strWID.u16WIDid	= (u16)WID_REMOVE_KEY;
@@ -4168,8 +4165,7 @@ s32 host_int_remove_key(struct host_if_drv *hWFIDrv, const u8 *pu8StaAddress)
 	strWID.ps8WidVal	= (s8 *)pu8StaAddress;
 	strWID.s32ValueSize = 6;
 
-	return s32Error;
-
+	return 0;
 }
 
 /**
@@ -4684,7 +4680,6 @@ s32 host_int_set_pmkid_info(struct host_if_drv *hWFIDrv, struct host_if_pmkid_at
 s32 host_int_get_pmkid_info(struct host_if_drv *hWFIDrv, u8 *pu8PmkidInfoArray,
 				    u32 u32PmkidInfoLen)
 {
-	s32 s32Error = 0;
 	tstrWID strWID;
 
 	strWID.u16WIDid	= (u16)WID_PMKID_INFO;
@@ -4692,7 +4687,7 @@ s32 host_int_get_pmkid_info(struct host_if_drv *hWFIDrv, u8 *pu8PmkidInfoArray,
 	strWID.s32ValueSize = u32PmkidInfoLen;
 	strWID.ps8WidVal = pu8PmkidInfoArray;
 
-	return s32Error;
+	return 0;
 }
 
 /**
@@ -4712,7 +4707,6 @@ s32 host_int_get_pmkid_info(struct host_if_drv *hWFIDrv, u8 *pu8PmkidInfoArray,
 s32 host_int_set_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv, u8 *pu8PassPhrase,
 						 u8 u8Psklength)
 {
-	s32 s32Error = 0;
 	tstrWID strWID;
 
 	/*validating psk length*/
@@ -4723,7 +4717,7 @@ s32 host_int_set_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv, u8 *pu8Pas
 		strWID.s32ValueSize = u8Psklength;
 	}
 
-	return s32Error;
+	return 0;
 }
 /**
  *  @brief              host_int_get_MacAddress
@@ -4808,7 +4802,6 @@ s32 host_int_set_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress)
 s32 host_int_get_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv,
 						 u8 *pu8PassPhrase, u8 u8Psklength)
 {
-	s32 s32Error = 0;
 	tstrWID strWID;
 
 	strWID.u16WIDid	= (u16)WID_11I_PSK;
@@ -4816,7 +4809,7 @@ s32 host_int_get_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv,
 	strWID.s32ValueSize = u8Psklength;
 	strWID.ps8WidVal	= pu8PassPhrase;
 
-	return s32Error;
+	return 0;
 }
 
 /**
@@ -4836,7 +4829,6 @@ s32 host_int_get_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv,
  */
 s32 host_int_set_start_scan_req(struct host_if_drv *hWFIDrv, u8 scanSource)
 {
-	s32 s32Error = 0;
 	tstrWID strWID;
 
 	strWID.u16WIDid = (u16)WID_START_SCAN_REQ;
@@ -4844,7 +4836,7 @@ s32 host_int_set_start_scan_req(struct host_if_drv *hWFIDrv, u8 scanSource)
 	strWID.ps8WidVal = (s8 *)&scanSource;
 	strWID.s32ValueSize = sizeof(char);
 
-	return s32Error;
+	return 0;
 }
 
 /**
@@ -4865,7 +4857,6 @@ s32 host_int_set_start_scan_req(struct host_if_drv *hWFIDrv, u8 scanSource)
 
 s32 host_int_get_start_scan_req(struct host_if_drv *hWFIDrv, u8 *pu8ScanSource)
 {
-	s32 s32Error = 0;
 	tstrWID strWID;
 
 	strWID.u16WIDid = (u16)WID_START_SCAN_REQ;
@@ -4873,7 +4864,7 @@ s32 host_int_get_start_scan_req(struct host_if_drv *hWFIDrv, u8 *pu8ScanSource)
 	strWID.ps8WidVal = (s8 *)pu8ScanSource;
 	strWID.s32ValueSize = sizeof(char);
 
-	return s32Error;
+	return 0;
 }
 
 /**
@@ -5063,7 +5054,6 @@ s32 host_int_disconnect(struct host_if_drv *hWFIDrv, u16 u16ReasonCode)
  */
 s32 host_int_disconnect_station(struct host_if_drv *hWFIDrv, u8 assoc_id)
 {
-	s32 s32Error = 0;
 	tstrWID strWID;
 
 	strWID.u16WIDid = (u16)WID_DISCONNECT;
@@ -5071,7 +5061,7 @@ s32 host_int_disconnect_station(struct host_if_drv *hWFIDrv, u8 assoc_id)
 	strWID.ps8WidVal = (s8 *)&assoc_id;
 	strWID.s32ValueSize = sizeof(char);
 
-	return s32Error;
+	return 0;
 }
 
 /**
@@ -5103,7 +5093,6 @@ s32 host_int_disconnect_station(struct host_if_drv *hWFIDrv, u8 assoc_id)
 s32 host_int_get_assoc_req_info(struct host_if_drv *hWFIDrv, u8 *pu8AssocReqInfo,
 					u32 u32AssocReqInfoLen)
 {
-	s32 s32Error = 0;
 	tstrWID strWID;
 
 	strWID.u16WIDid = (u16)WID_ASSOC_REQ_INFO;
@@ -5111,8 +5100,7 @@ s32 host_int_get_assoc_req_info(struct host_if_drv *hWFIDrv, u8 *pu8AssocReqInfo
 	strWID.ps8WidVal = pu8AssocReqInfo;
 	strWID.s32ValueSize = u32AssocReqInfoLen;
 
-
-	return s32Error;
+	return 0;
 }
 
 /**
@@ -5176,7 +5164,6 @@ s32 host_int_get_assoc_res_info(struct host_if_drv *hWFIDrv, u8 *pu8AssocRespInf
 s32 host_int_get_rx_power_level(struct host_if_drv *hWFIDrv, u8 *pu8RxPowerLevel,
 					u32 u32RxPowerLevelLen)
 {
-	s32 s32Error = 0;
 	tstrWID strWID;
 
 	strWID.u16WIDid = (u16)WID_RX_POWER_LEVEL;
@@ -5184,8 +5171,7 @@ s32 host_int_get_rx_power_level(struct host_if_drv *hWFIDrv, u8 *pu8RxPowerLevel
 	strWID.ps8WidVal = pu8RxPowerLevel;
 	strWID.s32ValueSize = u32RxPowerLevelLen;
 
-
-	return s32Error;
+	return 0;
 }
 
 /**
-- 
1.9.1

