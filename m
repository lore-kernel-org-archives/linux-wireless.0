Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:49636 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbbCAHKu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 02:10:50 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 13/16] mac80211: check and dequeue skb in ieee80211_tx_prepare_skb()
Date: Sun,  1 Mar 2015 09:10:12 +0200
Message-Id: <1425193815-17785-14-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_083417_169269_9353E51D)
In-Reply-To: <1425193815-17785-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1425193815-17785-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The ieee80211_tx_prepare_skb() function currently entirely ignores
the fact that the SKB that is passed in might be split into more
than one due to fragmentation and doesn't check the list of skbs
that the TX handlers may create. In case this happens, it would
leak them.

Fix this and also don't leave the skb next/prev pointers dangling
pointing to the on-stack sk_buff_head.

Reported-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 07bd8db..c519f06 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1422,6 +1422,7 @@ bool ieee80211_tx_prepare_skb(struct ieee80211_hw *hw,
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_tx_data tx;
+	struct sk_buff *skb2;
 
 	if (ieee80211_tx_prepare(sdata, &tx, skb) == TX_DROP)
 		return false;
@@ -1440,6 +1441,14 @@ bool ieee80211_tx_prepare_skb(struct ieee80211_hw *hw,
 			*sta = NULL;
 	}
 
+	/* this function isn't suitable for fragmented data frames */
+	skb2 = __skb_dequeue(&tx.skbs);
+	if (WARN_ON(skb2 != skb || !skb_queue_empty(&tx.skbs))) {
+		ieee80211_free_txskb(hw, skb2);
+		ieee80211_purge_tx_queue(hw, &tx.skbs);
+		return false;
+	}
+
 	return true;
 }
 EXPORT_SYMBOL(ieee80211_tx_prepare_skb);
-- 
1.9.1

