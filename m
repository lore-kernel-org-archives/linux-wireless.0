Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:41046 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254AbXBNNYE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Feb 2007 08:24:04 -0500
Received: by ug-out-1314.google.com with SMTP id 44so185155uga
        for <linux-wireless@vger.kernel.org>; Wed, 14 Feb 2007 05:23:58 -0800 (PST)
To: Jiri Benc <jbenc@suse.cz>, "John Linville" <linville@tuxdriver.com>
Subject: [PATCH v2] d80211: Add software sequence support
Date: Wed, 14 Feb 2007 14:23:27 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702141423.27823.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Most hardware can keep track of sequence numbers themselves,
unfortunately *most* doesn't cover all devices. ;)
This patch will keep track of the (per-bss) sequence number
if the flag IEEE80211_HW_SOFTWARE_SEQUENCE has been set.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/include/net/d80211.h b/include/net/d80211.h
index 326def5..5dd4943 100644
--- a/include/net/d80211.h
+++ b/include/net/d80211.h
@@ -534,6 +534,9 @@ struct ieee80211_hw {
 	 * per-packet RC4 key with each TX frame when doing hwcrypto */
 #define IEEE80211_HW_TKIP_REQ_PHASE2_KEY (1<<14)
 
+	/* Does the HOST need to insert the frame sequence counter */
+#define IEEE80211_HW_SOFTWARE_SEQUENCE (1<<15)
+
 	u32 flags;			/* hardware flags defined above */
 
 	/* Set to the size of a needed device specific skb headroom for TX skbs. */
diff --git a/net/d80211/ieee80211.c b/net/d80211/ieee80211.c
index 82daeb8..455f67a 100644
--- a/net/d80211/ieee80211.c
+++ b/net/d80211/ieee80211.c
@@ -50,6 +50,29 @@ static u8 * ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len);
 static int ieee80211_mgmt_start_xmit(struct sk_buff *skb,
 				     struct net_device *dev);
 
+static void ieee80211_include_sequence(struct net_device *dev,
+				       struct ieee80211_hdr *hdr)
+{
+	struct ieee80211_sta_bss *bss;
+	u8 *bssid = ieee80211_get_bssid(hdr, sizeof(*hdr));
+
+	bss = ieee80211_rx_bss_get(dev, bssid);
+	if (!bss)
+		return;
+
+       /*
+        * Set the sequence number for this frame.
+        */
+	hdr->seq_ctrl = cpu_to_le16(bss->sequence & IEEE80211_SCTL_SEQ);
+
+       /*
+        * Increase the sequence number.
+        */
+	bss->sequence = (bss->sequence + 0x10) & IEEE80211_SCTL_SEQ;
+
+	ieee80211_rx_bss_put(dev, bss);
+}
+
 struct ieee80211_key_conf *
 ieee80211_key_data2conf(struct ieee80211_local *local,
 			struct ieee80211_key *data)
@@ -441,6 +464,7 @@ ieee80211_tx_h_fragment(struct ieee80211_txrx_data *tx)
 	size_t hdrlen, per_fragm, num_fragm, payload_len, left;
 	struct sk_buff **frags, *first, *frag;
 	int i;
+	u16 seq;
         u8 *pos;
 	int frag_threshold = tx->local->fragmentation_threshold;
 
@@ -459,6 +483,7 @@ ieee80211_tx_h_fragment(struct ieee80211_txrx_data *tx)
 		goto fail;
 
 	hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREFRAGS);
+	seq = le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_SEQ;
 	pos = first->data + hdrlen + per_fragm;
 	left = payload_len - per_fragm;
 	for (i = 0; i < num_fragm - 1; i++) {
@@ -486,7 +511,7 @@ ieee80211_tx_h_fragment(struct ieee80211_txrx_data *tx)
 		memcpy(fhdr, first->data, hdrlen);
 		if (i == num_fragm - 2)
 			fhdr->frame_control &= cpu_to_le16(~IEEE80211_FCTL_MOREFRAGS);
-		fhdr->seq_ctrl = cpu_to_le16(i + 1);
+		fhdr->seq_ctrl = cpu_to_le16(seq + ((i + 1) & IEEE80211_SCTL_FRAG));
 		copylen = left > per_fragm ? per_fragm : left;
 		memcpy(skb_put(frag, copylen), pos, copylen);
 
@@ -896,6 +921,17 @@ ieee80211_tx_h_check_assoc(struct ieee80211_txrx_data *tx)
 	return TXRX_CONTINUE;
 }
 
