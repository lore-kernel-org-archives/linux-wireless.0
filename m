Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37426 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbbFBIzS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 04:55:18 -0400
From: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
To: gregkh@linuxfoundation.org, johnny.kim@atmel.com,
	rachel.kim@atmel.com, dean.lee@atmel.com, chris.park@atmel.com,
	devel@driverdev.osuosl.org
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
Subject: [PATCH v3 1/2] staging: wilc1000: Cleanup to coreconfigurator
Date: Tue,  2 Jun 2015 12:55:06 +0400
Message-Id: <1433235307-13146-1-git-send-email-kholmanskikh.s.s@gmail.com> (sfid-20150602_105555_818817_5EA6BF7E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixed several syntax/style issues found with checkpatch.pl.

Signed-off-by: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
---
Changes since V2:
* The first 2 patches were removed, because what they fix is already fixed now.


 drivers/staging/wilc1000/coreconfigurator.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index e3e3f20..43864dc 100644
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
@@ -710,13 +710,13 @@ u8 *get_tim_elm(u8 *pu8msa, WILC_Uint16 u16RxLen, WILC_Uint16 u16TagParamOffset)
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
@@ -728,7 +728,7 @@ u8 get_current_channel_802_11n(u8 *pu8msa, WILC_Uint16 u16RxLen)
 	index = TAG_PARAM_OFFSET;
 	while (index < (u16RxLen - FCS_LEN)) {
 		if (pu8msa[index] == IDSPARMS)
-			return (pu8msa[index + 2]);
+			return pu8msa[index + 2];
 		else
 			/* Increment index by length information and header */
 			index += pu8msa[index + 1] + IE_HDR_LEN;
@@ -750,7 +750,7 @@ u8 get_current_channel(u8 *pu8msa, WILC_Uint16 u16RxLen)
 #else /* FIVE_GHZ_BAND */
 	/* Extract current channel information from */
 	/* the beacon/probe response frame          */
-	return (get_current_channel_802_11n(pu8msa, u16RxLen));
+	return get_current_channel_802_11n(pu8msa, u16RxLen);
 #endif /* FIVE_GHZ_BAND */
 #else
 	return 0;
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

