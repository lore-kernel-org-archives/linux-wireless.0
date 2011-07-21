Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:32866 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206Ab1GUP0w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 11:26:52 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 22/25] iwlagn: track beacon interval sent to device
Date: Thu, 21 Jul 2011 07:50:25 -0700
Message-Id: <1311259828-8415-23-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110721_172705_534926_D4D5C369)
In-Reply-To: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Sometimes, when mac80211 changes the beacon
interval or when it isn't yet set in mac80211
before association, the uCode will sysassert
because we send it confusing RXON timing vs.
PAN parameters. To fix this, track the last
beacon interval sent to the device and use
that in PAN parameter calculations.

This fixes a bug during P2P group formation
as a client (and possibly association to a
regular AP) while connected to another AP.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   11 +++++------
 drivers/net/wireless/iwlwifi/iwl-core.c     |    2 ++
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 ++
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index d78a465..d42ef17 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -342,7 +342,7 @@ int iwlagn_set_pan_params(struct iwl_priv *priv)
 		slot1 = priv->hw_roc_duration;
 		slot0 = IWL_MIN_SLOT_TIME;
 	} else if (ctx_bss->vif && ctx_pan->vif) {
-		int bcnint = ctx_pan->vif->bss_conf.beacon_int;
+		int bcnint = ctx_pan->beacon_int;
 		int dtim = ctx_pan->vif->bss_conf.dtim_period ?: 1;
 
 		/* should be set, but seems unused?? */
@@ -350,14 +350,13 @@ int iwlagn_set_pan_params(struct iwl_priv *priv)
 
 		if (ctx_pan->vif->type == NL80211_IFTYPE_AP &&
 		    bcnint &&
-		    bcnint != ctx_bss->vif->bss_conf.beacon_int) {
+		    bcnint != ctx_bss->beacon_int) {
 			IWL_ERR(priv,
 				"beacon intervals don't match (%d, %d)\n",
-				ctx_bss->vif->bss_conf.beacon_int,
-				ctx_pan->vif->bss_conf.beacon_int);
+				ctx_bss->beacon_int, ctx_pan->beacon_int);
 		} else
 			bcnint = max_t(int, bcnint,
-				       ctx_bss->vif->bss_conf.beacon_int);
+				       ctx_bss->beacon_int);
 		if (!bcnint)
 			bcnint = DEFAULT_BEACON_INTERVAL;
 		slot0 = bcnint / 2;
@@ -376,7 +375,7 @@ int iwlagn_set_pan_params(struct iwl_priv *priv)
 	} else if (ctx_pan->vif) {
 		slot0 = 0;
 		slot1 = max_t(int, 1, ctx_pan->vif->bss_conf.dtim_period) *
-					ctx_pan->vif->bss_conf.beacon_int;
+					ctx_pan->beacon_int;
 		slot1 = max_t(int, DEFAULT_BEACON_INTERVAL, slot1);
 
 		if (test_bit(STATUS_SCAN_HW, &priv->status)) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 2f42547..cf376f6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -363,6 +363,8 @@ int iwl_send_rxon_timing(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 		ctx->timing.beacon_interval = cpu_to_le16(beacon_int);
 	}
 
+	ctx->beacon_int = beacon_int;
+
 	tsf = priv->timestamp; /* tsf is modifed by do_div: copy it */
 	interval_tm = beacon_int * TIME_UNIT;
 	rem = do_div(tsf, interval_tm);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index fc23873..8da38be 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1152,6 +1152,8 @@ struct iwl_rxon_context {
 
 	__le32 station_flags;
 
+	int beacon_int;
+
 	struct {
 		bool non_gf_sta_present;
 		u8 protection;
-- 
1.7.0.4

