Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35426 "EHLO
	mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311AbcGEPIb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2016 11:08:31 -0400
Received: by mail-oi0-f65.google.com with SMTP id d132so27968902oig.2
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jul 2016 08:08:31 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 05/10] rtlwifi: rtl8192ee: Convert driver to use common hardware info routine
Date: Tue,  5 Jul 2016 10:08:10 -0500
Message-Id: <1467731295-25850-6-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160705_170853_911466_610D68B1)
In-Reply-To: <1467731295-25850-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1467731295-25850-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver for RTL8192EE chips is converted to use the common routine
for getting the hardware information.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Arnd Bergmann <arnd@arndb.de>
---
V2 - Fixes bug found after V1 was submitted.
V3 - No changes.

This patch requires ("rtlwifi: Add missing newlines to RT_TRACE calls")
	submitted by Joe Perches.
---
 .../net/wireless/realtek/rtlwifi/rtl8192ee/hw.c    | 73 ++++------------------
 1 file changed, 12 insertions(+), 61 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
index 9d1ecba..b07af8d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
@@ -2098,75 +2098,24 @@ static void _rtl92ee_read_adapter_info(struct ieee80211_hw *hw)
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
-			 "RTL819X Not boot from eeprom, check it !!\n");
-		return;
-
-	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "boot from neither eeprom nor efuse, check it !!\n");
+	int params[] = {RTL8192E_EEPROM_ID, EEPROM_VID, EEPROM_DID,
+			EEPROM_SVID, EEPROM_SMID, EEPROM_MAC_ADDR,
+			EEPROM_CHANNELPLAN, EEPROM_VERSION, EEPROM_CUSTOMER_ID,
+			COUNTRY_CODE_WORLD_WIDE_13};
+	u8 *hwinfo;
+
+	hwinfo = kzalloc(HWSET_MAX_SIZE, GFP_KERNEL);
+	if (!hwinfo)
 		return;
-	}
-	memcpy(hwinfo, &rtlefuse->efuse_map[EFUSE_INIT_MAP][0], HWSET_MAX_SIZE);
 
-	RT_PRINT_DATA(rtlpriv, COMP_INIT, DBG_DMESG, "MAP\n",
-		      hwinfo, HWSET_MAX_SIZE);
+	if (rtl_get_hwinfo(hw, rtlpriv, HWSET_MAX_SIZE, hwinfo, params))
+		goto exit;
 
-	eeprom_id = *((u16 *)&hwinfo[0]);
-	if (eeprom_id != RTL8192E_EEPROM_ID) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
-			 "EEPROM ID(%#x) is invalid!!\n", eeprom_id);
-		rtlefuse->autoload_failflag = true;
-	} else {
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "Autoload OK\n");
-		rtlefuse->autoload_failflag = false;
-	}
-
-	if (rtlefuse->autoload_failflag)
-		return;
-	/*VID DID SVID SDID*/
-	rtlefuse->eeprom_vid = *(u16 *)&hwinfo[EEPROM_VID];
-	rtlefuse->eeprom_did = *(u16 *)&hwinfo[EEPROM_DID];
-	rtlefuse->eeprom_svid = *(u16 *)&hwinfo[EEPROM_SVID];
-	rtlefuse->eeprom_smid = *(u16 *)&hwinfo[EEPROM_SMID];
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "EEPROMId = 0x%4x\n", eeprom_id);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
-		 "EEPROM VID = 0x%4x\n", rtlefuse->eeprom_vid);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
-		 "EEPROM DID = 0x%4x\n", rtlefuse->eeprom_did);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
-		 "EEPROM SVID = 0x%4x\n", rtlefuse->eeprom_svid);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
-		 "EEPROM SMID = 0x%4x\n", rtlefuse->eeprom_smid);
-	/*customer ID*/
-	rtlefuse->eeprom_oemid = *(u8 *)&hwinfo[EEPROM_CUSTOMER_ID];
 	if (rtlefuse->eeprom_oemid == 0xFF)
 		rtlefuse->eeprom_oemid = 0;
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
 		 "EEPROM Customer ID: 0x%2x\n", rtlefuse->eeprom_oemid);
-	/*EEPROM version*/
-	rtlefuse->eeprom_version = *(u8 *)&hwinfo[EEPROM_VERSION];
-	/*mac address*/
-	for (i = 0; i < 6; i += 2) {
-		usvalue = *(u16 *)&hwinfo[EEPROM_MAC_ADDR + i];
-		*((u16 *)(&rtlefuse->dev_addr[i])) = usvalue;
-	}
-
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		 "dev_addr: %pM\n", rtlefuse->dev_addr);
-	/*channel plan */
-	rtlefuse->eeprom_channelplan = *(u8 *)&hwinfo[EEPROM_CHANNELPLAN];
 	/* set channel plan from efuse */
 	rtlefuse->channel_plan = rtlefuse->eeprom_channelplan;
 	/*tx power*/
@@ -2208,6 +2157,8 @@ static void _rtl92ee_read_adapter_info(struct ieee80211_hw *hw)
 			break;
 		}
 	}
+exit:
+	kfree(hwinfo);
 }
 
 static void _rtl92ee_hal_customized_behavior(struct ieee80211_hw *hw)
-- 
2.1.4

