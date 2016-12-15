Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36590 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755978AbcLOSYD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Dec 2016 13:24:03 -0500
Received: by mail-oi0-f68.google.com with SMTP id u15so7088264oie.3
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2016 10:23:43 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 14/14 V2] rtlwifi: Remove some redundant code
Date: Thu, 15 Dec 2016 12:23:10 -0600
Message-Id: <20161215182310.13713-15-Larry.Finger@lwfinger.net> (sfid-20161215_193931_422003_3F89167E)
In-Reply-To: <20161215182310.13713-1-Larry.Finger@lwfinger.net>
References: <20161215182310.13713-1-Larry.Finger@lwfinger.net>
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
V2 - eliminate some files that should not have been sent.
---
 drivers/net/wireless/realtek/rtlwifi/debug.h          |  2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c   |  6 +-----
 .../net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c |  6 +-----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c   | 10 ++--------
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c   | 19 ++-----------------
 .../wireless/realtek/rtlwifi/rtl8723com/fw_common.c   |  9 +--------
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c   | 15 +++------------
 7 files changed, 11 insertions(+), 56 deletions(-)

Index: wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/debug.h
===================================================================
--- wireless-drivers-next.orig/drivers/net/wireless/realtek/rtlwifi/debug.h
+++ wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/debug.h
@@ -36,7 +36,7 @@
  *unexpected HW behavior, HW BUG
  *and so on.
  */
-#define DBG_EMERG			0
+/*#define DBG_EMERG			0 */
 
 /*
  *Abnormal, rare, or unexpeted cases.
Index: wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c
===================================================================
--- wireless-drivers-next.orig/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c
+++ wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c
@@ -222,12 +222,8 @@ int rtl88e_download_fw(struct ieee80211_
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
Index: wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
===================================================================
--- wireless-drivers-next.orig/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
+++ wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
@@ -238,12 +238,8 @@ int rtl92c_download_fw(struct ieee80211_
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
Index: wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c
===================================================================
--- wireless-drivers-next.orig/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c
+++ wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c
@@ -125,9 +125,8 @@ static void _rtl92d_write_fw(struct ieee
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
@@ -156,8 +155,6 @@ static int _rtl92d_fw_free_to_go(struct
 		       value32);
 		return -EIO;
 	}
-	RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE,
-		 "Checksum report OK ! REG_MCUFWDL:0x%08x\n", value32);
 	value32 = rtl_read_dword(rtlpriv, REG_MCUFWDL);
 	value32 |= MCUFWDL_RDY;
 	rtl_write_dword(rtlpriv, REG_MCUFWDL, value32);
@@ -324,12 +321,9 @@ int rtl92d_download_fw(struct ieee80211_
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
Index: wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
===================================================================
--- wireless-drivers-next.orig/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
+++ wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
@@ -157,10 +157,6 @@ static int _rtl92ee_fw_free_to_go(struct
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
@@ -171,13 +167,8 @@ static int _rtl92ee_fw_free_to_go(struct
 
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
 
@@ -236,12 +227,6 @@ int rtl92ee_download_fw(struct ieee80211
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
Index: wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c
===================================================================
--- wireless-drivers-next.orig/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c
+++ wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c
@@ -213,9 +213,6 @@ int rtl8723_fw_free_to_go(struct ieee802
 		       value32);
 		goto exit;
 	}
-	RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE,
-		 "Checksum report OK ! REG_MCUFWDL:0x%08x .\n", value32);
-
 	value32 = rtl_read_dword(rtlpriv, REG_MCUFWDL) | MCUFWDL_RDY;
 	value32 &= ~WINTINI_RDY;
 	rtl_write_dword(rtlpriv, REG_MCUFWDL, value32);
@@ -291,12 +288,8 @@ int rtl8723_download_fw(struct ieee80211
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
Index: wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
===================================================================
--- wireless-drivers-next.orig/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
+++ wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
@@ -124,9 +124,8 @@ static void _rtl8821ae_write_fw(struct i
 	pagenums = size / FW_8821AE_PAGE_SIZE;
 	remainsize = size % FW_8821AE_PAGE_SIZE;
 
-	if (pagenums > 8) {
+	if (pagenums > 8)
 		pr_err("Page numbers should not greater then 8\n");
-	}
 
 	for (page = 0; page < pagenums; page++) {
 		offset = page * FW_8821AE_PAGE_SIZE;
@@ -160,10 +159,6 @@ static int _rtl8821ae_fw_free_to_go(stru
 			  value32);
 		goto exit;
 	}
-
-	pr_err("Checksum report OK! REG_MCUFWDL:0x%08x\n",
-	       value32);
-
 	value32 = rtl_read_dword(rtlpriv, REG_MCUFWDL);
 	value32 |= MCUFWDL_RDY;
 	value32 &= ~WINTINI_RDY;
@@ -174,13 +169,8 @@ static int _rtl8821ae_fw_free_to_go(stru
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
