Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33444 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753232AbdFRQNF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Jun 2017 12:13:05 -0400
Received: by mail-oi0-f65.google.com with SMTP id k145so7238576oih.0
        for <linux-wireless@vger.kernel.org>; Sun, 18 Jun 2017 09:13:05 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 10/11] rtlwifi: add btc_is_bt_lps_on() for btcoexist
Date: Sun, 18 Jun 2017 11:12:48 -0500
Message-Id: <20170618161249.6146-11-Larry.Finger@lwfinger.net> (sfid-20170618_181319_171589_51C52902)
In-Reply-To: <20170618161249.6146-1-Larry.Finger@lwfinger.net>
References: <20170618161249.6146-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

If LPS is controlled by btcoex, this function tell driver LPS is on or off.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c | 6 ++++++
 drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h | 1 +
 drivers/net/wireless/realtek/rtlwifi/wifi.h              | 1 +
 3 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
index 96c1ccbf70ac..7ee2aa94fd2a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
@@ -46,6 +46,7 @@ static struct rtl_btc_ops rtl_btc_operation = {
 	.btc_is_bt_disabled = rtl_btc_is_bt_disabled,
 	.btc_special_packet_notify = rtl_btc_special_packet_notify,
 	.btc_record_pwr_mode = rtl_btc_record_pwr_mode,
+	.btc_is_bt_lps_on = rtl_btc_is_bt_lps_on,
 	.btc_get_ampdu_cfg = rtl_btc_get_ampdu_cfg,
 };
 
@@ -61,6 +62,11 @@ void rtl_btc_record_pwr_mode(struct rtl_priv *rtlpriv, u8 *buf, u8 len)
 	memcpy(gl_bt_coexist.pwr_mode_val, buf, safe_len);
 }
 
+bool rtl_btc_is_bt_lps_on(struct rtl_priv *rtlpriv)
+{
+	return gl_bt_coexist.bt_info.bt_lps_on;
+}
+
 void rtl_btc_get_ampdu_cfg(struct rtl_priv *rtlpriv, u8 *reject_agg,
 			   u8 *ctrl_agg_size, u8 *agg_size)
 {
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h
index c1c32d685c5d..ed46f418eb91 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h
@@ -44,6 +44,7 @@ bool rtl_btc_is_disable_edca_turbo(struct rtl_priv *rtlpriv);
 bool rtl_btc_is_bt_disabled(struct rtl_priv *rtlpriv);
 void rtl_btc_special_packet_notify(struct rtl_priv *rtlpriv, u8 pkt_type);
 void rtl_btc_record_pwr_mode(struct rtl_priv *rtlpriv, u8 *buf, u8 len);
+bool rtl_btc_is_bt_lps_on(struct rtl_priv *rtlpriv);
 void rtl_btc_get_ampdu_cfg(struct rtl_priv *rtlpriv, u8 *reject_agg,
 			   u8 *ctrl_agg_size, u8 *agg_size);
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 0591adedce76..23d869bcb90d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2563,6 +2563,7 @@ struct rtl_btc_ops {
 	void (*btc_record_pwr_mode)(struct rtl_priv *rtlpriv, u8 *buf, u8 len);
 	void (*btc_get_ampdu_cfg)(struct rtl_priv *rtlpriv, u8 *reject_agg,
 				  u8 *ctrl_agg_size, u8 *agg_size);
+	bool (*btc_is_bt_lps_on)(struct rtl_priv *rtlpriv);
 };
 
 struct proxim {
-- 
2.12.3
