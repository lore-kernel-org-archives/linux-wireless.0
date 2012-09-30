Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33165 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab2I3PPc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2012 11:15:32 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: remove some unused code
Date: Sun, 30 Sep 2012 17:16:05 +0200
Message-Id: <1349018165-22826-1-git-send-email-johannes@sipsolutions.net> (sfid-20120930_171534_971256_CC4F28E8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There are a number of unused variables that gcc
pointed out (when building with W=1) as well as
some conditions that can never be true due to
the datatypes used: unsigned values can't be
less than zero. Remove this code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c  |    2 --
 net/mac80211/mlme.c |    7 +------
 net/mac80211/rx.c   |   11 +++--------
 net/mac80211/tx.c   |    2 --
 4 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 05f3a31..0181e0d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2819,7 +2819,6 @@ static int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_tx_info *info;
 	struct sk_buff *skb = NULL;
 	bool send_direct;
 	int ret;
@@ -2845,7 +2844,6 @@ static int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	if (!skb)
 		return -ENOMEM;
 
-	info = IEEE80211_SKB_CB(skb);
 	skb_reserve(skb, local->hw.extra_tx_headroom);
 
 	switch (action_code) {
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index e714ed8..8fed60b 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2543,14 +2543,9 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 
 
 	if (elems.ht_cap_elem && elems.ht_operation && elems.wmm_param &&
-	    !(ifmgd->flags & IEEE80211_STA_DISABLE_11N)) {
-		struct ieee80211_supported_band *sband;
-
-		sband = local->hw.wiphy->bands[local->oper_channel->band];
-
+	    !(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
 		changed |= ieee80211_config_ht_tx(sdata, elems.ht_operation,
 						  bssid, true);
-	}
 
 	if (elems.country_elem && elems.pwr_constr_elem &&
 	    mgmt->u.probe_resp.capab_info &
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 61c621e..9f64fc4 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1384,9 +1384,7 @@ ieee80211_reassemble_add(struct ieee80211_sub_if_data *sdata,
 			 struct sk_buff **skb)
 {
 	struct ieee80211_fragment_entry *entry;
-	int idx;
 
-	idx = sdata->fragment_next;
 	entry = &sdata->fragments[sdata->fragment_next++];
 	if (sdata->fragment_next >= IEEE80211_FRAGMENT_MAX)
 		sdata->fragment_next = 0;
@@ -3010,8 +3008,7 @@ void ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	WARN_ON_ONCE(softirq_count() == 0);
 
-	if (WARN_ON(status->band < 0 ||
-		    status->band >= IEEE80211_NUM_BANDS))
+	if (WARN_ON(status->band >= IEEE80211_NUM_BANDS))
 		goto drop;
 
 	sband = local->hw.wiphy->bands[status->band];
@@ -3056,8 +3053,7 @@ void ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb)
 			 * hardware error. The driver should catch hardware
 			 * errors.
 			 */
-			if (WARN((status->rate_idx < 0 ||
-				 status->rate_idx > 76),
+			if (WARN(status->rate_idx > 76,
 				 "Rate marked as an HT rate but passed "
 				 "status->rate_idx is not "
 				 "an MCS index [0-76]: %d (0x%02x)\n",
@@ -3065,8 +3061,7 @@ void ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb)
 				 status->rate_idx))
 				goto drop;
 		} else {
-			if (WARN_ON(status->rate_idx < 0 ||
-				    status->rate_idx >= sband->n_bitrates))
+			if (WARN_ON(status->rate_idx >= sband->n_bitrates))
 				goto drop;
 			rate = &sband->bitrates[status->rate_idx];
 		}
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e0e0d1d..baa88fc 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -951,7 +951,6 @@ ieee80211_tx_h_fragment(struct ieee80211_tx_data *tx)
 	fragnum = 0;
 
 	skb_queue_walk(&tx->skbs, skb) {
-		int next_len;
 		const __le16 morefrags = cpu_to_le16(IEEE80211_FCTL_MOREFRAGS);
 
 		hdr = (void *)skb->data;
@@ -970,7 +969,6 @@ ieee80211_tx_h_fragment(struct ieee80211_tx_data *tx)
 			info->flags &= ~IEEE80211_TX_CTL_RATE_CTRL_PROBE;
 		} else {
 			hdr->frame_control &= ~morefrags;
-			next_len = 0;
 		}
 		hdr->seq_ctrl |= cpu_to_le16(fragnum & IEEE80211_SCTL_FRAG);
 		fragnum++;
-- 
1.7.10.4

