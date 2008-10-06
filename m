Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:41454 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbYJFIME (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 04:12:04 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 5/7] iwlwifi: take a valid antenna upon rate scale init
Date: Mon,  6 Oct 2008 16:05:31 +0800
Message-Id: <1223280333-4383-6-git-send-email-yi.zhu@intel.com> (sfid-20081006_101210_244127_95B58958)
In-Reply-To: <1223280333-4383-5-git-send-email-yi.zhu@intel.com>
References: <1223280333-4383-1-git-send-email-yi.zhu@intel.com>
 <1223280333-4383-2-git-send-email-yi.zhu@intel.com>
 <1223280333-4383-3-git-send-email-yi.zhu@intel.com>
 <1223280333-4383-4-git-send-email-yi.zhu@intel.com>
 <1223280333-4383-5-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch selects a valid antenna upon RS init. This solves a SYSASSERT
complaining that the driver is setting a non valid antenna in the LQ CMD.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c   |    6 +++++-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h |   10 ++++++++++
 drivers/net/wireless/iwlwifi/iwl-sta.c    |    8 +++++---
 3 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index c1300fb..56a3f0c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -811,10 +811,14 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 
 	switch (priv->hw_rev & CSR_HW_REV_TYPE_MSK) {
 	case CSR_HW_REV_TYPE_5100:
+		priv->hw_params.tx_chains_num = 1;
+		priv->hw_params.rx_chains_num = 2;
+		priv->hw_params.valid_tx_ant = ANT_B;
+		priv->hw_params.valid_rx_ant = ANT_AB;
+		break;
 	case CSR_HW_REV_TYPE_5150:
 		priv->hw_params.tx_chains_num = 1;
 		priv->hw_params.rx_chains_num = 2;
-		/* FIXME: move to ANT_A, ANT_B, ANT_C enum */
 		priv->hw_params.valid_tx_ant = ANT_A;
 		priv->hw_params.valid_rx_ant = ANT_AB;
 		break;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
index d148d73..bac91f1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
@@ -284,6 +284,16 @@ static inline u8 num_of_ant(u8 mask)
 		!!((mask) & ANT_C);
 }
 
+static inline u8 first_antenna(u8 mask)
+{
+	if (mask & ANT_A)
+		return ANT_A;
+	if (mask & ANT_B)
+		return ANT_B;
+	return ANT_C;
+}
+
+
 static inline u8 iwl4965_get_prev_ieee_rate(u8 rate_index)
 {
 	u8 rate = iwl_rates[rate_index].prev_ieee;
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 61797f3..f9efc0c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -852,7 +852,7 @@ static void iwl_sta_init_lq(struct iwl_priv *priv, const u8 *addr, int is_ap)
 	struct iwl_link_quality_cmd link_cmd = {
 		.reserved1 = 0,
 	};
-	u16 rate_flags;
+	u32 rate_flags;
 
 	/* Set up the rate scaling to start at selected rate, fall back
 	 * all the way down to 1M in IEEE order, and then spin on 1M */
@@ -869,14 +869,16 @@ static void iwl_sta_init_lq(struct iwl_priv *priv, const u8 *addr, int is_ap)
 			rate_flags |= RATE_MCS_CCK_MSK;
 
 		/* Use Tx antenna B only */
-		rate_flags |= RATE_MCS_ANT_B_MSK; /*FIXME:RS*/
+		rate_flags |= first_antenna(priv->hw_params.valid_tx_ant) <<
+				RATE_MCS_ANT_POS;
 
 		link_cmd.rs_table[i].rate_n_flags =
 			iwl_hw_set_rate_n_flags(iwl_rates[r].plcp, rate_flags);
 		r = iwl4965_get_prev_ieee_rate(r);
 	}
 
-	link_cmd.general_params.single_stream_ant_msk = 2;
+	link_cmd.general_params.single_stream_ant_msk =
+				first_antenna(priv->hw_params.valid_tx_ant);
 	link_cmd.general_params.dual_stream_ant_msk = 3;
 	link_cmd.agg_params.agg_dis_start_th = 3;
 	link_cmd.agg_params.agg_time_limit = cpu_to_le16(4000);
-- 
1.5.3.6

