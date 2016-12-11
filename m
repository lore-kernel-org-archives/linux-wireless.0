Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35975 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752618AbcLKFpy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Dec 2016 00:45:54 -0500
Received: by mail-oi0-f66.google.com with SMTP id u15so7277552oie.3
        for <linux-wireless@vger.kernel.org>; Sat, 10 Dec 2016 21:45:54 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 14/14] rtlwifi: Remove some redundant code
Date: Sat, 10 Dec 2016 23:45:23 -0600
Message-Id: <20161211054523.7119-27-Larry.Finger@lwfinger.net> (sfid-20161211_064559_716194_807DDBAE)
In-Reply-To: <20161211054523.7119-1-Larry.Finger@lwfinger.net>
References: <20161211054523.7119-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The symbol DBG_EMERG is no longer used and is removed.

In a number of places, the code has redundant messages. For example, if
the failure for the firmware to run is logged, it is not necessary to
log that the firmware has been started. In addition, extraneous braces are
removed.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/debug.h          |  2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c   |  6 +-----
 .../net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c |  6 +-----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c   | 10 ++--------
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c   | 19 ++-----------------
 .../wireless/realtek/rtlwifi/rtl8723com/fw_common.c   |  9 +--------
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c   | 15 +++------------
 7 files changed, 11 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/debug.h b/drivers/net/wireless/realtek/rtlwifi/debug.h
index 51794bc..75596e2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/debug.h
+++ b/drivers/net/wireless/realtek/rtlwifi/debug.h
@@ -36,7 +36,7 @@
  *unexpected HW behavior, HW BUG
  *and so on.
  */
