Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:36692 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbbFAS4l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 14:56:41 -0400
From: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
To: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
Subject: [PATCH v2 3/4] staging: wilc1000: Cleanup to coreconfigurator
Date: Mon,  1 Jun 2015 21:56:20 +0300
Message-Id: <1433184981-6077-3-git-send-email-kholmanskikh.s.s@gmail.com> (sfid-20150601_205729_009634_917117F7)
In-Reply-To: <1433184981-6077-2-git-send-email-kholmanskikh.s.s@gmail.com>
References: <1433184981-6077-1-git-send-email-kholmanskikh.s.s@gmail.com>
 <1433184981-6077-2-git-send-email-kholmanskikh.s.s@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixed several syntax/style issues found with checkpatch.pl.

Signed-off-by: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 01625bd..2c6b7f4 100644
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
@@ -675,7 +675,7 @@ WILC_Sint32 CoreConfiguratorInit(void)
 	tstrWILC_SemaphoreAttrs strSemSendPktAttrs;
 	tstrWILC_SemaphoreAttrs strSemPktRespAttrs;
 
-	PRINT_D(CORECONFIG_DBG, "CoreConfiguratorInit() \n");
+	PRINT_D(CORECONFIG_DBG, "CoreConfiguratorInit()\n");
 
 	WILC_SemaphoreFillDefault(&strSemSendPktAttrs);
 	strSemSendPktAttrs.u32InitCount = 1;
@@ -687,7 +687,7 @@ WILC_Sint32 CoreConfiguratorInit(void)
 
 	gps8ConfigPacket = (WILC_Sint8 *)WILC_MALLOC(MAX_PACKET_BUFF_SIZE);
 	if (gps8ConfigPacket == NULL) {
-		PRINT_ER("failed in gps8ConfigPacket allocation \n");
+		PRINT_ER("failed in gps8ConfigPacket allocation\n");
 		s32Error = WILC_NO_MEM;
 		goto _fail_;
 	}
@@ -718,13 +718,13 @@ WILC_Uint8 *get_tim_elm(WILC_Uint8 *pu8msa, WILC_Uint16 u16RxLen, WILC_Uint16 u1
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
@@ -736,7 +736,7 @@ WILC_Uint8 get_current_channel_802_11n(WILC_Uint8 *pu8msa, WILC_Uint16 u16RxLen)
 	index = TAG_PARAM_OFFSET;
 	while (index < (u16RxLen - FCS_LEN)) {
 		if (pu8msa[index] == IDSPARMS)
-			return (pu8msa[index + 2]);
+			return pu8msa[index + 2];
 		else
 			/* Increment index by length information and header */
 			index += pu8msa[index + 1] + IE_HDR_LEN;
@@ -758,7 +758,7 @@ WILC_Uint8 get_current_channel(WILC_Uint8 *pu8msa, WILC_Uint16 u16RxLen)
 #else /* FIVE_GHZ_BAND */
 	/* Extract current channel information from */
 	/* the beacon/probe response frame          */
-	return (get_current_channel_802_11n(pu8msa, u16RxLen));
+	return get_current_channel_802_11n(pu8msa, u16RxLen);
 #endif /* FIVE_GHZ_BAND */
 #else
 	return 0;
@@ -1452,7 +1452,7 @@ void ProcessAdrWid(WILC_Char *pcPacket, WILC_Sint32 *ps32PktLen,
 void ProcessBinWid(WILC_Char *pcPacket, WILC_Sint32 *ps32PktLen,
 		   tstrWID *pstrWID, WILC_Uint8 *pu8val, WILC_Sint32 s32ValueSize)
 {
-	/* WILC_ERROR("processing Binary WIDs is not supported \n"); */
+	/* WILC_ERROR("processing Binary WIDs is not supported\n"); */
 
 	WILC_Uint16 u16MsgLen = 0;
 	WILC_Uint16 idx    = 0;
@@ -1591,7 +1591,7 @@ WILC_Sint32 further_process_response(WILC_Uint8 *resp,
 			WILC_memcpy(pstrWIDresult->ps8WidVal, cfg_str, cfg_len); /* mostafa: no need currently for the extra NULL byte */
 			pstrWIDresult->s32ValueSize = cfg_len;
 		} else {
-			PRINT_ER("allocated WID buffer length is smaller than the received WID Length \n");
+			PRINT_ER("allocated WID buffer length is smaller than the received WID Length\n");
 			retval = -2;
 		}
 
@@ -2035,7 +2035,7 @@ WILC_Sint32 ConfigProvideResponse(WILC_Char *pcRespBuffer, WILC_Sint32 s32RespLe
 		} else {
 			WILC_memcpy(gstrConfigPktInfo.pcRespBuffer, pcRespBuffer, gstrConfigPktInfo.s32MaxRespBuffLen);
 			gstrConfigPktInfo.s32BytesRead = gstrConfigPktInfo.s32MaxRespBuffLen;
-			PRINT_ER("BusProvideResponse() Response greater than the prepared Buffer Size \n");
+			PRINT_ER("BusProvideResponse() Response greater than the prepared Buffer Size\n");
 		}
 
 		WILC_SemaphoreRelease(&SemHandlePktResp, WILC_NULL);
@@ -2084,7 +2084,7 @@ WILC_Sint32 ConfigPktReceived(WILC_Uint8 *pu8RxPacket, WILC_Sint32 s32RxPacketLe
 		break;
 
 	default:
-		PRINT_ER("ConfigPktReceived(): invalid received msg type at the Core Configurator \n");
+		PRINT_ER("ConfigPktReceived(): invalid received msg type at the Core Configurator\n");
 		break;
 	}
 
@@ -2105,7 +2105,7 @@ WILC_Sint32 CoreConfiguratorDeInit(void)
 {
 	WILC_Sint32 s32Error = WILC_SUCCESS;
 
-	PRINT_D(CORECONFIG_DBG, "CoreConfiguratorDeInit() \n");
+	PRINT_D(CORECONFIG_DBG, "CoreConfiguratorDeInit()\n");
 
 
 	WILC_SemaphoreDestroy(&SemHandleSendPkt, WILC_NULL);
-- 
1.9.1

