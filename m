Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:4149 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758659AbZKFXRG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 18:17:06 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>, stable@kernel.org
Subject: [PATCH 1/2 v2.6.32] iwlwifi: Use RTS/CTS as the preferred protection mechanism for 6000 series
Date: Fri,  6 Nov 2009 15:17:04 -0800
Message-Id: <1257549425-13591-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1257549425-13591-1-git-send-email-reinette.chatre@intel.com>
References: <1257549425-13591-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

When 802.11g was introduced, we had RTS/CTS and CTS-to-Self protection
mechanisms. In an HT Beacon, HT stations use the "Operating Mode" field
in the HT Information Element to determine whether or not to use
protection.

The Operating Mode field has 4 possible settings: 0-3:
Mode 0: If all stations in the BSS are 20/40 MHz HT capable, or if the
BSS is 20/40 MHz capable, or if all stations in the BSS are 20 MHz HT
stations in a 20 MHz BSS
Mode 1: used if there are non-HT stations or APs using the primary or
secondary channels
Mode 2: if only HT stations are associated in the BSS and at least one
20 MHz HT station is associated.
Mode 3: used if one or more non-HT stations are associated in the BSS.

When in operating modes 1 or 3, and the Use_Protection field is 1 in the
Beacon's ERP IE, all HT transmissions must be protected using RTS/CTS or
CTS-to-Self.

By default, CTS-to-self is the preferred protection mechanism for less
overhead and higher throughput; but using the full RTS/CTS will better
protect the inner exchange from interference, especially in
highly-congested environment.

For 6000 series WIFI NIC, RTS/CTS protection mechanism is the
recommended choice for HT traffic based on the HW design.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
cc: stable@kernel.org
---
These patches are also targeting stable but do not apply there in its
current form. They will be backported and submitted there once they make it
into linux-2.6. The cc to stable@kernel.org is just informational.

 drivers/net/wireless/iwlwifi/iwl-6000.c   |    5 +++++
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    9 +++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c    |   10 +++++++---
 drivers/net/wireless/iwlwifi/iwl-core.h   |    2 ++
 4 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index c295b8e..1473452 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -175,6 +175,7 @@ struct iwl_cfg iwl6000h_2agn_cfg = {
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
 	.ht_greenfield_support = true,
+	.use_rts_for_ht = true, /* use rts/cts protection */
 };
 
 /*
@@ -198,6 +199,7 @@ struct iwl_cfg iwl6000i_2agn_cfg = {
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
 	.ht_greenfield_support = true,
+	.use_rts_for_ht = true, /* use rts/cts protection */
 };
 
 struct iwl_cfg iwl6050_2agn_cfg = {
@@ -218,6 +220,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
 	.ht_greenfield_support = true,
+	.use_rts_for_ht = true, /* use rts/cts protection */
 };
 
 struct iwl_cfg iwl6000_3agn_cfg = {
@@ -238,6 +241,7 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
 	.ht_greenfield_support = true,
+	.use_rts_for_ht = true, /* use rts/cts protection */
 };
 
 struct iwl_cfg iwl6050_3agn_cfg = {
@@ -258,6 +262,7 @@ struct iwl_cfg iwl6050_3agn_cfg = {
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
 	.ht_greenfield_support = true,
+	.use_rts_for_ht = true, /* use rts/cts protection */
 };
 
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 346dc06..81726ee 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -418,6 +418,15 @@ static void rs_tl_turn_on_agg(struct iwl_priv *priv, u8 tid,
 	else if (tid == IWL_AGG_ALL_TID)
 		for (tid = 0; tid < TID_MAX_LOAD_COUNT; tid++)
 			rs_tl_turn_on_agg_for_tid(priv, lq_data, tid, sta);
+	if (priv->cfg->use_rts_for_ht) {
+		/*
+		 * switch to RTS/CTS if it is the prefer protection method
+		 * for HT traffic
+		 */
+		IWL_DEBUG_HT(priv, "use RTS/CTS protection for HT\n");
+		priv->staging_rxon.flags &= ~RXON_FLG_SELF_CTS_EN;
+		iwlcore_commit_rxon(priv);
+	}
 }
 
 static inline int get_num_of_ant_from_rate(u32 rate_n_flags)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index eaafae0..921dc4a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -116,9 +116,6 @@ int iwl_commit_rxon(struct iwl_priv *priv)
 
 	/* always get timestamp with Rx frame */
 	priv->staging_rxon.flags |= RXON_FLG_TSF2HOST_MSK;
-	/* allow CTS-to-self if possible. this is relevant only for
-	 * 5000, but will not damage 4965 */
-	priv->staging_rxon.flags |= RXON_FLG_SELF_CTS_EN;
 
 	ret = iwl_check_rxon_cmd(priv);
 	if (ret) {
@@ -218,6 +215,13 @@ int iwl_commit_rxon(struct iwl_priv *priv)
 					"Could not send WEP static key.\n");
 		}
 
+		/*
+		 * allow CTS-to-self if possible for new association.
+		 * this is relevant only for 5000 series and up,
+		 * but will not damage 4965
+		 */
+		priv->staging_rxon.flags |= RXON_FLG_SELF_CTS_EN;
+
 		/* Apply the new configuration
 		 * RXON assoc doesn't clear the station table in uCode,
 		 */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index e50103a..7754538 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -213,6 +213,7 @@ struct iwl_mod_params {
  * @pa_type: used by 6000 series only to identify the type of Power Amplifier
  * @max_ll_items: max number of OTP blocks
  * @shadow_ram_support: shadow support for OTP memory
+ * @use_rts_for_ht: use rts/cts protection for HT traffic
  *
  * We enable the driver to be backward compatible wrt API version. The
  * driver specifies which APIs it supports (with @ucode_api_max being the
@@ -255,6 +256,7 @@ struct iwl_cfg {
 	const bool shadow_ram_support;
 	const bool ht_greenfield_support;
 	const bool broken_powersave;
+	bool use_rts_for_ht;
 };
 
 /***************************
-- 
1.5.6.3

