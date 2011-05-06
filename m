Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34786 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932562Ab1EFS4V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 14:56:21 -0400
Date: Fri, 06 May 2011 13:56:18 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: Move 2 large arrays off stack
Message-ID: <4dc44452.VYlyUCQ0PmHIzqvK%Larry.Finger@lwfinger.net> (sfid-20110506_205630_747380_C8961205)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In driver rtlwifi, efuse_read() places two relatively large arrays on the
stack - a 1D u8 array of size 128, and a 2D array of u16 with 128 * 4 elements.
With driver rtl8192de, the sizes will be 256 and 256 * 4 respectively. As that
will make the 2D array be 2048 bytes, I have changed the code to use kmalloc to
allocate the space.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is 2.6.40 material.

Larry
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/efuse.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/efuse.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/efuse.c
@@ -235,7 +235,7 @@ void read_efuse(struct ieee80211_hw *hw,
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
-	u8 efuse_tbl[HWSET_MAX_SIZE];
+	u8 *efuse_tbl;
 	u8 rtemp8[1];
 	u16 efuse_addr = 0;
 	u8 offset, wren;
@@ -245,7 +245,7 @@ void read_efuse(struct ieee80211_hw *hw,
 		rtlpriv->cfg->maps[EFUSE_MAX_SECTION_MAP];
 	const u32 efuse_len =
 		rtlpriv->cfg->maps[EFUSE_REAL_CONTENT_SIZE];
-	u16 efuse_word[EFUSE_MAX_SECTION][EFUSE_MAX_WORD_UNIT];
+	u16 **efuse_word;
 	u16 efuse_utilized = 0;
 	u8 efuse_usage;
 
@@ -256,9 +256,24 @@ void read_efuse(struct ieee80211_hw *hw,
 		return;
 	}
 
+	/* allocate memory for efuse_tbl and efuse_word */
+	efuse_tbl = kmalloc(rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE] *
+			    sizeof(u8), GFP_ATOMIC);
+	if (!efuse_tbl)
+		return;
+	efuse_word = kmalloc(EFUSE_MAX_WORD_UNIT * sizeof(u16 *), GFP_ATOMIC);
+	if (!efuse_word)
+		goto done;
+	for (i = 0; i < EFUSE_MAX_WORD_UNIT; i++) {
+		efuse_word[i] = kmalloc(efuse_max_section * sizeof(u16),
+					GFP_ATOMIC);
+		if (!efuse_word[i])
+			goto done;
+	}
+
 	for (i = 0; i < efuse_max_section; i++)
 		for (j = 0; j < EFUSE_MAX_WORD_UNIT; j++)
-			efuse_word[i][j] = 0xFFFF;
+			efuse_word[j][i] = 0xFFFF;
 
 	read_efuse_byte(hw, efuse_addr, rtemp8);
 	if (*rtemp8 != 0xFF) {
@@ -285,7 +300,8 @@ void read_efuse(struct ieee80211_hw *hw,
 					read_efuse_byte(hw, efuse_addr, rtemp8);
 					efuse_addr++;
 					efuse_utilized++;
-					efuse_word[offset][i] = (*rtemp8 & 0xff);
+					efuse_word[i][offset] =
+							 (*rtemp8 & 0xff);
 
 					if (efuse_addr >= efuse_len)
 						break;
@@ -297,7 +313,7 @@ void read_efuse(struct ieee80211_hw *hw,
 					read_efuse_byte(hw, efuse_addr, rtemp8);
 					efuse_addr++;
 					efuse_utilized++;
-					efuse_word[offset][i] |=
+					efuse_word[i][offset] |=
 					    (((u16)*rtemp8 << 8) & 0xff00);
 
 					if (efuse_addr >= efuse_len)
@@ -320,9 +336,9 @@ void read_efuse(struct ieee80211_hw *hw,
 	for (i = 0; i < efuse_max_section; i++) {
 		for (j = 0; j < EFUSE_MAX_WORD_UNIT; j++) {
 			efuse_tbl[(i * 8) + (j * 2)] =
-			    (efuse_word[i][j] & 0xff);
+			    (efuse_word[j][i] & 0xff);
 			efuse_tbl[(i * 8) + ((j * 2) + 1)] =
-			    ((efuse_word[i][j] >> 8) & 0xff);
+			    ((efuse_word[j][i] >> 8) & 0xff);
 		}
 	}
 
@@ -336,6 +352,11 @@ void read_efuse(struct ieee80211_hw *hw,
 				      (u8 *)&efuse_utilized);
 	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_EFUSE_USAGE,
 				      (u8 *)&efuse_usage);
+done:
+	for (i = 0; i < EFUSE_MAX_WORD_UNIT; i++)
+		kfree(efuse_word[i]);
+	kfree(efuse_word);
+	kfree(efuse_tbl);
 }
 
 bool efuse_shadow_update_chk(struct ieee80211_hw *hw)
