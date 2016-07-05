Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35436 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317AbcGEPId (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2016 11:08:33 -0400
Received: by mail-oi0-f68.google.com with SMTP id d132so27969069oig.2
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jul 2016 08:08:32 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 07/10] rtlwifi: rtl8723be: Convert driver to use common hardware info routine
Date: Tue,  5 Jul 2016 10:08:12 -0500
Message-Id: <1467731295-25850-8-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160705_170912_109403_C9E6AF6E)
In-Reply-To: <1467731295-25850-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1467731295-25850-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver for RTL8723BE chips is converted to use the common routine
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
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    | 74 ++++------------------
 1 file changed, 12 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
index 63b0df6..cb68c719 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
@@ -2026,10 +2026,12 @@ static void _rtl8723be_read_adapter_info(struct ieee80211_hw *hw,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	struct device *dev = &rtl_pcipriv(hw)->dev.pdev->dev;
-	u16 i, usvalue;
-	u8 hwinfo[HWSET_MAX_SIZE];
-	u16 eeprom_id;
+	int params[] = {RTL8723BE_EEPROM_ID, EEPROM_VID, EEPROM_DID,
+			EEPROM_SVID, EEPROM_SMID, EEPROM_MAC_ADDR,
+			EEPROM_CHANNELPLAN, EEPROM_VERSION, EEPROM_CUSTOMER_ID,
+			COUNTRY_CODE_WORLD_WIDE_13};
+	u8 *hwinfo;
+	int i;
 	bool is_toshiba_smid1 = false;
 	bool is_toshiba_smid2 = false;
 	bool is_samsung_smid = false;
@@ -2057,58 +2059,12 @@ static void _rtl8723be_read_adapter_info(struct ieee80211_hw *hw,
 		return;
 	}
 
-	switch (rtlefuse->epromtype) {
-	case EEPROM_BOOT_EFUSE:
-		rtl_efuse_shadow_map_update(hw);
-		break;
-
-	case EEPROM_93C46:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "RTL819X Not boot from eeprom, check it !!\n");
+	hwinfo = kzalloc(HWSET_MAX_SIZE, GFP_KERNEL);
+	if (!hwinfo)
 		return;
 
-	default:
-		dev_warn(dev, "no efuse data\n");
-		return;
-	}
-	memcpy(hwinfo, &rtlefuse->efuse_map[EFUSE_INIT_MAP][0], HWSET_MAX_SIZE);
-	RT_PRINT_DATA(rtlpriv, COMP_INIT, DBG_DMESG, ("MAP\n"),
-		      hwinfo, HWSET_MAX_SIZE);
-
-	eeprom_id = *((u16 *)&hwinfo[0]);
-	if (eeprom_id != RTL8723BE_EEPROM_ID) {
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
-
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
-
-	for (i = 0; i < 6; i += 2) {
-		usvalue = *(u16 *)&hwinfo[EEPROM_MAC_ADDR + i];
-		*((u16 *)(&rtlefuse->dev_addr[i])) = usvalue;
-	}
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "dev_addr: %pM\n",
-		 rtlefuse->dev_addr);
+	if (rtl_get_hwinfo(hw, rtlpriv, HWSET_MAX_SIZE, hwinfo, params))
+		goto exit;
 
 	/*parse xtal*/
 	rtlefuse->crystalcap = hwinfo[EEPROM_XTAL_8723BE];
@@ -2122,14 +2078,6 @@ static void _rtl8723be_read_adapter_info(struct ieee80211_hw *hw,
 						 rtlefuse->autoload_failflag,
 						 hwinfo);
 
-	rtlefuse->eeprom_channelplan = hwinfo[EEPROM_CHANNELPLAN];
-	rtlefuse->eeprom_version = *(u16 *)&hwinfo[EEPROM_VERSION];
-	rtlefuse->txpwr_fromeprom = true;
-	rtlefuse->eeprom_oemid = hwinfo[EEPROM_CUSTOMER_ID];
-
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
-		 "EEPROM Customer ID: 0x%2x\n", rtlefuse->eeprom_oemid);
-
 	/* set channel plan from efuse */
 	rtlefuse->channel_plan = rtlefuse->eeprom_channelplan;
 
@@ -2240,6 +2188,8 @@ static void _rtl8723be_read_adapter_info(struct ieee80211_hw *hw,
 			break;
 		}
 	}
+exit:
+	kfree(hwinfo);
 }
 
 static void _rtl8723be_hal_customized_behavior(struct ieee80211_hw *hw)
-- 
2.1.4

