Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35947 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbXFUKps (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2007 06:45:48 -0400
Subject: [PATCH] mac80211: show transmitted frames on monitor interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 21 Jun 2007 11:25:15 +0200
Message-Id: <1182417915.10821.1.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes mac80211 show transmitted frames on monitor interfaces,
including radiotap headers that indicate some transmission parameters.
The shown parameters will need to be expanded, but this should work as
a basis to work from.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
The original code did a full copy of the skb for status callbacks,
I'm fairly confident that orphaning it and then cloning where
necessary is enough. A comment in the original code *said* it cloned
it but the code actually did a full copy. Rather inefficient.

 net/mac80211/ieee80211.c   |  145 +++++++++++++++++++++++++++++++++++++--------
 net/mac80211/ieee80211_i.h |    1 
 2 files changed, 121 insertions(+), 25 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-06-21 11:13:53.098645783 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-06-21 11:19:37.128645783 +0200
@@ -57,6 +57,17 @@ static const unsigned char eapol_header[
 	{ 0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00, 0x88, 0x8e };
 
 
+/*
+ * For seeing transmitted packets on monitor interfaces
+ * we have a radiotap header too.
+ */
+struct ieee80211_tx_status_rtap_hdr {
+	struct ieee80211_radiotap_header hdr;
+	__le16 tx_flags;
+	u8 data_retries;
+} __attribute__ ((packed));
+
+
 static inline void ieee80211_include_sequence(struct ieee80211_sub_if_data *sdata,
 					      struct ieee80211_hdr *hdr)
 {
@@ -529,7 +540,7 @@ ieee80211_tx_h_fragment(struct ieee80211
 		/* reserve enough extra head and tail room for possible
 		 * encryption */
 		frag = frags[i] =
-			dev_alloc_skb(tx->local->hw.extra_tx_headroom +
+			dev_alloc_skb(tx->local->tx_headroom +
 				      frag_threshold +
 				      IEEE80211_ENCRYPT_HEADROOM +
 				      IEEE80211_ENCRYPT_TAILROOM);
@@ -538,8 +549,8 @@ ieee80211_tx_h_fragment(struct ieee80211
 		/* Make sure that all fragments use the same priority so
 		 * that they end up using the same TX queue */
 		frag->priority = first->priority;
-		skb_reserve(frag, tx->local->hw.extra_tx_headroom +
-			IEEE80211_ENCRYPT_HEADROOM);
+		skb_reserve(frag, tx->local->tx_headroom +
+				  IEEE80211_ENCRYPT_HEADROOM);
 		fhdr = (struct ieee80211_hdr *) skb_put(frag, hdrlen);
 		memcpy(fhdr, first->data, hdrlen);
 		if (i == num_fragm - 2)
@@ -1627,8 +1638,7 @@ static int ieee80211_master_start_xmit(s
 	}
 	osdata = IEEE80211_DEV_TO_SUB_IF(odev);
 
-	headroom = osdata->local->hw.extra_tx_headroom +
-		IEEE80211_ENCRYPT_HEADROOM;
+	headroom = osdata->local->tx_headroom + IEEE80211_ENCRYPT_HEADROOM;
 	if (skb_headroom(skb) < headroom) {
 		if (pskb_expand_head(skb, headroom, 0, GFP_ATOMIC)) {
 			dev_kfree_skb(skb);
@@ -1836,7 +1846,7 @@ int ieee80211_subif_start_xmit(struct sk
 	 * build in headroom in __dev_alloc_skb() (linux/skbuff.h) and
 	 * alloc_skb() (net/core/skbuff.c)
 	 */
-	head_need = hdrlen + encaps_len + local->hw.extra_tx_headroom;
+	head_need = hdrlen + encaps_len + local->tx_headroom;
 	head_need -= skb_headroom(skb);
 
 	/* We are going to modify skb data, so make a copy of it if happens to
@@ -1923,9 +1933,9 @@ ieee80211_mgmt_start_xmit(struct sk_buff
 		return 0;
 	}
 
-	if (skb_headroom(skb) < sdata->local->hw.extra_tx_headroom) {
-		if (pskb_expand_head(skb,
-		    sdata->local->hw.extra_tx_headroom, 0, GFP_ATOMIC)) {
+	if (skb_headroom(skb) < sdata->local->tx_headroom) {
+		if (pskb_expand_head(skb, sdata->local->tx_headroom,
+				     0, GFP_ATOMIC)) {
 			dev_kfree_skb(skb);
 			return 0;
 		}
@@ -2064,12 +2074,12 @@ struct sk_buff * ieee80211_beacon_get(st
 	bh_len = ap->beacon_head_len;
 	bt_len = ap->beacon_tail_len;
 
-	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
+	skb = dev_alloc_skb(local->tx_headroom +
 		bh_len + bt_len + 256 /* maximum TIM len */);
 	if (!skb)
 		return NULL;
 
-	skb_reserve(skb, local->hw.extra_tx_headroom);
+	skb_reserve(skb, local->tx_headroom);
 	memcpy(skb_put(skb, bh_len), b_head, bh_len);
 
 	ieee80211_include_sequence(sdata, (struct ieee80211_hdr *)skb->data);
@@ -2820,12 +2830,13 @@ ieee80211_rx_h_data_agg(struct ieee80211
 		if (subframe_len > remaining)
 			return TXRX_DROP;
 
-		frame = dev_alloc_skb(local->hw.extra_tx_headroom +
-				      subframe_len);
+		frame = dev_alloc_skb(local->tx_headroom + subframe_len);
 
 		if (frame == NULL)
 			return TXRX_DROP;
 
+		/* XXX: I think some skb_reserve is missing here */
+
 		memcpy(skb_put(frame, subframe_len), (u8*)eth, subframe_len);
 		skb_set_mac_header(frame, 0);
 		skb2 = NULL;
@@ -4600,6 +4611,9 @@ void ieee80211_tx_status(struct ieee8021
 	struct ieee80211_local *local = hw_to_local(hw);
 	u16 frag, type;
 	u32 msg_type;
+	struct ieee80211_tx_status_rtap_hdr *rthdr;
+	struct ieee80211_sub_if_data *sdata;
+	int monitors;
 
 	if (!status) {
 		printk(KERN_ERR
@@ -4711,27 +4725,100 @@ void ieee80211_tx_status(struct ieee8021
 			local->dot11FailedCount++;
 	}
 
-	if (!(status->control.flags & IEEE80211_TXCTL_REQ_TX_STATUS)
-	    || unlikely(!local->apdev)) {
+	msg_type = (status->flags & IEEE80211_TX_STATUS_ACK) ?
+		ieee80211_msg_tx_callback_ack : ieee80211_msg_tx_callback_fail;
+
+	/* this was a transmitted frame, but now we want to reuse it */
+	skb_orphan(skb);
+
+	if ((status->control.flags & IEEE80211_TXCTL_REQ_TX_STATUS) &&
+	    local->apdev) {
+		if (local->monitors) {
+			skb2 = skb_clone(skb, GFP_ATOMIC);
+		} else {
+			skb2 = skb;
+			skb = NULL;
+		}
+
+		if (skb2)
+			/* Send frame to hostapd */
+			ieee80211_rx_mgmt(local, skb2, NULL, msg_type);
+
+		if (!skb)
+			return;
+	}
+
+	if (!local->monitors) {
 		dev_kfree_skb(skb);
 		return;
 	}
 
-	msg_type = (status->flags & IEEE80211_TX_STATUS_ACK) ?
-		ieee80211_msg_tx_callback_ack : ieee80211_msg_tx_callback_fail;
+	/* send frame to monitor interfaces now */
 
-	/* skb was the original skb used for TX. Clone it and give the clone
-	 * to netif_rx(). Free original skb. */
-	skb2 = skb_copy(skb, GFP_ATOMIC);
-	if (!skb2) {
+	if (skb_headroom(skb) < sizeof(*rthdr)) {
+		printk(KERN_ERR "ieee80211_tx_status: headroom too small\n");
 		dev_kfree_skb(skb);
 		return;
 	}
-	dev_kfree_skb(skb);
-	skb = skb2;
 
-	/* Send frame to hostapd */
-	ieee80211_rx_mgmt(local, skb, NULL, msg_type);
+	rthdr = (struct ieee80211_tx_status_rtap_hdr*)
+				skb_push(skb, sizeof(*rthdr));
+
+	memset(rthdr, 0, sizeof(*rthdr));
+	rthdr->hdr.it_len = cpu_to_le16(sizeof(*rthdr));
+	rthdr->hdr.it_present =
+		cpu_to_le32((1 << IEEE80211_RADIOTAP_TX_FLAGS) |
+			    (1 << IEEE80211_RADIOTAP_DATA_RETRIES));
+
+	if (!(status->flags & IEEE80211_TX_STATUS_ACK) &&
+	    !is_multicast_ether_addr(hdr->addr1))
+		rthdr->tx_flags |= cpu_to_le16(IEEE80211_RADIOTAP_F_TX_FAIL);
+
+	if ((status->control.flags & IEEE80211_TXCTL_USE_RTS_CTS) &&
+	    (status->control.flags & IEEE80211_TXCTL_USE_CTS_PROTECT))
+		rthdr->tx_flags |= cpu_to_le16(IEEE80211_RADIOTAP_F_TX_CTS);
+	else if (status->control.flags & IEEE80211_TXCTL_USE_RTS_CTS)
+		rthdr->tx_flags |= cpu_to_le16(IEEE80211_RADIOTAP_F_TX_RTS);
+
+	rthdr->data_retries = status->retry_count;
+
+	read_lock(&local->sub_if_lock);
+	monitors = local->monitors;
+	list_for_each_entry(sdata, &local->sub_if_list, list) {
+		/*
+		 * Using the monitors counter is possibly racy, but
+		 * if the value is wrong we simply either clone the skb
+		 * once too much or forget sending it to one monitor iface
+		 * The latter case isn't nice but fixing the race is much
+		 * more complicated.
+		 */
+		if (!monitors || !skb)
+			goto out;
+
+		if (sdata->type == IEEE80211_IF_TYPE_MNTR) {
+			if (!netif_running(sdata->dev))
+				continue;
+			monitors--;
+			if (monitors)
+				skb2 = skb_clone(skb, GFP_KERNEL);
+			else
+				skb2 = NULL;
+			skb->dev = sdata->dev;
+			/* XXX: is this sufficient for BPF? */
+			skb_set_mac_header(skb, 0);
+			skb->ip_summed = CHECKSUM_UNNECESSARY;
+			skb->pkt_type = PACKET_OTHERHOST;
+			skb->protocol = htons(ETH_P_802_2);
+			memset(skb->cb, 0, sizeof(skb->cb));
+			netif_rx(skb);
+			skb = skb2;
+			break;
+		}
+	}
+ out:
+	read_unlock(&local->sub_if_lock);
+	if (skb)
+		dev_kfree_skb(skb);
 }
 EXPORT_SYMBOL(ieee80211_tx_status);
 
@@ -5033,6 +5120,14 @@ int ieee80211_register_hw(struct ieee802
 		goto fail_workqueue;
 	}
 
+	/*
+	 * The hardware needs headroom for sending the frame,
+	 * and we need some headroom for passing the frame to monitor
+	 * interfaces, but never both at the same time.
+	 */
+	local->tx_headroom = max(local->hw.extra_tx_headroom,
+				 sizeof(struct ieee80211_tx_status_rtap_hdr));
+
 	debugfs_hw_add(local);
 
 	local->hw.conf.beacon_int = 1000;
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-06-21 11:13:53.098645783 +0200
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-06-21 11:13:53.978645783 +0200
@@ -462,6 +462,7 @@ struct ieee80211_local {
 	int monitors;
 	struct iw_statistics wstats;
 	u8 wstats_flags;
+	int tx_headroom; /* required headroom for hardware/radiotap */
 
 	enum {
 		IEEE80211_DEV_UNINITIALIZED = 0,


