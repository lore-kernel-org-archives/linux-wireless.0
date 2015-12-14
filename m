Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:35555 "EHLO
	mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbbLNWez (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 17:34:55 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Stable <stable@vger.kernel.org>
Subject: [PATCH 1/8] rtlwifi: rtl8723be: Fix module parameter initialization
Date: Mon, 14 Dec 2015 16:34:31 -0600
Message-Id: <1450132478-2386-2-git-send-email-Larry.Finger@lwfinger.net> (sfid-20151214_233503_119759_B7B4A1DB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This driver has a number of errors in the module initialization. These
include the following:

Parameter msi_support is stored in two places - one is removed.
Paramters sw_crypto and disable_watchdog were never stored in the final
locations, nor were they initialized properly.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
index d091f1d..a78eaed 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
@@ -93,7 +93,6 @@ int rtl8723be_init_sw_vars(struct ieee80211_hw *hw)
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 
 	rtl8723be_bt_reg_init(hw);
-	rtlpci->msi_support = rtlpriv->cfg->mod_params->msi_support;
 	rtlpriv->btcoexist.btc_ops = rtl_btc_get_ops_pointer();
 
 	rtlpriv->dm.dm_initialgain_enable = 1;
@@ -151,6 +150,10 @@ int rtl8723be_init_sw_vars(struct ieee80211_hw *hw)
 	rtlpriv->psc.swctrl_lps = rtlpriv->cfg->mod_params->swctrl_lps;
 	rtlpriv->psc.fwctrl_lps = rtlpriv->cfg->mod_params->fwctrl_lps;
 	rtlpci->msi_support = rtlpriv->cfg->mod_params->msi_support;
+	rtlpriv->cfg->mod_params->sw_crypto =
+		 rtlpriv->cfg->mod_params->sw_crypto;
+	rtlpriv->cfg->mod_params->disable_watchdog =
+		 rtlpriv->cfg->mod_params->disable_watchdog;
 	if (rtlpriv->cfg->mod_params->disable_watchdog)
 		pr_info("watchdog disabled\n");
 	rtlpriv->psc.reg_fwctrl_lps = 3;
@@ -267,6 +270,9 @@ static struct rtl_mod_params rtl8723be_mod_params = {
 	.inactiveps = true,
 	.swctrl_lps = false,
 	.fwctrl_lps = true,
+	.msi_support = false,
+	.disable_watchdog = false,
+	.debug = DBG_EMERG,
 };
 
 static struct rtl_hal_cfg rtl8723be_hal_cfg = {
-- 
2.1.4

