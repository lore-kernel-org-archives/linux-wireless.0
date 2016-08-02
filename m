Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57408 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbcHBJNs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 05:13:48 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH] mac80211: fix purging multicast PS buffer queue
Date: Tue,  2 Aug 2016 11:13:41 +0200
Message-Id: <20160802091341.64330-1-nbd@nbd.name> (sfid-20160802_111356_489284_9B44A4D7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The code currently assumes that buffered multicast PS frames don't have
a pending ACK frame for tx status reporting.
However, hostapd sends a broadcast deauth frame on teardown for which tx
status is requested. This can lead to the "Have pending ack frames"
warning on module reload.
Fix this by using ieee80211_free_txskb/ieee80211_purge_tx_queue.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/cfg.c | 2 +-
 net/mac80211/tx.c  | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 47e99ab8..543b1d4 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -869,7 +869,7 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 
 	/* free all potentially still buffered bcast frames */
 	local->total_ps_buffered -= skb_queue_len(&sdata->u.ap.ps.bc_buf);
-	skb_queue_purge(&sdata->u.ap.ps.bc_buf);
+	ieee80211_purge_tx_queue(&local->hw, &sdata->u.ap.ps.bc_buf);
 
 	mutex_lock(&local->mtx);
 	ieee80211_vif_copy_chanctx_to_vlans(sdata, true);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 91461c4..5023966 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -368,7 +368,7 @@ static void purge_old_ps_buffers(struct ieee80211_local *local)
 		skb = skb_dequeue(&ps->bc_buf);
 		if (skb) {
 			purged++;
-			dev_kfree_skb(skb);
+			ieee80211_free_txskb(&local->hw, skb);
 		}
 		total += skb_queue_len(&ps->bc_buf);
 	}
@@ -451,7 +451,7 @@ ieee80211_tx_h_multicast_ps_buf(struct ieee80211_tx_data *tx)
 	if (skb_queue_len(&ps->bc_buf) >= AP_MAX_BC_BUFFER) {
 		ps_dbg(tx->sdata,
 		       "BC TX buffer full - dropping the oldest frame\n");
-		dev_kfree_skb(skb_dequeue(&ps->bc_buf));
+		ieee80211_free_txskb(&tx->local->hw, skb_dequeue(&ps->bc_buf));
 	} else
 		tx->local->total_ps_buffered++;
 
@@ -4275,7 +4275,7 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 			sdata = IEEE80211_DEV_TO_SUB_IF(skb->dev);
 		if (!ieee80211_tx_prepare(sdata, &tx, NULL, skb))
 			break;
-		dev_kfree_skb_any(skb);
+		ieee80211_free_txskb(hw, skb);
 	}
 
 	info = IEEE80211_SKB_CB(skb);
-- 
2.8.4

