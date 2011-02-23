Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46824 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655Ab1BWOIm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 09:08:42 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <johannes@sipsolutions.net>)
	id 1PsFOS-0006cp-UC
	for linux-wireless@vger.kernel.org; Wed, 23 Feb 2011 15:08:41 +0100
Subject: [RFC] mac80211: add RX_FLAG_MACTIME_PLCP
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Feb 2011 15:08:40 +0100
Message-ID: <1298470120.4122.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Allow drivers to specify that their mactime
timestamp is at the beginning of the PLCP
and adjust for that in mac80211.

NOTE: This is incomplete, see ieee80211_plcp_duration!!!

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h     |   10 +++++
 include/net/mac80211.h     |    7 ++++
 net/mac80211/ibss.c        |   27 +--------------
 net/mac80211/ieee80211_i.h |   11 ++++++
 net/mac80211/rx.c          |    8 ++--
 net/mac80211/util.c        |   76 +++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/core.h        |    2 -
 net/wireless/util.c        |    3 +
 8 files changed, 114 insertions(+), 30 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2011-02-23 15:03:52.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2011-02-23 15:05:19.000000000 +0100
@@ -603,10 +603,15 @@ ieee80211_tx_info_clear_status(struct ie
  *	field) is valid and contains the time the first symbol of the MPDU
  *	was received. This is useful in monitor mode and for proper IBSS
  *	merging.
+ * @RX_FLAG_MACTIME_PLCP: The timestamp passed in the RX status (@mactime
+ *	field) is valid and contains the time when the PLCP of the frame
+ *	started. mac80211 will automatically correct for the preamble time,
+ *	for which the rate and preamble flags etc. MUST be set correctly.
  * @RX_FLAG_SHORTPRE: Short preamble was used for this frame
  * @RX_FLAG_HT: HT MCS was used and rate_idx is MCS index
  * @RX_FLAG_40MHZ: HT40 (40 MHz) was used
  * @RX_FLAG_SHORT_GI: Short guard interval was used
