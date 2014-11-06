Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48803 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbaKFV6I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 16:58:08 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC] mac80211: add back support for radiotap vendor namespace data
Date: Thu,  6 Nov 2014 22:57:53 +0100
Message-Id: <1415311073-17514-1-git-send-email-johannes@sipsolutions.net> (sfid-20141106_225813_144185_BAB19ECC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Radiotap vendor namespace data might still be useful, but we
reverted it because it used too much space in the RX status.
Put it back, but address the space problem by using a single
but only and putting everything else into the skb->data.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 39 +++++++++++++++
 include/net/mac80211.h                | 33 +++++++++++++
 net/mac80211/rx.c                     | 91 +++++++++++++++++++++++++++++------
 3 files changed, 149 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 209db62ee627..718af436547e 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -984,6 +984,42 @@ static void mac80211_hwsim_tx_iter(void *_data, u8 *addr,
 	data->receive = true;
 }
 
+static void mac80211_hwsim_add_vendor_rtap(struct sk_buff *skb)
+{
+#if 0
+	struct ieee80211_vendor_radiotap *rtap;
+
+	rtap = (void *)skb_push(skb, sizeof(*rtap) + 8 + 4);
+	/*
+	 * Don't enable this code by default as the OUI 00:00:00
+	 * is registered to Xerox so we shouldn't use it here, it
+	 * might find its way into pcap files.
+	 * Note that this code requires the headroom in the SKB
+	 * that was allocated earlier.
+	 */
+	rtap->oui[0] = 0x00;
+	rtap->oui[1] = 0x00;
+	rtap->oui[2] = 0x00;
+	rtap->subns = 127;
+
+	/*
+	 * Radiotap vendor namespaces can (and should) also be
+	 * split into fields by using the standard radiotap
+	 * presence bitmap mechanism. Use just BIT(0) here for
+	 * the presence bitmap.
+	 */
+	rtap->present = BIT(0);
+	/* We have 8 bytes of (dummy) data */
+	rtap->len = 8;
+	/* For testing, also require it to be aligned */
+	rtap->align = 8;
+	/* And also test that padding works, 4 bytes */
+	rtap->pad = 4;
+	/* push the data */
+	memcpy(rtap->data, "ABCDEFGH", 8);
+#endif
+}
+
 static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 					  struct sk_buff *skb,
 					  struct ieee80211_channel *chan)
@@ -1098,6 +1134,9 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 		rx_status.mactime = now + data2->tsf_offset;
 
 		memcpy(IEEE80211_SKB_RXCB(nskb), &rx_status, sizeof(rx_status));
+
+		mac80211_hwsim_add_vendor_rtap(nskb);
+
 		data2->rx_pkts++;
 		data2->rx_bytes += nskb->len;
 		ieee80211_rx_irqsafe(data2->hw, nskb);
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5f203a6a5e7e..731f9a694de6 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -911,6 +911,7 @@ enum mac80211_rx_flags {
 	RX_FLAG_10MHZ			= BIT(28),
 	RX_FLAG_5MHZ			= BIT(29),
 	RX_FLAG_AMSDU_MORE		= BIT(30),
+	RX_FLAG_RADIOTAP_VENDOR_DATA	= BIT(31),
 };
 
 #define RX_FLAG_STBC_SHIFT		26
@@ -982,6 +983,38 @@ struct ieee80211_rx_status {
 };
 
 /**
+ * struct ieee80211_vendor_radiotap - vendor radiotap data information
+ * @present: presence bitmap for this vendor namespace
+ *	(this could be extended in the future if any vendor needs more
+ *	 bits, the radiotap spec does allow for that)
+ * @align: radiotap vendor namespace alignment. This defines the needed
+ *	alignment for the @data field below, not for the vendor namespace
+ *	description itself (which has a fixed 2-byte alignment)
+ * @oui: radiotap vendor namespace OUI
+ * @subns: radiotap vendor sub namespace
+ * @len: radiotap vendor sub namespace skip length, if alignment is done
+ *	then that's added to this, i.e. this is only the length of the
+ *	@data field.
+ * @pad: number of bytes of padding after the @data, this exists so that
+ *	the skb data alignment can be preserved even if the data has odd
+ *	length
+ * @data: the actual vendor namespace data
+ *
+ * This struct, including the vendor data, goes into the skb->data before
+ * the 802.11 header. It's split up in mac80211 using the align/oui/subns
+ * data.
+ */
+struct ieee80211_vendor_radiotap {
+	u32 present;
+	u8 align;
+	u8 oui[3];
+	u8 subns;
+	u8 pad;
+	u16 len;
+	u8 data[];
+} __packed;
+
+/**
  * enum ieee80211_conf_flags - configuration flags
  *
  * Flags to define PHY configuration options
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index bc63aa0c5401..95c8813f3fa8 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -39,7 +39,8 @@
  * only useful for monitoring.
  */
 static struct sk_buff *remove_monitor_info(struct ieee80211_local *local,
-					   struct sk_buff *skb)
+					   struct sk_buff *skb,
+					   unsigned int rtap_vendor_space)
 {
 	if (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS) {
 		if (likely(skb->len > FCS_LEN))
@@ -52,20 +53,25 @@ static struct sk_buff *remove_monitor_info(struct ieee80211_local *local,
 		}
 	}
 
+	__pskb_pull(skb, rtap_vendor_space);
+
 	return skb;
 }
 
