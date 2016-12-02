Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35465 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751105AbcLBBss (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Dec 2016 20:48:48 -0500
Received: by mail-oi0-f65.google.com with SMTP id v84so25421573oie.2
        for <linux-wireless@vger.kernel.org>; Thu, 01 Dec 2016 17:48:48 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Vincent Fann <vincent_fann@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        shaofu <shaofu@realtek.com>, Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 01/14] rtlwifi: Correct power save capability while init mac80211
Date: Thu,  1 Dec 2016 19:48:20 -0600
Message-Id: <20161202014833.6856-2-Larry.Finger@lwfinger.net> (sfid-20161202_024853_008174_3321ACB2)
In-Reply-To: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
References: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set IEEE80211_HW_SUPPORTS_PS when driver is fwlps
Because mac80211 control SW-LPS only, we add constraints to avoid errors.

Signed-off-by: Vincent Fann <vincent_fann@realtek.com>
Signed-off-by: shaofu <shaofu@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 2 ++
 drivers/net/wireless/realtek/rtlwifi/core.c | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index 4ac928b..fa2d26a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -406,6 +406,8 @@ static void _rtl_init_mac80211(struct ieee80211_hw *hw)
 		ieee80211_hw_set(hw, SUPPORTS_PS);
 		ieee80211_hw_set(hw, PS_NULLFUNC_STACK);
 	}
+	if (rtlpriv->psc.fwctrl_lps)
+		ieee80211_hw_set(hw, SUPPORTS_PS);
 	hw->wiphy->interface_modes =
 	    BIT(NL80211_IFTYPE_AP) |
 	    BIT(NL80211_IFTYPE_STATION) |
diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index 2caa4ad..7c2ac24 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -620,7 +620,8 @@ static int rtl_op_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
 	/*For LPS */
-	if (changed & IEEE80211_CONF_CHANGE_PS) {
+	if ((changed & IEEE80211_CONF_CHANGE_PS) &&
+	    rtlpriv->psc.swctrl_lps && !rtlpriv->psc.fwctrl_lps) {
 		cancel_delayed_work(&rtlpriv->works.ps_work);
 		cancel_delayed_work(&rtlpriv->works.ps_rfon_wq);
 		if (conf->flags & IEEE80211_CONF_PS) {
-- 
2.10.2
