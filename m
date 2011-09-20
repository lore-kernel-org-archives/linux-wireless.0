Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:13544 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594Ab1ITXXa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 19:23:30 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 7/8] iwlagn: pending frames musn't be incremented if agg is on
Date: Tue, 20 Sep 2011 15:37:26 -0700
Message-Id: <1316558247-10018-8-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110921_012340_007237_83312AE9)
In-Reply-To: <1316558247-10018-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316558247-10018-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

During my works on the transport layer I removed code that updated
a local variable (is_agg) that is needed to keep the pending_frames
count up to date. Fix this.

Also, there should be no way to have a packet with TX_CTL_AMPDU set
while the internal aggregation state machine is not in AGG_ON state.
Add a WARN_ON to ensure that.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c     |    3 +++
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index abb702d..8c0f07f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -313,6 +313,9 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		iwl_sta_modify_sleep_tx_count(priv, sta_id, 1);
 	}
 
+	if (info->flags & IEEE80211_TX_CTL_AMPDU)
+		is_agg = true;
+
 	/* irqs already disabled/saved above when locking priv->shrd->lock */
 	spin_lock(&priv->shrd->sta_lock);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index dbb7eb3..3e69e87 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1096,8 +1096,8 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		hdr->seq_ctrl |= cpu_to_le16(seq_number);
 		seq_number += 0x10;
 		/* aggregation is on for this <sta,tid> */
-		if (info->flags & IEEE80211_TX_CTL_AMPDU &&
-		    tid_data->agg.state == IWL_AGG_ON) {
+		if (info->flags & IEEE80211_TX_CTL_AMPDU) {
+			WARN_ON(tid_data->agg.state != IWL_AGG_ON);
 			txq_id = tid_data->agg.txq_id;
 			is_agg = true;
 		}
-- 
1.7.0.4

