Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:35651 "EHLO
	mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbcAENGO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 08:06:14 -0500
Received: by mail-lf0-f48.google.com with SMTP id c192so117342915lfe.2
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jan 2016 05:06:13 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, nbd@openwrt.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFC/RFT v3] mac80211: Add NEED_ALIGNED4_SKBS hw flag
Date: Tue,  5 Jan 2016 14:06:01 +0100
Message-Id: <1451999161-7286-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20160105_140619_374029_96A7AFB0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HW/driver should set NEED_ALIGNED4_SKBS flag in case require
aligned skbs to four-byte boundaries.

Before we have to do memmove() in the driver before
pass this to HW and memmove() back in tx completion.
This patch allow to save CPU and skip such memmoves.
For each skb we call memmove(ieee80211_hdrsize()) twice.

Currently this was tested with ath9k, both hw/sw crypt for
tkip/ccmp.
For sure more tests required.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
V3: remove padding for monitor iface
 include/net/mac80211.h     |  4 ++++
 net/mac80211/debugfs.c     |  1 +
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/sta_info.h    |  4 ++--
 net/mac80211/status.c      | 13 +++++++++++++
 net/mac80211/tkip.c        | 15 ++++++++++++---
 net/mac80211/tx.c          | 38 +++++++++++++++++++++++++++++++++-----
 net/mac80211/util.c        |  7 ++++++-
 net/mac80211/wep.c         | 11 ++++++-----
 net/mac80211/wep.h         |  1 +
 net/mac80211/wpa.c         | 14 ++++++--------
 11 files changed, 85 insertions(+), 24 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7c30faf..0ea9b51 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1910,6 +1910,9 @@ struct ieee80211_txq {
  *	by just its MAC address; this prevents, for example, the same station
  *	from connecting to two virtual AP interfaces at the same time.
  *
+ * @IEEE80211_HW_NEEDS_ALIGNED4_SKBS: Driver need aligned skbs to four-byte.
+ *	Padding will be added after ieee80211_hdr.
+ *
  * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
  */
 enum ieee80211_hw_flags {
@@ -1946,6 +1949,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SUPPORTS_AMSDU_IN_AMPDU,
 	IEEE80211_HW_BEACON_TX_STATUS,
 	IEEE80211_HW_NEEDS_UNIQUE_STA_ADDR,
+	IEEE80211_HW_NEEDS_ALIGNED4_SKBS,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index abbdff0..fd45830 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -126,6 +126,7 @@ static const char *hw_flag_names[NUM_IEEE80211_HW_FLAGS + 1] = {
 	FLAG(SUPPORTS_AMSDU_IN_AMPDU),
 	FLAG(BEACON_TX_STATUS),
 	FLAG(NEEDS_UNIQUE_STA_ADDR),
+	FLAG(NEEDS_ALIGNED4_SKBS),
 
 	/* keep last for the build bug below */
 	(void *)0x1
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c30b684..c5e1b46 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -172,6 +172,7 @@ struct ieee80211_tx_data {
 	struct ieee80211_tx_rate rate;
 
 	unsigned int flags;
+	unsigned int hdrlen;
 };
 
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index d605162..3e1cd70 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -268,8 +268,8 @@ struct ieee80211_fast_tx {
 	u8 hdr_len;
 	u8 sa_offs, da_offs, pn_offs;
 	u8 band;
-	u8 hdr[30 + 2 + IEEE80211_FAST_XMIT_MAX_IV +
-	       sizeof(rfc1042_header)];
+	u8 hdr[round_up(30 + 2 + IEEE80211_FAST_XMIT_MAX_IV +
+			sizeof(rfc1042_header), 4)];
 
 	struct rcu_head rcu_head;
 };
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 5bad05e..dbb2dde 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -678,9 +678,22 @@ void ieee80211_tx_monitor(struct ieee80211_local *local, struct sk_buff *skb,
 	struct sk_buff *skb2;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct net_device *prev_dev = NULL;
+	unsigned int padsize, hdrlen;
 	int rtap_len;
 
+	/* Remove padding if was added */
+	if (ieee80211_hw_check(&local->hw, NEEDS_ALIGNED4_SKBS)) {
+		hdrlen = ieee80211_hdrlen(hdr->frame_control);
+		padsize = hdrlen & 3;
+
+		if (padsize && skb->len > hdrlen + padsize) {
+			memmove(skb->data + padsize, skb->data, hdrlen);
+			skb_pull(skb, padsize);
+		}
+	}
+
 	/* send frame to monitor interfaces now */
 	rtap_len = ieee80211_tx_radiotap_len(info);
 	if (WARN_ON_ONCE(skb_headroom(skb) < rtap_len)) {
diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index 0ae2077..26b2663 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -204,9 +204,18 @@ void ieee80211_get_tkip_p2k(struct ieee80211_key_conf *keyconf,
 	const u8 *tk = &key->conf.key[NL80211_TKIP_DATA_OFFSET_ENCR_KEY];
 	struct tkip_ctx *ctx = &key->u.tkip.tx;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	const u8 *data = (u8 *)hdr + ieee80211_hdrlen(hdr->frame_control);
-	u32 iv32 = get_unaligned_le32(&data[4]);
-	u16 iv16 = data[2] | (data[0] << 8);
+	unsigned int hdrlen;
+	const u8 *data;
+	u32 iv32;
+	u16 iv16;
+
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	if (ieee80211_hw_check(&key->local->hw, NEEDS_ALIGNED4_SKBS))
+		hdrlen += hdrlen & 3;
+
+	data = (u8 *)hdr + hdrlen;
+	iv32 = get_unaligned_le32(&data[4]);
+	iv16 = data[2] | (data[0] << 8);
 
 	spin_lock(&key->u.tkip.txlock);
 	ieee80211_compute_tkip_p1k(key, iv32);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 431401b..6ea1c65 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -205,6 +205,20 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
 
 /* tx handlers */
 static ieee80211_tx_result debug_noinline
+ieee80211_tx_h_hdrlen_add(struct ieee80211_tx_data *tx)
+{
+	struct ieee80211_hw *hw = &tx->local->hw;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
+
+	tx->hdrlen = ieee80211_hdrlen(hdr->frame_control);
+
+	if (ieee80211_hw_check(hw, NEEDS_ALIGNED4_SKBS))
+		tx->hdrlen += tx->hdrlen & 3;
+
+	return TX_CONTINUE;
+}
+
+static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_local *local = tx->local;
@@ -915,7 +929,7 @@ ieee80211_tx_h_fragment(struct ieee80211_tx_data *tx)
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	int frag_threshold = tx->local->hw.wiphy->frag_threshold;
-	int hdrlen;
+	int hdrlen = tx->hdrlen;
 	int fragnum;
 
 	/* no matter what happens, tx->skb moves to tx->skbs */
@@ -936,8 +950,6 @@ ieee80211_tx_h_fragment(struct ieee80211_tx_data *tx)
 	if (WARN_ON(info->flags & IEEE80211_TX_CTL_AMPDU))
 		return TX_DROP;
 
-	hdrlen = ieee80211_hdrlen(hdr->frame_control);
-
 	/* internal error, why isn't DONTFRAG set? */
 	if (WARN_ON(skb->len + FCS_LEN <= frag_threshold))
 		return TX_DROP;
@@ -1471,6 +1483,7 @@ static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
 			goto txh_done;	\
 	} while (0)
 
+	CALL_TXH(ieee80211_tx_h_hdrlen_add);
 	CALL_TXH(ieee80211_tx_h_dynamic_ps);
 	CALL_TXH(ieee80211_tx_h_check_assoc);
 	CALL_TXH(ieee80211_tx_h_ps_buf);
@@ -1798,6 +1811,8 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 
 	hdr = (struct ieee80211_hdr *)(skb->data + len_rthdr);
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	if (ieee80211_hw_check(&local->hw, NEEDS_ALIGNED4_SKBS))
+		hdrlen += hdrlen & 3;
 
 	if (skb->len < len_rthdr + hdrlen)
 		goto fail;
@@ -2022,6 +2037,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_sub_if_data *ap_sdata;
 	enum ieee80211_band band;
+	int padsize = 0;
 	int ret;
 
 	if (IS_ERR(sta))
@@ -2239,6 +2255,10 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 		hdrlen += 2;
 	}
 
+	/* Check if HW require skb to be aligned */
+	if (ieee80211_hw_check(&sdata->local->hw, NEEDS_ALIGNED4_SKBS))
+		padsize = hdrlen & 3;
+
 	/*
 	 * Drop unicast frames to unauthorised stations unless they are
 	 * EAPOL frames from the local station.
@@ -2325,6 +2345,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	h_pos -= skip_header_bytes;
 
 	head_need = hdrlen + encaps_len + meshhdrlen - skb_headroom(skb);
+	head_need += padsize;
 
 	/*
 	 * So we need to modify the skb header and hence need a copy of
@@ -2363,6 +2384,9 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	}
 #endif
 
+	if (padsize)
+		skb_push(skb, padsize);
+
 	if (ieee80211_is_data_qos(fc)) {
 		__le16 *qos_control;
 
@@ -2376,8 +2400,8 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	} else
 		memcpy(skb_push(skb, hdrlen), &hdr, hdrlen);
 
-	nh_pos += hdrlen;
-	h_pos += hdrlen;
+	nh_pos += hdrlen + padsize;
+	h_pos += hdrlen + padsize;
 
 	/* Update skb pointers to various headers since this modified frame
 	 * is going to go through Linux networking code that may potentially
@@ -2546,6 +2570,10 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
 		fc |= cpu_to_le16(IEEE80211_STYPE_QOS_DATA);
 	}
 
+	/* Check if aligned skb required */
+	if (ieee80211_hw_check(&local->hw, NEEDS_ALIGNED4_SKBS))
+		build.hdr_len += build.hdr_len & 3;
+
 	/* We store the key here so there's no point in using rcu_dereference()
 	 * but that's fine because the code that changes the pointers will call
 	 * this function after doing so. For a single CPU that would be enough,
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 08af2b3..4c2c0e2 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1225,6 +1225,7 @@ void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
+	unsigned int hdrlen;
 	int err;
 
 	/* 24 + 6 = header + auth_algo + auth_transaction + status_code */
@@ -1249,8 +1250,12 @@ void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 		memcpy(skb_put(skb, extra_len), extra, extra_len);
 
 	if (auth_alg == WLAN_AUTH_SHARED_KEY && transaction == 3) {
+		hdrlen = ieee80211_hdrlen(mgmt->frame_control);
+		if (ieee80211_hw_check(&local->hw, NEEDS_ALIGNED4_SKBS))
+			hdrlen += hdrlen & 3;
 		mgmt->frame_control |= cpu_to_le16(IEEE80211_FCTL_PROTECTED);
-		err = ieee80211_wep_encrypt(local, skb, key, key_len, key_idx);
+		err = ieee80211_wep_encrypt(local, skb, hdrlen, key,
+					    key_len, key_idx);
 		WARN_ON(err);
 	}
 
diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
index efa3f48..d14bdb0 100644
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -89,11 +89,11 @@ static void ieee80211_wep_get_iv(struct ieee80211_local *local,
 
 static u8 *ieee80211_wep_add_iv(struct ieee80211_local *local,
 				struct sk_buff *skb,
+				unsigned int hdrlen,
 				int keylen, int keyidx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	unsigned int hdrlen;
 	u8 *newhdr;
 
 	hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PROTECTED);
@@ -101,7 +101,6 @@ static u8 *ieee80211_wep_add_iv(struct ieee80211_local *local,
 	if (WARN_ON(skb_headroom(skb) < IEEE80211_WEP_IV_LEN))
 		return NULL;
 
-	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	newhdr = skb_push(skb, IEEE80211_WEP_IV_LEN);
 	memmove(newhdr, newhdr + IEEE80211_WEP_IV_LEN, hdrlen);
 
@@ -160,6 +159,7 @@ int ieee80211_wep_encrypt_data(struct crypto_cipher *tfm, u8 *rc4key,
  */
 int ieee80211_wep_encrypt(struct ieee80211_local *local,
 			  struct sk_buff *skb,
+			  unsigned int hdrlen,
 			  const u8 *key, int keylen, int keyidx)
 {
 	u8 *iv;
@@ -169,7 +169,7 @@ int ieee80211_wep_encrypt(struct ieee80211_local *local,
 	if (WARN_ON(skb_tailroom(skb) < IEEE80211_WEP_ICV_LEN))
 		return -1;
 
-	iv = ieee80211_wep_add_iv(local, skb, keylen, keyidx);
+	iv = ieee80211_wep_add_iv(local, skb, hdrlen, keylen, keyidx);
 	if (!iv)
 		return -1;
 
@@ -306,13 +306,14 @@ static int wep_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 	struct ieee80211_key_conf *hw_key = info->control.hw_key;
 
 	if (!hw_key) {
-		if (ieee80211_wep_encrypt(tx->local, skb, tx->key->conf.key,
+		if (ieee80211_wep_encrypt(tx->local, skb, tx->hdrlen,
+					  tx->key->conf.key,
 					  tx->key->conf.keylen,
 					  tx->key->conf.keyidx))
 			return -1;
 	} else if ((hw_key->flags & IEEE80211_KEY_FLAG_GENERATE_IV) ||
 		   (hw_key->flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE)) {
-		if (!ieee80211_wep_add_iv(tx->local, skb,
+		if (!ieee80211_wep_add_iv(tx->local, skb, tx->hdrlen,
 					  tx->key->conf.keylen,
 					  tx->key->conf.keyidx))
 			return -1;
diff --git a/net/mac80211/wep.h b/net/mac80211/wep.h
index 9615749..ad0a52b 100644
--- a/net/mac80211/wep.h
+++ b/net/mac80211/wep.h
@@ -22,6 +22,7 @@ int ieee80211_wep_encrypt_data(struct crypto_cipher *tfm, u8 *rc4key,
 				size_t klen, u8 *data, size_t data_len);
 int ieee80211_wep_encrypt(struct ieee80211_local *local,
 			  struct sk_buff *skb,
+			  unsigned int hdrlen,
 			  const u8 *key, int keylen, int keyidx);
 int ieee80211_wep_decrypt_data(struct crypto_cipher *tfm, u8 *rc4key,
 			       size_t klen, u8 *data, size_t data_len);
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index d824c38..b94e6c4 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -42,7 +42,7 @@ ieee80211_tx_h_michael_mic_add(struct ieee80211_tx_data *tx)
 	    skb->len < 24 || !ieee80211_is_data_present(hdr->frame_control))
 		return TX_CONTINUE;
 
-	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	hdrlen = tx->hdrlen;
 	if (skb->len < hdrlen)
 		return TX_DROP;
 
@@ -186,7 +186,6 @@ mic_fail_no_key:
 
 static int tkip_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 {
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_key *key = tx->key;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	unsigned int hdrlen;
@@ -200,7 +199,7 @@ static int tkip_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 		return 0;
 	}
 
-	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	hdrlen = tx->hdrlen;
 	len = skb->len - hdrlen;
 
 	if (info->control.hw_key)
@@ -424,7 +423,7 @@ static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb,
 		return 0;
 	}
 
-	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	hdrlen = tx->hdrlen;
 	len = skb->len - hdrlen;
 
 	if (info->control.hw_key)
@@ -463,6 +462,7 @@ static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb,
 		return 0;
 
 	pos += IEEE80211_CCMP_HDR_LEN;
+
 	ccmp_special_blocks(skb, pn, b_0, aad);
 	ieee80211_aes_ccm_encrypt(key->u.ccmp.tfm, b_0, aad, pos, len,
 				  skb_put(skb, mic_len), mic_len);
@@ -651,7 +651,7 @@ static int gcmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 		return 0;
 	}
 
-	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	hdrlen = tx->hdrlen;
 	len = skb->len - hdrlen;
 
 	if (info->control.hw_key)
@@ -787,7 +787,6 @@ static ieee80211_tx_result
 ieee80211_crypto_cs_encrypt(struct ieee80211_tx_data *tx,
 			    struct sk_buff *skb)
 {
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_key *key = tx->key;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	int hdrlen;
@@ -803,8 +802,7 @@ ieee80211_crypto_cs_encrypt(struct ieee80211_tx_data *tx,
 		     pskb_expand_head(skb, iv_len, 0, GFP_ATOMIC)))
 		return TX_DROP;
 
-	hdrlen = ieee80211_hdrlen(hdr->frame_control);
-
+	hdrlen = tx->hdrlen;
 	pos = skb_push(skb, iv_len);
 	memmove(pos, pos + iv_len, hdrlen);
 
-- 
1.9.1

