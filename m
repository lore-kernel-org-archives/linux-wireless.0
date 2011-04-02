Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63737 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017Ab1DBXKa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Apr 2011 19:10:30 -0400
Date: Sat, 02 Apr 2011 18:10:22 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	chaoming_li@realsil.com.cn
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: Fix some warnings/bugs
Message-ID: <4d97acde.h9Lh18BNtdym9By2%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some compiler/architecture combinations generate some warnings that are
not seen on my main system. Two of the "warnings" about unitialized variables
are really bugs.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is 2.6.39 material.

Larry
---

Index: linux-2.6/drivers/net/wireless/rtlwifi/efuse.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/rtlwifi/efuse.c
+++ linux-2.6/drivers/net/wireless/rtlwifi/efuse.c
@@ -685,7 +685,7 @@ static int efuse_pg_packet_read(struct i
 
 	u8 efuse_data, word_cnts = 0;
 	u16 efuse_addr = 0;
-	u8 hworden;
+	u8 hworden = 0;
 	u8 tmpdata[8];
 
 	if (data == NULL)
Index: linux-2.6/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
+++ linux-2.6/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
@@ -303,7 +303,7 @@ static void _rtl92c_fill_h2c_command(str
 	u16 box_reg, box_extreg;
 	u8 u1b_tmp;
 	bool isfw_read = false;
-	u8 buf_index;
+	u8 buf_index = 0;
 	bool bwrite_sucess = false;
 	u8 wait_h2c_limmit = 100;
 	u8 wait_writeh2c_limmit = 100;
Index: linux-2.6/drivers/net/wireless/rtlwifi/usb.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/rtlwifi/usb.c
+++ linux-2.6/drivers/net/wireless/rtlwifi/usb.c
@@ -246,7 +246,7 @@ static void _rtl_usb_io_handler_init(str
 
 static void _rtl_usb_io_handler_release(struct ieee80211_hw *hw)
 {
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_priv __maybe_unused *rtlpriv = rtl_priv(hw);
 
 	mutex_destroy(&rtlpriv->io.bb_mutex);
 }
