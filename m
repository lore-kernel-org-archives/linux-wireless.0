Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35814 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751284AbdFEPaH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Jun 2017 11:30:07 -0400
Received: by mail-oi0-f67.google.com with SMTP id f206so12649541oig.2
        for <linux-wireless@vger.kernel.org>; Mon, 05 Jun 2017 08:30:06 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v2 3/9] rtlwifi: btcoex: settings before firmware is downloaded
Date: Mon,  5 Jun 2017 10:29:53 -0500
Message-Id: <20170605152959.27439-4-Larry.Finger@lwfinger.net> (sfid-20170605_173035_832310_8440BD27)
In-Reply-To: <20170605152959.27439-1-Larry.Finger@lwfinger.net>
References: <20170605152959.27439-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

The btcoex is sometimes unstable because there are some unexpected
behaviors before the firmware has been downloaded successfully.

Therefore we force the antenna path settings to avoid this, then let the
firmware control the btcoexistence when the firmware is ready.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h    |  1 +
 .../wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h    |  2 ++
 .../net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c   | 13 +++++++++++++
 .../net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h   |  1 +
 4 files changed, 17 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
index 50726beaeead..a98b9548c3c7 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
@@ -196,5 +196,6 @@ void ex_btc8723b2ant_bt_info_notify(struct btc_coexist *btcoexist,
 void ex_btc8723b2ant_halt_notify(struct btc_coexist *btcoexist);
 void ex_btc8723b2ant_periodical(struct btc_coexist *btcoexist);
 void ex_btc8723b2ant_display_coex_info(struct btc_coexist *btcoexist);
+void ex_btc8723b2ant_pre_load_firmware(struct btc_coexist *btcoexist);
 
 #endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
index 1d6e3e9abd91..a839d5574422 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
@@ -228,3 +228,5 @@ void
 ex_btc8821a2ant_display_coex_info(
 	struct btc_coexist *btcoexist
 	);
+void ex_btc8821a2ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state);
+void ex_btc8821a2ant_pre_load_firmware(struct btc_coexist *btcoexist);
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index f13000612913..0cd4926c1ed7 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -690,6 +690,19 @@ bool exhalbtc_initlize_variables(struct rtl_priv *adapter)
 	return true;
 }
 
+void exhalbtc_pre_load_firmware(struct btc_coexist *btcoexist)
+{
+	if (!halbtc_is_bt_coexist_available(btcoexist))
+		return;
+
+	btcoexist->statistics.cnt_pre_load_firmware++;
+
+	if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8723b2ant_pre_load_firmware(btcoexist);
+	}
+}
+
 void exhalbtc_init_hw_config(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index c5c360e011a9..eca0e5a78ada 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -486,6 +486,7 @@ struct btc_statistics {
 	u32 cnt_coex_dm_switch;
 	u32 cnt_stack_operation_notify;
 	u32 cnt_dbg_ctrl;
+	u32 cnt_pre_load_firmware;
 };
 
 struct btc_bt_link_info {
-- 
2.13.0
