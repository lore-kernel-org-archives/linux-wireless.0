Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:50371 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367Ab1FPKez (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2011 06:34:55 -0400
Date: Thu, 16 Jun 2011 15:55:38 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Andreas Hartmann <andihartmann@01019freenet.de>
Subject: [PATCH 1/2] Revert "Revert "mac80211: Skip tailroom reservation
 for full HW-crypto devices""
Message-ID: <20110616102537.GA24458@hertz.marvell.com> (sfid-20110616_123458_584015_95A4383F)
References: <20110616102138.GA24447@hertz.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110616102138.GA24447@hertz.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit ab6a44ce1da48d35fe7ec95fa068aa617bd7e8dd.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 net/mac80211/ieee80211_i.h |    3 +++
 net/mac80211/key.c         |   21 +++++++++++++++++++--
 net/mac80211/tx.c          |    7 +------
 3 files changed, 23 insertions(+), 8 deletions(-)

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
index f825e2f..31afd712 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -101,6 +101,11 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 
 	if (!ret) {
 		key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
+
+		if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
+		      (key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV)))
+			key->local->crypto_tx_tailroom_needed_cnt--;
+
 		return 0;
 	}
 
@@ -156,6 +161,10 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 			  key->conf.keyidx, sta ? sta->addr : bcast_addr, ret);
 
 	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
+
+	if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
+	      (key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV)))
+		key->local->crypto_tx_tailroom_needed_cnt++;
 }
 
 void ieee80211_key_removed(struct ieee80211_key_conf *key_conf)
@@ -394,8 +403,10 @@ static void __ieee80211_key_destroy(struct ieee80211_key *key)
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
@@ -457,6 +468,8 @@ int ieee80211_key_link(struct ieee80211_key *key,
 
 	ieee80211_debugfs_key_add(key);
 
+	key->local->crypto_tx_tailroom_needed_cnt++;
+
 	ret = ieee80211_key_enable_hw_accel(key);
 
 	mutex_unlock(&sdata->local->key_mtx);
@@ -498,8 +511,12 @@ void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata)
 
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
1.7.5.4

