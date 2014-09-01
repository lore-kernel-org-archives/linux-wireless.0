Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.197]:60928 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbaIACXM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Aug 2014 22:23:12 -0400
From: Jim Rees <rees@umich.edu>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] Revert "iwlwifi: dvm: don't enable CTS to self"
Date: Sun, 31 Aug 2014 22:22:27 -0400
Message-Id: <1409538147-1564-1-git-send-email-rees@umich.edu> (sfid-20140901_042315_997053_0F423CC3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Without this revert, my Thinkpad x220 with iwlwifi Ultimate-N 6300 AGN gets
35% packet drop rate.

This reverts commit 43d826ca5979927131685cc2092c7ce862cb91cd.

Signed-off-by: Jim Rees <rees@umich.edu>
---
 drivers/net/wireless/iwlwifi/dvm/rxon.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/dvm/rxon.c b/drivers/net/wireless/iwlwifi/dvm/rxon.c
index 6dc5dd3..ed50de6 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rxon.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rxon.c
@@ -1068,6 +1068,13 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	/* recalculate basic rates */
 	iwl_calc_basic_rates(priv, ctx);
 
+	/*
+	 * force CTS-to-self frames protection if RTS-CTS is not preferred
+	 * one aggregation protection method
+	 */
+	if (!priv->hw_params.use_rts_for_aggregation)
+		ctx->staging.flags |= RXON_FLG_SELF_CTS_EN;
+
 	if ((ctx->vif && ctx->vif->bss_conf.use_short_slot) ||
 	    !(ctx->staging.flags & RXON_FLG_BAND_24G_MSK))
 		ctx->staging.flags |= RXON_FLG_SHORT_SLOT_MSK;
@@ -1473,6 +1480,11 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 	else
 		ctx->staging.flags &= ~RXON_FLG_TGG_PROTECT_MSK;
 
+	if (bss_conf->use_cts_prot)
+		ctx->staging.flags |= RXON_FLG_SELF_CTS_EN;
+	else
+		ctx->staging.flags &= ~RXON_FLG_SELF_CTS_EN;
+
 	memcpy(ctx->staging.bssid_addr, bss_conf->bssid, ETH_ALEN);
 
 	if (vif->type == NL80211_IFTYPE_AP ||
-- 
2.1.0

