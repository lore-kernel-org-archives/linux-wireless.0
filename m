Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793651921;
	b=WTVOelU8gYHDXxvglKBqingjzsDD2/0yMWbCCggjaqOQpYiQbeMla7yaaXkVhTJoFdka
	 WB1XNVlFMrg+gz6/lC15aN6rJOTUFDU5uZ09yFta/lEC2WJeIhLfuM0z+GjqnGZCmJ3Do
	 Zu3n4eyganrTTGNBvYe08EnVQWVdwbwrH6R5snvKki7vBThHeVK61t3RMwaymWkGV1Q9t
	 OUnJZI2fWOLX6YNqlG5WfAL6rucNMnPSUEtXVUIxIMqTfw9sgToFqVscaGFnm/qcRfLZ9
	 DjOxBcrfT13SyHsdEJrjlT/FJIYWY+M11dDSx+rGgH0tDmvjYSV7XsvO2U4FLvAceUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793651921;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=2eIOKEPb6MqQSC9QUGrdtcwMPQYotyRpE6+yUEZ/IaI=;
	b=xa5sUuPncAEncAwrVwdwBAGJd5sB+jhDxaG+OC4FQ6kZX4+7UzZAafnU2PiA6RlEC7Wv
	 +g5Di14v6S2ihrZnm7AlwvDQA/2DmG8+zZac9G4QPBj3E7ogXKG9gXOEbXVuq7qMKfhEI
	 8pwBCXF4ZWZEJeNXcR+puVHflsg6b+Y4JVRoOEjmXmBH0YmJ6Tteu67FroJZJqyGlFfjq
	 in3rD4/qGhh8Tx9jECGGeDnzshB2xO1BdSjV9FoxYGIFIFlpcW9IIK1FAQ6JZOPHYwXh/
	 v+UvvwVk14iQm80DEGazpZ9Xhg0pCDHg1evesOm9Zbno5eK+e3ztO2OT0g7/k6BRecg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=v6YJIPhx;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEDA606D81C
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 20:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=v6YJIPhx
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=2eIOKEPb6MqQSC9QUGrdtcwMPQYotyRpE6+yUEZ/IaI=;
	t=1793651920; x=1794861520; b=v6YJIPhxf0Hc0zJeUHQW7o6k87b6i0QiVqoeiK/9SC22//9
	1cm82SsMbp8fD7y4wtxJdTZH3iHfSNYLcGLoJafxAq/agttcm2Q4AO585ZJ2h3Hh9yYM1Rx/v4j7B
	C25TeyAthMfJu+0pBt6D1bm2KE9W9+AxgX4iq8wIZMEXYGK3z6ShCQgfOpZW2RtHI/VLeucolmOoe
	J9B2LRBf/f5hCUnIJIwkx/AacyVQ6l1W2vuERfssB8ZnDty/I+P8SoEt0UubLSdALppsy5VsTn0yC
	aEG4Io6mLJZGkRRkA0xQnUZnkNCPy7dPQHtXMXJp/eM8ztspeLzbu79iv6imXLVA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNyne-00000001vzr-1HmK;
	Mon, 02 Nov 2026 21:38:38 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 04/30] wifi: mac80211: remove dead aggregation TX code
Date: Mon,  2 Nov 2026 21:22:54 +0100
Message-ID: <20261102203831.1058362-36-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102203831.1058362-32-johannes@sipsolutions.net>
References: <20261102203831.1058362-32-johannes@sipsolutions.net>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Since TXQs are paused for TX aggregation start, and we forced
all drivers to use TXQs in mac80211, ieee80211_tx_prep_agg()
can't find that there's no TXQ anymore. Delete the dead code.

TX now also no longer looks at the aggregation state with the
lock held, so update the docs.

Also set IEEE80211_TX_CTL_AMPDU again, we just fixed an issue
with that, and merging trees would otherwise drop that fix.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.h |  6 +--
 net/mac80211/tx.c       | 83 ++---------------------------------------
 2 files changed, 5 insertions(+), 84 deletions(-)

diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 8c6a9fee6b29..8b64c9b12de0 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -177,11 +177,7 @@ struct sta_info;
  * This structure's lifetime is managed by RCU, assignments to
  * the array holding it must hold the aggregation mutex.
  *
