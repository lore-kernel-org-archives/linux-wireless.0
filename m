Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:60377 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbYGICAs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 22:00:48 -0400
Received: by wa-out-1112.google.com with SMTP id j37so1717040waf.23
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jul 2008 19:00:47 -0700 (PDT)
Subject: [PATCH 2/3] mac80211: use ieee80211 frame control directly
From: Harvey Harrison <harvey.harrison@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 08 Jul 2008 19:00:45 -0700
Message-Id: <1215568845.476.67.camel@brick> (sfid-20080709_040050_954241_CF9171A0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the last users of the rx/tx_data->fc data members and use the
le16 frame_control from the header directly.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
There'll be some further cleanup needed going forward, but this finishes the->fc
removal.

 net/mac80211/rx.c  |   53 +++++++++++++++++++++++++--------------------------
 net/mac80211/tx.c  |   35 +++++++++++++--------------------
 net/mac80211/wep.c |    7 +++--
 3 files changed, 44 insertions(+), 51 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index dfe4184..f550a93 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -857,16 +857,18 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_hdr *hdr;
 	u16 sc;
+	__le16 fc;
 	unsigned int frag, seq;
 	struct ieee80211_fragment_entry *entry;
 	struct sk_buff *skb;
 	DECLARE_MAC_BUF(mac);
 
 	hdr = (struct ieee80211_hdr *)rx->skb->data;
+	fc = hdr->frame_control;
 	sc = le16_to_cpu(hdr->seq_ctrl);
 	frag = sc & IEEE80211_SCTL_FRAG;
 
-	if (likely((!ieee80211_has_morefrags(hdr->frame_control) && frag == 0) ||
+	if (likely((!ieee80211_has_morefrags(fc) && frag == 0) ||
 		   (rx->skb)->len < 24 ||
 		   is_multicast_ether_addr(hdr->addr1))) {
 		/* not fragmented */
@@ -881,7 +883,7 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 		entry = ieee80211_reassemble_add(rx->sdata, frag, seq,
 						 rx->queue, &(rx->skb));
 		if (rx->key && rx->key->conf.alg == ALG_CCMP &&
-		    ieee80211_has_protected(hdr->frame_control)) {
+		    ieee80211_has_protected(fc)) {
 			/* Store CCMP PN so that we can verify that the next
 			 * fragment has a sequential PN value. */
 			entry->ccmp = 1;
@@ -920,11 +922,11 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 		memcpy(entry->last_pn, pn, CCMP_PN_LEN);
 	}
 
-	skb_pull(rx->skb, ieee80211_hdrlen(hdr->frame_control));
+	skb_pull(rx->skb, ieee80211_hdrlen(fc));
 	__skb_queue_tail(&entry->skb_list, rx->skb);
 	entry->last_frag = frag;
 	entry->extra_len += rx->skb->len;
-	if (rx->fc & IEEE80211_FCTL_MOREFRAGS) {
+	if (ieee80211_has_morefrags(fc)) {
 		rx->skb = NULL;
 		return RX_QUEUED;
 	}
@@ -964,10 +966,9 @@ ieee80211_rx_h_ps_poll(struct ieee80211_rx_data *rx)
 	struct sk_buff *skb;
 	int no_pending_pkts;
 	DECLARE_MAC_BUF(mac);
+	__le16 fc = ((struct ieee80211_hdr *)rx->skb->data)->frame_control;
 
-	if (likely(!rx->sta ||
-		   (rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_CTL ||
-		   (rx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_PSPOLL ||
+	if (likely(!rx->sta || !ieee80211_is_pspoll(fc) ||
 		   !(rx->flags & IEEE80211_RX_RA_MATCH)))
 		return RX_CONTINUE;
 
@@ -1063,7 +1064,7 @@ ieee80211_802_1x_port_control(struct ieee80211_rx_data *rx)
 }
 
 static int
-ieee80211_drop_unencrypted(struct ieee80211_rx_data *rx)
+ieee80211_drop_unencrypted(struct ieee80211_rx_data *rx, __le16 fc)
 {
 	/*
 	 * Pass through unencrypted frames if the hardware has
@@ -1073,9 +1074,8 @@ ieee80211_drop_unencrypted(struct ieee80211_rx_data *rx)
 		return 0;
 
 	/* Drop unencrypted frames if key is set. */
-	if (unlikely(!(rx->fc & IEEE80211_FCTL_PROTECTED) &&
-		     (rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA &&
-		     (rx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_NULLFUNC &&
+	if (unlikely(!ieee80211_has_protected(fc) &&
+		     !ieee80211_is_nullfunc(fc) &&
 		     (rx->key || rx->sdata->drop_unencrypted)))
 		return -EACCES;
 
@@ -1185,7 +1185,7 @@ ieee80211_data_to_8023(struct ieee80211_rx_data *rx)
 /*
  * requires that rx->skb is a frame with ethernet header
  */
-static bool ieee80211_frame_allowed(struct ieee80211_rx_data *rx)
+static bool ieee80211_frame_allowed(struct ieee80211_rx_data *rx, __le16 fc)
 {
 	static const u8 pae_group_addr[ETH_ALEN] __aligned(2)
 		= { 0x01, 0x80, 0xC2, 0x00, 0x00, 0x03 };
@@ -1201,7 +1201,7 @@ static bool ieee80211_frame_allowed(struct ieee80211_rx_data *rx)
 		return true;
 
 	if (ieee80211_802_1x_port_control(rx) ||
-	    ieee80211_drop_unencrypted(rx))
+	    ieee80211_drop_unencrypted(rx, fc))
 		return false;
 
 	return true;
@@ -1303,20 +1303,21 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
 {
 	struct net_device *dev = rx->dev;
 	struct ieee80211_local *local = rx->local;
-	u16 fc, ethertype;
+	u16 ethertype;
 	u8 *payload;
 	struct sk_buff *skb = rx->skb, *frame = NULL;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	__le16 fc = hdr->frame_control;
 	const struct ethhdr *eth;
 	int remaining, err;
 	u8 dst[ETH_ALEN];
 	u8 src[ETH_ALEN];
 	DECLARE_MAC_BUF(mac);
 
-	fc = rx->fc;
-	if (unlikely((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA))
+	if (unlikely(!ieee80211_is_data(fc)))
 		return RX_CONTINUE;
 
-	if (unlikely(!WLAN_FC_DATA_PRESENT(fc)))
+	if (unlikely(!ieee80211_is_data_present(fc)))
 		return RX_DROP_MONITOR;
 
 	if (!(rx->flags & IEEE80211_RX_AMSDU))
@@ -1398,7 +1399,7 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
 			memcpy(skb_push(frame, ETH_ALEN), dst, ETH_ALEN);
 		}
 
-		if (!ieee80211_frame_allowed(rx)) {
+		if (!ieee80211_frame_allowed(rx, fc)) {
 			if (skb == frame) /* last frame */
 				return RX_DROP_UNUSABLE;
 			dev_kfree_skb(frame);
@@ -1415,21 +1416,21 @@ static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 {
 	struct net_device *dev = rx->dev;
-	u16 fc;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
+	__le16 fc = hdr->frame_control;
 	int err;
 
-	fc = rx->fc;
-	if (unlikely((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA))
+	if (unlikely(!ieee80211_is_data(hdr->frame_control)))
 		return RX_CONTINUE;
 
-	if (unlikely(!WLAN_FC_DATA_PRESENT(fc)))
+	if (unlikely(!ieee80211_is_data_present(hdr->frame_control)))
 		return RX_DROP_MONITOR;
 
 	err = ieee80211_data_to_8023(rx);
 	if (unlikely(err))
 		return RX_DROP_UNUSABLE;
 
-	if (!ieee80211_frame_allowed(rx))
+	if (!ieee80211_frame_allowed(rx, fc))
 		return RX_DROP_MONITOR;
 
 	rx->skb->dev = dev;
@@ -1795,13 +1796,12 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_rx_data rx;
-	u16 type;
 	int prepares;
 	struct ieee80211_sub_if_data *prev = NULL;
 	struct sk_buff *skb_new;
 	u8 *bssid;
 
-	hdr = (struct ieee80211_hdr *) skb->data;
+	hdr = (struct ieee80211_hdr *)skb->data;
 	memset(&rx, 0, sizeof(rx));
 	rx.skb = skb;
 	rx.local = local;
@@ -1809,9 +1809,8 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 	rx.status = status;
 	rx.rate = rate;
 	rx.fc = le16_to_cpu(hdr->frame_control);
-	type = rx.fc & IEEE80211_FCTL_FTYPE;
 
-	if (type == IEEE80211_FTYPE_DATA || type == IEEE80211_FTYPE_MGMT)
+	if (ieee80211_is_data(hdr->frame_control) || ieee80211_is_mgmt(hdr->frame_control))
 		local->dot11ReceivedFragmentCount++;
 
 	rx.sta = sta_info_get(local, hdr->addr2);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 309012d..70d5092 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -92,6 +92,7 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx, int group_addr,
 	struct ieee80211_rate *txrate;
 	struct ieee80211_local *local = tx->local;
 	struct ieee80211_supported_band *sband;
+	struct ieee80211_hdr *hdr;
 
 	sband = local->hw.wiphy->bands[tx->channel->band];
 	txrate = &sband->bitrates[tx->rate_idx];
@@ -117,8 +118,8 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx, int group_addr,
 	 *   at the highest possible rate belonging to the PHY rates in the
 	 *   BSSBasicRateSet
 	 */
-
-	if ((tx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL) {
+	hdr = (struct ieee80211_hdr *)tx->skb->data;
+	if (ieee80211_is_ctl(hdr->frame_control)) {
 		/* TODO: These control frames are not currently sent by
 		 * 80211.o, but should they be implemented, this function
 		 * needs to be updated to support duration field calculation.
@@ -223,9 +224,8 @@ static int inline is_ieee80211_device(struct net_device *dev,
 static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
 {
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
-#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 	u32 sta_flags;
 
@@ -233,8 +233,7 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
 		return TX_CONTINUE;
 
 	if (unlikely(tx->local->sta_sw_scanning) &&
-	    ((tx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_MGMT ||
-	     (tx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_PROBE_REQ))
+	    !ieee80211_is_probe_req(hdr->frame_control))
 		return TX_DROP;
 
 	if (tx->sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT)
@@ -248,7 +247,7 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
 	if (likely(tx->flags & IEEE80211_TX_UNICAST)) {
 		if (unlikely(!(sta_flags & WLAN_STA_ASSOC) &&
 			     tx->sdata->vif.type != IEEE80211_IF_TYPE_IBSS &&
-			     (tx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA)) {
+			     ieee80211_is_data(hdr->frame_control))) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 			DECLARE_MAC_BUF(mac);
 			printk(KERN_DEBUG "%s: dropped data frame to not "
@@ -259,7 +258,7 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
 			return TX_DROP;
 		}
 	} else {
-		if (unlikely((tx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA &&
+		if (unlikely(ieee80211_is_data(hdr->frame_control) &&
 			     tx->local->num_sta == 0 &&
 			     tx->sdata->vif.type != IEEE80211_IF_TYPE_IBSS)) {
 			/*
@@ -337,6 +336,7 @@ static ieee80211_tx_result
 ieee80211_tx_h_multicast_ps_buf(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
 
 	/*
 	 * broadcast/multicast frame
@@ -347,7 +347,7 @@ ieee80211_tx_h_multicast_ps_buf(struct ieee80211_tx_data *tx)
 	 */
 
 	/* not AP/IBSS or ordered frame */
-	if (!tx->sdata->bss || (tx->fc & IEEE80211_FCTL_ORDER))
+	if (!tx->sdata->bss || ieee80211_has_order(hdr->frame_control))
 		return TX_CONTINUE;
 
 	/* no stations in PS mode */
@@ -385,12 +385,11 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 {
 	struct sta_info *sta = tx->sta;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
 	u32 staflags;
 	DECLARE_MAC_BUF(mac);
 
-	if (unlikely(!sta ||
-		     ((tx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT &&
-		      (tx->fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PROBE_RESP)))
+	if (unlikely(!sta || ieee80211_is_probe_resp(hdr->frame_control)))
 		return TX_CONTINUE;
 
 	staflags = get_sta_flags(sta);
@@ -455,7 +454,7 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_key *key;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
-	u16 fc = tx->fc;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
 
 	if (unlikely(info->flags & IEEE80211_TX_CTL_DO_NOT_ENCRYPT))
 		tx->key = NULL;
@@ -472,22 +471,16 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 		tx->key = NULL;
 
 	if (tx->key) {
-		u16 ftype, stype;
-
 		tx->key->tx_rx_count++;
 		/* TODO: add threshold stuff again */
 
 		switch (tx->key->conf.alg) {
 		case ALG_WEP:
-			ftype = fc & IEEE80211_FCTL_FTYPE;
-			stype = fc & IEEE80211_FCTL_STYPE;
-
-			if (ftype == IEEE80211_FTYPE_MGMT &&
-			    stype == IEEE80211_STYPE_AUTH)
+			if (ieee80211_is_auth(hdr->frame_control))
 				break;
 		case ALG_TKIP:
 		case ALG_CCMP:
-			if (!WLAN_FC_DATA_PRESENT(fc))
+			if (!ieee80211_is_data_present(hdr->frame_control))
 				tx->key = NULL;
 			break;
 		}
diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
index e50b421..d6d68b5 100644
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -291,9 +291,10 @@ u8 * ieee80211_wep_is_weak_iv(struct sk_buff *skb, struct ieee80211_key *key)
 ieee80211_rx_result
 ieee80211_crypto_wep_decrypt(struct ieee80211_rx_data *rx)
 {
-	if ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA &&
-	    ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_MGMT ||
-	     (rx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_AUTH))
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
+
+	if (ieee80211_is_data(hdr->frame_control) &&
+	    ieee80211_is_auth(hdr->frame_control))
 		return RX_CONTINUE;
 
 	if (!(rx->status->flag & RX_FLAG_DECRYPTED)) {
-- 
1.5.6.1.322.ge904b


