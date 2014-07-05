Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:62759 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755874AbaGETd6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2014 15:33:58 -0400
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 2/3] iwlwifi: dvm: don't enable CTS to self
Date: Sat,  5 Jul 2014 22:33:48 +0300
Message-Id: <1404588829-14168-2-git-send-email-egrumbach@gmail.com> (sfid-20140705_213403_088967_17C8DCA5)
In-Reply-To: <53B852D4.5060109@gmail.com>
References: <53B852D4.5060109@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

We should always prefer to use full RTS protection. Using
CTS to self gives a meaningless improvement, but this flow
is much harder for the firmware which is likely to have
issues with it.

CC: <stable@vger.kernel.org>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/rxon.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/rxon.c b/drivers/net/wireless/iwlwifi/dvm/rxon.c
index ed50de6..6dc5dd3 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rxon.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rxon.c
@@ -1068,13 +1068,6 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	/* recalculate basic rates */
 	iwl_calc_basic_rates(priv, ctx);
 
-	/*
-	 * force CTS-to-self frames protection if RTS-CTS is not preferred
-	 * one aggregation protection method
-	 */
-	if (!priv->hw_params.use_rts_for_aggregation)
-		ctx->staging.flags |= RXON_FLG_SELF_CTS_EN;
-
 	if ((ctx->vif && ctx->vif->bss_conf.use_short_slot) ||
 	    !(ctx->staging.flags & RXON_FLG_BAND_24G_MSK))
 		ctx->staging.flags |= RXON_FLG_SHORT_SLOT_MSK;
@@ -1480,11 +1473,6 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 	else
 		ctx->staging.flags &= ~RXON_FLG_TGG_PROTECT_MSK;
 
-	if (bss_conf->use_cts_prot)
-		ctx->staging.flags |= RXON_FLG_SELF_CTS_EN;
-	else
-		ctx->staging.flags &= ~RXON_FLG_SELF_CTS_EN;
-
 	memcpy(ctx->staging.bssid_addr, bss_conf->bssid, ETH_ALEN);
 
 	if (vif->type == NL80211_IFTYPE_AP ||
-- 
1.8.3.2

