Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36352 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbbAWM0f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 07:26:35 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix per-TID RX-MSDU counter
Date: Fri, 23 Jan 2015 13:26:31 +0100
Message-Id: <1422015991-20096-1-git-send-email-johannes@sipsolutions.net> (sfid-20150123_132638_333844_6F72E682)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In the case of non-QoS association, the counter was actually
wrong. The right index isn't security_idx but seqno_idx, as
security_idx will be 0 for data frames, while 16 is needed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 3d79d498e7f6..ed516ae80a3b 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2310,12 +2310,12 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 		return RX_DROP_MONITOR;
 
 	if (rx->sta) {
-		/* The security index has the same property as needed
+		/* The seqno index has the same property as needed
 		 * for the rx_msdu field, i.e. it is IEEE80211_NUM_TIDS
 		 * for non-QoS-data frames. Here we know it's a data
 		 * frame, so count MSDUs.
 		 */
-		rx->sta->rx_msdu[rx->security_idx]++;
+		rx->sta->rx_msdu[rx->seqno_idx]++;
 	}
 
 	/*
-- 
2.1.4

