Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:57327 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932412AbZJ3VgR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 17:36:17 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 14/15] iwlwifi: add SM PS support for 6x50 series
Date: Fri, 30 Oct 2009 14:36:17 -0700
Message-Id: <1256938578-9638-15-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1256938578-9638-1-git-send-email-reinette.chatre@intel.com>
References: <1256938578-9638-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Spatial Multiplexing Power Save was disabled to achieve better
throughput while in power save mode by activating all the rx chains all the time.
By doing so, the device power consumption is high.

Enable static/dynamic spatial multiplexing power save if device support
it, which can lower the power consumption without impact throughput.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |    2 +
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    4 ++
 drivers/net/wireless/iwlwifi/iwl-core.c |   48 ++++++++++++++++++++++++------
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 +
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    1 +
 drivers/net/wireless/iwlwifi/iwl-sta.c  |    5 +++
 6 files changed, 52 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 2f841a8..a4a8b5e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -490,6 +490,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
+	.support_sm_ps = true,
 };
 
 struct iwl_cfg iwl6050_2abg_cfg = {
@@ -579,6 +580,7 @@ struct iwl_cfg iwl6050_3agn_cfg = {
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
+	.support_sm_ps = true,
 };
 
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index e99b753..2bbd04d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3012,6 +3012,10 @@ static int iwl_init_drv(struct iwl_priv *priv)
 	priv->band = IEEE80211_BAND_2GHZ;
 
 	priv->iw_mode = NL80211_IFTYPE_STATION;
+	if (priv->cfg->support_sm_ps)
+		priv->current_ht_config.sm_ps = WLAN_HT_CAP_SM_PS_DYNAMIC;
+	else
+		priv->current_ht_config.sm_ps = WLAN_HT_CAP_SM_PS_DISABLED;
 
 	/* Choose which receivers/antennas to use */
 	if (priv->cfg->ops->hcmd->set_rxon_chain)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 96eb476..6a9d593 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -415,8 +415,12 @@ static void iwlcore_init_ht_hw_capab(const struct iwl_priv *priv,
 	if (priv->cfg->ht_greenfield_support)
 		ht_info->cap |= IEEE80211_HT_CAP_GRN_FLD;
 	ht_info->cap |= IEEE80211_HT_CAP_SGI_20;
-	ht_info->cap |= (IEEE80211_HT_CAP_SM_PS &
-			     (WLAN_HT_CAP_SM_PS_DISABLED << 2));
+	if (priv->cfg->support_sm_ps)
+		ht_info->cap |= (IEEE80211_HT_CAP_SM_PS &
+				     (WLAN_HT_CAP_SM_PS_DYNAMIC << 2));
+	else
+		ht_info->cap |= (IEEE80211_HT_CAP_SM_PS &
+				     (WLAN_HT_CAP_SM_PS_DISABLED << 2));
 
 	max_bit_rate = MAX_BIT_RATE_20_MHZ;
 	if (priv->hw_params.ht40_channel & BIT(band)) {
@@ -964,17 +968,35 @@ static int iwl_get_active_rx_chain_count(struct iwl_priv *priv)
 }
 
 /*
- * When we are in power saving, there's no difference between
- * using multiple chains or just a single chain, but due to the
- * lack of SM PS we lose a lot of throughput if we use just a
- * single chain.
- *
- * Therefore, use the active count here (which will use multiple
- * chains unless connected to a legacy AP).
+ * When we are in power saving mode, unless device support spatial
+ * multiplexing power save, use the active count for rx chain count.
  */
 static int iwl_get_idle_rx_chain_count(struct iwl_priv *priv, int active_cnt)
 {
-	return active_cnt;
+	int idle_cnt = active_cnt;
+	bool is_cam = !test_bit(STATUS_POWER_PMI, &priv->status);
+
+	if (priv->cfg->support_sm_ps) {
+		/* # Rx chains when idling and maybe trying to save power */
+		switch (priv->current_ht_config.sm_ps) {
+		case WLAN_HT_CAP_SM_PS_STATIC:
+		case WLAN_HT_CAP_SM_PS_DYNAMIC:
+			idle_cnt = (is_cam) ? IWL_NUM_IDLE_CHAINS_DUAL :
+				IWL_NUM_IDLE_CHAINS_SINGLE;
+			break;
+		case WLAN_HT_CAP_SM_PS_DISABLED:
+			idle_cnt = (is_cam) ? active_cnt :
+				IWL_NUM_IDLE_CHAINS_SINGLE;
+			break;
+		case WLAN_HT_CAP_SM_PS_INVALID:
+		default:
+			IWL_ERR(priv, "invalid sm_ps mode %d\n",
+				priv->current_ht_config.sm_ps);
+			WARN_ON(1);
+			break;
+		}
+	}
+	return idle_cnt;
 }
 
 /* up to 4 chains */
@@ -2258,6 +2280,12 @@ static void iwl_ht_conf(struct iwl_priv *priv,
 					>> IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT;
 			maxstreams += 1;
 
+			ht_conf->sm_ps =
+				(u8)((ht_cap->cap & IEEE80211_HT_CAP_SM_PS)
+				>> 2);
+			IWL_DEBUG_MAC80211(priv, "sm_ps: 0x%x\n",
+				ht_conf->sm_ps);
+
 			if ((ht_cap->mcs.rx_mask[1] == 0) &&
 			    (ht_cap->mcs.rx_mask[2] == 0))
 				ht_conf->single_chain_sufficient = true;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index ddf0998..d2e47da 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -228,6 +228,7 @@ struct iwl_mod_params {
  * @chain_noise_num_beacons: number of beacons used to compute chain noise
  * @adv_thermal_throttle: support advance thermal throttle
  * @support_ct_kill_exit: support ct kill exit condition
+ * @support_sm_ps: support spatial multiplexing power save
  *
  * We enable the driver to be backward compatible wrt API version. The
  * driver specifies which APIs it supports (with @ucode_api_max being the
@@ -283,6 +284,7 @@ struct iwl_cfg {
 	const bool supports_idle;
 	bool adv_thermal_throttle;
 	bool support_ct_kill_exit;
+	bool support_sm_ps;
 };
 
 /***************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index e7ce673..cb2642c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -517,6 +517,7 @@ struct iwl_ht_config {
 	bool is_ht;
 	bool is_40mhz;
 	bool single_chain_sufficient;
+	u8 sm_ps;
 	/* BSS related data */
 	u8 extension_chan_offset;
 	u8 ht_protection;
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index ce1ceac..74cc8db 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -182,6 +182,11 @@ static void iwl_set_ht_add_station(struct iwl_priv *priv, u8 index,
 		goto done;
 
 	mimo_ps_mode = (sta_ht_inf->cap & IEEE80211_HT_CAP_SM_PS) >> 2;
+	IWL_DEBUG_ASSOC(priv, "spatial multiplexing power save mode: %s\n",
+			(mimo_ps_mode == WLAN_HT_CAP_SM_PS_STATIC) ?
+			"static" :
+			(mimo_ps_mode == WLAN_HT_CAP_SM_PS_DYNAMIC) ?
+			"dynamic" : "disabled");
 
 	sta_flags = priv->stations[index].sta.station_flags;
 
-- 
1.5.6.3

