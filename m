Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:49004 "EHLO silver.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934318AbXCWUnq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 16:43:46 -0400
From: Jiri Benc <jbenc@suse.cz>
To: "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20070323214400.642621638.midnight@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 19/19] mac80211: Add software sequence support
Message-Id: <20070323204502.446944859D@silver.suse.cz>
Date: Fri, 23 Mar 2007 21:45:02 +0100 (CET)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ivo van Doorn <ivdoorn@gmail.com>

Most hardware can keep track of sequence numbers themselves,
unfortunately *most* doesn't cover all devices. ;)
This patch will keep track of the (per-bss) sequence number.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: Jiri Benc <jbenc@suse.cz>

---

 net/mac80211/ieee80211.c   |   27 ++++++++++++++++++++++++++-
 net/mac80211/ieee80211_i.h |    2 ++
 2 files changed, 28 insertions(+), 1 deletions(-)

35262af661f8561e197b093581889e85ef6f5d74
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 39468b8..3bf0be4 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -59,6 +59,16 @@ static u8 * ieee80211_get_bssid(struct i
 static int ieee80211_mgmt_start_xmit(struct sk_buff *skb,
 				     struct net_device *dev);
 
+static inline void ieee80211_include_sequence(struct ieee80211_sub_if_data *sdata,
+					      struct ieee80211_hdr *hdr)
+{
+	/* Set the sequence number for this frame. */
+	hdr->seq_ctrl = cpu_to_le16(sdata->sequence);
+
+	/* Increase the sequence number. */
+	sdata->sequence = (sdata->sequence + 0x10) & IEEE80211_SCTL_SEQ;
+}
+
 struct ieee80211_key_conf *
 ieee80211_key_data2conf(struct ieee80211_local *local,
 			const struct ieee80211_key *data)
@@ -437,6 +447,7 @@ ieee80211_tx_h_fragment(struct ieee80211
 	size_t hdrlen, per_fragm, num_fragm, payload_len, left;
 	struct sk_buff **frags, *first, *frag;
 	int i;
+	u16 seq;
 	u8 *pos;
 	int frag_threshold = tx->local->fragmentation_threshold;
 
@@ -455,6 +466,7 @@ ieee80211_tx_h_fragment(struct ieee80211
 		goto fail;
 
 	hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREFRAGS);
+	seq = le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_SEQ;
 	pos = first->data + hdrlen + per_fragm;
 	left = payload_len - per_fragm;
 	for (i = 0; i < num_fragm - 1; i++) {
@@ -482,7 +494,7 @@ ieee80211_tx_h_fragment(struct ieee80211
 		memcpy(fhdr, first->data, hdrlen);
 		if (i == num_fragm - 2)
 			fhdr->frame_control &= cpu_to_le16(~IEEE80211_FCTL_MOREFRAGS);
-		fhdr->seq_ctrl = cpu_to_le16(i + 1);
+		fhdr->seq_ctrl = cpu_to_le16(seq | ((i + 1) & IEEE80211_SCTL_FRAG));
 		copylen = left > per_fragm ? per_fragm : left;
 		memcpy(skb_put(frag, copylen), pos, copylen);
 
@@ -894,6 +906,16 @@ #endif
 	return TXRX_CONTINUE;
 }
 
+static ieee80211_txrx_result
+ieee80211_tx_h_sequence(struct ieee80211_txrx_data *tx)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
+
+	if (ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_control)) >= 24)
+		ieee80211_include_sequence(tx->sdata, hdr);
+
+	return TXRX_CONTINUE;
+}
 
 /* This function is called whenever the AP is about to exceed the maximum limit
  * of buffered frames for power saving STAs. This situation should not really
@@ -1766,6 +1788,8 @@ #endif /* CONFIG_MAC80211_VERBOSE_DEBUG 
 	skb_reserve(skb, local->hw.extra_tx_headroom);
 	memcpy(skb_put(skb, bh_len), b_head, bh_len);
 
+	ieee80211_include_sequence(sdata, (struct ieee80211_hdr *)skb->data);
+
 	ieee80211_beacon_add_tim(local, ap, skb);
 
 	if (b_tail) {
@@ -4373,6 +4397,7 @@ static ieee80211_rx_handler ieee80211_rx
 static ieee80211_tx_handler ieee80211_tx_handlers[] =
 {
 	ieee80211_tx_h_check_assoc,
+	ieee80211_tx_h_sequence,
 	ieee80211_tx_h_ps_buf,
 	ieee80211_tx_h_select_key,
 	ieee80211_tx_h_michael_mic_add,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3c10152..561c976 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -318,6 +318,8 @@ struct ieee80211_sub_if_data {
 	int ieee802_1x; /* IEEE 802.1X PAE - drop packet to/from unauthorized
 			 * port */
 
+	u16 sequence;
+
 	/* Fragment table for host-based reassembly */
 	struct ieee80211_fragment_entry	fragments[IEEE80211_FRAGMENT_MAX];
 	unsigned int fragment_next;
-- 
1.3.0

