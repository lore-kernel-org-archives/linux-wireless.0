Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:35483 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439AbbHCU4f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2015 16:56:35 -0400
Received: by obbop1 with SMTP id op1so108664731obb.2
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2015 13:56:35 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH NEXT 3/6] rtlwifi: rtl8821ae: Fix firmware endian issues
Date: Mon,  3 Aug 2015 15:56:13 -0500
Message-Id: <1438635376-28114-4-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150803_225644_271457_FE37512F)
In-Reply-To: <1438635376-28114-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1438635376-28114-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This driver is converted to use the common firmware header struct.
Because the old header definition failed to indicate that the multi-byte
entries should be little endian, several problems were thus exposed.
These are fixed.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8821ae/fw.c | 14 +++++++-------
 drivers/net/wireless/rtlwifi/rtl8821ae/fw.h | 23 ++---------------------
 2 files changed, 9 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/fw.c b/drivers/net/wireless/rtlwifi/rtl8821ae/fw.c
index 95e9562..525eb23 100644
--- a/drivers/net/wireless/rtlwifi/rtl8821ae/fw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8821ae/fw.c
@@ -210,7 +210,7 @@ int rtl8821ae_download_fw(struct ieee80211_hw *hw, bool buse_wake_on_wlan_fw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	struct rtl8821a_firmware_header *pfwheader;
+	struct rtlwifi_firmware_header *pfwheader;
 	u8 *pfwdata;
 	u32 fwsize;
 	int err;
@@ -228,8 +228,8 @@ int rtl8821ae_download_fw(struct ieee80211_hw *hw, bool buse_wake_on_wlan_fw)
 			return 1;
 
 		pfwheader =
-		  (struct rtl8821a_firmware_header *)rtlhal->wowlan_firmware;
-		rtlhal->fw_version = pfwheader->version;
+		  (struct rtlwifi_firmware_header *)rtlhal->wowlan_firmware;
+		rtlhal->fw_version = le16_to_cpu(pfwheader->version);
 		rtlhal->fw_subversion = pfwheader->subversion;
 		pfwdata = (u8 *)rtlhal->wowlan_firmware;
 		fwsize = rtlhal->wowlan_fwsize;
@@ -238,8 +238,8 @@ int rtl8821ae_download_fw(struct ieee80211_hw *hw, bool buse_wake_on_wlan_fw)
 			return 1;
 
 		pfwheader =
-		  (struct rtl8821a_firmware_header *)rtlhal->pfirmware;
-		rtlhal->fw_version = pfwheader->version;
+		  (struct rtlwifi_firmware_header *)rtlhal->pfirmware;
+		rtlhal->fw_version = le16_to_cpu(pfwheader->version);
 		rtlhal->fw_subversion = pfwheader->subversion;
 		pfwdata = (u8 *)rtlhal->pfirmware;
 		fwsize = rtlhal->fwsize;
@@ -255,8 +255,8 @@ int rtl8821ae_download_fw(struct ieee80211_hw *hw, bool buse_wake_on_wlan_fw)
 			 "Firmware Version(%d), Signature(%#x)\n",
 			 pfwheader->version, pfwheader->signature);
 
-		pfwdata = pfwdata + sizeof(struct rtl8821a_firmware_header);
-		fwsize = fwsize - sizeof(struct rtl8821a_firmware_header);
+		pfwdata = pfwdata + sizeof(struct rtlwifi_firmware_header);
+		fwsize = fwsize - sizeof(struct rtlwifi_firmware_header);
 	}
 
 	if (rtlhal->mac_func_enable) {
diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/fw.h b/drivers/net/wireless/rtlwifi/rtl8821ae/fw.h
index 591c14c..8f5b4aa 100644
--- a/drivers/net/wireless/rtlwifi/rtl8821ae/fw.h
+++ b/drivers/net/wireless/rtlwifi/rtl8821ae/fw.h
@@ -34,10 +34,10 @@
 #define FW_8821AE_POLLING_TIMEOUT_COUNT	6000
 
 #define IS_FW_HEADER_EXIST_8812(_pfwhdr)	\
-	((_pfwhdr->signature&0xFFF0) == 0x9500)
+	((le16_to_cpu(_pfwhdr->signature) & 0xFFF0) == 0x9500)
 
 #define IS_FW_HEADER_EXIST_8821(_pfwhdr)	\
-	((_pfwhdr->signature&0xFFF0) == 0x2100)
+	((le16_to_cpu(_pfwhdr->signature) & 0xFFF0) == 0x2100)
 
 #define USE_OLD_WOWLAN_DEBUG_FW 0
 
@@ -137,25 +137,6 @@
 #define	FW_PWR_STATE_ACTIVE	((FW_PS_RF_ON) | (FW_PS_REGISTER_ACTIVE))
 #define	FW_PWR_STATE_RF_OFF	0
 
-struct rtl8821a_firmware_header {
-	u16 signature;
-	u8 category;
-	u8 function;
-	u16 version;
-	u8 subversion;
-	u8 rsvd1;
-	u8 month;
-	u8 date;
-	u8 hour;
-	u8 minute;
-	u16 ramcodeSize;
-	u16 rsvd2;
-	u32 svnindex;
-	u32 rsvd3;
-	u32 rsvd4;
-	u32 rsvd5;
-};
-
 enum rtl8812_c2h_evt {
 	C2H_8812_DBG = 0,
 	C2H_8812_LB = 1,
-- 
2.1.4

