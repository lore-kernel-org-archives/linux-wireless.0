Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:2957 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755490Ab1DRQCk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 12:02:40 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Daniel Halperin <dhalperi@cs.washington.edu>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH wireless-2.6] iwlwifi: fix frame injection for HT channels
Date: Mon, 18 Apr 2011 08:41:31 -0700
Message-Id: <1303141291-902-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Halperin <dhalperi@cs.washington.edu>

For some reason, sending QoS configuration causes transmission to stop
after a single frame on HT channels when not associated. Removing the
extra QoS configuration has no effect on station mode, and fixes
injection mode.

Signed-off-by: Daniel Halperin <dhalperi@cs.washington.edu>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
these patches are also available from wireless-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index dfdbea6..fbbde07 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -335,7 +335,6 @@ int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 	struct ieee80211_channel *channel = conf->channel;
 	const struct iwl_channel_info *ch_info;
 	int ret = 0;
-	bool ht_changed[NUM_IWL_RXON_CTX] = {};
 
 	IWL_DEBUG_MAC80211(priv, "changed %#x", changed);
 
@@ -383,10 +382,8 @@ int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 
 		for_each_context(priv, ctx) {
 			/* Configure HT40 channels */
-			if (ctx->ht.enabled != conf_is_ht(conf)) {
+			if (ctx->ht.enabled != conf_is_ht(conf))
 				ctx->ht.enabled = conf_is_ht(conf);
-				ht_changed[ctx->ctxid] = true;
-			}
 
 			if (ctx->ht.enabled) {
 				if (conf_is_ht40_minus(conf)) {
@@ -455,8 +452,6 @@ int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 		if (!memcmp(&ctx->staging, &ctx->active, sizeof(ctx->staging)))
 			continue;
 		iwlagn_commit_rxon(priv, ctx);
-		if (ht_changed[ctx->ctxid])
-			iwlagn_update_qos(priv, ctx);
 	}
  out:
 	mutex_unlock(&priv->mutex);
-- 
1.7.0.4

