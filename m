Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35483 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750728AbdGUEYz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Jul 2017 00:24:55 -0400
Received: by mail-oi0-f67.google.com with SMTP id h143so3947605oic.2
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jul 2017 21:24:55 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 07/10] rtlwifi: btcoex: btcoexist needs rfe_type to make decision
Date: Thu, 20 Jul 2017 23:24:37 -0500
Message-Id: <20170721042440.15839-8-Larry.Finger@lwfinger.net> (sfid-20170721_062514_334481_B8096DFC)
In-Reply-To: <20170721042440.15839-1-Larry.Finger@lwfinger.net>
References: <20170721042440.15839-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

btcoex uses rfe_type to configure antenna properly.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c | 10 ++++++++++
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h |  2 ++
 2 files changed, 12 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index e26bbdf3a733..6847b1abb4ab 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -200,6 +200,14 @@ u8 rtl_get_hwpg_package_type(struct rtl_priv *rtlpriv)
 	return rtlhal->package_type;
 }
 
+static
+u8 rtl_get_hwpg_rfe_type(struct rtl_priv *rtlpriv)
+{
+	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
+
+	return rtlhal->rfe_type;
+}
+
 /* ************************************
  *         Hal helper function
  * ************************************
@@ -1215,6 +1223,8 @@ bool exhalbtc_bind_bt_coex_withadapter(void *adapter)
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], Package Type = Non-TFBGA\n");
 
+	btcoexist->board_info.rfe_type = rtl_get_hwpg_rfe_type(rtlpriv);
+
 	return true;
 }
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index 8704d632bac8..91ba49586dbe 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -153,6 +153,8 @@ struct btc_board_info {
 	u8 btdm_ant_pos;
 	u8 single_ant_path; /* current used for 8723b only, 1=>s0,  0=>s1 */
 	bool tfbga_package;
+
+	u8 rfe_type;
 };
 
 enum btc_dbg_opcode {
-- 
2.12.3
