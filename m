Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:31123 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340AbYFJA3A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 20:29:00 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2335551wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jun 2008 17:29:00 -0700 (PDT)
Subject: [RFC-PATCH] mac80211: eliminate cached fc from struct
	ieee80211_{tx|rx}_data
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Tomas Winkler <tomasw@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 09 Jun 2008 17:28:57 -0700
Message-Id: <1213057737.5974.118.camel@brick> (sfid-20080610_022907_420119_9272FA06)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rather than keep a cached host-endian frame control, use byteswapped
helpers throughout and get the frame control directly from the 802.11
frame itself.

Very little testing has been done so far of this, but it does compile.

Applies on top of the 8-patch series adding byteswapped frame control
helpers.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/ieee80211.h  |  113 ++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |    4 +-
 net/mac80211/rx.c          |  226 +++++++++++++++++++++-----------------------
 net/mac80211/tx.c          |   51 +++++------
 net/mac80211/wep.c         |    6 +-
 net/mac80211/wpa.c         |   16 ++--
 6 files changed, 255 insertions(+), 161 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 9a964ff..be718e4 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -129,6 +129,33 @@ static inline int ieee80211_has_morefrags(__le16 fc)
 }
 
 /**
+ * ieee80211_has_retry - check if IEEE80211_FCTL_RETRY is set
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_has_retry(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_RETRY)) != 0;
+}
+
+/**
+ * ieee80211_has_pm - check if IEEE80211_FCTL_PM is set
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_has_pm(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_PM)) != 0;
+}
+
+/**
+ * ieee80211_has_order - check if IEEE80211_FCTL_ORDER is set
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_has_order(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_ORDER)) != 0;
+}
+
+/**
  * ieee80211_has_tods - check if IEEE80211_FCTL_TODS is set
  * @fc: frame control bytes in little-endian byteorder
  */
@@ -202,6 +229,19 @@ static inline int ieee80211_is_data_qos(__le16 fc)
 }
 
 /**
+ * ieee80211_data_present - check if data is present in the frame
+ * @fc: frame control bytes in little-endian byteorder
+ *
+ * Only mask with one bit in the STYPE to only match those STYPES that
+ * carry data.
+ */
+static inline int ieee80211_data_present(__le16 fc)
+{
+	return (fc & cpu_to_le16(0x40 | IEEE80211_FCTL_FTYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_DATA);
+}
+
+/**
  * ieee80211_is_nullfunc - check if FTYPE=IEEE80211_FTYPE_DATA and STYPE=IEEE80211_STYPE_NULLFUNC
  * @fc: frame control bytes in little-endian byteorder
  */
@@ -257,6 +297,61 @@ static inline int ieee80211_is_beacon(__le16 fc)
 }
 
 /**
+ * ieee80211_is_auth - check if FTYPE=IEEE80211_FTYPE_MGMT and STYPE=IEEE80211_STYPE_AUTH
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_auth(__le16 fc)
+{
+	return (fc &
+	       cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_AUTH);
+}
+
+/**
+ * ieee80211_is_assoc_req - check if FTYPE=IEEE80211_FTYPE_MGMT and STYPE=IEEE80211_STYPE_ASSOC_REQ
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_assoc_req(__le16 fc)
+{
+	return (fc &
+	       cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_ASSOC_REQ);
+}
+
+/**
+ * ieee80211_is_reassoc_req - check if FTYPE=IEEE80211_FTYPE_MGMT and STYPE=IEEE80211_STYPE_REASSOC_REQ
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_reassoc_req(__le16 fc)
+{
+	return (fc &
+	       cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_REASSOC_REQ);
+}
+
+/**
+ * ieee80211_is_probe_req - check if FTYPE=IEEE80211_FTYPE_MGMT and STYPE=IEEE80211_STYPE_PROBE_REQ
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_probe_req(__le16 fc)
+{
+	return (fc &
+	       cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_PROBE_REQ);
+}
+
+/**
+ * ieee80211_is_probe_resp - check if FTYPE=IEEE80211_FTYPE_MGMT and STYPE=IEEE80211_STYPE_PROBE_RESP
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_probe_resp(__le16 fc)
+{
+	return (fc &
+	       cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_PROBE_RESP);
+}
+
+/**
  * ieee80211_set_protected - set the IEEE80211_FCTL_PROTECTED bit
  * @hdr: the frame
  */
@@ -266,6 +361,24 @@ static inline void ieee80211_set_protected(struct ieee80211_hdr *hdr)
 }
 
 /**
+ * ieee80211_set_morefrags - set the IEEE80211_FCTL_MOREFRAGS bit
+ * @hdr: the frame
+ */
+static inline void ieee80211_set_morefrags(struct ieee80211_hdr *hdr)
+{
+	hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREFRAGS);
+}
+
+/**
+ * ieee80211_set_morefrags - clear the IEEE80211_FCTL_MOREFRAGS bit
+ * @hdr: the frame
+ */
+static inline void ieee80211_clear_morefrags(struct ieee80211_hdr *hdr)
+{
+	hdr->frame_control &= ~cpu_to_le16(IEEE80211_FCTL_MOREFRAGS);
+}
+
+/**
  * ieee80211_set_moredata - set the IEEE80211_FCTL_MOREDATA bit
  * @hdr: the frame
  */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 432011c..f938d3b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -171,7 +171,7 @@ struct ieee80211_tx_data {
 	struct sk_buff **extra_frag;
 	int num_extra_frag;
 
-	u16 fc, ethertype;
+	u16 ethertype;
 	unsigned int flags;
 };
 
