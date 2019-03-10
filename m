Return-Path: <SRS0=lllw=RN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53D60C10F0D
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Mar 2019 20:36:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E2192084D
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Mar 2019 20:36:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="ISrPtN0p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbfCJUfB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 10 Mar 2019 16:35:01 -0400
Received: from nbd.name ([46.4.11.11]:34722 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726798AbfCJUfB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Mar 2019 16:35:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Cj8aKHIAZJ7lJWLjl0Yx4e8IpOr8zwHHW0nPF6VB+Zg=; b=ISrPtN0p0797EYyKlFFG2HJKF+
        DXlvq26eITU+LvH4atHgCb9age40QEycbZAXA5aGMgdesnmli0PLoMaL3CFzkSr3KwNoaaCjQIPXd
        OuUX8ja6VCAhEx8piF3J8XkMQ+oZyG8Dtx8YmeLRIaUmPS1XbXiW992kfsTgCTdz/cVA=;
Received: by maeck-2.local (Postfix, from userid 501)
        id 1EE8451FA5D3; Sun, 10 Mar 2019 21:34:54 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net,
        Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 2/2] mac80211: add TX_NEEDS_ALIGNED4_SKBS hw flag
Date:   Sun, 10 Mar 2019 21:34:54 +0100
Message-Id: <20190310203454.47968-2-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190310203454.47968-1-nbd@nbd.name>
References: <20190310203454.47968-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Janusz Dziedzic <janusz.dziedzic@tieto.com>

The driver should set this flag if the hardware requires tx skb data
(starting with the LLC header) to be aligned to 4 bytes.

Padding is added after ieee80211_hdr, before IV/LLC.

Before this patch, we have to do memmove(hdrlen) twice in the driver:
Once before we pass this to HW and once again in tx completion
(to fix up the skb for monitor mode).

