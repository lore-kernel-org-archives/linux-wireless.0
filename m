Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:34723 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399AbbHCU4e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2015 16:56:34 -0400
Received: by obre1 with SMTP id e1so108561128obr.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2015 13:56:33 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH NEXT 2/6] rtlwifi: rtl8723ae: rtl8723be: rtl8723com: Fix firmware header endian issues
Date: Mon,  3 Aug 2015 15:56:12 -0500
Message-Id: <1438635376-28114-3-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150803_225638_315401_335D30AF)
In-Reply-To: <1438635376-28114-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1438635376-28114-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The drivers are converted to use the common firmware header struct.
Because the old header definition failed to indicate that the multi-byte
entries should be little endian, several problems were thus exposed.
These are fixed.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8723ae/sw.c         |  4 ++--
 drivers/net/wireless/rtlwifi/rtl8723be/sw.c         |  4 ++--
 drivers/net/wireless/rtlwifi/rtl8723com/fw_common.c | 10 +++++-----
 drivers/net/wireless/rtlwifi/rtl8723com/fw_common.h | 19 -------------------
 drivers/net/wireless/rtlwifi/wifi.h                 |  4 +---
 5 files changed, 10 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/sw.c b/drivers/net/wireless/rtlwifi/rtl8723ae/sw.c
index 8280bab..3859b3e 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723ae/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/sw.c
@@ -205,9 +205,9 @@ bool rtl8723e_get_btc_status(void)
 	return true;
 }
 
-static bool is_fw_header(struct rtl8723e_firmware_header *hdr)
+static bool is_fw_header(struct rtlwifi_firmware_header *hdr)
 {
-	return (hdr->signature & 0xfff0) == 0x2300;
+	return (le16_to_cpu(hdr->signature) & 0xfff0) == 0x2300;
 }
 
 static struct rtl_hal_ops rtl8723e_hal_ops = {
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/sw.c b/drivers/net/wireless/rtlwifi/rtl8723be/sw.c
index 7bf88d9..d091f1d 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723be/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723be/sw.c
@@ -209,9 +209,9 @@ bool rtl8723be_get_btc_status(void)
 	return true;
 }
 
-static bool is_fw_header(struct rtl8723e_firmware_header *hdr)
+static bool is_fw_header(struct rtlwifi_firmware_header *hdr)
 {
-	return (hdr->signature & 0xfff0) == 0x5300;
+	return (le16_to_cpu(hdr->signature) & 0xfff0) == 0x5300;
 }
 
 static struct rtl_hal_ops rtl8723be_hal_ops = {
diff --git a/drivers/net/wireless/rtlwifi/rtl8723com/fw_common.c b/drivers/net/wireless/rtlwifi/rtl8723com/fw_common.c
index dd698e7..a2f5e89 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723com/fw_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723com/fw_common.c
@@ -253,7 +253,7 @@ int rtl8723_download_fw(struct ieee80211_hw *hw,
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	struct rtl8723e_firmware_header *pfwheader;
+	struct rtlwifi_firmware_header *pfwheader;
 	u8 *pfwdata;
 	u32 fwsize;
 	int err;
@@ -263,7 +263,7 @@ int rtl8723_download_fw(struct ieee80211_hw *hw,
 	if (!rtlhal->pfirmware)
 		return 1;
 
-	pfwheader = (struct rtl8723e_firmware_header *)rtlhal->pfirmware;
+	pfwheader = (struct rtlwifi_firmware_header *)rtlhal->pfirmware;
 	pfwdata = rtlhal->pfirmware;
 	fwsize = rtlhal->fwsize;
 
@@ -275,10 +275,10 @@ int rtl8723_download_fw(struct ieee80211_hw *hw,
 		RT_TRACE(rtlpriv, COMP_FW, DBG_LOUD,
 			 "Firmware Version(%d), Signature(%#x), Size(%d)\n",
 			 pfwheader->version, pfwheader->signature,
-			 (int)sizeof(struct rtl8723e_firmware_header));
+			 (int)sizeof(struct rtlwifi_firmware_header));
 
-		pfwdata = pfwdata + sizeof(struct rtl8723e_firmware_header);
-		fwsize = fwsize - sizeof(struct rtl8723e_firmware_header);
+		pfwdata = pfwdata + sizeof(struct rtlwifi_firmware_header);
+		fwsize = fwsize - sizeof(struct rtlwifi_firmware_header);
 	}
 
 	if (rtl_read_byte(rtlpriv, REG_MCUFWDL)&BIT(7)) {
diff --git a/drivers/net/wireless/rtlwifi/rtl8723com/fw_common.h b/drivers/net/wireless/rtlwifi/rtl8723com/fw_common.h
index 3ebafc8..8ea372d 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723com/fw_common.h
+++ b/drivers/net/wireless/rtlwifi/rtl8723com/fw_common.h
@@ -50,25 +50,6 @@ enum version_8723e {
 	VERSION_UNKNOWN = 0xFF,
 };
 
-struct rtl8723e_firmware_header {
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
 enum rtl8723be_cmd {
 	H2C_8723BE_RSVDPAGE = 0,
 	H2C_8723BE_JOINBSSRPT = 1,
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index 9e5b0b1..fa9d953 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -2097,8 +2097,6 @@ struct rtl_wow_pattern {
 	u32 mask[4];
 };
 
-struct rtl8723e_firmware_header;
-
 struct rtl_hal_ops {
 	int (*init_sw_vars) (struct ieee80211_hw *hw);
 	void (*deinit_sw_vars) (struct ieee80211_hw *hw);
@@ -2202,7 +2200,7 @@ struct rtl_hal_ops {
 	void (*fill_h2c_cmd) (struct ieee80211_hw *hw, u8 element_id,
 			      u32 cmd_len, u8 *p_cmdbuffer);
 	bool (*get_btc_status) (void);
-	bool (*is_fw_header)(struct rtl8723e_firmware_header *hdr);
+	bool (*is_fw_header)(struct rtlwifi_firmware_header *hdr);
 	u32 (*rx_command_packet)(struct ieee80211_hw *hw,
 				 struct rtl_stats status, struct sk_buff *skb);
 	void (*add_wowlan_pattern)(struct ieee80211_hw *hw,
-- 
2.1.4

