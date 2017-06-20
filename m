Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35917 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752475AbdFTAcf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Jun 2017 20:32:35 -0400
Received: by mail-oi0-f65.google.com with SMTP id g14so10724185oib.3
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jun 2017 17:32:35 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 10/10] rtlwifi: Fill in_4way field by vendor command
Date: Mon, 19 Jun 2017 19:32:18 -0500
Message-Id: <20170620003218.17010-11-Larry.Finger@lwfinger.net> (sfid-20170620_023240_690290_79892656)
In-Reply-To: <20170620003218.17010-1-Larry.Finger@lwfinger.net>
References: <20170620003218.17010-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

The in_4way can be filled by wpa_cli's VENDOR command.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index 574f9943d70e..1b81bfa083ed 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -319,6 +319,7 @@ static void _rtl_init_hw_vht_capab(struct ieee80211_hw *hw,
 
 enum {
 	RTL_VENDOR_SCMD_COEX_AP_NUM	= 2000,
+	RTL_VENDOR_SCMD_COEX_4WAY	= 2001,
 };
 
 static u32 rtl_data_to_int(struct rtl_priv *rtlpriv, const void *data, int len)
@@ -364,6 +365,24 @@ static int rtl_cfgvendor_coex_ap_num(struct wiphy *wiphy,
 	return 0;
 }
 
+static int rtl_cfgvendor_coex_4way(struct wiphy *wiphy,
+				   struct wireless_dev *wdev,
+				   const void *data, int len)
+{
+	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	bool tmp;
+
+	tmp = (rtl_data_to_int(rtlpriv, data, len) ? true : false);
+
+	rtlpriv->btcoexist.btc_info.in_4way = tmp;
+
+	RT_TRACE(rtlpriv, COMP_VENDOR_CMD, DBG_DMESG,
+		 "cfgvendor 4way is %d\n", rtlpriv->btcoexist.btc_info.in_4way);
+
+	return 0;
+}
+
 static const struct wiphy_vendor_command rtl_vendor_cmds[] = {
 	{
 		{
@@ -374,6 +393,15 @@ static const struct wiphy_vendor_command rtl_vendor_cmds[] = {
 			 WIPHY_VENDOR_CMD_NEED_NETDEV,
 		.doit = rtl_cfgvendor_coex_ap_num,
 	},
+	{
+		{
+			.vendor_id = OUI_REALTEK,
+			.subcmd = RTL_VENDOR_SCMD_COEX_4WAY
+		},
+		.flags = WIPHY_VENDOR_CMD_NEED_WDEV |
+			 WIPHY_VENDOR_CMD_NEED_NETDEV,
+		.doit = rtl_cfgvendor_coex_4way,
+	},
 };
 
 static void _rtl_init_mac80211(struct ieee80211_hw *hw)
-- 
2.12.3
