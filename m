Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14287 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361Ab0IKQGn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Sep 2010 12:06:43 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/10] iwlwifi: fix default LQ table in 5.2 band
Date: Sat, 11 Sep 2010 09:08:29 -0700
Message-Id: <1284221318-28281-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1284221318-28281-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1284221318-28281-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

The default LQ is filled decreasingly using
iwl_get_prev_ieee_rate from a starting rate.
Since the starting rate is already the lowest one for
a specific band it should be actually filled evenly with
the starting rate: 1M and 6M for 5.2GHZ and 2.4GH respectively.
The bug is that for for A or G-only it decreases to
CCK rates which are not supported.
iwl_get_prev_ieee_rate function is just not band aware.
This affects broadcast station which lq table
is not updated by rs algorithm

G-only scenario is not treated by this patch

iwl_get_prev_ieee_rate is removed completely as it
is not used in other contexts

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h |    9 ---------
 drivers/net/wireless/iwlwifi/iwl-sta.c    |   19 ++++++++-----------
 2 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
index 3970ab1..357cdb2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
@@ -453,15 +453,6 @@ static inline u8 first_antenna(u8 mask)
 }
 
 
-static inline u8 iwl_get_prev_ieee_rate(u8 rate_index)
-{
-	u8 rate = iwl_rates[rate_index].prev_ieee;
-
-	if (rate == IWL_RATE_INVALID)
-		rate = rate_index;
-	return rate;
-}
-
 static inline u8 iwl3945_get_prev_ieee_rate(u8 rate_index)
 {
 	u8 rate = iwl3945_rates[rate_index].prev_ieee;
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index ccd0902..6edd034 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -386,7 +386,8 @@ static struct iwl_link_quality_cmd *iwl_sta_alloc_lq(struct iwl_priv *priv,
 {
 	int i, r;
 	struct iwl_link_quality_cmd *link_cmd;
-	u32 rate_flags;
+	u32 rate_flags = 0;
+	__le32 rate_n_flags;
 
 	link_cmd = kzalloc(sizeof(struct iwl_link_quality_cmd), GFP_KERNEL);
 	if (!link_cmd) {
@@ -400,18 +401,14 @@ static struct iwl_link_quality_cmd *iwl_sta_alloc_lq(struct iwl_priv *priv,
 	else
 		r = IWL_RATE_1M_INDEX;
 
-	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++) {
-		rate_flags = 0;
-		if (r >= IWL_FIRST_CCK_RATE && r <= IWL_LAST_CCK_RATE)
-			rate_flags |= RATE_MCS_CCK_MSK;
+	if (r >= IWL_FIRST_CCK_RATE && r <= IWL_LAST_CCK_RATE)
+		rate_flags |= RATE_MCS_CCK_MSK;
 
-		rate_flags |= first_antenna(priv->hw_params.valid_tx_ant) <<
+	rate_flags |= first_antenna(priv->hw_params.valid_tx_ant) <<
 				RATE_MCS_ANT_POS;
-
-		link_cmd->rs_table[i].rate_n_flags =
-			iwl_hw_set_rate_n_flags(iwl_rates[r].plcp, rate_flags);
-		r = iwl_get_prev_ieee_rate(r);
-	}
+	rate_n_flags = iwl_hw_set_rate_n_flags(iwl_rates[r].plcp, rate_flags);
+	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++)
+		link_cmd->rs_table[i].rate_n_flags = rate_n_flags;
 
 	link_cmd->general_params.single_stream_ant_msk =
 				first_antenna(priv->hw_params.valid_tx_ant);
-- 
1.7.0.4

