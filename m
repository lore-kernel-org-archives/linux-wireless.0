Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40593 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab1GGQpG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jul 2011 12:45:06 -0400
Subject: [PATCH] mac80211: simplify RX PN/IV handling
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jul 2011 18:45:03 +0200
Message-ID: <1310057103.3924.5.camel@jlt3.sipsolutions.net> (sfid-20110707_184511_741681_96BDD75F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The current rx->queue value is slightly confusing.
It is set to 16 on non-QoS frames, including data,
and then used for sequence number and PN/IV checks.
Until recently, we had a TKIP IV checking bug that
had been introduced in 2008 to fix a seqno issue.
Before that, we always used TID 0 for checking the
PN or IV on non-QoS packets.

Go back to the old status for PN/IV checks using
the TID 0 counter for non-QoS by splitting up the
rx->queue value into "seqno_idx" and "security_idx"
in order to avoid confusion in the future. They
each have special rules on the value used for non-
QoS data frames.

Since the handling is now unified, also revert the
special TKIP handling from my patch
"mac80211: fix TKIP replay vulnerability".

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |   17 ++++++++++++++++-
 net/mac80211/key.h         |    2 +-
 net/mac80211/rx.c          |   33 +++++++++++++++++++++------------
 net/mac80211/sta_info.h    |    3 ++-
 net/mac80211/wpa.c         |   19 ++++---------------
 5 files changed, 44 insertions(+), 30 deletions(-)

--- a/net/mac80211/ieee80211_i.h	2011-07-07 18:00:38.000000000 +0200
+++ b/net/mac80211/ieee80211_i.h	2011-07-07 18:39:02.000000000 +0200
@@ -202,7 +202,22 @@ struct ieee80211_rx_data {
 	struct ieee80211_key *key;
 
 	unsigned int flags;
-	int queue;
+
+	/*
+	 * Index into sequence numbers array, 0..16
+	 * since the last (16) is used for non-QoS,
+	 * will be 16 on non-QoS frames.
+	 */
+	int seqno_idx;
+
+	/*
+	 * Index into the security IV/PN arrays, 0..16
+	 * since the last (16) is used for CCMP-encrypted
+	 * management frames, will be set to 16 on mgmt
+	 * frames and 0 on non-QoS frames.
+	 */
+	int security_idx;
+
 	u32 tkip_iv32;
 	u16 tkip_iv16;
 };
--- a/net/mac80211/key.h	2011-07-07 18:37:58.000000000 +0200
+++ b/net/mac80211/key.h	2011-07-07 18:39:02.000000000 +0200
@@ -29,7 +29,7 @@
 #define TKIP_IV_LEN		8
 #define TKIP_ICV_LEN		4
 
-#define NUM_RX_DATA_QUEUES	17
+#define NUM_RX_DATA_QUEUES	16
 
 struct ieee80211_local;
 struct ieee80211_sub_if_data;
--- a/net/mac80211/rx.c	2011-07-07 18:00:38.000000000 +0200
+++ b/net/mac80211/rx.c	2011-07-07 18:39:02.000000000 +0200
@@ -331,7 +331,7 @@ static void ieee80211_parse_qos(struct i
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
-	int tid;
+	int tid, seqno_idx, security_idx;
 
 	/* does the frame have a qos control field? */
 	if (ieee80211_is_data_qos(hdr->frame_control)) {
@@ -340,6 +340,9 @@ static void ieee80211_parse_qos(struct i
 		tid = *qc & IEEE80211_QOS_CTL_TID_MASK;
 		if (*qc & IEEE80211_QOS_CTL_A_MSDU_PRESENT)
 			status->rx_flags |= IEEE80211_RX_AMSDU;
+
+		seqno_idx = tid;
+		security_idx = tid;
 	} else {
 		/*
 		 * IEEE 802.11-2007, 7.1.3.4.1 ("Sequence Number field"):
@@ -352,10 +355,15 @@ static void ieee80211_parse_qos(struct i
 		 *
 		 * We also use that counter for non-QoS STAs.
 		 */
-		tid = NUM_RX_DATA_QUEUES - 1;
+		seqno_idx = NUM_RX_DATA_QUEUES;
+		security_idx = 0;
+		if (ieee80211_is_mgmt(hdr->frame_control))
+			security_idx = NUM_RX_DATA_QUEUES;
+		tid = 0;
 	}
 
-	rx->queue = tid;
+	rx->seqno_idx = seqno_idx;
+	rx->security_idx = security_idx;
 	/* Set skb->priority to 1d tag if highest order bit of TID is not set.
 	 * For now, set skb->priority to 0 for other cases. */
 	rx->skb->priority = (tid > 7) ? 0 : tid;
@@ -810,7 +818,7 @@ ieee80211_rx_h_check(struct ieee80211_rx
 	/* Drop duplicate 802.11 retransmissions (IEEE 802.11 Chap. 9.2.9) */
 	if (rx->sta && !is_multicast_ether_addr(hdr->addr1)) {
 		if (unlikely(ieee80211_has_retry(hdr->frame_control) &&
-			     rx->sta->last_seq_ctrl[rx->queue] ==
+			     rx->sta->last_seq_ctrl[rx->seqno_idx] ==
 			     hdr->seq_ctrl)) {
 			if (status->rx_flags & IEEE80211_RX_RA_MATCH) {
 				rx->local->dot11FrameDuplicateCount++;
@@ -818,7 +826,7 @@ ieee80211_rx_h_check(struct ieee80211_rx
 			}
 			return RX_DROP_UNUSABLE;
 		} else
-			rx->sta->last_seq_ctrl[rx->queue] = hdr->seq_ctrl;
+			rx->sta->last_seq_ctrl[rx->seqno_idx] = hdr->seq_ctrl;
 	}
 
 	if (unlikely(rx->skb->len < 16)) {
@@ -1374,11 +1382,10 @@ ieee80211_rx_h_defragment(struct ieee802
 	if (frag == 0) {
 		/* This is the first fragment of a new frame. */
 		entry = ieee80211_reassemble_add(rx->sdata, frag, seq,
-						 rx->queue, &(rx->skb));
+						 rx->seqno_idx, &(rx->skb));
 		if (rx->key && rx->key->conf.cipher == WLAN_CIPHER_SUITE_CCMP &&
 		    ieee80211_has_protected(fc)) {
-			int queue = ieee80211_is_mgmt(fc) ?
-				NUM_RX_DATA_QUEUES : rx->queue;
+			int queue = rx->security_idx;
 			/* Store CCMP PN so that we can verify that the next
 			 * fragment has a sequential PN value. */
 			entry->ccmp = 1;
@@ -1392,7 +1399,8 @@ ieee80211_rx_h_defragment(struct ieee802
 	/* This is a fragment for a frame that should already be pending in
 	 * fragment cache. Add this fragment to the end of the pending entry.
 	 */
-	entry = ieee80211_reassemble_find(rx->sdata, frag, seq, rx->queue, hdr);
+	entry = ieee80211_reassemble_find(rx->sdata, frag, seq,
+					  rx->seqno_idx, hdr);
 	if (!entry) {
 		I802_DEBUG_INC(rx->local->rx_handlers_drop_defrag);
 		return RX_DROP_MONITOR;
@@ -1412,8 +1420,7 @@ ieee80211_rx_h_defragment(struct ieee802
 			if (pn[i])
 				break;
 		}
-		queue = ieee80211_is_mgmt(fc) ?
-			NUM_RX_DATA_QUEUES : rx->queue;
+		queue = rx->security_idx;
 		rpn = rx->key->u.ccmp.rx_pn[queue];
 		if (memcmp(pn, rpn, CCMP_PN_LEN))
 			return RX_DROP_UNUSABLE;
@@ -2590,7 +2597,9 @@ void ieee80211_release_reorder_timeout(s
 		.sta = sta,
 		.sdata = sta->sdata,
 		.local = sta->local,
-		.queue = tid,
+		/* This is OK -- must be QoS data frame */
+		.security_idx = tid,
+		.seqno_idx = tid,
 		.flags = 0,
 	};
 	struct tid_ampdu_rx *tid_agg_rx;
--- a/net/mac80211/sta_info.h	2011-07-07 18:00:38.000000000 +0200
+++ b/net/mac80211/sta_info.h	2011-07-07 18:39:02.000000000 +0200
@@ -287,7 +287,8 @@ struct sta_info {
 	unsigned long rx_dropped;
 	int last_signal;
 	struct ewma avg_signal;
-	__le16 last_seq_ctrl[NUM_RX_DATA_QUEUES];
+	/* Plus 1 for non-QoS frames */
+	__le16 last_seq_ctrl[NUM_RX_DATA_QUEUES + 1];
 
 	/* Updated from TX status path only, no locking requirements */
 	unsigned long tx_filtered_count;
--- a/net/mac80211/wpa.c	2011-07-07 18:38:31.000000000 +0200
+++ b/net/mac80211/wpa.c	2011-07-07 18:39:02.000000000 +0200
@@ -87,11 +87,6 @@ ieee80211_rx_h_michael_mic_verify(struct
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	int queue = rx->queue;
-
-	/* otherwise, TKIP is vulnerable to TID 0 vs. non-QoS replays */
-	if (rx->queue == NUM_RX_DATA_QUEUES - 1)
-		queue = 0;
 
 	/*
 	 * it makes no sense to check for MIC errors on anything other
@@ -154,8 +149,8 @@ ieee80211_rx_h_michael_mic_verify(struct
 
 update_iv:
 	/* update IV in key information to be able to detect replays */
-	rx->key->u.tkip.rx[queue].iv32 = rx->tkip_iv32;
-	rx->key->u.tkip.rx[queue].iv16 = rx->tkip_iv16;
+	rx->key->u.tkip.rx[rx->security_idx].iv32 = rx->tkip_iv32;
+	rx->key->u.tkip.rx[rx->security_idx].iv16 = rx->tkip_iv16;
 
 	return RX_CONTINUE;
 
@@ -248,11 +243,6 @@ ieee80211_crypto_tkip_decrypt(struct iee
 	struct ieee80211_key *key = rx->key;
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
-	int queue = rx->queue;
-
-	/* otherwise, TKIP is vulnerable to TID 0 vs. non-QoS replays */
-	if (rx->queue == NUM_RX_DATA_QUEUES - 1)
-		queue = 0;
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 
@@ -273,7 +263,7 @@ ieee80211_crypto_tkip_decrypt(struct iee
 	res = ieee80211_tkip_decrypt_data(rx->local->wep_rx_tfm,
 					  key, skb->data + hdrlen,
 					  skb->len - hdrlen, rx->sta->sta.addr,
-					  hdr->addr1, hwaccel, queue,
+					  hdr->addr1, hwaccel, rx->security_idx,
 					  &rx->tkip_iv32,
 					  &rx->tkip_iv16);
 	if (res != TKIP_DECRYPT_OK)
@@ -488,8 +478,7 @@ ieee80211_crypto_ccmp_decrypt(struct iee
 
 	ccmp_hdr2pn(pn, skb->data + hdrlen);
 
-	queue = ieee80211_is_mgmt(hdr->frame_control) ?
-		NUM_RX_DATA_QUEUES : rx->queue;
+	queue = rx->security_idx;
 
 	if (memcmp(pn, key->u.ccmp.rx_pn[queue], CCMP_PN_LEN) <= 0) {
 		key->u.ccmp.replays++;


