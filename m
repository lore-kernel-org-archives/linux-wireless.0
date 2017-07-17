Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34563 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751300AbdGQOe0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 10:34:26 -0400
Received: by mail-oi0-f66.google.com with SMTP id d77so18024428oig.1
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jul 2017 07:34:26 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH] Revert "rtlwifi: btcoex: rtl8723be: fix ant_sel not work"
Date: Mon, 17 Jul 2017 09:34:19 -0500
Message-Id: <20170717143419.12865-1-Larry.Finger@lwfinger.net> (sfid-20170717_163430_903602_3447B7E4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit f95d95a7cd5514549dcf6ba754f0ee834cce3e1f.

With commit f95d95a7cd55 ("rtlwifi: btcoex: rtl8723be: fix ant_sel not
work"), the kernel has a NULL pointer dereference oops. This content and
the proper fix will be included in a later patch.

Fixes: f95d95a7cd55 ("rtlwifi: btcoex: rtl8723be: fix ant_sel not work")
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
Kalle,

This patch needs to be applied to kernel 4.13. Sorry that it slipped
through.

Larry
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c | 3 ---
 drivers/net/wireless/realtek/rtlwifi/wifi.h         | 1 -
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
index 2a7ad5ffe997..cd5dc6dcb19f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
@@ -846,9 +846,6 @@ static bool _rtl8723be_init_mac(struct ieee80211_hw *hw)
 		return false;
 	}
 
-	if (rtlpriv->cfg->ops->get_btc_status())
-		rtlpriv->btcoexist.btc_ops->btc_power_on_setting(rtlpriv);
-
 	bytetmp = rtl_read_byte(rtlpriv, REG_MULTI_FUNC_CTRL);
 	rtl_write_byte(rtlpriv, REG_MULTI_FUNC_CTRL, bytetmp | BIT(3));
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index fb1ebb01133f..70723e67b7d7 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2547,7 +2547,6 @@ struct bt_coexist_info {
 struct rtl_btc_ops {
 	void (*btc_init_variables) (struct rtl_priv *rtlpriv);
 	void (*btc_init_hal_vars) (struct rtl_priv *rtlpriv);
-	void (*btc_power_on_setting)(struct rtl_priv *rtlpriv);
 	void (*btc_init_hw_config) (struct rtl_priv *rtlpriv);
 	void (*btc_ips_notify) (struct rtl_priv *rtlpriv, u8 type);
 	void (*btc_lps_notify)(struct rtl_priv *rtlpriv, u8 type);
-- 
2.12.3
