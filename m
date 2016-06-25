Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33339 "EHLO
	mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbcFYTxt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jun 2016 15:53:49 -0400
Received: by mail-oi0-f67.google.com with SMTP id w141so24214176oia.0
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jun 2016 12:53:48 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 01/10] rtlwifi: Create common routine to get hardware info
Date: Sat, 25 Jun 2016 14:53:32 -0500
Message-Id: <1466884421-722-2-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160625_215408_297397_A3013F2A)
In-Reply-To: <1466884421-722-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1466884421-722-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All of the rtlwifi family of drivers have a similar routine that acquires
the hardware info from efuse and initializes a number of variables in the
driver's private area. A common routine is created for all drivers to use.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/realtek/rtlwifi/efuse.c | 78 ++++++++++++++++++++++++++++
 drivers/net/wireless/realtek/rtlwifi/efuse.h |  2 +
 2 files changed, 80 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/efuse.c b/drivers/net/wireless/realtek/rtlwifi/efuse.c
index 0b4082c..b8ad00e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/efuse.c
+++ b/drivers/net/wireless/realtek/rtlwifi/efuse.c
@@ -24,6 +24,7 @@
  *****************************************************************************/
 #include "wifi.h"
 #include "efuse.h"
+#include "pci.h"
 #include <linux/export.h>
 
 static const u8 MAX_PGPKT_SIZE = 9;
@@ -1243,3 +1244,80 @@ static u8 efuse_calculate_word_cnts(u8 word_en)
 	return word_cnts;
 }
 
+int rtl_get_hwinfo(struct ieee80211_hw *hw, struct rtl_priv *rtlpriv,
+		   int max_size, u8 *hwinfo, int *params)
+{
+	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
+	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
+	struct device *dev = &rtlpcipriv->dev.pdev->dev;
+	u16 eeprom_id;
+	u16 i, usvalue;
+
+	switch (rtlefuse->epromtype) {
+	case EEPROM_BOOT_EFUSE:
+		rtl_efuse_shadow_map_update(hw);
+		break;
+
+	case EEPROM_93C46:
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 "RTL819X Not boot from eeprom, check it !!");
+		return 1;
+
+	default:
+		dev_warn(dev, "no efuse data\n");
+		return 1;
+	}
+
+	memcpy(hwinfo, &rtlefuse->efuse_map[EFUSE_INIT_MAP][0], max_size);
+
+	RT_PRINT_DATA(rtlpriv, COMP_INIT, DBG_DMESG, "MAP",
+		      hwinfo, max_size);
+
+	eeprom_id = *((u16 *)&hwinfo[0]);
+	if (eeprom_id != params[0]) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
+			 "EEPROM ID(%#x) is invalid!!\n", eeprom_id);
+		rtlefuse->autoload_failflag = true;
+	} else {
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "Autoload OK\n");
+		rtlefuse->autoload_failflag = false;
+	}
+
+	if (rtlefuse->autoload_failflag)
+		return 1;
+
+	rtlefuse->eeprom_vid = *(u16 *)&hwinfo[params[1]];
+	rtlefuse->eeprom_did = *(u16 *)&hwinfo[params[2]];
+	rtlefuse->eeprom_svid = *(u16 *)&hwinfo[params[3]];
+	rtlefuse->eeprom_smid = *(u16 *)&hwinfo[params[4]];
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+		 "EEPROMId = 0x%4x\n", eeprom_id);
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+		 "EEPROM VID = 0x%4x\n", rtlefuse->eeprom_vid);
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+		 "EEPROM DID = 0x%4x\n", rtlefuse->eeprom_did);
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+		 "EEPROM SVID = 0x%4x\n", rtlefuse->eeprom_svid);
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+		 "EEPROM SMID = 0x%4x\n", rtlefuse->eeprom_smid);
+
+	for (i = 0; i < 6; i += 2) {
+		usvalue = *(u16 *)&hwinfo[params[5] + i];
+		*((u16 *)(&rtlefuse->dev_addr[i])) = usvalue;
+	}
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "%pM\n", rtlefuse->dev_addr);
+
+	rtlefuse->eeprom_channelplan = *&hwinfo[params[6]];
+	rtlefuse->eeprom_version = *(u16 *)&hwinfo[params[7]];
+	rtlefuse->txpwr_fromeprom = true;
+	rtlefuse->eeprom_oemid = *&hwinfo[params[8]];
+
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+		 "EEPROM Customer ID: 0x%2x\n", rtlefuse->eeprom_oemid);
+
+	/* set channel plan to world wide 13 */
+	rtlefuse->channel_plan = params[9];
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rtl_get_hwinfo);
diff --git a/drivers/net/wireless/realtek/rtlwifi/efuse.h b/drivers/net/wireless/realtek/rtlwifi/efuse.h
index be02e78..51aa121 100644
--- a/drivers/net/wireless/realtek/rtlwifi/efuse.h
+++ b/drivers/net/wireless/realtek/rtlwifi/efuse.h
@@ -109,5 +109,7 @@ bool efuse_shadow_update_chk(struct ieee80211_hw *hw);
 void rtl_efuse_shadow_map_update(struct ieee80211_hw *hw);
 void efuse_force_write_vendor_Id(struct ieee80211_hw *hw);
 void efuse_re_pg_section(struct ieee80211_hw *hw, u8 section_idx);
+int rtl_get_hwinfo(struct ieee80211_hw *hw, struct rtl_priv *rtlpriv,
+		   int max_size, u8 *hwinfo, int *params);
 
 #endif
-- 
2.1.4

