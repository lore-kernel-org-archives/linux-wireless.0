Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54747 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848Ab2KIUHj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 15:07:39 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 04/13] iwlwifi: don't clear CTL_AMPDU on frame status
Date: Fri,  9 Nov 2012 21:08:03 +0100
Message-Id: <1352491692-28994-5-git-send-email-johannes@sipsolutions.net> (sfid-20121109_210752_832259_A5DAF705)
In-Reply-To: <1352491692-28994-1-git-send-email-johannes@sipsolutions.net>
References: <1352491692-28994-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no reason to clear the CTL_AMPDU flag on
transmitted frame status, it's not used by the
driver here and mac80211 only uses it for some
rate statistics.

Also remove a stray space in the function.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/tx.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/tx.c b/drivers/net/wireless/iwlwifi/dvm/tx.c
index f5ca73a..4ae031f 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@ -1075,14 +1075,11 @@ static void iwlagn_count_tx_err_status(struct iwl_priv *priv, u16 status)
 
 static void iwlagn_set_tx_status(struct iwl_priv *priv,
 				 struct ieee80211_tx_info *info,
-				 struct iwlagn_tx_resp *tx_resp,
-				 bool is_agg)
+				 struct iwlagn_tx_resp *tx_resp)
 {
-	u16  status = le16_to_cpu(tx_resp->status.status);
+	u16 status = le16_to_cpu(tx_resp->status.status);
 
 	info->status.rates[0].count = tx_resp->failure_frame + 1;
-	if (is_agg)
-		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
 	info->flags |= iwl_tx_status_to_mac80211(status);
 	iwlagn_hwrate_to_tx_control(priv, le32_to_cpu(tx_resp->rate_n_flags),
 				    info);
@@ -1231,7 +1228,7 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 			if (is_agg && !iwl_is_tx_success(status))
 				info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
 			iwlagn_set_tx_status(priv, IEEE80211_SKB_CB(skb),
-				     tx_resp, is_agg);
+				     tx_resp);
 			if (!is_agg)
 				iwlagn_non_agg_tx_status(priv, ctx, hdr->addr1);
 
-- 
1.8.0

