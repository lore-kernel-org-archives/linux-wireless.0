Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35195 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752265AbdFURPu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Jun 2017 13:15:50 -0400
Received: by mail-oi0-f65.google.com with SMTP id v74so16298476oie.2
        for <linux-wireless@vger.kernel.org>; Wed, 21 Jun 2017 10:15:50 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v2 6/8] rtlwifi: Add ap_num field for btcoexist
Date: Wed, 21 Jun 2017 12:15:36 -0500
Message-Id: <20170621171538.4462-7-Larry.Finger@lwfinger.net> (sfid-20170621_191553_561907_3B589DC1)
In-Reply-To: <20170621171538.4462-1-Larry.Finger@lwfinger.net>
References: <20170621171538.4462-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

If there are many AP (dirty environment), we use another strategy set
to resolve coex issue.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c | 5 +----
 drivers/net/wireless/realtek/rtlwifi/pci.c                    | 1 +
 drivers/net/wireless/realtek/rtlwifi/wifi.h                   | 2 ++
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index ffa7a517b665..9dbb35f190d1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -503,10 +503,7 @@ static bool halbtc_get(void *void_btcoexist, u8 get_type, void *out_buf)
 		ret = false;
 		break;
 	case BTC_GET_U1_AP_NUM:
-		/* driver do not know AP num,
-		 * so the return value here is not right
-		 */
-		*u8_tmp = 1;
+		*u8_tmp = rtlpriv->btcoexist.btc_info.ap_num;
 		break;
 	case BTC_GET_U1_ANT_TYPE:
 		*u8_tmp = (u8)BTC_ANT_TYPE_0;
diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 2e6b888bd417..00a354c85ece 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -1826,6 +1826,7 @@ static int rtl_pci_start(struct ieee80211_hw *hw)
 	rtlpci->driver_is_goingto_unload = false;
 	if (rtlpriv->cfg->ops->get_btc_status &&
 	    rtlpriv->cfg->ops->get_btc_status()) {
+		rtlpriv->btcoexist.btc_info.ap_num = 36;
 		rtlpriv->btcoexist.btc_ops->btc_init_variables(rtlpriv);
 		rtlpriv->btcoexist.btc_ops->btc_init_hal_vars(rtlpriv);
 	}
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 49c0d2229274..2fb83a7061dd 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2481,6 +2481,8 @@ struct rtl_btc_info {
 	u8 btcoexist;
 	u8 ant_num;
 	u8 single_ant_path;
+
+	u8 ap_num;
 };
 
 struct bt_coexist_info {
-- 
2.12.3
