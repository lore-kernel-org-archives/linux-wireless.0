Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:35643 "EHLO
	mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932845AbbLNWe7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 17:34:59 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Stable <stable@vger.kernel.org>
Subject: [PATCH 4/8] rtlwifi: rtl8188ee: Fix module parameter initialization
Date: Mon, 14 Dec 2015 16:34:34 -0600
Message-Id: <1450132478-2386-5-git-send-email-Larry.Finger@lwfinger.net> (sfid-20151214_233517_666634_23CA9218)
In-Reply-To: <1450132478-2386-2-git-send-email-Larry.Finger@lwfinger.net>
References: <1450132478-2386-2-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In this driver, parameters disable_watchdog and sw_crypto are never
copied into the locations used in the main code. While modifying the
parameter handling, the copying of parameter msi_support is moved to
be with the rest.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c
index 1134412..47e32cb 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c
@@ -88,8 +88,6 @@ int rtl88e_init_sw_vars(struct ieee80211_hw *hw)
 	u8 tid;
 
 	rtl8188ee_bt_reg_init(hw);
-	rtlpci->msi_support = rtlpriv->cfg->mod_params->msi_support;
-
 	rtlpriv->dm.dm_initialgain_enable = 1;
 	rtlpriv->dm.dm_flag = 0;
 	rtlpriv->dm.disable_framebursting = 0;
@@ -138,6 +136,11 @@ int rtl88e_init_sw_vars(struct ieee80211_hw *hw)
 	rtlpriv->psc.inactiveps = rtlpriv->cfg->mod_params->inactiveps;
 	rtlpriv->psc.swctrl_lps = rtlpriv->cfg->mod_params->swctrl_lps;
 	rtlpriv->psc.fwctrl_lps = rtlpriv->cfg->mod_params->fwctrl_lps;
+	rtlpci->msi_support = rtlpriv->cfg->mod_params->msi_support;
+	rtlpriv->cfg->mod_params->sw_crypto =
+		rtlpriv->cfg->mod_params->sw_crypto;
+	rtlpriv->cfg->mod_params->disable_watchdog =
+		rtlpriv->cfg->mod_params->disable_watchdog;
 	if (rtlpriv->cfg->mod_params->disable_watchdog)
 		pr_info("watchdog disabled\n");
 	if (!rtlpriv->psc.inactiveps)
-- 
2.1.4

