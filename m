Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([60.250.210.242]:56810 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab1AYFJJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 00:09:09 -0500
From: =?gb2312?B?wO6zr8P3?= <chaoming_li@realsil.com.cn>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
References: <1291828372-25159-1-git-send-email-Larry.Finger@lwfinger.net>     <1291828372-25159-5-git-send-email-Larry.Finger@lwfinger.net> <301B5E6D9B3042F6ABB4C6479ACB875E@realsil.com.cn>
Subject: [PATCH] fix_rtlwifi_rfkill_state_not_synchronous_with_true_rfstate_issue
Date: Tue, 25 Jan 2011 13:08:57 +0800
Message-ID: <5D449C23195D46B388A79AE17932553E@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="gb2312"
In-Reply-To: <301B5E6D9B3042F6ABB4C6479ACB875E@realsil.com.cn>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry for last patch have no description.

1. when driver init, rfkill_state was setted, but because the flag valid may
not be true, this will cause rfkill_state
not synchronous with the true rf state, and will cause some issues when we
do rfkill.
and now in driver init we will set rfkill_state to rf_on, and at the same
time 
we tell rfkill to set rf_on also.

2. for rtl8192ce you can check GPIO any time, not only after up_first_time
== true. so we delete rtlpci->up_first_time
in rtl92ce_gpio_radio_on_off_checking.

Signed-off-by: chaoming_li  <chaoming_li@realsil.com.cn>

---
 drivers/net/wireless/rtlwifi/base.c         |   13 ++++++++-----
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c |    2 +-
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/base.c
b/drivers/net/wireless/rtlwifi/base.c
index cf0b73e..33323b4 100644
--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
@@ -251,15 +251,18 @@ void rtl_init_rfkill(struct ieee80211_hw *hw)
 	bool blocked;
 	u8 valid = 0;
 
-	radio_state = rtlpriv->cfg->ops->radio_onoff_checking(hw, &valid);
+	/*1. set init state to on */
+	rtlpriv->rfkill.rfkill_state = 1;
+	wiphy_rfkill_set_hw_state(hw->wiphy, 0);
 
-	/*set init state to that of switch */
-	rtlpriv->rfkill.rfkill_state = radio_state;
-	printk(KERN_INFO "rtlwifi: wireless switch is %s\n",
-	       rtlpriv->rfkill.rfkill_state ? "on" : "off");
+	/*2. check gpio for rf state */
+	radio_state = rtlpriv->cfg->ops->radio_onoff_checking(hw, &valid);
 
+	/*3. if valid, change state based on gpio */
 	if (valid) {
 		rtlpriv->rfkill.rfkill_state = radio_state;
+		printk(KERN_INFO "rtlwifi: wireless switch is %s\n",
+				rtlpriv->rfkill.rfkill_state ? "on" :
"off");
 
 		blocked = (rtlpriv->rfkill.rfkill_state == 1) ? 0 : 1;
 		wiphy_rfkill_set_hw_state(hw->wiphy, blocked);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
index 1c41a0c..cb2e01a 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -1943,7 +1943,7 @@ bool rtl92ce_gpio_radio_on_off_checking(struct
ieee80211_hw *hw, u8 * valid)
 	bool b_actuallyset = false;
 	unsigned long flag;
 
-	if ((rtlpci->up_first_time == 1) || (rtlpci->being_init_adapter))
+	if (rtlpci->being_init_adapter)
 		return false;
 
 	if (ppsc->b_swrf_processing)
-- 
1.7.0.4