With this patch we can skip this memmove() and thus reduce CPU cycles in
the data path.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/net/mac80211.h      | 38 +++++++++++++++++++++++++++++++++++++
 net/mac80211/debugfs.c      |  1 +
 net/mac80211/iface.c        |  4 ++++
 net/mac80211/mesh_pathtbl.c |  4 +++-
 net/mac80211/rx.c           | 12 ++++++++++--
 net/mac80211/sta_info.h     |  2 +-
 net/mac80211/status.c       | 16 +++++++++++++++-
 net/mac80211/tkip.c         |  4 +++-
 net/mac80211/tx.c           | 18 ++++++++++++------
 9 files changed, 87 insertions(+), 12 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index ac2ed8ec662b..3771625b7a9d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2243,6 +2243,9 @@ struct ieee80211_txq {
  * @IEEE80211_HW_SUPPORTS_ONLY_HE_MULTI_BSSID: Hardware supports multi BSSID
  *	only for HE APs. Applies if @IEEE80211_HW_SUPPORTS_MULTI_BSSID is set.
  *
+ * @IEEE80211_HW_TX_NEEDS_ALIGNED4_SKBS: Driver need aligned skbs to four-byte.
+ *	Padding will be added after ieee80211_hdr, before IV/LLC.
+ *
  * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
  */
 enum ieee80211_hw_flags {
@@ -2294,6 +2297,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_TX_STATUS_NO_AMPDU_LEN,
 	IEEE80211_HW_SUPPORTS_MULTI_BSSID,
 	IEEE80211_HW_SUPPORTS_ONLY_HE_MULTI_BSSID,
+	IEEE80211_HW_TX_NEEDS_ALIGNED4_SKBS,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
@@ -2586,6 +2590,40 @@ ieee80211_get_alt_retry_rate(const struct ieee80211_hw *hw,
  */
 void ieee80211_free_txskb(struct ieee80211_hw *hw, struct sk_buff *skb);
 
+/**
+ * ieee80211_hdr_padsize - get size of padding between 802.11 header and LLC
+ * @hw: the hardware
+ * @hdrlen: 802.11 header length
+ */
+static inline unsigned int
+ieee80211_hdr_padsize(struct ieee80211_hw *hw, unsigned int hdrlen)
+{
+	/*
+	 * While hdrlen is already aligned to two-byte boundaries,
+	 * simple check with & 2 will return correct padsize.
+	 */
+	if (ieee80211_hw_check(hw, TX_NEEDS_ALIGNED4_SKBS))
+		return hdrlen & 2;
+	return 0;
+}
+
+/**
+ * ieee80211_padded_hdrlen - get padded 802.11 header size
+ * @hw: the hardware
+ * @fc: frame control field in little-endian format
+ */
+static inline unsigned int
+ieee80211_padded_hdrlen(struct ieee80211_hw *hw, __le16 fc)
+{
+	unsigned int hdrlen;
+
+	hdrlen = ieee80211_hdrlen(fc);
+	hdrlen += ieee80211_hdr_padsize(hw, hdrlen);
+
+	return hdrlen;
+}
+
+
 /**
  * DOC: Hardware crypto acceleration
  *
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 2d43bc127043..6c4f6b731360 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -221,6 +221,7 @@ static const char *hw_flag_names[] = {
 	FLAG(TX_STATUS_NO_AMPDU_LEN),
 	FLAG(SUPPORTS_MULTI_BSSID),
 	FLAG(SUPPORTS_ONLY_HE_MULTI_BSSID),
+	FLAG(TX_NEEDS_ALIGNED4_SKBS),
 #undef FLAG
 };
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 4a6ff1482a9f..8ab23bbfba3e 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1792,6 +1792,10 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 					+ 8 /* rfc1042/bridge tunnel */
 					- ETH_HLEN /* ethernet hard_header_len */
 					+ IEEE80211_ENCRYPT_HEADROOM;
+
+		if (ieee80211_hw_check(&local->hw, TX_NEEDS_ALIGNED4_SKBS))
+			ndev->needed_headroom += 2; /* padding */
+
 		ndev->needed_tailroom = IEEE80211_ENCRYPT_TAILROOM;
 
 		ret = dev_alloc_name(ndev, ndev->name);
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 95eb5064fa91..8822c4f3dc48 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -105,13 +105,15 @@ void mesh_path_assign_nexthop(struct mesh_path *mpath, struct sta_info *sta)
 static void prepare_for_gate(struct sk_buff *skb, char *dst_addr,
 			     struct mesh_path *gate_mpath)
 {
+	struct ieee80211_sub_if_data *sdata = gate_mpath->sdata;
+	struct ieee80211_hw *hw = &sdata->local->hw;
 	struct ieee80211_hdr *hdr;
 	struct ieee80211s_hdr *mshdr;
 	int mesh_hdrlen, hdrlen;
 	char *next_hop;
 
 	hdr = (struct ieee80211_hdr *) skb->data;
-	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	hdrlen = ieee80211_padded_hdrlen(hw, hdr->frame_control);
 	mshdr = (struct ieee80211s_hdr *) (skb->data + hdrlen);
 
 	if (!(mshdr->flags & MESH_FLAGS_AE)) {
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 7f8d93401ce0..295535b75184 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2660,7 +2660,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	struct ieee80211_local *local = rx->local;
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
-	u16 ac, q, hdrlen;
+	u16 ac, q, hdrlen, padsize;
 	int tailroom = 0;
 
 	hdr = (struct ieee80211_hdr *) skb->data;
@@ -2753,7 +2753,9 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	if (sdata->crypto_tx_tailroom_needed_cnt)
 		tailroom = IEEE80211_ENCRYPT_TAILROOM;
 
-	fwd_skb = skb_copy_expand(skb, local->tx_headroom +
+	padsize = ieee80211_hdr_padsize(&local->hw, hdrlen);
+
+	fwd_skb = skb_copy_expand(skb, local->tx_headroom + padsize +
 				       sdata->encrypt_headroom,
 				  tailroom, GFP_ATOMIC);
 	if (!fwd_skb)
@@ -2785,6 +2787,12 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 		return RX_DROP_MONITOR;
 	}
 
+	if (padsize) {
+		skb_push(fwd_skb, padsize);
+		memmove(fwd_skb->data, skb->data + padsize, hdrlen);
+		memset(fwd_skb->data + hdrlen, 0, padsize);
+	}
+
 	IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, fwded_frames);
 	ieee80211_add_pending_skb(local, fwd_skb);
  out:
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 71f7e4973329..4c88042bf1fc 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -311,7 +311,7 @@ struct ieee80211_fast_tx {
 	u8 hdr_len;
 	u8 sa_offs, da_offs, pn_offs;
 	u8 band;
-	u8 hdr[30 + 2 + IEEE80211_FAST_XMIT_MAX_IV +
+	u8 hdr[30 + 2 + 2 + IEEE80211_FAST_XMIT_MAX_IV +
 	       sizeof(rfc1042_header)] __aligned(2);
 
 	struct rcu_head rcu_head;
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 5b9952b1caf3..0af1c7a99d6c 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -515,6 +515,7 @@ static void ieee80211_report_used_skb(struct ieee80211_local *local,
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (void *)skb->data;
+	struct ieee80211_hw *hw = &local->hw;
 	bool acked = info->flags & IEEE80211_TX_STAT_ACK;
 
 	if (dropped)
@@ -531,7 +532,7 @@ static void ieee80211_report_used_skb(struct ieee80211_local *local,
 			skb->dev = NULL;
 		} else {
 			unsigned int hdr_size =
-				ieee80211_hdrlen(hdr->frame_control);
+				ieee80211_padded_hdrlen(hw, hdr->frame_control);
 
 			/* Check to see if packet is a TDLS teardown packet */
 			if (ieee80211_is_data(hdr->frame_control) &&
@@ -653,9 +654,22 @@ void ieee80211_tx_monitor(struct ieee80211_local *local, struct sk_buff *skb,
 	struct sk_buff *skb2;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_hdr *hdr = (void *)skb->data;
 	struct net_device *prev_dev = NULL;
+	unsigned int hdrlen, padsize;
 	int rtap_len;
 
+	/* Remove padding if was added */
+	if (ieee80211_hw_check(&local->hw, TX_NEEDS_ALIGNED4_SKBS)) {
+		hdrlen = ieee80211_hdrlen(hdr->frame_control);
+		padsize = ieee80211_hdr_padsize(&local->hw, hdrlen);
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
index b3622823bad2..505026e82109 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -201,10 +201,12 @@ void ieee80211_get_tkip_p2k(struct ieee80211_key_conf *keyconf,
 {
 	struct ieee80211_key *key = (struct ieee80211_key *)
 			container_of(keyconf, struct ieee80211_key, conf);
+	struct ieee80211_hw *hw = &key->local->hw;
 	const u8 *tk = &key->conf.key[NL80211_TKIP_DATA_OFFSET_ENCR_KEY];
 	struct tkip_ctx *ctx = &key->u.tkip.tx;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	const u8 *data = (u8 *)hdr + ieee80211_hdrlen(hdr->frame_control);
+	const u8 *data = (u8 *)hdr + ieee80211_padded_hdrlen(hw,
+							hdr->frame_control);
 	u32 iv32 = get_unaligned_le32(&data[4]);
 	u16 iv16 = data[2] | (data[0] << 8);
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index ee9b7860b1b1..ca23abbf5c0b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1175,8 +1175,7 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 	info->flags &= ~IEEE80211_TX_INTFL_NEED_TXPROCESSING;
 
 	hdr = (struct ieee80211_hdr *) skb->data;
-
-	tx->hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	tx->hdrlen = ieee80211_padded_hdrlen(&local->hw, hdr->frame_control);
 
 	if (likely(sta)) {
 		if (!IS_ERR(sta))
@@ -2247,7 +2246,7 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 		goto fail;
 
 	hdr = (struct ieee80211_hdr *)(skb->data + len_rthdr);
-	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	hdrlen = ieee80211_padded_hdrlen(&local->hw, hdr->frame_control);
 
 	if (skb->len < len_rthdr + hdrlen)
 		goto fail;
@@ -2465,7 +2464,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_sub_if_data *ap_sdata;
 	enum nl80211_band band;
-	int ret;
+	int padsize, ret;
 
 	if (IS_ERR(sta))
 		sta = NULL;
@@ -2764,7 +2763,9 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	}
 
 	skb_pull(skb, skip_header_bytes);
+	padsize = ieee80211_hdr_padsize(&local->hw, hdrlen);
 	head_need = hdrlen + encaps_len + meshhdrlen - skb_headroom(skb);
+	head_need += padsize;
 
 	/*
 	 * So we need to modify the skb header and hence need a copy of
@@ -2797,6 +2798,9 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 		memcpy(skb_push(skb, meshhdrlen), &mesh_hdr, meshhdrlen);
 #endif
 
+	if (padsize)
+		memset(skb_push(skb, padsize), 0, padsize);
+
 	if (ieee80211_is_data_qos(fc)) {
 		__le16 *qos_control;
 
@@ -2972,6 +2976,8 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
 		fc |= cpu_to_le16(IEEE80211_STYPE_QOS_DATA);
 	}
 
+	build.hdr_len += ieee80211_hdr_padsize(&local->hw, build.hdr_len);
+
 	/* We store the key here so there's no point in using rcu_dereference()
 	 * but that's fine because the code that changes the pointers will call
 	 * this function after doing so. For a single CPU that would be enough,
@@ -3559,7 +3565,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	tx.local = local;
 	tx.skb = skb;
 	tx.sdata = vif_to_sdata(info->control.vif);
-	tx.hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	tx.hdrlen = ieee80211_padded_hdrlen(hw, hdr->frame_control);
 
 	if (txq->sta)
 		tx.sta = container_of(txq->sta, struct sta_info, sta);
@@ -4030,7 +4036,7 @@ ieee80211_build_data_template(struct ieee80211_sub_if_data *sdata,
 	hdr = (void *)skb->data;
 	tx.sta = sta_info_get(sdata, hdr->addr1);
 	tx.skb = skb;
-	tx.hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	tx.hdrlen = ieee80211_padded_hdrlen(&tx.local->hw, hdr->frame_control);
 
 	if (ieee80211_tx_h_select_key(&tx) != TX_CONTINUE) {
 		rcu_read_unlock();
-- 
2.17.0

