Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:54959 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754020AbZEKS7B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 14:59:01 -0400
Message-Id: <20090511185854.338687878@atheros.com>
References: <20090511185754.653711567@atheros.com>
Date: Mon, 11 May 2009 21:57:58 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 4/4] nl80211: Add RSC configuration for new keys
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When setting a key with NL80211_CMD_NEW_KEY, we should allow the key
sequence number (RSC) to be set in order to allow replay protection to
work correctly for group keys. This patch documents this use for
nl80211 and adds the couple of missing pieces in nl80211/cfg80211 and
mac80211 to support this. In addition, WEXT SIOCSIWENCODEEXT compat
processing in cfg80211 is extended to handle the RSC (this was already
specified in WEXT, but just not implemented in cfg80211/mac80211).

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 include/linux/nl80211.h    |    4 ++--
 net/mac80211/cfg.c         |    3 ++-
 net/mac80211/key.c         |   21 ++++++++++++++++++++-
 net/mac80211/key.h         |    3 ++-
 net/wireless/nl80211.c     |    5 +++++
 net/wireless/wext-compat.c |    5 +++++
 6 files changed, 36 insertions(+), 5 deletions(-)

--- uml.orig/include/linux/nl80211.h	2009-05-11 21:39:26.000000000 +0300
+++ uml/include/linux/nl80211.h	2009-05-11 21:39:27.000000000 +0300
@@ -79,8 +79,8 @@
  * @NL80211_CMD_SET_KEY: Set key attributes %NL80211_ATTR_KEY_DEFAULT,
  *	%NL80211_ATTR_KEY_DEFAULT_MGMT, or %NL80211_ATTR_KEY_THRESHOLD.
  * @NL80211_CMD_NEW_KEY: add a key with given %NL80211_ATTR_KEY_DATA,
- *	%NL80211_ATTR_KEY_IDX, %NL80211_ATTR_MAC and %NL80211_ATTR_KEY_CIPHER
- *	attributes.
+ *	%NL80211_ATTR_KEY_IDX, %NL80211_ATTR_MAC, %NL80211_ATTR_KEY_CIPHER,
+ *	and %NL80211_ATTR_KEY_SEQ attributes.
  * @NL80211_CMD_DEL_KEY: delete a key identified by %NL80211_ATTR_KEY_IDX
  *	or %NL80211_ATTR_MAC.
  *
--- uml.orig/net/wireless/nl80211.c	2009-05-11 21:39:26.000000000 +0300
+++ uml/net/wireless/nl80211.c	2009-05-11 21:39:27.000000000 +0300
@@ -1115,6 +1115,11 @@ static int nl80211_new_key(struct sk_buf
 		params.key_len = nla_len(info->attrs[NL80211_ATTR_KEY_DATA]);
 	}
 
+	if (info->attrs[NL80211_ATTR_KEY_SEQ]) {
+		params.seq = nla_data(info->attrs[NL80211_ATTR_KEY_SEQ]);
+		params.seq_len = nla_len(info->attrs[NL80211_ATTR_KEY_SEQ]);
+	}
+
 	if (info->attrs[NL80211_ATTR_KEY_IDX])
 		key_idx = nla_get_u8(info->attrs[NL80211_ATTR_KEY_IDX]);
 
--- uml.orig/net/mac80211/cfg.c	2009-05-11 21:39:26.000000000 +0300
+++ uml/net/mac80211/cfg.c	2009-05-11 21:39:27.000000000 +0300
@@ -141,7 +141,8 @@ static int ieee80211_add_key(struct wiph
 		return -EINVAL;
 	}
 
-	key = ieee80211_key_alloc(alg, key_idx, params->key_len, params->key);
+	key = ieee80211_key_alloc(alg, key_idx, params->key_len, params->key,
+				  params->seq_len, params->seq);
 	if (!key)
 		return -ENOMEM;
 
--- uml.orig/net/mac80211/key.c	2009-05-11 21:39:08.000000000 +0300
+++ uml/net/mac80211/key.c	2009-05-11 21:39:27.000000000 +0300
@@ -290,9 +290,11 @@ static void __ieee80211_key_replace(stru
 struct ieee80211_key *ieee80211_key_alloc(enum ieee80211_key_alg alg,
 					  int idx,
 					  size_t key_len,
-					  const u8 *key_data)
+					  const u8 *key_data,
+					  size_t seq_len, const u8 *seq)
 {
 	struct ieee80211_key *key;
+	int i, j;
 
 	BUG_ON(idx < 0 || idx >= NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS);
 
@@ -318,14 +320,31 @@ struct ieee80211_key *ieee80211_key_allo
 	case ALG_TKIP:
 		key->conf.iv_len = TKIP_IV_LEN;
 		key->conf.icv_len = TKIP_ICV_LEN;
+		if (seq && seq_len == 6) {
+			for (i = 0; i < NUM_RX_DATA_QUEUES; i++) {
+				key->u.tkip.rx[i].iv32 =
+					get_unaligned_le32(&seq[2]);
+				key->u.tkip.rx[i].iv16 =
+					get_unaligned_le16(seq);
+			}
+		}
 		break;
 	case ALG_CCMP:
 		key->conf.iv_len = CCMP_HDR_LEN;
 		key->conf.icv_len = CCMP_MIC_LEN;
+		if (seq && seq_len == CCMP_PN_LEN) {
+			for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
+				for (j = 0; j < CCMP_PN_LEN; j++)
+					key->u.ccmp.rx_pn[i][j] =
+						seq[CCMP_PN_LEN - j - 1];
+		}
 		break;
 	case ALG_AES_CMAC:
 		key->conf.iv_len = 0;
 		key->conf.icv_len = sizeof(struct ieee80211_mmie);
+		if (seq && seq_len == 6)
+			for (j = 0; j < 6; j++)
+				key->u.aes_cmac.rx_pn[j] = seq[6 - j - 1];
 		break;
 	}
 	memcpy(key->conf.key, key_data, key_len);
--- uml.orig/net/mac80211/key.h	2009-05-11 21:39:08.000000000 +0300
+++ uml/net/mac80211/key.h	2009-05-11 21:39:27.000000000 +0300
@@ -144,7 +144,8 @@ struct ieee80211_key {
 struct ieee80211_key *ieee80211_key_alloc(enum ieee80211_key_alg alg,
 					  int idx,
 					  size_t key_len,
-					  const u8 *key_data);
+					  const u8 *key_data,
+					  size_t seq_len, const u8 *seq);
 /*
  * Insert a key into data structures (sdata, sta if necessary)
  * to make it used, free old key.
--- uml.orig/net/wireless/wext-compat.c	2009-05-11 21:39:21.000000000 +0300
+++ uml/net/wireless/wext-compat.c	2009-05-11 21:39:27.000000000 +0300
@@ -655,6 +655,11 @@ int cfg80211_wext_siwencodeext(struct ne
 	params.key_len = ext->key_len;
 	params.cipher = cipher;
 
+	if (ext->ext_flags & IW_ENCODE_EXT_RX_SEQ_VALID) {
+		params.seq = ext->rx_seq;
+		params.seq_len = 6;
+	}
+
 	return cfg80211_set_encryption(
 			rdev, dev, addr, remove,
 			ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY,

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
