Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:57797 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaB0HD2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 02:03:28 -0500
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>, <stable@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/2] iwlwifi: mvm: fix TX status for aggregated packets
Date: Thu, 27 Feb 2014 09:03:19 +0200
Message-Id: <1393484599-8240-2-git-send-email-egrumbach@gmail.com> (sfid-20140227_080334_739294_5CF3BC61)
In-Reply-To: <530EE0EA.5030105@gmail.com>
References: <530EE0EA.5030105@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Only the first packet is currently handled correctly, but then
all others are assumed to have failed which is problematic. Fix
this, marking them all successful instead (since if they're not
then the firmware will have transmitted them as single frames.)

This fixes the lost packet reporting.

Also do a tiny variable scoping cleanup.

Cc: <stable@vger.kernel.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[Add the dvm part]
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/tx.c | 14 +++++++++-----
 drivers/net/wireless/iwlwifi/mvm/tx.c | 18 +++++++++---------
 2 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/tx.c b/drivers/net/wireless/iwlwifi/dvm/tx.c
index a6839df..398dd096 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@ -1291,8 +1291,6 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 	struct iwl_compressed_ba_resp *ba_resp = (void *)pkt->data;
 	struct iwl_ht_agg *agg;
 	struct sk_buff_head reclaimed_skbs;
-	struct ieee80211_tx_info *info;
-	struct ieee80211_hdr *hdr;
 	struct sk_buff *skb;
 	int sta_id;
 	int tid;
@@ -1379,22 +1377,28 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 	freed = 0;
 
 	skb_queue_walk(&reclaimed_skbs, skb) {
-		hdr = (struct ieee80211_hdr *)skb->data;
+		struct ieee80211_hdr *hdr = (void *)skb->data;
+		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
 		if (ieee80211_is_data_qos(hdr->frame_control))
 			freed++;
 		else
 			WARN_ON_ONCE(1);
 
-		info = IEEE80211_SKB_CB(skb);
 		iwl_trans_free_tx_cmd(priv->trans, info->driver_data[1]);
 
+		memset(&info->status, 0, sizeof(info->status));
+		/* Packet was transmitted successfully, failures come as single
+		 * frames because before failing a frame the firmware transmits
+		 * it without aggregation at least once.
+		 */
+		info->flags |= IEEE80211_TX_STAT_ACK;
+
 		if (freed == 1) {
 			/* this is the first skb we deliver in this batch */
 			/* put the rate scaling data there */
 			info = IEEE80211_SKB_CB(skb);
 			memset(&info->status, 0, sizeof(info->status));
-			info->flags |= IEEE80211_TX_STAT_ACK;
 			info->flags |= IEEE80211_TX_STAT_AMPDU;
 			info->status.ampdu_ack_len = ba_resp->txed_2_done;
 			info->status.ampdu_len = ba_resp->txed;
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 4df12fa..76ee486 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -822,16 +822,12 @@ int iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 	struct iwl_mvm_ba_notif *ba_notif = (void *)pkt->data;
 	struct sk_buff_head reclaimed_skbs;
 	struct iwl_mvm_tid_data *tid_data;
-	struct ieee80211_tx_info *info;
 	struct ieee80211_sta *sta;
 	struct iwl_mvm_sta *mvmsta;
-	struct ieee80211_hdr *hdr;
 	struct sk_buff *skb;
 	int sta_id, tid, freed;
-
 	/* "flow" corresponds to Tx queue */
 	u16 scd_flow = le16_to_cpu(ba_notif->scd_flow);
-
 	/* "ssn" is start of block-ack Tx window, corresponds to index
 	 * (in Tx queue's circular buffer) of first TFD/frame in window */
 	u16 ba_resp_scd_ssn = le16_to_cpu(ba_notif->scd_ssn);
@@ -888,22 +884,26 @@ int iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 	freed = 0;
 
 	skb_queue_walk(&reclaimed_skbs, skb) {
-		hdr = (struct ieee80211_hdr *)skb->data;
+		struct ieee80211_hdr *hdr = (void *)skb->data;
+		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
 		if (ieee80211_is_data_qos(hdr->frame_control))
 			freed++;
 		else
 			WARN_ON_ONCE(1);
 
-		info = IEEE80211_SKB_CB(skb);
 		iwl_trans_free_tx_cmd(mvm->trans, info->driver_data[1]);
 
+		memset(&info->status, 0, sizeof(info->status));
+		/* Packet was transmitted successfully, failures come as single
+		 * frames because before failing a frame the firmware transmits
+		 * it without aggregation at least once.
+		 */
+		info->flags |= IEEE80211_TX_STAT_ACK;
+
 		if (freed == 1) {
 			/* this is the first skb we deliver in this batch */
 			/* put the rate scaling data there */
-			info = IEEE80211_SKB_CB(skb);
-			memset(&info->status, 0, sizeof(info->status));
-			info->flags |= IEEE80211_TX_STAT_ACK;
 			info->flags |= IEEE80211_TX_STAT_AMPDU;
 			info->status.ampdu_ack_len = ba_notif->txed_2_done;
 			info->status.ampdu_len = ba_notif->txed;
-- 
1.8.3.2

