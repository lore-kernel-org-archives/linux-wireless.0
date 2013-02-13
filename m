Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52110 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760039Ab3BMREM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 12:04:12 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: use spin_lock_bh() for TKIP lock
Date: Wed, 13 Feb 2013 18:04:07 +0100
Message-Id: <1360775047-16109-1-git-send-email-johannes@sipsolutions.net> (sfid-20130213_180417_797902_0DE6C5F2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since no driver calls the TKIP functions from interrupt
context, there's no need to use spin_lock_irqsave().
Just use spin_lock_bh() (and spin_lock() in the TX path
where we're in a BH or they're already disabled.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tkip.c | 10 ++++------
 net/mac80211/wpa.c  |  5 ++---
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index 57e14d5..3ed801d 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -177,12 +177,11 @@ void ieee80211_get_tkip_p1k_iv(struct ieee80211_key_conf *keyconf,
 	struct ieee80211_key *key = (struct ieee80211_key *)
 			container_of(keyconf, struct ieee80211_key, conf);
 	struct tkip_ctx *ctx = &key->u.tkip.tx;
-	unsigned long flags;
 
-	spin_lock_irqsave(&key->u.tkip.txlock, flags);
+	spin_lock_bh(&key->u.tkip.txlock);
 	ieee80211_compute_tkip_p1k(key, iv32);
 	memcpy(p1k, ctx->p1k, sizeof(ctx->p1k));
-	spin_unlock_irqrestore(&key->u.tkip.txlock, flags);
+	spin_unlock_bh(&key->u.tkip.txlock);
 }
 EXPORT_SYMBOL(ieee80211_get_tkip_p1k_iv);
 
@@ -208,12 +207,11 @@ void ieee80211_get_tkip_p2k(struct ieee80211_key_conf *keyconf,
 	const u8 *data = (u8 *)hdr + ieee80211_hdrlen(hdr->frame_control);
 	u32 iv32 = get_unaligned_le32(&data[4]);
 	u16 iv16 = data[2] | (data[0] << 8);
-	unsigned long flags;
 
-	spin_lock_irqsave(&key->u.tkip.txlock, flags);
+	spin_lock_bh(&key->u.tkip.txlock);
 	ieee80211_compute_tkip_p1k(key, iv32);
 	tkip_mixing_phase2(tk, ctx, iv16, p2k);
-	spin_unlock_irqrestore(&key->u.tkip.txlock, flags);
+	spin_unlock_bh(&key->u.tkip.txlock);
 }
 EXPORT_SYMBOL(ieee80211_get_tkip_p2k);
 
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index c175ee8..c7c6d64 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -181,7 +181,6 @@ static int tkip_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_key *key = tx->key;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	unsigned long flags;
 	unsigned int hdrlen;
 	int len, tail;
 	u8 *pos;
@@ -216,12 +215,12 @@ static int tkip_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 		return 0;
 
 	/* Increase IV for the frame */
-	spin_lock_irqsave(&key->u.tkip.txlock, flags);
+	spin_lock(&key->u.tkip.txlock);
 	key->u.tkip.tx.iv16++;
 	if (key->u.tkip.tx.iv16 == 0)
 		key->u.tkip.tx.iv32++;
 	pos = ieee80211_tkip_add_iv(pos, key);
-	spin_unlock_irqrestore(&key->u.tkip.txlock, flags);
+	spin_unlock(&key->u.tkip.txlock);
 
 	/* hwaccel - with software IV */
 	if (info->control.hw_key)
-- 
1.8.0

