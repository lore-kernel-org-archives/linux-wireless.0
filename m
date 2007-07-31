Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:45045 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566AbXGaC7L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2007 22:59:11 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 5/7] iwlwifi: Endianity fixes for 3945
Date: Tue, 31 Jul 2007 10:56:34 +0800
Message-Id: <11858506051195-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11858506033857-git-send-email-yi.zhu@intel.com>
References: <11858505963374-git-send-email-yi.zhu@intel.com>
 <118585059814-git-send-email-yi.zhu@intel.com>
 <11858505994113-git-send-email-yi.zhu@intel.com>
 <11858506013260-git-send-email-yi.zhu@intel.com>
 <11858506033857-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch fixes most of endianity issues in iwl-3945.c.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-3945.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwl-3945.c b/drivers/net/wireless/iwl-3945.c
index b71e987..6074ae0 100644
--- a/drivers/net/wireless/iwl-3945.c
+++ b/drivers/net/wireless/iwl-3945.c
@@ -295,6 +295,8 @@ static void iwl3945_rx_reply_rx(struct iwl_priv *priv,
 	struct iwl_rx_frame_end *rx_end = IWL_RX_END(pkt);
 	struct ieee80211_hdr *header;
 	u16 phy_flags = le16_to_cpu(rx_hdr->phy_flags);
+	u16 rx_stats_sig_avg = le16_to_cpu(rx_stats->sig_avg);
+	u16 rx_stats_noise_diff = le16_to_cpu(rx_stats->noise_diff);
 	struct ieee80211_rx_status stats = {
 		.mactime = le32_to_cpu(rx_end->beacon_timestamp),
 		.freq = ieee80211chan2mhz(le16_to_cpu(rx_hdr->channel)),
@@ -316,9 +318,8 @@ static void iwl3945_rx_reply_rx(struct iwl_priv *priv,
 		return;
 	}
 
-	if (!(le32_to_cpu(rx_end->status) & RX_RES_STATUS_NO_CRC32_ERROR)
-	    || !(le32_to_cpu(rx_end->status) &
-		 RX_RES_STATUS_NO_RXE_OVERFLOW)) {
+	if (!(rx_end->status & RX_RES_STATUS_NO_CRC32_ERROR)
+	    || !(rx_end->status & RX_RES_STATUS_NO_RXE_OVERFLOW)) {
 		IWL_DEBUG_RX("Bad CRC or FIFO: 0x%08X.\n", rx_end->status);
 		return;
 	}
@@ -349,8 +350,8 @@ static void iwl3945_rx_reply_rx(struct iwl_priv *priv,
 	 * Convert linear SNR to dB SNR, then subtract that from rssi dBm
 	 *   to obtain noise level in dBm.
 	 * Calculate stats.signal (quality indicator in %) based on SNR. */
-	if (rx_stats->noise_diff) {
-		snr = rx_stats->sig_avg / rx_stats->noise_diff;
+	if (rx_stats_noise_diff) {
+		snr = rx_stats_sig_avg / rx_stats_noise_diff;
 		stats.noise = stats.ssi - iwl_calc_db_from_ratio(snr);
 		stats.signal = iwl_calc_sig_qual(stats.ssi, stats.noise);
 
@@ -364,7 +365,7 @@ static void iwl3945_rx_reply_rx(struct iwl_priv *priv,
 
 	IWL_DEBUG_STATS("Rssi %d noise %d qual %d sig_avg %d noise_diff %d\n",
 			stats.ssi, stats.noise, stats.signal,
-			rx_stats->sig_avg, rx_stats->noise_diff);
+			rx_stats_sig_avg, rx_stats_noise_diff);
 
 	stats.freq = ieee80211chan2mhz(stats.channel);
 
@@ -415,7 +416,7 @@ static void iwl3945_rx_reply_rx(struct iwl_priv *priv,
 					pos =
 					    (__le32 *) & mgmt->u.beacon.
 					    timestamp;
-					priv->timestamp0 = le64_to_cpu(pos[0]);
+					priv->timestamp0 = le32_to_cpu(pos[0]);
 					priv->timestamp1 = le32_to_cpu(pos[1]);
 					priv->beacon_int = le16_to_cpu(
 					    mgmt->u.beacon.beacon_int);
@@ -597,7 +598,7 @@ void iwl_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 	int rate;
 	u8 rts_retry_limit;
 	u8 data_retry_limit;
-	u32 tx_flags;
+	__le32 tx_flags;
 	u16 fc = le16_to_cpu(hdr->frame_control);
 
 	rate = iwl_rates[rate_index].plcp;
@@ -663,7 +664,7 @@ void iwl_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 		       "cck/ofdm mask: 0x%x/0x%x\n",
 		       sta_id,
 		       cmd->cmd.tx.rate,
-		       BIT_ARG16(cmd->cmd.tx.tx_flags),
+		       BIT_ARG16(le32_to_cpu(cmd->cmd.tx.tx_flags)),
 		       cmd->cmd.tx.supp_rates[1], cmd->cmd.tx.supp_rates[0]);
 }
 
@@ -2108,7 +2109,7 @@ int iwl_hw_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 
 	struct iwl_shared *shared_data = priv->hw_setting.shared_virt;
 
-	shared_data->tx_base_ptr[txq_id] = (u32) txq->q.dma_addr;
+	shared_data->tx_base_ptr[txq_id] = cpu_to_le32((u32)txq->q.dma_addr);
 
 	spin_lock_irqsave(&priv->lock, flags);
 	rc = iwl_grab_restricted_access(priv);
@@ -2140,7 +2141,7 @@ int iwl_hw_get_rx_read(struct iwl_priv *priv)
 	struct iwl_shared *shared_data =
 	    (struct iwl_shared *)priv->hw_setting.shared_virt;
 
-	return shared_data->rx_read_ptr[0];
+	return le32_to_cpu(shared_data->rx_read_ptr[0]);
 }
 
 /**
-- 
1.5.2
