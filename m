Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:46871 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755910AbeDYRTi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 13:19:38 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 06/21] staging: wilc1000: remove inner {} in wilc_parse_network_info()
Date: Wed, 25 Apr 2018 22:48:11 +0530
Message-ID: <1524676706-13179-7-git-send-email-ajay.kathat@microchip.com> (sfid-20180425_191944_006203_3E43C7EB)
In-Reply-To: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
References: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to remove the unnecessary {/**/} block in
wilc_parse_network_info().

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 77 ++++++++++++++---------------
 1 file changed, 37 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 5bc9d78..43b0b21 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -274,6 +274,14 @@ s32 wilc_parse_network_info(u8 *msg_buffer,
 	u8 msg_type = 0;
 	u16 wid_len  = 0;
 	u8 *wid_val = NULL;
+	u8 *msa = NULL;
+	u16 rx_len = 0;
+	u8 *tim_elm = NULL;
+	u8 *ies = NULL;
+	u16 ies_len = 0;
+	u8 index = 0;
+	u32 tsf_lo;
+	u32 tsf_hi;
 
 	msg_type = msg_buffer[0];
 
@@ -283,60 +291,49 @@ s32 wilc_parse_network_info(u8 *msg_buffer,
 	wid_len = MAKE_WORD16(msg_buffer[6], msg_buffer[7]);
 	wid_val = &msg_buffer[8];
 
-	{
-		u8 *msa = NULL;
-		u16 rx_len = 0;
-		u8 *tim_elm = NULL;
-		u8 *ies = NULL;
-		u16 ies_len = 0;
-		u8 index = 0;
-		u32 tsf_lo;
-		u32 tsf_hi;
-
-		network_info = kzalloc(sizeof(*network_info), GFP_KERNEL);
-		if (!network_info)
-			return -ENOMEM;
+	network_info = kzalloc(sizeof(*network_info), GFP_KERNEL);
+	if (!network_info)
+		return -ENOMEM;
 
-		network_info->rssi = wid_val[0];
+	network_info->rssi = wid_val[0];
 
-		msa = &wid_val[1];
+	msa = &wid_val[1];
 
-		rx_len = wid_len - 1;
-		network_info->cap_info = get_cap_info(msa);
-		network_info->tsf_lo = get_beacon_timestamp_lo(msa);
+	rx_len = wid_len - 1;
+	network_info->cap_info = get_cap_info(msa);
+	network_info->tsf_lo = get_beacon_timestamp_lo(msa);
 
-		tsf_lo = get_beacon_timestamp_lo(msa);
-		tsf_hi = get_beacon_timestamp_hi(msa);
+	tsf_lo = get_beacon_timestamp_lo(msa);
+	tsf_hi = get_beacon_timestamp_hi(msa);
 
-		network_info->tsf_hi = tsf_lo | ((u64)tsf_hi << 32);
+	network_info->tsf_hi = tsf_lo | ((u64)tsf_hi << 32);
 
-		get_ssid(msa, network_info->ssid, &network_info->ssid_len);
-		get_BSSID(msa, network_info->bssid);
+	get_ssid(msa, network_info->ssid, &network_info->ssid_len);
+	get_BSSID(msa, network_info->bssid);
 
-		network_info->ch = get_current_channel_802_11n(msa, rx_len
-							       + FCS_LEN);
+	network_info->ch = get_current_channel_802_11n(msa, rx_len
+						       + FCS_LEN);
 
-		index = MAC_HDR_LEN + TIME_STAMP_LEN;
+	index = MAC_HDR_LEN + TIME_STAMP_LEN;
 
-		network_info->beacon_period = get_beacon_period(msa + index);
+	network_info->beacon_period = get_beacon_period(msa + index);
 
-		index += BEACON_INTERVAL_LEN + CAP_INFO_LEN;
+	index += BEACON_INTERVAL_LEN + CAP_INFO_LEN;
 
-		tim_elm = get_tim_elm(msa, rx_len + FCS_LEN, index);
-		if (tim_elm)
-			network_info->dtim_period = tim_elm[3];
-		ies = &msa[TAG_PARAM_OFFSET];
-		ies_len = rx_len - TAG_PARAM_OFFSET;
+	tim_elm = get_tim_elm(msa, rx_len + FCS_LEN, index);
+	if (tim_elm)
+		network_info->dtim_period = tim_elm[3];
+	ies = &msa[TAG_PARAM_OFFSET];
+	ies_len = rx_len - TAG_PARAM_OFFSET;
 
-		if (ies_len > 0) {
-			network_info->ies = kmemdup(ies, ies_len, GFP_KERNEL);
-			if (!network_info->ies) {
-				kfree(network_info);
-				return -ENOMEM;
-			}
+	if (ies_len > 0) {
+		network_info->ies = kmemdup(ies, ies_len, GFP_KERNEL);
+		if (!network_info->ies) {
+			kfree(network_info);
+			return -ENOMEM;
 		}
-		network_info->ies_len = ies_len;
 	}
+	network_info->ies_len = ies_len;
 
 	*ret_network_info = network_info;
 
-- 
2.7.4
