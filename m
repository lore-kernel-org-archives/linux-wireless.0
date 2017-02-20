Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50064 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752622AbdBTNR5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Feb 2017 08:17:57 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix packet statistics for fast-RX
Date: Mon, 20 Feb 2017 14:17:21 +0100
Message-Id: <20170220131721.14585-1-johannes@sipsolutions.net> (sfid-20170220_141800_964814_A8F75D03)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When adding per-CPU statistics, which added statistics back
to mac80211 for the fast-RX path, I evidently forgot to add
the "stats->packets++" line. The reason for that is likely
that I didn't see it since it's done in defragmentation for
the regular RX path.

Add the missing line to properly count received packets in
the fast-RX case.

Fixes: c9c5962b56c1 ("mac80211: enable collecting station statistics per-CPU")
Reported-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 50ca3828b124..a8443d8bc233 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3880,6 +3880,7 @@ static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
 	stats->last_rate = sta_stats_encode_rate(status);
 
 	stats->fragments++;
+	stats->packets++;
 
 	if (!(status->flag & RX_FLAG_NO_SIGNAL_VAL)) {
 		stats->last_signal = status->signal;
-- 
2.9.3
