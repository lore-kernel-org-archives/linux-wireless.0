Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33378 "EHLO
	mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbcFYTx4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jun 2016 15:53:56 -0400
Received: by mail-oi0-f65.google.com with SMTP id w141so24214448oia.0
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jun 2016 12:53:55 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 10/10] rtlwifi: rtl8723ae: Clean up the hardware info routine
Date: Sat, 25 Jun 2016 14:53:41 -0500
Message-Id: <1466884421-722-11-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160625_215359_661104_39926833)
In-Reply-To: <1466884421-722-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1466884421-722-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This driver contains some complicated if ... else if ... else constructions.
These are replaced by switch statements to improve readability.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 .../net/wireless/realtek/rtlwifi/rtl8723ae/hw.c    | 210 +++++++++++----------
 1 file changed, 107 insertions(+), 103 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
index 112443b..3e562f3 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
@@ -1656,113 +1656,117 @@ static void _rtl8723e_read_adapter_info(struct ieee80211_hw *hw,
 	if (rtlhal->oem_id == RT_CID_DEFAULT) {
 		switch (rtlefuse->eeprom_oemid) {
 		case EEPROM_CID_DEFAULT:
-			if (rtlefuse->eeprom_did == 0x8176) {
-				if (CHK_SVID_SMID(0x10EC, 0x6151) ||
-				    CHK_SVID_SMID(0x10EC, 0x6152) ||
-				    CHK_SVID_SMID(0x10EC, 0x6154) ||
-				    CHK_SVID_SMID(0x10EC, 0x6155) ||
-				    CHK_SVID_SMID(0x10EC, 0x6177) ||
-				    CHK_SVID_SMID(0x10EC, 0x6178) ||
-				    CHK_SVID_SMID(0x10EC, 0x6179) ||
-				    CHK_SVID_SMID(0x10EC, 0x6180) ||
-				    CHK_SVID_SMID(0x10EC, 0x7151) ||
-				    CHK_SVID_SMID(0x10EC, 0x7152) ||
-				    CHK_SVID_SMID(0x10EC, 0x7154) ||
-				    CHK_SVID_SMID(0x10EC, 0x7155) ||
-				    CHK_SVID_SMID(0x10EC, 0x7177) ||
-				    CHK_SVID_SMID(0x10EC, 0x7178) ||
-				    CHK_SVID_SMID(0x10EC, 0x7179) ||
-				    CHK_SVID_SMID(0x10EC, 0x7180) ||
-				    CHK_SVID_SMID(0x10EC, 0x8151) ||
-				    CHK_SVID_SMID(0x10EC, 0x8152) ||
-				    CHK_SVID_SMID(0x10EC, 0x8154) ||
-				    CHK_SVID_SMID(0x10EC, 0x8155) ||
-				    CHK_SVID_SMID(0x10EC, 0x8181) ||
-				    CHK_SVID_SMID(0x10EC, 0x8182) ||
-				    CHK_SVID_SMID(0x10EC, 0x8184) ||
-				    CHK_SVID_SMID(0x10EC, 0x8185) ||
-				    CHK_SVID_SMID(0x10EC, 0x9151) ||
-				    CHK_SVID_SMID(0x10EC, 0x9152) ||
-				    CHK_SVID_SMID(0x10EC, 0x9154) ||
-				    CHK_SVID_SMID(0x10EC, 0x9155) ||
-				    CHK_SVID_SMID(0x10EC, 0x9181) ||
-				    CHK_SVID_SMID(0x10EC, 0x9182) ||
-				    CHK_SVID_SMID(0x10EC, 0x9184) ||
-				    CHK_SVID_SMID(0x10EC, 0x9185))
-					rtlhal->oem_id = RT_CID_TOSHIBA;
-				else if (rtlefuse->eeprom_svid == 0x1025)
+			rtlhal->oem_id = RT_CID_DEFAULT;
+			switch (rtlefuse->eeprom_did) {
+			case 0x8176:
+				switch (rtlefuse->eeprom_svid) {
+				case 0x10EC:
+					switch (rtlefuse->eeprom_smid) {
+					case 0x6151 ... 0x6152:
+					case 0x6154 ... 0x6155:
+					case 0x6177 ... 0x6180:
+					case 0x7151 ... 0x7152:
+					case 0x7154 ... 0x7155:
+					case 0x7177 ... 0x7180:
+					case 0x8151 ... 0x8152:
+					case 0x8154 ... 0x8155:
+					case 0x8181 ... 0x8182:
+					case 0x8184 ... 0x8185:
+					case 0x9151 ... 0x9152:
+					case 0x9154 ... 0x9155:
+					case 0x9181 ... 0x9182:
+					case 0x9184 ... 0x9185:
+						rtlhal->oem_id = RT_CID_TOSHIBA;
+						break;
+					case 0x6191 ... 0x6193:
+					case 0x7191 ... 0x7193:
+					case 0x8191 ... 0x8193:
+					case 0x9191 ... 0x9193:
+						rtlhal->oem_id = RT_CID_819X_SAMSUNG;
+						break;
+					case 0x8197:
+					case 0x9196:
+						rtlhal->oem_id = RT_CID_819X_CLEVO;
+						break;
+					case 0x8203:
+						rtlhal->oem_id = RT_CID_819X_PRONETS;
+						break;
+					case 0x8195:
+					case 0x9195:
+					case 0x7194:
+					case 0x8200 ... 0x8202:
+					case 0x9200:
+						rtlhal->oem_id = RT_CID_819X_LENOVO;
+						break;
+					}
+				case 0x1025:
 					rtlhal->oem_id = RT_CID_819X_ACER;
-				else if (CHK_SVID_SMID(0x10EC, 0x6191) ||
-					 CHK_SVID_SMID(0x10EC, 0x6192) ||
-					 CHK_SVID_SMID(0x10EC, 0x6193) ||
-					 CHK_SVID_SMID(0x10EC, 0x7191) ||
-					 CHK_SVID_SMID(0x10EC, 0x7192) ||
-					 CHK_SVID_SMID(0x10EC, 0x7193) ||
-					 CHK_SVID_SMID(0x10EC, 0x8191) ||
-					 CHK_SVID_SMID(0x10EC, 0x8192) ||
-					 CHK_SVID_SMID(0x10EC, 0x8193) ||
-					 CHK_SVID_SMID(0x10EC, 0x9191) ||
-					 CHK_SVID_SMID(0x10EC, 0x9192) ||
-					 CHK_SVID_SMID(0x10EC, 0x9193))
-					rtlhal->oem_id = RT_CID_819X_SAMSUNG;
-				else if (CHK_SVID_SMID(0x10EC, 0x8195) ||
-					 CHK_SVID_SMID(0x10EC, 0x9195) ||
-					 CHK_SVID_SMID(0x10EC, 0x7194) ||
-					 CHK_SVID_SMID(0x10EC, 0x8200) ||
-					 CHK_SVID_SMID(0x10EC, 0x8201) ||
-					 CHK_SVID_SMID(0x10EC, 0x8202) ||
-					 CHK_SVID_SMID(0x10EC, 0x9200))
-					rtlhal->oem_id = RT_CID_819X_LENOVO;
-				else if (CHK_SVID_SMID(0x10EC, 0x8197) ||
-					 CHK_SVID_SMID(0x10EC, 0x9196))
-					rtlhal->oem_id = RT_CID_819X_CLEVO;
-				else if (CHK_SVID_SMID(0x1028, 0x8194) ||
-					 CHK_SVID_SMID(0x1028, 0x8198) ||
-					 CHK_SVID_SMID(0x1028, 0x9197) ||
-					 CHK_SVID_SMID(0x1028, 0x9198))
-					rtlhal->oem_id = RT_CID_819X_DELL;
-				else if (CHK_SVID_SMID(0x103C, 0x1629))
-					rtlhal->oem_id = RT_CID_819X_HP;
-				else if (CHK_SVID_SMID(0x1A32, 0x2315))
-					rtlhal->oem_id = RT_CID_819X_QMI;
-				else if (CHK_SVID_SMID(0x10EC, 0x8203))
-					rtlhal->oem_id = RT_CID_819X_PRONETS;
-				else if (CHK_SVID_SMID(0x1043, 0x84B5))
-					rtlhal->oem_id =
-						 RT_CID_819X_EDIMAX_ASUS;
-				else
-					rtlhal->oem_id = RT_CID_DEFAULT;
-			} else if (rtlefuse->eeprom_did == 0x8178) {
-				if (CHK_SVID_SMID(0x10EC, 0x6181) ||
-				    CHK_SVID_SMID(0x10EC, 0x6182) ||
-				    CHK_SVID_SMID(0x10EC, 0x6184) ||
-				    CHK_SVID_SMID(0x10EC, 0x6185) ||
-				    CHK_SVID_SMID(0x10EC, 0x7181) ||
-				    CHK_SVID_SMID(0x10EC, 0x7182) ||
-				    CHK_SVID_SMID(0x10EC, 0x7184) ||
-				    CHK_SVID_SMID(0x10EC, 0x7185) ||
-				    CHK_SVID_SMID(0x10EC, 0x8181) ||
-				    CHK_SVID_SMID(0x10EC, 0x8182) ||
-				    CHK_SVID_SMID(0x10EC, 0x8184) ||
-				    CHK_SVID_SMID(0x10EC, 0x8185) ||
-				    CHK_SVID_SMID(0x10EC, 0x9181) ||
-				    CHK_SVID_SMID(0x10EC, 0x9182) ||
-				    CHK_SVID_SMID(0x10EC, 0x9184) ||
-				    CHK_SVID_SMID(0x10EC, 0x9185))
-					rtlhal->oem_id = RT_CID_TOSHIBA;
-				else if (rtlefuse->eeprom_svid == 0x1025)
+					break;
+				case 0x1028:
+					switch (rtlefuse->eeprom_smid) {
+					case 0x8194:
+					case 0x8198:
+					case 0x9197 ... 0x9198:
+						rtlhal->oem_id =
+							RT_CID_819X_DELL;
+						break;
+					}
+					break;
+				case 0x103C:
+					switch (rtlefuse->eeprom_smid) {
+					case 0x1629:
+						rtlhal->oem_id = RT_CID_819X_HP;
+					}
+					break;
+				case 0x1A32:
+					switch (rtlefuse->eeprom_smid) {
+					case 0x2315:
+						rtlhal->oem_id =
+							RT_CID_819X_QMI;
+						break;
+					}
+					break;
+				case 0x1043:
+					switch (rtlefuse->eeprom_smid) {
+					case 0x84B5:
+						rtlhal->oem_id =
+							RT_CID_819X_EDIMAX_ASUS;
+					}
+					break;
+				}
+			case 0x8178:
+				switch (rtlefuse->eeprom_svid) {
+				case 0x10ec:
+					switch (rtlefuse->eeprom_smid) {
+					case 0x6181 ... 0x6182:
+					case 0x6184 ... 0x6185:
+					case 0x7181 ... 0x7182:
+					case 0x7184 ... 0x7185:
+					case 0x8181 ... 0x8182:
+					case 0x8184 ... 0x8185:
+					case 0x9181 ... 0x9182:
+					case 0x9184 ... 0x9185:
+						rtlhal->oem_id = RT_CID_TOSHIBA;
+						break;
+					case 0x8186:
+						rtlhal->oem_id =
+							RT_CID_819X_PRONETS;
+						break;
+					}
+					break;
+				case 0x1025:
 					rtlhal->oem_id = RT_CID_819X_ACER;
-				else if (CHK_SVID_SMID(0x10EC, 0x8186))
-					rtlhal->oem_id = RT_CID_819X_PRONETS;
-				else if (CHK_SVID_SMID(0x1043, 0x8486))
-					rtlhal->oem_id =
+					break;
+				case 0x1043:
+					switch (rtlefuse->eeprom_smid) {
+					case 0x8486:
+						rtlhal->oem_id =
 						     RT_CID_819X_EDIMAX_ASUS;
-				else
-					rtlhal->oem_id = RT_CID_DEFAULT;
-			} else {
-				rtlhal->oem_id = RT_CID_DEFAULT;
+					}
+					break;
+				}
+				break;
 			}
-			break;
 		case EEPROM_CID_TOSHIBA:
 			rtlhal->oem_id = RT_CID_TOSHIBA;
 			break;
-- 
2.1.4

