Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:33609 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185Ab0HRQSf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 12:18:35 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/16] iwlagn: adjust starting action for rate scale
Date: Wed, 18 Aug 2010 09:22:44 -0700
Message-Id: <1282148571-9258-10-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282148571-9258-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282148571-9258-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During rate scale, reset starting action after making action adjustment
to avoid the possibility of break out of loop too early.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 7c4deee..4d5738d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -1265,7 +1265,7 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 	struct iwl_rate_scale_data *window = &(tbl->win[index]);
 	u32 sz = (sizeof(struct iwl_scale_tbl_info) -
 		  (sizeof(struct iwl_rate_scale_data) * IWL_RATE_COUNT));
-	u8 start_action = tbl->action;
+	u8 start_action;
 	u8 valid_tx_ant = priv->hw_params.valid_tx_ant;
 	u8 tx_chains_num = priv->hw_params.tx_chains_num;
 	int ret = 0;
@@ -1277,6 +1277,7 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 	else if (iwl_tx_ant_restriction(priv) == IWL_ANT_OK_SINGLE &&
 		   tbl->action > IWL_LEGACY_SWITCH_SISO)
 		tbl->action = IWL_LEGACY_SWITCH_SISO;
+	start_action = tbl->action;
 	for (; ;) {
 		lq_sta->action_counter++;
 		switch (tbl->action) {
@@ -1403,7 +1404,7 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 	struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
 	u32 sz = (sizeof(struct iwl_scale_tbl_info) -
 		  (sizeof(struct iwl_rate_scale_data) * IWL_RATE_COUNT));
-	u8 start_action = tbl->action;
+	u8 start_action;
 	u8 valid_tx_ant = priv->hw_params.valid_tx_ant;
 	u8 tx_chains_num = priv->hw_params.tx_chains_num;
 	u8 update_search_tbl_counter = 0;
@@ -1414,6 +1415,7 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 		/* stay in SISO */
 		tbl->action = IWL_SISO_SWITCH_ANTENNA1;
 	}
+	start_action = tbl->action;
 	for (;;) {
 		lq_sta->action_counter++;
 		switch (tbl->action) {
@@ -1541,7 +1543,7 @@ static int rs_move_mimo2_to_other(struct iwl_priv *priv,
 	struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
 	u32 sz = (sizeof(struct iwl_scale_tbl_info) -
 		  (sizeof(struct iwl_rate_scale_data) * IWL_RATE_COUNT));
-	u8 start_action = tbl->action;
+	u8 start_action;
 	u8 valid_tx_ant = priv->hw_params.valid_tx_ant;
 	u8 tx_chains_num = priv->hw_params.tx_chains_num;
 	u8 update_search_tbl_counter = 0;
@@ -1553,6 +1555,7 @@ static int rs_move_mimo2_to_other(struct iwl_priv *priv,
 		/* switch in SISO */
 		tbl->action = IWL_MIMO2_SWITCH_SISO_A;
 	}
+	start_action = tbl->action;
 	for (;;) {
 		lq_sta->action_counter++;
 		switch (tbl->action) {
@@ -1682,7 +1685,7 @@ static int rs_move_mimo3_to_other(struct iwl_priv *priv,
 	struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
 	u32 sz = (sizeof(struct iwl_scale_tbl_info) -
 		  (sizeof(struct iwl_rate_scale_data) * IWL_RATE_COUNT));
-	u8 start_action = tbl->action;
+	u8 start_action;
 	u8 valid_tx_ant = priv->hw_params.valid_tx_ant;
 	u8 tx_chains_num = priv->hw_params.tx_chains_num;
 	int ret;
@@ -1694,6 +1697,7 @@ static int rs_move_mimo3_to_other(struct iwl_priv *priv,
 		/* switch in SISO */
 		tbl->action = IWL_MIMO3_SWITCH_SISO_A;
 	}
+	start_action = tbl->action;
 	for (;;) {
 		lq_sta->action_counter++;
 		switch (tbl->action) {
-- 
1.7.0.4

