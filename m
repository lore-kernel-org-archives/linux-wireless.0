Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:39520 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751437AbeASGqT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Jan 2018 01:46:19 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 03/10] rtlwifi: btcoex: Add variable ant_div_cfg to support antenna diversity
Date: Fri, 19 Jan 2018 14:45:44 +0800
Message-ID: <20180119064551.10084-4-pkshih@realtek.com> (sfid-20180119_074626_699687_431F1385)
In-Reply-To: <20180119064551.10084-1-pkshih@realtek.com>
References: <20180119064551.10084-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

The variable will be used by btcoex of 8822be, so we prepare this variable
in advance.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c | 1 +
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index b51189ae1bfd..8dc646190e35 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -1310,6 +1310,7 @@ bool exhalbtc_bind_bt_coex_withadapter(void *adapter)
 			 "[BTCoex], Package Type = Non-TFBGA\n");
 
 	btcoexist->board_info.rfe_type = rtl_get_hwpg_rfe_type(rtlpriv);
+	btcoexist->board_info.ant_div_cfg = 0;
 
 	return true;
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index cd3925d34854..e0818f6efb87 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -153,6 +153,7 @@ struct btc_board_info {
 	bool tfbga_package;
 
 	u8 rfe_type;
+	u8 ant_div_cfg;
 };
 
 enum btc_dbg_opcode {
-- 
2.15.1