-static inline bool should_drop_frame(struct sk_buff *skb, int present_fcs_len)
+static inline bool should_drop_frame(struct sk_buff *skb, int present_fcs_len,
+				     unsigned int rtap_vendor_space)
 {
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
-	struct ieee80211_hdr *hdr = (void *)skb->data;
+	struct ieee80211_hdr *hdr;
+
+	hdr = (void *)(skb->data + rtap_vendor_space);
 
 	if (status->flag & (RX_FLAG_FAILED_FCS_CRC |
 			    RX_FLAG_FAILED_PLCP_CRC |
 			    RX_FLAG_AMPDU_IS_ZEROLEN))
 		return true;
 
-	if (unlikely(skb->len < 16 + present_fcs_len))
+	if (unlikely(skb->len < 16 + present_fcs_len + rtap_vendor_space))
 		return true;
 
 	if (ieee80211_is_ctl(hdr->frame_control) &&
@@ -78,7 +84,8 @@ static inline bool should_drop_frame(struct sk_buff *skb, int present_fcs_len)
 
 static int
 ieee80211_rx_radiotap_space(struct ieee80211_local *local,
-			    struct ieee80211_rx_status *status)
+			    struct ieee80211_rx_status *status,
+			    struct sk_buff *skb)
 {
 	int len;
 
@@ -121,6 +128,23 @@ ieee80211_rx_radiotap_space(struct ieee80211_local *local,
 		len += 2 * hweight8(status->chains);
 	}
 
+	/* note that because the vendor radiotap data is already
+	 * in the skb->data, we don't need extra space for it, in
+	 * fact in theory we could use two of its bytes for other
+	 * purposes; we simply use those for alignment of the six
+	 * byte vendor namespace header.
+	 * All that remains here is to take into account alignment
+	 * that the vendor data wants.
+	 */
+	if (status->flag & RX_FLAG_RADIOTAP_VENDOR_DATA) {
+		struct ieee80211_vendor_radiotap *rtap = (void *)skb->data;
+
+		if (WARN_ON(rtap->align == 0))
+			rtap->align = 1;
+		/* consider the worst case here */
+		len += rtap->align - 1;
+	}
+
 	return len;
 }
 
@@ -144,6 +168,12 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	u16 channel_flags = 0;
 	int mpdulen, chain;
 	unsigned long chains = status->chains;
+	struct ieee80211_vendor_radiotap rtap = {};
+
+	if (status->flag & RX_FLAG_RADIOTAP_VENDOR_DATA) {
+		rtap = *(struct ieee80211_vendor_radiotap *)skb->data;
+		skb_pull(skb, sizeof(rtap));
+	}
 
 	mpdulen = skb->len;
 	if (!(has_fcs && (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS)))
@@ -154,7 +184,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	it_present = &rthdr->it_present;
 
 	/* radiotap header, set always present flags */
-	rthdr->it_len = cpu_to_le16(rtap_len);
+	rthdr->it_len = cpu_to_le16(rtap_len + rtap.len + rtap.pad);
 	it_present_val = BIT(IEEE80211_RADIOTAP_FLAGS) |
 			 BIT(IEEE80211_RADIOTAP_CHANNEL) |
 			 BIT(IEEE80211_RADIOTAP_RX_FLAGS);
@@ -172,6 +202,14 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 				 BIT(IEEE80211_RADIOTAP_DBM_ANTSIGNAL);
 	}
 
