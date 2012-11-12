Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45195 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab2KLSir (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 13:38:47 -0500
Received: by mail-pb0-f46.google.com with SMTP id rr4so4552697pbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2012 10:38:47 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH] mac80211: support RX_FLAG_MACTIME_END
Date: Mon, 12 Nov 2012 10:38:33 -0800
Message-Id: <1352745513-1265-1-git-send-email-thomas@cozybit.com> (sfid-20121112_193851_693663_8BFD24CE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow drivers to indicate their mactime is at RX completion and adjust
for this in mac80211. Based on similar code by Johannes Berg.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 include/net/mac80211.h     |    4 ++++
 net/mac80211/ibss.c        |   29 +++++--------------------
 net/mac80211/ieee80211_i.h |    9 ++++++++
 net/mac80211/mesh_sync.c   |   43 ++++++-------------------------------
 net/mac80211/rx.c          |   14 ++++++++++---
 net/mac80211/util.c        |   50 ++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 85 insertions(+), 64 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 00b7204..a2b9b52 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -704,6 +704,9 @@ ieee80211_tx_info_clear_status(struct ieee80211_tx_info *info)
  *	field) is valid and contains the time the first symbol of the MPDU
  *	was received. This is useful in monitor mode and for proper IBSS
  *	merging.
+ * @RX_FLAG_MACTIME_END: The timestamp passed in the RX status (@mactime
+ *	field) is valid and contains the time the last symbol of the MPDU
+ *	was received.
  * @RX_FLAG_SHORTPRE: Short preamble was used for this frame
  * @RX_FLAG_HT: HT MCS was used and rate_idx is MCS index
  * @RX_FLAG_40MHZ: HT40 (40 MHz) was used
