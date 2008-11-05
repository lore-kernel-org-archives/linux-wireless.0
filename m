Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18823 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257AbYKETNk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 14:13:40 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/2 2.6.28] iwlwifi : Fix channel scanning/association in 5Ghz band
Date: Wed,  5 Nov 2008 11:14:08 -0800
Message-Id: <1225912449-26625-1-git-send-email-reinette.chatre@intel.com> (sfid-20081105_201406_041699_2AEFC874)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

A new wireless regulatory API has been added and
static definitions of regulatory alpha2 have been removed.
As a result of this 5Ghz channels have been disabled by default.
Patch takes care of this by setting the regulatory domain
by reading the EEPROM contents.
It uses regulatory_hint function to dynamically set the regulatory
channels.

This patch is related to bug 11870 at bugzilla.kernel.org. With
correct regulatory information the number of channels to scan
will be correct and not zero as seen in that bug.

This patch eliminates the need for wireless to be compiled with
CONFIG_WIRELESS_OLD_REGULATORY to get correct regulatory behavior with
iwlwifi.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Could you please send up to 2.6.28? This patch is not valid for
wireless-testing - we will send another patch when regulatory_struct_hint
is available.

 drivers/net/wireless/iwlwifi/iwl-agn.c  |    5 ++
 drivers/net/wireless/iwlwifi/iwl-core.c |   83 +++++++++++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-core.h |    1 +
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    2 +
 4 files changed, 86 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 321dbc8..067f5b6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4345,6 +4345,11 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	if (err)
 		IWL_ERROR("failed to create debugfs files\n");
 
+	err = iwl_set_reg_domain(priv);
+	if (err) {
+		IWL_ERROR("Failed to set regulatory domain (error %d)\n", err);
+		goto out_remove_sysfs;
+	}
 	err = iwl_rfkill_init(priv);
 	if (err)
 		IWL_ERROR("Unable to initialize RFKILL system. "
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 4c312c5..b36966d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -456,6 +456,39 @@ static void iwlcore_init_hw_rates(struct iwl_priv *priv,
 	}
 }
 
+ /* Regulatory Domains
+  * After 2.6.29 , driver has to pass regulatory domain or alpha2 to
+  * core wireless CRDA using regulatory_hint api
+  */
+
+/**
+ * iwl_set_reg_domain - Set Regulatory Domain
+ */
+
+int iwl_set_reg_domain(struct iwl_priv *priv)
+{
+	int err;
+
+	IWL_DEBUG_INFO("Setting Regulatory Domain\n");
+	err = regulatory_hint(priv->hw->wiphy, NULL, priv->rd);
+	if (err)  {
+		if (err == -EALREADY)
+			err = 0;
+		kfree(priv->rd);
+	}
+	return err;
+}
+EXPORT_SYMBOL(iwl_set_reg_domain);
+
+#define REG_RULES(rule, start, end, bw, gain, eirp, reg_flags) { \
+		rule.freq_range.start_freq_khz = (start) * 1000; \
+		rule.freq_range.end_freq_khz = (end) * 1000; \
+		rule.freq_range.max_bandwidth_khz = (bw) * 1000; \
+		rule.power_rule.max_antenna_gain = (gain) * 100; \
+		rule.power_rule.max_eirp = (eirp) * 100; \
+		rule.flags = reg_flags; \
+		}
+
 /**
  * iwlcore_init_geos - Initialize mac80211's geo/channel info based from eeprom
  */
@@ -466,7 +499,9 @@ static int iwlcore_init_geos(struct iwl_priv *priv)
 	struct ieee80211_channel *channels;
 	struct ieee80211_channel *geo_ch;
 	struct ieee80211_rate *rates;
-	int i = 0;
+	int i = 0, reg_flags = 0, reg_count;
+	struct ieee80211_reg_rule *reg_rule;
+	int size_of_regd;
 
 	if (priv->bands[IEEE80211_BAND_2GHZ].n_bitrates ||
 	    priv->bands[IEEE80211_BAND_5GHZ].n_bitrates) {
@@ -475,14 +510,22 @@ static int iwlcore_init_geos(struct iwl_priv *priv)
 		return 0;
 	}
 
+	reg_rule = kzalloc(sizeof(struct ieee80211_reg_rule) *
+			   priv->channel_count, GFP_KERNEL);
+	if (!reg_rule)
+		return -ENOMEM;
+
 	channels = kzalloc(sizeof(struct ieee80211_channel) *
 			   priv->channel_count, GFP_KERNEL);
