Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33346 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbcFYTxu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jun 2016 15:53:50 -0400
Received: by mail-oi0-f68.google.com with SMTP id w141so24214222oia.0
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jun 2016 12:53:50 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 03/10] rtlwifi: rtl8192cu: Convert driver to use common hardware info routine
Date: Sat, 25 Jun 2016 14:53:34 -0500
Message-Id: <1466884421-722-4-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160625_221248_758288_B91FB953)
In-Reply-To: <1466884421-722-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1466884421-722-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver for RTL8192CU chips is converted to use the common routine
for getting the hardware information.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 .../net/wireless/realtek/rtlwifi/rtl8192cu/hw.c    | 61 ++++++----------------
 1 file changed, 15 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
index ae1129f..c281f94 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
@@ -347,56 +347,24 @@ static void _rtl92cu_read_adapter_info(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	u16 i, usvalue;
-	u8 hwinfo[HWSET_MAX_SIZE] = {0};
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
+	int params[] = {RTL8190_EEPROM_ID, EEPROM_VID, EEPROM_DID,
+			EEPROM_SVID, EEPROM_SMID, EEPROM_MAC_ADDR,
+			EEPROM_CHANNELPLAN, EEPROM_VERSION, EEPROM_CUSTOMER_ID,
+			0};
+	u8 *hwinfo;
+
+	hwinfo = kzalloc(HWSET_MAX_SIZE, GFP_KERNEL);
+	if (!hwinfo)
 		return;
 
-	default:
-		pr_warn("rtl92cu: no efuse data\n\n");
-		return;
-	}
-	memcpy(hwinfo, &rtlefuse->efuse_map[EFUSE_INIT_MAP][0], HWSET_MAX_SIZE);
-	RT_PRINT_DATA(rtlpriv, COMP_INIT, DBG_LOUD, "MAP",
-		      hwinfo, HWSET_MAX_SIZE);
-	eeprom_id = le16_to_cpu(*((__le16 *)&hwinfo[0]));
-	if (eeprom_id != RTL8190_EEPROM_ID) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "EEPROM ID(%#x) is invalid!!\n", eeprom_id);
-		rtlefuse->autoload_failflag = true;
-	} else {
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "Autoload OK\n");
-		rtlefuse->autoload_failflag = false;
-	}
-	if (rtlefuse->autoload_failflag)
-		return;
-	for (i = 0; i < 6; i += 2) {
-		usvalue = *(u16 *)&hwinfo[EEPROM_MAC_ADDR + i];
-		*((u16 *) (&rtlefuse->dev_addr[i])) = usvalue;
-	}
-	pr_info("MAC address: %pM\n", rtlefuse->dev_addr);
+	if (rtl_get_hwinfo(hw, rtlpriv, HWSET_MAX_SIZE, hwinfo, params));
+		goto exit;
+
 	_rtl92cu_read_txpower_info_from_hwpg(hw,
 					   rtlefuse->autoload_failflag, hwinfo);
-	rtlefuse->eeprom_vid = le16_to_cpu(*(__le16 *)&hwinfo[EEPROM_VID]);
-	rtlefuse->eeprom_did = le16_to_cpu(*(__le16 *)&hwinfo[EEPROM_DID]);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, " VID = 0x%02x PID = 0x%02x\n",
-		 rtlefuse->eeprom_vid, rtlefuse->eeprom_did);
-	rtlefuse->eeprom_channelplan = hwinfo[EEPROM_CHANNELPLAN];
-	rtlefuse->eeprom_version =
-			 le16_to_cpu(*(__le16 *)&hwinfo[EEPROM_VERSION]);
+	_rtl92cu_read_board_type(hw, hwinfo);
+
 	rtlefuse->txpwr_fromeprom = true;
-	rtlefuse->eeprom_oemid = hwinfo[EEPROM_CUSTOMER_ID];
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "EEPROM Customer ID: 0x%2x\n",
-		 rtlefuse->eeprom_oemid);
 	if (rtlhal->oem_id == RT_CID_DEFAULT) {
 		switch (rtlefuse->eeprom_oemid) {
 		case EEPROM_CID_DEFAULT:
@@ -422,7 +390,8 @@ static void _rtl92cu_read_adapter_info(struct ieee80211_hw *hw)
 			break;
 		}
 	}
-	_rtl92cu_read_board_type(hw, hwinfo);
+exit:
+	kfree(hwinfo);
 }
 
 static void _rtl92cu_hal_customized_behavior(struct ieee80211_hw *hw)
-- 
2.1.4

