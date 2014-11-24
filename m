Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:59303 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115AbaKXOfL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:11 -0500
Received: by mail-wg0-f52.google.com with SMTP id a1so12357993wgh.11
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:35:10 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/75] iwlwifi: mvm: rs: fix getting stuck in a test window
Date: Mon, 24 Nov 2014 16:33:45 +0200
Message-Id: <1416839691-28533-9-git-send-email-egrumbach@gmail.com> (sfid-20141124_153518_331527_D1B8B500)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

When Tx STBC is being used and RS switches to a search column
using the alternate antenna from the current one there is a
problem with using rs_rate_match to figure out which table
is the active and which one is the search one. The root cause
is because in STBC the antenna mask in the ucode rate is set
to ANT_AB and in this specific scenario it matches both the
active and search table (e.g. SISO_ANT_A and SISO_ANT_B).
This leads to tx stats being updated in the wrong table and later
on to getting stuck in a test window and not moving on to other
columns. If this happens during the initial search cycle we
never end it and therefore never enable aggregation which leads
naturally to severe througput degradation.
Fix it by deducing which table is which by knowing whether we're
in a search or not like it's being done in rs_rate_scale_perform

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index cb18b60..bbd2f9b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -506,7 +506,7 @@ static inline void rs_dump_rate(struct iwl_mvm *mvm, const struct rs_rate *rate,
 				const char *prefix)
 {
 	IWL_DEBUG_RATE(mvm,
-		       "%s: (%s: %d) ANT: %s BW: %d SGI: %d LDPC: %d STBC %d\n",
+		       "%s: (%s: %d) ANT: %s BW: %d SGI: %d LDPC: %d STBC: %d\n",
 		       prefix, rs_pretty_lq_type(rate->type),
 		       rate->index, rs_pretty_ant(rate->ant),
 		       rate->bw, rate->sgi, rate->ldpc, rate->stbc);
@@ -1155,16 +1155,15 @@ void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		/* Rate did match, so reset the missed_rate_counter */
 		lq_sta->missed_rate_counter = 0;
 
-	/* Figure out if rate scale algorithm is in active or search table */
-	if (rs_rate_match(&rate,
-			  &(lq_sta->lq_info[lq_sta->active_tbl].rate))) {
+	if (!lq_sta->search_better_tbl) {
 		curr_tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
 		other_tbl = &(lq_sta->lq_info[1 - lq_sta->active_tbl]);
-	} else if (rs_rate_match(&rate,
-			 &lq_sta->lq_info[1 - lq_sta->active_tbl].rate)) {
+	} else {
 		curr_tbl = &(lq_sta->lq_info[1 - lq_sta->active_tbl]);
 		other_tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
-	} else {
+	}
+
+	if (WARN_ON_ONCE(!rs_rate_match(&rate, &curr_tbl->rate))) {
 		IWL_DEBUG_RATE(mvm,
 			       "Neither active nor search matches tx rate\n");
 		tmp_tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
-- 
1.9.1

