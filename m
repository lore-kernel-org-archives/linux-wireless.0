Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753944Ab1LWHOc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Dec 2011 02:14:32 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 05/10] iwlegacy: 4965: small tx_cmd build cleanup
Date: Fri, 23 Dec 2011 08:13:45 +0100
Message-Id: <1324624430-3688-5-git-send-email-sgruszka@redhat.com> (sfid-20111223_081435_178825_0FD5787A)
In-Reply-To: <1324624430-3688-1-git-send-email-sgruszka@redhat.com>
References: <1324624430-3688-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Get rid of two inline functions related and simplify a bit
rts_retry_limit calculations.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c |   33 ++++++++---------------------
 drivers/net/wireless/iwlegacy/4965.h     |    6 -----
 2 files changed, 9 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index e1dfb2c..cefc623 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -819,12 +819,6 @@ il4965_get_channels_for_scan(struct il_priv *il, struct ieee80211_vif *vif,
 	return added;
 }
 
-static inline u32
-il4965_ant_idx_to_flags(u8 ant_idx)
-{
-	return BIT(ant_idx) << RATE_MCS_ANT_POS;
-}
-
 static void
 il4965_toggle_tx_ant(struct il_priv *il, u8 *ant, u8 valid)
 {
@@ -976,9 +970,8 @@ il4965_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 		rx_ant = il->cfg->scan_rx_antennas[band];
 
 	il4965_toggle_tx_ant(il, &il->scan_tx_ant[band], scan_tx_antennas);
-	rate_flags |= il4965_ant_idx_to_flags(il->scan_tx_ant[band]);
-	scan->tx_cmd.rate_n_flags =
-	    il4965_hw_set_rate_n_flags(rate, rate_flags);
+	rate_flags |= BIT(il->scan_tx_ant[band]) << RATE_MCS_ANT_POS;
+	scan->tx_cmd.rate_n_flags = cpu_to_le32(rate | rate_flags);
 
 	/* In power save mode use one chain, otherwise use all chains */
 	if (test_bit(S_POWER_PMI, &il->status)) {
@@ -1530,15 +1523,13 @@ il4965_tx_cmd_build_basic(struct il_priv *il, struct sk_buff *skb,
 	tx_cmd->next_frame_len = 0;
 }
 
-#define RTS_DFAULT_RETRY_LIMIT		60
-
 static void
 il4965_tx_cmd_build_rate(struct il_priv *il, struct il_tx_cmd *tx_cmd,
 			 struct ieee80211_tx_info *info, __le16 fc)
 {
+	const u8 rts_retry_limit = 60;
 	u32 rate_flags;
 	int rate_idx;
-	u8 rts_retry_limit;
 	u8 data_retry_limit;
 	u8 rate_plcp;
 
@@ -1548,12 +1539,8 @@ il4965_tx_cmd_build_rate(struct il_priv *il, struct il_tx_cmd *tx_cmd,
 	else
 		data_retry_limit = IL4965_DEFAULT_TX_RETRY;
 	tx_cmd->data_retry_limit = data_retry_limit;
-
 	/* Set retry limit on RTS packets */
-	rts_retry_limit = RTS_DFAULT_RETRY_LIMIT;
-	if (data_retry_limit < rts_retry_limit)
-		rts_retry_limit = data_retry_limit;
-	tx_cmd->rts_retry_limit = rts_retry_limit;
+	tx_cmd->rts_retry_limit = min(data_retry_limit, rts_retry_limit);
 
 	/* DATA packets will use the uCode station table for rate/antenna
 	 * selection */
@@ -1589,11 +1576,10 @@ il4965_tx_cmd_build_rate(struct il_priv *il, struct il_tx_cmd *tx_cmd,
 
 	/* Set up antennas */
 	il4965_toggle_tx_ant(il, &il->mgmt_tx_ant, il->hw_params.valid_tx_ant);
-	rate_flags |= il4965_ant_idx_to_flags(il->mgmt_tx_ant);
+	rate_flags |= BIT(il->mgmt_tx_ant) << RATE_MCS_ANT_POS;
 
 	/* Set the rate in the TX cmd */
-	tx_cmd->rate_n_flags =
-	    il4965_hw_set_rate_n_flags(rate_plcp, rate_flags);
+	tx_cmd->rate_n_flags = cpu_to_le32(rate_plcp | rate_flags);
 }
 
 static void
@@ -2753,7 +2739,7 @@ il4965_sta_alloc_lq(struct il_priv *il, u8 sta_id)
 	rate_flags |=
 	    il4965_first_antenna(il->hw_params.
 				 valid_tx_ant) << RATE_MCS_ANT_POS;
-	rate_n_flags = il4965_hw_set_rate_n_flags(il_rates[r].plcp, rate_flags);
+	rate_n_flags = cpu_to_le32(il_rates[r].plcp | rate_flags);
 	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++)
 		link_cmd->rs_table[i].rate_n_flags = rate_n_flags;
 
@@ -3538,11 +3524,10 @@ il4965_hw_get_beacon_cmd(struct il_priv *il, struct il_frame *frame)
 	/* Set up packet rate and flags */
 	rate = il_get_lowest_plcp(il, il->beacon_ctx);
 	il4965_toggle_tx_ant(il, &il->mgmt_tx_ant, il->hw_params.valid_tx_ant);
-	rate_flags = il4965_ant_idx_to_flags(il->mgmt_tx_ant);
+	rate_flags = BIT(il->mgmt_tx_ant) << RATE_MCS_ANT_POS;
 	if ((rate >= IL_FIRST_CCK_RATE) && (rate <= IL_LAST_CCK_RATE))
 		rate_flags |= RATE_MCS_CCK_MSK;
-	tx_beacon_cmd->tx.rate_n_flags =
-	    il4965_hw_set_rate_n_flags(rate, rate_flags);
+	tx_beacon_cmd->tx.rate_n_flags = cpu_to_le32(rate | rate_flags);
 
 	return sizeof(*tx_beacon_cmd) + frame_size;
 }
diff --git a/drivers/net/wireless/iwlegacy/4965.h b/drivers/net/wireless/iwlegacy/4965.h
index ca254aa..f280e01 100644
--- a/drivers/net/wireless/iwlegacy/4965.h
+++ b/drivers/net/wireless/iwlegacy/4965.h
@@ -167,12 +167,6 @@ il4965_hw_get_rate(__le32 rate_n_flags)
 	return le32_to_cpu(rate_n_flags) & 0xFF;
 }
 
-static inline __le32
-il4965_hw_set_rate_n_flags(u8 rate, u32 flags)
-{
-	return cpu_to_le32(flags | (u32) rate);
-}
-
 /* eeprom */
 void il4965_eeprom_get_mac(const struct il_priv *il, u8 * mac);
 int il4965_eeprom_acquire_semaphore(struct il_priv *il);
-- 
1.7.4.4

