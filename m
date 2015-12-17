Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37982 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771AbbLQJUu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2015 04:20:50 -0500
Received: by mail-wm0-f51.google.com with SMTP id l126so12048203wml.1
        for <linux-wireless@vger.kernel.org>; Thu, 17 Dec 2015 01:20:50 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, nbd@openwrt.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFC/RFT 1/2] mac80211: Add NEED_ALIGNED4_SKBS hw flag
Date: Thu, 17 Dec 2015 10:20:28 +0100
Message-Id: <1450344029-5296-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20151217_102102_134283_CFB261F0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HW/driver should set NEED_ALIGNED4_SKBS flag in case require
aligned skbs to four-byte boundaries.

Before we have to do memmove() in the driver before
pass this to HW and memmove() back in tx completion.
This patch allow to save CPU and skip such memmoves.
For each skb we called memmove(ieee80211_hdrsize()) twice.

Currently this was tested with ath9k, both hw/sw crypt for
tkip/ccmp.
For sure more tests required.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 include/net/mac80211.h |  4 ++++
 net/mac80211/debugfs.c |  1 +
 net/mac80211/tkip.c    | 15 ++++++++++++---
 net/mac80211/tx.c      | 21 +++++++++++++++++++--
 net/mac80211/wep.c     |  6 ++++++
 net/mac80211/wpa.c     | 35 +++++++++++++++++++++++++++--------
 6 files changed, 69 insertions(+), 13 deletions(-)

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
index 3311ce0..30ee9ad 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -937,6 +937,8 @@ ieee80211_tx_h_fragment(struct ieee80211_tx_data *tx)
 		return TX_DROP;
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	if (ieee80211_hw_check(&tx->local->hw, NEEDS_ALIGNED4_SKBS))
+		hdrlen += hdrlen & 3;
 
 	/* internal error, why isn't DONTFRAG set? */
 	if (WARN_ON(skb->len + FCS_LEN <= frag_threshold))
@@ -1796,6 +1798,8 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 
 	hdr = (struct ieee80211_hdr *)(skb->data + len_rthdr);
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	if (ieee80211_hw_check(&local->hw, NEEDS_ALIGNED4_SKBS))
+		hdrlen += hdrlen & 3;
 
 	if (skb->len < len_rthdr + hdrlen)
 		goto fail;
@@ -2020,6 +2024,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_sub_if_data *ap_sdata;
 	enum ieee80211_band band;
+	int padsize = 0;
 	int ret;
 
 	if (IS_ERR(sta))
@@ -2237,6 +2242,10 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 		hdrlen += 2;
 	}
 
