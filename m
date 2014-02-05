Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:37627 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbaBEKus (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Feb 2014 05:50:48 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/3] mac80211: remove unused radiotap vendor fields in ieee80211_rx_status
Date: Wed,  5 Feb 2014 12:48:51 +0200
Message-Id: <1391597333-6398-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140205_115054_516917_A19C0540)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The purpose of this housekeeping is to make some room for
VHT flags. The radiotap vendor fields weren't in use.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 26 -----------------
 include/net/mac80211.h                | 12 --------
 net/mac80211/rx.c                     | 53 ++++-------------------------------
 3 files changed, 5 insertions(+), 86 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 5d88137..c939fd7 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1035,32 +1035,6 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 			ack = true;
 
 		rx_status.mactime = now + data2->tsf_offset;
-#if 0
-		/*
-		 * Don't enable this code by default as the OUI 00:00:00
-		 * is registered to Xerox so we shouldn't use it here, it
-		 * might find its way into pcap files.
-		 * Note that this code requires the headroom in the SKB
-		 * that was allocated earlier.
-		 */
-		rx_status.vendor_radiotap_oui[0] = 0x00;
-		rx_status.vendor_radiotap_oui[1] = 0x00;
-		rx_status.vendor_radiotap_oui[2] = 0x00;
-		rx_status.vendor_radiotap_subns = 127;
-		/*
-		 * Radiotap vendor namespaces can (and should) also be
-		 * split into fields by using the standard radiotap
-		 * presence bitmap mechanism. Use just BIT(0) here for
-		 * the presence bitmap.
-		 */
-		rx_status.vendor_radiotap_bitmap = BIT(0);
-		/* We have 8 bytes of (dummy) data */
-		rx_status.vendor_radiotap_len = 8;
-		/* For testing, also require it to be aligned */
-		rx_status.vendor_radiotap_align = 8;
-		/* push the data */
-		memcpy(skb_push(nskb, 8), "ABCDEFGH", 8);
-#endif
 
 		memcpy(IEEE80211_SKB_RXCB(nskb), &rx_status, sizeof(rx_status));
 		ieee80211_rx_irqsafe(data2->hw, nskb);
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5cc7d47..cef0f38 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -906,21 +906,12 @@ enum mac80211_rx_flags {
  * @ampdu_reference: A-MPDU reference number, must be a different value for
  *	each A-MPDU but the same for each subframe within one A-MPDU
  * @ampdu_delimiter_crc: A-MPDU delimiter CRC
- * @vendor_radiotap_bitmap: radiotap vendor namespace presence bitmap
- * @vendor_radiotap_len: radiotap vendor namespace length
- * @vendor_radiotap_align: radiotap vendor namespace alignment. Note
- *	that the actual data must be at the start of the SKB data
- *	already.
- * @vendor_radiotap_oui: radiotap vendor namespace OUI
- * @vendor_radiotap_subns: radiotap vendor sub namespace
  */
 struct ieee80211_rx_status {
 	u64 mactime;
 	u32 device_timestamp;
 	u32 ampdu_reference;
 	u32 flag;
-	u32 vendor_radiotap_bitmap;
-	u16 vendor_radiotap_len;
 	u16 freq;
 	u8 rate_idx;
 	u8 vht_nss;
@@ -931,9 +922,6 @@ struct ieee80211_rx_status {
 	u8 chains;
 	s8 chain_signal[IEEE80211_MAX_CHAINS];
 	u8 ampdu_delimiter_crc;
-	u8 vendor_radiotap_align;
-	u8 vendor_radiotap_oui[3];
-	u8 vendor_radiotap_subns;
 };
 
 /**
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 47faeaf..5dc0661 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -40,8 +40,6 @@
 static struct sk_buff *remove_monitor_info(struct ieee80211_local *local,
 					   struct sk_buff *skb)
 {
-	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
-
 	if (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS) {
 		if (likely(skb->len > FCS_LEN))
 			__pskb_trim(skb, skb->len - FCS_LEN);
@@ -53,9 +51,6 @@ static struct sk_buff *remove_monitor_info(struct ieee80211_local *local,
 		}
 	}
 
-	if (status->vendor_radiotap_len)
-		__pskb_pull(skb, status->vendor_radiotap_len);
-
 	return skb;
 }
 
@@ -64,14 +59,13 @@ static inline int should_drop_frame(struct sk_buff *skb, int present_fcs_len)
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_hdr *hdr;
 
-	hdr = (void *)(skb->data + status->vendor_radiotap_len);
+	hdr = (void *)(skb->data);
 
 	if (status->flag & (RX_FLAG_FAILED_FCS_CRC |
 			    RX_FLAG_FAILED_PLCP_CRC |
 			    RX_FLAG_AMPDU_IS_ZEROLEN))
 		return 1;
-	if (unlikely(skb->len < 16 + present_fcs_len +
-				status->vendor_radiotap_len))
+	if (unlikely(skb->len < 16 + present_fcs_len))
 		return 1;
 	if (ieee80211_is_ctl(hdr->frame_control) &&
 	    !ieee80211_is_pspoll(hdr->frame_control) &&
@@ -90,8 +84,6 @@ ieee80211_rx_radiotap_space(struct ieee80211_local *local,
 	len = sizeof(struct ieee80211_radiotap_header) + 8;
 
 	/* allocate extra bitmaps */
-	if (status->vendor_radiotap_len)
-		len += 4;
 	if (status->chains)
 		len += 4 * hweight8(status->chains);
 
@@ -127,18 +119,6 @@ ieee80211_rx_radiotap_space(struct ieee80211_local *local,
 		len += 2 * hweight8(status->chains);
 	}
 
-	if (status->vendor_radiotap_len) {
-		if (WARN_ON_ONCE(status->vendor_radiotap_align == 0))
-			status->vendor_radiotap_align = 1;
-		/* align standard part of vendor namespace */
-		len = ALIGN(len, 2);
-		/* allocate standard part of vendor namespace */
-		len += 6;
-		/* align vendor-defined part */
-		len = ALIGN(len, status->vendor_radiotap_align);
-		/* vendor-defined part is already in skb */
-	}
-
 	return len;
 }
 
@@ -172,7 +152,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	it_present = &rthdr->it_present;
 
 	/* radiotap header, set always present flags */
-	rthdr->it_len = cpu_to_le16(rtap_len + status->vendor_radiotap_len);
+	rthdr->it_len = cpu_to_le16(rtap_len);
 	it_present_val = BIT(IEEE80211_RADIOTAP_FLAGS) |
 			 BIT(IEEE80211_RADIOTAP_CHANNEL) |
 			 BIT(IEEE80211_RADIOTAP_RX_FLAGS);
@@ -190,14 +170,6 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 				 BIT(IEEE80211_RADIOTAP_DBM_ANTSIGNAL);
 	}
 
