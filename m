Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33352 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbcFYTxv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jun 2016 15:53:51 -0400
Received: by mail-oi0-f68.google.com with SMTP id w141so24214251oia.0
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jun 2016 12:53:51 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 04/10] rtlwifi: rtl8188ee: Convert driver to use common hardware info routine
Date: Sat, 25 Jun 2016 14:53:35 -0500
Message-Id: <1466884421-722-5-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160625_215409_731913_A96BBC10)
In-Reply-To: <1466884421-722-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1466884421-722-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver for RTL8188EE chips is converted to use the common routine
for getting the hardware information.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 .../net/wireless/realtek/rtlwifi/rtl8188ee/hw.c    | 76 ++++------------------
 1 file changed, 13 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
index e26a233..bf35b23 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
@@ -1835,76 +1835,24 @@ static void _rtl88ee_read_adapter_info(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	u16 i, usvalue;
-	u8 hwinfo[HWSET_MAX_SIZE];
-	u16 eeprom_id;
-
-	switch (rtlefuse->epromtype) {
-	case EEPROM_BOOT_EFUSE:
-		rtl_efuse_shadow_map_update(hw);
-		break;
-
-	case EEPROM_93C46:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "RTL819X Not boot from eeprom, check it !!");
+	int params[] = {RTL8188E_EEPROM_ID, EEPROM_VID, EEPROM_DID,
+			EEPROM_SVID, EEPROM_SMID, EEPROM_MAC_ADDR,
+			EEPROM_CHANNELPLAN, EEPROM_VERSION, EEPROM_CUSTOMER_ID,
+			COUNTRY_CODE_WORLD_WIDE_13};
+	u8 *hwinfo;
+
+	hwinfo = kzalloc(HWSET_MAX_SIZE, GFP_KERNEL);
+	if (!hwinfo)
 		return;
 
-	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "boot from neither eeprom nor efuse, check it !!");
-		return;
-	}
-	memcpy(hwinfo, &rtlefuse->efuse_map[EFUSE_INIT_MAP][0], HWSET_MAX_SIZE);
-
-	RT_PRINT_DATA(rtlpriv, COMP_INIT, DBG_DMESG, "MAP\n",
-		      hwinfo, HWSET_MAX_SIZE);
-
-	eeprom_id = *((u16 *)&hwinfo[0]);
-	if (eeprom_id != RTL8188E_EEPROM_ID) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
-			 "EEPROM ID(%#x) is invalid!!\n", eeprom_id);
-		rtlefuse->autoload_failflag = true;
-	} else {
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "Autoload OK\n");
-		rtlefuse->autoload_failflag = false;
-	}
+	if (rtl_get_hwinfo(hw, rtlpriv, HWSET_MAX_SIZE, hwinfo, params));
+		goto exit;
 
-	if (rtlefuse->autoload_failflag == true)
-		return;
-	/*VID DID SVID SDID*/
-	rtlefuse->eeprom_vid = *(u16 *)&hwinfo[EEPROM_VID];
-	rtlefuse->eeprom_did = *(u16 *)&hwinfo[EEPROM_DID];
-	rtlefuse->eeprom_svid = *(u16 *)&hwinfo[EEPROM_SVID];
-	rtlefuse->eeprom_smid = *(u16 *)&hwinfo[EEPROM_SMID];
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
-		 "EEPROMId = 0x%4x\n", eeprom_id);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
-		 "EEPROM VID = 0x%4x\n", rtlefuse->eeprom_vid);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
-		 "EEPROM DID = 0x%4x\n", rtlefuse->eeprom_did);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
-		 "EEPROM SVID = 0x%4x\n", rtlefuse->eeprom_svid);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
-		 "EEPROM SMID = 0x%4x\n", rtlefuse->eeprom_smid);
-	/*customer ID*/
-	rtlefuse->eeprom_oemid = hwinfo[EEPROM_CUSTOMER_ID];
 	if (rtlefuse->eeprom_oemid == 0xFF)
-		rtlefuse->eeprom_oemid =	0;
+		rtlefuse->eeprom_oemid = 0;
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
 		 "EEPROM Customer ID: 0x%2x\n", rtlefuse->eeprom_oemid);
-	/*EEPROM version*/
-	rtlefuse->eeprom_version = *(u16 *)&hwinfo[EEPROM_VERSION];
-	/*mac address*/
-	for (i = 0; i < 6; i += 2) {
-		usvalue = *(u16 *)&hwinfo[EEPROM_MAC_ADDR + i];
-		*((u16 *)(&rtlefuse->dev_addr[i])) = usvalue;
-	}
-
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		 "dev_addr: %pM\n", rtlefuse->dev_addr);
-	/*channel plan */
-	rtlefuse->eeprom_channelplan = hwinfo[EEPROM_CHANNELPLAN];
 	/* set channel plan from efuse */
 	rtlefuse->channel_plan = rtlefuse->eeprom_channelplan;
 	/*tx power*/
@@ -1978,6 +1926,8 @@ static void _rtl88ee_read_adapter_info(struct ieee80211_hw *hw)
 
 		}
 	}
+exit:
+	kfree(hwinfo);
 }
 
 static void _rtl88ee_hal_customized_behavior(struct ieee80211_hw *hw)
-- 
2.1.4

