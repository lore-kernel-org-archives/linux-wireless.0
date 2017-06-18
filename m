Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33424 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753150AbdFRQM5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Jun 2017 12:12:57 -0400
Received: by mail-oi0-f68.google.com with SMTP id k145so7238356oih.0
        for <linux-wireless@vger.kernel.org>; Sun, 18 Jun 2017 09:12:57 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 02/11] rtlwifi: btcoex: set correct interface type and parameter.
Date: Sun, 18 Jun 2017 11:12:40 -0500
Message-Id: <20170618161249.6146-3-Larry.Finger@lwfinger.net> (sfid-20170618_181309_943310_F33A3FBB)
In-Reply-To: <20170618161249.6146-1-Larry.Finger@lwfinger.net>
References: <20170618161249.6146-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

This commit fixies two problems. The first one is interface types
(e.g. PCI) that are used to switch antenna, and the second is to add
wifi_only parameter to give correct state.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c  | 18 +++++++++++++-----
 .../wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h  |  2 +-
 .../net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c   |  2 +-
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index f00d6e6ab69b..451039ac7b0a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -803,8 +803,6 @@ bool exhalbtc_initlize_variables(void)
 
 	halbtc_dbg_init();
 
-	btcoexist->chip_interface = BTC_INTF_UNKNOWN;
-
 	btcoexist->btc_read_1byte = halbtc_read_1byte;
 	btcoexist->btc_write_1byte = halbtc_write_1byte;
 	btcoexist->btc_write_1byte_bitmask = halbtc_bitmask_write_1byte;
@@ -843,6 +841,18 @@ bool exhalbtc_bind_bt_coex_withadapter(void *adapter)
 	if (btcoexist->binded)
 		return false;
 
+	switch (rtlpriv->rtlhal.interface) {
+	case INTF_PCI:
+		btcoexist->chip_interface = BTC_INTF_PCI;
+		break;
+	case INTF_USB:
+		btcoexist->chip_interface = BTC_INTF_USB;
+		break;
+	default:
+		btcoexist->chip_interface = BTC_INTF_UNKNOWN;
+		break;
+	}
+
 	btcoexist->binded = true;
 	btcoexist->statistics.cnt_bind++;
 
@@ -912,10 +922,8 @@ void exhalbtc_pre_load_firmware(struct btc_coexist *btcoexist)
 	}
 }
 
-void exhalbtc_init_hw_config(struct btc_coexist *btcoexist)
+void exhalbtc_init_hw_config(struct btc_coexist *btcoexist, bool wifi_only)
 {
-	bool wifi_only = true;
-
 	if (!halbtc_is_bt_coexist_available(btcoexist))
 		return;
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index 21d39973feab..f9b87c12db09 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -601,7 +601,7 @@ extern struct btc_coexist gl_bt_coexist;
 
 bool exhalbtc_initlize_variables(void);
 bool exhalbtc_bind_bt_coex_withadapter(void *adapter);
-void exhalbtc_init_hw_config(struct btc_coexist *btcoexist);
+void exhalbtc_init_hw_config(struct btc_coexist *btcoexist, bool wifi_only);
 void exhalbtc_init_coex_dm(struct btc_coexist *btcoexist);
 void exhalbtc_ips_notify(struct btc_coexist *btcoexist, u8 type);
 void exhalbtc_lps_notify(struct btc_coexist *btcoexist, u8 type);
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
index 7d4a94efe260..9635c1478875 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
@@ -68,7 +68,7 @@ void rtl_btc_init_hw_config(struct rtl_priv *rtlpriv)
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
 		"%s, bt_exist is %d\n", __func__, bt_exist);
 
-	exhalbtc_init_hw_config(&gl_bt_coexist);
+	exhalbtc_init_hw_config(&gl_bt_coexist, !bt_exist);
 	exhalbtc_init_coex_dm(&gl_bt_coexist);
 }
 
-- 
2.12.3
