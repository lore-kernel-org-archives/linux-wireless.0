Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:10067 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965859AbcBDJZp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 04:25:45 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 26/70] staging: wilc1000: wilc_parse_network_info(): renames local inner variables
Date: Thu, 4 Feb 2016 18:15:43 +0900
Message-ID: <1454577387-509-27-git-send-email-glen.lee@atmel.com> (sfid-20160204_102949_411476_7B4820E5)
In-Reply-To: <1454577387-509-1-git-send-email-glen.lee@atmel.com>
References: <1454577387-509-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames to avoid camelcase, changes follow are:
 - pu8TimElm to tim_elm
 - pu8IEs to ies
 - u16IEsLen to ies_len
 - u32Tsf_Lo to tsf_lo
 - u32Tsf_Hi to tsf_hi

And, remove the prefix variable defined name, below are:
 - u8index to index
 - pu8msa to msa

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 54 ++++++++++++++---------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 24afeb8..2a4e324 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -295,14 +295,14 @@ s32 wilc_parse_network_info(u8 *msg_buffer, tstrNetworkInfo **ret_network_info)
 	wid_val = &msg_buffer[8];
 
 	{
-		u8  *pu8msa = NULL;
+		u8 *msa = NULL;
 		u16 rx_len = 0;
-		u8 *pu8TimElm = NULL;
-		u8 *pu8IEs = NULL;
-		u16 u16IEsLen = 0;
-		u8 u8index = 0;
-		u32 u32Tsf_Lo;
-		u32 u32Tsf_Hi;
+		u8 *tim_elm = NULL;
+		u8 *ies = NULL;
+		u16 ies_len = 0;
+		u8 index = 0;
+		u32 tsf_lo;
+		u32 tsf_hi;
 
 		network_info = kzalloc(sizeof(tstrNetworkInfo), GFP_KERNEL);
 		if (!network_info)
@@ -310,43 +310,43 @@ s32 wilc_parse_network_info(u8 *msg_buffer, tstrNetworkInfo **ret_network_info)
 
 		network_info->s8rssi = wid_val[0];
 
-		pu8msa = &wid_val[1];
+		msa = &wid_val[1];
 
 		rx_len = wid_len - 1;
-		network_info->u16CapInfo = get_cap_info(pu8msa);
-		network_info->u32Tsf = get_beacon_timestamp_lo(pu8msa);
+		network_info->u16CapInfo = get_cap_info(msa);
+		network_info->u32Tsf = get_beacon_timestamp_lo(msa);
 		PRINT_D(CORECONFIG_DBG, "TSF :%x\n", network_info->u32Tsf);
 
-		u32Tsf_Lo = get_beacon_timestamp_lo(pu8msa);
-		u32Tsf_Hi = get_beacon_timestamp_hi(pu8msa);
+		tsf_lo = get_beacon_timestamp_lo(msa);
+		tsf_hi = get_beacon_timestamp_hi(msa);
 
-		network_info->u64Tsf = u32Tsf_Lo | ((u64)u32Tsf_Hi << 32);
+		network_info->u64Tsf = tsf_lo | ((u64)tsf_hi << 32);
 
-		get_ssid(pu8msa, network_info->au8ssid, &network_info->u8SsidLen);
-		get_BSSID(pu8msa, network_info->au8bssid);
+		get_ssid(msa, network_info->au8ssid, &network_info->u8SsidLen);
+		get_BSSID(msa, network_info->au8bssid);
 
-		network_info->u8channel = get_current_channel_802_11n(pu8msa,
+		network_info->u8channel = get_current_channel_802_11n(msa,
 							rx_len + FCS_LEN);
 
-		u8index = MAC_HDR_LEN + TIME_STAMP_LEN;
+		index = MAC_HDR_LEN + TIME_STAMP_LEN;
 
-		network_info->u16BeaconPeriod = get_beacon_period(pu8msa + u8index);
+		network_info->u16BeaconPeriod = get_beacon_period(msa + index);
 
-		u8index += BEACON_INTERVAL_LEN + CAP_INFO_LEN;
+		index += BEACON_INTERVAL_LEN + CAP_INFO_LEN;
 
-		pu8TimElm = get_tim_elm(pu8msa, rx_len + FCS_LEN, u8index);
-		if (pu8TimElm)
-			network_info->u8DtimPeriod = pu8TimElm[3];
-		pu8IEs = &pu8msa[MAC_HDR_LEN + TIME_STAMP_LEN + BEACON_INTERVAL_LEN + CAP_INFO_LEN];
-		u16IEsLen = rx_len - (MAC_HDR_LEN + TIME_STAMP_LEN + BEACON_INTERVAL_LEN + CAP_INFO_LEN);
+		tim_elm = get_tim_elm(msa, rx_len + FCS_LEN, index);
+		if (tim_elm)
+			network_info->u8DtimPeriod = tim_elm[3];
+		ies = &msa[MAC_HDR_LEN + TIME_STAMP_LEN + BEACON_INTERVAL_LEN + CAP_INFO_LEN];
+		ies_len = rx_len - (MAC_HDR_LEN + TIME_STAMP_LEN + BEACON_INTERVAL_LEN + CAP_INFO_LEN);
 
-		if (u16IEsLen > 0) {
-			network_info->pu8IEs = kmemdup(pu8IEs, u16IEsLen,
+		if (ies_len > 0) {
+			network_info->pu8IEs = kmemdup(ies, ies_len,
 						       GFP_KERNEL);
 			if (!network_info->pu8IEs)
 				return -ENOMEM;
 		}
-		network_info->u16IEsLen = u16IEsLen;
+		network_info->u16IEsLen = ies_len;
 	}
 
 	*ret_network_info = network_info;
-- 
1.9.1