-#define DBG_EMERG			0
+/*#define DBG_EMERG			0 */
 
 /*
  *Abnormal, rare, or unexpeted cases.
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c
index 3ba2a3f..2e22759 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c
@@ -221,12 +221,8 @@ int rtl88e_download_fw(struct ieee80211_hw *hw,
 	_rtl88e_enable_fw_download(hw, false);
 
 	err = _rtl88e_fw_free_to_go(hw);
-	if (err) {
+	if (err)
 		pr_err("Firmware is not ready to run!\n");
-	} else {
-		RT_TRACE(rtlpriv, COMP_FW, DBG_LOUD,
-			 "Firmware is ready to run!\n");
-	}
 
 	return 0;
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
index 5c93ee0..eb4459c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
@@ -237,12 +237,8 @@ int rtl92c_download_fw(struct ieee80211_hw *hw)
 	_rtl92c_enable_fw_download(hw, false);
 
 	err = _rtl92c_fw_free_to_go(hw);
-	if (err) {
+	if (err)
 		pr_err("Firmware is not ready to run!\n");
-	} else {
-		RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE,
-			 "Firmware is ready to run!\n");
-	}
 
 	return 0;
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c
index 5b33bed..e647605 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c
@@ -125,9 +125,8 @@ static void _rtl92d_write_fw(struct ieee80211_hw *hw,
 		_rtl92d_fill_dummy(bufferPtr, &size);
 	pagenums = size / FW_8192D_PAGE_SIZE;
 	remainSize = size % FW_8192D_PAGE_SIZE;
-	if (pagenums > 8) {
+	if (pagenums > 8)
 		pr_err("Page numbers should not greater then 8\n");
-	}
 	for (page = 0; page < pagenums; page++) {
 		offset = page * FW_8192D_PAGE_SIZE;
 		_rtl92d_fw_page_write(hw, page, (bufferPtr + offset),
@@ -155,8 +154,6 @@ static int _rtl92d_fw_free_to_go(struct ieee80211_hw *hw)
 		pr_err("chksum report fail! REG_MCUFWDL:0x%08x\n", value32);
 		return -EIO;
 	}
-	RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE,
-		 "Checksum report OK ! REG_MCUFWDL:0x%08x\n", value32);
 	value32 = rtl_read_dword(rtlpriv, REG_MCUFWDL);
 	value32 |= MCUFWDL_RDY;
 	rtl_write_dword(rtlpriv, REG_MCUFWDL, value32);
@@ -323,12 +320,9 @@ int rtl92d_download_fw(struct ieee80211_hw *hw)
 	value &= (~BIT(5));
 	rtl_write_byte(rtlpriv, 0x1f, value);
 	spin_unlock_irqrestore(&globalmutex_for_fwdownload, flags);
-	if (err) {
+	if (err)
 		pr_err("fw is not ready to run!\n");
 		goto exit;
-	} else {
-		RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE, "fw is ready to run!\n");
-	}
 exit:
 	err = _rtl92d_fw_init(hw);
 	return err;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
index 2959746..e05b181 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
@@ -157,10 +157,6 @@ static int _rtl92ee_fw_free_to_go(struct ieee80211_hw *hw)
 		       value32);
 		goto exit;
 	}
-
-	RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE,
-		 "Checksum report OK! REG_MCUFWDL:0x%08x\n", value32);
-
 	value32 = rtl_read_dword(rtlpriv, REG_MCUFWDL);
 	value32 |= MCUFWDL_RDY;
 	value32 &= ~WINTINI_RDY;
@@ -171,13 +167,8 @@ static int _rtl92ee_fw_free_to_go(struct ieee80211_hw *hw)
 
 	do {
 		value32 = rtl_read_dword(rtlpriv, REG_MCUFWDL);
-		if (value32 & WINTINI_RDY) {
-			RT_TRACE(rtlpriv, COMP_FW, DBG_LOUD ,
-				 "Polling FW ready success!! REG_MCUFWDL:0x%08x. count = %d\n",
-				 value32, counter);
-			err = 0;
-			goto exit;
-		}
+		if (value32 & WINTINI_RDY)
+			return 0;
 
 		udelay(FW_8192C_POLLING_DELAY*10);
 
@@ -236,12 +227,6 @@ int rtl92ee_download_fw(struct ieee80211_hw *hw, bool buse_wake_on_wlan_fw)
 	_rtl92ee_enable_fw_download(hw, false);
 
 	err = _rtl92ee_fw_free_to_go(hw);
-	if (err) {
-		pr_err("Firmware is not ready to run!\n");
-	} else {
-		RT_TRACE(rtlpriv, COMP_FW, DBG_LOUD ,
-			 "Firmware is ready to run!\n");
-	}
 
 	return 0;
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c
index a9cc67e..a040e6b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c
@@ -212,9 +212,6 @@ int rtl8723_fw_free_to_go(struct ieee80211_hw *hw, bool is_8723be,
 		       value32);
 		goto exit;
 	}
-	RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE,
-		 "Checksum report OK ! REG_MCUFWDL:0x%08x .\n", value32);
-
 	value32 = rtl_read_dword(rtlpriv, REG_MCUFWDL) | MCUFWDL_RDY;
 	value32 &= ~WINTINI_RDY;
 	rtl_write_dword(rtlpriv, REG_MCUFWDL, value32);
@@ -290,12 +287,8 @@ int rtl8723_download_fw(struct ieee80211_hw *hw,
 	rtl8723_enable_fw_download(hw, false);
 
 	err = rtl8723_fw_free_to_go(hw, is_8723be, max_count);
-	if (err) {
+	if (err)
 		pr_err("Firmware is not ready to run!\n");
-	} else {
-		RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE,
-			 "Firmware is ready to run!\n");
-	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rtl8723_download_fw);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
index 536c12a..4f17140 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
@@ -124,9 +124,8 @@ static void _rtl8821ae_write_fw(struct ieee80211_hw *hw,
 	pagenums = size / FW_8821AE_PAGE_SIZE;
 	remainsize = size % FW_8821AE_PAGE_SIZE;
 
-	if (pagenums > 8) {
+	if (pagenums > 8)
 		pr_err("Page numbers should not greater then 8\n");
-	}
 
 	for (page = 0; page < pagenums; page++) {
 		offset = page * FW_8821AE_PAGE_SIZE;
@@ -160,9 +159,6 @@ static int _rtl8821ae_fw_free_to_go(struct ieee80211_hw *hw)
 			  value32);
 		goto exit;
 	}
-
-	pr_err("Checksum report OK ! REG_MCUFWDL:0x%08x .\n", value32);
-
 	value32 = rtl_read_dword(rtlpriv, REG_MCUFWDL);
 	value32 |= MCUFWDL_RDY;
 	value32 &= ~WINTINI_RDY;
@@ -173,13 +169,8 @@ static int _rtl8821ae_fw_free_to_go(struct ieee80211_hw *hw)
 	counter = 0;
 	do {
 		value32 = rtl_read_dword(rtlpriv, REG_MCUFWDL);
-		if (value32 & WINTINI_RDY) {
-			RT_TRACE(rtlpriv, COMP_FW, DBG_LOUD,
-				 "Polling FW ready success!! REG_MCUFWDL:0x%08x .\n",
-				  value32);
-			err = 0;
-			goto exit;
-		}
+		if (value32 & WINTINI_RDY)
+			return 0;
 
 		udelay(FW_8821AE_POLLING_DELAY);
 	} while (counter++ < FW_8821AE_POLLING_TIMEOUT_COUNT);
-- 
2.10.2
