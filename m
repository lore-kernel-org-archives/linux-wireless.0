Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43506 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519Ab1BWQOh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 11:14:37 -0500
Date: Wed, 23 Feb 2011 10:14:39 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: sfr@canb.auug.org.au, otavio@ossystems.com.br, w@1wt.eu,
	george0505@realtek.com, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org
Subject: [PATCH V2 4/5] rtlwifi: rtl8192cu: Fix for udelay too large
Message-ID: <4d65326f.0vNgH3uNBGHYMogT%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Willy Tarreau <w@1wt.eu>
Date: Sun, 20 Feb 2011 11:43:36 +0100
Subject: rtlwifi: Eliminate udelay calls with too large values

On ARM, compilation of rtlwifi/efuse.c fails with the message:
ERROR: "__bad_udelay" [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
On inspection, the faulty calls are in routine efuse_reset_loader(), a
routine that is never used, and the faulty routine is deleted.

Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 drivers/net/wireless/rtlwifi/efuse.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

Index: wireless-testing/drivers/net/wireless/rtlwifi/efuse.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/efuse.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/efuse.c
@@ -1169,21 +1169,3 @@ static u8 efuse_calculate_word_cnts(u8 w
 	return word_cnts;
 }
 
-void efuse_reset_loader(struct ieee80211_hw *hw)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u16 tmp_u2b;
-
-	tmp_u2b = rtl_read_word(rtlpriv, rtlpriv->cfg->maps[SYS_FUNC_EN]);
-	rtl_write_word(rtlpriv, rtlpriv->cfg->maps[SYS_FUNC_EN],
-		       (tmp_u2b & ~(BIT(12))));
-	udelay(10000);
-	rtl_write_word(rtlpriv, rtlpriv->cfg->maps[SYS_FUNC_EN],
-		       (tmp_u2b | BIT(12)));
-	udelay(10000);
-}
-
-bool efuse_program_map(struct ieee80211_hw *hw, char *p_filename, u8 tabletype)
-{
-	return true;
-}
Index: wireless-testing/drivers/net/wireless/rtlwifi/efuse.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/efuse.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/efuse.h
@@ -117,8 +117,5 @@ extern bool efuse_shadow_update_chk(stru
 extern void rtl_efuse_shadow_map_update(struct ieee80211_hw *hw);
 extern void efuse_force_write_vendor_Id(struct ieee80211_hw *hw);
 extern void efuse_re_pg_section(struct ieee80211_hw *hw, u8 section_idx);
-extern bool efuse_program_map(struct ieee80211_hw *hw,
-			      char *p_filename, u8 tabletype);
-extern void efuse_reset_loader(struct ieee80211_hw *hw);
 
 #endif
