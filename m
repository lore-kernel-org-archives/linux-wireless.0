Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:43232 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684Ab0KJSBG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 13:01:06 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 13/16] iwlagn: fix RXON HT
Date: Wed, 10 Nov 2010 09:56:47 -0800
Message-Id: <1289411810-23093-14-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1289411810-23093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1289411810-23093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When the HT information is changed due to
BSS changes (like legacy stations joining)
we need to recalculate HT RXON parameters.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index d9d617f..2d927a9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -538,6 +538,7 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 		ctx->ht.non_gf_sta_present = !!(bss_conf->ht_operation_mode &
 					IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);
 		iwlagn_check_needed_chains(priv, ctx, bss_conf);
+		iwl_set_rxon_ht(priv, &priv->current_ht_config);
 	}
 
 	if (priv->cfg->ops->hcmd->set_rxon_chain)
-- 
1.7.0.4

