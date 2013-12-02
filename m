Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:53717 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab3LBU7q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 15:59:46 -0500
Received: by mail-we0-f177.google.com with SMTP id p61so12484509wes.36
        for <linux-wireless@vger.kernel.org>; Mon, 02 Dec 2013 12:59:45 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/13] iwlwifi: mvm: rs: update expected TPT tables if aggregation changed
Date: Mon,  2 Dec 2013 22:59:15 +0200
Message-Id: <1386017965-13641-3-git-send-email-egrumbach@gmail.com> (sfid-20131202_220023_042469_AF43AA83)
In-Reply-To: <529CF2D6.1080008@gmail.com>
References: <529CF2D6.1080008@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Expected TPT table was updated only when switching to a new
modulation. This is wrong as toggling aggregation changes
the expected TPT signficantly.
This leads to scenarios where turning aggregation on after
being in MIMO sends us back to SISO despite a perfect success
ratio.
This occurred because the TPT of the SISO mode was being
estimated based on aggregation while the MIMO one wasn't.

Also remove an error print which isn't an error anymore
since we might be updating the expected TPT table due
to aggregation changes.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index ecf24cb..882ecd3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -1717,6 +1717,7 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 	u16 high_low;
 	s32 sr;
 	u8 tid = IWL_MAX_TID_COUNT;
+	u8 prev_agg = lq_sta->is_agg;
 	struct iwl_mvm_sta *sta_priv = (void *)sta->drv_priv;
 	struct iwl_mvm_tid_data *tid_data;
 
@@ -1752,6 +1753,13 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 
 	tbl = &(lq_sta->lq_info[active_tbl]);
 
+	if (prev_agg != lq_sta->is_agg) {
+		IWL_DEBUG_RATE(mvm,
+			       "Aggregation changed: prev %d current %d. Update expected TPT table\n",
+			       prev_agg, lq_sta->is_agg);
+		rs_set_expected_tpt_table(lq_sta, tbl);
+	}
+
 	/* current tx rate */
 	index = lq_sta->last_txrate_idx;
 
@@ -1837,8 +1845,6 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 	 * actual average throughput */
 	if (window->average_tpt != ((window->success_ratio *
 			tbl->expected_tpt[index] + 64) / 128)) {
-		IWL_ERR(mvm,
-			"expected_tpt should have been calculated by now\n");
 		window->average_tpt = ((window->success_ratio *
 					tbl->expected_tpt[index] + 64) / 128);
 	}
-- 
1.7.9.5

