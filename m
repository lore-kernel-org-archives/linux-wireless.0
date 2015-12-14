Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:33859 "EHLO
	mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbbLNWfD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 17:35:03 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Stable <stable@vger.kernel.org>
Subject: [PATCH 6/8] rtlwifi: rtl8192se: Fix module parameter initialization
Date: Mon, 14 Dec 2015 16:34:36 -0600
Message-Id: <1450132478-2386-7-git-send-email-Larry.Finger@lwfinger.net> (sfid-20151214_233519_691216_7A46FB1A)
In-Reply-To: <1450132478-2386-2-git-send-email-Larry.Finger@lwfinger.net>
References: <1450132478-2386-2-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Two of the module parameter descriptions show incorrect default values.
In addition the value for software encryption is not transferred to
the locations used by the driver.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c
index e1fd27c..31baca41 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c
@@ -187,6 +187,8 @@ static int rtl92s_init_sw_vars(struct ieee80211_hw *hw)
 	rtlpriv->psc.inactiveps = rtlpriv->cfg->mod_params->inactiveps;
 	rtlpriv->psc.swctrl_lps = rtlpriv->cfg->mod_params->swctrl_lps;
 	rtlpriv->psc.fwctrl_lps = rtlpriv->cfg->mod_params->fwctrl_lps;
+	rtlpriv->cfg->mod_params->sw_crypto =
+		rtlpriv->cfg->mod_params->sw_crypto;
 	if (!rtlpriv->psc.inactiveps)
 		pr_info("Power Save off (module option)\n");
 	if (!rtlpriv->psc.fwctrl_lps)
@@ -425,8 +427,8 @@ module_param_named(swlps, rtl92se_mod_params.swctrl_lps, bool, 0444);
 module_param_named(fwlps, rtl92se_mod_params.fwctrl_lps, bool, 0444);
 MODULE_PARM_DESC(swenc, "Set to 1 for software crypto (default 0)\n");
 MODULE_PARM_DESC(ips, "Set to 0 to not use link power save (default 1)\n");
-MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
-MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
+MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 1)\n");
+MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 0)\n");
 MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
 
 static SIMPLE_DEV_PM_OPS(rtlwifi_pm_ops, rtl_pci_suspend, rtl_pci_resume);
-- 
2.1.4

