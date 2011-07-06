Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58235 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997Ab1GFT7j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 15:59:39 -0400
Subject: [PATCH 2/2 v2] mac80211: fix CCMP races
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20110706101558.466384440@sipsolutions.net> (sfid-20110706_121637_541845_ADF8A914)
References: <20110706100929.554431961@sipsolutions.net>
	 <20110706101558.466384440@sipsolutions.net>
	 (sfid-20110706_121637_541845_ADF8A914)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jul 2011 21:59:39 +0200
Message-ID: <1309982379.3893.12.camel@jlt3.sipsolutions.net> (sfid-20110706_215944_357761_1405ACC2)
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

We also need to use an on-stack scratch buf
so that multiple packets won't corrupt each
others scratch buffers.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         |   14 ++++++++------
 net/mac80211/debugfs_key.c |    6 ++++--
 net/mac80211/key.h         |    5 +----
 net/mac80211/wpa.c         |   32 +++++++++++++++++++-------------
 4 files changed, 32 insertions(+), 25 deletions(-)

--- a/net/mac80211/key.h	2011-07-06 21:40:12.000000000 +0200
+++ b/net/mac80211/key.h	2011-07-06 21:59:19.000000000 +0200
@@ -82,7 +82,7 @@ struct ieee80211_key {
 			struct tkip_ctx rx[NUM_RX_DATA_QUEUES];
 		} tkip;
 		struct {
-			u8 tx_pn[6];
+			atomic64_t tx_pn;
 			/*
 			 * Last received packet number. The first
 			 * NUM_RX_DATA_QUEUES counters are used with Data
@@ -92,12 +92,9 @@ struct ieee80211_key {
 			u8 rx_pn[NUM_RX_DATA_QUEUES + 1][6];
 			struct crypto_cipher *tfm;
 			u32 replays; /* dot11RSNAStatsCCMPReplays */
-			/* scratch buffers for virt_to_page() (crypto API) */
 #ifndef AES_BLOCK_LEN
 #define AES_BLOCK_LEN 16
 #endif
-			u8 tx_crypto_buf[6 * AES_BLOCK_LEN];
-			u8 rx_crypto_buf[6 * AES_BLOCK_LEN];
 		} ccmp;
 		struct {
 			u8 tx_pn[6];
--- a/net/mac80211/cfg.c	2011-07-06 21:40:12.000000000 +0200
+++ b/net/mac80211/cfg.c	2011-07-06 21:59:19.000000000 +0200
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
--- a/net/mac80211/wpa.c	2011-07-06 21:40:12.000000000 +0200
+++ b/net/mac80211/wpa.c	2011-07-06 21:59:19.000000000 +0200
@@ -15,6 +15,7 @@
 #include <linux/gfp.h>
 #include <asm/unaligned.h>
 #include <net/mac80211.h>
+#include <crypto/aes.h>
 
 #include "ieee80211_i.h"
 #include "michael.h"
@@ -290,6 +291,8 @@ static void ccmp_special_blocks(struct s
 	unsigned int hdrlen;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 
+	memset(scratch, 0, 6 * AES_BLOCK_LEN);
+
 	b_0 = scratch + 3 * AES_BLOCK_LEN;
 	aad = scratch + 4 * AES_BLOCK_LEN;
 
@@ -380,8 +383,10 @@ static int ccmp_encrypt_skb(struct ieee8
 	struct ieee80211_key *key = tx->key;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	int hdrlen, len, tail;
-	u8 *pos, *pn;
-	int i;
+	u8 *pos;
+	u8 pn[6];
+	u64 pn64;
+	u8 scratch[6 * AES_BLOCK_LEN];
 
 	if (info->control.hw_key &&
 	    !(info->control.hw_key->flags & IEEE80211_KEY_FLAG_GENERATE_IV)) {
@@ -409,14 +414,14 @@ static int ccmp_encrypt_skb(struct ieee8
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
 
@@ -425,8 +430,8 @@ static int ccmp_encrypt_skb(struct ieee8
 		return 0;
 
 	pos += CCMP_HDR_LEN;
-	ccmp_special_blocks(skb, pn, key->u.ccmp.tx_crypto_buf, 0);
-	ieee80211_aes_ccm_encrypt(key->u.ccmp.tfm, key->u.ccmp.tx_crypto_buf, pos, len,
+	ccmp_special_blocks(skb, pn, scratch, 0);
+	ieee80211_aes_ccm_encrypt(key->u.ccmp.tfm, scratch, pos, len,
 				  pos, skb_put(skb, CCMP_MIC_LEN));
 
 	return 0;
@@ -482,11 +487,12 @@ ieee80211_crypto_ccmp_decrypt(struct iee
 	}
 
 	if (!(status->flag & RX_FLAG_DECRYPTED)) {
+		u8 scratch[6 * AES_BLOCK_LEN];
 		/* hardware didn't decrypt/verify MIC */
-		ccmp_special_blocks(skb, pn, key->u.ccmp.rx_crypto_buf, 1);
+		ccmp_special_blocks(skb, pn, scratch, 1);
 
 		if (ieee80211_aes_ccm_decrypt(
-			    key->u.ccmp.tfm, key->u.ccmp.rx_crypto_buf,
+			    key->u.ccmp.tfm, scratch,
 			    skb->data + hdrlen + CCMP_HDR_LEN, data_len,
 			    skb->data + skb->len - CCMP_MIC_LEN,
 			    skb->data + hdrlen + CCMP_HDR_LEN))
--- a/net/mac80211/debugfs_key.c	2011-07-06 21:39:54.000000000 +0200
+++ b/net/mac80211/debugfs_key.c	2011-07-06 21:59:19.000000000 +0200
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


