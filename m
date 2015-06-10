Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:35739 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbbFJS56 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 14:57:58 -0400
From: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
To: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
Subject: [PATCH v5 1/3] staging: wilc1000: coreconfigurator: Remove spaces before "\n"
Date: Wed, 10 Jun 2015 21:57:24 +0300
Message-Id: <1433962646-4278-1-git-send-email-kholmanskikh.s.s@gmail.com> (sfid-20150610_205818_934402_BCBE43CC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In accordance to checkpatch.pl, a space before a quoted
newline ("\n") is unnecessary, therefore substituted " \n"
with "\n" in coreconfigurator.c

Signed-off-by: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
---
Changes since V4:
* Split [PATCH V4 1/2] into two patches. I postponed the realignment
  of TAG_PARAM_OFFSET to fit 80 columns to a later time.
* Noted in the description to patch 3, that I also realigned
  defines.

 drivers/staging/wilc1000/coreconfigurator.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index e3e3f20..b54e43a 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -672,14 +672,14 @@ INLINE WILC_Uint16 get_asoc_id(u8 *data)
 WILC_Sint32 CoreConfiguratorInit(void)
 {
 	WILC_Sint32 s32Error = WILC_SUCCESS;
-	PRINT_D(CORECONFIG_DBG, "CoreConfiguratorInit() \n");
+	PRINT_D(CORECONFIG_DBG, "CoreConfiguratorInit()\n");
 
 	sema_init(&SemHandleSendPkt, 1);
 	sema_init(&SemHandlePktResp, 0);
 
 	gps8ConfigPacket = (WILC_Sint8 *)WILC_MALLOC(MAX_PACKET_BUFF_SIZE);
 	if (gps8ConfigPacket == NULL) {
-		PRINT_ER("failed in gps8ConfigPacket allocation \n");
+		PRINT_ER("failed in gps8ConfigPacket allocation\n");
 		s32Error = WILC_NO_MEM;
 		goto _fail_;
 	}
@@ -1444,7 +1444,7 @@ void ProcessAdrWid(WILC_Char *pcPacket, WILC_Sint32 *ps32PktLen,
 void ProcessBinWid(WILC_Char *pcPacket, WILC_Sint32 *ps32PktLen,
 		   tstrWID *pstrWID, u8 *pu8val, WILC_Sint32 s32ValueSize)
 {
-	/* WILC_ERROR("processing Binary WIDs is not supported \n"); */
+	/* WILC_ERROR("processing Binary WIDs is not supported\n"); */
 
 	WILC_Uint16 u16MsgLen = 0;
 	WILC_Uint16 idx    = 0;
@@ -1583,7 +1583,7 @@ WILC_Sint32 further_process_response(u8 *resp,
 			WILC_memcpy(pstrWIDresult->ps8WidVal, cfg_str, cfg_len); /* mostafa: no need currently for the extra NULL byte */
 			pstrWIDresult->s32ValueSize = cfg_len;
 		} else {
-			PRINT_ER("allocated WID buffer length is smaller than the received WID Length \n");
+			PRINT_ER("allocated WID buffer length is smaller than the received WID Length\n");
 			retval = -2;
 		}
 
@@ -2027,7 +2027,7 @@ WILC_Sint32 ConfigProvideResponse(WILC_Char *pcRespBuffer, WILC_Sint32 s32RespLe
 		} else {
 			WILC_memcpy(gstrConfigPktInfo.pcRespBuffer, pcRespBuffer, gstrConfigPktInfo.s32MaxRespBuffLen);
 			gstrConfigPktInfo.s32BytesRead = gstrConfigPktInfo.s32MaxRespBuffLen;
-			PRINT_ER("BusProvideResponse() Response greater than the prepared Buffer Size \n");
+			PRINT_ER("BusProvideResponse() Response greater than the prepared Buffer Size\n");
 		}
 
 		up(&SemHandlePktResp);
@@ -2076,7 +2076,7 @@ WILC_Sint32 ConfigPktReceived(u8 *pu8RxPacket, WILC_Sint32 s32RxPacketLen)
 		break;
 
 	default:
-		PRINT_ER("ConfigPktReceived(): invalid received msg type at the Core Configurator \n");
+		PRINT_ER("ConfigPktReceived(): invalid received msg type at the Core Configurator\n");
 		break;
 	}
 
@@ -2097,7 +2097,7 @@ WILC_Sint32 CoreConfiguratorDeInit(void)
 {
 	WILC_Sint32 s32Error = WILC_SUCCESS;
 
-	PRINT_D(CORECONFIG_DBG, "CoreConfiguratorDeInit() \n");
+	PRINT_D(CORECONFIG_DBG, "CoreConfiguratorDeInit()\n");
 
 	if (gps8ConfigPacket != NULL) {
 
-- 
1.9.1

