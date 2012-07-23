Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35111 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab2GWNaS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jul 2012 09:30:18 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC/RFT 6/6] mac80211: use correct channel in TX
Date: Mon, 23 Jul 2012 15:30:11 +0200
Message-Id: <1343050211-499-7-git-send-email-johannes@sipsolutions.net> (sfid-20120723_153032_098125_CDD4E70C)
In-Reply-To: <1343050211-499-1-git-send-email-johannes@sipsolutions.net>
References: <1343050211-499-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since we only need the band, remove the channel
pointer from struct ieee80211_tx_data and also
assign it properly, depending on context, to the
correct operating or current channel.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |    2 --
 net/mac80211/tx.c          |   17 +++++++----------
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 290000d..9500421 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -193,8 +193,6 @@ struct ieee80211_tx_data {
 	struct sta_info *sta;
 	struct ieee80211_key *key;
 
-	struct ieee80211_channel *channel;
-
 	unsigned int flags;
 };
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 1d035f0..5ea6c36 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -55,7 +55,7 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
 	if (WARN_ON_ONCE(info->control.rates[0].idx < 0))
 		return 0;
 
-	sband = local->hw.wiphy->bands[tx->channel->band];
+	sband = local->hw.wiphy->bands[info->band];
 	txrate = &sband->bitrates[info->control.rates[0].idx];
 
 	erp = txrate->flags & IEEE80211_RATE_ERP_G;
@@ -615,7 +615,7 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 
 	memset(&txrc, 0, sizeof(txrc));
 
-	sband = tx->local->hw.wiphy->bands[tx->channel->band];
+	sband = tx->local->hw.wiphy->bands[info->band];
 
 	len = min_t(u32, tx->skb->len + FCS_LEN,
 			 tx->local->hw.wiphy->frag_threshold);
@@ -626,13 +626,13 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 	txrc.bss_conf = &tx->sdata->vif.bss_conf;
 	txrc.skb = tx->skb;
 	txrc.reported_rate.idx = -1;
-	txrc.rate_idx_mask = tx->sdata->rc_rateidx_mask[tx->channel->band];
+	txrc.rate_idx_mask = tx->sdata->rc_rateidx_mask[info->band];
 	if (txrc.rate_idx_mask == (1 << sband->n_bitrates) - 1)
 		txrc.max_rate_idx = -1;
 	else
 		txrc.max_rate_idx = fls(txrc.rate_idx_mask) - 1;
 	memcpy(txrc.rate_idx_mcs_mask,
-	       tx->sdata->rc_rateidx_mcs_mask[tx->channel->band],
+	       tx->sdata->rc_rateidx_mcs_mask[info->band],
 	       sizeof(txrc.rate_idx_mcs_mask));
 	txrc.bss = (tx->sdata->vif.type == NL80211_IFTYPE_AP ||
 		    tx->sdata->vif.type == NL80211_IFTYPE_MESH_POINT ||
@@ -667,7 +667,7 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 		 "scanning and associated. Target station: "
 		 "%pM on %d GHz band\n",
 		 tx->sdata->name, hdr->addr1,
-		 tx->channel->band ? 5 : 2))
+		 info->band ? 5 : 2))
 		return TX_DROP;
 
 	/*
@@ -1131,7 +1131,6 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 	tx->skb = skb;
 	tx->local = local;
 	tx->sdata = sdata;
-	tx->channel = local->hw.conf.channel;
 	__skb_queue_head_init(&tx->skbs);
 
 	/*
@@ -1399,8 +1398,7 @@ static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
 		goto out;
 	}
 
-	tx.channel = local->hw.conf.channel;
-	info->band = tx.channel->band;
+	info->band = local->hw.conf.channel->band;
 
 	/* set up hw_queue value early */
 	if (!(info->flags & IEEE80211_TX_CTL_TX_OFFCHAN) ||
@@ -2706,8 +2704,7 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 	info = IEEE80211_SKB_CB(skb);
 
 	tx.flags |= IEEE80211_TX_PS_BUFFERED;
-	tx.channel = local->hw.conf.channel;
-	info->band = tx.channel->band;
+	info->band = local->oper_channel->band;
 
 	if (invoke_tx_handlers(&tx))
 		skb = NULL;
-- 
1.7.10.4