- * The TX path can access it under RCU lock-free if, and
- * only if, the state has the flag %HT_AGG_STATE_OPERATIONAL
- * set. Otherwise, the TX path must also acquire the spinlock
- * and re-check the state, see comments in the tx code
- * touching it.
+ * The TX path accesses it under RCU, lock-free.
  */
 struct tid_ampdu_tx {
 	struct rcu_head rcu_head;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e9b6a0415d6a..b945bd2fcb46 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1153,77 +1153,6 @@ ieee80211_tx_h_calculate_duration(struct ieee80211_tx_data *tx)
 
 /* actual transmit path */
 
-static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
-				  struct sk_buff *skb,
-				  struct ieee80211_tx_info *info,
-				  struct tid_ampdu_tx *tid_tx,
-				  int tid)
-{
-	bool queued = false;
-	bool reset_agg_timer = false;
-	struct sk_buff *purge_skb = NULL;
-
-	if (test_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state)) {
-		reset_agg_timer = true;
-	} else if (test_bit(HT_AGG_STATE_WANT_START, &tid_tx->state)) {
-		/*
-		 * nothing -- this aggregation session is being started
-		 * but that might still fail with the driver
-		 */
-	} else if (!tx->sta->sta.txq[tid]) {
-		spin_lock(&tx->sta->lock);
-		/*
-		 * Need to re-check now, because we may get here
-		 *
-		 *  1) in the window during which the setup is actually
-		 *     already done, but not marked yet because not all
-		 *     packets are spliced over to the driver pending
-		 *     queue yet -- if this happened we acquire the lock
-		 *     either before or after the splice happens, but
-		 *     need to recheck which of these cases happened.
-		 *
-		 *  2) during session teardown, if the OPERATIONAL bit
-		 *     was cleared due to the teardown but the pointer
-		 *     hasn't been assigned NULL yet (or we loaded it
-		 *     before it was assigned) -- in this case it may
-		 *     now be NULL which means we should just let the
-		 *     packet pass through because splicing the frames
-		 *     back is already done.
-		 */
-		tid_tx = rcu_dereference_protected_tid_tx(tx->sta, tid);
-
-		if (!tid_tx) {
-			/* do nothing, let packet pass through */
-		} else if (test_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state)) {
-			reset_agg_timer = true;
-		} else {
-			queued = true;
-			if (info->flags & IEEE80211_TX_CTL_NO_PS_BUFFER) {
-				clear_sta_flag(tx->sta, WLAN_STA_SP);
-				ps_dbg(tx->sta->sdata,
-				       "STA %pM aid %d: SP frame queued, close the SP w/o telling the peer\n",
-				       tx->sta->sta.addr, tx->sta->sta.aid);
-			}
-			info->control.vif = &tx->sdata->vif;
-			info->control.flags |= IEEE80211_TX_INTCFL_NEED_TXPROCESSING;
-			info->flags &= ~IEEE80211_TX_TEMPORARY_FLAGS;
-			__skb_queue_tail(&tid_tx->pending, skb);
-			if (skb_queue_len(&tid_tx->pending) > STA_MAX_TX_BUFFER)
-				purge_skb = __skb_dequeue(&tid_tx->pending);
-		}
-		spin_unlock(&tx->sta->lock);
-
-		if (purge_skb)
-			ieee80211_free_txskb(&tx->local->hw, purge_skb);
-	}
-
-	/* reset session timer */
-	if (reset_agg_timer)
-		tid_tx->last_tx = jiffies;
-
-	return queued;
-}
-
 void ieee80211_aggr_check(struct ieee80211_sub_if_data *sdata,
 			  struct sta_info *sta, struct sk_buff *skb)
 {
@@ -1308,14 +1237,10 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 			tid_tx = rcu_dereference(tx->sta->ampdu_mlme.tid_tx[tid]);
 		}
 
-		if (tid_tx) {
-			bool queued;
-
-			queued = ieee80211_tx_prep_agg(tx, skb, info,
-						       tid_tx, tid);
-
-			if (unlikely(queued))
-				return TX_QUEUED;
+		if (tid_tx && test_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state)) {
+			info->flags |= IEEE80211_TX_CTL_AMPDU;
+			/* reset session timer */
+			tid_tx->last_tx = jiffies;
 		}
 	}
 
-- 
2.56.0

