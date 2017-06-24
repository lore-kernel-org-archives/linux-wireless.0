Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:33878 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754162AbdFXBxS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Jun 2017 21:53:18 -0400
Received: by mail-ot0-f196.google.com with SMTP id p48so6525464otc.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jun 2017 18:53:18 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 04/10] rtlwifi: add amplifier type for 8812ae
Date: Fri, 23 Jun 2017 20:53:03 -0500
Message-Id: <20170624015309.28099-5-Larry.Finger@lwfinger.net> (sfid-20170624_035334_794033_BB7AA1B9)
In-Reply-To: <20170624015309.28099-1-Larry.Finger@lwfinger.net>
References: <20170624015309.28099-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

With correct amplifier_type, the phy praser can choose correct parameters.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.c    | 41 +++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
index 2bc6bace069c..8f4abb3d7669 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
@@ -2966,6 +2966,44 @@ static void _rtl8812ae_read_pa_type(struct ieee80211_hw *hw, u8 *hwinfo,
 	}
 }
 
+static void _rtl8812ae_read_amplifier_type(struct ieee80211_hw *hw, u8 *hwinfo,
+					   bool autoload_fail)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
+
+	u8 ext_type_pa_2g_a  = (hwinfo[0xBD] & BIT(2))      >> 2; /* 0xBD[2] */
+	u8 ext_type_pa_2g_b  = (hwinfo[0xBD] & BIT(6))      >> 6; /* 0xBD[6] */
+	u8 ext_type_pa_5g_a  = (hwinfo[0xBF] & BIT(2))      >> 2; /* 0xBF[2] */
+	u8 ext_type_pa_5g_b  = (hwinfo[0xBF] & BIT(6))      >> 6; /* 0xBF[6] */
+	/* 0xBD[1:0] */
+	u8 ext_type_lna_2g_a = (hwinfo[0xBD] & (BIT(1) | BIT(0))) >> 0;
+	/* 0xBD[5:4] */
+	u8 ext_type_lna_2g_b = (hwinfo[0xBD] & (BIT(5) | BIT(4))) >> 4;
+	/* 0xBF[1:0] */
+	u8 ext_type_lna_5g_a = (hwinfo[0xBF] & (BIT(1) | BIT(0))) >> 0;
+	/* 0xBF[5:4] */
+	u8 ext_type_lna_5g_b = (hwinfo[0xBF] & (BIT(5) | BIT(4))) >> 4;
+
+	_rtl8812ae_read_pa_type(hw, hwinfo, autoload_fail);
+
+	/* [2.4G] Path A and B are both extPA */
+	if ((rtlhal->pa_type_2g & (BIT(5) | BIT(4))) == (BIT(5) | BIT(4)))
+		rtlhal->type_gpa  = ext_type_pa_2g_b  << 2 | ext_type_pa_2g_a;
+
+	/* [5G] Path A and B are both extPA */
+	if ((rtlhal->pa_type_5g & (BIT(1) | BIT(0))) == (BIT(1) | BIT(0)))
+		rtlhal->type_apa  = ext_type_pa_5g_b  << 2 | ext_type_pa_5g_a;
+
+	/* [2.4G] Path A and B are both extLNA */
+	if ((rtlhal->lna_type_2g & (BIT(7) | BIT(3))) == (BIT(7) | BIT(3)))
+		rtlhal->type_glna = ext_type_lna_2g_b << 2 | ext_type_lna_2g_a;
+
+	/* [5G] Path A and B are both extLNA */
+	if ((rtlhal->lna_type_5g & (BIT(7) | BIT(3))) == (BIT(7) | BIT(3)))
+		rtlhal->type_alna = ext_type_lna_5g_b << 2 | ext_type_lna_5g_a;
+}
+
 static void _rtl8821ae_read_pa_type(struct ieee80211_hw *hw, u8 *hwinfo,
 				    bool autoload_fail)
 {
@@ -3114,7 +3152,8 @@ static void _rtl8821ae_read_adapter_info(struct ieee80211_hw *hw, bool b_pseudo_
 					       hwinfo);
 
 	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8812AE) {
-		_rtl8812ae_read_pa_type(hw, hwinfo, rtlefuse->autoload_failflag);
+		_rtl8812ae_read_amplifier_type(hw, hwinfo,
+					       rtlefuse->autoload_failflag);
 		_rtl8812ae_read_bt_coexist_info_from_hwpg(hw,
 				rtlefuse->autoload_failflag, hwinfo);
 	} else {
-- 
2.12.3
