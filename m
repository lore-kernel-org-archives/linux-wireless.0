Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:49357 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755731AbZIKRiV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 13:38:21 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 13/13 v2.6.32 and w-t] iwlwifi: disable powersave for 4965
Date: Fri, 11 Sep 2009 10:38:19 -0700
Message-Id: <1252690699-25796-14-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1252690699-25796-1-git-send-email-reinette.chatre@intel.com>
References: <1252690699-25796-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

There's a bug in 4965 powersave that appears to
be related to the way it keeps track of its data
during sleep, but we haven't found it yet. Due to
that, using powersave may spontaneously cause the
device to SYSASSERT when transitioning from sleep
to wake. Therefore, disable powersave for 4965,
until (if ever, unfortunately) we can identify
and fix the problem.

Cf. http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=1982
which was closed, but now has re-appeared with
IDLE mode, which probably means we never really
fixed it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c  |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.c  |    9 ++++++---
 drivers/net/wireless/iwlwifi/iwl-core.h  |    1 +
 drivers/net/wireless/iwlwifi/iwl-power.c |    5 +++--
 4 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 63df1e4..d61d5a3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2346,6 +2346,7 @@ struct iwl_cfg iwl4965_agn_cfg = {
 	.mod_params = &iwl4965_mod_params,
 	.use_isr_legacy = true,
 	.ht_greenfield_support = false,
+	.broken_powersave = true,
 	.led_compensation = 61,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 5c6cee2..e447c1a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1565,9 +1565,12 @@ int iwl_setup_mac(struct iwl_priv *priv)
 	hw->flags = IEEE80211_HW_SIGNAL_DBM |
 		    IEEE80211_HW_NOISE_DBM |
 		    IEEE80211_HW_AMPDU_AGGREGATION |
-		    IEEE80211_HW_SPECTRUM_MGMT |
-		    IEEE80211_HW_SUPPORTS_PS |
-		    IEEE80211_HW_SUPPORTS_DYNAMIC_PS;
+		    IEEE80211_HW_SPECTRUM_MGMT;
+
+	if (!priv->cfg->broken_powersave)
+		hw->flags |= IEEE80211_HW_SUPPORTS_PS |
+			     IEEE80211_HW_SUPPORTS_DYNAMIC_PS;
+
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index cab148d..5e1f700 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -256,6 +256,7 @@ struct iwl_cfg {
 	const bool shadow_ram_support;
 	const bool ht_greenfield_support;
 	u16 led_compensation;
+	const bool broken_powersave;
 };
 
 /***************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 4ec6a83..60be976 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -292,8 +292,9 @@ int iwl_power_update_mode(struct iwl_priv *priv, bool force)
 	else
 		dtimper = 1;
 
-	/* TT power setting overwrites everything */
-	if (tt->state >= IWL_TI_1)
+	if (priv->cfg->broken_powersave)
+		iwl_power_sleep_cam_cmd(priv, &cmd);
+	else if (tt->state >= IWL_TI_1)
 		iwl_static_sleep_cmd(priv, &cmd, tt->tt_power_mode, dtimper);
 	else if (!enabled)
 		iwl_power_sleep_cam_cmd(priv, &cmd);
-- 
1.5.6.3

