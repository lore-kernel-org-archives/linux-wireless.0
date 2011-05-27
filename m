Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26815 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754725Ab1E0QIB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2011 12:08:01 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/10] iwlagn: solve sparse warning
Date: Fri, 27 May 2011 08:40:27 -0700
Message-Id: <1306510833-32049-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110527_180806_472782_4457CFF9)
In-Reply-To: <1306510833-32049-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1306510833-32049-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Remove local variable that was shadowing another one
sta_priv hasn't changed since the beginning of the function, so don't define
another pointer with the same name to the same variable

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index e027f99..58ed9a0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2711,12 +2711,9 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 			ret = 0;
 		if (priv->cfg->ht_params &&
 		    priv->cfg->ht_params->use_rts_for_aggregation) {
-			struct iwl_station_priv *sta_priv =
-				(void *) sta->drv_priv;
 			/*
 			 * switch off RTS/CTS if it was previously enabled
 			 */
-
 			sta_priv->lq_sta.lq.general_params.flags &=
 				~LINK_QUAL_FLAGS_SET_STA_TLC_RTS_MSK;
 			iwl_send_lq_cmd(priv, iwl_rxon_ctx_from_vif(vif),
-- 
1.7.0.4

