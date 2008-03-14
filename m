Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:47109 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbYCNRlp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Mar 2008 13:41:45 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: TKIP enable HW encryption for fragmented packets
Date: Fri, 14 Mar 2008 10:40:15 -0700
Message-Id: <1205516415-22202-1-git-send-email-reinette.chatre@intel.com> (sfid-20080314_174153_458878_74B32EBC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch fixes TKIP encryption for fragmented packets.
Each fragmet needs it's own phase2 key.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/tx.c          |   12 ++++++++++++
 net/mac80211/wpa.c         |   18 +++++++++++++-----
 3 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 7f10ff5..5c7b8e2 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -156,6 +156,7 @@ struct ieee80211_tx_data {
 	struct sta_info *sta;
 	u16 fc, ethertype;
 	struct ieee80211_key *key;
+	u8 tkip_key[16];
 	unsigned int flags;
 
 	struct ieee80211_tx_control *control;
@@ -170,6 +171,7 @@ struct ieee80211_tx_data {
 	 * in skb) */
 	int num_extra_frag;
 	struct sk_buff **extra_frag;
+	u8 *frag_tkip_key; /* size 16 * num_extra_frag */
 };
 
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 80f4343..ee09464 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1078,6 +1078,11 @@ static int __ieee80211_tx(struct ieee80211_local *local, struct sk_buff *skb,
 	if (skb) {
 		ieee80211_dump_frame(wiphy_name(local->hw.wiphy),
 				     "TX to low-level driver", skb);
+
+		if (tx->key && (tx->key->conf.flags &
+				IEEE80211_KEY_FLAG_TKIP_REQ_TX_P2_KEY))
+			memcpy(control->tkip_key, tx->tkip_key, 16);
+
 		ret = local->ops->tx(local_to_hw(local), skb, control);
 		if (ret)
 			return IEEE80211_TX_AGAIN;
@@ -1092,6 +1097,11 @@ static int __ieee80211_tx(struct ieee80211_local *local, struct sk_buff *skb,
 		for (i = 0; i < tx->num_extra_frag; i++) {
 			if (!tx->extra_frag[i])
 				continue;
+
+			if (tx->frag_tkip_key)
+				memcpy(control->tkip_key,
+					&tx->frag_tkip_key[i * 16], 16);
+
 			if (__ieee80211_queue_stopped(local, control->queue))
 				return IEEE80211_TX_FRAG_AGAIN;
 			if (i == tx->num_extra_frag) {
@@ -1119,6 +1129,8 @@ static int __ieee80211_tx(struct ieee80211_local *local, struct sk_buff *skb,
 		}
 		kfree(tx->extra_frag);
 		tx->extra_frag = NULL;
+		kfree(tx->frag_tkip_key);
+		tx->frag_tkip_key = NULL;
 	}
 	return IEEE80211_TX_OK;
 }
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index cc1702e..60f2349 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -228,10 +228,8 @@ static int tkip_encrypt_skb(struct ieee80211_tx_data *tx,
 					    0x7f),
 				      (u8) key->u.tkip.iv16);
 
-		if (key->conf.flags & IEEE80211_KEY_FLAG_TKIP_REQ_TX_P2_KEY)
-			ieee80211_tkip_gen_rc4key(key, hdr->addr2,
-						tx->control->tkip_key);
 		tx->control->key_idx = tx->key->conf.hw_key_idx;
+
 		return 0;
 	}
 
@@ -249,6 +247,7 @@ ieee80211_tx_result
 ieee80211_crypto_tkip_encrypt(struct ieee80211_tx_data *tx)
 {
 	struct sk_buff *skb = tx->skb;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	int wpa_test = 0, test = 0;
 
 	tx->control->icv_len = TKIP_ICV_LEN;
@@ -266,12 +265,21 @@ ieee80211_crypto_tkip_encrypt(struct ieee80211_tx_data *tx)
 	if (tkip_encrypt_skb(tx, skb, test) < 0)
 		return TX_DROP;
 
+	if (tx->key->conf.flags & IEEE80211_KEY_FLAG_TKIP_REQ_TX_P2_KEY)
+		ieee80211_tkip_gen_rc4key(tx->key, hdr->addr2, tx->tkip_key);
+
+
 	if (tx->extra_frag) {
 		int i;
+		if (tx->key->conf.flags & IEEE80211_KEY_FLAG_TKIP_REQ_TX_P2_KEY)
+			tx->frag_tkip_key =
+				kzalloc(tx->num_extra_frag * 16, GFP_ATOMIC);
 		for (i = 0; i < tx->num_extra_frag; i++) {
-			if (tkip_encrypt_skb(tx, tx->extra_frag[i], test)
-			    < 0)
+			if (tkip_encrypt_skb(tx, tx->extra_frag[i], test) < 0)
 				return TX_DROP;
+			if (tx->key->conf.flags & IEEE80211_KEY_FLAG_TKIP_REQ_TX_P2_KEY)
+				ieee80211_tkip_gen_rc4key(tx->key, hdr->addr2,
+							  &tx->frag_tkip_key[i * 16]);
 		}
 	}
 
-- 
1.5.3.4