+static ieee80211_txrx_result
+ieee80211_tx_h_sequence(struct ieee80211_txrx_data *tx)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
+
+	if ((tx->local->hw.flags & IEEE80211_HW_SOFTWARE_SEQUENCE) &&
+	    ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_control)) >= 24)
+		ieee80211_include_sequence(tx->dev, hdr);
+
+	return TXRX_CONTINUE;
+}
 
 /* This function is called whenever the AP is about to exceed the maximum limit
  * of buffered frames for power saving STAs. This situation should not really
@@ -1765,6 +1801,10 @@ struct sk_buff * ieee80211_beacon_get(struct ieee80211_hw *hw, int if_id,
 	skb_reserve(skb, local->hw.extra_tx_headroom);
 	memcpy(skb_put(skb, bh_len), b_head, bh_len);
 
+	if (hw->flags & IEEE80211_HW_SOFTWARE_SEQUENCE)
+		ieee80211_include_sequence(bdev,
+			(struct ieee80211_hdr *)skb->data);
+
 	ieee80211_beacon_add_tim(local, ap, skb);
 
 	if (b_tail) {
@@ -4369,6 +4409,7 @@ static ieee80211_rx_handler ieee80211_rx_handlers[] =
 static ieee80211_tx_handler ieee80211_tx_handlers[] =
 {
 	ieee80211_tx_h_check_assoc,
+	ieee80211_tx_h_sequence,
 	ieee80211_tx_h_ps_buf,
 	ieee80211_tx_h_select_key,
 	ieee80211_tx_h_michael_mic_add,
diff --git a/net/d80211/ieee80211_i.h b/net/d80211/ieee80211_i.h
index 5ab9eb5..1891e05 100644
--- a/net/d80211/ieee80211_i.h
+++ b/net/d80211/ieee80211_i.h
@@ -80,6 +80,7 @@ struct ieee80211_sta_bss {
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	size_t ssid_len;
 	u16 capability; /* host byte order */
+	u16 sequence;
 	int hw_mode;
 	int channel;
 	int freq;
@@ -682,6 +683,10 @@ struct sta_info * ieee80211_ibss_add_sta(struct net_device *dev,
 					 u8 *addr);
 int ieee80211_sta_deauthenticate(struct net_device *dev, u16 reason);
 int ieee80211_sta_disassociate(struct net_device *dev, u16 reason);
+struct ieee80211_sta_bss *
+ieee80211_rx_bss_get(struct net_device *dev, u8 *bssid);
+void ieee80211_rx_bss_put(struct net_device *dev,
+			  struct ieee80211_sta_bss *bss);
 
 /* ieee80211_dev.c */
 int ieee80211_dev_alloc_index(struct ieee80211_local *local);
diff --git a/net/d80211/ieee80211_sta.c b/net/d80211/ieee80211_sta.c
index 433a11b..64c9c9f 100644
--- a/net/d80211/ieee80211_sta.c
+++ b/net/d80211/ieee80211_sta.c
@@ -57,10 +57,6 @@
 
 static void ieee80211_send_probe_req(struct net_device *dev, u8 *dst,
 				     u8 *ssid, size_t ssid_len);
-static struct ieee80211_sta_bss *
-ieee80211_rx_bss_get(struct net_device *dev, u8 *bssid);
-static void ieee80211_rx_bss_put(struct net_device *dev,
-				 struct ieee80211_sta_bss *bss);
 static int ieee80211_sta_find_ibss(struct net_device *dev,
 				   struct ieee80211_if_sta *ifsta);
 static int ieee80211_sta_wep_configured(struct net_device *dev);
@@ -1274,7 +1270,7 @@ ieee80211_rx_bss_add(struct net_device *dev, u8 *bssid)
 }
 
 
-static struct ieee80211_sta_bss *
+struct ieee80211_sta_bss *
 ieee80211_rx_bss_get(struct net_device *dev, u8 *bssid)
 {
 	struct ieee80211_local *local = dev->ieee80211_ptr;
@@ -1303,8 +1299,8 @@ static void ieee80211_rx_bss_free(struct ieee80211_sta_bss *bss)
 }
 
 
-static void ieee80211_rx_bss_put(struct net_device *dev,
-				 struct ieee80211_sta_bss *bss)
+void ieee80211_rx_bss_put(struct net_device *dev,
+			  struct ieee80211_sta_bss *bss)
 {
 	struct ieee80211_local *local = dev->ieee80211_ptr;
 	if (!atomic_dec_and_test(&bss->users))
