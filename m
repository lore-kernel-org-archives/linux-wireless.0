Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.227]:61666 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798AbYFVXp1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jun 2008 19:45:27 -0400
Received: by rv-out-0506.google.com with SMTP id k40so6742576rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 22 Jun 2008 16:45:26 -0700 (PDT)
Subject: [PATCH 2/4] mac80211: tx.c use new frame control helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 22 Jun 2008 16:45:27 -0700
Message-Id: <1214178327.21092.15.camel@brick> (sfid-20080623_014553_247693_4518EF3C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/tx.c |   54 ++++++++++++++++++++++++----------------------------
 1 files changed, 25 insertions(+), 29 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 195cb6d..4066ab9 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -52,9 +52,8 @@ static inline void ieee80211_include_sequence(struct ieee80211_sub_if_data *sdat
 static void ieee80211_dump_frame(const char *ifname, const char *title,
 				 const struct sk_buff *skb)
 {
-	const struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	u16 fc;
-	int hdrlen;
+	const struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	unsigned int hdrlen;
 	DECLARE_MAC_BUF(mac);
 
 	printk(KERN_DEBUG "%s: %s (len=%d)", ifname, title, skb->len);
@@ -63,13 +62,12 @@ static void ieee80211_dump_frame(const char *ifname, const char *title,
 		return;
 	}
 
-	fc = le16_to_cpu(hdr->frame_control);
-	hdrlen = ieee80211_get_hdrlen(fc);
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	if (hdrlen > skb->len)
 		hdrlen = skb->len;
 	if (hdrlen >= 4)
 		printk(" FC=0x%04x DUR=0x%04x",
-		       fc, le16_to_cpu(hdr->duration_id));
+		    le16_to_cpu(hdr->frame_control), le16_to_cpu(hdr->duration_id));
 	if (hdrlen >= 10)
 		printk(" A1=%s", print_mac(mac, hdr->addr1));
 	if (hdrlen >= 16)
@@ -281,7 +279,7 @@ ieee80211_tx_h_sequence(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
 
-	if (ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_control)) >= 24)
+	if (ieee80211_hdrlen(hdr->frame_control) >= 24)
 		ieee80211_include_sequence(tx->sdata, hdr);
 
 	return TX_CONTINUE;
@@ -542,8 +540,7 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 static ieee80211_tx_result
 ieee80211_tx_h_misc(struct ieee80211_tx_data *tx)
 {
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) tx->skb->data;
-	u16 fc = le16_to_cpu(hdr->frame_control);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
 	u16 dur;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 	struct ieee80211_supported_band *sband;
@@ -595,7 +592,7 @@ ieee80211_tx_h_misc(struct ieee80211_tx_data *tx)
 	/* Transmit data frames using short preambles if the driver supports
 	 * short preambles at the selected rate and short preambles are
 	 * available on the network at the current point in time. */
-	if (((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA) &&
+	if (ieee80211_is_data(hdr->frame_control) &&
 	    (sband->bitrates[tx->rate_idx].flags & IEEE80211_RATE_SHORT_PREAMBLE) &&
 	    tx->sdata->bss_conf.use_short_preamble &&
 	    (!tx->sta || test_sta_flags(tx->sta, WLAN_STA_SHORT_PREAMBLE))) {
@@ -647,7 +644,7 @@ ieee80211_tx_h_misc(struct ieee80211_tx_data *tx)
 static ieee80211_tx_result
 ieee80211_tx_h_fragment(struct ieee80211_tx_data *tx)
 {
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) tx->skb->data;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
 	size_t hdrlen, per_fragm, num_fragm, payload_len, left;
 	struct sk_buff **frags, *first, *frag;
 	int i;
@@ -670,7 +667,7 @@ ieee80211_tx_h_fragment(struct ieee80211_tx_data *tx)
 
 	first = tx->skb;
 
-	hdrlen = ieee80211_get_hdrlen(tx->fc);
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	payload_len = first->len - hdrlen;
 	per_fragm = frag_threshold - hdrlen - FCS_LEN;
 	num_fragm = DIV_ROUND_UP(payload_len, per_fragm);
@@ -1379,7 +1376,8 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 	struct ieee80211_tx_info *info;
 	struct ieee80211_sub_if_data *sdata;
 	int ret = 1, head_need;
-	u16 ethertype, hdrlen,  meshhdrlen = 0, fc;
+	u16 ethertype, hdrlen,  meshhdrlen = 0;
+	__le16 fc;
 	struct ieee80211_hdr hdr;
 	struct ieee80211s_hdr mesh_hdr;
 	const u8 *encaps_data;
@@ -1402,12 +1400,12 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 	/* convert Ethernet header to proper 802.11 header (based on
 	 * operation mode) */
 	ethertype = (skb->data[12] << 8) | skb->data[13];
-	fc = IEEE80211_FTYPE_DATA | IEEE80211_STYPE_DATA;
+	fc = cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_DATA);
 
 	switch (sdata->vif.type) {
 	case IEEE80211_IF_TYPE_AP:
 	case IEEE80211_IF_TYPE_VLAN:
-		fc |= IEEE80211_FCTL_FROMDS;
+		fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS);
 		/* DA BSSID SA */
 		memcpy(hdr.addr1, skb->data, ETH_ALEN);
 		memcpy(hdr.addr2, dev->dev_addr, ETH_ALEN);
@@ -1415,7 +1413,7 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 		hdrlen = 24;
 		break;
 	case IEEE80211_IF_TYPE_WDS:
-		fc |= IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS;
+		fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS);
 		/* RA TA DA SA */
 		memcpy(hdr.addr1, sdata->u.wds.remote_addr, ETH_ALEN);
 		memcpy(hdr.addr2, dev->dev_addr, ETH_ALEN);
@@ -1425,7 +1423,7 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 		break;
 #ifdef CONFIG_MAC80211_MESH
 	case IEEE80211_IF_TYPE_MESH_POINT:
-		fc |= IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS;
+		fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS);
 		/* RA TA DA SA */
 		if (is_multicast_ether_addr(skb->data))
 			memcpy(hdr.addr1, skb->data, ETH_ALEN);
@@ -1455,7 +1453,7 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 		break;
 #endif
 	case IEEE80211_IF_TYPE_STA:
-		fc |= IEEE80211_FCTL_TODS;
+		fc |= cpu_to_le16(IEEE80211_FCTL_TODS);
 		/* BSSID SA DA */
 		memcpy(hdr.addr1, sdata->u.sta.bssid, ETH_ALEN);
 		memcpy(hdr.addr2, skb->data + ETH_ALEN, ETH_ALEN);
@@ -1490,7 +1488,7 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 	/* receiver and we are QoS enabled, use a QoS type frame */
 	if (sta_flags & WLAN_STA_WME &&
 	    ieee80211_num_regular_queues(&local->hw) >= 4) {
-		fc |= IEEE80211_STYPE_QOS_DATA;
+		fc |= cpu_to_le16(IEEE80211_STYPE_QOS_DATA);
 		hdrlen += 2;
 	}
 
@@ -1518,7 +1516,7 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 		goto fail;
 	}
 
