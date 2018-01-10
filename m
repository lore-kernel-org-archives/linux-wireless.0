Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:42900 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752983AbeAJFUe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Jan 2018 00:20:34 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <yhchuang@realtek.com>,
        <linux-wireless@vger.kernel.org>
Subject: [PATCH 10/10] rtlwifi: btcoex: add rfe_type parameter to btcoex
Date: Wed, 10 Jan 2018 13:20:02 +0800
Message-ID: <20180110052002.9544-11-pkshih@realtek.com> (sfid-20180110_062038_746303_2E8C66DA)
In-Reply-To: <20180110052002.9544-1-pkshih@realtek.com>
References: <20180110052002.9544-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

btcoex configure antenna by rfe_type that is RF type programmed in efuse.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c | 10 ++++++++++
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h |  2 ++
 2 files changed, 12 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index 30d940cf3abf..7b7099cbb1c7 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -207,6 +207,14 @@ u8 rtl_get_hwpg_package_type(struct rtl_priv *rtlpriv)
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
 static
 bool halbtc_is_hw_mailbox_exist(struct btc_coexist *btcoexist)
 {
@@ -1309,6 +1317,8 @@ bool exhalbtc_bind_bt_coex_withadapter(void *adapter)
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], Package Type = Non-TFBGA\n");
 
+	btcoexist->board_info.rfe_type = rtl_get_hwpg_rfe_type(rtlpriv);
+
 	return true;
 }
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index cbbf5e5a9c9b..ee7bbbd87eae 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -151,6 +151,8 @@ struct btc_board_info {
 	u8 btdm_ant_pos;
 	u8 single_ant_path; /* current used for 8723b only, 1=>s0,  0=>s1 */
 	bool tfbga_package;
+
+	u8 rfe_type;
 };
 
 enum btc_dbg_opcode {
-- 
2.15.1
