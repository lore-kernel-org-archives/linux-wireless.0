Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:36082 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab3LQUpf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:45:35 -0500
Received: by mail-ee0-f52.google.com with SMTP id d17so3099477eek.25
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 12:45:34 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 35/36] iwlwifi: mvm: rs: fix RTS protection being set indefinitely
Date: Tue, 17 Dec 2013 22:44:38 +0200
Message-Id: <1387313079-28123-35-git-send-email-egrumbach@gmail.com> (sfid-20131217_214544_301983_9B9AAA29)
In-Reply-To: <52B0B72A.5070704@gmail.com>
References: <52B0B72A.5070704@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

RTS protection was turned on once aggregation was enabled but it
was never turned off. Remove turning on RTS protection in the LQ command
completely as TX_CMD_FLG_PROT_REQUIRE gets set in iwl_mvm_set_tx_cmd
for every Tx which is part of an aggregation. This would already cause
RTS protection to be used during aggregations.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c |    1 -
 drivers/net/wireless/iwlwifi/mvm/sta.c  |   13 -------------
 2 files changed, 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index 5efc6d1..5fb3772 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -109,7 +109,6 @@ static const struct iwl_base_params iwl7000_base_params = {
 
 static const struct iwl_ht_params iwl7000_ht_params = {
 	.stbc = true,
-	.use_rts_for_aggregation = true, /* use rts/cts protection */
 	.ht40_bands = BIT(IEEE80211_BAND_2GHZ) | BIT(IEEE80211_BAND_5GHZ),
 };
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 4ea00da..0b541ca 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -932,19 +932,6 @@ int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	IWL_DEBUG_HT(mvm, "Tx aggregation enabled on ra = %pM tid = %d\n",
 		     sta->addr, tid);
 
-	if (mvm->cfg->ht_params->use_rts_for_aggregation) {
-		/*
-		 * switch to RTS/CTS if it is the prefer protection
-		 * method for HT traffic
-		 * this function also sends the LQ command
-		 */
-		return iwl_mvm_tx_protection(mvm, mvmsta, true);
-		/*
-		 * TODO: remove the TLC_RTS flag when we tear down the last
-		 * AGG session (agg_tids_count in DVM)
-		 */
-	}
-
 	return iwl_mvm_send_lq_cmd(mvm, &mvmsta->lq_sta.lq, false);
 }
 
-- 
1.7.9.5

