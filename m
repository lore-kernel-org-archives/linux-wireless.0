Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49292 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755394AbdD1Ige (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Apr 2017 04:36:34 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/4] mac80211: use bitfield macros for encoded rate
Date: Fri, 28 Apr 2017 10:36:26 +0200
Message-Id: <20170428083626.3463-5-johannes@sipsolutions.net> (sfid-20170428_103754_013368_91E94198)
In-Reply-To: <20170428083626.3463-1-johannes@sipsolutions.net>
References: <20170428083626.3463-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of hand-coding the bit manipulations, use the bitfield
macros to generate the code for the encoded bitrate.

type=cleanup

Change-Id: I93b66fbd2d866f4e5c118dc5fb4845683edd4dcc
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c | 26 +++++++++++++-----------
 net/mac80211/sta_info.h | 54 ++++++++++++++++++++++++++++++++-----------------
 2 files changed, 50 insertions(+), 30 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 81ec1f72518d..464566c662c5 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2,7 +2,7 @@
  * Copyright 2002-2005, Instant802 Networks, Inc.
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
- * Copyright (C) 2015 - 2016 Intel Deutschland GmbH
+ * Copyright (C) 2015 - 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -1957,27 +1957,32 @@ sta_get_last_rx_stats(struct sta_info *sta)
 static void sta_stats_decode_rate(struct ieee80211_local *local, u16 rate,
 				  struct rate_info *rinfo)
 {
-	rinfo->bw = (rate & STA_STATS_RATE_BW_MASK) >>
-		STA_STATS_RATE_BW_SHIFT;
+	rinfo->bw = STA_STATS_GET(BW, rate);
 
-	switch (rate & STA_STATS_RATE_TYPE_MASK) {
+	switch (STA_STATS_GET(TYPE, rate)) {
 	case STA_STATS_RATE_TYPE_VHT:
 		rinfo->flags = RATE_INFO_FLAGS_VHT_MCS;
-		rinfo->mcs = rate & 0xf;
-		rinfo->nss = (rate & 0xf0) >> 4;
+		rinfo->mcs = STA_STATS_GET(VHT_MCS, rate);
+		rinfo->nss = STA_STATS_GET(VHT_NSS, rate);
+		if (STA_STATS_GET(SGI, rate))
+			rinfo->flags |= RATE_INFO_FLAGS_SHORT_GI;
 		break;
 	case STA_STATS_RATE_TYPE_HT:
 		rinfo->flags = RATE_INFO_FLAGS_MCS;
-		rinfo->mcs = rate & 0xff;
+		rinfo->mcs = STA_STATS_GET(HT_MCS, rate);
+		if (STA_STATS_GET(SGI, rate))
+			rinfo->flags |= RATE_INFO_FLAGS_SHORT_GI;
 		break;
 	case STA_STATS_RATE_TYPE_LEGACY: {
 		struct ieee80211_supported_band *sband;
 		u16 brate;
 		unsigned int shift;
+		int band = STA_STATS_GET(LEGACY_BAND, rate);
+		int rate_idx = STA_STATS_GET(LEGACY_IDX, rate);
 
 		rinfo->flags = 0;
-		sband = local->hw.wiphy->bands[(rate >> 4) & 0xf];
-		brate = sband->bitrates[rate & 0xf].bitrate;
+		sband = local->hw.wiphy->bands[band];
+		brate = sband->bitrates[rate_idx].bitrate;
 		if (rinfo->bw == RATE_INFO_BW_5)
 			shift = 2;
 		else if (rinfo->bw == RATE_INFO_BW_10)
@@ -1988,9 +1993,6 @@ static void sta_stats_decode_rate(struct ieee80211_local *local, u16 rate,
 		break;
 		}
 	}
-
-	if (rate & STA_STATS_RATE_SGI)
-		rinfo->flags |= RATE_INFO_FLAGS_SHORT_GI;
 }
 
 static int sta_set_rate_info_rx(struct sta_info *sta, struct rate_info *rinfo)
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 150f478c7c63..5609cacb20d5 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -16,6 +16,7 @@
 #include <linux/if_ether.h>
 #include <linux/workqueue.h>
 #include <linux/average.h>
+#include <linux/bitfield.h>
 #include <linux/etherdevice.h>
 #include <linux/rhashtable.h>
 #include <linux/u64_stats_sync.h>
@@ -727,37 +728,54 @@ void ieee80211_sta_ps_deliver_uapsd(struct sta_info *sta);
 
 unsigned long ieee80211_sta_last_active(struct sta_info *sta);
 
+enum sta_stats_type {
+	STA_STATS_RATE_TYPE_INVALID = 0,
+	STA_STATS_RATE_TYPE_LEGACY,
+	STA_STATS_RATE_TYPE_HT,
+	STA_STATS_RATE_TYPE_VHT,
+};
+
+#define STA_STATS_FIELD_HT_MCS		GENMASK( 7,  0)
+#define STA_STATS_FIELD_LEGACY_IDX	GENMASK( 3,  0)
+#define STA_STATS_FIELD_LEGACY_BAND	GENMASK( 7,  4)
+#define STA_STATS_FIELD_VHT_MCS		GENMASK( 3,  0)
+#define STA_STATS_FIELD_VHT_NSS		GENMASK( 7,  4)
+#define STA_STATS_FIELD_BW		GENMASK(11,  8)
+#define STA_STATS_FIELD_SGI		GENMASK(12, 12)
+#define STA_STATS_FIELD_TYPE		GENMASK(15, 13)
+
+#define STA_STATS_FIELD(_n, _v)		FIELD_PREP(STA_STATS_FIELD_ ## _n, _v)
+#define STA_STATS_GET(_n, _v)		FIELD_GET(STA_STATS_FIELD_ ## _n, _v)
+
 #define STA_STATS_RATE_INVALID		0
-#define STA_STATS_RATE_TYPE_MASK	0xC000
-#define STA_STATS_RATE_TYPE_LEGACY	0x4000
-#define STA_STATS_RATE_TYPE_HT		0x8000
-#define STA_STATS_RATE_TYPE_VHT		0xC000
-#define STA_STATS_RATE_SGI		0x1000
-#define STA_STATS_RATE_BW_SHIFT		9
-#define STA_STATS_RATE_BW_MASK		(0x7 << STA_STATS_RATE_BW_SHIFT)
-
-static inline u16 sta_stats_encode_rate(struct ieee80211_rx_status *s)
+
+static inline u32 sta_stats_encode_rate(struct ieee80211_rx_status *s)
 {
-	u16 r = s->rate_idx;
+	u16 r;
 
-	r |= s->bw << STA_STATS_RATE_BW_SHIFT;
+	r = STA_STATS_FIELD(BW, s->bw);
 
 	if (s->enc_flags & RX_ENC_FLAG_SHORT_GI)
-		r |= STA_STATS_RATE_SGI;
+		r |= STA_STATS_FIELD(SGI, 1);
 
 	switch (s->encoding) {
 	case RX_ENC_VHT:
-		r |= STA_STATS_RATE_TYPE_VHT | (s->nss << 4);
+		r |= STA_STATS_FIELD(TYPE, STA_STATS_RATE_TYPE_VHT);
+		r |= STA_STATS_FIELD(VHT_NSS, s->nss);
+		r |= STA_STATS_FIELD(VHT_MCS, s->rate_idx);
 		break;
 	case RX_ENC_HT:
-		r |= STA_STATS_RATE_TYPE_HT;
+		r |= STA_STATS_FIELD(TYPE, STA_STATS_RATE_TYPE_HT);
+		r |= STA_STATS_FIELD(HT_MCS, s->rate_idx);
 		break;
-	default:
-		WARN_ON(1);
-		/* fall through */
 	case RX_ENC_LEGACY:
-		r |= STA_STATS_RATE_TYPE_LEGACY | (s->band << 4);
+		r |= STA_STATS_FIELD(TYPE, STA_STATS_RATE_TYPE_LEGACY);
+		r |= STA_STATS_FIELD(LEGACY_BAND, s->band);
+		r |= STA_STATS_FIELD(LEGACY_IDX, s->rate_idx);
 		break;
+	default:
+		WARN_ON(1);
+		return STA_STATS_RATE_INVALID;
 	}
 
 	return r;
-- 
2.11.0
