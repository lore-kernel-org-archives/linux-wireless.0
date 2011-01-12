Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:45200 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125Ab1ALMv7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 07:51:59 -0500
From: <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: Luciano Coelho <coelho@ti.com>, stable@kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] mac80211: use maximum number of a-msdu frames as default in BA RX
Date: Wed, 12 Jan 2011 14:51:21 +0200
Message-ID: <1294836681-21712-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

When the buffer size is set to zero in the block ack parameter set
field, we should use the maximum supported number of subframes.  The
existing code was bogus and was doing some unnecessary calculations
that lead to wrong values.

Thanks Johannes for helping me figure this one out.

Cc: stable@kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 net/mac80211/agg-rx.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 002db5e..ed3ee93 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -231,13 +231,8 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
 		goto end_no_lock;
 	}
 	/* determine default buffer size */
-	if (buf_size == 0) {
-		struct ieee80211_supported_band *sband;
-
-		sband = local->hw.wiphy->bands[conf->channel->band];
-		buf_size = IEEE80211_MIN_AMPDU_BUF;
-		buf_size = buf_size << sband->ht_cap.ampdu_factor;
-	}
+	if (buf_size == 0)
+		buf_size = IEEE80211_MAX_AMPDU_BUF;
 
 	/* make sure the size doesn't exceed the maximum supported by the hw */
 	if (buf_size > local->hw.max_rx_aggregation_subframes)
-- 
1.7.1

