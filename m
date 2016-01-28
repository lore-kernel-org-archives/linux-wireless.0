Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:12104 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbcA1HQO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 02:16:14 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 02/12] staging: wilc1000: renames u16RxLen variable
Date: Thu, 28 Jan 2016 16:13:36 +0900
Message-ID: <1453965226-6158-2-git-send-email-leo.kim@atmel.com> (sfid-20160128_081618_599992_513570D3)
In-Reply-To: <1453965226-6158-1-git-send-email-leo.kim@atmel.com>
References: <1453965226-6158-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u16RxLen variable to rx_len to avoid camelcase.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 37d40bb..9f85fff 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -241,13 +241,13 @@ static inline u16 get_asoc_id(u8 *data)
 	return asoc_id;
 }
 
-static u8 *get_tim_elm(u8 *pu8msa, u16 u16RxLen, u16 u16TagParamOffset)
+static u8 *get_tim_elm(u8 *pu8msa, u16 rx_len, u16 u16TagParamOffset)
 {
 	u16 u16index;
 
 	u16index = u16TagParamOffset;
 
-	while (u16index < (u16RxLen - FCS_LEN)) {
+	while (u16index < (rx_len - FCS_LEN)) {
 		if (pu8msa[u16index] == ITIM)
 			return &pu8msa[u16index];
 		u16index += (IE_HDR_LEN + pu8msa[u16index + 1]);
@@ -256,12 +256,12 @@ static u8 *get_tim_elm(u8 *pu8msa, u16 u16RxLen, u16 u16TagParamOffset)
 	return NULL;
 }
 
-static u8 get_current_channel_802_11n(u8 *pu8msa, u16 u16RxLen)
+static u8 get_current_channel_802_11n(u8 *pu8msa, u16 rx_len)
 {
 	u16 index;
 
 	index = TAG_PARAM_OFFSET;
-	while (index < (u16RxLen - FCS_LEN)) {
+	while (index < (rx_len - FCS_LEN)) {
 		if (pu8msa[index] == IDSPARMS)
 			return pu8msa[index + 2];
 		index += pu8msa[index + 1] + IE_HDR_LEN;
@@ -296,7 +296,7 @@ s32 wilc_parse_network_info(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo
 
 	{
 		u8  *pu8msa = NULL;
-		u16 u16RxLen = 0;
+		u16 rx_len = 0;
 		u8 *pu8TimElm = NULL;
 		u8 *pu8IEs = NULL;
 		u16 u16IEsLen = 0;
@@ -312,7 +312,7 @@ s32 wilc_parse_network_info(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo
 
 		pu8msa = &pu8WidVal[1];
 
-		u16RxLen = u16WidLen - 1;
+		rx_len = u16WidLen - 1;
 		pstrNetworkInfo->u16CapInfo = get_cap_info(pu8msa);
 		pstrNetworkInfo->u32Tsf = get_beacon_timestamp_lo(pu8msa);
 		PRINT_D(CORECONFIG_DBG, "TSF :%x\n", pstrNetworkInfo->u32Tsf);
@@ -326,7 +326,7 @@ s32 wilc_parse_network_info(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo
 		get_BSSID(pu8msa, pstrNetworkInfo->au8bssid);
 
 		pstrNetworkInfo->u8channel = get_current_channel_802_11n(pu8msa,
-							u16RxLen + FCS_LEN);
+							rx_len + FCS_LEN);
 
 		u8index = MAC_HDR_LEN + TIME_STAMP_LEN;
 
@@ -334,11 +334,11 @@ s32 wilc_parse_network_info(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo
 
 		u8index += BEACON_INTERVAL_LEN + CAP_INFO_LEN;
 
-		pu8TimElm = get_tim_elm(pu8msa, u16RxLen + FCS_LEN, u8index);
+		pu8TimElm = get_tim_elm(pu8msa, rx_len + FCS_LEN, u8index);
 		if (pu8TimElm)
 			pstrNetworkInfo->u8DtimPeriod = pu8TimElm[3];
 		pu8IEs = &pu8msa[MAC_HDR_LEN + TIME_STAMP_LEN + BEACON_INTERVAL_LEN + CAP_INFO_LEN];
-		u16IEsLen = u16RxLen - (MAC_HDR_LEN + TIME_STAMP_LEN + BEACON_INTERVAL_LEN + CAP_INFO_LEN);
+		u16IEsLen = rx_len - (MAC_HDR_LEN + TIME_STAMP_LEN + BEACON_INTERVAL_LEN + CAP_INFO_LEN);
 
 		if (u16IEsLen > 0) {
 			pstrNetworkInfo->pu8IEs = kmemdup(pu8IEs, u16IEsLen,
-- 
1.9.1

