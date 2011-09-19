Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f42.google.com ([74.125.83.42]:61760 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087Ab1ISTed (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 15:34:33 -0400
Received: by gwb17 with SMTP id 17so7043628gwb.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 Sep 2011 12:34:33 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] rtlwifi: rtl8192se: Change modinfo messages
Date: Mon, 19 Sep 2011 14:34:08 -0500
Message-Id: <1316460850-16443-3-git-send-email-Larry.Finger@lwfinger.net> (sfid-20110919_213437_383514_0B20A784)
In-Reply-To: <1316460850-16443-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1316460850-16443-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The various modparam messages are difficult to understand.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192se/sw.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/sw.c b/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
index 0055a1c..24bd331 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
@@ -164,6 +164,10 @@ static int rtl92s_init_sw_vars(struct ieee80211_hw *hw)
 	rtlpriv->psc.inactiveps = rtlpriv->cfg->mod_params->inactiveps;
 	rtlpriv->psc.swctrl_lps = rtlpriv->cfg->mod_params->swctrl_lps;
 	rtlpriv->psc.fwctrl_lps = rtlpriv->cfg->mod_params->fwctrl_lps;
+	if (!rtlpriv->psc.inactiveps)
+		pr_info("rtl8192ce: Power Save off (module option)\n");
+	if (!rtlpriv->psc.fwctrl_lps)
+		pr_info("rtl8192ce: FW Power Save off (module option)\n");
 	rtlpriv->psc.reg_fwctrl_lps = 3;
 	rtlpriv->psc.reg_max_lps_awakeintvl = 5;
 	/* for ASPM, you can close aspm through
@@ -378,6 +382,7 @@ MODULE_DEVICE_TABLE(pci, rtl92se_pci_ids);
 
 MODULE_AUTHOR("lizhaoming	<chaoming_li@realsil.com.cn>");
 MODULE_AUTHOR("Realtek WlanFAE	<wlanfae@realtek.com>");
+MODULE_AUTHOR("Larry Finger	<Larry.Finger@lwfinger.net>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Realtek 8192S/8191S 802.11n PCI wireless");
 MODULE_FIRMWARE("rtlwifi/rtl8192sefw.bin");
@@ -386,11 +391,10 @@ module_param_named(swenc, rtl92se_mod_params.sw_crypto, bool, 0444);
 module_param_named(ips, rtl92se_mod_params.inactiveps, bool, 0444);
 module_param_named(swlps, rtl92se_mod_params.swctrl_lps, bool, 0444);
 module_param_named(fwlps, rtl92se_mod_params.fwctrl_lps, bool, 0444);
-MODULE_PARM_DESC(swenc, "using hardware crypto (default 0 [hardware])\n");
-MODULE_PARM_DESC(ips, "using no link power save (default 1 is open)\n");
-MODULE_PARM_DESC(swlps, "using linked sw control power save (default 1 is "
-		 "open)\n");
-
+MODULE_PARM_DESC(swenc, "Set to 1 for software crypto (default 0)\n");
+MODULE_PARM_DESC(ips, "Set to 0 to not use link power save (default 1)\n");
+MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
+MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
 
 static struct pci_driver rtl92se_driver = {
 	.name = KBUILD_MODNAME,
-- 
1.7.6.1