+	if (status->flag & RX_FLAG_RADIOTAP_VENDOR_DATA) {
+		it_present_val |= BIT(IEEE80211_RADIOTAP_VENDOR_NAMESPACE) |
+				  BIT(IEEE80211_RADIOTAP_EXT);
+		put_unaligned_le32(it_present_val, it_present);
+		it_present++;
+		it_present_val = rtap.present;
+	}
+
 	put_unaligned_le32(it_present_val, it_present);
 
 	pos = (void *)(it_present + 1);
@@ -366,6 +404,22 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 		*pos++ = status->chain_signal[chain];
 		*pos++ = chain;
 	}
+
+	if (status->flag & RX_FLAG_RADIOTAP_VENDOR_DATA) {
+		/* ensure 2 byte alignment for the vendor field as required */
+		if ((pos - (u8 *)rthdr) & 1)
+			*pos++ = 0;
+		*pos++ = rtap.oui[0];
+		*pos++ = rtap.oui[1];
+		*pos++ = rtap.oui[2];
+		*pos++ = rtap.subns;
+		put_unaligned_le16(rtap.len, pos);
+		pos += 2;
+		/* align the actual payload as requested */
+		while ((pos - (u8 *)rthdr) & (rtap.align - 1))
+			*pos++ = 0;
+		/* data (and possible padding) already follows */
+	}
 }
 
 /*
@@ -383,6 +437,13 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 	struct sk_buff *skb, *skb2;
 	struct net_device *prev_dev = NULL;
 	int present_fcs_len = 0;
+	unsigned int rtap_vendor_space = 0;
+
+	if (unlikely(status->flag & RX_FLAG_RADIOTAP_VENDOR_DATA)) {
+		struct ieee80211_vendor_radiotap *rtap = (void *)origskb->data;
+
+		rtap_vendor_space = sizeof(*rtap) + rtap->len + rtap->pad;
+	}
 
 	/*
 	 * First, we may need to make a copy of the skb because
@@ -396,25 +457,26 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 	if (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS)
 		present_fcs_len = FCS_LEN;
 
-	/* ensure hdr->frame_control is in skb head */
-	if (!pskb_may_pull(origskb, 2)) {
+	/* ensure hdr->frame_control and vendor radiotap data are in skb head */
+	if (!pskb_may_pull(origskb, 2 + rtap_vendor_space)) {
 		dev_kfree_skb(origskb);
 		return NULL;
 	}
 
 	if (!local->monitors) {
-		if (should_drop_frame(origskb, present_fcs_len)) {
+		if (should_drop_frame(origskb, present_fcs_len,
+				      rtap_vendor_space)) {
 			dev_kfree_skb(origskb);
 			return NULL;
 		}
 
-		return remove_monitor_info(local, origskb);
+		return remove_monitor_info(local, origskb, rtap_vendor_space);
 	}
 
 	/* room for the radiotap header based on driver features */
-	needed_headroom = ieee80211_rx_radiotap_space(local, status);
+	needed_headroom = ieee80211_rx_radiotap_space(local, status, origskb);
 
-	if (should_drop_frame(origskb, present_fcs_len)) {
+	if (should_drop_frame(origskb, present_fcs_len, rtap_vendor_space)) {
 		/* only need to expand headroom if necessary */
 		skb = origskb;
 		origskb = NULL;
@@ -438,7 +500,8 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 		 */
 		skb = skb_copy_expand(origskb, needed_headroom, 0, GFP_ATOMIC);
 
-		origskb = remove_monitor_info(local, origskb);
+		origskb = remove_monitor_info(local, origskb,
+					      rtap_vendor_space);
 
 		if (!skb)
 			return origskb;
@@ -2893,7 +2956,7 @@ static void ieee80211_rx_cooked_monitor(struct ieee80211_rx_data *rx,
 		goto out_free_skb;
 
 	/* room for the radiotap header based on driver features */
-	needed_headroom = ieee80211_rx_radiotap_space(local, status);
+	needed_headroom = ieee80211_rx_radiotap_space(local, status, skb);
 
 	if (skb_headroom(skb) < needed_headroom &&
 	    pskb_expand_head(skb, needed_headroom, 0, GFP_ATOMIC))
-- 
2.1.1

