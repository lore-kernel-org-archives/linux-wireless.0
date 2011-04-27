Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:49558 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759217Ab1D0NTG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2011 09:19:06 -0400
Date: Wed, 27 Apr 2011 18:40:29 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] mac80211: Skip tailroom reservation for full HW-crypto
 devices
Message-ID: <20110427131017.GA19537@hertz.marvell.com> (sfid-20110427_151910_715151_A6E95433)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In xmit path, devices that do full hardware crypto (including
TKIP MMIC) need no tailroom. For such devices, tailroom
reservation can be skipped if all the keys are programmed into
the hardware (i.e software crypto is not used for any of the
keys) and none of the keys wants software to generate Michael
MIC.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 net/mac80211/ieee80211_i.h |    3 +++
 net/mac80211/key.c         |   19 +++++++++++++++++--
 net/mac80211/tx.c          |    7 +------
 3 files changed, 21 insertions(+), 8 deletions(-)

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
index af3c564..ca3c626 100644
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
@@ -492,8 +503,12 @@ void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata)
 
 	mutex_lock(&sdata->local->key_mtx);
 
-	list_for_each_entry(key, &sdata->key_list, list)
+	sdata->local->crypto_tx_tailroom_needed_cnt = 0;
+
+	list_for_each_entry(key, &sdata->key_list, list) {
+		sdata->local->crypto_tx_tailroom_needed_cnt++;
 		ieee80211_key_enable_hw_accel(key);
+	}
 
 	mutex_unlock(&sdata->local->key_mtx);
 }
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index a2043e4..e3e3aa1 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1476,12 +1476,7 @@ static int ieee80211_skb_resize(struct ieee80211_local *local,
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

