Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:36793 "EHLO
	mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932593AbbLNWe6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 17:34:58 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Stable <stable@vger.kernel.org>
Subject: [PATCH 3/8] rtlwifi: rtl8821ae: Fix errors in parameter initialization
Date: Mon, 14 Dec 2015 16:34:33 -0600
Message-Id: <1450132478-2386-4-git-send-email-Larry.Finger@lwfinger.net> (sfid-20151214_233513_731128_4D1332D7)
In-Reply-To: <1450132478-2386-2-git-send-email-Larry.Finger@lwfinger.net>
References: <1450132478-2386-2-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This driver failed to copy parameters sw_crypto and disable_watchdog into
the locations actually used by the driver. In addition, msi_support was
initialized three times and one of them used the wrong variable. The
initialization of parameter int_clear was moved so that it is near that
of the rest of the parameters.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
index 142bdff..4159f9b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
@@ -95,8 +95,6 @@ int rtl8821ae_init_sw_vars(struct ieee80211_hw *hw)
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 
 	rtl8821ae_bt_reg_init(hw);
-	rtlpci->msi_support = rtlpriv->cfg->mod_params->msi_support;
-	rtlpci->int_clear = rtlpriv->cfg->mod_params->int_clear;
 	rtlpriv->btcoexist.btc_ops = rtl_btc_get_ops_pointer();
 
 	rtlpriv->dm.dm_initialgain_enable = 1;
@@ -168,12 +166,15 @@ int rtl8821ae_init_sw_vars(struct ieee80211_hw *hw)
 	rtlpriv->psc.swctrl_lps = rtlpriv->cfg->mod_params->swctrl_lps;
 	rtlpriv->psc.fwctrl_lps = rtlpriv->cfg->mod_params->fwctrl_lps;
 	rtlpci->msi_support = rtlpriv->cfg->mod_params->msi_support;
-	rtlpci->msi_support = rtlpriv->cfg->mod_params->int_clear;
+	rtlpci->int_clear = rtlpriv->cfg->mod_params->int_clear;
+	rtlpriv->cfg->mod_params->sw_crypto =
+		rtlpriv->cfg->mod_params->sw_crypto;
+	rtlpriv->cfg->mod_params->disable_watchdog =
+		rtlpriv->cfg->mod_params->disable_watchdog;
 	if (rtlpriv->cfg->mod_params->disable_watchdog)
 		pr_info("watchdog disabled\n");
 	rtlpriv->psc.reg_fwctrl_lps = 3;
 	rtlpriv->psc.reg_max_lps_awakeintvl = 5;
-	rtlpci->msi_support = rtlpriv->cfg->mod_params->msi_support;
 
 	/* for ASPM, you can close aspm through
 	 * set const_support_pciaspm = 0
-- 
2.1.4

