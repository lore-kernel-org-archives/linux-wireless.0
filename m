Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33496 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760791AbdAKPmN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 10:42:13 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: set wifi_acked[_valid] bits for transmitted SKBs
Date: Wed, 11 Jan 2017 16:42:10 +0100
Message-Id: <20170111154210.1488-1-johannes@sipsolutions.net> (sfid-20170111_164245_174598_69F07374)
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
index f7c5ae597639..d6a1bfaa7a81 100644
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
