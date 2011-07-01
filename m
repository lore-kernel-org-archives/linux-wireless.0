Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60457 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475Ab1GANut (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 09:50:49 -0400
Date: Fri, 01 Jul 2011 08:50:48 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: akpm@linux-foundation.org, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192de: Replace loops calling udelay with
 single mdelay
Message-ID: <4e0dd0b8.irNTM3ZWqD8ljlYa%Larry.Finger@lwfinger.net> (sfid-20110701_155055_637313_D9292F87)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are a number of loops to implement delays. These are replaced with
single calls to mdelay().

The need for a fix was noted by Andrew Morton <akpm@linux-foundation.org>.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
@@ -932,7 +932,7 @@ bool rtl92d_phy_config_rf_with_headerfil
 					  enum rf_content content,
 					  enum radio_path rfpath)
 {
-	int i, j;
+	int i;
 	u32 *radioa_array_table;
 	u32 *radiob_array_table;
 	u16 radioa_arraylen, radiob_arraylen;
@@ -974,13 +974,10 @@ bool rtl92d_phy_config_rf_with_headerfil
 				mdelay(50);
 			} else if (radioa_array_table[i] == 0xfd) {
 				/* delay_ms(5); */
-				for (j = 0; j < 100; j++)
-					udelay(MAX_STALL_TIME);
+				mdelay(5);
 			} else if (radioa_array_table[i] == 0xfc) {
 				/* delay_ms(1); */
-				for (j = 0; j < 20; j++)
-					udelay(MAX_STALL_TIME);
-
+				mdelay(1);
 			} else if (radioa_array_table[i] == 0xfb) {
 				udelay(50);
 			} else if (radioa_array_table[i] == 0xfa) {
@@ -1004,12 +1001,10 @@ bool rtl92d_phy_config_rf_with_headerfil
 				mdelay(50);
 			} else if (radiob_array_table[i] == 0xfd) {
 				/* delay_ms(5); */
-				for (j = 0; j < 100; j++)
-					udelay(MAX_STALL_TIME);
+				mdelay(5);
 			} else if (radiob_array_table[i] == 0xfc) {
 				/* delay_ms(1); */
-				for (j = 0; j < 20; j++)
-					udelay(MAX_STALL_TIME);
+				mdelay(1);
 			} else if (radiob_array_table[i] == 0xfb) {
 				udelay(50);
 			} else if (radiob_array_table[i] == 0xfa) {
@@ -1276,7 +1271,7 @@ static void rtl92d_phy_switch_wirelessba
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	u8 i, value8;
+	u8 value8;
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, ("==>\n"));
 	rtlhal->bandset = band;
@@ -1321,8 +1316,7 @@ static void rtl92d_phy_switch_wirelessba
 		rtl_write_byte(rtlpriv, (rtlhal->interfaceindex ==
 			0 ? REG_MAC0 : REG_MAC1), value8);
 	}
-	for (i = 0; i < 20; i++)
-		udelay(MAX_STALL_TIME);
+	mdelay(1);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, ("<==Switch Band OK.\n"));
 }
 
