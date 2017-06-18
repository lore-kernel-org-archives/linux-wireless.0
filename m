Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36858 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753111AbdFRQM6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Jun 2017 12:12:58 -0400
Received: by mail-oi0-f65.google.com with SMTP id g14so7240129oib.3
        for <linux-wireless@vger.kernel.org>; Sun, 18 Jun 2017 09:12:58 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        vincent_fann <vincent_fann@realtek.com>,
        shaofu <shaofu@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>
Subject: [PATCH 04/11] rtlwifi: Correct power save capability while init mac80211
Date: Sun, 18 Jun 2017 11:12:42 -0500
Message-Id: <20170618161249.6146-5-Larry.Finger@lwfinger.net> (sfid-20170618_181319_722359_FA2E8077)
In-Reply-To: <20170618161249.6146-1-Larry.Finger@lwfinger.net>
References: <20170618161249.6146-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Since the driver itself will enter power saving mode dynamically
according to the traffic, we set hw capability SUPPORTS_PS and
SUPPORTS_DYNAMIC_PS in case of fwctrl_lps.

The process IEEE80211_CONF_CHANGE_PS in op_config is used by
SW-LPS only, so we add constraints to avoid errors.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: vincent_fann <vincent_fann@realtek.com>
Signed-off-by: shaofu <shaofu@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 4 ++++
 drivers/net/wireless/realtek/rtlwifi/core.c | 3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index bdc379178e87..6415ec03008f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -405,6 +405,10 @@ static void _rtl_init_mac80211(struct ieee80211_hw *hw)
 		ieee80211_hw_set(hw, SUPPORTS_PS);
 		ieee80211_hw_set(hw, PS_NULLFUNC_STACK);
 	}
+	if (rtlpriv->psc.fwctrl_lps) {
+		ieee80211_hw_set(hw, SUPPORTS_PS);
+		ieee80211_hw_set(hw, SUPPORTS_DYNAMIC_PS);
+	}
 	hw->wiphy->interface_modes =
 	    BIT(NL80211_IFTYPE_AP) |
 	    BIT(NL80211_IFTYPE_STATION) |
diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index a4f8e326a2bc..5053d8c73e29 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -629,7 +629,8 @@ static int rtl_op_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
 	/*For LPS */
-	if (changed & IEEE80211_CONF_CHANGE_PS) {
+	if ((changed & IEEE80211_CONF_CHANGE_PS) &&
+	    rtlpriv->psc.swctrl_lps && !rtlpriv->psc.fwctrl_lps) {
 		cancel_delayed_work(&rtlpriv->works.ps_work);
 		cancel_delayed_work(&rtlpriv->works.ps_rfon_wq);
 		if (conf->flags & IEEE80211_CONF_PS) {
-- 
2.12.3