-	if (status->vendor_radiotap_len) {
-		it_present_val |= BIT(IEEE80211_RADIOTAP_VENDOR_NAMESPACE) |
-				  BIT(IEEE80211_RADIOTAP_EXT);
-		put_unaligned_le32(it_present_val, it_present);
-		it_present++;
-		it_present_val = status->vendor_radiotap_bitmap;
-	}
-
 	put_unaligned_le32(it_present_val, it_present);
 
 	pos = (void *)(it_present + 1);
@@ -383,21 +355,6 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 		*pos++ = status->chain_signal[chain];
 		*pos++ = chain;
 	}
-
-	if (status->vendor_radiotap_len) {
-		/* ensure 2 byte alignment for the vendor field as required */
-		if ((pos - (u8 *)rthdr) & 1)
-			*pos++ = 0;
-		*pos++ = status->vendor_radiotap_oui[0];
-		*pos++ = status->vendor_radiotap_oui[1];
-		*pos++ = status->vendor_radiotap_oui[2];
-		*pos++ = status->vendor_radiotap_subns;
-		put_unaligned_le16(status->vendor_radiotap_len, pos);
-		pos += 2;
-		/* align the actual payload as requested */
-		while ((pos - (u8 *)rthdr) & (status->vendor_radiotap_align - 1))
-			*pos++ = 0;
-	}
 }
 
 /*
@@ -428,8 +385,8 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 	if (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS)
 		present_fcs_len = FCS_LEN;
 
-	/* ensure hdr->frame_control and vendor radiotap data are in skb head */
-	if (!pskb_may_pull(origskb, 2 + status->vendor_radiotap_len)) {
+	/* ensure hdr->frame_control is in skb head */
+	if (!pskb_may_pull(origskb, 2)) {
 		dev_kfree_skb(origskb);
 		return NULL;
 	}
-- 
1.8.3.2

