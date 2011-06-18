Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:27652 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754619Ab1FRQFb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2011 12:05:31 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 20/25] iwlagn: add power_save module parameter
Date: Sat, 18 Jun 2011 08:34:26 -0700
Message-Id: <1308411271-26093-21-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110618_180539_367632_F9BF9D8F)
In-Reply-To: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add power_save module parameter to enable power management if needed
Default power management is disabled.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   14 +++++++++-----
 drivers/net/wireless/iwlwifi/iwl-core.h |    1 +
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 1ac6c64..b719628 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2545,11 +2545,10 @@ static int iwl_mac_setup_register(struct iwl_priv *priv,
 			    WIPHY_FLAG_DISABLE_BEACON_HINTS |
 			    WIPHY_FLAG_IBSS_RSN;
 
-	/*
-	 * For now, disable PS by default because it affects
-	 * RX performance significantly.
-	 */
-	hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
+	if (iwlagn_mod_params.power_save)
+		hw->wiphy->flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT;
+	else
+		hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
 	hw->wiphy->max_scan_ssids = PROBE_OPTION_MAX;
 	/* we create the 802.11 header and a zero-length SSID element */
@@ -3827,6 +3826,11 @@ module_param_named(led_mode, iwlagn_mod_params.led_mode, int, S_IRUGO);
 MODULE_PARM_DESC(led_mode, "0=system default, "
 		"1=On(RF On)/Off(RF Off), 2=blinking (default: 0)");
 
+module_param_named(power_save, iwlagn_mod_params.power_save,
+		bool, S_IRUGO);
+MODULE_PARM_DESC(power_save,
+		 "enable WiFi power management (default: disable)");
+
 /*
  * For now, keep using power level 1 instead of automatically
  * adjusting ...
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index a09361d..6238ac6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -163,6 +163,7 @@ struct iwl_mod_params {
 	bool bt_coex_active;	/* def: true = enable bt coex */
 	int led_mode;		/* def: 0 = system default */
 	bool no_sleep_autoadjust; /* def: true = disable autoadjust */
+	bool power_save;	/* def: false = disable power save */
 };
 
 /*
-- 
1.7.0.4

