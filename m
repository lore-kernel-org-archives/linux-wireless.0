Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:65144 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709AbaDMNDC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 09:03:02 -0400
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>, <stable@vger.kernel.org>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/13] iwlwifi: mvm: rs: fallback to legacy Tx columns
Date: Sun, 13 Apr 2014 16:02:00 +0300
Message-Id: <1397394123-25102-10-git-send-email-egrumbach@gmail.com> (sfid-20140413_150353_119432_B0F8E239)
In-Reply-To: <1397394123-25102-1-git-send-email-egrumbach@gmail.com>
References: <534A8A49.2030100@gmail.com>
 <1397394123-25102-1-git-send-email-egrumbach@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Allow switching back to legacy Tx columns so we'll stop doing
HT/VHT in case we're far from the AP. Stop active aggregation when
making a deciding to stay in a legacy column.
Despite having low legacy rates in the LQ table lower entries
it doesn't help much in case we're doing aggregations as the
aggregation was being transmitted in the initial rate of the table.

This should help traffic stalls when far from the AP.

Cc: <stable@vger.kernel.org> [3.14]
Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 0d03dcd..b007db9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -142,7 +142,7 @@ enum rs_column_mode {
 	RS_MIMO2,
 };
 
-#define MAX_NEXT_COLUMNS 5
+#define MAX_NEXT_COLUMNS 7
 #define MAX_COLUMN_CHECKS 3
 
 typedef bool (*allow_column_func_t) (struct iwl_mvm *mvm,
@@ -214,6 +214,8 @@ static const struct rs_tx_column rs_tx_columns[] = {
 			RS_COLUMN_SISO_ANT_B,
 			RS_COLUMN_MIMO2,
 			RS_COLUMN_MIMO2_SGI,
+			RS_COLUMN_INVALID,
+			RS_COLUMN_INVALID,
 		},
 	},
 	[RS_COLUMN_LEGACY_ANT_B] = {
@@ -225,6 +227,8 @@ static const struct rs_tx_column rs_tx_columns[] = {
 			RS_COLUMN_SISO_ANT_B,
 			RS_COLUMN_MIMO2,
 			RS_COLUMN_MIMO2_SGI,
+			RS_COLUMN_INVALID,
+			RS_COLUMN_INVALID,
 		},
 	},
 	[RS_COLUMN_SISO_ANT_A] = {
@@ -236,6 +240,8 @@ static const struct rs_tx_column rs_tx_columns[] = {
 			RS_COLUMN_SISO_ANT_A_SGI,
 			RS_COLUMN_SISO_ANT_B_SGI,
 			RS_COLUMN_MIMO2_SGI,
+			RS_COLUMN_LEGACY_ANT_A,
+			RS_COLUMN_LEGACY_ANT_B,
 		},
 		.checks = {
 			rs_siso_allow,
@@ -250,6 +256,8 @@ static const struct rs_tx_column rs_tx_columns[] = {
 			RS_COLUMN_SISO_ANT_B_SGI,
 			RS_COLUMN_SISO_ANT_A_SGI,
 			RS_COLUMN_MIMO2_SGI,
+			RS_COLUMN_LEGACY_ANT_A,
+			RS_COLUMN_LEGACY_ANT_B,
 		},
 		.checks = {
 			rs_siso_allow,
@@ -265,6 +273,8 @@ static const struct rs_tx_column rs_tx_columns[] = {
 			RS_COLUMN_SISO_ANT_A,
 			RS_COLUMN_SISO_ANT_B,
 			RS_COLUMN_MIMO2,
+			RS_COLUMN_LEGACY_ANT_A,
+			RS_COLUMN_LEGACY_ANT_B,
 		},
 		.checks = {
 			rs_siso_allow,
@@ -281,6 +291,8 @@ static const struct rs_tx_column rs_tx_columns[] = {
 			RS_COLUMN_SISO_ANT_B,
 			RS_COLUMN_SISO_ANT_A,
 			RS_COLUMN_MIMO2,
+			RS_COLUMN_LEGACY_ANT_A,
+			RS_COLUMN_LEGACY_ANT_B,
 		},
 		.checks = {
 			rs_siso_allow,
@@ -296,6 +308,8 @@ static const struct rs_tx_column rs_tx_columns[] = {
 			RS_COLUMN_SISO_ANT_A_SGI,
 			RS_COLUMN_SISO_ANT_B_SGI,
 			RS_COLUMN_MIMO2_SGI,
+			RS_COLUMN_LEGACY_ANT_A,
+			RS_COLUMN_LEGACY_ANT_B,
 		},
 		.checks = {
 			rs_mimo_allow,
@@ -311,6 +325,8 @@ static const struct rs_tx_column rs_tx_columns[] = {
 			RS_COLUMN_SISO_ANT_A,
 			RS_COLUMN_SISO_ANT_B,
 			RS_COLUMN_MIMO2,
+			RS_COLUMN_LEGACY_ANT_A,
+			RS_COLUMN_LEGACY_ANT_B,
 		},
 		.checks = {
 			rs_mimo_allow,
@@ -2070,8 +2086,18 @@ lq_update:
 		 * stay with best antenna legacy modulation for a while
 		 * before next round of mode comparisons. */
 		tbl1 = &(lq_sta->lq_info[lq_sta->active_tbl]);
-		if (is_legacy(&tbl1->rate) && !sta->ht_cap.ht_supported) {
+		if (is_legacy(&tbl1->rate)) {
 			IWL_DEBUG_RATE(mvm, "LQ: STAY in legacy table\n");
+
+			if (tid != IWL_MAX_TID_COUNT) {
+				tid_data = &sta_priv->tid_data[tid];
+				if (tid_data->state != IWL_AGG_OFF) {
+					IWL_DEBUG_RATE(mvm,
+						       "Stop aggregation on tid %d\n",
+						       tid);
+					ieee80211_stop_tx_ba_session(sta, tid);
+				}
+			}
 			rs_set_stay_in_table(mvm, 1, lq_sta);
 		} else {
 		/* If we're in an HT mode, and all 3 mode switch actions
-- 
1.8.3.2

