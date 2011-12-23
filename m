Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180Ab1LWHOV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Dec 2011 02:14:21 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 04/10] iwlegacy: 4965: toggle tx antenna inline
Date: Fri, 23 Dec 2011 08:13:44 +0100
Message-Id: <1324624430-3688-4-git-send-email-sgruszka@redhat.com> (sfid-20111223_081423_790519_777397A2)
In-Reply-To: <1324624430-3688-1-git-send-email-sgruszka@redhat.com>
References: <1324624430-3688-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make function static and change antenna number inline.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c |   41 +++++++++++++----------------
 drivers/net/wireless/iwlegacy/4965.h     |    2 -
 2 files changed, 18 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 4aaef41..e1dfb2c 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -825,6 +825,21 @@ il4965_ant_idx_to_flags(u8 ant_idx)
 	return BIT(ant_idx) << RATE_MCS_ANT_POS;
 }
 
+static void
+il4965_toggle_tx_ant(struct il_priv *il, u8 *ant, u8 valid)
+{
+	int i;
+	u8 ind = *ant;
+
+	for (i = 0; i < RATE_ANT_NUM - 1; i++) {
+		ind = (ind + 1) < RATE_ANT_NUM ? ind + 1 : 0;
+		if (valid & BIT(ind)) {
+			*ant = ind;
+			return;
+		}
+	}
+}
+
 int
 il4965_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 {
@@ -960,8 +975,7 @@ il4965_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 	if (il->cfg->scan_rx_antennas[band])
 		rx_ant = il->cfg->scan_rx_antennas[band];
 
-	il->scan_tx_ant[band] =
-	    il4965_toggle_tx_ant(il, il->scan_tx_ant[band], scan_tx_antennas);
+	il4965_toggle_tx_ant(il, &il->scan_tx_ant[band], scan_tx_antennas);
 	rate_flags |= il4965_ant_idx_to_flags(il->scan_tx_ant[band]);
 	scan->tx_cmd.rate_n_flags =
 	    il4965_hw_set_rate_n_flags(rate, rate_flags);
@@ -1171,20 +1185,6 @@ il4965_set_rxon_chain(struct il_priv *il, struct il_rxon_context *ctx)
 		active_rx_cnt < idle_rx_cnt);
 }
 
-u8
-il4965_toggle_tx_ant(struct il_priv *il, u8 ant, u8 valid)
-{
-	int i;
-	u8 ind = ant;
-
-	for (i = 0; i < RATE_ANT_NUM - 1; i++) {
-		ind = (ind + 1) < RATE_ANT_NUM ? ind + 1 : 0;
-		if (valid & BIT(ind))
-			return ind;
-	}
-	return ant;
-}
-
 static const char *
 il4965_get_fh_string(int cmd)
 {
@@ -1588,10 +1588,7 @@ il4965_tx_cmd_build_rate(struct il_priv *il, struct il_tx_cmd *tx_cmd,
 		rate_flags |= RATE_MCS_CCK_MSK;
 
 	/* Set up antennas */
-	il->mgmt_tx_ant =
-	    il4965_toggle_tx_ant(il, il->mgmt_tx_ant,
-				 il->hw_params.valid_tx_ant);
-
+	il4965_toggle_tx_ant(il, &il->mgmt_tx_ant, il->hw_params.valid_tx_ant);
 	rate_flags |= il4965_ant_idx_to_flags(il->mgmt_tx_ant);
 
 	/* Set the rate in the TX cmd */
@@ -3540,9 +3537,7 @@ il4965_hw_get_beacon_cmd(struct il_priv *il, struct il_frame *frame)
 
 	/* Set up packet rate and flags */
 	rate = il_get_lowest_plcp(il, il->beacon_ctx);
-	il->mgmt_tx_ant =
-	    il4965_toggle_tx_ant(il, il->mgmt_tx_ant,
-				 il->hw_params.valid_tx_ant);
+	il4965_toggle_tx_ant(il, &il->mgmt_tx_ant, il->hw_params.valid_tx_ant);
 	rate_flags = il4965_ant_idx_to_flags(il->mgmt_tx_ant);
 	if ((rate >= IL_FIRST_CCK_RATE) && (rate <= IL_LAST_CCK_RATE))
 		rate_flags |= RATE_MCS_CCK_MSK;
diff --git a/drivers/net/wireless/iwlegacy/4965.h b/drivers/net/wireless/iwlegacy/4965.h
index 7447231..ca254aa 100644
--- a/drivers/net/wireless/iwlegacy/4965.h
+++ b/drivers/net/wireless/iwlegacy/4965.h
@@ -107,8 +107,6 @@ void il4965_set_wr_ptrs(struct il_priv *il, int txq_id, u32 idx);
 void il4965_tx_queue_set_status(struct il_priv *il, struct il_tx_queue *txq,
 				int tx_fifo_id, int scd_retry);
 
-u8 il4965_toggle_tx_ant(struct il_priv *il, u8 ant_idx, u8 valid);
-
 /* rx */
 void il4965_hdl_missed_beacon(struct il_priv *il, struct il_rx_buf *rxb);
 bool il4965_good_plcp_health(struct il_priv *il, struct il_rx_pkt *pkt);
-- 
1.7.4.4

