Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40830 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625AbXH3OiJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 10:38:09 -0400
Subject: [PATCH] mac80211: fix race conditions with keys
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 30 Aug 2007 16:39:17 +0200
Message-Id: <1188484758.3978.18.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During receive processing, we select the key long before using it and
because there's no locking it is possible that we kfree() the key
after having selected it but before using it for crypto operations.
Obviously, this is bad.

Secondly, during transmit processing, there are two possible races: We
have a similar race between select_key() and using it for encryption,
but we also have a race here between select_key() and hardware
encryption (both when a key is removed.)

This patch solves these issues by using RCU: when a key is to be freed,
we first remove the pointer from the appropriate places (sdata->keys,
sdata->default_key, sta->key) using rcu_assign_pointer() and then
synchronize_rcu(). Then, we can safely kfree() the key and remove it
from the hardware. There's a window here where the hardware may still
be using it for decryption, but we can't work around that without having
two hardware callbacks, one to disable the key for RX and one to disable
it for TX; but the worst thing that will happen is that we receive a
packet decrypted that we don't find a key for any more and then drop it.

When we add a key, we first need to upload it to the hardware and then,
using rcu_assign_pointer() again, link it into our structures.

In the code using keys (TX/RX paths) we use rcu_dereference() to get the
key and enclose the whole tx/rx section in a rcu_read_lock() ...
rcu_read_unlock() block. Because we've uploaded the key to hardware
before linking it into internal structures, we can guarantee that it is
valid once get to into tx().

One possible race condition remains, however: when we have hardware
acceleration enabled and the driver shuts down the queues, we end up
queueing the frame. If now somebody removes the key, the key will be
removed from hwaccel and then then driver will be asked to encrypt the
frame with a key index that has been removed. Hence, drivers will need
to be aware that the hw_key_index they are passed might not be under
all circumstances. Most drivers will, however, simply ignore that
condition and encrypt the frame with the selected key anyway, this
only results in a frame being encrypted with a wrong key or dropped
(rightfully) because the key was not valid. There isn't much we can
do about it unless we want to walk the pending frame queue every time
a key is removed and remove all frames that used it.

This race condition, however, will most likely be solved once we add
multiqueue support to mac80211 because then frames will be queued
further up the stack instead of after being processed.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
As I've explained previously, refcounting keys as it appears Jiri wanted
to do it isn't possible without having huge complexity in the
driver/mac80211 interface because we're not supposed to give a two keys
for a given station.

 net/mac80211/ieee80211_ioctl.c |    5 ----
 net/mac80211/key.c             |   43 +++++++++++++++++++++++++----------------
 net/mac80211/rx.c              |   20 ++++++++++++++++---
 net/mac80211/tx.c              |   20 +++++++++++++++----
 4 files changed, 61 insertions(+), 27 deletions(-)

--- wireless-dev.orig/net/mac80211/key.c	2007-08-30 14:35:20.812051253 +0200
+++ wireless-dev/net/mac80211/key.c	2007-08-30 14:35:32.122051253 +0200
@@ -12,6 +12,7 @@
 #include <linux/if_ether.h>
 #include <linux/etherdevice.h>
 #include <linux/list.h>
+#include <linux/rcupdate.h>
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
 #include "debugfs_key.h"
