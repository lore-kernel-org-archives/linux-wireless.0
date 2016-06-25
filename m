Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35125 "EHLO
	mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbcFYTxz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jun 2016 15:53:55 -0400
Received: by mail-oi0-f65.google.com with SMTP id d132so24149809oig.2
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jun 2016 12:53:55 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 09/10] rtlwifi: rtl8192de: Convert driver to use common hardware info routine
Date: Sat, 25 Jun 2016 14:53:40 -0500
Message-Id: <1466884421-722-10-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160625_215407_545865_DB0FE4CA)
In-Reply-To: <1466884421-722-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1466884421-722-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver for RTL8192DE chips is converted to use the common routine
for getting the hardware information.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 .../net/wireless/realtek/rtlwifi/rtl8192de/hw.c    | 77 +++++-----------------
 1 file changed, 15 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
index 8618c32..bee8607 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
@@ -1744,71 +1744,26 @@ static void _rtl92de_read_adapter_info(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	struct device *dev = &rtl_pcipriv(hw)->dev.pdev->dev;
-	u16 i, usvalue;
-	u8 hwinfo[HWSET_MAX_SIZE];
-	u16 eeprom_id;
-	unsigned long flags;
+	int params[] = {RTL8190_EEPROM_ID, EEPROM_VID, EEPROM_DID,
+			EEPROM_SVID, EEPROM_SMID, EEPROM_MAC_ADDR_MAC0_92D,
+			EEPROM_CHANNEL_PLAN, EEPROM_VERSION, EEPROM_CUSTOMER_ID,
+			COUNTRY_CODE_WORLD_WIDE_13};
+	int i;
+	u16 usvalue;
+	u8 *hwinfo;
 
-	switch (rtlefuse->epromtype) {
-	case EEPROM_BOOT_EFUSE:
-		spin_lock_irqsave(&globalmutex_for_power_and_efuse, flags);
-		rtl_efuse_shadow_map_update(hw);
-		_rtl92de_efuse_update_chip_version(hw);
-		spin_unlock_irqrestore(&globalmutex_for_power_and_efuse, flags);
-		break;
-	case EEPROM_93C46:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "RTL819X Not boot from eeprom, check it !!\n");
-		return;
-	default:
-		dev_warn(dev, "no efuse data\n");
+	hwinfo = kzalloc(HWSET_MAX_SIZE, GFP_KERNEL);
+	if (!hwinfo)
 		return;
-	}
-
-	memcpy(hwinfo, &rtlefuse->efuse_map[EFUSE_INIT_MAP][0], HWSET_MAX_SIZE);
-	RT_PRINT_DATA(rtlpriv, COMP_INIT, DBG_DMESG, "MAP",
-		      hwinfo, HWSET_MAX_SIZE);
 
-	eeprom_id = *((u16 *)&hwinfo[0]);
-	if (eeprom_id != RTL8190_EEPROM_ID) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
-			 "EEPROM ID(%#x) is invalid!!\n", eeprom_id);
-		rtlefuse->autoload_failflag = true;
-	} else {
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "Autoload OK\n");
-		rtlefuse->autoload_failflag = false;
-	}
-	if (rtlefuse->autoload_failflag) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "RTL819X Not boot from eeprom, check it !!\n");
+	if (rtl_get_hwinfo(hw, rtlpriv, HWSET_MAX_SIZE, hwinfo, params));
 		return;
-	}
-	rtlefuse->eeprom_oemid = hwinfo[EEPROM_CUSTOMER_ID];
-	_rtl92de_read_macphymode_and_bandtype(hw, hwinfo);
 
-	/* VID, DID  SE     0xA-D */
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
+	_rtl92de_efuse_update_chip_version(hw);
+	_rtl92de_read_macphymode_and_bandtype(hw, hwinfo);
 
-	/* Read Permanent MAC address */
-	if (rtlhal->interfaceindex == 0) {
-		for (i = 0; i < 6; i += 2) {
-			usvalue = *(u16 *)&hwinfo[EEPROM_MAC_ADDR_MAC0_92D + i];
-			*((u16 *) (&rtlefuse->dev_addr[i])) = usvalue;
-		}
-	} else {
+	/* Read Permanent MAC address for 2nd interface */
+	if (rtlhal->interfaceindex != 0) {
 		for (i = 0; i < 6; i += 2) {
 			usvalue = *(u16 *)&hwinfo[EEPROM_MAC_ADDR_MAC1_92D + i];
 			*((u16 *) (&rtlefuse->dev_addr[i])) = usvalue;
@@ -1834,10 +1789,8 @@ static void _rtl92de_read_adapter_info(struct ieee80211_hw *hw)
 		rtlefuse->channel_plan = COUNTRY_CODE_FCC;
 		break;
 	}
-	rtlefuse->eeprom_version = *(u16 *)&hwinfo[EEPROM_VERSION];
 	rtlefuse->txpwr_fromeprom = true;
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
-		 "EEPROM Customer ID: 0x%2x\n", rtlefuse->eeprom_oemid);
+	kfree(hwinfo);
 }
 
 void rtl92de_read_eeprom_info(struct ieee80211_hw *hw)
-- 
2.1.4

