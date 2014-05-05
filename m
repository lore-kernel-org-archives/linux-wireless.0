Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:48365 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027AbaEEIeO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2014 04:34:14 -0400
Received: by mail-pa0-f51.google.com with SMTP id kq14so2044502pab.24
        for <linux-wireless@vger.kernel.org>; Mon, 05 May 2014 01:34:14 -0700 (PDT)
From: Adam Lee <adam.lee@canonical.com>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/3] rtlwifi: rtl8723be: add msi module parameter
Date: Mon,  5 May 2014 16:33:38 +0800
Message-Id: <1399278818-19152-3-git-send-email-adam.lee@canonical.com> (sfid-20140505_103420_289048_9C54465A)
In-Reply-To: <1399278818-19152-1-git-send-email-adam.lee@canonical.com>
References: <1399278818-19152-1-git-send-email-adam.lee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The msi module parameter offers an option to enable or disable MSI
interrupts mode, for debugging and workaround(in case) convenience.

Signed-off-by: Adam Lee <adam.lee@canonical.com>
---
 drivers/net/wireless/rtlwifi/rtl8723be/sw.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/sw.c b/drivers/net/wireless/rtlwifi/rtl8723be/sw.c
index a072136..ff12bf4 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723be/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723be/sw.c
@@ -92,7 +92,7 @@ int rtl8723be_init_sw_vars(struct ieee80211_hw *hw)
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 
 	rtl8723be_bt_reg_init(hw);
-	rtlpci->msi_support = false;
+	rtlpci->msi_support = rtlpriv->cfg->mod_params->msi_support;
 	rtlpriv->btcoexist.btc_ops = rtl_btc_get_ops_pointer();
 
 	rtlpriv->dm.dm_initialgain_enable = 1;
@@ -253,6 +253,7 @@ static struct rtl_mod_params rtl8723be_mod_params = {
 	.inactiveps = true,
 	.swctrl_lps = false,
 	.fwctrl_lps = true,
+	.msi_support = false,
 	.debug = DBG_EMERG,
 };
 
@@ -365,9 +366,11 @@ module_param_named(debug, rtl8723be_mod_params.debug, int, 0444);
 module_param_named(ips, rtl8723be_mod_params.inactiveps, bool, 0444);
 module_param_named(swlps, rtl8723be_mod_params.swctrl_lps, bool, 0444);
 module_param_named(fwlps, rtl8723be_mod_params.fwctrl_lps, bool, 0444);
+module_param_named(msi, rtl8723be_mod_params.msi_support, bool, 0444);
 MODULE_PARM_DESC(swenc, "using hardware crypto (default 0 [hardware])\n");
 MODULE_PARM_DESC(ips, "using no link power save (default 1 is open)\n");
 MODULE_PARM_DESC(fwlps, "using linked fw control power save (default 1 is open)\n");
+MODULE_PARM_DESC(msi, "Set to 1 to use MSI interrupts mode (default 0)\n");
 MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
 
 static SIMPLE_DEV_PM_OPS(rtlwifi_pm_ops, rtl_pci_suspend, rtl_pci_resume);
-- 
2.0.0.rc0

