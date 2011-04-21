Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:56061 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab1DUMXa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 08:23:30 -0400
Date: Thu, 21 Apr 2011 17:45:14 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH 1/2] mac80211: Adding HW flag
 IEEE80211_HW_CRYPTO_ENABLED
Message-ID: <20110421121513.GC27527@hertz.marvell.com>
References: <20110415045321.GA11504@hertz.marvell.com>
 <1302850527.3572.2.camel@jlt3.sipsolutions.net>
 <20110415084005.GC11576@hertz.marvell.com>
 <1302857554.3572.14.camel@jlt3.sipsolutions.net>
 <20110415105140.GD11576@hertz.marvell.com>
 <1302865304.3572.15.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1302865304.3572.15.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes,
      Please take a look at the patch below which handles all the
comments that have been discussed in this thread.

I will appreciate if you review the same and let me know your thoughts
before I send the final patch.

On Fri, Apr 15, 2011 at 04:01:44AM -0700, Johannes Berg wrote:
> On Fri, 2011-04-15 at 16:21 +0530, Yogesh Ashok Powar wrote:
> 
> > > > Then Skip the code which expands the skb iff
> > > > IEEE80211_CRYPTO_NO_TAILROOM_NEEDED is set and the key is programmed
> > > > into the hardware (checking KEY_FLAG_UPLOADED_TO_HARDWARE).
> > > 
> > > You don't know the key at this point, so you have to keep track of
> > > whether this is true for all keys, which depends on whether or not
> > > they're already programmed into the HW (since for SW crypto we need the
> > > tailroom)
> > From this it seems that we do not reserve tailroom iff
> > IEEE80211_KEY_FLAG_GENERATE_MMIC flag is unset for all keys and all the keys
> > are programmed into the hardware.
> > 
> > Also, say in mixed mode if TKIP and CCMP keys are configured and this
> > flag is set for TKIP MMIC, we will end up reserving tailroom even for
> > CCMP.  Is my understanding correct?
> 
> Yes, correct.
> 
> > Also, though I have not looked into this part of the code very closely,
> > how about deriving key information at this place? Will that be feasible?
> 
> No, we can't do it here. I suppose we could postpone it for per key
> stuff, but that's more complex and probably good for a separate patch.
> 
> johannes
> 
Thanks
Yogesh
	

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a778499..20476ee 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -764,6 +764,9 @@ struct ieee80211_local {
 	/* device is started */
 	bool started;
 
+	/* count for keys needing tailroom space allocation */
+	int crypto_tx_tailroom_needed_cnt;
+
 	int tx_headroom; /* required headroom for hardware/radiotap */
 
 	/* Tasklet and skb queue to process calls from IRQ mode. All frames
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index af3c564..86b88fa 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -101,6 +101,9 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 
 	if (!ret) {
 		key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
+		if (key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC)
+			key->local->crypto_tx_tailroom_needed_cnt++;
+
 		return 0;
 	}
 
@@ -117,6 +120,11 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 	case WLAN_CIPHER_SUITE_CCMP:
 	case WLAN_CIPHER_SUITE_AES_CMAC:
 		/* all of these we can do in software */
+
+		/* SW encryption need tailroom reservation */
+		BUG_ON(!key->local);
+		key->local->crypto_tx_tailroom_needed_cnt++;
+
 		return 0;
 	default:
 		return -EINVAL;
@@ -156,6 +164,11 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 			  key->conf.keyidx, sta ? sta->addr : bcast_addr, ret);
 
 	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
+
+	if ((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC)
+				&& key->local->crypto_tx_tailroom_needed_cnt)
+		key->local->crypto_tx_tailroom_needed_cnt--;
+
 }
 
 void ieee80211_key_removed(struct ieee80211_key_conf *key_conf)
@@ -370,8 +383,11 @@ struct ieee80211_key *ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 	return key;
 }
 
-static void __ieee80211_key_destroy(struct ieee80211_key *key)
+static void __ieee80211_key_destroy(struct ieee80211_local *local,
+		struct ieee80211_key *key)
 {
+	bool key_sw_programmed = true;
+
 	if (!key)
 		return;
 
@@ -381,6 +397,8 @@ static void __ieee80211_key_destroy(struct ieee80211_key *key)
 	 */
 	synchronize_rcu();
 
+	key_sw_programmed = !(key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE);
+
 	if (key->local)
 		ieee80211_key_disable_hw_accel(key);
 
@@ -391,6 +409,9 @@ static void __ieee80211_key_destroy(struct ieee80211_key *key)
 	if (key->local)
 		ieee80211_debugfs_key_remove(key);
 
+	if (key_sw_programmed && local->crypto_tx_tailroom_needed_cnt)
+		local->crypto_tx_tailroom_needed_cnt--;
+
 	kfree(key);
 }
 
@@ -447,7 +468,7 @@ int ieee80211_key_link(struct ieee80211_key *key,
 		old_key = sdata->keys[idx];
 
 	__ieee80211_key_replace(sdata, sta, pairwise, old_key, key);
-	__ieee80211_key_destroy(old_key);
+	__ieee80211_key_destroy(sdata->local, old_key);
 
 	ieee80211_debugfs_key_add(key);
 
@@ -458,7 +479,8 @@ int ieee80211_key_link(struct ieee80211_key *key,
 	return ret;
 }
 
-static void __ieee80211_key_free(struct ieee80211_key *key)
+static void __ieee80211_key_free(struct ieee80211_local *local,
+		struct ieee80211_key *key)
 {
 	/*
 	 * Replace key with nothingness if it was ever used.
@@ -467,7 +489,7 @@ static void __ieee80211_key_free(struct ieee80211_key *key)
 		__ieee80211_key_replace(key->sdata, key->sta,
 				key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE,
 				key, NULL);
-	__ieee80211_key_destroy(key);
+	__ieee80211_key_destroy(local, key);
 }
 
 void ieee80211_key_free(struct ieee80211_local *local,
@@ -477,7 +499,7 @@ void ieee80211_key_free(struct ieee80211_local *local,
 		return;
 
 	mutex_lock(&local->key_mtx);
-	__ieee80211_key_free(key);
+	__ieee80211_key_free(local, key);
 	mutex_unlock(&local->key_mtx);
 }
 
@@ -521,7 +543,7 @@ void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata)
 	ieee80211_debugfs_key_remove_mgmt_default(sdata);
 
 	list_for_each_entry_safe(key, tmp, &sdata->key_list, list)
-		__ieee80211_key_free(key);
+		__ieee80211_key_free(sdata->local, key);
 
 	ieee80211_debugfs_key_update_default(sdata);
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 0ab2a8d..1f2aa4d 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -619,6 +619,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	local->user_power_level = -1;
 	local->uapsd_queues = IEEE80211_DEFAULT_UAPSD_QUEUES;
 	local->uapsd_max_sp_len = IEEE80211_DEFAULT_MAX_SP_LEN;
+	local->crypto_tx_tailroom_needed_cnt = 0;
 
 	INIT_LIST_HEAD(&local->interfaces);
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 17b10be..39cdcf5 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1487,7 +1487,7 @@ static int ieee80211_skb_resize(struct ieee80211_local *local,
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

