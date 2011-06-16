Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:50392 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756775Ab1FPKgZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2011 06:36:25 -0400
Date: Thu, 16 Jun 2011 15:57:08 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Andreas Hartmann <andihartmann@01019freenet.de>
Subject: [PATCH 2/2] mac80211: Fixing Races for skipping tailroom
 reservation
Message-ID: <20110616102707.GB24458@hertz.marvell.com> (sfid-20110616_123629_968132_960D9994)
References: <20110616102138.GA24447@hertz.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110616102138.GA24447@hertz.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Following warning was observed after the commit
aac6af5534fade2b18682a0b9efad1a6c04c34c6

>WARNING: at net/mac80211/wpa.c:397 ccmp_encrypt_skb+0xc4/0x1f0

Consider a scenario where reserving skb tailroom is skipped
because software encryption is not enabled. SW encryption
can be disabled because of a) All the keys are hardware
planted b) No key has been created.  But, before actual
transmit if hardware encryption is disabled or software
encryption is started, there will not be enough tailroom
space to accommodate the sw crypto's MMIC or IV and
WARN_ON will be hit.

This race between updations of hw keys and skipping & using
tailroom, is fixed by protecting critical regions (code
accessing crypto_tx_tailroom_needed_cnt and code from
tailroom skipping to skb_put for IV or MMIC) with the
spinlock.

Reported-and-tested-by: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: Andreas Hartmann <andihartmann@01019freenet.de>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 net/mac80211/ieee80211_i.h |    6 +++++-
 net/mac80211/key.c         |   27 ++++++++++++++++++++++++++-
 net/mac80211/main.c        |    2 ++
 net/mac80211/tx.c          |    6 ++++++
 4 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 2025af5..844d385 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -775,8 +775,12 @@ struct ieee80211_local {
 
 	int tx_headroom; /* required headroom for hardware/radiotap */
 
-	/* count for keys needing tailroom space allocation */
+	/*
+	 * count for keys needing tailroom space allocation,
+	 * its access is protected by spinlock tailroom_skp (see below)
+	 */
 	int crypto_tx_tailroom_needed_cnt;
+	spinlock_t tailroom_skip;
 
 	/* Tasklet and skb queue to process calls from IRQ mode. All frames
 	 * added to skb_queue will be processed, but frames in
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 31afd712..b78ef6f 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -104,8 +104,13 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 
 		if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
 		      (key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV)))
+
+			spin_lock(&key->local->tailroom_skip);
+
 			key->local->crypto_tx_tailroom_needed_cnt--;
 
+			spin_unlock(&key->local->tailroom_skip);
+
 		return 0;
 	}
 
@@ -163,8 +168,14 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
 
 	if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
-	      (key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV)))
+	      (key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV))) {
+
+		spin_lock(&key->local->tailroom_skip);
+
 		key->local->crypto_tx_tailroom_needed_cnt++;
+
+		spin_unlock(&key->local->tailroom_skip);
+	}
 }
 
 void ieee80211_key_removed(struct ieee80211_key_conf *key_conf)
@@ -405,7 +416,12 @@ static void __ieee80211_key_destroy(struct ieee80211_key *key)
 		ieee80211_aes_cmac_key_free(key->u.aes_cmac.tfm);
 	if (key->local) {
 		ieee80211_debugfs_key_remove(key);
+
+		spin_lock(&key->local->tailroom_skip);
+
 		key->local->crypto_tx_tailroom_needed_cnt--;
+
+		spin_unlock(&key->local->tailroom_skip);
 	}
 
 	kfree(key);
@@ -468,8 +484,13 @@ int ieee80211_key_link(struct ieee80211_key *key,
 
 	ieee80211_debugfs_key_add(key);
 
+
+	spin_lock(&key->local->tailroom_skip);
+
 	key->local->crypto_tx_tailroom_needed_cnt++;
 
+	spin_unlock(&key->local->tailroom_skip);
+
 	ret = ieee80211_key_enable_hw_accel(key);
 
 	mutex_unlock(&sdata->local->key_mtx);
@@ -511,6 +532,8 @@ void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata)
 
 	mutex_lock(&sdata->local->key_mtx);
 
+	spin_lock(&sdata->local->tailroom_skip);
+
 	sdata->local->crypto_tx_tailroom_needed_cnt = 0;
 
 	list_for_each_entry(key, &sdata->key_list, list) {
@@ -518,6 +541,8 @@ void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata)
 		ieee80211_key_enable_hw_accel(key);
 	}
 
+	spin_unlock(&sdata->local->tailroom_skip);
+
 	mutex_unlock(&sdata->local->key_mtx);
 }
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 866f269..4506ed3 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -625,6 +625,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	spin_lock_init(&local->filter_lock);
 	spin_lock_init(&local->queue_stop_reason_lock);
 
+	spin_lock_init(&local->tailroom_skip);
+
 	/*
 	 * The rx_skb_queue is only accessed from tasklets,
 	 * but other SKB queues are used from within IRQ
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 64e0f75..5ea1baa 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1573,8 +1573,11 @@ static void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
 	headroom -= skb_headroom(skb);
 	headroom = max_t(int, 0, headroom);
 
+	spin_lock(&local->tailroom_skip);
+
 	if (ieee80211_skb_resize(local, skb, headroom, may_encrypt)) {
 		dev_kfree_skb(skb);
+		spin_unlock(&local->tailroom_skip);
 		rcu_read_unlock();
 		return;
 	}
@@ -1587,12 +1590,15 @@ static void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
 		!is_multicast_ether_addr(hdr->addr1))
 			if (mesh_nexthop_lookup(skb, sdata)) {
 				/* skb queued: don't free */
+				spin_unlock(&local->tailroom_skip);
 				rcu_read_unlock();
 				return;
 			}
 
 	ieee80211_set_qos_hdr(local, skb);
 	ieee80211_tx(sdata, skb, false);
+
+	spin_unlock(&local->tailroom_skip);
 	rcu_read_unlock();
 }
 
-- 
1.7.5.4

