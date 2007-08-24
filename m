Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45015 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758259AbXHXMb5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2007 08:31:57 -0400
Message-Id: <20070824122913.231672000@sipsolutions.net>
References: <20070824122705.549190000@sipsolutions.net>
Date: Fri, 24 Aug 2007 14:27:20 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 15/15] mac80211: make use of the new cfg80211 key threshold  notification
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes mac80211 use the cfg80211 facilities for key threshold
notification.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/cfg.c             |    1 +
 net/mac80211/ieee80211_ioctl.c |    3 ++-
 net/mac80211/ieee80211_key.h   |    4 +++-
 net/mac80211/key.c             |    3 ++-
 net/mac80211/rx.c              |   10 ++++++++--
 net/mac80211/tx.c              |   17 ++++++++++++-----
 6 files changed, 28 insertions(+), 10 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211_key.h	2007-08-24 14:11:42.149417211 +0200
+++ wireless-dev/net/mac80211/ieee80211_key.h	2007-08-24 14:18:16.959417211 +0200
@@ -86,6 +86,8 @@ struct ieee80211_key {
 
 	/* number of times this key has been used */
 	int tx_rx_count;
+	/* threshold for notification */
+	u32 tx_rx_threshold;
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct {
@@ -115,7 +117,7 @@ struct ieee80211_key {
 struct ieee80211_key *ieee80211_key_alloc(struct ieee80211_sub_if_data *sdata,
 					  struct sta_info *sta,
 					  ieee80211_key_alg alg,
-					  int idx,
+					  int idx, u32 threshold,
 					  size_t key_len,
 					  const u8 *key_data);
 void ieee80211_key_free(struct ieee80211_key *key);
--- wireless-dev.orig/net/mac80211/key.c	2007-08-24 14:13:37.299417211 +0200
+++ wireless-dev/net/mac80211/key.c	2007-08-24 14:18:16.959417211 +0200
@@ -124,7 +124,7 @@ void ieee80211_key_removed(struct ieee80
 struct ieee80211_key *ieee80211_key_alloc(struct ieee80211_sub_if_data *sdata,
 					  struct sta_info *sta,
 					  ieee80211_key_alg alg,
-					  int idx,
+					  int idx, u32 threshold,
 					  size_t key_len,
 					  const u8 *key_data)
 {
@@ -151,6 +151,7 @@ struct ieee80211_key *ieee80211_key_allo
 	key->local = sdata->local;
 	key->sdata = sdata;
 	key->sta = sta;
+	key->tx_rx_threshold = threshold;
 
 	if (alg == ALG_CCMP) {
 		/*
--- wireless-dev.orig/net/mac80211/cfg.c	2007-08-24 14:16:51.139417211 +0200
+++ wireless-dev/net/mac80211/cfg.c	2007-08-24 14:18:16.959417211 +0200
@@ -103,6 +103,7 @@ static int ieee80211_add_key(struct wiph
 
 	ret = 0;
 	if (!ieee80211_key_alloc(sdata, sta, alg, params->key_idx,
+				 params->threshold,
 				 params->key_len, params->key))
 		ret = -ENOMEM;
 
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-08-24 14:16:56.449417211 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-08-24 14:18:16.969417211 +0200
@@ -431,7 +431,8 @@ static int ieee80211_set_encryption(stru
 		 * set_key() callback becomes confused.
 		 */
 		ieee80211_key_free(key);
-		key = ieee80211_key_alloc(sdata, sta, alg, idx, key_len, _key);
+		key = ieee80211_key_alloc(sdata, sta, alg, idx, 0,
+					  key_len, _key);
 		if (!key) {
 			ret = -ENOMEM;
 			goto err_out;
--- wireless-dev.orig/net/mac80211/rx.c	2007-08-24 14:16:56.449417211 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-08-24 14:18:16.969417211 +0200
@@ -322,6 +322,7 @@ ieee80211_rx_h_load_key(struct ieee80211
 	int keyidx;
 	int hdrlen;
 	int trying_wep = 0;
+	u8 *sta_mac = NULL;
 
 	/*
 	 * Key selection 101
@@ -401,11 +402,16 @@ ieee80211_rx_h_load_key(struct ieee80211
 			trying_wep = 1;
 			goto find_by_index;
 		}
+		sta_mac = rx->sta->addr;
 	}
 
-	if (rx->key && (rx->flags & IEEE80211_TXRXD_RXRA_MATCH)) {
+	if (rx->key) {
 		rx->key->tx_rx_count++;
-		/* TODO: add threshold stuff again */
+		if (rx->key->tx_rx_threshold &&
+		    rx->key->tx_rx_count > rx->key->tx_rx_threshold)
+			cfg80211_key_threshold_notify(rx->key->sdata->dev,
+						      rx->key->conf.keyidx,
+						      sta_mac);
 	}
 
 	return TXRX_CONTINUE;
--- wireless-dev.orig/net/mac80211/tx.c	2007-08-24 14:16:56.459417211 +0200
+++ wireless-dev/net/mac80211/tx.c	2007-08-24 14:18:16.989417211 +0200
@@ -426,11 +426,14 @@ ieee80211_tx_h_ps_buf(struct ieee80211_t
 static ieee80211_txrx_result
 ieee80211_tx_h_select_key(struct ieee80211_txrx_data *tx)
 {
+	u8 *sta_mac = NULL;
+
 	if (unlikely(tx->u.tx.control->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT))
 		tx->key = NULL;
-	else if (tx->sta && tx->sta->key)
+	else if (tx->sta && tx->sta->key) {
+		sta_mac = tx->sta->addr;
 		tx->key = tx->sta->key;
-	else if (tx->sdata->default_key)
+	} else if (tx->sdata->default_key)
 		tx->key = tx->sdata->default_key;
 	else if (tx->sdata->drop_unencrypted &&
 		 !(tx->sdata->eapol && ieee80211_is_eapol(tx->skb))) {
@@ -441,9 +444,13 @@ ieee80211_tx_h_select_key(struct ieee802
 		tx->u.tx.control->flags |= IEEE80211_TXCTL_DO_NOT_ENCRYPT;
 	}
 
-	if (tx->key) {
-		tx->key->tx_rx_count++;
-		/* TODO: add threshold stuff again */
+        if (tx->key) {
+                tx->key->tx_rx_count++;
+		if (tx->key->tx_rx_threshold &&
+		    tx->key->tx_rx_count > tx->key->tx_rx_threshold)
+			cfg80211_key_threshold_notify(tx->key->sdata->dev,
+						      tx->key->conf.keyidx,
+						      sta_mac);
 	}
 
 	return TXRX_CONTINUE;

-- 