+	/* Check if HW require skb to be aligned */
+	if (ieee80211_hw_check(&sdata->local->hw, NEEDS_ALIGNED4_SKBS))
+		padsize = hdrlen & 3;
+
 	/*
 	 * Drop unicast frames to unauthorised stations unless they are
 	 * EAPOL frames from the local station.
@@ -2323,6 +2332,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	h_pos -= skip_header_bytes;
 
 	head_need = hdrlen + encaps_len + meshhdrlen - skb_headroom(skb);
+	head_need += padsize;
 
 	/*
 	 * So we need to modify the skb header and hence need a copy of
@@ -2361,6 +2371,9 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	}
 #endif
 
+	if (padsize)
+		skb_push(skb, padsize);
+
 	if (ieee80211_is_data_qos(fc)) {
 		__le16 *qos_control;
 
@@ -2374,8 +2387,8 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	} else
 		memcpy(skb_push(skb, hdrlen), &hdr, hdrlen);
 
-	nh_pos += hdrlen;
-	h_pos += hdrlen;
+	nh_pos += hdrlen + padsize;
+	h_pos += hdrlen + padsize;
 
 	/* Update skb pointers to various headers since this modified frame
 	 * is going to go through Linux networking code that may potentially
@@ -2544,6 +2557,10 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
 		fc |= cpu_to_le16(IEEE80211_STYPE_QOS_DATA);
 	}
 
+	/* Check if aligned skb required */
+	if (ieee80211_hw_check(&local->hw, NEEDS_ALIGNED4_SKBS))
+		build.hdr_len += build.hdr_len & 3;
+
 	/* We store the key here so there's no point in using rcu_dereference()
 	 * but that's fine because the code that changes the pointers will call
 	 * this function after doing so. For a single CPU that would be enough,
diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
index efa3f48..46c7c67 100644
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -102,6 +102,9 @@ static u8 *ieee80211_wep_add_iv(struct ieee80211_local *local,
 		return NULL;
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	if (ieee80211_hw_check(&local->hw, NEEDS_ALIGNED4_SKBS))
+		hdrlen += hdrlen & 3;
+
 	newhdr = skb_push(skb, IEEE80211_WEP_IV_LEN);
 	memmove(newhdr, newhdr + IEEE80211_WEP_IV_LEN, hdrlen);
 
@@ -123,6 +126,9 @@ static void ieee80211_wep_remove_iv(struct ieee80211_local *local,
 	unsigned int hdrlen;
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	if (ieee80211_hw_check(&local->hw, NEEDS_ALIGNED4_SKBS))
+		hdrlen += hdrlen & 3;
+
 	memmove(skb->data + IEEE80211_WEP_IV_LEN, skb->data, hdrlen);
 	skb_pull(skb, IEEE80211_WEP_IV_LEN);
 }
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index d824c38..18110c8 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -43,6 +43,8 @@ ieee80211_tx_h_michael_mic_add(struct ieee80211_tx_data *tx)
 		return TX_CONTINUE;
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	if (ieee80211_hw_check(&tx->local->hw, NEEDS_ALIGNED4_SKBS))
+		hdrlen += hdrlen & 3;
 	if (skb->len < hdrlen)
 		return TX_DROP;
 
@@ -201,6 +203,8 @@ static int tkip_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 	}
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	if (ieee80211_hw_check(&tx->local->hw, NEEDS_ALIGNED4_SKBS))
+		hdrlen += hdrlen & 3;
 	len = skb->len - hdrlen;
 
 	if (info->control.hw_key)
@@ -307,7 +311,8 @@ ieee80211_crypto_tkip_decrypt(struct ieee80211_rx_data *rx)
 }
 
 
-static void ccmp_special_blocks(struct sk_buff *skb, u8 *pn, u8 *b_0, u8 *aad)
+static void ccmp_special_blocks(struct sk_buff *skb, u8 *pn, u8 *b_0, u8 *aad,
+				unsigned int padsize)
 {
 	__le16 mask_fc;
 	int a4_included, mgmt;
@@ -329,7 +334,8 @@ static void ccmp_special_blocks(struct sk_buff *skb, u8 *pn, u8 *b_0, u8 *aad)
 	mask_fc |= cpu_to_le16(IEEE80211_FCTL_PROTECTED);
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
-	len_a = hdrlen - 2;
+	hdrlen += padsize;
+	len_a = hdrlen - 2 - padsize;
 	a4_included = ieee80211_has_a4(hdr->frame_control);
 
 	if (ieee80211_is_data_qos(hdr->frame_control))
@@ -405,6 +411,7 @@ static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb,
 	struct ieee80211_key *key = tx->key;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	int hdrlen, len, tail;
+	unsigned int padsize = 0;
 	u8 *pos;
 	u8 pn[6];
 	u64 pn64;
@@ -425,6 +432,9 @@ static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb,
 	}
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	if (ieee80211_hw_check(&tx->local->hw, NEEDS_ALIGNED4_SKBS))
+		padsize = hdrlen & 3;
+	hdrlen += padsize;
 	len = skb->len - hdrlen;
 
 	if (info->control.hw_key)
@@ -463,7 +473,8 @@ static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb,
 		return 0;
 
 	pos += IEEE80211_CCMP_HDR_LEN;
-	ccmp_special_blocks(skb, pn, b_0, aad);
+
+	ccmp_special_blocks(skb, pn, b_0, aad, padsize);
 	ieee80211_aes_ccm_encrypt(key->u.ccmp.tfm, b_0, aad, pos, len,
 				  skb_put(skb, mic_len), mic_len);
 
@@ -534,7 +545,7 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx,
 			u8 aad[2 * AES_BLOCK_SIZE];
 			u8 b_0[AES_BLOCK_SIZE];
 			/* hardware didn't decrypt/verify MIC */
