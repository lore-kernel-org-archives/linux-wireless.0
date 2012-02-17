Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46093 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327Ab2BQUXz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 15:23:55 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 25/26] iwlwifi: remove un-necessary return
Date: Fri, 17 Feb 2012 11:13:53 -0800
Message-Id: <1329506034-1394-26-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120217_212430_830579_DEB62707)
In-Reply-To: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Already return 0, change to void

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    5 ++---
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 6dff9c4..f3b72bc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -643,7 +643,7 @@ u8 iwl_get_single_channel_number(struct iwl_priv *priv,
  * NOTE:  Does not commit to the hardware; it sets appropriate bit fields
  * in the staging RXON flag structure based on the ch->band
  */
-int iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch,
+void iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch,
 			 struct iwl_rxon_context *ctx)
 {
 	enum ieee80211_band band = ch->band;
@@ -651,7 +651,7 @@ int iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch,
 
 	if ((le16_to_cpu(ctx->staging.channel) == channel) &&
 	    (priv->band == band))
-		return 0;
+		return;
 
 	ctx->staging.channel = cpu_to_le16(channel);
 	if (band == IEEE80211_BAND_5GHZ)
@@ -663,7 +663,6 @@ int iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch,
 
 	IWL_DEBUG_INFO(priv, "Staging channel set to %d [%d]\n", channel, band);
 
-	return 0;
 }
 
 void iwl_set_flags_for_band(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 49370dd..930e247 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -169,7 +169,7 @@ void iwl_set_rxon_hwcrypto(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 			   int hw_decrypt);
 int iwl_check_rxon_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
 int iwl_full_rxon_required(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
-int iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch,
+void iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch,
 			 struct iwl_rxon_context *ctx);
 void iwl_set_flags_for_band(struct iwl_priv *priv,
 			    struct iwl_rxon_context *ctx,
-- 
1.7.0.4

