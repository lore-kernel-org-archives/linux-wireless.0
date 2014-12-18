Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:46792 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbaLRJGB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 04:06:01 -0500
Received: by mail-ob0-f182.google.com with SMTP id wo20so2282197obc.13
        for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2014 01:06:00 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 04/16] rtlwifi: rtl8192ce: Update setting of the media status
Date: Thu, 18 Dec 2014 03:05:28 -0600
Message-Id: <1418893540-19944-5-git-send-email-Larry.Finger@lwfinger.net> (sfid-20141218_100613_827029_693AE2AF)
In-Reply-To: <1418893540-19944-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1418893540-19944-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch applies changes found in the latest vendor driver.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c | 51 ++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
index b63b78b..2ee778a 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -1161,36 +1161,24 @@ static int _rtl92ce_set_media_status(struct ieee80211_hw *hw,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u8 bt_msr = rtl_read_byte(rtlpriv, MSR);
 	enum led_ctl_mode ledaction = LED_CTL_NO_LINK;
-	bt_msr &= 0xfc;
+	u8 mode = MSR_NOLINK;
 
-	if (type == NL80211_IFTYPE_UNSPECIFIED ||
-	    type == NL80211_IFTYPE_STATION) {
-		_rtl92ce_stop_tx_beacon(hw);
-		_rtl92ce_enable_bcn_sub_func(hw);
-	} else if (type == NL80211_IFTYPE_ADHOC || type == NL80211_IFTYPE_AP ||
-		   type == NL80211_IFTYPE_MESH_POINT) {
-		_rtl92ce_resume_tx_beacon(hw);
-		_rtl92ce_disable_bcn_sub_func(hw);
-	} else {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
-			 "Set HW_VAR_MEDIA_STATUS: No such media status(%x)\n",
-			 type);
-	}
+	bt_msr &= 0xfc;
 
 	switch (type) {
 	case NL80211_IFTYPE_UNSPECIFIED:
-		bt_msr |= MSR_NOLINK;
+		mode = MSR_NOLINK;
 		ledaction = LED_CTL_LINK;
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 			 "Set Network type to NO LINK!\n");
 		break;
 	case NL80211_IFTYPE_ADHOC:
-		bt_msr |= MSR_ADHOC;
+		mode = MSR_ADHOC;
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 			 "Set Network type to Ad Hoc!\n");
 		break;
 	case NL80211_IFTYPE_STATION:
-		bt_msr |= MSR_INFRA;
+		mode = MSR_INFRA;
 		ledaction = LED_CTL_LINK;
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 			 "Set Network type to STA!\n");
@@ -1201,7 +1189,7 @@ static int _rtl92ce_set_media_status(struct ieee80211_hw *hw,
 			 "Set Network type to AP!\n");
 		break;
 	case NL80211_IFTYPE_MESH_POINT:
-		bt_msr |= MSR_ADHOC;
+		mode = MSR_ADHOC;
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 			 "Set Network type to Mesh Point!\n");
 		break;
@@ -1212,9 +1200,32 @@ static int _rtl92ce_set_media_status(struct ieee80211_hw *hw,
 
 	}
 
-	rtl_write_byte(rtlpriv, (MSR), bt_msr);
+	/* MSR_INFRA == Link in infrastructure network;
+	 * MSR_ADHOC == Link in ad hoc network;
+	 * Therefore, check link state is necessary.
+	 *
+	 * MSR_AP == AP mode; link state does not matter here.
+	 */
+	if (mode != MSR_AP &&
+	    rtlpriv->mac80211.link_state < MAC80211_LINKED) {
+		mode = MSR_NOLINK;
+		ledaction = LED_CTL_NO_LINK;
+	}
+	if (mode == MSR_NOLINK || mode == MSR_INFRA) {
+		_rtl92ce_stop_tx_beacon(hw);
+		_rtl92ce_enable_bcn_sub_func(hw);
+	} else if (mode == MSR_ADHOC || mode == MSR_AP) {
+		_rtl92ce_resume_tx_beacon(hw);
+		_rtl92ce_disable_bcn_sub_func(hw);
+	} else {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
+			 "Set HW_VAR_MEDIA_STATUS: No such media status(%x).\n",
+			 mode);
+	}
+	rtl_write_byte(rtlpriv, (MSR), bt_msr | mode);
+
 	rtlpriv->cfg->ops->led_control(hw, ledaction);
-	if ((bt_msr & MSR_MASK) == MSR_AP)
+	if (mode == MSR_AP)
 		rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x00);
 	else
 		rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x66);
-- 
2.1.2

