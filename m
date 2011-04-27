Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:46731 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124Ab1D0LLk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2011 07:11:40 -0400
Date: Wed, 27 Apr 2011 16:33:04 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH 1/2] mac80211: Adding HW flag
 IEEE80211_HW_CRYPTO_ENABLED
Message-ID: <20110427110303.GA18370@hertz.marvell.com> (sfid-20110427_131143_583491_041C9F99)
References: <20110415045321.GA11504@hertz.marvell.com>
 <1302850527.3572.2.camel@jlt3.sipsolutions.net>
 <20110415084005.GC11576@hertz.marvell.com>
 <1302857554.3572.14.camel@jlt3.sipsolutions.net>
 <20110415105140.GD11576@hertz.marvell.com>
 <1302865304.3572.15.camel@jlt3.sipsolutions.net>
 <20110421121513.GC27527@hertz.marvell.com>
 <1303389236.3597.8.camel@jlt3.sipsolutions.net>
 <20110421124624.GA29211@hertz.marvell.com>
 <1303390788.3597.10.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1303390788.3597.10.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 21, 2011 at 05:59:48AM -0700, Johannes Berg wrote:
> Well, it kinda goes like this:
> 
> key added           -> need tailroom code
> key put into HW     -> no longer need tailroom code
> key removed from HW -> need tailroom code again
> key deleted         -> no longer need tailroom code
> 
Following patch takes care of these four states. Kindly review.

Thanks
Yogesh

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a778499..027c046 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -766,6 +766,9 @@ struct ieee80211_local {
 
 	int tx_headroom; /* required headroom for hardware/radiotap */
 
+	/* count for keys needing tailroom space allocation */
+	int crypto_tx_tailroom_needed_cnt;
+
 	/* Tasklet and skb queue to process calls from IRQ mode. All frames
 	 * added to skb_queue will be processed, but frames in
 	 * skb_queue_unreliable may be dropped if the total length of these
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index af3c564..e180149 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -101,6 +101,10 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 
 	if (!ret) {
 		key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
+
+		if (!(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC))
+			key->local->crypto_tx_tailroom_needed_cnt--;
+
 		return 0;
 	}
 
@@ -156,6 +160,9 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 			  key->conf.keyidx, sta ? sta->addr : bcast_addr, ret);
 
 	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
+
+	if (!(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC))
+		key->local->crypto_tx_tailroom_needed_cnt++;
 }
 
 void ieee80211_key_removed(struct ieee80211_key_conf *key_conf)
@@ -388,8 +395,10 @@ static void __ieee80211_key_destroy(struct ieee80211_key *key)
 		ieee80211_aes_key_free(key->u.ccmp.tfm);
 	if (key->conf.cipher == WLAN_CIPHER_SUITE_AES_CMAC)
 		ieee80211_aes_cmac_key_free(key->u.aes_cmac.tfm);
-	if (key->local)
+	if (key->local) {
 		ieee80211_debugfs_key_remove(key);
+		key->local->crypto_tx_tailroom_needed_cnt--;
+	}
 
 	kfree(key);
 }
@@ -451,6 +460,8 @@ int ieee80211_key_link(struct ieee80211_key *key,
 
 	ieee80211_debugfs_key_add(key);
 
+	key->local->crypto_tx_tailroom_needed_cnt++;
+
 	ret = ieee80211_key_enable_hw_accel(key);
 
 	mutex_unlock(&sdata->local->key_mtx);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index a2043e4..87456b4 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1481,7 +1481,7 @@ static int ieee80211_skb_resize(struct ieee80211_local *local,
 	 * crypto (including TKIP MMIC) need no tailroom... But we
 	 * have no drivers for such devices currently.
 	 */
-	if (may_encrypt) {
+	if (may_encrypt && local->crypto_tx_tailroom_needed_cnt) {
 		tail_need = IEEE80211_ENCRYPT_TAILROOM;
 		tail_need -= skb_tailroom(skb);
 		tail_need = max_t(int, tail_need, 0);
-- 
1.5.4.1

