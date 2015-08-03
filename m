Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:35511 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399AbbHCU4h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2015 16:56:37 -0400
Received: by obbop1 with SMTP id op1so108665415obb.2
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2015 13:56:37 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH NEXT 4/6] rtlwifi: rtl8192de: Fix firmware header endian issues
Date: Mon,  3 Aug 2015 15:56:14 -0500
Message-Id: <1438635376-28114-5-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150803_225642_446046_E85FF059)
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
 drivers/net/wireless/rtlwifi/rtl8192de/fw.h | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/fw.h b/drivers/net/wireless/rtlwifi/rtl8192de/fw.h
index 1646e7c..8a38daa 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/fw.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/fw.h
@@ -110,28 +110,6 @@
 #define SET_H2CCMD_RSVDPAGE_LOC_NULL_DATA(__ph2ccmd, __val)	\
 	SET_BITS_TO_LE_1BYTE((__ph2ccmd) + 2, 0, 8, __val)
 
-struct rtl92d_firmware_header {
-	u16 signature;
-	u8 category;
-	u8 function;
-	u16 version;
-	u8 subversion;
-	u8 rsvd1;
-
-	u8 month;
-	u8 date;
-	u8 hour;
-	u8 minute;
-	u16 ramcodeSize;
-	u16 rsvd2;
-
-	u32 svnindex;
-	u32 rsvd3;
-
-	u32 rsvd4;
-	u32 rsvd5;
-};
-
 int rtl92d_download_fw(struct ieee80211_hw *hw);
 void rtl92d_fill_h2c_cmd(struct ieee80211_hw *hw, u8 element_id,
 			 u32 cmd_len, u8 *p_cmdbuffer);
-- 
2.1.4

