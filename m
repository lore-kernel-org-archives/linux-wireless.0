Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:9996 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965842AbcBDJZ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 04:25:29 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 25/70] staging: wilc1000: wilc_parse_network_info(): renames local variables
Date: Thu, 4 Feb 2016 18:15:42 +0900
Message-ID: <1454577387-509-26-git-send-email-glen.lee@atmel.com> (sfid-20160204_102952_670937_F44D2C3A)
In-Reply-To: <1454577387-509-1-git-send-email-glen.lee@atmel.com>
References: <1454577387-509-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames to avoid camelcase, changes follow are:
 - pstrNetworkInfo to network_info
 - u8MsgType to msg_type
 - u8MsgID to msg_id
 - u16MsgLen to msg_len
 - u16WidID to wid_id
 - u16WidLen to wid_len
 - pu8WidVal to wid_val

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 67 ++++++++++++++---------------
 1 file changed, 33 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 43f0a29..24afeb8 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -272,27 +272,27 @@ static u8 get_current_channel_802_11n(u8 *pu8msa, u16 rx_len)
 
 s32 wilc_parse_network_info(u8 *msg_buffer, tstrNetworkInfo **ret_network_info)
 {
-	tstrNetworkInfo *pstrNetworkInfo = NULL;
-	u8 u8MsgType = 0;
-	u8 u8MsgID = 0;
-	u16 u16MsgLen = 0;
+	tstrNetworkInfo *network_info = NULL;
+	u8 msg_type = 0;
+	u8 msg_id = 0;
+	u16 msg_len = 0;
 
-	u16 u16WidID = (u16)WID_NIL;
-	u16 u16WidLen  = 0;
-	u8  *pu8WidVal = NULL;
+	u16 wid_id = (u16)WID_NIL;
+	u16 wid_len  = 0;
+	u8 *wid_val = NULL;
 
-	u8MsgType = msg_buffer[0];
+	msg_type = msg_buffer[0];
 
-	if ('N' != u8MsgType) {
+	if ('N' != msg_type) {
 		PRINT_ER("Received Message format incorrect.\n");
 		return -EFAULT;
 	}
 
-	u8MsgID = msg_buffer[1];
-	u16MsgLen = MAKE_WORD16(msg_buffer[2], msg_buffer[3]);
-	u16WidID = MAKE_WORD16(msg_buffer[4], msg_buffer[5]);
-	u16WidLen = MAKE_WORD16(msg_buffer[6], msg_buffer[7]);
-	pu8WidVal = &msg_buffer[8];
+	msg_id = msg_buffer[1];
+	msg_len = MAKE_WORD16(msg_buffer[2], msg_buffer[3]);
+	wid_id = MAKE_WORD16(msg_buffer[4], msg_buffer[5]);
+	wid_len = MAKE_WORD16(msg_buffer[6], msg_buffer[7]);
+	wid_val = &msg_buffer[8];
 
 	{
 		u8  *pu8msa = NULL;
@@ -304,53 +304,52 @@ s32 wilc_parse_network_info(u8 *msg_buffer, tstrNetworkInfo **ret_network_info)
 		u32 u32Tsf_Lo;
 		u32 u32Tsf_Hi;
 
-		pstrNetworkInfo = kzalloc(sizeof(tstrNetworkInfo), GFP_KERNEL);
-		if (!pstrNetworkInfo)
+		network_info = kzalloc(sizeof(tstrNetworkInfo), GFP_KERNEL);
+		if (!network_info)
 			return -ENOMEM;
 
-		pstrNetworkInfo->s8rssi = pu8WidVal[0];
+		network_info->s8rssi = wid_val[0];
 
-		pu8msa = &pu8WidVal[1];
+		pu8msa = &wid_val[1];
 
-		rx_len = u16WidLen - 1;
-		pstrNetworkInfo->u16CapInfo = get_cap_info(pu8msa);
-		pstrNetworkInfo->u32Tsf = get_beacon_timestamp_lo(pu8msa);
-		PRINT_D(CORECONFIG_DBG, "TSF :%x\n", pstrNetworkInfo->u32Tsf);
+		rx_len = wid_len - 1;
+		network_info->u16CapInfo = get_cap_info(pu8msa);
+		network_info->u32Tsf = get_beacon_timestamp_lo(pu8msa);
+		PRINT_D(CORECONFIG_DBG, "TSF :%x\n", network_info->u32Tsf);
 
 		u32Tsf_Lo = get_beacon_timestamp_lo(pu8msa);
 		u32Tsf_Hi = get_beacon_timestamp_hi(pu8msa);
 
-		pstrNetworkInfo->u64Tsf = u32Tsf_Lo | ((u64)u32Tsf_Hi << 32);
+		network_info->u64Tsf = u32Tsf_Lo | ((u64)u32Tsf_Hi << 32);
 
-		get_ssid(pu8msa, pstrNetworkInfo->au8ssid, &pstrNetworkInfo->u8SsidLen);
-		get_BSSID(pu8msa, pstrNetworkInfo->au8bssid);
+		get_ssid(pu8msa, network_info->au8ssid, &network_info->u8SsidLen);
+		get_BSSID(pu8msa, network_info->au8bssid);
 
-		pstrNetworkInfo->u8channel = get_current_channel_802_11n(pu8msa,
+		network_info->u8channel = get_current_channel_802_11n(pu8msa,
 							rx_len + FCS_LEN);
 
 		u8index = MAC_HDR_LEN + TIME_STAMP_LEN;
 
-		pstrNetworkInfo->u16BeaconPeriod = get_beacon_period(pu8msa + u8index);
+		network_info->u16BeaconPeriod = get_beacon_period(pu8msa + u8index);
 
 		u8index += BEACON_INTERVAL_LEN + CAP_INFO_LEN;
 
 		pu8TimElm = get_tim_elm(pu8msa, rx_len + FCS_LEN, u8index);
 		if (pu8TimElm)
-			pstrNetworkInfo->u8DtimPeriod = pu8TimElm[3];
+			network_info->u8DtimPeriod = pu8TimElm[3];
 		pu8IEs = &pu8msa[MAC_HDR_LEN + TIME_STAMP_LEN + BEACON_INTERVAL_LEN + CAP_INFO_LEN];
 		u16IEsLen = rx_len - (MAC_HDR_LEN + TIME_STAMP_LEN + BEACON_INTERVAL_LEN + CAP_INFO_LEN);
 
 		if (u16IEsLen > 0) {
-			pstrNetworkInfo->pu8IEs = kmemdup(pu8IEs, u16IEsLen,
-							  GFP_KERNEL);
-			if (!pstrNetworkInfo->pu8IEs)
+			network_info->pu8IEs = kmemdup(pu8IEs, u16IEsLen,
+						       GFP_KERNEL);
+			if (!network_info->pu8IEs)
 				return -ENOMEM;
 		}
-		pstrNetworkInfo->u16IEsLen = u16IEsLen;
-
+		network_info->u16IEsLen = u16IEsLen;
 	}
 
-	*ret_network_info = pstrNetworkInfo;
+	*ret_network_info = network_info;
 
 	return 0;
 }
-- 
1.9.1

