Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46312 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab1CQSJF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2011 14:09:05 -0400
Received: by vxi39 with SMTP id 39so2860560vxi.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2011 11:09:04 -0700 (PDT)
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: Fix memset argument order
Date: Thu, 17 Mar 2011 14:08:57 -0400
Message-Id: <1300385337-27760-1-git-send-email-imirkin@alum.mit.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These were found using the following semantic match:
// <smpl>
@@expression E1; type T;@@
* memset(E1, ... * sizeof(T) * ..., ...);
// </smpl>

Also take this opportunity to remove the unnecessary void* casts.

Signed-off-by: Ilia Mirkin <imirkin@alum.mit.edu>
---

I do not have the hardware for this, but reading the code, it makes
sense that the length of the memsets is currently the second argument
instead of the third.

 drivers/net/wireless/rtlwifi/efuse.c |   31 +++++++++++++++----------------
 1 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/efuse.c b/drivers/net/wireless/rtlwifi/efuse.c
index 4f92cba..f74a870 100644
--- a/drivers/net/wireless/rtlwifi/efuse.c
+++ b/drivers/net/wireless/rtlwifi/efuse.c
@@ -410,8 +410,8 @@ bool efuse_shadow_update(struct ieee80211_hw *hw)
 
 	if (!efuse_shadow_update_chk(hw)) {
 		efuse_read_all_map(hw, &rtlefuse->efuse_map[EFUSE_INIT_MAP][0]);
-		memcpy((void *)&rtlefuse->efuse_map[EFUSE_MODIFY_MAP][0],
-		       (void *)&rtlefuse->efuse_map[EFUSE_INIT_MAP][0],
+		memcpy(&rtlefuse->efuse_map[EFUSE_MODIFY_MAP][0],
+		       &rtlefuse->efuse_map[EFUSE_INIT_MAP][0],
 		       rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE]);
 
 		RT_TRACE(rtlpriv, COMP_EFUSE, DBG_LOUD,
@@ -446,9 +446,9 @@ bool efuse_shadow_update(struct ieee80211_hw *hw)
 
 		if (word_en != 0x0F) {
 			u8 tmpdata[8];
-			memcpy((void *)tmpdata,
-			       (void *)(&rtlefuse->
-					efuse_map[EFUSE_MODIFY_MAP][base]), 8);
+			memcpy(tmpdata,
+			       &rtlefuse->efuse_map[EFUSE_MODIFY_MAP][base],
+			       8);
 			RT_PRINT_DATA(rtlpriv, COMP_INIT, DBG_LOUD,
 				      ("U-efuse\n"), tmpdata, 8);
 
@@ -465,8 +465,8 @@ bool efuse_shadow_update(struct ieee80211_hw *hw)
 	efuse_power_switch(hw, true, false);
 	efuse_read_all_map(hw, &rtlefuse->efuse_map[EFUSE_INIT_MAP][0]);
 
-	memcpy((void *)&rtlefuse->efuse_map[EFUSE_MODIFY_MAP][0],
-	       (void *)&rtlefuse->efuse_map[EFUSE_INIT_MAP][0],
+	memcpy(&rtlefuse->efuse_map[EFUSE_MODIFY_MAP][0],
+	       &rtlefuse->efuse_map[EFUSE_INIT_MAP][0],
 	       rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE]);
 
 	RT_TRACE(rtlpriv, COMP_EFUSE, DBG_LOUD, ("<---\n"));
@@ -479,13 +479,12 @@ void rtl_efuse_shadow_map_update(struct ieee80211_hw *hw)
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
 
 	if (rtlefuse->autoload_failflag == true) {
-		memset((void *)(&rtlefuse->efuse_map[EFUSE_INIT_MAP][0]), 128,
-		       0xFF);
+		memset(&rtlefuse->efuse_map[EFUSE_INIT_MAP][0], 0xFF, 128);
 	} else
 		efuse_read_all_map(hw, &rtlefuse->efuse_map[EFUSE_INIT_MAP][0]);
 
-	memcpy((void *)&rtlefuse->efuse_map[EFUSE_MODIFY_MAP][0],
-	       (void *)&rtlefuse->efuse_map[EFUSE_INIT_MAP][0],
+	memcpy(&rtlefuse->efuse_map[EFUSE_MODIFY_MAP][0],
+	       &rtlefuse->efuse_map[EFUSE_INIT_MAP][0],
 	       rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE]);
 
 }
@@ -694,8 +693,8 @@ static int efuse_pg_packet_read(struct ieee80211_hw *hw, u8 offset, u8 *data)
 	if (offset > 15)
 		return false;
 
-	memset((void *)data, PGPKT_DATA_SIZE * sizeof(u8), 0xff);
-	memset((void *)tmpdata, PGPKT_DATA_SIZE * sizeof(u8), 0xff);
+	memset(data, 0xff, PGPKT_DATA_SIZE * sizeof(u8));
+	memset(tmpdata, 0xff, PGPKT_DATA_SIZE * sizeof(u8));
 
 	while (bcontinual && (efuse_addr < EFUSE_MAX_SIZE)) {
 		if (readstate & PG_STATE_HEADER) {
@@ -862,7 +861,7 @@ static void efuse_write_data_case2(struct ieee80211_hw *hw, u16 *efuse_addr,
 
 		tmp_word_cnts = efuse_calculate_word_cnts(tmp_pkt.word_en);
 
-		memset((void *)originaldata, 8 * sizeof(u8), 0xff);
+		memset(originaldata, 0xff, 8 * sizeof(u8));
 
 		if (efuse_pg_packet_read(hw, tmp_pkt.offset, originaldata)) {
 			badworden = efuse_word_enable_data_write(hw,
@@ -917,7 +916,7 @@ static int efuse_pg_packet_write(struct ieee80211_hw *hw,
 	target_pkt.offset = offset;
 	target_pkt.word_en = word_en;
 
-	memset((void *)target_pkt.data, 8 * sizeof(u8), 0xFF);
+	memset(target_pkt.data, 0xFF, 8 * sizeof(u8));
 
 	efuse_word_enable_data_read(word_en, data, target_pkt.data);
 	target_word_cnts = efuse_calculate_word_cnts(target_pkt.word_en);
@@ -1022,7 +1021,7 @@ static u8 efuse_word_enable_data_write(struct ieee80211_hw *hw,
 	u8 badworden = 0x0F;
 	u8 tmpdata[8];
 
-	memset((void *)tmpdata, PGPKT_DATA_SIZE, 0xff);
+	memset(tmpdata, 0xff, PGPKT_DATA_SIZE);
 	RT_TRACE(rtlpriv, COMP_EFUSE, DBG_LOUD,
 		 ("word_en = %x efuse_addr=%x\n", word_en, efuse_addr));
 
-- 
1.7.3.4

