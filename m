Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37009 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbbAOPRD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 10:17:03 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/3] mac80211: remove 80+80 MHz rate reporting
Date: Thu, 15 Jan 2015 16:16:55 +0100
Message-Id: <1421335017-7409-1-git-send-email-johannes@sipsolutions.net> (sfid-20150115_161709_339027_A4D093F1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

These rates are treated the same as 160 MHz in the spec,
so it makes no sense to distinguish them. As no driver
uses them yet, this is also not a problem, just remove
them.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h | 6 ++----
 net/mac80211/cfg.c     | 2 --
 net/mac80211/rx.c      | 5 -----
 net/mac80211/util.c    | 2 --
 4 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 123f2308958a..275ee56152ad 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -931,15 +931,13 @@ enum mac80211_rx_flags {
  * These flags are used with the @vht_flag member of
  *	&struct ieee80211_rx_status.
  * @RX_VHT_FLAG_80MHZ: 80 MHz was used
- * @RX_VHT_FLAG_80P80MHZ: 80+80 MHz was used
  * @RX_VHT_FLAG_160MHZ: 160 MHz was used
  * @RX_VHT_FLAG_BF: packet was beamformed
  */
 enum mac80211_rx_vht_flags {
 	RX_VHT_FLAG_80MHZ		= BIT(0),
-	RX_VHT_FLAG_80P80MHZ		= BIT(1),
-	RX_VHT_FLAG_160MHZ		= BIT(2),
-	RX_VHT_FLAG_BF			= BIT(3),
+	RX_VHT_FLAG_160MHZ		= BIT(1),
+	RX_VHT_FLAG_BF			= BIT(2),
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index fd6860d7f557..6d5076fbf87a 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -465,8 +465,6 @@ void sta_set_rate_info_rx(struct sta_info *sta, struct rate_info *rinfo)
 		rinfo->flags |= RATE_INFO_FLAGS_SHORT_GI;
 	if (sta->last_rx_rate_vht_flag & RX_VHT_FLAG_80MHZ)
 		rinfo->flags |= RATE_INFO_FLAGS_80_MHZ_WIDTH;
-	if (sta->last_rx_rate_vht_flag & RX_VHT_FLAG_80P80MHZ)
-		rinfo->flags |= RATE_INFO_FLAGS_80P80_MHZ_WIDTH;
 	if (sta->last_rx_rate_vht_flag & RX_VHT_FLAG_160MHZ)
 		rinfo->flags |= RATE_INFO_FLAGS_160_MHZ_WIDTH;
 }
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 3a1a3ba40bd8..3d79d498e7f6 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -361,9 +361,6 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 		u16 known = local->hw.radiotap_vht_details;
 
 		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_VHT);
-		/* known field - how to handle 80+80? */
-		if (status->vht_flag & RX_VHT_FLAG_80P80MHZ)
-			known &= ~IEEE80211_RADIOTAP_VHT_KNOWN_BANDWIDTH;
 		put_unaligned_le16(known, pos);
 		pos += 2;
 		/* flags */
@@ -378,8 +375,6 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 		/* bandwidth */
 		if (status->vht_flag & RX_VHT_FLAG_80MHZ)
 			*pos++ = 4;
-		else if (status->vht_flag & RX_VHT_FLAG_80P80MHZ)
-			*pos++ = 0; /* marked not known above */
 		else if (status->vht_flag & RX_VHT_FLAG_160MHZ)
 			*pos++ = 11;
 		else if (status->flag & RX_FLAG_40MHZ)
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 83ba6cd9cf8d..db7216124736 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2552,8 +2552,6 @@ u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
 			ri.flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
 		if (status->vht_flag & RX_VHT_FLAG_80MHZ)
 			ri.flags |= RATE_INFO_FLAGS_80_MHZ_WIDTH;
-		if (status->vht_flag & RX_VHT_FLAG_80P80MHZ)
-			ri.flags |= RATE_INFO_FLAGS_80P80_MHZ_WIDTH;
 		if (status->vht_flag & RX_VHT_FLAG_160MHZ)
 			ri.flags |= RATE_INFO_FLAGS_160_MHZ_WIDTH;
 		if (status->flag & RX_FLAG_SHORT_GI)
-- 
2.1.4

