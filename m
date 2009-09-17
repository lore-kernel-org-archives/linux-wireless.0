Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:9689 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995AbZIQRnx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 13:43:53 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 01/13] iwlwifi: Use RTS/CTS as the preferred protection mechanism for 6000 series
Date: Thu, 17 Sep 2009 10:43:44 -0700
Message-Id: <1253209436-2309-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1253209436-2309-1-git-send-email-reinette.chatre@intel.com>
References: <1253209436-2309-1-git-send-email-reinette.chatre@intel.com>
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
---
 drivers/net/wireless/iwlwifi/iwl-6000.c   |    5 +++++
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    9 +++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c    |   10 +++++++---
 drivers/net/wireless/iwlwifi/iwl-core.h   |    2 ++
 4 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 89b111a..c4ae99f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -257,6 +257,7 @@ struct iwl_cfg iwl6000h_2agn_cfg = {
 	.shadow_ram_support = true,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
+	.use_rts_for_ht = true, /* use rts/cts protection */
 };
 
 /*
@@ -281,6 +282,7 @@ struct iwl_cfg iwl6000i_2agn_cfg = {
 	.shadow_ram_support = true,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
+	.use_rts_for_ht = true, /* use rts/cts protection */
 };
 
 struct iwl_cfg iwl6050_2agn_cfg = {
@@ -302,6 +304,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.shadow_ram_support = true,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
+	.use_rts_for_ht = true, /* use rts/cts protection */
 };
 
 struct iwl_cfg iwl6000_3agn_cfg = {
@@ -323,6 +326,7 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.shadow_ram_support = true,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
+	.use_rts_for_ht = true, /* use rts/cts protection */
 };
 
 struct iwl_cfg iwl6050_3agn_cfg = {
@@ -344,6 +348,7 @@ struct iwl_cfg iwl6050_3agn_cfg = {
 	.shadow_ram_support = true,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
+	.use_rts_for_ht = true, /* use rts/cts protection */
 };
 
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 18af37c..469d563 100644
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
index 00457bf..c0939dc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -115,9 +115,6 @@ int iwl_commit_rxon(struct iwl_priv *priv)
 
 	/* always get timestamp with Rx frame */
 	priv->staging_rxon.flags |= RXON_FLG_TSF2HOST_MSK;
-	/* allow CTS-to-self if possible. this is relevant only for
-	 * 5000, but will not damage 4965 */
-	priv->staging_rxon.flags |= RXON_FLG_SELF_CTS_EN;
 
 	ret = iwl_check_rxon_cmd(priv);
 	if (ret) {
@@ -217,6 +214,13 @@ int iwl_commit_rxon(struct iwl_priv *priv)
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
index 5e1f700..4f7c133 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -214,6 +214,7 @@ struct iwl_mod_params {
  * @led_compensation: compensate on the led on/off time per HW according
  *	to the deviation to achieve the desired led frequency.
  *	The detail algorithm is described in iwl-led.c
+ * @use_rts_for_ht: use rts/cts protection for HT traffic
  *
  * We enable the driver to be backward compatible wrt API version. The
  * driver specifies which APIs it supports (with @ucode_api_max being the
@@ -257,6 +258,7 @@ struct iwl_cfg {
 	const bool ht_greenfield_support;
 	u16 led_compensation;
 	const bool broken_powersave;
+	bool use_rts_for_ht;
 };
 
 /***************************
-- 
1.5.6.3

