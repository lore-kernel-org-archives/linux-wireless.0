Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:34607 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759034AbcAUJan (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 04:30:43 -0500
Received: by mail-lb0-f175.google.com with SMTP id cl12so19818962lbc.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2016 01:30:42 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFC/RFT v4 2/2] mac80211: add NEED_ALIGNED4_SKBS hw flag
Date: Thu, 21 Jan 2016 10:30:25 +0100
Message-Id: <1453368625-3615-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20160121_103049_034719_DE33E940)
In-Reply-To: <1453368625-3615-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1453368625-3615-1-git-send-email-janusz.dziedzic@tieto.com>
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

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---

not sure __ieee80211_hdrlen is the best choice here ...

 include/net/mac80211.h     |  4 ++++
 net/mac80211/debugfs.c     |  1 +
 net/mac80211/ieee80211_i.h | 11 +++++++++++
 net/mac80211/sta_info.h    |  4 ++--
 net/mac80211/status.c      | 13 +++++++++++++
 net/mac80211/tkip.c        |  3 ++-
 net/mac80211/tx.c          | 22 +++++++++++++++++-----
 net/mac80211/util.c        |  2 +-
 8 files changed, 51 insertions(+), 9 deletions(-)

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
index f9ff470..99e3cef 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1470,6 +1470,17 @@ ieee80211_have_rx_timestamp(struct ieee80211_rx_status *status)
 	return status->flag & (RX_FLAG_MACTIME_START | RX_FLAG_MACTIME_END);
 }
 
+static inline unsigned int
+__ieee80211_hdrlen(struct ieee80211_hw *hw, __le16 fc) {
+	unsigned int hdrlen;
+
+	hdrlen = ieee80211_hdrlen(fc);
+	if (ieee80211_hw_check(hw, NEEDS_ALIGNED4_SKBS))
+		hdrlen += hdrlen & 3;
+
+	return hdrlen;
+}
+
 u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
 				     struct ieee80211_rx_status *status,
 				     unsigned int mpdu_len,
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
index 5bad05e..84b0b1a 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -678,9 +678,22 @@ void ieee80211_tx_monitor(struct ieee80211_local *local, struct sk_buff *skb,
 	struct sk_buff *skb2;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_hdr *hdr = (void *)skb->data;
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
index 0ae2077..6f78975 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -201,10 +201,11 @@ void ieee80211_get_tkip_p2k(struct ieee80211_key_conf *keyconf,
 {
 	struct ieee80211_key *key = (struct ieee80211_key *)
 			container_of(keyconf, struct ieee80211_key, conf);
+	struct ieee80211_hw *hw = &key->local->hw;
 	const u8 *tk = &key->conf.key[NL80211_TKIP_DATA_OFFSET_ENCR_KEY];
 	struct tkip_ctx *ctx = &key->u.tkip.tx;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	const u8 *data = (u8 *)hdr + ieee80211_hdrlen(hdr->frame_control);
+	const u8 *data = (u8 *)hdr + __ieee80211_hdrlen(hw, hdr->frame_control);
 	u32 iv32 = get_unaligned_le32(&data[4]);
 	u16 iv16 = data[2] | (data[0] << 8);
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index cd4c361..692b76d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1162,8 +1162,7 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 	info->flags &= ~IEEE80211_TX_INTFL_NEED_TXPROCESSING;
 
 	hdr = (struct ieee80211_hdr *) skb->data;
-
-	tx->hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	tx->hdrlen = __ieee80211_hdrlen(&local->hw, hdr->frame_control);
 
 	if (likely(sta)) {
 		if (!IS_ERR(sta))
@@ -1795,7 +1794,7 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 		goto fail;
 
 	hdr = (struct ieee80211_hdr *)(skb->data + len_rthdr);
-	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	hdrlen = __ieee80211_hdrlen(&local->hw, hdr->frame_control);
 
 	if (skb->len < len_rthdr + hdrlen)
 		goto fail;
@@ -2020,6 +2019,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_sub_if_data *ap_sdata;
 	enum ieee80211_band band;
+	int padsize = 0;
 	int ret;
 
 	if (IS_ERR(sta))
@@ -2237,6 +2237,10 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 		hdrlen += 2;
 	}
 
+	/* Check if HW require skb to be aligned */
+	if (ieee80211_hw_check(&sdata->local->hw, NEEDS_ALIGNED4_SKBS))
+		padsize = hdrlen & 3;
+
 	/*
 	 * Drop unicast frames to unauthorised stations unless they are
 	 * EAPOL frames from the local station.
@@ -2323,6 +2327,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	h_pos -= skip_header_bytes;
 
 	head_need = hdrlen + encaps_len + meshhdrlen - skb_headroom(skb);
+	head_need += padsize;
 
 	/*
 	 * So we need to modify the skb header and hence need a copy of
@@ -2361,6 +2366,9 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	}
 #endif
 
+	if (padsize)
+		skb_push(skb, padsize);
+
 	if (ieee80211_is_data_qos(fc)) {
 		__le16 *qos_control;
 
@@ -2374,8 +2382,8 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	} else
 		memcpy(skb_push(skb, hdrlen), &hdr, hdrlen);
 
-	nh_pos += hdrlen;
-	h_pos += hdrlen;
+	nh_pos += hdrlen + padsize;
+	h_pos += hdrlen + padsize;
 
 	/* Update skb pointers to various headers since this modified frame
 	 * is going to go through Linux networking code that may potentially
@@ -2544,6 +2552,10 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
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
index ce1aeba..9231ac2 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1250,7 +1250,7 @@ void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 		memcpy(skb_put(skb, extra_len), extra, extra_len);
 
 	if (auth_alg == WLAN_AUTH_SHARED_KEY && transaction == 3) {
-		hdrlen = ieee80211_hdrlen(mgmt->frame_control);
+		hdrlen = __ieee80211_hdrlen(&local->hw, mgmt->frame_control);
 		mgmt->frame_control |= cpu_to_le16(IEEE80211_FCTL_PROTECTED);
 		err = ieee80211_wep_encrypt(local, skb, hdrlen, key,
 					    key_len, key_idx);
-- 
1.9.1

