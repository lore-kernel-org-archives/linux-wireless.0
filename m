Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42779 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759282AbcINIMC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 04:12:02 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/5] nl80211: always check nla_put* return values
Date: Wed, 14 Sep 2016 10:11:55 +0200
Message-Id: <1473840718-5605-2-git-send-email-johannes@sipsolutions.net> (sfid-20160914_101206_967517_38396B3A)
In-Reply-To: <1473840718-5605-1-git-send-email-johannes@sipsolutions.net>
References: <1473840718-5605-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

A few instances were found where we didn't check them, add the
missing checks even though they'll probably never trigger as
the message should be large enough here.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4c8cc743ae7d..ec024cb90faa 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9444,8 +9444,10 @@ static int nl80211_send_wowlan_nd(struct sk_buff *msg,
 	if (!freqs)
 		return -ENOBUFS;
 
-	for (i = 0; i < req->n_channels; i++)
-		nla_put_u32(msg, i, req->channels[i]->center_freq);
+	for (i = 0; i < req->n_channels; i++) {
+		if (nla_put_u32(msg, i, req->channels[i]->center_freq))
+			return -ENOBUFS;
+	}
 
 	nla_nest_end(msg, freqs);
 
@@ -9459,9 +9461,10 @@ static int nl80211_send_wowlan_nd(struct sk_buff *msg,
 			if (!match)
 				return -ENOBUFS;
 
-			nla_put(msg, NL80211_SCHED_SCAN_MATCH_ATTR_SSID,
-				req->match_sets[i].ssid.ssid_len,
-				req->match_sets[i].ssid.ssid);
+			if (nla_put(msg, NL80211_SCHED_SCAN_MATCH_ATTR_SSID,
+				    req->match_sets[i].ssid.ssid_len,
+				    req->match_sets[i].ssid.ssid))
+				return -ENOBUFS;
 			nla_nest_end(msg, match);
 		}
 		nla_nest_end(msg, matches);
-- 
2.8.1