@@ -120,6 +121,7 @@ struct ieee80211_key *ieee80211_key_allo
 {
 	struct ieee80211_key *key;
 
+	BUG_ON(idx < 0 || idx >= NUM_DEFAULT_KEYS);
 	BUG_ON(alg == ALG_NONE);
 
 	key = kzalloc(sizeof(struct ieee80211_key) + key_len, GFP_KERNEL);
@@ -157,9 +159,15 @@ struct ieee80211_key *ieee80211_key_allo
 
 	ieee80211_debugfs_key_add(key->local, key);
 
+	/* remove key first */
+	if (sta)
+		ieee80211_key_free(sta->key);
+	else
+		ieee80211_key_free(sdata->keys[idx]);
+
 	if (sta) {
 		ieee80211_debugfs_key_sta_link(key, sta);
-		sta->key = key;
+
 		/*
 		 * some hardware cannot handle TKIP with QoS, so
 		 * we indicate whether QoS could be in use.
@@ -179,21 +187,19 @@ struct ieee80211_key *ieee80211_key_allo
 				sta_info_put(ap);
 			}
 		}
-
-		if (idx >= 0 && idx < NUM_DEFAULT_KEYS) {
-			if (!sdata->keys[idx])
-				sdata->keys[idx] = key;
-			else
-				WARN_ON(1);
-		} else
-			WARN_ON(1);
 	}
 
-	list_add(&key->list, &sdata->key_list);
-
+	/* enable hwaccel if appropriate */
 	if (netif_running(key->sdata->dev))
 		ieee80211_key_enable_hw_accel(key);
 
+	if (sta)
+		rcu_assign_pointer(sta->key, key);
+	else
+		rcu_assign_pointer(sdata->keys[idx], key);
+
+	list_add(&key->list, &sdata->key_list);
+
 	return key;
 }
 
@@ -202,20 +208,25 @@ void ieee80211_key_free(struct ieee80211
 	if (!key)
 		return;
 
-	ieee80211_key_disable_hw_accel(key);
-
 	if (key->sta) {
-		key->sta->key = NULL;
+		rcu_assign_pointer(key->sta->key, NULL);
 	} else {
 		if (key->sdata->default_key == key)
 			ieee80211_set_default_key(key->sdata, -1);
 		if (key->conf.keyidx >= 0 &&
 		    key->conf.keyidx < NUM_DEFAULT_KEYS)
-			key->sdata->keys[key->conf.keyidx] = NULL;
+			rcu_assign_pointer(key->sdata->keys[key->conf.keyidx],
+					   NULL);
 		else
 			WARN_ON(1);
 	}
 
+	/* wait for all key users to complete */
+	synchronize_rcu();
+
+	/* remove from hwaccel if appropriate */
+	ieee80211_key_disable_hw_accel(key);
+
 	if (key->conf.alg == ALG_CCMP)
 		ieee80211_aes_key_free(key->u.ccmp.tfm);
 	ieee80211_debugfs_key_remove(key);
@@ -235,7 +246,7 @@ void ieee80211_set_default_key(struct ie
 	if (sdata->default_key != key) {
 		ieee80211_debugfs_key_remove_default(sdata);
 
-		sdata->default_key = key;
+		rcu_assign_pointer(sdata->default_key, key);
 
 		if (sdata->default_key)
 			ieee80211_debugfs_key_add_default(sdata);
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-08-30 14:35:20.832051253 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-08-30 14:35:32.122051253 +0200
@@ -420,11 +420,8 @@ static int ieee80211_set_encryption(stru
 		key = NULL;
 	} else {
 		/*
-		 * Need to free it before allocating a new one with
-		 * with the same index or the ordering to the driver's
-		 * set_key() callback becomes confused.
+		 * Automatically frees any old key if present.
 		 */
-		ieee80211_key_free(key);
 		key = ieee80211_key_alloc(sdata, sta, alg, idx, key_len, _key);
 		if (!key) {
 			ret = -ENOMEM;
--- wireless-dev.orig/net/mac80211/rx.c	2007-08-30 14:35:20.882051253 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-08-30 14:35:32.132051253 +0200
@@ -13,6 +13,7 @@
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
+#include <linux/rcupdate.h>
 #include <net/mac80211.h>
 #include <net/ieee80211_radiotap.h>
 
@@ -321,6 +322,7 @@ ieee80211_rx_h_load_key(struct ieee80211
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
 	int keyidx;
 	int hdrlen;
+	struct ieee80211_key *stakey = NULL;
 
 	/*
 	 * Key selection 101
@@ -358,8 +360,11 @@ ieee80211_rx_h_load_key(struct ieee80211
 	if (!(rx->flags & IEEE80211_TXRXD_RXRA_MATCH))
 		return TXRX_CONTINUE;
 
-	if (!is_multicast_ether_addr(hdr->addr1) && rx->sta && rx->sta->key) {
-		rx->key = rx->sta->key;
+	if (rx->sta)
+		stakey = rcu_dereference(rx->sta->key);
+
+	if (!is_multicast_ether_addr(hdr->addr1) && stakey) {
+		rx->key = stakey;
 	} else {
 		/*
 		 * The device doesn't give us the IV so we won't be
@@ -384,7 +389,7 @@ ieee80211_rx_h_load_key(struct ieee80211
 		 */
 		keyidx = rx->skb->data[hdrlen + 3] >> 6;
 
-		rx->key = rx->sdata->keys[keyidx];
+		rx->key = rcu_dereference(rx->sdata->keys[keyidx]);
 
 		/*
 		 * RSNA-protected unicast frames should always be sent with
@@ -1512,6 +1517,12 @@ void __ieee80211_rx(struct ieee80211_hw 
 		skb_pull(skb, radiotap_len);
 	}
 
+	/*
+	 * key references are protected using RCU and this requires that
+	 * we are in a read-site RCU section during receive processing
+	 */
+	rcu_read_lock();
+
 	hdr = (struct ieee80211_hdr *) skb->data;
 	memset(&rx, 0, sizeof(rx));
 	rx.skb = skb;
@@ -1552,6 +1563,7 @@ void __ieee80211_rx(struct ieee80211_hw 
 		ieee80211_invoke_rx_handlers(local, local->rx_handlers, &rx,
 					     rx.sta);
 		sta_info_put(sta);
+		rcu_read_unlock();
 		return;
 	}
 
@@ -1613,6 +1625,8 @@ void __ieee80211_rx(struct ieee80211_hw 
 	read_unlock(&local->sub_if_lock);
 
  end:
+	rcu_read_unlock();
+
 	if (sta)
 		sta_info_put(sta);
 }
--- wireless-dev.orig/net/mac80211/tx.c	2007-08-30 14:35:31.502051253 +0200
+++ wireless-dev/net/mac80211/tx.c	2007-08-30 14:35:32.132051253 +0200
@@ -17,6 +17,7 @@
 #include <linux/skbuff.h>
 #include <linux/etherdevice.h>
 #include <linux/bitmap.h>
+#include <linux/rcupdate.h>
 #include <net/ieee80211_radiotap.h>
 #include <net/cfg80211.h>
 #include <net/mac80211.h>
@@ -426,14 +427,16 @@ ieee80211_tx_h_ps_buf(struct ieee80211_t
 static ieee80211_txrx_result
 ieee80211_tx_h_select_key(struct ieee80211_txrx_data *tx)
 {
+	struct ieee80211_key *key;
+
 	tx->u.tx.control->key_idx = HW_KEY_IDX_INVALID;
 
 	if (unlikely(tx->u.tx.control->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT))
 		tx->key = NULL;
-	else if (tx->sta && tx->sta->key)
-		tx->key = tx->sta->key;
-	else if (tx->sdata->default_key)
-		tx->key = tx->sdata->default_key;
+	else if (tx->sta && (key = rcu_dereference(tx->sta->key)))
+		tx->key = key;
+	else if ((key = rcu_dereference(tx->sdata->default_key)))
+		tx->key = key;
 	else if (tx->sdata->drop_unencrypted &&
 		 !(tx->sdata->eapol && ieee80211_is_eapol(tx->skb))) {
 		I802_DEBUG_INC(tx->local->tx_handlers_drop_unencrypted);
@@ -1111,6 +1114,12 @@ static int ieee80211_tx(struct net_devic
 		return 0;
 	}
 
+	/*
+	 * key references are protected using RCU and this requires that
+	 * we are in a read-site RCU section during receive processing
+	 */
+	rcu_read_lock();
+
 	sta = tx.sta;
 	tx.u.tx.mgmt_interface = mgmt;
 	tx.u.tx.mode = local->hw.conf.mode;
@@ -1138,6 +1147,7 @@ static int ieee80211_tx(struct net_devic
 
 	if (unlikely(res == TXRX_QUEUED)) {
 		I802_DEBUG_INC(local->tx_handlers_queued);
+		rcu_read_unlock();
 		return 0;
 	}
 
@@ -1195,6 +1205,7 @@ retry:
 		store->last_frag_rate_ctrl_probe =
 			!!(tx.flags & IEEE80211_TXRXD_TXPROBE_LAST_FRAG);
 	}
+	rcu_read_unlock();
 	return 0;
 
  drop:
@@ -1204,6 +1215,7 @@ retry:
 		if (tx.u.tx.extra_frag[i])
 			dev_kfree_skb(tx.u.tx.extra_frag[i]);
 	kfree(tx.u.tx.extra_frag);
+	rcu_read_unlock();
 	return 0;
 }
 


