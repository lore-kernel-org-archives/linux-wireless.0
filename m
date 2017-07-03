Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35722 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754188AbdGCSky (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Jul 2017 14:40:54 -0400
Received: by mail-oi0-f68.google.com with SMTP id l130so20125486oib.2
        for <linux-wireless@vger.kernel.org>; Mon, 03 Jul 2017 11:40:54 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 09/11] rtlwifi: Remove BAND_NUM and related fields
Date: Mon,  3 Jul 2017 13:40:36 -0500
Message-Id: <20170703184038.24669-10-Larry.Finger@lwfinger.net> (sfid-20170703_204102_618861_67A1533E)
In-Reply-To: <20170703184038.24669-1-Larry.Finger@lwfinger.net>
References: <20170703184038.24669-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

These fields are unused, and we will define them in phydm later.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/wifi.h | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 4dbce5f4c2db..9e1914bf014d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -172,7 +172,6 @@ enum rtl8192c_h2c_cmd {
 #define BUFDESC_SEG_NUM		1 /* 0:2 seg, 1: 4 seg, 2: 8 seg */
 
 #define DEL_SW_IDX_SZ		30
-#define BAND_NUM			3
 
 /* For now, it's just for 8192ee
  * but not OK yet, keep it 0
@@ -1748,21 +1747,6 @@ struct rtl_dm {
 	s8	swing_diff_2g;
 	s8	swing_diff_5g;
 
-	u8 delta_swing_table_idx_24gccka_p[DEL_SW_IDX_SZ];
-	u8 delta_swing_table_idx_24gccka_n[DEL_SW_IDX_SZ];
-	u8 delta_swing_table_idx_24gcckb_p[DEL_SW_IDX_SZ];
-	u8 delta_swing_table_idx_24gcckb_n[DEL_SW_IDX_SZ];
-	u8 delta_swing_table_idx_24ga_p[DEL_SW_IDX_SZ];
-	u8 delta_swing_table_idx_24ga_n[DEL_SW_IDX_SZ];
-	u8 delta_swing_table_idx_24gb_p[DEL_SW_IDX_SZ];
-	u8 delta_swing_table_idx_24gb_n[DEL_SW_IDX_SZ];
-	u8 delta_swing_table_idx_5ga_p[BAND_NUM][DEL_SW_IDX_SZ];
-	u8 delta_swing_table_idx_5ga_n[BAND_NUM][DEL_SW_IDX_SZ];
-	u8 delta_swing_table_idx_5gb_p[BAND_NUM][DEL_SW_IDX_SZ];
-	u8 delta_swing_table_idx_5gb_n[BAND_NUM][DEL_SW_IDX_SZ];
-	u8 delta_swing_table_idx_24ga_p_8188e[DEL_SW_IDX_SZ];
-	u8 delta_swing_table_idx_24ga_n_8188e[DEL_SW_IDX_SZ];
-
 	/* DMSP */
 	bool supp_phymode_switch;
 
-- 
2.12.3
