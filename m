Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59818 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751318AbdBOOCP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 09:02:15 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/5] mac80211: encode rate type (legacy, HT, VHT) with fewer bits
Date: Wed, 15 Feb 2017 15:02:09 +0100
Message-Id: <20170215140210.19393-4-johannes@sipsolutions.net> (sfid-20170215_150225_803604_45606494)
In-Reply-To: <20170215140210.19393-1-johannes@sipsolutions.net>
References: <20170215140210.19393-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We don't really need three different bits for each, since the
types are mutually exclusive. Use just two bits for it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c | 11 ++++++++---
 net/mac80211/sta_info.h | 13 +++++++------
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 4774e663a411..cd162be6024e 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1960,14 +1960,17 @@ static void sta_stats_decode_rate(struct ieee80211_local *local, u16 rate,
 	rinfo->bw = (rate & STA_STATS_RATE_BW_MASK) >>
 		STA_STATS_RATE_BW_SHIFT;
 
-	if (rate & STA_STATS_RATE_VHT) {
+	switch (rate & STA_STATS_RATE_TYPE_MASK) {
+	case STA_STATS_RATE_TYPE_VHT:
 		rinfo->flags = RATE_INFO_FLAGS_VHT_MCS;
 		rinfo->mcs = rate & 0xf;
 		rinfo->nss = (rate & 0xf0) >> 4;
-	} else if (rate & STA_STATS_RATE_HT) {
+		break;
+	case STA_STATS_RATE_TYPE_HT:
 		rinfo->flags = RATE_INFO_FLAGS_MCS;
 		rinfo->mcs = rate & 0xff;
-	} else if (rate & STA_STATS_RATE_LEGACY) {
+		break;
+	case STA_STATS_RATE_TYPE_LEGACY: {
 		struct ieee80211_supported_band *sband;
 		u16 brate;
 		unsigned int shift;
@@ -1982,6 +1985,8 @@ static void sta_stats_decode_rate(struct ieee80211_local *local, u16 rate,
 		else
 			shift = 0;
 		rinfo->legacy = DIV_ROUND_UP(brate, 1 << shift);
+		break;
+		}
 	}
 
 	if (rate & STA_STATS_RATE_SGI)
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 71fa41a1368a..1a9968aa6990 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -726,9 +726,10 @@ void ieee80211_sta_ps_deliver_uapsd(struct sta_info *sta);
 unsigned long ieee80211_sta_last_active(struct sta_info *sta);
 
 #define STA_STATS_RATE_INVALID		0
-#define STA_STATS_RATE_VHT		0x8000
-#define STA_STATS_RATE_HT		0x4000
-#define STA_STATS_RATE_LEGACY		0x2000
+#define STA_STATS_RATE_TYPE_MASK	0xC000
+#define STA_STATS_RATE_TYPE_LEGACY	0x4000
+#define STA_STATS_RATE_TYPE_HT		0x8000
+#define STA_STATS_RATE_TYPE_VHT		0xC000
 #define STA_STATS_RATE_SGI		0x1000
 #define STA_STATS_RATE_BW_SHIFT		9
 #define STA_STATS_RATE_BW_MASK		(0x7 << STA_STATS_RATE_BW_SHIFT)
@@ -754,11 +755,11 @@ static inline u16 sta_stats_encode_rate(struct ieee80211_rx_status *s)
 		r |= STA_STATS_RATE_SGI;
 
 	if (s->flag & RX_FLAG_VHT)
-		r |= STA_STATS_RATE_VHT | (s->vht_nss << 4);
+		r |= STA_STATS_RATE_TYPE_VHT | (s->vht_nss << 4);
 	else if (s->flag & RX_FLAG_HT)
-		r |= STA_STATS_RATE_HT;
+		r |= STA_STATS_RATE_TYPE_HT;
 	else
-		r |= STA_STATS_RATE_LEGACY | (s->band << 4);
+		r |= STA_STATS_RATE_TYPE_LEGACY | (s->band << 4);
 
 	return r;
 }
-- 
2.9.3
