Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:34740 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbbBTOuY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2015 09:50:24 -0500
Received: by pabrd3 with SMTP id rd3so8582094pab.1
        for <linux-wireless@vger.kernel.org>; Fri, 20 Feb 2015 06:50:24 -0800 (PST)
From: Taehee Yoo <ap420073@gmail.com>
To: Larry.Finger@lwfinger.net
Cc: linux-wireless@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH] rtlwifi: rtl8192cu: Fix some beacon issue
Date: Fri, 20 Feb 2015 23:50:13 +0900
Message-Id: <1424443813-13634-1-git-send-email-ap420073@gmail.com> (sfid-20150220_155027_966402_ECDD2381)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes rtl8192cu is not sending beacon frame.
This patch fix this issue.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c  | 40 +++++++++++++---------------
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c |  1 +
 2 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
index fe4b699..5ad5429 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -1323,39 +1323,40 @@ static int _rtl92cu_set_media_status(struct ieee80211_hw *hw,
 	enum led_ctl_mode ledaction = LED_CTL_NO_LINK;
 
 	bt_msr &= 0xfc;
-	rtl_write_byte(rtlpriv, REG_BCN_MAX_ERR, 0xFF);
-	if (type == NL80211_IFTYPE_UNSPECIFIED || type ==
-	    NL80211_IFTYPE_STATION) {
-		_rtl92cu_stop_tx_beacon(hw);
-		_rtl92cu_enable_bcn_sub_func(hw);
-	} else if (type == NL80211_IFTYPE_ADHOC || type == NL80211_IFTYPE_AP) {
-		_rtl92cu_resume_tx_beacon(hw);
-		_rtl92cu_disable_bcn_sub_func(hw);
-	} else {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
-			 "Set HW_VAR_MEDIA_STATUS:No such media status(%x)\n",
-			 type);
-	}
+	bt_msr |= type;
+	rtl_write_byte(rtlpriv, REG_BCN_CTRL,
+		       rtl_read_byte(rtlpriv, REG_BCN_CTRL)|BIT(4));
+	rtl_write_byte(rtlpriv, MSR, bt_msr);
+	rtl_write_byte(rtlpriv, REG_DUAL_TSF_RST, BIT(0));
+
 	switch (type) {
 	case NL80211_IFTYPE_UNSPECIFIED:
-		bt_msr |= MSR_NOLINK;
 		ledaction = LED_CTL_LINK;
+		_rtl92cu_stop_tx_beacon(hw);
+		rtl_write_byte(rtlpriv, REG_BCN_CTRL, 0x19);
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 			 "Set Network type to NO LINK!\n");
 		break;
 	case NL80211_IFTYPE_ADHOC:
-		bt_msr |= MSR_ADHOC;
+		_rtl92cu_resume_tx_beacon(hw);
+		rtl_write_byte(rtlpriv, REG_BCN_CTRL, 0x1a);
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 			 "Set Network type to Ad Hoc!\n");
 		break;
 	case NL80211_IFTYPE_STATION:
-		bt_msr |= MSR_INFRA;
 		ledaction = LED_CTL_LINK;
+		_rtl92cu_stop_tx_beacon(hw);
+		rtl_write_byte(rtlpriv, REG_BCN_CTRL, 0x19);
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 			 "Set Network type to STA!\n");
 		break;
 	case NL80211_IFTYPE_AP:
-		bt_msr |= MSR_AP;
+		_rtl92cu_resume_tx_beacon(hw);
+		rtl_write_dword(rtlpriv, REG_BCN_CTRL, 0x12);
+		rtl_write_word(rtlpriv, REG_BCNTCFG, 0x00);
+		rtl_write_byte(rtlpriv, REG_BCN_CTRL,
+			       (DIS_TSF_UDT0_NORMAL_CHIP|EN_BCN_FUNCTION
+				| EN_TXBCN_RPT|EN_MBSSID));
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 			 "Set Network type to AP!\n");
 		break;
@@ -1364,12 +1365,7 @@ static int _rtl92cu_set_media_status(struct ieee80211_hw *hw,
 			 "Network type %d not supported!\n", type);
 		goto error_out;
 	}
-	rtl_write_byte(rtlpriv, (MSR), bt_msr);
 	rtlpriv->cfg->ops->led_control(hw, ledaction);
-	if ((bt_msr & MSR_MASK) == MSR_AP)
-		rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x00);
-	else
-		rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x66);
 	return 0;
 error_out:
 	return 1;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
index 133e395..7a00e92 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
@@ -647,6 +647,7 @@ void rtl92c_init_beacon_parameters(struct ieee80211_hw *hw,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 
+	rtl_write_word(rtlpriv, REG_BCN_CTRL, 0x1010);
 	rtl_write_word(rtlpriv, REG_TBTT_PROHIBIT, 0x6404);/* ms */
 	rtl_write_byte(rtlpriv, REG_DRVERLYINT, DRIVER_EARLY_INT_TIME);/*ms*/
 	rtl_write_byte(rtlpriv, REG_BCNDMATIM, BCN_DMA_ATIME_INT_TIME);
-- 
2.1.0

