Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:33593 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbaIAHM5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2014 03:12:57 -0400
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 1/3] Revert "iwlwifi: dvm: don't enable CTS to self"
Date: Mon,  1 Sep 2014 10:12:48 +0300
Message-Id: <1409555570-18567-1-git-send-email-egrumbach@gmail.com> (sfid-20140901_091303_724995_03CD03C1)
In-Reply-To: <54041C13.7000905@gmail.com>
References: <54041C13.7000905@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This reverts commit 43d826ca5979927131685cc2092c7ce862cb91cd.

This commit caused packet loss.

Cc: <stable@vger.kernel.org>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
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
1.9.1