-	hdr.frame_control = cpu_to_le16(fc);
+	hdr.frame_control = fc;
 	hdr.duration_id = 0;
 	hdr.seq_ctrl = 0;
 
@@ -1587,7 +1585,7 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 		h_pos += meshhdrlen;
 	}
 
-	if (fc & IEEE80211_STYPE_QOS_DATA) {
+	if (ieee80211_is_data_qos(fc)) {
 		__le16 *qos_control;
 
 		qos_control = (__le16*) skb_push(skb, 2);
@@ -1845,8 +1843,8 @@ struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
 		mgmt = (struct ieee80211_mgmt *)
 			skb_put(skb, 24 + sizeof(mgmt->u.beacon));
 		memset(mgmt, 0, 24 + sizeof(mgmt->u.beacon));
-		mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
-						   IEEE80211_STYPE_BEACON);
+		mgmt->frame_control =
+		    cpu_to_le16(IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_BEACON);
 		memset(mgmt->da, 0xff, ETH_ALEN);
 		memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
 		/* BSSID is left zeroed, wildcard value */
@@ -1914,10 +1912,9 @@ void ieee80211_rts_get(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		       struct ieee80211_rts *rts)
 {
 	const struct ieee80211_hdr *hdr = frame;
-	u16 fctl;
 
-	fctl = IEEE80211_FTYPE_CTL | IEEE80211_STYPE_RTS;
-	rts->frame_control = cpu_to_le16(fctl);
+	rts->frame_control =
+	    cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_RTS);
 	rts->duration = ieee80211_rts_duration(hw, vif, frame_len,
 					       frame_txctl);
 	memcpy(rts->ra, hdr->addr1, sizeof(rts->ra));
@@ -1931,10 +1928,9 @@ void ieee80211_ctstoself_get(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			     struct ieee80211_cts *cts)
 {
 	const struct ieee80211_hdr *hdr = frame;
-	u16 fctl;
 
-	fctl = IEEE80211_FTYPE_CTL | IEEE80211_STYPE_CTS;
-	cts->frame_control = cpu_to_le16(fctl);
+	cts->frame_control =
+	    cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_CTS);
 	cts->duration = ieee80211_ctstoself_duration(hw, vif,
 						     frame_len, frame_txctl);
 	memcpy(cts->ra, hdr->addr1, sizeof(cts->ra));
-- 
1.5.6.290.gc4e15


