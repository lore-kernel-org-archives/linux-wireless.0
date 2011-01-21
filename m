Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51005 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab1AUT5E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 14:57:04 -0500
Date: Fri, 21 Jan 2011 13:57:37 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: Fix firmware upload errors
Message-ID: <4d39e531.0rk48a+WQ91WHhKW%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaoming Li <chaoming_li@realsil.com.cn>

When the source code from Realtek was prepared for kernel inclusion,
some routines were refactored to reduce the level of indentation. This
patch repairs errors introduced in that process.

Signed-off-by: Chaoming Li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is 2.6.38 material.

Larry
---

Index: linux-2.6/drivers/net/wireless/rtlwifi/efuse.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/rtlwifi/efuse.c
+++ linux-2.6/drivers/net/wireless/rtlwifi/efuse.c
@@ -726,9 +726,9 @@ static int efuse_pg_packet_read(struct i
 }
 
 static void efuse_write_data_case1(struct ieee80211_hw *hw, u16 *efuse_addr,
-				u8 efuse_data, u8 offset, int *bcontinual,
-				u8 *write_state, struct pgpkt_struct target_pkt,
-				int *repeat_times, int *bresult, u8 word_en)
+			u8 efuse_data, u8 offset, int *bcontinual,
+			u8 *write_state, struct pgpkt_struct *target_pkt,
+			int *repeat_times, int *bresult, u8 word_en)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct pgpkt_struct tmp_pkt;
@@ -744,8 +744,8 @@ static void efuse_write_data_case1(struc
 	tmp_pkt.word_en = tmp_header & 0x0F;
 	tmp_word_cnts = efuse_calculate_word_cnts(tmp_pkt.word_en);
 
-	if (tmp_pkt.offset != target_pkt.offset) {
-		efuse_addr = efuse_addr + (tmp_word_cnts * 2) + 1;
+	if (tmp_pkt.offset != target_pkt->offset) {
+		*efuse_addr = *efuse_addr + (tmp_word_cnts * 2) + 1;
 		*write_state = PG_STATE_HEADER;
 	} else {
 		for (tmpindex = 0; tmpindex < (tmp_word_cnts * 2); tmpindex++) {
@@ -756,23 +756,23 @@ static void efuse_write_data_case1(struc
 		}
 
 		if (bdataempty == false) {
-			efuse_addr = efuse_addr + (tmp_word_cnts * 2) + 1;
+			*efuse_addr = *efuse_addr + (tmp_word_cnts * 2) + 1;
 			*write_state = PG_STATE_HEADER;
 		} else {
 			match_word_en = 0x0F;
-			if (!((target_pkt.word_en & BIT(0)) |
+			if (!((target_pkt->word_en & BIT(0)) |
 			     (tmp_pkt.word_en & BIT(0))))
 				match_word_en &= (~BIT(0));
 
-			if (!((target_pkt.word_en & BIT(1)) |
+			if (!((target_pkt->word_en & BIT(1)) |
 			     (tmp_pkt.word_en & BIT(1))))
 				match_word_en &= (~BIT(1));
 
-			if (!((target_pkt.word_en & BIT(2)) |
+			if (!((target_pkt->word_en & BIT(2)) |
 			     (tmp_pkt.word_en & BIT(2))))
 				match_word_en &= (~BIT(2));
 
-			if (!((target_pkt.word_en & BIT(3)) |
+			if (!((target_pkt->word_en & BIT(3)) |
 			     (tmp_pkt.word_en & BIT(3))))
 				match_word_en &= (~BIT(3));
 
@@ -780,7 +780,7 @@ static void efuse_write_data_case1(struc
 				badworden = efuse_word_enable_data_write(
 							    hw, *efuse_addr + 1,
 							    tmp_pkt.word_en,
-							    target_pkt.data);
+							    target_pkt->data);
 
 				if (0x0F != (badworden & 0x0F)) {
 					u8 reorg_offset = offset;
@@ -791,26 +791,26 @@ static void efuse_write_data_case1(struc
 				}
 
 				tmp_word_en = 0x0F;
-				if ((target_pkt.word_en & BIT(0)) ^
+				if ((target_pkt->word_en & BIT(0)) ^
 				    (match_word_en & BIT(0)))
 					tmp_word_en &= (~BIT(0));
 
-				if ((target_pkt.word_en & BIT(1)) ^
+				if ((target_pkt->word_en & BIT(1)) ^
 				    (match_word_en & BIT(1)))
 					tmp_word_en &= (~BIT(1));
 
-				if ((target_pkt.word_en & BIT(2)) ^
+				if ((target_pkt->word_en & BIT(2)) ^
 					(match_word_en & BIT(2)))
 					tmp_word_en &= (~BIT(2));
 
-				if ((target_pkt.word_en & BIT(3)) ^
+				if ((target_pkt->word_en & BIT(3)) ^
 				    (match_word_en & BIT(3)))
 					tmp_word_en &= (~BIT(3));
 
 				if ((tmp_word_en & 0x0F) != 0x0F) {
 					*efuse_addr = efuse_get_current_size(hw);
-					target_pkt.offset = offset;
-					target_pkt.word_en = tmp_word_en;
+					target_pkt->offset = offset;
+					target_pkt->word_en = tmp_word_en;
 				} else
 					*bcontinual = false;
 				*write_state = PG_STATE_HEADER;
@@ -821,8 +821,8 @@ static void efuse_write_data_case1(struc
 				}
 			} else {
 				*efuse_addr += (2 * tmp_word_cnts) + 1;
-				target_pkt.offset = offset;
-				target_pkt.word_en = word_en;
+				target_pkt->offset = offset;
+				target_pkt->word_en = word_en;
 				*write_state = PG_STATE_HEADER;
 			}
 		}
@@ -938,7 +938,7 @@ static int efuse_pg_packet_write(struct
 				efuse_write_data_case1(hw, &efuse_addr,
 						       efuse_data, offset,
 						       &bcontinual,
-						       &write_state, target_pkt,
+						       &write_state, &target_pkt,
 						       &repeat_times, &bresult,
 						       word_en);
 			else
