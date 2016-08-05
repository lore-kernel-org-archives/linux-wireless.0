Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web01.01d.eu ([5.200.27.195]:50913 "EHLO web01.01d.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S942603AbcHEUPT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Aug 2016 16:15:19 -0400
From: Shiva Kerdel <shiva@exdev.nl>
To: Larry.Finger@lwfinger.net
Cc: Jes.Sorensen@redhat.com, gregkh@linuxfoundation.org,
	amsfield22@gmail.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Shiva Kerdel <shiva@exdev.nl>
Subject: [PATCH] Staging: rtl8723au: rtw_ieee80211: Fixed operators spacing style issues
Date: Fri,  5 Aug 2016 22:14:41 +0200
Message-Id: <20160805201441.4269-1-shiva@exdev.nl> (sfid-20160805_221600_779467_ABFABA5C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixed spaces around operators to fix their coding style issues.

Signed-off-by: Shiva Kerdel <shiva@exdev.nl>
---
 drivers/staging/rtl8723au/core/rtw_ieee80211.c | 80 +++++++++++++-------------
 1 file changed, 40 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_ieee80211.c b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
index 07a6490..9fa0ef1 100644
--- a/drivers/staging/rtl8723au/core/rtw_ieee80211.c
+++ b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
@@ -65,7 +65,7 @@ static u8 WIFI_OFDMRATES[] = {
 
 int rtw_get_bit_value_from_ieee_value23a(u8 val)
 {
-	unsigned char dot11_rate_table[]=
+	unsigned char dot11_rate_table[] =
 		{2, 4, 11, 22, 12, 18, 24, 36, 48, 72, 96, 108, 0};
 
 	int i = 0;
@@ -140,7 +140,7 @@ u8 *rtw_set_ie23a(u8 *pbuf, int index, uint len, const u8 *source, uint *frlen)
 	return pbuf + len + 2;
 }
 
-inline u8 *rtw_set_ie23a_ch_switch (u8 *buf, u32 *buf_len, u8 ch_switch_mode,
+inline u8 *rtw_set_ie23a_ch_switch(u8 *buf, u32 *buf_len, u8 ch_switch_mode,
 				u8 new_ch, u8 ch_switch_cnt)
 {
 	u8 ie_data[3];
@@ -230,14 +230,14 @@ u8 *rtw_get_ie23a_ex(u8 *in_ie, uint in_len, u8 eid, u8 *oui, u8 oui_len,
 
 	while (cnt < in_len) {
 		if (eid == in_ie[cnt] &&
-		    (!oui || !memcmp(&in_ie[cnt+2], oui, oui_len))) {
+		    (!oui || !memcmp(&in_ie[cnt + 2], oui, oui_len))) {
 			target_ie = &in_ie[cnt];
 
 			if (ie)
-				memcpy(ie, &in_ie[cnt], in_ie[cnt+1]+2);
+				memcpy(ie, &in_ie[cnt], in_ie[cnt + 1] + 2);
 
 			if (ielen)
-				*ielen = in_ie[cnt+1]+2;
+				*ielen = in_ie[cnt + 1] + 2;
 			break;
 		} else {
 			cnt += in_ie[cnt + 1] + 2; /* goto next */
@@ -331,7 +331,7 @@ uint rtw_get_rateset_len23a(u8 *rateset)
 {
 	uint i = 0;
 
-	while(1) {
+	while (1) {
 		if (rateset[i] == 0)
 			break;
 
@@ -378,7 +378,7 @@ int rtw_generate_ie23a(struct registry_priv *pregistrypriv)
 		wireless_mode = pregistrypriv->wireless_mode;
 	}
 
-	rtw_set_supported_rate23a(pdev_network->SupportedRates, wireless_mode) ;
+	rtw_set_supported_rate23a(pdev_network->SupportedRates, wireless_mode);
 
 	rateLen = rtw_get_rateset_len23a(pdev_network->SupportedRates);
 
@@ -533,7 +533,7 @@ int rtw_parse_wpa2_ie23a(const u8 *rsn_ie, int rsn_ie_len, int *group_cipher,
 		return _FAIL;
 	}
 
-	if (*rsn_ie != WLAN_EID_RSN || *(rsn_ie+1) != (u8)(rsn_ie_len - 2)) {
+	if (*rsn_ie != WLAN_EID_RSN || *(rsn_ie + 1) != (u8)(rsn_ie_len - 2)) {
 		return _FAIL;
 	}
 
@@ -791,64 +791,64 @@ u16 rtw_mcs_rate23a(u8 rf_type, u8 bw_40MHz, u8 short_GI_20, u8 short_GI_40,
 
 	if (rf_type == RF_1T1R) {
 		if (mcs->rx_mask[0] & BIT(7))
-			max_rate = (bw_40MHz) ? ((short_GI_40)?1500:1350):
-				((short_GI_20)?722:650);
+			max_rate = (bw_40MHz) ? ((short_GI_40) ? 1500 : 1350) :
+				((short_GI_20) ? 722 : 650);
 		else if (mcs->rx_mask[0] & BIT(6))
-			max_rate = (bw_40MHz) ? ((short_GI_40)?1350:1215):
-				((short_GI_20)?650:585);
+			max_rate = (bw_40MHz) ? ((short_GI_40) ? 1350 : 1215) :
+				((short_GI_20) ? 650 : 585);
 		else if (mcs->rx_mask[0] & BIT(5))
-			max_rate = (bw_40MHz) ? ((short_GI_40)?1200:1080):
-				((short_GI_20)?578:520);
+			max_rate = (bw_40MHz) ? ((short_GI_40) ? 1200 : 1080) :
+				((short_GI_20) ? 578 : 520);
 		else if (mcs->rx_mask[0] & BIT(4))
-			max_rate = (bw_40MHz) ? ((short_GI_40)?900:810):
-				((short_GI_20)?433:390);
+			max_rate = (bw_40MHz) ? ((short_GI_40) ? 900 : 810) :
+				((short_GI_20) ? 433 : 390);
 		else if (mcs->rx_mask[0] & BIT(3))
-			max_rate = (bw_40MHz) ? ((short_GI_40)?600:540):
-				((short_GI_20)?289:260);
+			max_rate = (bw_40MHz) ? ((short_GI_40) ? 600 : 540) :
+				((short_GI_20) ? 289 : 260);
 		else if (mcs->rx_mask[0] & BIT(2))
-			max_rate = (bw_40MHz) ? ((short_GI_40)?450:405):
-				((short_GI_20)?217:195);
+			max_rate = (bw_40MHz) ? ((short_GI_40) ? 450 : 405) :
+				((short_GI_20) ? 217 : 195);
 		else if (mcs->rx_mask[0] & BIT(1))
-			max_rate = (bw_40MHz) ? ((short_GI_40)?300:270):
-				((short_GI_20)?144:130);
+			max_rate = (bw_40MHz) ? ((short_GI_40) ? 300 : 270) :
+				((short_GI_20) ? 144 : 130);
 		else if (mcs->rx_mask[0] & BIT(0))
-			max_rate = (bw_40MHz) ? ((short_GI_40)?150:135):
-				((short_GI_20)?72:65);
+			max_rate = (bw_40MHz) ? ((short_GI_40) ? 150 : 135) :
+				((short_GI_20) ? 72 : 65);
 	} else {
 		if (mcs->rx_mask[1]) {
 			if (mcs->rx_mask[1] & BIT(7))
-				max_rate = (bw_40MHz) ? ((short_GI_40)?3000:2700):((short_GI_20)?1444:1300);
+				max_rate = (bw_40MHz) ? ((short_GI_40) ? 3000 : 2700) : ((short_GI_20) ? 1444 : 1300);
 			else if (mcs->rx_mask[1] & BIT(6))
-				max_rate = (bw_40MHz) ? ((short_GI_40)?2700:2430):((short_GI_20)?1300:1170);
+				max_rate = (bw_40MHz) ? ((short_GI_40) ? 2700 : 2430) : ((short_GI_20) ? 1300 : 1170);
 			else if (mcs->rx_mask[1] & BIT(5))
-				max_rate = (bw_40MHz) ? ((short_GI_40)?2400:2160):((short_GI_20)?1156:1040);
+				max_rate = (bw_40MHz) ? ((short_GI_40) ? 2400 : 2160) : ((short_GI_20) ? 1156 : 1040);
 			else if (mcs->rx_mask[1] & BIT(4))
-				max_rate = (bw_40MHz) ? ((short_GI_40)?1800:1620):((short_GI_20)?867:780);
+				max_rate = (bw_40MHz) ? ((short_GI_40) ? 1800 : 1620) : ((short_GI_20) ? 867 : 780);
 			else if (mcs->rx_mask[1] & BIT(3))
-				max_rate = (bw_40MHz) ? ((short_GI_40)?1200:1080):((short_GI_20)?578:520);
+				max_rate = (bw_40MHz) ? ((short_GI_40) ? 1200 : 1080) : ((short_GI_20) ? 578 : 520);
 			else if (mcs->rx_mask[1] & BIT(2))
-				max_rate = (bw_40MHz) ? ((short_GI_40)?900:810):((short_GI_20)?433:390);
+				max_rate = (bw_40MHz) ? ((short_GI_40) ? 900 : 810) : ((short_GI_20) ? 433 : 390);
 			else if (mcs->rx_mask[1] & BIT(1))
-				max_rate = (bw_40MHz) ? ((short_GI_40)?600:540):((short_GI_20)?289:260);
+				max_rate = (bw_40MHz) ? ((short_GI_40) ? 600 : 540) : ((short_GI_20) ? 289 : 260);
 			else if (mcs->rx_mask[1] & BIT(0))
-				max_rate = (bw_40MHz) ? ((short_GI_40)?300:270):((short_GI_20)?144:130);
+				max_rate = (bw_40MHz) ? ((short_GI_40) ? 300 : 270) : ((short_GI_20) ? 144 : 130);
 		} else {
 			if (mcs->rx_mask[0] & BIT(7))
-				max_rate = (bw_40MHz) ? ((short_GI_40)?1500:1350):((short_GI_20)?722:650);
+				max_rate = (bw_40MHz) ? ((short_GI_40) ? 1500 : 1350) : ((short_GI_20) ? 722 : 650);
 			else if (mcs->rx_mask[0] & BIT(6))
-				max_rate = (bw_40MHz) ? ((short_GI_40)?1350:1215):((short_GI_20)?650:585);
+				max_rate = (bw_40MHz) ? ((short_GI_40) ? 1350 : 1215) : ((short_GI_20) ? 650 : 585);
 			else if (mcs->rx_mask[0] & BIT(5))
-				max_rate = (bw_40MHz) ? ((short_GI_40)?1200:1080):((short_GI_20)?578:520);
+				max_rate = (bw_40MHz) ? ((short_GI_40) ? 1200 : 1080) : ((short_GI_20) ? 578 : 520);
 			else if (mcs->rx_mask[0] & BIT(4))
-				max_rate = (bw_40MHz) ? ((short_GI_40)?900:810):((short_GI_20)?433:390);
+				max_rate = (bw_40MHz) ? ((short_GI_40) ? 900 : 810) : ((short_GI_20) ? 433 : 390);
 			else if (mcs->rx_mask[0] & BIT(3))
-				max_rate = (bw_40MHz) ? ((short_GI_40)?600:540):((short_GI_20)?289:260);
+				max_rate = (bw_40MHz) ? ((short_GI_40) ? 600 : 540) : ((short_GI_20) ? 289 : 260);
 			else if (mcs->rx_mask[0] & BIT(2))
-				max_rate = (bw_40MHz) ? ((short_GI_40)?450:405):((short_GI_20)?217:195);
+				max_rate = (bw_40MHz) ? ((short_GI_40) ? 450 : 405) : ((short_GI_20) ? 217 : 195);
 			else if (mcs->rx_mask[0] & BIT(1))
-				max_rate = (bw_40MHz) ? ((short_GI_40)?300:270):((short_GI_20)?144:130);
+				max_rate = (bw_40MHz) ? ((short_GI_40) ? 300 : 270) : ((short_GI_20) ? 144 : 130);
 			else if (mcs->rx_mask[0] & BIT(0))
-				max_rate = (bw_40MHz) ? ((short_GI_40)?150:135):((short_GI_20)?72:65);
+				max_rate = (bw_40MHz) ? ((short_GI_40) ? 150 : 135) : ((short_GI_20) ? 72 : 65);
 		}
 	}
 	return max_rate;
-- 
2.9.2

