Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36708 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439AbbHCU4j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2015 16:56:39 -0400
Received: by obnw1 with SMTP id w1so108116941obn.3
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2015 13:56:38 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH NEXT 5/6] rtlwifi: rtl888ee: Fix firmware header endian issues
Date: Mon,  3 Aug 2015 15:56:15 -0500
Message-Id: <1438635376-28114-6-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150803_225645_658344_B9D27943)
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
 drivers/net/wireless/rtlwifi/rtl8188ee/fw.c | 10 +++++-----
 drivers/net/wireless/rtlwifi/rtl8188ee/fw.h | 21 +--------------------
 2 files changed, 6 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/fw.c b/drivers/net/wireless/rtlwifi/rtl8188ee/fw.c
index c8058aa..6291256 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/fw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/fw.c
@@ -200,7 +200,7 @@ int rtl88e_download_fw(struct ieee80211_hw *hw,
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	struct rtl92c_firmware_header *pfwheader;
+	struct rtlwifi_firmware_header *pfwheader;
 	u8 *pfwdata;
 	u32 fwsize;
 	int err;
@@ -209,7 +209,7 @@ int rtl88e_download_fw(struct ieee80211_hw *hw,
 	if (!rtlhal->pfirmware)
 		return 1;
 
-	pfwheader = (struct rtl92c_firmware_header *)rtlhal->pfirmware;
+	pfwheader = (struct rtlwifi_firmware_header *)rtlhal->pfirmware;
 	pfwdata = rtlhal->pfirmware;
 	fwsize = rtlhal->fwsize;
 	RT_TRACE(rtlpriv, COMP_FW, DBG_DMESG,
@@ -219,10 +219,10 @@ int rtl88e_download_fw(struct ieee80211_hw *hw,
 		RT_TRACE(rtlpriv, COMP_FW, DBG_DMESG,
 			 "Firmware Version(%d), Signature(%#x), Size(%d)\n",
 			  pfwheader->version, pfwheader->signature,
-			  (int)sizeof(struct rtl92c_firmware_header));
+			  (int)sizeof(struct rtlwifi_firmware_header));
 
-		pfwdata = pfwdata + sizeof(struct rtl92c_firmware_header);
-		fwsize = fwsize - sizeof(struct rtl92c_firmware_header);
+		pfwdata = pfwdata + sizeof(struct rtlwifi_firmware_header);
+		fwsize = fwsize - sizeof(struct rtlwifi_firmware_header);
 	}
 
 	if (rtl_read_byte(rtlpriv, REG_MCUFWDL) & BIT(7)) {
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/fw.h b/drivers/net/wireless/rtlwifi/rtl8188ee/fw.h
index 05e944e..21bd4a5 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/fw.h
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/fw.h
@@ -37,7 +37,7 @@
 #define FW_8192C_POLLING_TIMEOUT_COUNT		3000
 
 #define IS_FW_HEADER_EXIST(_pfwhdr)		\
-	((_pfwhdr->signature&0xFFFF) == 0x88E1)
+	((le16_to_cpu(_pfwhdr->signature) & 0xFFFF) == 0x88E1)
 #define USE_OLD_WOWLAN_DEBUG_FW			0
 
 #define H2C_88E_RSVDPAGE_LOC_LEN		5
@@ -131,25 +131,6 @@
 #define	FW_PWR_STATE_ACTIVE	((FW_PS_RF_ON) | (FW_PS_REGISTER_ACTIVE))
 #define	FW_PWR_STATE_RF_OFF		0
 
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
 enum rtl8188e_h2c_cmd {
 	H2C_88E_RSVDPAGE = 0,
 	H2C_88E_JOINBSSRPT = 1,
-- 
2.1.4