+ * @RX_FLAG_HT_GF: This frame was received in a HT-greenfield transmission
  */
 enum mac80211_rx_flags {
 	RX_FLAG_MMIC_ERROR	= 1<<0,
@@ -620,6 +625,8 @@ enum mac80211_rx_flags {
 	RX_FLAG_HT		= 1<<9,
 	RX_FLAG_40MHZ		= 1<<10,
 	RX_FLAG_SHORT_GI	= 1<<11,
+	RX_FLAG_MACTIME_PLCP	= 1<<12,
+	RX_FLAG_HT_GF		= 1<<13,
 };
 
 /**
--- wireless-testing.orig/include/net/cfg80211.h	2011-02-23 15:03:52.000000000 +0100
+++ wireless-testing/include/net/cfg80211.h	2011-02-23 15:05:19.000000000 +0100
@@ -471,6 +471,16 @@ struct rate_info {
 };
 
 /**
+ * cfg80211_calculate_bitrate - calculate bitrate in 100kbit/s
+ * @rate: The rate information
+ *
+ * Calculates the net bitrate in units of 100kbit/s from the
+ * given rate/MCS information.
+ */
+u16 cfg80211_calculate_bitrate(struct rate_info *rate);
+
+
+/**
  * struct station_info - station information
  *
  * Station information filled by driver for get_station() and dump_station.
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2011-02-23 15:03:52.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2011-02-23 15:05:19.000000000 +0100
@@ -1347,6 +1347,17 @@ size_t ieee80211_ie_split(const u8 *ies,
 			  const u8 *ids, int n_ids, size_t offset);
 size_t ieee80211_ie_split_vendor(const u8 *ies, size_t ielen, size_t offset);
 
+u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
+				     struct ieee80211_rx_status *status,
+				     unsigned int mpdu_offset);
+
+static inline bool
+ieee80211_have_rx_timestamp(struct ieee80211_rx_status *status)
+{
+	return status->rx_flags & (RX_FLAG_MACTIME_MPDU | RX_FLAG_MACTIME_PLCP);
+}
+
+
 /* internal work items */
 void ieee80211_work_init(struct ieee80211_local *local);
 void ieee80211_add_work(struct ieee80211_work *wk);
--- wireless-testing.orig/net/mac80211/util.c	2011-02-23 15:03:52.000000000 +0100
+++ wireless-testing/net/mac80211/util.c	2011-02-23 15:08:06.000000000 +0100
@@ -1418,3 +1418,79 @@ size_t ieee80211_ie_split_vendor(const u
 
 	return pos;
 }
+
+static u64 ieee80211_plcp_duration(struct ieee80211_rx_status *status)
+{
+	if (status->rx_flags & RX_FLAG_HT_GF) {
+		/* HT-greenfield preamble */
+		/* TODO */
+		return 0;
+	} else if (status->rx_flags & RX_FLAG_HT) {
+		/* HT-mixed preamble */
+		/* TODO */
+		return 0;
+	} else switch (status->band) {
+	case IEEE80211_BAND_2GHZ:
+		if (status->rx_flags & RX_FLAG_SHORTPRE)
+			return 96;
+		return 192;
+	case IEEE80211_BAND_5GHZ:
+		/* This appears to be correct for iwlwifi, but is it really? */
+		return 16;
+	case IEEE80211_NUM_BANDS:
+		break;
+	}
+
+	WARN_ON_ONCE(1);
+	return 0;
+}
+
+/**
+ * ieee80211_calculate_rx_timestamp - calculate timestamp in frame
+ * @status: RX status
+ * @mpdu_offset: offset into MPDU to calculate timestamp at
+ *
+ * This function calculates the RX timestamp at the given MPDU
+ * offset, taking into account what the RX timestamp was.
+ */
+u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
+				     struct ieee80211_rx_status *status,
+				     unsigned int mpdu_offset)
+{
+	u64 ts = status->mactime;
+	struct rate_info ri;
+	u16 rate;
+
+	if (WARN_ON(!ieee80211_have_rx_timestamp(status)))
+		return 0;
+
+	/* Adjust for PLCP header */
+	if (status->rx_flags & RX_FLAG_MACTIME_PLCP)
+		ts += ieee80211_plcp_duration(status);
+
+	if (mpdu_offset == 0)
+		return ts;
+
+	memset(&ri, 0, sizeof(ri));
+
+	/* Fill cfg80211 rate info */
+	if (status->rx_flags & RX_FLAG_HT) {
+		ri.mcs = status->rate_idx;
+		ri.flags |= RATE_INFO_FLAGS_MCS;
+		if (status->rx_flags & RX_FLAG_40MHZ)
+			ri.flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
+		if (status->rx_flags & RX_FLAG_SHORT_GI)
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
+	ts += mpdu_offset * 8 * 10 / rate;
+
+	return ts;
+}
--- wireless-testing.orig/net/wireless/core.h	2011-02-23 15:03:52.000000000 +0100
+++ wireless-testing/net/wireless/core.h	2011-02-23 15:05:19.000000000 +0100
@@ -410,8 +410,6 @@ int cfg80211_set_freq(struct cfg80211_re
 		      struct wireless_dev *wdev, int freq,
 		      enum nl80211_channel_type channel_type);
 
-u16 cfg80211_calculate_bitrate(struct rate_info *rate);
-
 #ifdef CONFIG_CFG80211_DEVELOPER_WARNINGS
 #define CFG80211_DEV_WARN_ON(cond)	WARN_ON(cond)
 #else
--- wireless-testing.orig/net/wireless/util.c	2011-02-23 15:03:52.000000000 +0100
+++ wireless-testing/net/wireless/util.c	2011-02-23 15:05:19.000000000 +0100
@@ -872,7 +872,7 @@ u16 cfg80211_calculate_bitrate(struct ra
 		return rate->legacy;
 
 	/* the formula below does only work for MCS values smaller than 32 */
-	if (rate->mcs >= 32)
+	if (WARN_ON_ONCE(rate->mcs >= 32))
 		return 0;
 
 	modulation = rate->mcs & 7;
@@ -896,3 +896,4 @@ u16 cfg80211_calculate_bitrate(struct ra
 	/* do NOT round down here */
 	return (bitrate + 50000) / 100000;
 }
+EXPORT_SYMBOL(cfg80211_calculate_bitrate);
--- wireless-testing.orig/net/mac80211/ibss.c	2011-02-23 15:03:53.000000000 +0100
+++ wireless-testing/net/mac80211/ibss.c	2011-02-23 15:05:19.000000000 +0100
@@ -354,30 +354,9 @@ static void ieee80211_rx_bss_info(struct
 	if (memcmp(cbss->bssid, sdata->u.ibss.bssid, ETH_ALEN) == 0)
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
+		rx_timestamp =
+			ieee80211_calculate_rx_timestamp(local, rx_status, 24);
 	} else {
 		/*
 		 * second best option: get current TSF
--- wireless-testing.orig/net/mac80211/rx.c	2011-02-23 15:03:52.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2011-02-23 15:05:19.000000000 +0100
@@ -77,7 +77,7 @@ ieee80211_rx_radiotap_len(struct ieee802
 	/* always present fields */
 	len = sizeof(struct ieee80211_radiotap_header) + 9;
 
-	if (status->flag & RX_FLAG_MACTIME_MPDU)
+	if (ieee80211_have_rx_timestamp(status))
 		len += 8;
 	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
 		len += 1;
@@ -123,8 +123,10 @@ ieee80211_add_rx_radiotap_header(struct
 	/* the order of the following fields is important */
 
 	/* IEEE80211_RADIOTAP_TSFT */
-	if (status->flag & RX_FLAG_MACTIME_MPDU) {
-		put_unaligned_le64(status->mactime, pos);
+	if (ieee80211_have_rx_timestamp(status)) {
+		put_unaligned_le64(
+			ieee80211_calculate_rx_timestamp(local, status, 0),
+			pos);
 		rthdr->it_present |=
 			cpu_to_le32(1 << IEEE80211_RADIOTAP_TSFT);
 		pos += 8;


