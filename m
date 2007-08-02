Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:18761 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613AbXHBCSq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2007 22:18:46 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 1/4] iwlwifi: Endianity fix for iwl4965_handle_data_packet function
Date: Thu,  2 Aug 2007 10:16:02 +0800
Message-Id: <11860209683483-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1186020965807-git-send-email-yi.zhu@intel.com>
References: <1186020965807-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch fixes endianity issue in iwl4965_handle_data_packet
function.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-4965.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwl-4965.c b/drivers/net/wireless/iwl-4965.c
index 1b90838..f501f82 100644
--- a/drivers/net/wireless/iwl-4965.c
+++ b/drivers/net/wireless/iwl-4965.c
@@ -3588,10 +3588,10 @@ static void iwl4965_handle_data_packet(struct iwl_priv *priv, int is_data,
 	struct iwl4965_rx_phy_res *rx_start = (include_phy) ?
 	    (struct iwl4965_rx_phy_res *)&(pkt->u.raw[0]) : NULL;
 	struct ieee80211_hdr *hdr;
-	unsigned int len;
-	u32 *rx_end;
+	u16 len;
+	__le32 *rx_end;
 	unsigned int skblen;
-	u32 ampd_status;
+	u32 ampdu_status;
 
 	if (!include_phy && priv->last_phy_res[0])
 		rx_start = (struct iwl4965_rx_phy_res *)&priv->last_phy_res[1];
@@ -3604,9 +3604,9 @@ static void iwl4965_handle_data_packet(struct iwl_priv *priv, int is_data,
 		hdr = (struct ieee80211_hdr *)((u8 *) & rx_start[1] +
 					       rx_start->cfg_phy_cnt);
 
-		len = rx_start->byte_count;
+		len = le16_to_cpu(rx_start->byte_count);
 
-		rx_end = (u32 *) ((u8 *) & pkt->u.raw[0] +
+		rx_end = (__le32 *) ((u8 *) & pkt->u.raw[0] +
 				  sizeof(struct iwl4965_rx_phy_res) +
 				  rx_start->cfg_phy_cnt + len);
 
@@ -3614,20 +3614,19 @@ static void iwl4965_handle_data_packet(struct iwl_priv *priv, int is_data,
 		struct iwl4965_rx_mpdu_res_start *amsdu =
 		    (struct iwl4965_rx_mpdu_res_start *)pkt->u.raw;
 
-		hdr = (void *)(pkt->u.raw +
+		hdr = (struct ieee80211_hdr *)(pkt->u.raw +
 			       sizeof(struct iwl4965_rx_mpdu_res_start));
-		len = amsdu->byte_count;
-		rx_end = (u32 *) (((u8 *) hdr) + len);
-		rx_start->byte_count = len;
+		len =  le16_to_cpu(amsdu->byte_count);
+		rx_start->byte_count = amsdu->byte_count;
+		rx_end = (__le32 *) (((u8 *) hdr) + len);
 	}
 	if (len > 2342 || len < 16) {
 		IWL_DEBUG_DROP("byte count out of range [16,2342]"
 			       " : %d\n", len);
 		return;
-
 	}
 
-	ampd_status = *rx_end;
+	ampdu_status = le32_to_cpu(*rx_end);
 	skblen = ((u8 *) rx_end - (u8 *) & pkt->u.raw[0]) + sizeof(u32);
 
 	/* start from MAC */
@@ -3644,7 +3643,7 @@ static void iwl4965_handle_data_packet(struct iwl_priv *priv, int is_data,
 	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR) {
 		if (iwl_param_hwcrypto)
 			iwl_set_decrypted_flag(priv, rxb->skb,
-					       ampd_status, stats);
+					       ampdu_status, stats);
 		iwl_handle_data_packet_monitor(priv, rxb, hdr, len, stats, 0);
 		return;
 	}
@@ -3653,7 +3652,7 @@ static void iwl4965_handle_data_packet(struct iwl_priv *priv, int is_data,
 	hdr = (struct ieee80211_hdr *)rxb->skb->data;
 
 	if (iwl_param_hwcrypto)
-		iwl_set_decrypted_flag(priv, rxb->skb, ampd_status, stats);
+		iwl_set_decrypted_flag(priv, rxb->skb, ampdu_status, stats);
 
 	ieee80211_rx_irqsafe(priv->hw, rxb->skb, stats);
 	priv->alloc_rxb_skb--;
-- 
1.5.2
