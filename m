Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42292 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab1GFKQe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 06:16:34 -0400
Message-Id: <20110706101558.466384440@sipsolutions.net> (sfid-20110706_121637_541845_ADF8A914)
Date: Wed, 06 Jul 2011 12:09:31 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] mac80211: fix CCMP PN race
References: <20110706100929.554431961@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since we can process multiple packets at the
same time for different ACs, but the PN is
allocated from a single counter, we need to
use an atomic value there. Use atomic64_t to
make this cheaper on 64-bit platforms, other
platforms will support this through software
emulation, see lib/atomic64.c.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         |   14 ++++++++------
 net/mac80211/debugfs_key.c |    6 ++++--
 net/mac80211/key.h         |    2 +-
 net/mac80211/wpa.c         |   19 ++++++++++---------
 4 files changed, 23 insertions(+), 18 deletions(-)

--- a/net/mac80211/key.h	2011-07-06 12:08:57.000000000 +0200
+++ b/net/mac80211/key.h	2011-07-06 12:09:07.000000000 +0200
@@ -82,7 +82,7 @@ struct ieee80211_key {
 			struct tkip_ctx rx[NUM_RX_DATA_QUEUES];
 		} tkip;
 		struct {
-			u8 tx_pn[6];
+			atomic64_t tx_pn;
 			/*
 			 * Last received packet number. The first
 			 * NUM_RX_DATA_QUEUES counters are used with Data
--- a/net/mac80211/cfg.c	2011-07-06 12:08:39.000000000 +0200
+++ b/net/mac80211/cfg.c	2011-07-06 12:09:07.000000000 +0200
@@ -209,6 +209,7 @@ static int ieee80211_get_key(struct wiph
 	u8 seq[6] = {0};
 	struct key_params params;
 	struct ieee80211_key *key = NULL;
+	u64 pn64;
 	u32 iv32;
 	u16 iv16;
 	int err = -ENOENT;
@@ -256,12 +257,13 @@ static int ieee80211_get_key(struct wiph
 		params.seq_len = 6;
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
-		seq[0] = key->u.ccmp.tx_pn[5];
-		seq[1] = key->u.ccmp.tx_pn[4];
-		seq[2] = key->u.ccmp.tx_pn[3];
-		seq[3] = key->u.ccmp.tx_pn[2];
-		seq[4] = key->u.ccmp.tx_pn[1];
-		seq[5] = key->u.ccmp.tx_pn[0];
+		pn64 = atomic64_read(&key->u.ccmp.tx_pn);
+		seq[0] = pn64;
+		seq[1] = pn64 >> 8;
+		seq[2] = pn64 >> 16;
+		seq[3] = pn64 >> 24;
+		seq[4] = pn64 >> 32;
+		seq[5] = pn64 >> 40;
 		params.seq = seq;
 		params.seq_len = 6;
 		break;
--- a/net/mac80211/wpa.c	2011-07-06 12:08:57.000000000 +0200
+++ b/net/mac80211/wpa.c	2011-07-06 12:09:07.000000000 +0200
@@ -380,8 +380,9 @@ static int ccmp_encrypt_skb(struct ieee8
 	struct ieee80211_key *key = tx->key;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	int hdrlen, len, tail;
-	u8 *pos, *pn;
-	int i;
+	u8 *pos;
+	u8 pn[6];
+	u64 pn64;
 
 	if (info->control.hw_key &&
 	    !(info->control.hw_key->flags & IEEE80211_KEY_FLAG_GENERATE_IV)) {
@@ -409,14 +410,14 @@ static int ccmp_encrypt_skb(struct ieee8
 	hdr = (struct ieee80211_hdr *) pos;
 	pos += hdrlen;
 
-	/* PN = PN + 1 */
-	pn = key->u.ccmp.tx_pn;
+	pn64 = atomic64_inc_return(&key->u.ccmp.tx_pn);
 
-	for (i = CCMP_PN_LEN - 1; i >= 0; i--) {
-		pn[i]++;
-		if (pn[i])
-			break;
-	}
+	pn[5] = pn64;
+	pn[4] = pn64 >> 8;
+	pn[3] = pn64 >> 16;
+	pn[2] = pn64 >> 24;
+	pn[1] = pn64 >> 32;
+	pn[0] = pn64 >> 40;
 
 	ccmp_pn2hdr(pos, pn, key->conf.keyidx);
 
--- a/net/mac80211/debugfs_key.c	2011-07-06 12:03:22.000000000 +0200
+++ b/net/mac80211/debugfs_key.c	2011-07-06 12:09:07.000000000 +0200
@@ -79,6 +79,7 @@ static ssize_t key_tx_spec_read(struct f
 				size_t count, loff_t *ppos)
 {
 	const u8 *tpn;
+	u64 pn;
 	char buf[20];
 	int len;
 	struct ieee80211_key *key = file->private_data;
@@ -94,9 +95,10 @@ static ssize_t key_tx_spec_read(struct f
 				key->u.tkip.tx.iv16);
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
-		tpn = key->u.ccmp.tx_pn;
+		pn = atomic64_read(&key->u.ccmp.tx_pn);
 		len = scnprintf(buf, sizeof(buf), "%02x%02x%02x%02x%02x%02x\n",
-				tpn[0], tpn[1], tpn[2], tpn[3], tpn[4], tpn[5]);
+				(u8)(pn >> 40), (u8)(pn >> 32), (u8)(pn >> 24),
+				(u8)(pn >> 16), (u8)(pn >> 8), (u8)pn);
 		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
 		tpn = key->u.aes_cmac.tx_pn;


