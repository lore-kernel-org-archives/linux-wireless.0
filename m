Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39101 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756009AbcAYNqk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2016 08:46:40 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/3] mac80211: add RX_FLAG_MACTIME_PLCP_START
Date: Mon, 25 Jan 2016 15:46:34 +0200
Message-Id: <1453729596-9847-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160125_144644_131591_82F506DA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The timestamp given by iwlwifi is at the beginning of the
frame over the air, at (or during) the SYNC field. Allow
such timestamps to be given to mac80211, at least (for now)
for frames with non-HT/VHT preambles.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     |  3 +++
 net/mac80211/ieee80211_i.h |  8 +++++++-
 net/mac80211/util.c        | 14 +++++++++++++-
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 566df20..31337f8 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1010,6 +1010,8 @@ ieee80211_tx_info_clear_status(struct ieee80211_tx_info *info)
  * @RX_FLAG_MACTIME_END: The timestamp passed in the RX status (@mactime
  *	field) is valid and contains the time the last symbol of the MPDU
  *	(including FCS) was received.
+ * @RX_FLAG_MACTIME_PLCP_START: The timestamp passed in the RX status (@mactime
+ *	field) is valid and contains the time the SYNC preamble was received.
  * @RX_FLAG_SHORTPRE: Short preamble was used for this frame
  * @RX_FLAG_HT: HT MCS was used and rate_idx is MCS index
  * @RX_FLAG_VHT: VHT MCS was used and rate_index is MCS index
@@ -1058,6 +1060,7 @@ ieee80211_tx_info_clear_status(struct ieee80211_tx_info *info)
 enum mac80211_rx_flags {
 	RX_FLAG_MMIC_ERROR		= BIT(0),
 	RX_FLAG_DECRYPTED		= BIT(1),
+	RX_FLAG_MACTIME_PLCP_START	= BIT(2),
 	RX_FLAG_MMIC_STRIPPED		= BIT(3),
 	RX_FLAG_IV_STRIPPED		= BIT(4),
 	RX_FLAG_FAILED_FCS_CRC		= BIT(5),
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9934447..a29f61d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1466,7 +1466,13 @@ ieee80211_have_rx_timestamp(struct ieee80211_rx_status *status)
 {
 	WARN_ON_ONCE(status->flag & RX_FLAG_MACTIME_START &&
 		     status->flag & RX_FLAG_MACTIME_END);
-	return status->flag & (RX_FLAG_MACTIME_START | RX_FLAG_MACTIME_END);
+	if (status->flag & (RX_FLAG_MACTIME_START | RX_FLAG_MACTIME_END))
+		return true;
+	/* can't handle HT/VHT preamble yet */
+	if (status->flag & RX_FLAG_MACTIME_PLCP_START &&
+	    !(status->flag & (RX_FLAG_HT | RX_FLAG_VHT)))
+		return true;
+	return false;
 }
 
 u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index dbdac3a..54afbf4 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -4,7 +4,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
- * Copyright (C) 2015	Intel Deutschland GmbH
+ * Copyright (C) 2015-2016	Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -2681,6 +2681,18 @@ u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
 		sband = local->hw.wiphy->bands[status->band];
 		bitrate = sband->bitrates[status->rate_idx].bitrate;
 		ri.legacy = DIV_ROUND_UP(bitrate, (1 << shift));
+
+		if (status->flag & RX_FLAG_MACTIME_PLCP_START) {
+			/* TODO: handle HT/VHT preambles */
+			if (status->band == IEEE80211_BAND_5GHZ) {
+				ts += 20 << shift;
+				mpdu_offset += 2;
+			} else if (status->flag & RX_FLAG_SHORTPRE) {
+				ts += 96;
+			} else {
+				ts += 192;
+			}
+		}
 	}
 
 	rate = cfg80211_calculate_bitrate(&ri);
-- 
2.5.0

