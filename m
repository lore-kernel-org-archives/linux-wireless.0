Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:36726 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489AbbHCU4k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2015 16:56:40 -0400
Received: by obnw1 with SMTP id w1so108117403obn.3
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2015 13:56:40 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH NEXT 6/6] rtlwifi: rtl8192ee: Fix firmware header endian issues
Date: Mon,  3 Aug 2015 15:56:16 -0500
Message-Id: <1438635376-28114-7-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150803_225648_915282_406AF5CB)
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
 drivers/net/wireless/rtlwifi/rtl8192ee/fw.c | 12 ++++++------
 drivers/net/wireless/rtlwifi/rtl8192ee/fw.h | 21 +--------------------
 2 files changed, 7 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/fw.c b/drivers/net/wireless/rtlwifi/rtl8192ee/fw.c
index 4091430..7bc0225 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ee/fw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ee/fw.c
@@ -198,7 +198,7 @@ int rtl92ee_download_fw(struct ieee80211_hw *hw, bool buse_wake_on_wlan_fw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	struct rtl92c_firmware_header *pfwheader;
+	struct rtlwifi_firmware_header *pfwheader;
 	u8 *pfwdata;
 	u32 fwsize;
 	int err;
@@ -207,8 +207,8 @@ int rtl92ee_download_fw(struct ieee80211_hw *hw, bool buse_wake_on_wlan_fw)
 	if (!rtlhal->pfirmware)
 		return 1;
 
-	pfwheader = (struct rtl92c_firmware_header *)rtlhal->pfirmware;
-	rtlhal->fw_version = pfwheader->version;
+	pfwheader = (struct rtlwifi_firmware_header *)rtlhal->pfirmware;
+	rtlhal->fw_version = le16_to_cpu(pfwheader->version);
 	rtlhal->fw_subversion = pfwheader->subversion;
 	pfwdata = (u8 *)rtlhal->pfirmware;
 	fwsize = rtlhal->fwsize;
@@ -219,10 +219,10 @@ int rtl92ee_download_fw(struct ieee80211_hw *hw, bool buse_wake_on_wlan_fw)
 		RT_TRACE(rtlpriv, COMP_FW, DBG_DMESG,
 			 "Firmware Version(%d), Signature(%#x),Size(%d)\n",
 			  pfwheader->version, pfwheader->signature,
-			  (int)sizeof(struct rtl92c_firmware_header));
+			  (int)sizeof(struct rtlwifi_firmware_header));
 
-		pfwdata = pfwdata + sizeof(struct rtl92c_firmware_header);
-		fwsize = fwsize - sizeof(struct rtl92c_firmware_header);
+		pfwdata = pfwdata + sizeof(struct rtlwifi_firmware_header);
+		fwsize = fwsize - sizeof(struct rtlwifi_firmware_header);
 	} else {
 		RT_TRACE(rtlpriv, COMP_FW, DBG_DMESG,
 			 "Firmware no Header, Signature(%#x)\n",
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/fw.h b/drivers/net/wireless/rtlwifi/rtl8192ee/fw.h
index 3e2a48e..069da1e 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ee/fw.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ee/fw.h
@@ -33,7 +33,7 @@
 #define FW_8192C_POLLING_TIMEOUT_COUNT		3000
 
 #define IS_FW_HEADER_EXIST(_pfwhdr)	\
-	((_pfwhdr->signature&0xFFF0) == 0x92E0)
+	((le16_to_cpu(_pfwhdr->signature) & 0xFFF0) == 0x92E0)
 #define USE_OLD_WOWLAN_DEBUG_FW 0
 
 #define H2C_92E_RSVDPAGE_LOC_LEN		5
@@ -89,25 +89,6 @@
 #define	FW_PWR_STATE_ACTIVE	((FW_PS_RF_ON) | (FW_PS_REGISTER_ACTIVE))
 #define	FW_PWR_STATE_RF_OFF	0
 
-struct rtl92c_firmware_header {
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
-	u16 ramcodesize;
-	u16 rsvd2;
-	u32 svnindex;
-	u32 rsvd3;
-	u32 rsvd4;
-	u32 rsvd5;
-};
-
 enum rtl8192e_h2c_cmd {
 	H2C_92E_RSVDPAGE = 0,
 	H2C_92E_MSRRPT = 1,
-- 
2.1.4

