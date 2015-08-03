Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:34710 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777AbbHCU4c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2015 16:56:32 -0400
Received: by obre1 with SMTP id e1so108560758obr.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2015 13:56:32 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH NEXT 1/6] rtlwifi: rtl8192ce: rtl8192cu: Fix endian issue
Date: Mon,  3 Aug 2015 15:56:11 -0500
Message-Id: <1438635376-28114-2-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150803_225636_653444_4E60C421)
In-Reply-To: <1438635376-28114-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1438635376-28114-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit e996db69833a (rtlwifi: rtl8192c: Add init codes for "fw_version"
and "fw_subversion") added initialization for fw_version, but failed to
note that the variable in the firmware header is little-endian. The
following Sparse warning results:

  CHECK   drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c:242:36: warning: incorrect type in assignment (different base types)
drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c:242:36:    expected unsigned short [unsigned] [usertype] fw_version
drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c:242:36:    got restricted __le16 [usertype] version

When fixing this problem, I noticed that several of the drivers contain
nearly identical copies of the firmware header struct, and that only the one
used in rtl8192c{e,u} had correct endian notation. The struct has been
moved into a common header, and the other drivers will be fixed in
subsequant patches.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c | 12 ++++++------
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h | 19 -------------------
 drivers/net/wireless/rtlwifi/wifi.h               | 21 +++++++++++++++++++--
 3 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
index 14b819e..43fcb25 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
@@ -221,7 +221,7 @@ int rtl92c_download_fw(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	struct rtl92c_firmware_header *pfwheader;
+	struct rtlwifi_firmware_header *pfwheader;
 	u8 *pfwdata;
 	u32 fwsize;
 	int err;
@@ -230,19 +230,19 @@ int rtl92c_download_fw(struct ieee80211_hw *hw)
 	if (!rtlhal->pfirmware)
 		return 1;
 
-	pfwheader = (struct rtl92c_firmware_header *)rtlhal->pfirmware;
+	pfwheader = (struct rtlwifi_firmware_header *)rtlhal->pfirmware;
 	pfwdata = (u8 *)rtlhal->pfirmware;
 	fwsize = rtlhal->fwsize;
 	if (IS_FW_HEADER_EXIST(pfwheader)) {
 		RT_TRACE(rtlpriv, COMP_FW, DBG_DMESG,
 			 "Firmware Version(%d), Signature(%#x),Size(%d)\n",
 			  pfwheader->version, pfwheader->signature,
-			  (int)sizeof(struct rtl92c_firmware_header));
+			  (int)sizeof(struct rtlwifi_firmware_header));
 
-		rtlhal->fw_version = pfwheader->version;
+		rtlhal->fw_version = le16_to_cpu(pfwheader->version);
 		rtlhal->fw_subversion = pfwheader->subversion;
-		pfwdata = pfwdata + sizeof(struct rtl92c_firmware_header);
-		fwsize = fwsize - sizeof(struct rtl92c_firmware_header);
+		pfwdata = pfwdata + sizeof(struct rtlwifi_firmware_header);
+		fwsize = fwsize - sizeof(struct rtlwifi_firmware_header);
 	}
 
 	_rtl92c_enable_fw_download(hw, true);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h
index e9f4281..864806c 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h
@@ -69,25 +69,6 @@
 	((GET_CVID_CUT_VERSION(version) == \
 		CHIP_VENDOR_UMC_B_CUT) ? true : false) : false)
 
-struct rtl92c_firmware_header {
-	__le16 signature;
-	u8 category;
-	u8 function;
-	__le16 version;
-	u8 subversion;
-	u8 rsvd1;
-	u8 month;
-	u8 date;
-	u8 hour;
-	u8 minute;
-	__le16 ramcodeSize;
-	__le16 rsvd2;
-	__le32 svnindex;
-	__le32 rsvd3;
-	__le32 rsvd4;
-	__le32 rsvd5;
-};
-
 #define pagenum_128(_len)	(u32)(((_len)>>7) + ((_len)&0x7F ? 1 : 0))
 
 #define SET_H2CCMD_PWRMODE_PARM_MODE(__ph2ccmd, __val)			\
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index ca734bb..9e5b0b1 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -222,6 +222,25 @@ enum rf_tx_num {
 #define	WOL_REASON_REALWOW_V2_WAKEUPPKT	BIT(9)
 #define	WOL_REASON_REALWOW_V2_ACKLOST	BIT(10)
 
+struct rtlwifi_firmware_header {
+	__le16 signature;
+	u8 category;
+	u8 function;
+	__le16 version;
+	u8 subversion;
+	u8 rsvd1;
+	u8 month;
+	u8 date;
+	u8 hour;
+	u8 minute;
+	__le16 ramcodeSize;
+	__le16 rsvd2;
+	__le32 svnindex;
+	__le32 rsvd3;
+	__le32 rsvd4;
+	__le32 rsvd5;
+};
+
 struct txpower_info_2g {
 	u8 index_cck_base[MAX_RF_PATH][MAX_CHNL_GROUP_24G];
 	u8 index_bw40_base[MAX_RF_PATH][MAX_CHNL_GROUP_24G];
@@ -2072,8 +2091,6 @@ struct rtl_tcb_desc {
 	bool tx_enable_sw_calc_duration;
 };
 
-struct rtl92c_firmware_header;
-
 struct rtl_wow_pattern {
 	u8 type;
 	u16 crc;
-- 
2.1.4

