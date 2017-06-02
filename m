Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33905 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdFBV2H (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 17:28:07 -0400
Received: by mail-oi0-f68.google.com with SMTP id d99so2085741oic.1
        for <linux-wireless@vger.kernel.org>; Fri, 02 Jun 2017 14:28:06 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 5/9] rtlwifi: btcoex: add settings before the hardware is ready
Date: Fri,  2 Jun 2017 16:27:44 -0500
Message-Id: <20170602212748.23857-6-Larry.Finger@lwfinger.net> (sfid-20170602_232819_620636_BE933C37)
In-Reply-To: <20170602212748.23857-1-Larry.Finger@lwfinger.net>
References: <20170602212748.23857-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

When the hardware is turned on and in the initialization stage, the PTA
circuit is unstable. Hence we need to force some hardware settings to
make sure the PTA circuit work correctly, otherwise it may affect the
user's experience.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h  |  1 +
 .../net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c | 15 +++++++++++++++
 .../net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h |  1 +
 3 files changed, 17 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
index ae3e450c5966..bc1e3042e271 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
@@ -198,5 +198,6 @@ void ex_btc8723b2ant_periodical(struct btc_coexist *btcoexist);
 void ex_btc8723b2ant_display_coex_info(struct btc_coexist *btcoexist);
 void ex_btc8723b2ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state);
 void ex_btc8723b2ant_pre_load_firmware(struct btc_coexist *btcoexist);
+void ex_btc8723b2ant_power_on_setting(struct btc_coexist *btcoexist);
 
 #endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index 5e6e14fd8c85..8b015e64af49 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -690,6 +690,21 @@ bool exhalbtc_initlize_variables(struct rtl_priv *adapter)
 	return true;
 }
 
+void exhalbtc_power_on_setting(struct btc_coexist *btcoexist)
+{
+	if (!halbtc_is_bt_coexist_available(btcoexist))
+		return;
+
+	btcoexist->statistics.cnt_power_on++;
+
+	if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8723b2ant_power_on_setting(btcoexist);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8723b1ant_power_on_setting(btcoexist);
+	}
+}
+
 void exhalbtc_pre_load_firmware(struct btc_coexist *btcoexist)
 {
 	if (!halbtc_is_bt_coexist_available(btcoexist))
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index eca0e5a78ada..9b0a6e9c5b20 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -487,6 +487,7 @@ struct btc_statistics {
 	u32 cnt_stack_operation_notify;
 	u32 cnt_dbg_ctrl;
 	u32 cnt_pre_load_firmware;
+	u32 cnt_power_on;
 };
 
 struct btc_bt_link_info {
-- 
2.13.0
