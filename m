Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:40709 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754938Ab0KJSBG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 13:01:06 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 12/16] iwlagn: re-enable calibration
Date: Wed, 10 Nov 2010 09:56:46 -0800
Message-Id: <1289411810-23093-13-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1289411810-23093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1289411810-23093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

During the RXON rewrite, this code got lost.
When we've just associated, we need to enable
all calibrations and see if some were already
finished. Add back the missing code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index d594a16..d9d617f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -569,6 +569,20 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 	if (force || memcmp(&ctx->staging, &ctx->active, sizeof(ctx->staging)))
 		iwlagn_commit_rxon(priv, ctx);
 
+	if (changes & BSS_CHANGED_ASSOC && bss_conf->assoc) {
+		/*
+		 * The chain noise calibration will enable PM upon
+		 * completion. If calibration has already been run
+		 * then we need to enable power management here.
+		 */
+		if (priv->chain_noise_data.state == IWL_CHAIN_NOISE_DONE)
+			iwl_power_update_mode(priv, false);
+
+		/* Enable RX differential gain and sensitivity calibrations */
+		iwl_chain_noise_reset(priv);
+		priv->start_calib = 1;
+	}
+
 	if (changes & BSS_CHANGED_IBSS) {
 		ret = iwlagn_manage_ibss_station(priv, vif,
 						 bss_conf->ibss_joined);
-- 
1.7.0.4

