Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36187 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751286AbdGQPKD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 11:10:03 -0400
Received: by mail-oi0-f66.google.com with SMTP id n2so18150404oig.3
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jul 2017 08:10:03 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v2 01/11] rtlwifi: btcoex: Add power_on_setting routine
Date: Mon, 17 Jul 2017 10:09:44 -0500
Message-Id: <20170717150954.1441-2-Larry.Finger@lwfinger.net> (sfid-20170717_171009_722620_9BDAF63C)
In-Reply-To: <20170717150954.1441-1-Larry.Finger@lwfinger.net>
References: <20170717150954.1441-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

New btcoex uses it to setup antenna before wifi on.

This patch also restores the content of commit f95d95a7cd55 ("rtlwifi:
btcoex: rtl8723be: fix ant_sel not work"), which caused a kernel oops
without this material.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
v2 - Add the material in commit f95d95a7cd55, which had to be reverted.
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h | 1 +
 drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c      | 6 ++++++
 drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h      | 1 +
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c           | 3 +++
 drivers/net/wireless/realtek/rtlwifi/wifi.h                   | 1 +
 5 files changed, 12 insertions(+)

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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
index 4d47b97adfed..0b9366e7acbd 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
@@ -846,6 +846,9 @@ static bool _rtl8723be_init_mac(struct ieee80211_hw *hw)
 		return false;
 	}
 
+	if (rtlpriv->cfg->ops->get_btc_status())
+		rtlpriv->btcoexist.btc_ops->btc_power_on_setting(rtlpriv);
+
 	bytetmp = rtl_read_byte(rtlpriv, REG_MULTI_FUNC_CTRL);
 	rtl_write_byte(rtlpriv, REG_MULTI_FUNC_CTRL, bytetmp | BIT(3));
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 71a523e342b7..6c3ff4a73d19 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2550,6 +2550,7 @@ struct bt_coexist_info {
 struct rtl_btc_ops {
 	void (*btc_init_variables) (struct rtl_priv *rtlpriv);
 	void (*btc_init_hal_vars) (struct rtl_priv *rtlpriv);
+	void (*btc_power_on_setting)(struct rtl_priv *rtlpriv);
 	void (*btc_init_hw_config) (struct rtl_priv *rtlpriv);
 	void (*btc_ips_notify) (struct rtl_priv *rtlpriv, u8 type);
 	void (*btc_lps_notify)(struct rtl_priv *rtlpriv, u8 type);
-- 
2.12.3
