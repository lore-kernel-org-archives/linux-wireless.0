Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:43058 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088Ab1FTOj6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2011 10:39:58 -0400
Date: Mon, 20 Jun 2011 20:00:52 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Andreas Hartmann <andihartmann@01019freenet.de>
Subject: Re: [PATCH 2/2] mac80211: Fixing Races for skipping tailroom
 reservation
Message-ID: <20110620143051.GA31035@hertz.marvell.com> (sfid-20110620_164002_251122_6BBC8DFB)
References: <20110616102138.GA24447@hertz.marvell.com>
 <20110616102707.GB24458@hertz.marvell.com>
 <d38dc36c1ab9a4bd819b9bcbbda181da@secure.sipsolutions.net>
 <20110617132527.GA27436@hertz.marvell.com>
 <1308331485.7329.2.camel@Nokia-N900-51-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1308331485.7329.2.camel@Nokia-N900-51-1>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 17, 2011 at 10:24:45AM -0700, Johannes Berg wrote:
> > Using spinlocks in TX/RX path is not allowed because spinlocks will make
> > TX/RX path to block and its illegal to block while in an RCU read-side
> > critical section. I think, I got the joke here :(.
> 
> No, that'd be allowed, but you can't spinlock all the TX path because of performance.
> 
> I think the way to solve it would be to use synchronize_net() somehow maybe; not really sure.

Following patch avoids tailroom skip check for RCU readside
critical sections that begin inside the synchronize_rcu's grace
period, without grabbing any lock in the TX patch and there by avoiding
the race conditions.

I will request Andreas to test this patch on his testbed if the changes
are fine with you.

Thanks
Yogesh

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 2025af5..56c7751b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -777,6 +777,7 @@ struct ieee80211_local {
 
 	/* count for keys needing tailroom space allocation */
 	int crypto_tx_tailroom_needed_cnt;
+	struct mutex tailroom_skip;
 
 	/* Tasklet and skb queue to process calls from IRQ mode. All frames
 	 * added to skb_queue will be processed, but frames in
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 31afd712..d59837a 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -390,14 +390,20 @@ static void __ieee80211_key_destroy(struct ieee80211_key *key)
 	if (!key)
 		return;
 
+	if (key->local && !(key->local->crypto_tx_tailroom_needed_cnt))
+		mutex_lock(&key->local->tailroom_skip);
+
 	/*
 	 * Synchronize so the TX path can no longer be using
 	 * this key before we free/remove it.
 	 */
 	synchronize_rcu();
 
-	if (key->local)
+	if (key->local) {
 		ieee80211_key_disable_hw_accel(key);
+		if (mutex_is_locked(&key->local->tailroom_skip))
+			mutex_unlock(&key->local->tailroom_skip);
+	}
 
 	if (key->conf.cipher == WLAN_CIPHER_SUITE_CCMP)
 		ieee80211_aes_key_free(key->u.ccmp.tfm);
@@ -468,8 +474,16 @@ int ieee80211_key_link(struct ieee80211_key *key,
 
 	ieee80211_debugfs_key_add(key);
 
+	if (!key->local->crypto_tx_tailroom_needed_cnt) {
+		mutex_lock(&key->local->tailroom_skip);
+		synchronize_rcu();
+	}
+
 	key->local->crypto_tx_tailroom_needed_cnt++;
 
+	if (mutex_is_locked(&key->local->tailroom_skip))
+		mutex_unlock(&key->local->tailroom_skip);
+
 	ret = ieee80211_key_enable_hw_accel(key);
 
 	mutex_unlock(&sdata->local->key_mtx);
@@ -513,11 +527,17 @@ void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata)
 
 	sdata->local->crypto_tx_tailroom_needed_cnt = 0;
 
+	mutex_lock(&sdata->local->tailroom_skip);
+
+	synchronize_rcu();
+
 	list_for_each_entry(key, &sdata->key_list, list) {
 		sdata->local->crypto_tx_tailroom_needed_cnt++;
 		ieee80211_key_enable_hw_accel(key);
 	}
 
+	mutex_unlock(&sdata->local->tailroom_skip);
+
 	mutex_unlock(&sdata->local->key_mtx);
 }
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 866f269..c70b26d 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -625,6 +625,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	spin_lock_init(&local->filter_lock);
 	spin_lock_init(&local->queue_stop_reason_lock);
 
+	mutex_init(&local->tailroom_skip);
+
 	/*
 	 * The rx_skb_queue is only accessed from tasklets,
 	 * but other SKB queues are used from within IRQ
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 64e0f75..ce2ee4a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1480,7 +1480,8 @@ static int ieee80211_skb_resize(struct ieee80211_local *local,
 {
 	int tail_need = 0;
 
-	if (may_encrypt && local->crypto_tx_tailroom_needed_cnt) {
+	if (may_encrypt && (local->crypto_tx_tailroom_needed_cnt ||
+				mutex_is_locked(&local->tailroom_skip))) {
 		tail_need = IEEE80211_ENCRYPT_TAILROOM;
 		tail_need -= skb_tailroom(skb);
 		tail_need = max_t(int, tail_need, 0);