-			ccmp_special_blocks(skb, pn, b_0, aad);
+			ccmp_special_blocks(skb, pn, b_0, aad, 0);
 
 			if (ieee80211_aes_ccm_decrypt(
 				    key->u.ccmp.tfm, b_0, aad,
@@ -556,7 +567,8 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx,
 	return RX_CONTINUE;
 }
 
-static void gcmp_special_blocks(struct sk_buff *skb, u8 *pn, u8 *j_0, u8 *aad)
+static void gcmp_special_blocks(struct sk_buff *skb, u8 *pn, u8 *j_0, u8 *aad,
+				unsigned int padsize)
 {
 	__le16 mask_fc;
 	u8 qos_tid;
@@ -571,7 +583,8 @@ static void gcmp_special_blocks(struct sk_buff *skb, u8 *pn, u8 *j_0, u8 *aad)
 	/* AAD (extra authenticate-only data) / masked 802.11 header
 	 * FC | A1 | A2 | A3 | SC | [A4] | [QC]
 	 */
-	put_unaligned_be16(ieee80211_hdrlen(hdr->frame_control) - 2, &aad[0]);
+	put_unaligned_be16(ieee80211_hdrlen(hdr->frame_control) - 2 - padsize,
+			   &aad[0]);
 	/* Mask FC: zero subtype b4 b5 b6 (if not mgmt)
 	 * Retry, PwrMgt, MoreData; set Protected
 	 */
@@ -633,6 +646,7 @@ static int gcmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 	struct ieee80211_key *key = tx->key;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	int hdrlen, len, tail;
+	unsigned int padsize = 0;
 	u8 *pos;
 	u8 pn[6];
 	u64 pn64;
@@ -652,6 +666,9 @@ static int gcmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 	}
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	if (ieee80211_hw_check(&tx->local->hw, NEEDS_ALIGNED4_SKBS))
+		padsize = hdrlen & 3;
+	hdrlen += padsize;
 	len = skb->len - hdrlen;
 
 	if (info->control.hw_key)
@@ -692,7 +709,7 @@ static int gcmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 		return 0;
 
 	pos += IEEE80211_GCMP_HDR_LEN;
-	gcmp_special_blocks(skb, pn, j_0, aad);
+	gcmp_special_blocks(skb, pn, j_0, aad, padsize);
 	ieee80211_aes_gcm_encrypt(key->u.gcmp.tfm, j_0, aad, pos, len,
 				  skb_put(skb, IEEE80211_GCMP_MIC_LEN));
 
@@ -760,7 +777,7 @@ ieee80211_crypto_gcmp_decrypt(struct ieee80211_rx_data *rx)
 			u8 aad[2 * AES_BLOCK_SIZE];
 			u8 j_0[AES_BLOCK_SIZE];
 			/* hardware didn't decrypt/verify MIC */
-			gcmp_special_blocks(skb, pn, j_0, aad);
+			gcmp_special_blocks(skb, pn, j_0, aad, 0);
 
 			if (ieee80211_aes_gcm_decrypt(
 				    key->u.gcmp.tfm, j_0, aad,
@@ -804,6 +821,8 @@ ieee80211_crypto_cs_encrypt(struct ieee80211_tx_data *tx,
 		return TX_DROP;
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	if (ieee80211_hw_check(&tx->local->hw, NEEDS_ALIGNED4_SKBS))
+		hdrlen += hdrlen & 3;
 
 	pos = skb_push(skb, iv_len);
 	memmove(pos, pos + iv_len, hdrlen);
-- 
1.9.1

