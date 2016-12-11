Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35953 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752876AbcLKFpo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Dec 2016 00:45:44 -0500
Received: by mail-oi0-f68.google.com with SMTP id u15so7277434oie.3
        for <linux-wireless@vger.kernel.org>; Sat, 10 Dec 2016 21:45:44 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 07/14] rtlwifi: rtl8723-common: Remove all instances of DBG_EMERG
Date: Sat, 10 Dec 2016 23:45:10 -0600
Message-Id: <20161211054523.7119-14-Larry.Finger@lwfinger.net> (sfid-20161211_070931_756739_1D9E1A1D)
In-Reply-To: <20161211054523.7119-1-Larry.Finger@lwfinger.net>
References: <20161211054523.7119-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a step toward eliminating the RT_TRACE macros. Those calls that
have DBG_EMERG as the level are always logged, and they represent error
conditions, thus they are replaced with pr_err().

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
---
 .../net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c  | 16 ++++++----------
 .../net/wireless/realtek/rtlwifi/rtl8723com/phy_common.c |  4 ++--
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c
index 108475e..a9cc67e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c
@@ -129,8 +129,8 @@ void rtl8723_write_fw(struct ieee80211_hw *hw,
 	remain_size = size % FW_8192C_PAGE_SIZE;
 
 	if (page_nums > max_page) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Page numbers should not greater than %d\n", max_page);
+		pr_err("rtl8723-common: Page numbers should not greater than %d\n",
+		       max_page);
 	}
 	for (page = 0; page < page_nums; page++) {
 		offset = page * FW_8192C_PAGE_SIZE;
@@ -209,9 +208,8 @@ int rtl8723_fw_free_to_go(struct ieee80211_hw *hw, bool is_8723be,
 		 (!(value32 & FWDL_CHKSUM_RPT)));
 
 	if (counter >= max_count) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "chksum report fail ! REG_MCUFWDL:0x%08x .\n",
-			 value32);
+		pr_err("rtl8723-common: chksum report fail ! REG_MCUFWDL:0x%08x .\n",
+		       value32);
 		goto exit;
 	}
 	RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE,
@@ -239,9 +237,8 @@ int rtl8723_fw_free_to_go(struct ieee80211_hw *hw, bool is_8723be,
 
 	} while (counter++ < max_count);
 
-	RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-		 "Polling FW ready fail!! REG_MCUFWDL:0x%08x .\n",
-		 value32);
+	pr_err("rtl8723-common: Polling FW ready fail!! REG_MCUFWDL:0x%08x .\n",
+	       value32);
 
 exit:
 	return err;
@@ -294,8 +291,7 @@ int rtl8723_download_fw(struct ieee80211_hw *hw,
 
 	err = rtl8723_fw_free_to_go(hw, is_8723be, max_count);
 	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Firmware is not ready to run!\n");
+		pr_err("rtl8723-common: Firmware is not ready to run!\n");
 	} else {
 		RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE,
 			 "Firmware is ready to run!\n");
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723com/phy_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/phy_common.c
index 0adae58..91a1ef0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723com/phy_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/phy_common.c
@@ -99,7 +99,7 @@ u32 rtl8723_phy_rf_serial_read(struct ieee80211_hw *hw,
 	offset &= 0xff;
 	newoffset = offset;
 	if (RT_CANNOT_IO(hw)) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "return all one\n");
+		pr_err("rtl8723-common: return all one\n");
 		return 0xFFFFFFFF;
 	}
 	tmplong = rtl_get_bbreg(hw, RFPGA0_XA_HSSIPARAMETER2, MASKDWORD);
@@ -147,7 +147,7 @@ void rtl8723_phy_rf_serial_write(struct ieee80211_hw *hw,
 	struct bb_reg_def *pphyreg = &rtlphy->phyreg_def[rfpath];
 
 	if (RT_CANNOT_IO(hw)) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "stop\n");
+		pr_err("rtl8723-common: rtl8723: stop\n");
 		return;
 	}
 	offset &= 0xff;
-- 
2.10.2
