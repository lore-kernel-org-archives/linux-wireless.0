Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:27422 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721Ab1HBQaX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 12:30:23 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH update for 3.1] iwlagn: 5000 do not support idle mode
Date: Tue,  2 Aug 2011 08:51:55 -0700
Message-Id: <1312300315-24183-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110802_183027_495203_168438BB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

5000 series has issue supporting power save idle mode:

commit	9dc2153315650eae220898668b6aa56a25c130be

iwlwifi: always support idle mode for agn devices

For agn devices, always support idle mode which help power
consumption in idle unassociated state.

the above changes cause 5000 become not stable when power management is "on"

http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2312

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
these patches are also available from wireless-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-5000.c  |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.h  |    2 ++
 drivers/net/wireless/iwlwifi/iwl-power.c |    3 ++-
 3 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 3eeb12e..c95cefd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -365,6 +365,7 @@ static struct iwl_base_params iwl5000_base_params = {
 	.chain_noise_scale = 1000,
 	.wd_timeout = IWL_LONG_WD_TIMEOUT,
 	.max_event_log_size = 512,
+	.no_idle_support = true,
 };
 static struct iwl_ht_params iwl5000_ht_params = {
 	.ht_greenfield_support = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 3e6bb73..02817a4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -135,6 +135,7 @@ struct iwl_mod_params {
  * @temperature_kelvin: temperature report by uCode in kelvin
  * @max_event_log_size: size of event log buffer size for ucode event logging
  * @shadow_reg_enable: HW shadhow register bit
+ * @no_idle_support: do not support idle mode
  */
 struct iwl_base_params {
 	int eeprom_size;
@@ -156,6 +157,7 @@ struct iwl_base_params {
 	bool temperature_kelvin;
 	u32 max_event_log_size;
 	const bool shadow_reg_enable;
+	const bool no_idle_support;
 };
 /*
  * @advanced_bt_coexist: support advanced bt coexist
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 3ec619c..cd64df0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -349,7 +349,8 @@ static void iwl_power_build_cmd(struct iwl_priv *priv,
 
 	if (priv->wowlan)
 		iwl_static_sleep_cmd(priv, cmd, IWL_POWER_INDEX_5, dtimper);
-	else if (priv->hw->conf.flags & IEEE80211_CONF_IDLE)
+	else if (!priv->cfg->base_params->no_idle_support &&
+		 priv->hw->conf.flags & IEEE80211_CONF_IDLE)
 		iwl_static_sleep_cmd(priv, cmd, IWL_POWER_INDEX_5, 20);
 	else if (iwl_tt_is_low_power_state(priv)) {
 		/* in thermal throttling low power state */
-- 
1.7.0.4

