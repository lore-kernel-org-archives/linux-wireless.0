Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33537 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S970086AbdEYRsX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 May 2017 13:48:23 -0400
Received: by mail-oi0-f67.google.com with SMTP id h4so38674234oib.0
        for <linux-wireless@vger.kernel.org>; Thu, 25 May 2017 10:48:22 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 3/7] rtlwifi: btcoex: bind bt to the adapter when initialization
Date: Thu, 25 May 2017 12:48:10 -0500
Message-Id: <20170525174814.25005-4-Larry.Finger@lwfinger.net> (sfid-20170525_194904_721739_F92FB4A6)
In-Reply-To: <20170525174814.25005-1-Larry.Finger@lwfinger.net>
References: <20170525174814.25005-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

the bt need the information of the adapter, hook it on the callback for
bt to operate and get properly initialized

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h | 1 +
 drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c      | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index 32cbbd0595ed..21d39973feab 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -600,6 +600,7 @@ bool halbtc_is_wifi_uplink(struct rtl_priv *adapter);
 extern struct btc_coexist gl_bt_coexist;
 
 bool exhalbtc_initlize_variables(void);
+bool exhalbtc_bind_bt_coex_withadapter(void *adapter);
 void exhalbtc_init_hw_config(struct btc_coexist *btcoexist);
 void exhalbtc_init_coex_dm(struct btc_coexist *btcoexist);
 void exhalbtc_ips_notify(struct btc_coexist *btcoexist, u8 type);
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
index 3ab0cfe26513..7d4a94efe260 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
@@ -50,6 +50,7 @@ static struct rtl_btc_ops rtl_btc_operation = {
 void rtl_btc_init_variables(struct rtl_priv *rtlpriv)
 {
 	exhalbtc_initlize_variables();
+	exhalbtc_bind_bt_coex_withadapter(rtlpriv);
 }
 
 void rtl_btc_init_hal_vars(struct rtl_priv *rtlpriv)
-- 
2.12.0
