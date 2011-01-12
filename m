Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:47882 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756014Ab1ALNTH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 08:19:07 -0500
From: <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: Luciano Coelho <coelho@ti.com>, stable@kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v2] mac80211: use maximum number of AMPDU frames as default in BA RX
Date: Wed, 12 Jan 2011 15:18:11 +0200
Message-ID: <1294838291-32627-1-git-send-email-coelho@ti.com>
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
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/agg-rx.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index f138b19..227ca82 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -185,8 +185,6 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
 				     struct ieee80211_mgmt *mgmt,
 				     size_t len)
 {
-	struct ieee80211_hw *hw = &local->hw;
-	struct ieee80211_conf *conf = &hw->conf;
 	struct tid_ampdu_rx *tid_agg_rx;
 	u16 capab, tid, timeout, ba_policy, buf_size, start_seq_num, status;
 	u8 dialog_token;
@@ -231,13 +229,8 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
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
 
 
 	/* examine state machine */
-- 
1.7.1

