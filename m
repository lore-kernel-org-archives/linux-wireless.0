Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35907 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752475AbdFTAcc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Jun 2017 20:32:32 -0400
Received: by mail-oi0-f68.google.com with SMTP id g14so10724142oib.3
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jun 2017 17:32:32 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 07/10] rtlwifi: Fill ap_num filed by vendor command
Date: Mon, 19 Jun 2017 19:32:15 -0500
Message-Id: <20170620003218.17010-8-Larry.Finger@lwfinger.net> (sfid-20170620_023236_566681_2734142D)
In-Reply-To: <20170620003218.17010-1-Larry.Finger@lwfinger.net>
References: <20170620003218.17010-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

The ap_num can be filled by wpa_cli's VENDOR command.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/base.c  | 64 ++++++++++++++++++++++++++++
 drivers/net/wireless/realtek/rtlwifi/debug.h |  1 +
 2 files changed, 65 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index 180850cb4671..1994125a21b5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -315,6 +315,67 @@ static void _rtl_init_hw_vht_capab(struct ieee80211_hw *hw,
 	}
 }
 
+#define OUI_REALTEK	0x00E04C
+
+enum {
+	RTL_VENDOR_SCMD_COEX_AP_NUM	= 2000,
+};
+
+static u32 rtl_data_to_int(struct rtl_priv *rtlpriv, const void *data, int len)
+{
+	/* wpa_supplicant translates the string '01234567' to binary as
+	 * '01 23 45 67', so we treat it as big-endian.
+	 */
+	u32 tmp = 0;
+
+	switch (len) {
+	case 1:
+		tmp = *((u8 *)data);
+		break;
+	case 2:
+		tmp = be16_to_cpu(*((__be16 *)data));
+		break;
+	case 4:
+		tmp = be32_to_cpu(*((__be32 *)data));
+		break;
+	default:
+		RT_TRACE(rtlpriv, COMP_VENDOR_CMD, DBG_WARNING,
+			 "length of vendor command is %d\n", len);
+		break;
+	}
+
+	return tmp;
+}
+
+static int rtl_cfgvendor_coex_ap_num(struct wiphy *wiphy,
+				     struct wireless_dev *wdev,
+				     const void *data, int len)
+{
+	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	rtlpriv->btcoexist.btc_info.ap_num =
+					rtl_data_to_int(rtlpriv, data, len);
+
+	RT_TRACE(rtlpriv, COMP_VENDOR_CMD, DBG_DMESG,
+		 "cfgvendor ap_num is %d\n",
+		 rtlpriv->btcoexist.btc_info.ap_num);
+
+	return 0;
+}
+
+static const struct wiphy_vendor_command rtl_vendor_cmds[] = {
+	{
+		{
+			.vendor_id = OUI_REALTEK,
+			.subcmd = RTL_VENDOR_SCMD_COEX_AP_NUM
+		},
+		.flags = WIPHY_VENDOR_CMD_NEED_WDEV |
+			 WIPHY_VENDOR_CMD_NEED_NETDEV,
+		.doit = rtl_cfgvendor_coex_ap_num,
+	},
+};
+
 static void _rtl_init_mac80211(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -323,6 +384,9 @@ static void _rtl_init_mac80211(struct ieee80211_hw *hw)
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
 	struct ieee80211_supported_band *sband;
 
+	hw->wiphy->vendor_commands = rtl_vendor_cmds;
+	hw->wiphy->n_vendor_commands = ARRAY_SIZE(rtl_vendor_cmds);
+
 	if (rtlhal->macphymode == SINGLEMAC_SINGLEPHY &&
 	    rtlhal->bandset == BAND_ON_BOTH) {
 		/* 1: 2.4 G bands */
diff --git a/drivers/net/wireless/realtek/rtlwifi/debug.h b/drivers/net/wireless/realtek/rtlwifi/debug.h
index 947718001457..b39e87cc568a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/debug.h
+++ b/drivers/net/wireless/realtek/rtlwifi/debug.h
@@ -106,6 +106,7 @@
 #define COMP_BT_COEXIST			BIT(30)
 #define COMP_IQK			BIT(31)
 #define COMP_TX_REPORT			BIT_ULL(32)
+#define COMP_VENDOR_CMD			BIT_ULL(33)
 
 /*--------------------------------------------------------------
 		Define the rt_print components
-- 
2.12.3
