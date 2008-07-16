Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:16274 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679AbYGPBoX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 21:44:23 -0400
Received: by yx-out-2324.google.com with SMTP id 8so1738137yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jul 2008 18:44:23 -0700 (PDT)
Subject: [PATCH 07/12] mac80211: rx.c/tx.c remove more users of
	tx/rx_data->fc
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 18:44:12 -0700
Message-Id: <1216172652.6610.55.camel@brick> (sfid-20080716_034427_375493_DB3EF1D4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Those functions that still use ieee80211_get_hdrlen are moved over
to use the little endian frame control.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/rx.c |   62 ++++++++++++++++++++--------------------------------
 net/mac80211/tx.c |    2 +-
 2 files changed, 25 insertions(+), 39 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 6d9ae67..cca1ed8 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -816,7 +816,7 @@ ieee80211_reassemble_add(struct ieee80211_sub_if_data *sdata,
 
 static inline struct ieee80211_fragment_entry *
 ieee80211_reassemble_find(struct ieee80211_sub_if_data *sdata,
-			  u16 fc, unsigned int frag, unsigned int seq,
+			  unsigned int frag, unsigned int seq,
 			  int rx_queue, struct ieee80211_hdr *hdr)
 {
 	struct ieee80211_fragment_entry *entry;
@@ -825,7 +825,6 @@ ieee80211_reassemble_find(struct ieee80211_sub_if_data *sdata,
 	idx = sdata->fragment_next;
 	for (i = 0; i < IEEE80211_FRAGMENT_MAX; i++) {
 		struct ieee80211_hdr *f_hdr;
-		u16 f_fc;
 
 		idx--;
 		if (idx < 0)
@@ -837,10 +836,13 @@ ieee80211_reassemble_find(struct ieee80211_sub_if_data *sdata,
 		    entry->last_frag + 1 != frag)
 			continue;
 
-		f_hdr = (struct ieee80211_hdr *) entry->skb_list.next->data;
-		f_fc = le16_to_cpu(f_hdr->frame_control);
+		f_hdr = (struct ieee80211_hdr *)entry->skb_list.next->data;
 
-		if ((fc & IEEE80211_FCTL_FTYPE) != (f_fc & IEEE80211_FCTL_FTYPE) ||
+		/*
+		 * Check ftype and addresses are equal, else check next fragment
+		 */
+		if (((hdr->frame_control ^ f_hdr->frame_control) &
+		     cpu_to_le16(IEEE80211_FCTL_FTYPE)) ||
 		    compare_ether_addr(hdr->addr1, f_hdr->addr1) != 0 ||
 		    compare_ether_addr(hdr->addr2, f_hdr->addr2) != 0)
 			continue;
@@ -865,11 +867,11 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 	struct sk_buff *skb;
 	DECLARE_MAC_BUF(mac);
 
-	hdr = (struct ieee80211_hdr *) rx->skb->data;
+	hdr = (struct ieee80211_hdr *)rx->skb->data;
 	sc = le16_to_cpu(hdr->seq_ctrl);
 	frag = sc & IEEE80211_SCTL_FRAG;
 
-	if (likely((!(rx->fc & IEEE80211_FCTL_MOREFRAGS) && frag == 0) ||
+	if (likely((!ieee80211_has_morefrags(hdr->frame_control) && frag == 0) ||
 		   (rx->skb)->len < 24 ||
 		   is_multicast_ether_addr(hdr->addr1))) {
 		/* not fragmented */
@@ -884,7 +886,7 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 		entry = ieee80211_reassemble_add(rx->sdata, frag, seq,
 						 rx->queue, &(rx->skb));
 		if (rx->key && rx->key->conf.alg == ALG_CCMP &&
-		    (rx->fc & IEEE80211_FCTL_PROTECTED)) {
+		    ieee80211_has_protected(hdr->frame_control)) {
 			/* Store CCMP PN so that we can verify that the next
 			 * fragment has a sequential PN value. */
 			entry->ccmp = 1;
@@ -898,8 +900,7 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 	/* This is a fragment for a frame that should already be pending in
 	 * fragment cache. Add this fragment to the end of the pending entry.
 	 */
-	entry = ieee80211_reassemble_find(rx->sdata, rx->fc, frag, seq,
-					  rx->queue, hdr);
+	entry = ieee80211_reassemble_find(rx->sdata, frag, seq, rx->queue, hdr);
 	if (!entry) {
 		I802_DEBUG_INC(rx->local->rx_handlers_drop_defrag);
 		return RX_DROP_MONITOR;
@@ -924,7 +925,7 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 		memcpy(entry->last_pn, pn, CCMP_PN_LEN);
 	}
 
-	skb_pull(rx->skb, ieee80211_get_hdrlen(rx->fc));
+	skb_pull(rx->skb, ieee80211_hdrlen(hdr->frame_control));
 	__skb_queue_tail(&entry->skb_list, rx->skb);
 	entry->last_frag = frag;
 	entry->extra_len += rx->skb->len;
@@ -1091,7 +1092,7 @@ ieee80211_data_to_8023(struct ieee80211_rx_data *rx)
 {
 	struct net_device *dev = rx->dev;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
-	u16 fc, hdrlen, ethertype;
+	u16 hdrlen, ethertype;
 	u8 *payload;
 	u8 dst[ETH_ALEN];
 	u8 src[ETH_ALEN] __aligned(2);
@@ -1102,12 +1103,10 @@ ieee80211_data_to_8023(struct ieee80211_rx_data *rx)
 	DECLARE_MAC_BUF(mac3);
 	DECLARE_MAC_BUF(mac4);
 
-	fc = rx->fc;
-
-	if (unlikely(!WLAN_FC_DATA_PRESENT(fc)))
+	if (unlikely(!ieee80211_is_data_present(hdr->frame_control)))
 		return -1;
 
-	hdrlen = ieee80211_get_hdrlen(fc);
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 		int meshhdrlen = ieee80211_get_mesh_hdrlen(
@@ -1133,41 +1132,28 @@ ieee80211_data_to_8023(struct ieee80211_rx_data *rx)
 	 *   1     0   BSSID SA    DA    n/a
 	 *   1     1   RA    TA    DA    SA
 	 */
+	memcpy(dst, ieee80211_get_DA(hdr), ETH_ALEN);
+	memcpy(src, ieee80211_get_SA(hdr), ETH_ALEN);
 
-	switch (fc & (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) {
-	case IEEE80211_FCTL_TODS:
-		/* BSSID SA DA */
-		memcpy(dst, hdr->addr3, ETH_ALEN);
-		memcpy(src, hdr->addr2, ETH_ALEN);
-
+	switch (hdr->frame_control &
+		cpu_to_le16(IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) {
+	case __constant_cpu_to_le16(IEEE80211_FCTL_TODS):
 		if (unlikely(sdata->vif.type != IEEE80211_IF_TYPE_AP &&
 			     sdata->vif.type != IEEE80211_IF_TYPE_VLAN))
 			return -1;
 		break;
-	case (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS):
-		/* RA TA DA SA */
-		memcpy(dst, hdr->addr3, ETH_ALEN);
-		memcpy(src, hdr->addr4, ETH_ALEN);
-
-		 if (unlikely(sdata->vif.type != IEEE80211_IF_TYPE_WDS &&
+	case __constant_cpu_to_le16(IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS):
+		if (unlikely(sdata->vif.type != IEEE80211_IF_TYPE_WDS &&
 			     sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT))
 			return -1;
 		break;
-	case IEEE80211_FCTL_FROMDS:
-		/* DA BSSID SA */
-		memcpy(dst, hdr->addr1, ETH_ALEN);
-		memcpy(src, hdr->addr3, ETH_ALEN);
-
+	case __constant_cpu_to_le16(IEEE80211_FCTL_FROMDS):
 		if (sdata->vif.type != IEEE80211_IF_TYPE_STA ||
 		    (is_multicast_ether_addr(dst) &&
 		     !compare_ether_addr(src, dev->dev_addr)))
 			return -1;
 		break;
-	case 0:
-		/* DA SA BSSID */
-		memcpy(dst, hdr->addr1, ETH_ALEN);
-		memcpy(src, hdr->addr2, ETH_ALEN);
-
+	case __constant_cpu_to_le16(0):
 		if (sdata->vif.type != IEEE80211_IF_TYPE_IBSS)
 			return -1;
 		break;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 2b912cf..bf733ed 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1025,7 +1025,7 @@ __ieee80211_tx_prepare(struct ieee80211_tx_data *tx,
 	else if (test_and_clear_sta_flags(tx->sta, WLAN_STA_CLEAR_PS_FILT))
 		info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
 
-	hdrlen = ieee80211_get_hdrlen(tx->fc);
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	if (skb->len > hdrlen + sizeof(rfc1042_header) + 2) {
 		u8 *pos = &skb->data[hdrlen + sizeof(rfc1042_header)];
 		tx->ethertype = (pos[0] << 8) | pos[1];
-- 
1.5.6.3.499.geae9