@@ -748,6 +751,7 @@ enum mac80211_rx_flags {
 	RX_FLAG_AMPDU_IS_LAST		= BIT(18),
 	RX_FLAG_AMPDU_DELIM_CRC_ERROR	= BIT(19),
 	RX_FLAG_AMPDU_DELIM_CRC_KNOWN	= BIT(20),
+	RX_FLAG_MACTIME_END		= BIT(21),
 };
 
 /**
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index c7386b2..92500d8 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -543,30 +543,11 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 	if (ether_addr_equal(cbss->bssid, sdata->u.ibss.bssid))
 		goto put_bss;
 
-	if (rx_status->flag & RX_FLAG_MACTIME_MPDU) {
-		/*
-		 * For correct IBSS merging we need mactime; since mactime is
-		 * defined as the time the first data symbol of the frame hits
-		 * the PHY, and the timestamp of the beacon is defined as "the
-		 * time that the data symbol containing the first bit of the
-		 * timestamp is transmitted to the PHY plus the transmitting
-		 * STA's delays through its local PHY from the MAC-PHY
-		 * interface to its interface with the WM" (802.11 11.1.2)
-		 * - equals the time this bit arrives at the receiver - we have
-		 * to take into account the offset between the two.
-		 *
-		 * E.g. at 1 MBit that means mactime is 192 usec earlier
-		 * (=24 bytes * 8 usecs/byte) than the beacon timestamp.
-		 */
-		int rate;
-
-		if (rx_status->flag & RX_FLAG_HT)
-			rate = 65; /* TODO: HT rates */
-		else
-			rate = local->hw.wiphy->bands[band]->
-				bitrates[rx_status->rate_idx].bitrate;
-
-		rx_timestamp = rx_status->mactime + (24 * 8 * 10 / rate);
+	if (ieee80211_have_rx_timestamp(rx_status)) {
+		/* time when timestamp field was received */
+		rx_timestamp =
+			ieee80211_calculate_rx_timestamp(local, rx_status,
+							 len + 4, 24);
 	} else {
 		/*
 		 * second best option: get current TSF
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3026519..6162342 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1251,7 +1251,16 @@ static inline int ieee80211_bssid_match(const u8 *raddr, const u8 *addr)
 	       is_broadcast_ether_addr(raddr);
 }
 
+static inline bool
+ieee80211_have_rx_timestamp(struct ieee80211_rx_status *status)
+{
+	return status->flag & (RX_FLAG_MACTIME_MPDU | RX_FLAG_MACTIME_END);
+}
 
+u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
+				     struct ieee80211_rx_status *status,
+				     unsigned int mpdu_len,
+				     unsigned int mpdu_offset);
 int ieee80211_hw_config(struct ieee80211_local *local, u32 changed);
 void ieee80211_tx_set_protected(struct ieee80211_tx_data *tx);
 void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/mesh_sync.c b/net/mac80211/mesh_sync.c
index 407c870..99e792b 100644
--- a/net/mac80211/mesh_sync.c
+++ b/net/mac80211/mesh_sync.c
@@ -116,43 +116,12 @@ static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 		goto no_sync;
 	}
 
-	if (rx_status->flag & RX_FLAG_MACTIME_MPDU && rx_status->mactime) {
-		/*
-		 * The mactime is defined as the time the first data symbol
-		 * of the frame hits the PHY, and the timestamp of the beacon
-		 * is defined as "the time that the data symbol containing the
-		 * first bit of the timestamp is transmitted to the PHY plus
-		 * the transmitting STA's delays through its local PHY from the
-		 * MAC-PHY interface to its interface with the WM" (802.11
-		 * 11.1.2)
-		 *
-		 * T_r, in 13.13.2.2.2, is just defined as "the frame reception
-		 * time" but we unless we interpret that time to be the same
-		 * time of the beacon timestamp, the offset calculation will be
-		 * off.  Below we adjust t_r to be "the time at which the first
-		 * symbol of the timestamp element in the beacon is received".
-		 * This correction depends on the rate.
-		 *
-		 * Based on similar code in ibss.c
-		 */
-		int rate;
-
-		if (rx_status->flag & RX_FLAG_HT) {
-			/* TODO:
-			 * In principle there could be HT-beacons (Dual Beacon
-			 * HT Operation options), but for now ignore them and
-			 * just use the primary (i.e. non-HT) beacons for
-			 * synchronization.
-			 * */
-			goto no_sync;
-		} else
-			rate = local->hw.wiphy->bands[rx_status->band]->
-				bitrates[rx_status->rate_idx].bitrate;
-
-		/* 24 bytes of header * 8 bits/byte *
-		 * 10*(100 Kbps)/Mbps / rate (100 Kbps)*/
-		t_r = rx_status->mactime + (24 * 8 * 10 / rate);
-	}
+	if (ieee80211_have_rx_timestamp(rx_status))
+		/* time when timestamp field was received */
+		t_r = ieee80211_calculate_rx_timestamp(local, rx_status,
+						       24 + 12 +
+						       elems->total_len + 4,
+						       24);
 
 	/* Timing offset calculation (see 13.13.2.2.2) */
 	t_t = le64_to_cpu(mgmt->u.beacon.timestamp);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 8c1f152..9898fda 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -82,7 +82,7 @@ ieee80211_rx_radiotap_len(struct ieee80211_local *local,
 	/* always present fields */
 	len = sizeof(struct ieee80211_radiotap_header) + 9;
 
-	if (status->flag & RX_FLAG_MACTIME_MPDU)
+	if (ieee80211_have_rx_timestamp(status))
 		len += 8;
 	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
 		len += 1;
@@ -118,6 +118,11 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	struct ieee80211_radiotap_header *rthdr;
 	unsigned char *pos;
 	u16 rx_flags = 0;
+	int mpdulen;
+
+	mpdulen = skb->len;
+	if (!(has_fcs && (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS)))
+		mpdulen += 4;
 
 	rthdr = (struct ieee80211_radiotap_header *)skb_push(skb, rtap_len);
 	memset(rthdr, 0, rtap_len);
@@ -135,8 +140,11 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	/* the order of the following fields is important */
 
 	/* IEEE80211_RADIOTAP_TSFT */
-	if (status->flag & RX_FLAG_MACTIME_MPDU) {
-		put_unaligned_le64(status->mactime, pos);
+	if (ieee80211_have_rx_timestamp(status)) {
+		put_unaligned_le64(
+			ieee80211_calculate_rx_timestamp(local, status,
+							 mpdulen, 0),
+			pos);
 		rthdr->it_present |=
 			cpu_to_le32(1 << IEEE80211_RADIOTAP_TSFT);
 		pos += 8;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 9556391..9d7271e 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1990,3 +1990,53 @@ u8 ieee80211_mcs_to_chains(const struct ieee80211_mcs_info *mcs)
 		return 2;
 	return 1;
 }
+
+/**
+ * ieee80211_calculate_rx_timestamp - calculate timestamp in frame
+ * @status: RX status
+ * @mpdu_len: total MPDU length (including FCS)
+ * @mpdu_offset: offset into MPDU to calculate timestamp at
+ *
+ * This function calculates the RX timestamp at the given MPDU offset, taking
+ * into account what the RX timestamp was. An offset of 0 will just normalize
+ * the timestamp to TSF at beginning of MPDU reception.
+ */
+u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
+				     struct ieee80211_rx_status *status,
+				     unsigned int mpdu_len,
+				     unsigned int mpdu_offset)
+{
+	u64 ts = status->mactime;
+	struct rate_info ri;
+	u16 rate;
+
+	if (WARN_ON(!ieee80211_have_rx_timestamp(status)))
+		return 0;
+
+	memset(&ri, 0, sizeof(ri));
+
+	/* Fill cfg80211 rate info */
+	if (status->flag & RX_FLAG_HT) {
+		ri.mcs = status->rate_idx;
+		ri.flags |= RATE_INFO_FLAGS_MCS;
+		if (status->flag & RX_FLAG_40MHZ)
+			ri.flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
+		if (status->flag & RX_FLAG_SHORT_GI)
+			ri.flags |= RATE_INFO_FLAGS_SHORT_GI;
+	} else {
+		struct ieee80211_supported_band *sband;
+
+		sband = local->hw.wiphy->bands[status->band];
+		ri.legacy = sband->bitrates[status->rate_idx].bitrate;
+	}
+
+	rate = cfg80211_calculate_bitrate(&ri);
+
+	/* rewind from end of MPDU */
+	if (status->flag & RX_FLAG_MACTIME_END)
+		ts -= mpdu_len * 8 * 10 / rate;
+
+	ts += mpdu_offset * 8 * 10 / rate;
+
+	return ts;
+}
-- 
1.7.10.4

