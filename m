Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:27258 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbbIJJ05 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 05:26:57 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 5/5] staging: wilc1000: coreconfigurator.c: remove unused functions
Date: Thu, 10 Sep 2015 18:26:30 +0900
Message-ID: <1441877190-4546-5-git-send-email-tony.cho@atmel.com> (sfid-20150910_112701_569726_4AC2BC45)
In-Reply-To: <1441877190-4546-1-git-send-email-tony.cho@atmel.com>
References: <1441877190-4546-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

This patch removes following unused funtions which will not be used anymore.

ascii_hex_to_dec
get_hex_char
extract_mac_addr
create_mac_addr
conv_ip_to_int
conv_int_to_ip
get_wid_type
get_type
CreateConfigPacket
ConfigWaitResponse
ConfigProvideResponse
ConfigPktReceived
ParseWriteResponse
CreatePacketHeader
ParseResponse
ProcessBinWid
ProcessAdrWid
ProcessStrWid
ProcessIPwid
ProcessIntWid
ProcessShortWid
ProcessCharWid

As a result, four global variable causes defined but not used compile warnings.
So just remove unused varialbs g_seqno, g_wid_num, Res_Len and g_oper_mode.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 151 ----------------------------
 1 file changed, 151 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 450c3ff..f339085 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -1789,157 +1789,6 @@ s32 CreatePacketHeader(char *pcpacket, s32 *ps32PacketLength)
 }
 
 /**
- *  @brief              creates Configuration packet based on the Input WIDs
- *  @details
- *  @param[in]  pstrWIDs WIDs to be sent in the configuration packet
- *  @param[in]  u32WIDsCount number of WIDs to be sent in the configuration packet
- *  @param[out]         ps8packet The created Configuration Packet
- *  @param[out]         ps32PacketLength Length of the created Configuration Packet
- *  @return     Error code indicating success/failure
- *  @note
- *  @author
- *  @date		1 Mar 2012
- *  @version	1.0
- */
-
-s32 CreateConfigPacket(s8 *ps8packet, s32 *ps32PacketLength,
-			       tstrWID *pstrWIDs, u32 u32WIDsCount)
-{
-	s32 s32Error = WILC_SUCCESS;
-	u32 u32idx = 0;
-	*ps32PacketLength = MSG_HEADER_LEN;
-	for (u32idx = 0; u32idx < u32WIDsCount; u32idx++) {
-		switch (pstrWIDs[u32idx].enuWIDtype) {
-		case WID_CHAR:
-			ProcessCharWid(ps8packet, ps32PacketLength, &pstrWIDs[u32idx],
-				       pstrWIDs[u32idx].ps8WidVal);
-			break;
-
-		case WID_SHORT:
-			ProcessShortWid(ps8packet, ps32PacketLength, &pstrWIDs[u32idx],
-					pstrWIDs[u32idx].ps8WidVal);
-			break;
-
-		case WID_INT:
-			ProcessIntWid(ps8packet, ps32PacketLength, &pstrWIDs[u32idx],
-				      pstrWIDs[u32idx].ps8WidVal);
-			break;
-
-		case WID_STR:
-			ProcessStrWid(ps8packet, ps32PacketLength, &pstrWIDs[u32idx],
-				      pstrWIDs[u32idx].ps8WidVal, pstrWIDs[u32idx].s32ValueSize);
-			break;
-
-		case WID_IP:
-			ProcessIPwid(ps8packet, ps32PacketLength, &pstrWIDs[u32idx],
-				     pstrWIDs[u32idx].ps8WidVal);
-			break;
-
-		case WID_BIN_DATA:
-			ProcessBinWid(ps8packet, ps32PacketLength, &pstrWIDs[u32idx],
-				      pstrWIDs[u32idx].ps8WidVal, pstrWIDs[u32idx].s32ValueSize);
-			break;
-
-		default:
-			PRINT_ER("ERROR: Check Config database\n");
-		}
-	}
-
-	CreatePacketHeader(ps8packet, ps32PacketLength);
-
-	return s32Error;
-}
-
-s32 ConfigWaitResponse(char *pcRespBuffer, s32 s32MaxRespBuffLen, s32 *ps32BytesRead,
-			       bool bRespRequired)
-{
-	s32 s32Error = WILC_SUCCESS;
-	/*bug 3878*/
-	/*removed to caller function*/
-	/*gstrConfigPktInfo.pcRespBuffer = pcRespBuffer;
-	 * gstrConfigPktInfo.s32MaxRespBuffLen = s32MaxRespBuffLen;
-	 * gstrConfigPktInfo.bRespRequired = bRespRequired;*/
-
-
-	if (gstrConfigPktInfo.bRespRequired) {
-		down(&SemHandlePktResp);
-
-		*ps32BytesRead = gstrConfigPktInfo.s32BytesRead;
-	}
-
-	memset((void *)(&gstrConfigPktInfo), 0, sizeof(tstrConfigPktInfo));
-
-	return s32Error;
-}
-
-s32 ConfigProvideResponse(char *pcRespBuffer, s32 s32RespLen)
-{
-	s32 s32Error = WILC_SUCCESS;
-
-	if (gstrConfigPktInfo.bRespRequired) {
-		if (s32RespLen <= gstrConfigPktInfo.s32MaxRespBuffLen) {
-			memcpy(gstrConfigPktInfo.pcRespBuffer, pcRespBuffer, s32RespLen);
-			gstrConfigPktInfo.s32BytesRead = s32RespLen;
-		} else {
-			memcpy(gstrConfigPktInfo.pcRespBuffer, pcRespBuffer, gstrConfigPktInfo.s32MaxRespBuffLen);
-			gstrConfigPktInfo.s32BytesRead = gstrConfigPktInfo.s32MaxRespBuffLen;
-			PRINT_ER("BusProvideResponse() Response greater than the prepared Buffer Size\n");
-		}
-
-		up(&SemHandlePktResp);
-	}
-
-	return s32Error;
-}
-
-/**
- *  @brief              writes the received packet pu8RxPacket in the global Rx FIFO buffer
- *  @details
- *  @param[in]  pu8RxPacket The received packet
- *  @param[in]  s32RxPacketLen Length of the received packet
- *  @return     Error code indicating success/failure
- *  @note
- *
- *  @author	mabubakr
- *  @date		1 Mar 2012
- *  @version	1.0
- */
-
-s32 ConfigPktReceived(u8 *pu8RxPacket, s32 s32RxPacketLen)
-{
-	s32 s32Error = WILC_SUCCESS;
-	u8 u8MsgType = 0;
-
-	u8MsgType = pu8RxPacket[0];
-
-	switch (u8MsgType) {
-	case 'R':
-		ConfigProvideResponse(pu8RxPacket, s32RxPacketLen);
-
-		break;
-
-	case 'N':
-		PRINT_INFO(CORECONFIG_DBG, "NetworkInfo packet received\n");
-		NetworkInfoReceived(pu8RxPacket, s32RxPacketLen);
-		break;
-
-	case 'I':
-		GnrlAsyncInfoReceived(pu8RxPacket, s32RxPacketLen);
-		break;
-
-	case 'S':
-		host_int_ScanCompleteReceived(pu8RxPacket, s32RxPacketLen);
-		break;
-
-	default:
-		PRINT_ER("ConfigPktReceived(): invalid received msg type at the Core Configurator\n");
-		break;
-	}
-
-	return s32Error;
-}
-
-/**
  *  @brief              Deinitializes the Core Configurator
  *  @details
  *  @return     Error code indicating success/failure
-- 
1.9.1

