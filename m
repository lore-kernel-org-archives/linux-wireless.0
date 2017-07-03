Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36459 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754121AbdGCSkq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Jul 2017 14:40:46 -0400
Received: by mail-oi0-f68.google.com with SMTP id n2so12756020oig.3
        for <linux-wireless@vger.kernel.org>; Mon, 03 Jul 2017 11:40:45 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 01/11] rtlwifi: btcoex: Add power_on_setting routine
Date: Mon,  3 Jul 2017 13:40:28 -0500
Message-Id: <20170703184038.24669-2-Larry.Finger@lwfinger.net> (sfid-20170703_204050_837515_F07C35CA)
In-Reply-To: <20170703184038.24669-1-Larry.Finger@lwfinger.net>
References: <20170703184038.24669-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

New btcoex uses it to setup antenna before wifi on.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h | 1 +
 drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c      | 6 ++++++
 drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h      | 1 +
 3 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index ea12b9d63a73..bc523af7ef88 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -608,6 +608,7 @@ extern struct btc_coexist gl_bt_coexist;
 
 bool exhalbtc_initlize_variables(void);
 bool exhalbtc_bind_bt_coex_withadapter(void *adapter);
+void exhalbtc_power_on_setting(struct btc_coexist *btcoexist);
 void exhalbtc_init_hw_config(struct btc_coexist *btcoexist, bool wifi_only);
 void exhalbtc_init_coex_dm(struct btc_coexist *btcoexist);
 void exhalbtc_ips_notify(struct btc_coexist *btcoexist, u8 type);
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
index 4d9e33078d4f..9e3623b0423c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
@@ -32,6 +32,7 @@
 static struct rtl_btc_ops rtl_btc_operation = {
 	.btc_init_variables = rtl_btc_init_variables,
 	.btc_init_hal_vars = rtl_btc_init_hal_vars,
+	.btc_power_on_setting = rtl_btc_power_on_setting,
 	.btc_init_hw_config = rtl_btc_init_hw_config,
 	.btc_ips_notify = rtl_btc_ips_notify,
 	.btc_lps_notify = rtl_btc_lps_notify,
@@ -116,6 +117,11 @@ void rtl_btc_init_hal_vars(struct rtl_priv *rtlpriv)
 	 */
 }
 
+void rtl_btc_power_on_setting(struct rtl_priv *rtlpriv)
+{
+	exhalbtc_power_on_setting(&gl_bt_coexist);
+}
+
 void rtl_btc_init_hw_config(struct rtl_priv *rtlpriv)
 {
 	u8 bt_exist;
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h
index 40f1ce8c8a06..9becfa59407d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h
@@ -29,6 +29,7 @@
 
 void rtl_btc_init_variables(struct rtl_priv *rtlpriv);
 void rtl_btc_init_hal_vars(struct rtl_priv *rtlpriv);
+void rtl_btc_power_on_setting(struct rtl_priv *rtlpriv);
 void rtl_btc_init_hw_config(struct rtl_priv *rtlpriv);
 void rtl_btc_ips_notify(struct rtl_priv *rtlpriv, u8 type);
 void rtl_btc_lps_notify(struct rtl_priv *rtlpriv, u8 type);
-- 
2.12.3
