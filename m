Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:49304 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbXCJTV5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Mar 2007 14:21:57 -0500
Received: by ug-out-1314.google.com with SMTP id 44so1729600uga
        for <linux-wireless@vger.kernel.org>; Sat, 10 Mar 2007 11:21:55 -0800 (PST)
To: John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>
Subject: [PATCH v3] d80211: Add software sequence support
Date: Sat, 10 Mar 2007 20:21:39 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>
References: <200702141423.27823.IvDoorn@gmail.com> <200703101251.07345.flamingice@sourmilk.net> <200703102001.41004.IvDoorn@gmail.com>
In-Reply-To: <200703102001.41004.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200703102021.40041.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Most hardware can keep track of sequence numbers themselves,
unfortunately *most* doesn't cover all devices. ;)
This patch will keep track of the (per-bss) sequence number
if the flag IEEE80211_HW_SOFTWARE_SEQUENCE has been set.

This 3rd version of the patch has the sequence number stored
in the ieee80211_sub_if_data structure.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 82ea43f..e32e28a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -515,6 +515,9 @@ struct ieee80211_hw {
 	 * normal operation. */
 #define IEEE80211_HW_MONITOR_DURING_OPER (1<<9)
 
+	/* Does the HOST need to insert the frame sequence counter */
+#define IEEE80211_HW_SOFTWARE_SEQUENCE (1<<10)
+
 	/* please fill this gap when adding new flags */
 
 	/* calculate Michael MIC for an MSDU when doing hwcrypto */
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 577dbe3..79c2a60 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -54,6 +54,20 @@ static u8 * ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len);
 static int ieee80211_mgmt_start_xmit(struct sk_buff *skb,
 				     struct net_device *dev);
 
+static void ieee80211_include_sequence(struct ieee80211_sub_if_data *sdata,
+				       struct ieee80211_hdr *hdr)
+{
+	/*
+	 * Set the sequence number for this frame.
+	 */
+	hdr->seq_ctrl = cpu_to_le16(sdata->sequence & IEEE80211_SCTL_SEQ);
+
+	/*
+	 * Increase the sequence number.
+	 */
+	sdata->sequence = (sdata->sequence + 0x10) & IEEE80211_SCTL_SEQ;
+}
+
 struct ieee80211_key_conf *
 ieee80211_key_data2conf(struct ieee80211_local *local,
 			const struct ieee80211_key *data)
@@ -445,6 +459,7 @@ ieee80211_tx_h_fragment(struct ieee80211_txrx_data *tx)
 	size_t hdrlen, per_fragm, num_fragm, payload_len, left;
 	struct sk_buff **frags, *first, *frag;
 	int i;
+	u16 seq;
 	u8 *pos;
 	int frag_threshold = tx->local->fragmentation_threshold;
 
@@ -463,6 +478,7 @@ ieee80211_tx_h_fragment(struct ieee80211_txrx_data *tx)
 		goto fail;
 
 	hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREFRAGS);
+	seq = le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_SEQ;
 	pos = first->data + hdrlen + per_fragm;
 	left = payload_len - per_fragm;
 	for (i = 0; i < num_fragm - 1; i++) {
@@ -490,7 +506,7 @@ ieee80211_tx_h_fragment(struct ieee80211_txrx_data *tx)
 		memcpy(fhdr, first->data, hdrlen);
 		if (i == num_fragm - 2)
 			fhdr->frame_control &= cpu_to_le16(~IEEE80211_FCTL_MOREFRAGS);
-		fhdr->seq_ctrl = cpu_to_le16(i + 1);
+		fhdr->seq_ctrl = cpu_to_le16(seq + ((i + 1) & IEEE80211_SCTL_FRAG));
 		copylen = left > per_fragm ? per_fragm : left;
 		memcpy(skb_put(frag, copylen), pos, copylen);
 
@@ -900,6 +916,17 @@ ieee80211_tx_h_check_assoc(struct ieee80211_txrx_data *tx)
 	return TXRX_CONTINUE;
 }
 
+static ieee80211_txrx_result
+ieee80211_tx_h_sequence(struct ieee80211_txrx_data *tx)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
+
+	if ((tx->local->hw.flags & IEEE80211_HW_SOFTWARE_SEQUENCE) &&
+	    ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_control)) >= 24)
+		ieee80211_include_sequence(tx->sdata, hdr);
+
+	return TXRX_CONTINUE;
+}
 
 /* This function is called whenever the AP is about to exceed the maximum limit
  * of buffered frames for power saving STAs. This situation should not really
@@ -1770,6 +1797,10 @@ struct sk_buff * ieee80211_beacon_get(struct ieee80211_hw *hw, int if_id,
 	skb_reserve(skb, local->hw.extra_tx_headroom);
 	memcpy(skb_put(skb, bh_len), b_head, bh_len);
 
+	if (hw->flags & IEEE80211_HW_SOFTWARE_SEQUENCE)
+		ieee80211_include_sequence(sdata,
+			(struct ieee80211_hdr *)skb->data);
+
 	ieee80211_beacon_add_tim(local, ap, skb);
 
 	if (b_tail) {
@@ -4381,6 +4412,7 @@ static ieee80211_rx_handler ieee80211_rx_handlers[] =
 static ieee80211_tx_handler ieee80211_tx_handlers[] =
 {
 	ieee80211_tx_h_check_assoc,
+	ieee80211_tx_h_sequence,
 	ieee80211_tx_h_ps_buf,
 	ieee80211_tx_h_select_key,
 	ieee80211_tx_h_michael_mic_add,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9df8ef0..4b7c427 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -317,6 +317,8 @@ struct ieee80211_sub_if_data {
 	int ieee802_1x; /* IEEE 802.1X PAE - drop packet to/from unauthorized
 			 * port */
 
+	u16 sequence;
+
 	/* Fragment table for host-based reassembly */
 	struct ieee80211_fragment_entry	fragments[IEEE80211_FRAGMENT_MAX];
 	unsigned int fragment_next;
