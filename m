Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24060 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbbCATby (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 14:31:54 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/31] iwlwifi: mvm: rs: adapt rate matching to new STBC/BFER
Date: Sun,  1 Mar 2015 21:31:16 +0200
Message-Id: <1425238304-498-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_203157_973128_A1B0CC98)
In-Reply-To: <1425238186.30202.5.camel@egrumbacBox>
References: <1425238186.30202.5.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Once the FW supports autonomous decision between STBC/BFER/SISO
we no longer set the STBC bit and ANT_AB in the rate table.
However the FW rate in the tx response will have the STBC
or BFER bit set and the antennas set to ANT_AB in case these
were chosen by it. This will cause us to discard any such
response as unmatching the current LQ table and thus break
the rs search cycle completely.
Fix this by relaxing the rate matching in case we're working
with the new API and STBC/BFER are used.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 45 ++++++++++++++++++++++++++++-------
 drivers/net/wireless/iwlwifi/mvm/rs.h |  1 +
 2 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 2e45b81..37002cf 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -807,6 +807,8 @@ static int rs_rate_from_ucode_rate(const u32 ucode_rate,
 		rate->ldpc = true;
 	if (ucode_rate & RATE_MCS_VHT_STBC_MSK)
 		rate->stbc = true;
+	if (ucode_rate & RATE_MCS_BF_MSK)
+		rate->bfer = true;
 
 	rate->bw = ucode_rate & RATE_MCS_CHAN_WIDTH_MSK;
 
@@ -816,7 +818,9 @@ static int rs_rate_from_ucode_rate(const u32 ucode_rate,
 
 		if (nss == 1) {
 			rate->type = LQ_HT_SISO;
-			WARN_ON_ONCE(!rate->stbc && num_of_ant != 1);
+			WARN_ONCE(!rate->stbc && !rate->bfer && num_of_ant != 1,
+				  "stbc %d bfer %d",
+				  rate->stbc, rate->bfer);
 		} else if (nss == 2) {
 			rate->type = LQ_HT_MIMO2;
 			WARN_ON_ONCE(num_of_ant != 2);
@@ -829,7 +833,9 @@ static int rs_rate_from_ucode_rate(const u32 ucode_rate,
 
 		if (nss == 1) {
 			rate->type = LQ_VHT_SISO;
-			WARN_ON_ONCE(!rate->stbc && num_of_ant != 1);
+			WARN_ONCE(!rate->stbc && !rate->bfer && num_of_ant != 1,
+				  "stbc %d bfer %d",
+				  rate->stbc, rate->bfer);
 		} else if (nss == 2) {
 			rate->type = LQ_VHT_MIMO2;
 			WARN_ON_ONCE(num_of_ant != 2);
@@ -1008,13 +1014,32 @@ static void rs_get_lower_rate_down_column(struct iwl_lq_sta *lq_sta,
 		rs_get_lower_rate_in_column(lq_sta, rate);
 }
 
-/* Check if both rates are identical */
+/* Check if both rates are identical
+ * allow_ant_mismatch enables matching a SISO rate on ANT_A or ANT_B
+ * with a rate indicating STBC/BFER and ANT_AB.
+ */
 static inline bool rs_rate_equal(struct rs_rate *a,
-				 struct rs_rate *b)
-{
+				 struct rs_rate *b,
+				 bool allow_ant_mismatch)
+
+{
+	bool ant_match = (a->ant == b->ant) && (a->stbc == b->stbc) &&
+		(a->bfer == b->bfer);
+
+	if (allow_ant_mismatch) {
+		if (a->stbc || a->bfer) {
+			WARN_ONCE(a->ant != ANT_AB, "stbc %d bfer %d ant %d",
+				  a->stbc, a->bfer, a->ant);
+			ant_match |= (b->ant == ANT_A || b->ant == ANT_B);
+		} else if (b->stbc || b->bfer) {
+			WARN_ONCE(b->ant != ANT_AB, "stbc %d bfer %d ant %d",
+				  b->stbc, b->bfer, b->ant);
+			ant_match |= (a->ant == ANT_A || a->ant == ANT_B);
+		}
+	}
+
 	return (a->type == b->type) && (a->bw == b->bw) && (a->sgi == b->sgi) &&
-		(a->ldpc == b->ldpc) && (a->index == b->index) &&
-		(a->ant == b->ant);
+		(a->ldpc == b->ldpc) && (a->index == b->index) && ant_match;
 }
 
 /* Check if both rates share the same column */
@@ -1023,7 +1048,7 @@ static inline bool rs_rate_column_match(struct rs_rate *a,
 {
 	bool ant_match;
 
-	if (a->stbc)
+	if (a->stbc || a->bfer)
 		ant_match = (b->ant == ANT_A || b->ant == ANT_B);
 	else
 		ant_match = (a->ant == b->ant);
@@ -1061,6 +1086,8 @@ void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	u32 tx_resp_hwrate = (uintptr_t)info->status.status_driver_data[1];
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_lq_sta *lq_sta = &mvmsta->lq_sta;
+	bool allow_ant_mismatch = mvm->fw->ucode_capa.api[0] &
+		IWL_UCODE_TLV_API_LQ_SS_PARAMS;
 
 	/* Treat uninitialized rate scaling data same as non-existing. */
 	if (!lq_sta) {
@@ -1110,7 +1137,7 @@ void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	rs_rate_from_ucode_rate(tx_resp_hwrate, info->band, &tx_resp_rate);
 
 	/* Here we actually compare this rate to the latest LQ command */
-	if (!rs_rate_equal(&tx_resp_rate, &lq_rate)) {
+	if (!rs_rate_equal(&tx_resp_rate, &lq_rate, allow_ant_mismatch)) {
 		IWL_DEBUG_RATE(mvm,
 			       "initial tx resp rate 0x%x does not match 0x%x\n",
 			       tx_resp_hwrate, lq_hwrate);
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.h b/drivers/net/wireless/iwlwifi/mvm/rs.h
index dc4ef3d..4cb278f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.h
@@ -170,6 +170,7 @@ struct rs_rate {
 	bool sgi;
 	bool ldpc;
 	bool stbc;
+	bool bfer;
 };
 
 
-- 
1.9.1

