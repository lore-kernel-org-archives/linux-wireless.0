Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55845 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab2BZKYk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Feb 2012 05:24:40 -0500
Subject: [PATCH] mac80211: remove local_to_hw
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 26 Feb 2012 11:24:35 +0100
Message-ID: <1330251875.4401.0.camel@jlt3.sipsolutions.net> (sfid-20120226_112451_398059_CA20D1A1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

That's a lot longer than open-coding it and
doesn't really add value, so just remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |    6 ------
 net/mac80211/main.c        |    6 +++---
 net/mac80211/tx.c          |    2 +-
 net/mac80211/util.c        |    2 +-
 4 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 38bfca3..3c7c92f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1133,12 +1133,6 @@ static inline struct ieee80211_local *hw_to_local(
 	return container_of(hw, struct ieee80211_local, hw);
 }
 
-static inline struct ieee80211_hw *local_to_hw(
-	struct ieee80211_local *local)
-{
-	return &local->hw;
-}
-
 
 static inline int ieee80211_bssid_match(const u8 *raddr, const u8 *addr)
 {
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 0f68645..87f5340 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -290,11 +290,11 @@ static void ieee80211_tasklet_handler(unsigned long data)
 			/* Clear skb->pkt_type in order to not confuse kernel
 			 * netstack. */
 			skb->pkt_type = 0;
-			ieee80211_rx(local_to_hw(local), skb);
+			ieee80211_rx(&local->hw, skb);
 			break;
 		case IEEE80211_TX_STATUS_MSG:
 			skb->pkt_type = 0;
-			ieee80211_tx_status(local_to_hw(local), skb);
+			ieee80211_tx_status(&local->hw, skb);
 			break;
 		case IEEE80211_EOSP_MSG:
 			eosp_data = (void *)skb->cb;
@@ -674,7 +674,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 
 	ieee80211_hw_roc_setup(local);
 
-	return local_to_hw(local);
+	return &local->hw;
 }
 EXPORT_SYMBOL(ieee80211_alloc_hw);
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index d4c007d..c383723 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -625,7 +625,7 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 			 tx->local->hw.wiphy->frag_threshold);
 
 	/* set up the tx rate control struct we give the RC algo */
-	txrc.hw = local_to_hw(tx->local);
+	txrc.hw = &tx->local->hw;
 	txrc.sband = sband;
 	txrc.bss_conf = &tx->sdata->vif.bss_conf;
 	txrc.skb = tx->skb;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index b54d7fc..3215117 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -778,7 +778,7 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata)
 	use_11b = (local->hw.conf.channel->band == IEEE80211_BAND_2GHZ) &&
 		 !(sdata->flags & IEEE80211_SDATA_OPERATING_GMODE);
 
-	for (queue = 0; queue < local_to_hw(local)->queues; queue++) {
+	for (queue = 0; queue < local->hw.queues; queue++) {
 		/* Set defaults according to 802.11-2007 Table 7-37 */
 		aCWmax = 1023;
 		if (use_11b)
-- 
1.7.6.3