@@ -199,7 +199,7 @@ struct ieee80211_rx_data {
 	struct ieee80211_rx_status *status;
 	struct ieee80211_rate *rate;
 
-	u16 fc, ethertype;
+	u16 ethertype;
 	unsigned int flags;
 	int sent_ps_buffered;
 	int queue;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index e80336f..78fd9e8 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -321,12 +321,12 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 
 static void ieee80211_parse_qos(struct ieee80211_rx_data *rx)
 {
-	u8 *data = rx->skb->data;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 	int tid;
 
 	/* does the frame have a qos control field? */
-	if (WLAN_FC_IS_QOS_DATA(rx->fc)) {
-		u8 *qc = data + ieee80211_get_hdrlen(rx->fc) - QOS_CONTROL_LEN;
+	if (ieee80211_is_data_qos(hdr->frame_control)) {
+		u8 *qc = ieee80211_get_qos_ctl(hdr);
 		/* frame has qos control */
 		tid = qc[0] & QOS_CONTROL_TID_MASK;
 		if (qc[0] & IEEE80211_QOS_CONTROL_A_MSDU_PRESENT)
@@ -334,7 +334,7 @@ static void ieee80211_parse_qos(struct ieee80211_rx_data *rx)
 		else
 			rx->flags &= ~IEEE80211_RX_AMSDU;
 	} else {
-		if (unlikely((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT)) {
+		if (unlikely(ieee80211_is_mgmt(hdr->frame_control))) {
 			/* Separate TID for management frames */
 			tid = NUM_RX_DATA_QUEUES - 1;
 		} else {
@@ -353,8 +353,9 @@ static void ieee80211_verify_ip_alignment(struct ieee80211_rx_data *rx)
 {
 #ifdef CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT
 	int hdrlen;
+	__le16 fc = ((struct ieee80211_hdr *)rx->skb->data)->frame_control;
 
-	if (!WLAN_FC_DATA_PRESENT(rx->fc))
+	if (!ieee80211_data_present(fc))
 		return;
 
 	/*
@@ -376,7 +377,7 @@ static void ieee80211_verify_ip_alignment(struct ieee80211_rx_data *rx)
 	 * header and the payload is not supported, the driver is required
 	 * to move the 802.11 header further back in that case.
 	 */
-	hdrlen = ieee80211_get_hdrlen(rx->fc);
+	hdrlen = ieee80211_hdrlen(fc);
 	if (rx->flags & IEEE80211_RX_AMSDU)
 		hdrlen += ETH_HLEN;
 	WARN_ON_ONCE(((unsigned long)(rx->skb->data + hdrlen)) & 3);
@@ -415,14 +416,13 @@ ieee80211_rx_h_passive_scan(struct ieee80211_rx_data *rx)
 static ieee80211_rx_result
 ieee80211_rx_mesh_check(struct ieee80211_rx_data *rx)
 {
-	int hdrlen = ieee80211_get_hdrlen(rx->fc);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
+	unsigned int hdrlen = ieee80211_hdrlen(hdr->frame_control);
 
 #define msh_h_get(h, l) ((struct ieee80211s_hdr *) ((u8 *)h + l))
 
-	if ((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA) {
-		if (!((rx->fc & IEEE80211_FCTL_FROMDS) &&
-		      (rx->fc & IEEE80211_FCTL_TODS)))
+	if (ieee80211_is_data(hdr->frame_control)) {
+		if (!ieee80211_has_a4(hdr->frame_control))
 			return RX_DROP_MONITOR;
 		if (memcmp(hdr->addr4, rx->dev->dev_addr, ETH_ALEN) == 0)
 			return RX_DROP_MONITOR;
@@ -435,25 +435,25 @@ ieee80211_rx_mesh_check(struct ieee80211_rx_data *rx)
 	if (!rx->sta || sta_plink_state(rx->sta) != PLINK_ESTAB) {
 		struct ieee80211_mgmt *mgmt;
 
-		if ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_MGMT)
+		if (!ieee80211_is_mgmt(hdr->frame_control))
 			return RX_DROP_MONITOR;
 
-		switch (rx->fc & IEEE80211_FCTL_STYPE) {
-		case IEEE80211_STYPE_ACTION:
+		switch (hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_STYPE)) {
+		case cpu_to_le16(IEEE80211_STYPE_ACTION):
 			mgmt = (struct ieee80211_mgmt *)hdr;
 			if (mgmt->u.action.category != PLINK_CATEGORY)
 				return RX_DROP_MONITOR;
 			/* fall through on else */
-		case IEEE80211_STYPE_PROBE_REQ:
-		case IEEE80211_STYPE_PROBE_RESP:
-		case IEEE80211_STYPE_BEACON:
+		case cpu_to_le16(IEEE80211_STYPE_PROBE_REQ):
+		case cpu_to_le16(IEEE80211_STYPE_PROBE_RESP):
+		case cpu_to_le16(IEEE80211_STYPE_BEACON):
 			return RX_CONTINUE;
 			break;
 		default:
 			return RX_DROP_MONITOR;
 		}
 
-	 } else if ((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA &&
+	 } else if (ieee80211_is_data(hdr->frame_control) &&
 		    is_multicast_ether_addr(hdr->addr1) &&
 		    mesh_rmc_check(hdr->addr4, msh_h_get(hdr, hdrlen), rx->dev))
 		return RX_DROP_MONITOR;
@@ -466,13 +466,12 @@ ieee80211_rx_mesh_check(struct ieee80211_rx_data *rx)
 static ieee80211_rx_result
 ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
 {
-	struct ieee80211_hdr *hdr;
-
-	hdr = (struct ieee80211_hdr *) rx->skb->data;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
+	__le16 fc = hdr->frame_control;
 
 	/* Drop duplicate 802.11 retransmissions (IEEE 802.11 Chap. 9.2.9) */
 	if (rx->sta && !is_multicast_ether_addr(hdr->addr1)) {
-		if (unlikely(rx->fc & IEEE80211_FCTL_RETRY &&
+		if (unlikely(ieee80211_has_retry(fc) &&
 			     rx->sta->last_seq_ctrl[rx->queue] ==
 			     hdr->seq_ctrl)) {
 			if (rx->flags & IEEE80211_RX_RA_MATCH) {
@@ -501,15 +500,12 @@ ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
 	if (ieee80211_vif_is_mesh(&rx->sdata->vif))
 		return ieee80211_rx_mesh_check(rx);
 
-	if (unlikely(((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA ||
-		      ((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL &&
-		       (rx->fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PSPOLL)) &&
+	if (unlikely((ieee80211_is_data(fc) || ieee80211_is_pspoll(fc)) &&
 		     rx->sdata->vif.type != IEEE80211_IF_TYPE_IBSS &&
 		     (!rx->sta || !test_sta_flags(rx->sta, WLAN_STA_ASSOC)))) {
-		if ((!(rx->fc & IEEE80211_FCTL_FROMDS) &&
-		     !(rx->fc & IEEE80211_FCTL_TODS) &&
-		     (rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA)
-		    || !(rx->flags & IEEE80211_RX_RA_MATCH)) {
+		if ((!ieee80211_has_fromds(fc) && !ieee80211_has_tods(fc) &&
+		    ieee80211_is_data(fc)) ||
+		    !(rx->flags & IEEE80211_RX_RA_MATCH)) {
 			/* Drop IBSS frames and frames for other hosts
 			 * silently. */
 			return RX_DROP_MONITOR;
@@ -557,7 +553,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 	 * possible.
 	 */
 
-	if (!(rx->fc & IEEE80211_FCTL_PROTECTED))
+	if (!ieee80211_has_protected(hdr->frame_control))
 		return RX_CONTINUE;
 
 	/*
@@ -586,7 +582,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 		    (rx->status->flag & RX_FLAG_IV_STRIPPED))
 			return RX_CONTINUE;
 
-		hdrlen = ieee80211_get_hdrlen(rx->fc);
+		hdrlen = ieee80211_hdrlen(hdr->frame_control);
 
 		if (rx->skb->len < 8 + hdrlen)
 			return RX_DROP_UNUSABLE; /* TODO: count this? */
@@ -623,7 +619,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 
 	/* Check for weak IVs if possible */
 	if (rx->sta && rx->key->conf.alg == ALG_WEP &&
-	    ((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA) &&
+	    ieee80211_is_data(hdr->frame_control) &&
 	    (!(rx->status->flag & RX_FLAG_IV_STRIPPED) ||
 	     !(rx->status->flag & RX_FLAG_DECRYPTED)) &&
 	    ieee80211_wep_is_weak_iv(rx->skb, rx->key))
@@ -749,21 +745,20 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 	sta->last_qual = rx->status->qual;
 	sta->last_noise = rx->status->noise;
 
-	if (!(rx->fc & IEEE80211_FCTL_MOREFRAGS)) {
+	if (!ieee80211_has_morefrags(hdr->frame_control)) {
 		/* Change STA power saving mode only in the end of a frame
 		 * exchange sequence */
 		if (test_sta_flags(sta, WLAN_STA_PS) &&
-		    !(rx->fc & IEEE80211_FCTL_PM))
+		    !ieee80211_has_pm(hdr->frame_control))
 			rx->sent_ps_buffered += ap_sta_ps_end(dev, sta);
 		else if (!test_sta_flags(sta, WLAN_STA_PS) &&
-			 (rx->fc & IEEE80211_FCTL_PM))
+			 ieee80211_has_pm(hdr->frame_control))
 			ap_sta_ps_start(dev, sta);
 	}
 
 	/* Drop data::nullfunc frames silently, since they are used only to
 	 * control station power saving mode. */
-	if ((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA &&
-	    (rx->fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_NULLFUNC) {
+	if (ieee80211_is_nullfunc(hdr->frame_control)) {
 		I802_DEBUG_INC(rx->local->rx_handlers_drop_nullfunc);
 		/* Update counter and free packet here to avoid counting this
 		 * as a dropped packed. */
@@ -817,18 +812,19 @@ ieee80211_reassemble_add(struct ieee80211_sub_if_data *sdata,
 	return entry;
 }
 
-static inline struct ieee80211_fragment_entry *
+static struct ieee80211_fragment_entry *
 ieee80211_reassemble_find(struct ieee80211_sub_if_data *sdata,
-			  u16 fc, unsigned int frag, unsigned int seq,
+			  unsigned int frag, unsigned int seq,
 			  int rx_queue, struct ieee80211_hdr *hdr)
 {
 	struct ieee80211_fragment_entry *entry;
 	int i, idx;
+	__le16 fc = hdr->frame_control;
 
 	idx = sdata->fragment_next;
 	for (i = 0; i < IEEE80211_FRAGMENT_MAX; i++) {
 		struct ieee80211_hdr *f_hdr;
-		u16 f_fc;
+		__le16 f_fc;
 
 		idx--;
 		if (idx < 0)
@@ -841,9 +837,10 @@ ieee80211_reassemble_find(struct ieee80211_sub_if_data *sdata,
 			continue;
 
 		f_hdr = (struct ieee80211_hdr *) entry->skb_list.next->data;
-		f_fc = le16_to_cpu(f_hdr->frame_control);
+		f_fc = f_hdr->frame_control;
 
-		if ((fc & IEEE80211_FCTL_FTYPE) != (f_fc & IEEE80211_FCTL_FTYPE) ||
+		if ((fc & cpu_to_le16(IEEE80211_FCTL_FTYPE)) != 
+		    (f_fc & cpu_to_le16(IEEE80211_FCTL_FTYPE)) ||
 		    compare_ether_addr(hdr->addr1, f_hdr->addr1) != 0 ||
 		    compare_ether_addr(hdr->addr2, f_hdr->addr2) != 0)
 			continue;
@@ -863,16 +860,18 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_hdr *hdr;
 	u16 sc;
+	__le16 fc;
 	unsigned int frag, seq;
 	struct ieee80211_fragment_entry *entry;
 	struct sk_buff *skb;
 	DECLARE_MAC_BUF(mac);
 
 	hdr = (struct ieee80211_hdr *) rx->skb->data;
+	fc = hdr->frame_control;
 	sc = le16_to_cpu(hdr->seq_ctrl);
 	frag = sc & IEEE80211_SCTL_FRAG;
 
-	if (likely((!(rx->fc & IEEE80211_FCTL_MOREFRAGS) && frag == 0) ||
+	if (likely((!ieee80211_has_morefrags(fc) && frag == 0) ||
 		   (rx->skb)->len < 24 ||
 		   is_multicast_ether_addr(hdr->addr1))) {
 		/* not fragmented */
@@ -887,7 +886,7 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 		entry = ieee80211_reassemble_add(rx->sdata, frag, seq,
 						 rx->queue, &(rx->skb));
 		if (rx->key && rx->key->conf.alg == ALG_CCMP &&
-		    (rx->fc & IEEE80211_FCTL_PROTECTED)) {
+		    ieee80211_has_protected(fc)) {
 			/* Store CCMP PN so that we can verify that the next
 			 * fragment has a sequential PN value. */
 			entry->ccmp = 1;
@@ -901,7 +900,7 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 	/* This is a fragment for a frame that should already be pending in
 	 * fragment cache. Add this fragment to the end of the pending entry.
 	 */
-	entry = ieee80211_reassemble_find(rx->sdata, rx->fc, frag, seq,
+	entry = ieee80211_reassemble_find(rx->sdata, frag, seq,
 					  rx->queue, hdr);
 	if (!entry) {
 		I802_DEBUG_INC(rx->local->rx_handlers_drop_defrag);
@@ -937,11 +936,11 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 		memcpy(entry->last_pn, pn, CCMP_PN_LEN);
 	}
 
-	skb_pull(rx->skb, ieee80211_get_hdrlen(rx->fc));
+	skb_pull(rx->skb, ieee80211_hdrlen(fc));
 	__skb_queue_tail(&entry->skb_list, rx->skb);
 	entry->last_frag = frag;
 	entry->extra_len += rx->skb->len;
-	if (rx->fc & IEEE80211_FCTL_MOREFRAGS) {
+	if (ieee80211_has_morefrags(fc)) {
 		rx->skb = NULL;
 		return RX_QUEUED;
 	}
@@ -979,12 +978,12 @@ ieee80211_rx_h_ps_poll(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(rx->dev);
 	struct sk_buff *skb;
+	struct ieee80211_hdr *hdr;
 	int no_pending_pkts;
 	DECLARE_MAC_BUF(mac);
 
-	if (likely(!rx->sta ||
-		   (rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_CTL ||
-		   (rx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_PSPOLL ||
+	hdr = (struct ieee80211_hdr *)rx->skb->data;
+	if (likely(!rx->sta || !ieee80211_is_pspoll(hdr->frame_control) ||
 		   !(rx->flags & IEEE80211_RX_RA_MATCH)))
 		return RX_CONTINUE;
 
@@ -1002,8 +1001,7 @@ ieee80211_rx_h_ps_poll(struct ieee80211_rx_data *rx)
 		skb_queue_empty(&rx->sta->ps_tx_buf);
 
 	if (skb) {
-		struct ieee80211_hdr *hdr =
-			(struct ieee80211_hdr *) skb->data;
+		hdr = (struct ieee80211_hdr *)skb->data;
 
 		/*
 		 * Tell TX path to send one frame even though the STA may
@@ -1020,9 +1018,9 @@ ieee80211_rx_h_ps_poll(struct ieee80211_rx_data *rx)
 		/* Use MoreData flag to indicate whether there are more
 		 * buffered frames for this STA */
 		if (no_pending_pkts)
-			hdr->frame_control &= cpu_to_le16(~IEEE80211_FCTL_MOREDATA);
+			ieee80211_clear_moredata(hdr);
 		else
-			hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREDATA);
+			ieee80211_set_moredata(hdr);
 
 		dev_queue_xmit(skb);
 
@@ -1052,19 +1050,17 @@ ieee80211_rx_h_ps_poll(struct ieee80211_rx_data *rx)
 static ieee80211_rx_result
 ieee80211_rx_h_remove_qos_control(struct ieee80211_rx_data *rx)
 {
-	u16 fc = rx->fc;
 	u8 *data = rx->skb->data;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) data;
 
-	if (!WLAN_FC_IS_QOS_DATA(fc))
+	if (!ieee80211_is_data_qos(hdr->frame_control))
 		return RX_CONTINUE;
 
 	/* remove the qos control field, update frame type and meta-data */
-	memmove(data + 2, data, ieee80211_get_hdrlen(fc) - 2);
-	hdr = (struct ieee80211_hdr *) skb_pull(rx->skb, 2);
+	memmove(data + 2, data, ieee80211_hdrlen(hdr->frame_control) - 2);
+	hdr = (struct ieee80211_hdr *)skb_pull(rx->skb, 2);
 	/* change frame type to non QOS */
-	rx->fc = fc &= ~IEEE80211_STYPE_QOS_DATA;
-	hdr->frame_control = cpu_to_le16(fc);
+	hdr->frame_control &= ~cpu_to_le16(IEEE80211_STYPE_QOS_DATA);
 
 	return RX_CONTINUE;
 }
@@ -1088,6 +1084,8 @@ ieee80211_802_1x_port_control(struct ieee80211_rx_data *rx)
 static int
 ieee80211_drop_unencrypted(struct ieee80211_rx_data *rx)
 {
+	__le16 fc;
+
 	/*
 	 * Pass through unencrypted frames if the hardware has
 	 * decrypted them already.
@@ -1095,10 +1093,10 @@ ieee80211_drop_unencrypted(struct ieee80211_rx_data *rx)
 	if (rx->status->flag & RX_FLAG_DECRYPTED)
 		return 0;
 
+	fc = ((struct ieee80211_hdr *)rx->skb->data)->frame_control;
 	/* Drop unencrypted frames if key is set. */
-	if (unlikely(!(rx->fc & IEEE80211_FCTL_PROTECTED) &&
-		     (rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA &&
-		     (rx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_NULLFUNC &&
+	if (unlikely(!ieee80211_has_protected(fc) && ieee80211_is_data(fc) &&
+		     !ieee80211_is_nullfunc(fc) &&
 		     (rx->key || rx->sdata->drop_unencrypted)))
 		return -EACCES;
 
@@ -1110,7 +1108,8 @@ ieee80211_data_to_8023(struct ieee80211_rx_data *rx)
 {
 	struct net_device *dev = rx->dev;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
-	u16 fc, hdrlen, ethertype;
+	__le16 fc;
+	u16 hdrlen, ethertype;
 	u8 *payload;
 	u8 dst[ETH_ALEN];
 	u8 src[ETH_ALEN] __aligned(2);
@@ -1121,12 +1120,12 @@ ieee80211_data_to_8023(struct ieee80211_rx_data *rx)
 	DECLARE_MAC_BUF(mac3);
 	DECLARE_MAC_BUF(mac4);
 
-	fc = rx->fc;
+	fc = hdr->frame_control;
 
-	if (unlikely(!WLAN_FC_DATA_PRESENT(fc)))
+	if (unlikely(!ieee80211_data_present(fc)))
 		return -1;
 
-	hdrlen = ieee80211_get_hdrlen(fc);
+	hdrlen = ieee80211_hdrlen(fc);
 
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 		int meshhdrlen = ieee80211_get_mesh_hdrlen(
@@ -1153,25 +1152,7 @@ ieee80211_data_to_8023(struct ieee80211_rx_data *rx)
 	 *   1     1   RA    TA    DA    SA
 	 */
 
-	switch (fc & (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) {
-	case IEEE80211_FCTL_TODS:
-		/* BSSID SA DA */
-		memcpy(dst, hdr->addr3, ETH_ALEN);
-		memcpy(src, hdr->addr2, ETH_ALEN);
-
-		if (unlikely(sdata->vif.type != IEEE80211_IF_TYPE_AP &&
-			     sdata->vif.type != IEEE80211_IF_TYPE_VLAN)) {
-			if (net_ratelimit())
-				printk(KERN_DEBUG "%s: dropped ToDS frame "
-				       "(BSSID=%s SA=%s DA=%s)\n",
-				       dev->name,
-				       print_mac(mac, hdr->addr1),
-				       print_mac(mac2, hdr->addr2),
-				       print_mac(mac3, hdr->addr3));
-			return -1;
-		}
-		break;
-	case (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS):
+	if (ieee80211_has_a4(fc)) {
 		/* RA TA DA SA */
 		memcpy(dst, hdr->addr3, ETH_ALEN);
 		memcpy(src, hdr->addr4, ETH_ALEN);
@@ -1188,8 +1169,23 @@ ieee80211_data_to_8023(struct ieee80211_rx_data *rx)
 				       print_mac(mac4, hdr->addr4));
 			return -1;
 		}
-		break;
-	case IEEE80211_FCTL_FROMDS:
+	} else if (ieee80211_has_tods(fc)) {
+		/* BSSID SA DA */
+		memcpy(dst, hdr->addr3, ETH_ALEN);
+		memcpy(src, hdr->addr2, ETH_ALEN);
+
+		if (unlikely(sdata->vif.type != IEEE80211_IF_TYPE_AP &&
+			     sdata->vif.type != IEEE80211_IF_TYPE_VLAN)) {
+			if (net_ratelimit())
+				printk(KERN_DEBUG "%s: dropped ToDS frame "
+				       "(BSSID=%s SA=%s DA=%s)\n",
+				       dev->name,
+				       print_mac(mac, hdr->addr1),
+				       print_mac(mac2, hdr->addr2),
+				       print_mac(mac3, hdr->addr3));
+			return -1;
+		}
+	} else if (ieee80211_has_fromds(fc)) {
 		/* DA BSSID SA */
 		memcpy(dst, hdr->addr1, ETH_ALEN);
 		memcpy(src, hdr->addr3, ETH_ALEN);
@@ -1198,8 +1194,7 @@ ieee80211_data_to_8023(struct ieee80211_rx_data *rx)
 		    (is_multicast_ether_addr(dst) &&
 		     !compare_ether_addr(src, dev->dev_addr)))
 			return -1;
-		break;
-	case 0:
+	} else {
 		/* DA SA BSSID */
 		memcpy(dst, hdr->addr1, ETH_ALEN);
 		memcpy(src, hdr->addr2, ETH_ALEN);
@@ -1215,7 +1210,6 @@ ieee80211_data_to_8023(struct ieee80211_rx_data *rx)
 			}
 			return -1;
 		}
-		break;
 	}
 
 	if (unlikely(skb->len - hdrlen < 8)) {
@@ -1227,7 +1221,7 @@ ieee80211_data_to_8023(struct ieee80211_rx_data *rx)
 	}
 
 	payload = skb->data + hdrlen;
-	ethertype = (payload[6] << 8) | payload[7];
+	ethertype = get_unaligned_be16(&payload[6]);
 
 	if (likely((compare_ether_addr(payload, rfc1042_header) == 0 &&
 		    ethertype != ETH_P_AARP && ethertype != ETH_P_IPX) ||
@@ -1372,7 +1366,8 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
 {
 	struct net_device *dev = rx->dev;
 	struct ieee80211_local *local = rx->local;
-	u16 fc, ethertype;
+	u16 ethertype;
+	__le16 fc;
 	u8 *payload;
 	struct sk_buff *skb = rx->skb, *frame = NULL;
 	const struct ethhdr *eth;
@@ -1381,11 +1376,11 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
 	u8 src[ETH_ALEN];
 	DECLARE_MAC_BUF(mac);
 
-	fc = rx->fc;
-	if (unlikely((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA))
+	fc = ((struct ieee80211_hdr *)skb->data)->frame_control;
+	if (unlikely(!ieee80211_is_data(fc)))
 		return RX_CONTINUE;
 
-	if (unlikely(!WLAN_FC_DATA_PRESENT(fc)))
+	if (unlikely(!ieee80211_data_present(fc)))
 		return RX_DROP_MONITOR;
 
 	if (!(rx->flags & IEEE80211_RX_AMSDU))
@@ -1488,14 +1483,14 @@ static ieee80211_rx_result
 ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 {
 	struct net_device *dev = rx->dev;
-	u16 fc;
+	__le16 fc;
 	int err;
 
-	fc = rx->fc;
-	if (unlikely((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA))
+	fc = ((struct ieee80211_hdr *)rx->skb->data)->frame_control;
+	if (unlikely(!ieee80211_is_data(fc)))
 		return RX_CONTINUE;
 
-	if (unlikely(!WLAN_FC_DATA_PRESENT(fc)))
+	if (unlikely(!ieee80211_data_present(fc)))
 		return RX_DROP_MONITOR;
 
 	err = ieee80211_data_to_8023(rx);
@@ -1526,10 +1521,7 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_data *rx)
 	u16 start_seq_num;
 	u16 tid;
 
-	if (likely((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_CTL))
-		return RX_CONTINUE;
-
-	if ((rx->fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_BACK_REQ) {
+	if (ieee80211_is_back_req(bar->frame_control)) {
 		if (!rx->sta)
 			return RX_CONTINUE;
 		tid = le16_to_cpu(bar->control) >> 12;
@@ -1584,6 +1576,7 @@ static void ieee80211_rx_michael_mic_report(struct net_device *dev,
 					    struct ieee80211_rx_data *rx)
 {
 	int keyidx, hdrlen;
+	__le16 fc;
 	DECLARE_MAC_BUF(mac);
 	DECLARE_MAC_BUF(mac2);
 
@@ -1611,7 +1604,9 @@ static void ieee80211_rx_michael_mic_report(struct net_device *dev,
 		goto ignore;
 	}
 
-	if (!(rx->fc & IEEE80211_FCTL_PROTECTED)) {
+	fc = ((struct ieee80211_hdr *)rx->skb->data)->frame_control;
+
+	if (!ieee80211_has_protected(fc)) {
 		if (net_ratelimit())
 			printk(KERN_DEBUG "%s: ignored spurious Michael MIC "
 			       "error for a frame with no PROTECTED flag (src "
@@ -1634,14 +1629,12 @@ static void ieee80211_rx_michael_mic_report(struct net_device *dev,
 		goto ignore;
 	}
 
-	if ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA &&
-	    ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_MGMT ||
-	     (rx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_AUTH)) {
+	if (!ieee80211_is_data(fc) && !ieee80211_is_auth(fc)) {
 		if (net_ratelimit())
 			printk(KERN_DEBUG "%s: ignored spurious Michael MIC "
 			       "error for a frame that cannot be encrypted "
 			       "(fc=0x%04x) (src %s)\n",
-			       dev->name, rx->fc, print_mac(mac, hdr->addr2));
+			       dev->name, le16_to_cpu(fc), print_mac(mac, hdr->addr2));
 		goto ignore;
 	}
 
@@ -1802,6 +1795,7 @@ static int prepare_for_handlers(struct ieee80211_sub_if_data *sdata,
 				struct ieee80211_hdr *hdr)
 {
 	int multicast = is_multicast_ether_addr(hdr->addr1);
+	__le16 fc = ((struct ieee80211_hdr *)rx->skb->data)->frame_control;
 
 	switch (sdata->vif.type) {
 	case IEEE80211_IF_TYPE_STA:
@@ -1822,8 +1816,7 @@ static int prepare_for_handlers(struct ieee80211_sub_if_data *sdata,
 	case IEEE80211_IF_TYPE_IBSS:
 		if (!bssid)
 			return 0;
-		if ((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT &&
-		    (rx->fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_BEACON)
+		if (ieee80211_is_beacon(fc))
 			return 1;
 		else if (!ieee80211_bssid_match(bssid, sdata->u.sta.bssid)) {
 			if (!(rx->flags & IEEE80211_RX_IN_SCAN))
@@ -1868,8 +1861,7 @@ static int prepare_for_handlers(struct ieee80211_sub_if_data *sdata,
 			return 0;
 		break;
 	case IEEE80211_IF_TYPE_WDS:
-		if (bssid ||
-		    (rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA)
+		if (bssid || !ieee80211_is_data(fc))
 			return 0;
 		if (compare_ether_addr(sdata->u.wds.remote_addr, hdr->addr2))
 			return 0;
@@ -1899,7 +1891,6 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_rx_data rx;
-	u16 type;
 	int prepares;
 	struct ieee80211_sub_if_data *prev = NULL;
 	struct sk_buff *skb_new;
@@ -1912,10 +1903,9 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 
 	rx.status = status;
 	rx.rate = rate;
-	rx.fc = le16_to_cpu(hdr->frame_control);
-	type = rx.fc & IEEE80211_FCTL_FTYPE;
 
-	if (type == IEEE80211_FTYPE_DATA || type == IEEE80211_FTYPE_MGMT)
+	if (ieee80211_is_data(hdr->frame_control) ||
+	    ieee80211_is_mgmt(hdr->frame_control))
 		local->dot11ReceivedFragmentCount++;
 
 	rx.sta = sta_info_get(local, hdr->addr2);
@@ -1976,12 +1966,10 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 				       prev->dev->name);
 			continue;
 		}
-		rx.fc = le16_to_cpu(hdr->frame_control);
 		ieee80211_invoke_rx_handlers(prev, &rx, skb_new);
 		prev = sdata;
 	}
 	if (prev) {
-		rx.fc = le16_to_cpu(hdr->frame_control);
 		ieee80211_invoke_rx_handlers(prev, &rx, skb);
 	} else
 		dev_kfree_skb(skb);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 1ad9e66..6dee30b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -94,6 +94,7 @@ static u16 ieee80211_duration(struct ieee80211_tx_data *tx, int group_addr,
 	struct ieee80211_rate *txrate;
 	struct ieee80211_local *local = tx->local;
 	struct ieee80211_supported_band *sband;
+	__le16 fc;
 
 	sband = local->hw.wiphy->bands[tx->channel->band];
 	txrate = &sband->bitrates[tx->rate_idx];
@@ -119,8 +120,8 @@ static u16 ieee80211_duration(struct ieee80211_tx_data *tx, int group_addr,
 	 *   at the highest possible rate belonging to the PHY rates in the
 	 *   BSSBasicRateSet
 	 */
-
-	if ((tx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL) {
+	fc = ((struct ieee80211_hdr *)tx->skb->data)->frame_control;
+	if (ieee80211_is_ctl(fc)) {
 		/* TODO: These control frames are not currently sent by
 		 * 80211.o, but should they be implemented, this function
 		 * needs to be updated to support duration field calculation.
@@ -225,9 +226,7 @@ static int inline is_ieee80211_device(struct net_device *dev,
 static ieee80211_tx_result
 ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
 {
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
-#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 	u32 sta_flags;
 
@@ -235,8 +234,7 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
 		return TX_CONTINUE;
 
 	if (unlikely(tx->local->sta_sw_scanning) &&
-	    ((tx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_MGMT ||
-	     (tx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_PROBE_REQ))
+	    !ieee80211_is_probe_req(hdr->frame_control))
 		return TX_DROP;
 
 	if (tx->sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT)
@@ -250,7 +248,7 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
 	if (likely(tx->flags & IEEE80211_TX_UNICAST)) {
 		if (unlikely(!(sta_flags & WLAN_STA_ASSOC) &&
 			     tx->sdata->vif.type != IEEE80211_IF_TYPE_IBSS &&
-			     (tx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA)) {
+			     ieee80211_is_data(hdr->frame_control))) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 			DECLARE_MAC_BUF(mac);
 			printk(KERN_DEBUG "%s: dropped data frame to not "
@@ -261,7 +259,7 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
 			return TX_DROP;
 		}
 	} else {
-		if (unlikely((tx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA &&
+		if (unlikely(ieee80211_is_data(hdr->frame_control) &&
 			     tx->local->num_sta == 0 &&
 			     tx->sdata->vif.type != IEEE80211_IF_TYPE_IBSS)) {
 			/*
@@ -281,7 +279,7 @@ ieee80211_tx_h_sequence(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
 
-	if (ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_control)) >= 24)
+	if (ieee80211_hdrlen(hdr->frame_control) >= 24)
 		ieee80211_include_sequence(tx->sdata, hdr);
 
 	return TX_CONTINUE;
@@ -337,6 +335,7 @@ static ieee80211_tx_result
 ieee80211_tx_h_multicast_ps_buf(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
+	__le16 fc;
 
 	/*
 	 * broadcast/multicast frame
@@ -346,8 +345,9 @@ ieee80211_tx_h_multicast_ps_buf(struct ieee80211_tx_data *tx)
 	 * This is done either by the hardware or us.
 	 */
 
+	fc = ((struct ieee80211_hdr *)tx->skb->data)->frame_control;
 	/* not AP/IBSS or ordered frame */
-	if (!tx->sdata->bss || (tx->fc & IEEE80211_FCTL_ORDER))
+	if (!tx->sdata->bss || ieee80211_has_order(fc))
 		return TX_CONTINUE;
 
 	/* no stations in PS mode */
@@ -384,11 +384,11 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 	struct sta_info *sta = tx->sta;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 	u32 staflags;
+	__le16 fc;
 	DECLARE_MAC_BUF(mac);
 
-	if (unlikely(!sta ||
-		     ((tx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT &&
-		      (tx->fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PROBE_RESP)))
+	fc = ((struct ieee80211_hdr *)tx->skb->data)->frame_control;
+	if (unlikely(!sta || ieee80211_is_probe_resp(fc)))
 		return TX_CONTINUE;
 
 	staflags = get_sta_flags(sta);
@@ -451,7 +451,7 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_key *key;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
-	u16 fc = tx->fc;
+	__le16 fc = ((struct ieee80211_hdr *)tx->skb->data)->frame_control;
 
 	if (unlikely(info->flags & IEEE80211_TX_CTL_DO_NOT_ENCRYPT))
 		tx->key = NULL;
@@ -468,22 +468,16 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
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
+			if (ieee80211_is_auth(fc))
 				break;
 		case ALG_TKIP:
 		case ALG_CCMP:
-			if (!WLAN_FC_DATA_PRESENT(fc))
+			if (!ieee80211_data_present(fc))
 				tx->key = NULL;
 			break;
 		}
@@ -543,7 +537,7 @@ static ieee80211_tx_result
 ieee80211_tx_h_misc(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) tx->skb->data;
-	u16 fc = le16_to_cpu(hdr->frame_control);
+	u16 fc = hdr->frame_control;
 	u16 dur;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 	struct ieee80211_supported_band *sband;
@@ -595,7 +589,7 @@ ieee80211_tx_h_misc(struct ieee80211_tx_data *tx)
 	/* Transmit data frames using short preambles if the driver supports
 	 * short preambles at the selected rate and short preambles are
 	 * available on the network at the current point in time. */
-	if (((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA) &&
+	if (ieee80211_is_data(fc) &&
 	    (sband->bitrates[tx->rate_idx].flags & IEEE80211_RATE_SHORT_PREAMBLE) &&
 	    tx->sdata->bss_conf.use_short_preamble &&
 	    (!tx->sta || test_sta_flags(tx->sta, WLAN_STA_SHORT_PREAMBLE))) {
@@ -671,7 +665,7 @@ ieee80211_tx_h_fragment(struct ieee80211_tx_data *tx)
 
 	first = tx->skb;
 
-	hdrlen = ieee80211_get_hdrlen(tx->fc);
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	payload_len = first->len - hdrlen;
 	per_fragm = frag_threshold - hdrlen - FCS_LEN;
 	num_fragm = DIV_ROUND_UP(payload_len, per_fragm);
@@ -680,7 +674,7 @@ ieee80211_tx_h_fragment(struct ieee80211_tx_data *tx)
 	if (!frags)
 		goto fail;
 
-	hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREFRAGS);
+	ieee80211_set_morefrags(hdr);
 	seq = le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_SEQ;
 	pos = first->data + hdrlen + per_fragm;
 	left = payload_len - per_fragm;
@@ -708,7 +702,7 @@ ieee80211_tx_h_fragment(struct ieee80211_tx_data *tx)
 		fhdr = (struct ieee80211_hdr *) skb_put(frag, hdrlen);
 		memcpy(fhdr, first->data, hdrlen);
 		if (i == num_fragm - 2)
-			fhdr->frame_control &= cpu_to_le16(~IEEE80211_FCTL_MOREFRAGS);
+			ieee80211_clear_morefrags(fhdr);
 		fhdr->seq_ctrl = cpu_to_le16(seq | ((i + 1) & IEEE80211_SCTL_FRAG));
 		copylen = left > per_fragm ? per_fragm : left;
 		memcpy(skb_put(frag, copylen), pos, copylen);
@@ -968,7 +962,6 @@ __ieee80211_tx_prepare(struct ieee80211_tx_data *tx,
 	hdr = (struct ieee80211_hdr *) skb->data;
 
 	tx->sta = sta_info_get(local, hdr->addr1);
-	tx->fc = le16_to_cpu(hdr->frame_control);
 
 	if (is_multicast_ether_addr(hdr->addr1)) {
 		tx->flags &= ~IEEE80211_TX_UNICAST;
@@ -992,7 +985,7 @@ __ieee80211_tx_prepare(struct ieee80211_tx_data *tx,
 	else if (test_and_clear_sta_flags(tx->sta, WLAN_STA_CLEAR_PS_FILT))
 		info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
 
-	hdrlen = ieee80211_get_hdrlen(tx->fc);
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	if (skb->len > hdrlen + sizeof(rfc1042_header) + 2) {
 		u8 *pos = &skb->data[hdrlen + sizeof(rfc1042_header)];
 		tx->ethertype = (pos[0] << 8) | pos[1];
diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
index e7b6344..fb57979 100644
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -304,9 +304,9 @@ u8 * ieee80211_wep_is_weak_iv(struct sk_buff *skb, struct ieee80211_key *key)
 ieee80211_rx_result
 ieee80211_crypto_wep_decrypt(struct ieee80211_rx_data *rx)
 {
-	if ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA &&
-	    ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_MGMT ||
-	     (rx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_AUTH))
+	__le16 fc = ((struct ieee80211_hdr *)rx->skb->data)->frame_control;
+
+	if (!ieee80211_is_data(fc) && !ieee80211_is_auth(fc))
 		return RX_CONTINUE;
 
 	if (!(rx->status->flag & RX_FLAG_DECRYPTED)) {
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 9834cec..2b2d572 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -51,16 +51,16 @@ ieee80211_tx_h_michael_mic_add(struct ieee80211_tx_data *tx)
 {
 	u8 *data, *sa, *da, *key, *mic, qos_tid;
 	size_t data_len;
-	u16 fc;
+	__le16 fc;
 	struct sk_buff *skb = tx->skb;
 	int authenticator;
 	int wpa_test = 0;
 	int tail;
 
-	fc = tx->fc;
+	fc = ((struct ieee80211_hdr *)tx->skb->data)->frame_control;
 
 	if (!tx->key || tx->key->conf.alg != ALG_TKIP || skb->len < 24 ||
-	    !WLAN_FC_DATA_PRESENT(fc))
+	    !ieee80211_is_data(fc))
 		return TX_CONTINUE;
 
 	if (ieee80211_get_hdr_info(skb, &sa, &da, &qos_tid, &data, &data_len))
@@ -102,13 +102,13 @@ ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
 {
 	u8 *data, *sa, *da, *key = NULL, qos_tid;
 	size_t data_len;
-	u16 fc;
+	__le16 fc;
 	u8 mic[MICHAEL_MIC_LEN];
 	struct sk_buff *skb = rx->skb;
 	int authenticator = 1, wpa_test = 0;
 	DECLARE_MAC_BUF(mac);
 
-	fc = rx->fc;
+	fc = ((struct ieee80211_hdr *)rx->skb->data)->frame_control;
 
 	/*
 	 * No way to verify the MIC if the hardware stripped it
@@ -117,7 +117,7 @@ ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
 		return RX_CONTINUE;
 
 	if (!rx->key || rx->key->conf.alg != ALG_TKIP ||
-	    !(rx->fc & IEEE80211_FCTL_PROTECTED) || !WLAN_FC_DATA_PRESENT(fc))
+	    !ieee80211_has_protected(fc) || !ieee80211_data_present(fc))
 		return RX_CONTINUE;
 
 	if (ieee80211_get_hdr_info(skb, &sa, &da, &qos_tid, &data, &data_len)
@@ -254,7 +254,7 @@ ieee80211_crypto_tkip_decrypt(struct ieee80211_rx_data *rx)
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 
-	if ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA)
+	if (!ieee80211_is_data(hdr->frame_control))
 		return RX_CONTINUE;
 
 	if (!rx->sta || skb->len - hdrlen < 12)
@@ -496,7 +496,7 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx)
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 
-	if ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA)
+	if (!ieee80211_is_data(hdr->frame_control))
 		return RX_CONTINUE;
 
 	data_len = skb->len - hdrlen - CCMP_HDR_LEN - CCMP_MIC_LEN;
-- 
1.5.6.rc2.261.ga8fbe



