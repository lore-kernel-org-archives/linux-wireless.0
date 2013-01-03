Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48328 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab3ACOnA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 09:43:00 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/2] iwlwifi: fix the reclaimed packet tracking upon flush queue
Date: Thu,  3 Jan 2013 15:43:23 +0100
Message-Id: <1357224203-27639-2-git-send-email-johannes@sipsolutions.net> (sfid-20130103_154305_737341_D7D7BF8B)
In-Reply-To: <1357224203-27639-1-git-send-email-johannes@sipsolutions.net>
References: <1357224173.9741.18.camel@jlt4.sipsolutions.net>
 <1357224203-27639-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

There's a bug in the currently released firmware version,
the sequence control in the Tx response isn't updated in
all cases. Take it from the packet as a workaround.

Cc: stable@vger.kernel.org
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/tx.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/tx.c b/drivers/net/wireless/iwlwifi/dvm/tx.c
index da21328..a790599 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@ -1151,13 +1151,6 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 			next_reclaimed = ssn;
 		}
 
-		if (tid != IWL_TID_NON_QOS) {
-			priv->tid_data[sta_id][tid].next_reclaimed =
-				next_reclaimed;
-			IWL_DEBUG_TX_REPLY(priv, "Next reclaimed packet:%d\n",
-						  next_reclaimed);
-		}
-
 		iwl_trans_reclaim(priv->trans, txq_id, ssn, &skbs);
 
 		iwlagn_check_ratid_empty(priv, sta_id, tid);
@@ -1208,11 +1201,28 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 			if (!is_agg)
 				iwlagn_non_agg_tx_status(priv, ctx, hdr->addr1);
 
+			/*
+			 * W/A for FW bug - the seq_ctl isn't updated when the
+			 * queues are flushed. Fetch it from the packet itself
+			 */
+			if (!is_agg && status == TX_STATUS_FAIL_FIFO_FLUSHED) {
+				next_reclaimed = le16_to_cpu(hdr->seq_ctrl);
+				next_reclaimed =
+					SEQ_TO_SN(next_reclaimed + 0x10);
+			}
+
 			is_offchannel_skb =
 				(info->flags & IEEE80211_TX_CTL_TX_OFFCHAN);
 			freed++;
 		}
 
+		if (tid != IWL_TID_NON_QOS) {
+			priv->tid_data[sta_id][tid].next_reclaimed =
+				next_reclaimed;
+			IWL_DEBUG_TX_REPLY(priv, "Next reclaimed packet:%d\n",
+					   next_reclaimed);
+		}
+
 		WARN_ON(!is_agg && freed != 1);
 
 		/*
-- 
1.8.0