-	if (!channels)
+	if (!channels) {
+		kfree(reg_rule);
 		return -ENOMEM;
+	}
 
 	rates = kzalloc((sizeof(struct ieee80211_rate) * (IWL_RATE_COUNT + 1)),
 			GFP_KERNEL);
 	if (!rates) {
+		kfree(reg_rule);
 		kfree(channels);
 		return -ENOMEM;
 	}
@@ -513,7 +556,7 @@ static int iwlcore_init_geos(struct iwl_priv *priv)
 
 	iwlcore_init_hw_rates(priv, rates);
 
-	for (i = 0;  i < priv->channel_count; i++) {
+	for (i = 0, reg_count = 0;  i < priv->channel_count; i++) {
 		ch = &priv->channel_info[i];
 
 		/* FIXME: might be removed if scan is OK */
@@ -534,11 +577,15 @@ static int iwlcore_init_geos(struct iwl_priv *priv)
 		geo_ch->hw_value = ch->channel;
 
 		if (is_channel_valid(ch)) {
-			if (!(ch->flags & EEPROM_CHANNEL_IBSS))
+			if (!(ch->flags & EEPROM_CHANNEL_IBSS)) {
 				geo_ch->flags |= IEEE80211_CHAN_NO_IBSS;
+				reg_flags |= NL80211_RRF_NO_IBSS;
+			}
 
-			if (!(ch->flags & EEPROM_CHANNEL_ACTIVE))
+			if (!(ch->flags & EEPROM_CHANNEL_ACTIVE)) {
 				geo_ch->flags |= IEEE80211_CHAN_PASSIVE_SCAN;
+				reg_flags |= NL80211_RRF_PASSIVE_SCAN;
+			}
 
 			if (ch->flags & EEPROM_CHANNEL_RADAR)
 				geo_ch->flags |= IEEE80211_CHAN_RADAR;
@@ -554,6 +601,13 @@ static int iwlcore_init_geos(struct iwl_priv *priv)
 		/* Save flags for reg domain usage */
 		geo_ch->orig_flags = geo_ch->flags;
 
+		/* Add new Regulatory channel */
+		REG_RULES(reg_rule[reg_count], geo_ch->center_freq - 20,
+			 geo_ch->center_freq + 20, 40, geo_ch->max_antenna_gain,
+			 geo_ch->max_power, reg_flags);
+		reg_flags = 0;
+		reg_count++;
+
 		IWL_DEBUG_INFO("Channel %d Freq=%d[%sGHz] %s flag=0x%X\n",
 				ch->channel, geo_ch->center_freq,
 				is_channel_a_band(ch) ?  "5.2" : "2.4",
@@ -576,8 +630,27 @@ static int iwlcore_init_geos(struct iwl_priv *priv)
 	       priv->bands[IEEE80211_BAND_2GHZ].n_channels,
 	       priv->bands[IEEE80211_BAND_5GHZ].n_channels);
 
+	size_of_regd = sizeof(struct ieee80211_regdomain) +
+			(reg_count * sizeof(struct ieee80211_reg_rule));
+
+	priv->rd = kzalloc(size_of_regd, GFP_KERNEL);
+	if (!priv->rd) {
+		kfree(reg_rule);
+		kfree(channels);
+		kfree(rates);
+		return -ENOMEM;
+	}
+
+	priv->rd->n_reg_rules = reg_count;
+	strncpy(priv->rd->alpha2, "99", 2);
+
+	for (i = 0; i < reg_count; i++) {
+		memcpy(&priv->rd->reg_rules[i], &reg_rule[i],
+			sizeof(struct ieee80211_reg_rule));
+	}
 
 	set_bit(STATUS_GEO_CONFIGURED, &priv->status);
+	kfree(reg_rule);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 288b6a8..94ef48c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -194,6 +194,7 @@ u8 iwl_is_fat_tx_allowed(struct iwl_priv *priv,
 int iwl_hw_nic_init(struct iwl_priv *priv);
 int iwl_setup_mac(struct iwl_priv *priv);
 int iwl_set_hw_params(struct iwl_priv *priv);
+int iwl_set_reg_domain(struct iwl_priv *priv);
 int iwl_init_drv(struct iwl_priv *priv);
 void iwl_uninit_drv(struct iwl_priv *priv);
 /* "keep warm" functions */
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index c018121..bfe6f6e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -775,6 +775,8 @@ struct iwl_priv {
 	struct ieee80211_rate *ieee_rates;
 	struct iwl_cfg *cfg;
 
+	struct ieee80211_regdomain *rd; /*Regulatroy Domain Information */
+
 	/* temporary frame storage list */
 	struct list_head free_frames;
 	int frames_count;
-- 
1.5.4.3

