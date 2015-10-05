Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:57193 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752472AbbJEPBm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 11:01:42 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Oct 2015 17:36:49 +0300
Message-Id: <1444055820-27506-18-git-send-email-luca@coelho.fi> (sfid-20151005_170146_878315_1C67EAF5)
In-Reply-To: <1444050759.27220.15.camel@coelho.fi>
References: <1444050759.27220.15.camel@coelho.fi>
Subject: [PATCH 18/29] iwlwifi: mvm: rs: improve rate debug messages
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Pretty print the rate full details to ease debugging.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 60 +++++++++++++++++++++++++++++------
 1 file changed, 51 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 5ae9c8a..98f4d78 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -524,14 +524,56 @@ static const char *rs_pretty_lq_type(enum iwl_table_type type)
 	return lq_types[type];
 }
 
+static char *rs_pretty_rate(const struct rs_rate *rate)
+{
+	static char buf[40];
+	static const char * const legacy_rates[] = {
+		[IWL_RATE_1M_INDEX] = "1M",
+		[IWL_RATE_2M_INDEX] = "2M",
+		[IWL_RATE_5M_INDEX] = "5.5M",
+		[IWL_RATE_11M_INDEX] = "11M",
+		[IWL_RATE_6M_INDEX] = "6M",
+		[IWL_RATE_9M_INDEX] = "9M",
+		[IWL_RATE_12M_INDEX] = "12M",
+		[IWL_RATE_18M_INDEX] = "18M",
+		[IWL_RATE_24M_INDEX] = "24M",
+		[IWL_RATE_36M_INDEX] = "36M",
+		[IWL_RATE_48M_INDEX] = "48M",
+		[IWL_RATE_54M_INDEX] = "54M",
+	};
+	static const char *const ht_vht_rates[] = {
+		[IWL_RATE_MCS_0_INDEX] = "MCS0",
+		[IWL_RATE_MCS_1_INDEX] = "MCS1",
+		[IWL_RATE_MCS_2_INDEX] = "MCS2",
+		[IWL_RATE_MCS_3_INDEX] = "MCS3",
+		[IWL_RATE_MCS_4_INDEX] = "MCS4",
+		[IWL_RATE_MCS_5_INDEX] = "MCS5",
+		[IWL_RATE_MCS_6_INDEX] = "MCS6",
+		[IWL_RATE_MCS_7_INDEX] = "MCS7",
+		[IWL_RATE_MCS_8_INDEX] = "MCS8",
+		[IWL_RATE_MCS_9_INDEX] = "MCS9",
+	};
+	const char *rate_str;
+
+	if (is_type_legacy(rate->type))
+		rate_str = legacy_rates[rate->index];
+	else if (is_type_ht(rate->type) || is_type_vht(rate->type))
+		rate_str = ht_vht_rates[rate->index];
+	else
+		rate_str = "BAD_RATE";
+
+	sprintf(buf, "(%s|%s|%s)", rs_pretty_lq_type(rate->type),
+		rs_pretty_ant(rate->ant), rate_str);
+	return buf;
+}
+
 static inline void rs_dump_rate(struct iwl_mvm *mvm, const struct rs_rate *rate,
 				const char *prefix)
 {
 	IWL_DEBUG_RATE(mvm,
-		       "%s: (%s: %d) ANT: %s BW: %d SGI: %d LDPC: %d STBC: %d\n",
-		       prefix, rs_pretty_lq_type(rate->type),
-		       rate->index, rs_pretty_ant(rate->ant),
-		       rate->bw, rate->sgi, rate->ldpc, rate->stbc);
+		       "%s: %s BW: %d SGI: %d LDPC: %d STBC: %d\n",
+		       prefix, rs_pretty_rate(rate), rate->bw,
+		       rate->sgi, rate->ldpc, rate->stbc);
 }
 
 static void rs_rate_scale_clear_window(struct iwl_rate_scale_data *window)
@@ -2174,9 +2216,9 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 	if ((fail_count < IWL_MVM_RS_RATE_MIN_FAILURE_TH) &&
 	    (window->success_counter < IWL_MVM_RS_RATE_MIN_SUCCESS_TH)) {
 		IWL_DEBUG_RATE(mvm,
-			       "(%s: %d): Test Window: succ %d total %d\n",
-			       rs_pretty_lq_type(rate->type),
-			       index, window->success_counter, window->counter);
+			       "%s: Test Window: succ %d total %d\n",
+			       rs_pretty_rate(rate),
+			       window->success_counter, window->counter);
 
 		/* Can't calculate this yet; not enough history */
 		window->average_tpt = IWL_INVALID_VALUE;
@@ -2253,8 +2295,8 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 		high_tpt = tbl->win[high].average_tpt;
 
 	IWL_DEBUG_RATE(mvm,
-		       "(%s: %d): cur_tpt %d SR %d low %d high %d low_tpt %d high_tpt %d\n",
-		       rs_pretty_lq_type(rate->type), index, current_tpt, sr,
+		       "%s: cur_tpt %d SR %d low %d high %d low_tpt %d high_tpt %d\n",
+		       rs_pretty_rate(rate), current_tpt, sr,
 		       low, high, low_tpt, high_tpt);
 
 	scale_action = rs_get_rate_action(mvm, tbl, sr, low, high,
-- 
2.5.3

