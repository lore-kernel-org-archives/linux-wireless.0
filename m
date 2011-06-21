Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:48518 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165Ab1FUOTW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 10:19:22 -0400
Date: Tue, 21 Jun 2011 19:40:18 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Andreas Hartmann <andihartmann@01019freenet.de>
Subject: Re: [PATCH 2/2] mac80211: Fixing Races for skipping tailroom
 reservation
Message-ID: <20110621141017.GC32464@hertz.marvell.com> (sfid-20110621_161926_221719_4FB1C831)
References: <20110616102707.GB24458@hertz.marvell.com>
 <d38dc36c1ab9a4bd819b9bcbbda181da@secure.sipsolutions.net>
 <20110617132527.GA27436@hertz.marvell.com>
 <1308331485.7329.2.camel@Nokia-N900-51-1>
 <20110620143051.GA31035@hertz.marvell.com>
 <1308583799.4322.9.camel@jlt3.sipsolutions.net>
 <7DDF37406E10F0438561DBB78326DF3902F5D190E2@SC-VEXCH1.marvell.com>
 <1308590980.4322.19.camel@jlt3.sipsolutions.net>
 <20110621130305.GB32464@hertz.marvell.com>
 <1308663814.4276.3.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1308663814.4276.3.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 21, 2011 at 06:43:34AM -0700, Johannes Berg wrote:
> On Tue, 2011-06-21 at 18:33 +0530, Yogesh Ashok Powar wrote:
> 
> > Following is the implementation based on your design.
> > 
> > Let me know if I miss anything here.
> 
> Since your original code was reverted you should send a full patch. But
> overall it looks fine.
Thanks

>Came to think of it yesterday though, for the
> 0->1 case it's of course necessary to do the adjustment before the key
> can be found, but also for the 1->0 case it'll be necessary to do the
> counter adjustment after the key adjustments.
Right.
I reconfirmed that the current code handles these cases.

Following is the complete patch.

Andreas will it be possible for you to test this patch on your setup?

Will send an official patch once Andreas confirms things are working.

Thanks
Yogesh

---
 net/mac80211/ieee80211_i.h |    3 ++
 net/mac80211/key.c         |   51 ++++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/tx.c          |    7 +-----
 3 files changed, 53 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 090b0ec..2025af5 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -775,6 +775,9 @@ struct ieee80211_local {
 
 	int tx_headroom; /* required headroom for hardware/radiotap */
 
+	/* count for keys needing tailroom space allocation */
+	int crypto_tx_tailroom_needed_cnt;
+
 	/* Tasklet and skb queue to process calls from IRQ mode. All frames
 	 * added to skb_queue will be processed, but frames in
 	 * skb_queue_unreliable may be dropped if the total length of these
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index f825e2f..edf9f40 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -61,6 +61,36 @@ static struct ieee80211_sta *get_sta_for_key(struct ieee80211_key *key)
 	return NULL;
 }
 
+static void increment_tailroom_need_count(struct ieee80211_local *local)
+{
+	/*
+	 * When this count is zero, SKB resizing for allocating tailroom
+	 * for IV or MMIC is skipped. But, this check has created two race
+	 * cases in xmit path while transiting from zero count to one:
+	 *
+	 * 1. SKB resize was skipped because no key was added but just before
+	 * the xmit key is added and SW encryption kicks off.
+	 *
+	 * 2. SKB resize was skipped because all the keys were hw planted but
+	 * just before xmit one of the key is deleted and SW encryption kicks
+	 * off.
+	 *
+	 * In both the above case SW encryption will find not enough space for
+	 * tailroom and exits with WARN_ON. (See WARN_ONs at wpa.c)
+	 *
+	 * Solution has been explained at
+	 * http://markmail.org/message/c3ykchyv6azzmdum
+	 */
+
+	if (!local->crypto_tx_tailroom_needed_cnt++) {
+		/*
+		 * Flush all XMIT packets currently using HW encryption or no
+		 * encryption at all if the count transition is from 0 -> 1.
+		 */
+		synchronize_net();
+	}
+}
+
 static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 {
 	struct ieee80211_sub_if_data *sdata;
@@ -101,6 +131,11 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 
 	if (!ret) {
 		key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
+
+		if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
+		      (key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV)))
+			key->local->crypto_tx_tailroom_needed_cnt--;
+
 		return 0;
 	}
 
@@ -139,6 +174,10 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 	if (!(key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
 		return;
 
+	if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
+	      (key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV)))
+		increment_tailroom_need_count(key->local);
+
 	sta = get_sta_for_key(key);
 	sdata = key->sdata;
 
@@ -394,8 +433,10 @@ static void __ieee80211_key_destroy(struct ieee80211_key *key)
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
@@ -455,6 +496,8 @@ int ieee80211_key_link(struct ieee80211_key *key,
 	__ieee80211_key_replace(sdata, sta, pairwise, old_key, key);
 	__ieee80211_key_destroy(old_key);
 
+	increment_tailroom_need_count(key->local);
+
 	ieee80211_debugfs_key_add(key);
 
 	ret = ieee80211_key_enable_hw_accel(key);
@@ -498,8 +541,12 @@ void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata)
 
 	mutex_lock(&sdata->local->key_mtx);
 
-	list_for_each_entry(key, &sdata->key_list, list)
+	sdata->local->crypto_tx_tailroom_needed_cnt = 0;
+
+	list_for_each_entry(key, &sdata->key_list, list) {
+		increment_tailroom_need_count(sdata->local);
 		ieee80211_key_enable_hw_accel(key);
+	}
 
 	mutex_unlock(&sdata->local->key_mtx);
 }
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 3104c84..64e0f75 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1480,12 +1480,7 @@ static int ieee80211_skb_resize(struct ieee80211_local *local,
 {
 	int tail_need = 0;
 
-	/*
-	 * This could be optimised, devices that do full hardware
-	 * crypto (including TKIP MMIC) need no tailroom... But we
-	 * have no drivers for such devices currently.
-	 */
-	if (may_encrypt) {
+	if (may_encrypt && local->crypto_tx_tailroom_needed_cnt) {
 		tail_need = IEEE80211_ENCRYPT_TAILROOM;
 		tail_need -= skb_tailroom(skb);
 		tail_need = max_t(int, tail_need, 0);
-- 
1.5.4.1


