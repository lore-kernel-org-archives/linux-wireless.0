Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:36641 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752643AbdFTAc2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Jun 2017 20:32:28 -0400
Received: by mail-ot0-f196.google.com with SMTP id r67so13317892ota.3
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jun 2017 17:32:28 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 03/10] rtlwifi: Modify power mode parameters of 8723be and 8821ae.
Date: Mon, 19 Jun 2017 19:32:11 -0500
Message-Id: <20170620003218.17010-4-Larry.Finger@lwfinger.net> (sfid-20170620_023245_324665_C203C753)
In-Reply-To: <20170620003218.17010-1-Larry.Finger@lwfinger.net>
References: <20170620003218.17010-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Change the parameters suggested by FW.
awake int: 2
smart_ps: 2 or 0
ps_mode: 2 (MAX -- every DTIM)

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
index 8c0ac96b5430..f9d10f1e7cf8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
@@ -155,8 +155,8 @@ int rtl8723be_init_sw_vars(struct ieee80211_hw *hw)
 		 rtlpriv->cfg->mod_params->disable_watchdog;
 	if (rtlpriv->cfg->mod_params->disable_watchdog)
 		pr_info("watchdog disabled\n");
-	rtlpriv->psc.reg_fwctrl_lps = 3;
-	rtlpriv->psc.reg_max_lps_awakeintvl = 5;
+	rtlpriv->psc.reg_fwctrl_lps = 2;
+	rtlpriv->psc.reg_max_lps_awakeintvl = 2;
 	/* for ASPM, you can close aspm through
 	 * set const_support_pciaspm = 0
 	 */
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
index abaf34cb1433..d71d2776ca03 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
@@ -172,8 +172,8 @@ int rtl8821ae_init_sw_vars(struct ieee80211_hw *hw)
 		rtlpriv->cfg->mod_params->disable_watchdog;
 	if (rtlpriv->cfg->mod_params->disable_watchdog)
 		pr_info("watchdog disabled\n");
-	rtlpriv->psc.reg_fwctrl_lps = 3;
-	rtlpriv->psc.reg_max_lps_awakeintvl = 5;
+	rtlpriv->psc.reg_fwctrl_lps = 2;
+	rtlpriv->psc.reg_max_lps_awakeintvl = 2;
 
 	/* for ASPM, you can close aspm through
 	 * set const_support_pciaspm = 0
-- 
2.12.3
