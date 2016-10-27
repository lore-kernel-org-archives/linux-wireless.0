Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39894 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S938535AbcJ0OVI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Oct 2016 10:21:08 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC] mac80211: set wifi_acked[_valid] bits for transmitted SKBs
Date: Thu, 27 Oct 2016 16:21:03 +0200
Message-Id: <20161027142103.19756-1-johannes@sipsolutions.net> (sfid-20161027_162144_303196_AA5ABF9B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There may be situations in which the in-kernel originator of an
SKB cares about its wifi transmission status. To have that, set
the wifi_acked[_valid] bits before freeing/orphaning the SKB if
the destructor is set. The originator can then use it in there.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/status.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index ddf71c648cab..dc3132d0effe 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -541,6 +541,11 @@ static void ieee80211_report_used_skb(struct ieee80211_local *local,
 	} else if (info->ack_frame_id) {
 		ieee80211_report_ack_skb(local, info, acked, dropped);
 	}
+
+	if (!dropped && skb->destructor) {
+		skb->wifi_acked_valid = 1;
+		skb->wifi_acked = acked;
+	}
 }
 
 /*
-- 
2.9.3
