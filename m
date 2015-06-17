Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46749 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493AbbFQIlV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 04:41:21 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 09/14] mac80211: remove key TX/RX counter
Date: Wed, 17 Jun 2015 10:41:10 +0200
Message-Id: <1434530475-3553-10-git-send-email-johannes@sipsolutions.net> (sfid-20150617_104142_436500_C1175329)
In-Reply-To: <1434530475-3553-1-git-send-email-johannes@sipsolutions.net>
References: <1434530475-3553-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This counter is inherently racy (since it can be incremented by RX
as well as by concurrent TX) and only available in debugfs. Instead
of fixing it to be per-CPU or similar, remove it for now. If needed
it should be added without races and with proper nl80211, perhaps
even addressing the threshold reporting TODO item that's been there
since the code was originally added.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs_key.c | 2 --
 net/mac80211/key.h         | 3 ---
 net/mac80211/rx.c          | 1 -
 net/mac80211/tx.c          | 1 -
 4 files changed, 7 deletions(-)

diff --git a/net/mac80211/debugfs_key.c b/net/mac80211/debugfs_key.c
index e82bf1e9d7a8..702ca122c498 100644
--- a/net/mac80211/debugfs_key.c
+++ b/net/mac80211/debugfs_key.c
@@ -57,7 +57,6 @@ KEY_CONF_FILE(keylen, D);
 KEY_CONF_FILE(keyidx, D);
 KEY_CONF_FILE(hw_key_idx, D);
 KEY_FILE(flags, X);
-KEY_FILE(tx_rx_count, D);
 KEY_READ(ifindex, sdata->name, "%s\n");
 KEY_OPS(ifindex);
 
@@ -310,7 +309,6 @@ void ieee80211_debugfs_key_add(struct ieee80211_key *key)
 	DEBUGFS_ADD(flags);
 	DEBUGFS_ADD(keyidx);
 	DEBUGFS_ADD(hw_key_idx);
-	DEBUGFS_ADD(tx_rx_count);
 	DEBUGFS_ADD(algorithm);
 	DEBUGFS_ADD(tx_spec);
 	DEBUGFS_ADD(rx_spec);
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index 3f4f9eaac140..9951ef06323e 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -115,9 +115,6 @@ struct ieee80211_key {
 		} gen;
 	} u;
 
-	/* number of times this key has been used */
-	int tx_rx_count;
-
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct {
 		struct dentry *stalink;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 9d95cb8e8e95..3037bd152ffa 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1682,7 +1682,6 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 		if (unlikely(rx->key->flags & KEY_FLAG_TAINTED))
 			return RX_DROP_MONITOR;
 
-		rx->key->tx_rx_count++;
 		/* TODO: add threshold stuff again */
 	} else {
 		return RX_DROP_MONITOR;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8410bb3bf5e8..87b9b4e27d22 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -610,7 +610,6 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 	if (tx->key) {
 		bool skip_hw = false;
 
-		tx->key->tx_rx_count++;
 		/* TODO: add threshold stuff again */
 
 		switch (tx->key->conf.cipher) {
-- 
2.1.4

