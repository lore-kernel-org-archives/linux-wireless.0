Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:38261 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbaEGTxn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 15:53:43 -0400
Received: by mail-wg0-f50.google.com with SMTP id x12so1531754wgg.9
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 12:53:42 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/23] iwlwifi: mvm: rs: don't allow TPC when power save is disabled
Date: Wed,  7 May 2014 22:52:43 +0300
Message-Id: <1399492380-12050-6-git-send-email-egrumbach@gmail.com> (sfid-20140507_215439_335410_8C5A1070)
In-Reply-To: <536A8EE3.2050906@gmail.com>
References: <536A8EE3.2050906@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Currently we were checking only if the driver power_scheme is set
to CAM. TPC shouldn't be enabled also when disabling powersave on the
interface (e.g. iw wlan0 set power_save off)
which may occur even if power_scheme wasn't set to CAM.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Reviewed-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index a7ad532..32ac66b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -1750,16 +1750,21 @@ static void rs_get_adjacent_txp(struct iwl_mvm *mvm, int index,
 		*stronger = TPC_INVALID;
 }
 
-static bool rs_tpc_allowed(struct iwl_mvm *mvm, struct rs_rate *rate,
-			   enum ieee80211_band band)
+static bool rs_tpc_allowed(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+			   struct rs_rate *rate, enum ieee80211_band band)
 {
 	int index = rate->index;
+	bool cam = (iwlmvm_mod_params.power_scheme == IWL_POWER_SCHEME_CAM);
+	bool sta_ps_disabled = (vif->type == NL80211_IFTYPE_STATION &&
+				!vif->bss_conf.ps);
 
+	IWL_DEBUG_RATE(mvm, "cam: %d sta_ps_disabled %d\n",
+		       cam, sta_ps_disabled);
 	/*
 	 * allow tpc only if power management is enabled, or bt coex
 	 * activity grade allows it and we are on 2.4Ghz.
 	 */
-	if (iwlmvm_mod_params.power_scheme == IWL_POWER_SCHEME_CAM &&
+	if ((cam || sta_ps_disabled) &&
 	    !iwl_mvm_bt_coex_is_tpc_allowed(mvm, band))
 		return false;
 
@@ -1876,7 +1881,7 @@ static bool rs_tpc_perform(struct iwl_mvm *mvm,
 		band = chanctx_conf->def.chan->band;
 	rcu_read_unlock();
 
-	if (!rs_tpc_allowed(mvm, rate, band)) {
+	if (!rs_tpc_allowed(mvm, vif, rate, band)) {
 		IWL_DEBUG_RATE(mvm,
 			       "tpc is not allowed. remove txp restrictions");
 		lq_sta->lq.reduced_tpc = TPC_NO_REDUCTION;
-- 
1.8.3.2

