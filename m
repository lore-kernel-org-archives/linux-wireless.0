Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42222 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab2LJVtA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 16:49:00 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 07/10] iwlwifi: change TX code to suppress smatch warning
Date: Mon, 10 Dec 2012 22:49:15 +0100
Message-Id: <1355176158-24675-7-git-send-email-johannes@sipsolutions.net> (sfid-20121210_224913_762716_CA645168)
In-Reply-To: <1355176158-24675-1-git-send-email-johannes@sipsolutions.net>
References: <1355176087.8083.17.camel@jlt4.sipsolutions.net>
 <1355176158-24675-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

By using a few temporary variables, smatch can track
what's happening and stops complaining that we access
beyond the tid_data array.

This also makes the generated code a bit smaller, so
it's a win all around.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/tx.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/tx.c b/drivers/net/wireless/iwlwifi/dvm/tx.c
index 7d6cc5d..517562b 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@ -305,7 +305,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv,
 	u8 hdr_len;
 	u16 len, seq_number = 0;
 	u8 sta_id, tid = IWL_MAX_TID_COUNT;
-	bool is_agg = false;
+	bool is_agg = false, is_data_qos = false;
 	int txq_id;
 
 	if (info->control.vif)
@@ -378,9 +378,6 @@ int iwlagn_tx_skb(struct iwl_priv *priv,
 		iwl_sta_modify_sleep_tx_count(priv, sta_id, 1);
 	}
 
-	if (info->flags & IEEE80211_TX_CTL_AMPDU)
-		is_agg = true;
-
 	dev_cmd = iwl_trans_alloc_tx_cmd(priv->trans);
 
 	if (unlikely(!dev_cmd))
@@ -442,6 +439,10 @@ int iwlagn_tx_skb(struct iwl_priv *priv,
 		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
 		hdr->seq_ctrl |= cpu_to_le16(seq_number);
 		seq_number += 0x10;
+
+		if (info->flags & IEEE80211_TX_CTL_AMPDU)
+			is_agg = true;
+		is_data_qos = true;
 	}
 
 	/* Copy MAC header from skb into command buffer */
@@ -474,8 +475,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv,
 	if (iwl_trans_tx(priv->trans, skb, dev_cmd, txq_id))
 		goto drop_unlock_sta;
 
-	if (ieee80211_is_data_qos(fc) && !ieee80211_is_qos_nullfunc(fc) &&
-	    !ieee80211_has_morefrags(fc))
+	if (is_data_qos && !ieee80211_has_morefrags(fc))
 		priv->tid_data[sta_id][tid].seq_number = seq_number;
 
 	spin_unlock(&priv->sta_lock);
-- 
1.8.0

