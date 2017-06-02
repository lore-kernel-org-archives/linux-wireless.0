Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35344 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751164AbdFBV2F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 17:28:05 -0400
Received: by mail-oi0-f66.google.com with SMTP id f206so3956182oig.2
        for <linux-wireless@vger.kernel.org>; Fri, 02 Jun 2017 14:28:05 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 4/9] rtlwifi: btcoex: hook external PnP notify by chip for wifi driver
Date: Fri,  2 Jun 2017 16:27:43 -0500
Message-Id: <20170602212748.23857-5-Larry.Finger@lwfinger.net> (sfid-20170602_232811_086611_75BE8E3C)
In-Reply-To: <20170602212748.23857-1-Larry.Finger@lwfinger.net>
References: <20170602212748.23857-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Hook the chip-specific PnP notify functions for the wifi driver to
notify btcoexistence.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.h        |  1 +
 .../wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c  | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
index a98b9548c3c7..ae3e450c5966 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
@@ -196,6 +196,7 @@ void ex_btc8723b2ant_bt_info_notify(struct btc_coexist *btcoexist,
 void ex_btc8723b2ant_halt_notify(struct btc_coexist *btcoexist);
 void ex_btc8723b2ant_periodical(struct btc_coexist *btcoexist);
 void ex_btc8723b2ant_display_coex_info(struct btc_coexist *btcoexist);
+void ex_btc8723b2ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state);
 void ex_btc8723b2ant_pre_load_firmware(struct btc_coexist *btcoexist);
 
 #endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index 0cd4926c1ed7..5e6e14fd8c85 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -916,6 +916,24 @@ void exhalbtc_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state)
 {
 	if (!halbtc_is_bt_coexist_available(btcoexist))
 		return;
+
+	/* currently only 1ant we have to do the notification,
+	 * once pnp is notified to sleep state, we have to leave LPS that
+	 * we can sleep normally.
+	 */
+
+	if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8723b1ant_pnp_notify(btcoexist, pnp_state);
+		else if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8723b2ant_pnp_notify(btcoexist, pnp_state);
+	} else if (IS_HARDWARE_TYPE_8821(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8821a1ant_pnp_notify(btcoexist, pnp_state);
+		else if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8821a2ant_pnp_notify(btcoexist, pnp_state);
+	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
+	}
 }
 
 void exhalbtc_periodical(struct btc_coexist *btcoexist)
-- 
2.13.0
