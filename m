Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:55198 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab1FVMkU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 08:40:20 -0400
Date: Wed, 22 Jun 2011 18:01:20 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Andreas Hartmann <andihartmann@01019freenet.de>
Subject: Re: [PATCH 2/2] mac80211: Fixing Races for skipping tailroom
 reservation
Message-ID: <20110622123118.GA4800@hertz.marvell.com> (sfid-20110622_144033_351476_D794548A)
References: <20110620143051.GA31035@hertz.marvell.com>
 <1308583799.4322.9.camel@jlt3.sipsolutions.net>
 <7DDF37406E10F0438561DBB78326DF3902F5D190E2@SC-VEXCH1.marvell.com>
 <1308590980.4322.19.camel@jlt3.sipsolutions.net>
 <20110621130305.GB32464@hertz.marvell.com>
 <1308663814.4276.3.camel@jlt3.sipsolutions.net>
 <20110621141017.GC32464@hertz.marvell.com>
 <1308667215.4276.7.camel@jlt3.sipsolutions.net>
 <20110621163351.GD32464@hertz.marvell.com>
 <20110622071743.GA4087@hertz.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110622071743.GA4087@hertz.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Will work on some other logic.

Following is the complete V2-patch

v2 changes: a) Moved counter++ before __ieee80211_key_replace in
		key_link()
	    b) Moved crypto_tx_tailroom_needed_cnt to sdata resolve
	        issue with multiple sdata instances in hw reset.
	    
Thanks
Yogesh

---
 net/mac80211/ieee80211_i.h |    3 ++
 net/mac80211/key.c         |   51 ++++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/tx.c          |   14 ++++-------
 3 files changed, 57 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 090b0ec..74c2f62 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -544,6 +544,9 @@ struct ieee80211_sub_if_data {
 	/* keys */
 	struct list_head key_list;
 
+	/* count for keys needing tailroom space allocation */
+	int crypto_tx_tailroom_needed_cnt;
+
 	struct net_device *dev;
 	struct ieee80211_local *local;
 
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index f825e2f..aea5a71 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -61,6 +61,36 @@ static struct ieee80211_sta *get_sta_for_key(struct ieee80211_key *key)
 	return NULL;
 }
 
+static void increment_tailroom_need_count(struct ieee80211_sub_if_data *sdata)
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
+	if (!sdata->crypto_tx_tailroom_needed_cnt++) {
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
+			sdata->crypto_tx_tailroom_needed_cnt--;
+
 		return 0;
 	}
 
@@ -142,6 +177,10 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 	sta = get_sta_for_key(key);
 	sdata = key->sdata;
 
+	if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
+	      (key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV)))
+		increment_tailroom_need_count(sdata);
+
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 		sdata = container_of(sdata->bss,
 				     struct ieee80211_sub_if_data,
@@ -394,8 +433,10 @@ static void __ieee80211_key_destroy(struct ieee80211_key *key)
 		ieee80211_aes_key_free(key->u.ccmp.tfm);
 	if (key->conf.cipher == WLAN_CIPHER_SUITE_AES_CMAC)
 		ieee80211_aes_cmac_key_free(key->u.aes_cmac.tfm);
-	if (key->local)
+	if (key->local) {
 		ieee80211_debugfs_key_remove(key);
+		key->sdata->crypto_tx_tailroom_needed_cnt--;
+	}
 
 	kfree(key);
 }
@@ -452,6 +493,8 @@ int ieee80211_key_link(struct ieee80211_key *key,
 	else
 		old_key = key_mtx_dereference(sdata->local, sdata->keys[idx]);
 
+	increment_tailroom_need_count(sdata);
+
 	__ieee80211_key_replace(sdata, sta, pairwise, old_key, key);
 	__ieee80211_key_destroy(old_key);
 
@@ -498,8 +541,12 @@ void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata)
 
 	mutex_lock(&sdata->local->key_mtx);
 
-	list_for_each_entry(key, &sdata->key_list, list)
+	sdata->crypto_tx_tailroom_needed_cnt = 0;
+
+	list_for_each_entry(key, &sdata->key_list, list) {
+		increment_tailroom_need_count(sdata);
 		ieee80211_key_enable_hw_accel(key);
+	}
 
 	mutex_unlock(&sdata->local->key_mtx);
 }
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 3104c84..e8d0d2d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1474,18 +1474,14 @@ static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
 
 /* device xmit handlers */
 
-static int ieee80211_skb_resize(struct ieee80211_local *local,
+static int ieee80211_skb_resize(struct ieee80211_sub_if_data *sdata,
 				struct sk_buff *skb,
 				int head_need, bool may_encrypt)
 {
+	struct ieee80211_local *local = sdata->local;
 	int tail_need = 0;
 
-	/*
-	 * This could be optimised, devices that do full hardware
-	 * crypto (including TKIP MMIC) need no tailroom... But we
-	 * have no drivers for such devices currently.
-	 */
-	if (may_encrypt) {
+	if (may_encrypt && sdata->crypto_tx_tailroom_needed_cnt) {
 		tail_need = IEEE80211_ENCRYPT_TAILROOM;
 		tail_need -= skb_tailroom(skb);
 		tail_need = max_t(int, tail_need, 0);
@@ -1578,7 +1574,7 @@ static void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
 	headroom -= skb_headroom(skb);
 	headroom = max_t(int, 0, headroom);
 
-	if (ieee80211_skb_resize(local, skb, headroom, may_encrypt)) {
+	if (ieee80211_skb_resize(sdata, skb, headroom, may_encrypt)) {
 		dev_kfree_skb(skb);
 		rcu_read_unlock();
 		return;
@@ -1945,7 +1941,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		head_need += IEEE80211_ENCRYPT_HEADROOM;
 		head_need += local->tx_headroom;
 		head_need = max_t(int, 0, head_need);
-		if (ieee80211_skb_resize(local, skb, head_need, true))
+		if (ieee80211_skb_resize(sdata, skb, head_need, true))
 			goto fail;
 	}
 
-- 
1.5.4.1

