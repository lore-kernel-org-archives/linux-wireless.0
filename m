Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:48312 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab1FUNMK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 09:12:10 -0400
Date: Tue, 21 Jun 2011 18:33:06 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Andreas Hartmann <andihartmann@01019freenet.de>
Subject: Re: [PATCH 2/2] mac80211: Fixing Races for skipping tailroom
 reservation
Message-ID: <20110621130305.GB32464@hertz.marvell.com> (sfid-20110621_151214_947762_AAB716CC)
References: <20110616102138.GA24447@hertz.marvell.com>
 <20110616102707.GB24458@hertz.marvell.com>
 <d38dc36c1ab9a4bd819b9bcbbda181da@secure.sipsolutions.net>
 <20110617132527.GA27436@hertz.marvell.com>
 <1308331485.7329.2.camel@Nokia-N900-51-1>
 <20110620143051.GA31035@hertz.marvell.com>
 <1308583799.4322.9.camel@jlt3.sipsolutions.net>
 <7DDF37406E10F0438561DBB78326DF3902F5D190E2@SC-VEXCH1.marvell.com>
 <1308590980.4322.19.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1308590980.4322.19.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 20, 2011 at 10:29:40AM -0700, Johannes Berg wrote:
> On Mon, 2011-06-20 at 09:49 -0700, Yogesh Powar wrote:
> > >No, they're not, the mutex trickery seems completely pointless, and the
> > >conditional (on _is_locked no less) locking is horrible.
> > Ok.
> > 
> > Will spend some more time on exploring solutions using rcu primitives only
> > (synchronize_net or something similar).
> > 
> > If nothing  of only-RCU is feasible then, I think, we need to resize the skb if it has
> > already skipped the tailroom instead of WARN_ON. This will come in to picuture
> > only during the race cases. But this wont get rid of race.
> 
> Ahrg, seriously, just analyse the situation for once. Do I really need
> to do that?
> 
> There are two race cases, during transitions:
>  1) need to resize -> no need to (key moved to HW)
>  2) no need to resize -> need to (new key, ...)
> 
> The first is uninteresting, it's fine if the race happens and the skb is
> still resized even if it didn't need to.
> 
> The second one is what's causing issues. But the race happens like this:
>   - counter is 0
> 	- skb goes through tx start, no tailroom allocated
>   - key added, counter > 0
> 	- key lookup while TX processing is successful
> 
> So ... how can you solve it? Clearly, the locking attempts you made were
> pretty useless. But now that we understand the race, can we fix it? I
> think we can, by doing something like this:
> 
> 	counter++;
> 	/* flush packets being processed */
> 	synchronize_net();
> 	/* do whatever causes the key to be found by sw crypto */
> 
> That should be it. The only overhead is a little bit in control paths
> for key settings which are delayed a bit by synchronize_net(), but who
> cares, we don't change keys every packet.
> 
> Of course you need to encapsulate that code into a small function and
> write comments about why it's necessary and how it works.
> 
> Was that so hard? :-)
:( 

Following is the implementation based on your design.

Let me know if I miss anything here.

Thanks
Yogesh

---
 net/mac80211/key.c |   43 +++++++++++++++++++++++++++++++++++++------
 1 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 31afd71..4e0be17 100644
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
@@ -144,6 +174,10 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 	if (!(key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
 		return;
 
+	if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
+	      (key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV)))
+		increment_tailroom_need_count(key->local);
+
 	sta = get_sta_for_key(key);
 	sdata = key->sdata;
 
@@ -162,9 +196,6 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 
 	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
 
-	if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
-	      (key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV)))
-		key->local->crypto_tx_tailroom_needed_cnt++;
 }
 
 void ieee80211_key_removed(struct ieee80211_key_conf *key_conf)
@@ -466,9 +497,9 @@ int ieee80211_key_link(struct ieee80211_key *key,
 	__ieee80211_key_replace(sdata, sta, pairwise, old_key, key);
 	__ieee80211_key_destroy(old_key);
 
-	ieee80211_debugfs_key_add(key);
+	increment_tailroom_need_count(key->local);
 
-	key->local->crypto_tx_tailroom_needed_cnt++;
+	ieee80211_debugfs_key_add(key);
 
 	ret = ieee80211_key_enable_hw_accel(key);
 
@@ -514,7 +545,7 @@ void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata)
 	sdata->local->crypto_tx_tailroom_needed_cnt = 0;
 
 	list_for_each_entry(key, &sdata->key_list, list) {
-		sdata->local->crypto_tx_tailroom_needed_cnt++;
+		increment_tailroom_need_count(sdata->local);
 		ieee80211_key_enable_hw_accel(key);
 	}
 
-- 
1.5.4.1

