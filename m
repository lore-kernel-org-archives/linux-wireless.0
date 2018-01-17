Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:54057 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750885AbeAQGPw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jan 2018 01:15:52 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <yhchuang@realtek.com>,
        <linux-wireless@vger.kernel.org>
Subject: [PATCH v3 06/10] rtlwifi: btcoex: Add power_on_setting routine
Date: Wed, 17 Jan 2018 14:15:26 +0800
Message-ID: <20180117061530.30049-7-pkshih@realtek.com> (sfid-20180117_071557_443489_AEE9C7BB)
In-Reply-To: <20180117061530.30049-1-pkshih@realtek.com>
References: <20180117061530.30049-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

After mac power-on sequence, wifi will start to work so notify btcoex the
event to configure registers especially related to antenna. This will not
only help to assign antenna but also to yield better user experience.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h | 1 +
 drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c      | 6 ++++++
 drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h      | 1 +
 drivers/net/wireless/realtek/rtlwifi/wifi.h                   | 1 +
 4 files changed, 9 insertions(+)

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
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 941694060f48..b27dbe10b163 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2557,6 +2557,7 @@ struct bt_coexist_info {
 struct rtl_btc_ops {
 	void (*btc_init_variables) (struct rtl_priv *rtlpriv);
 	void (*btc_init_hal_vars) (struct rtl_priv *rtlpriv);
+	void (*btc_power_on_setting)(struct rtl_priv *rtlpriv);
 	void (*btc_init_hw_config) (struct rtl_priv *rtlpriv);
 	void (*btc_ips_notify) (struct rtl_priv *rtlpriv, u8 type);
 	void (*btc_lps_notify)(struct rtl_priv *rtlpriv, u8 type);
-- 
2.15.1
