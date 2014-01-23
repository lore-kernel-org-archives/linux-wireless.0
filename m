Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:22042 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaAWLe1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 06:34:27 -0500
From: Raja Mani <rmani@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH-v2] nl80211: Fix bug in match set count calculation
Date: Thu, 23 Jan 2014 17:04:18 +0530
Message-ID: <1390476858-4833-1-git-send-email-rmani@qti.qualcomm.com> (sfid-20140123_123431_127580_4C32D8BE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Match set count is calculated in nl80211_start_sched_scan() by counting
each attr available in NL80211_ATTR_SCHED_SCAN_MATCH. Some cases, RSSI
threshold limit NL80211_SCHED_SCAN_MATCH_ATTR_RSSI attr also can come
from user space along with NL80211_SCHED_SCAN_MATCH_ATTR_SSID attr.
In such cases, exiting code counts NL80211_SCHED_SCAN_MATCH_ATTR_RSSI
attr also as one of SSID and leads extra memory allocation for match set
array (request->match_sets).

Counting only NL80211_SCHED_SCAN_MATCH_ATTR_RSSI attr will help nl80211 to
allocate exact memory needed for match set array and also driver can know
the exact valid SSID available in match set array.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---

V2 changes:
* Changed commit text and patch title as per johannas comments.

 net/wireless/nl80211.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d0afd82..2d3a86f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5504,11 +5504,17 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	if (n_ssids > wiphy->max_sched_scan_ssids)
 		return -EINVAL;
 
-	if (info->attrs[NL80211_ATTR_SCHED_SCAN_MATCH])
+	if (info->attrs[NL80211_ATTR_SCHED_SCAN_MATCH]) {
 		nla_for_each_nested(attr,
 				    info->attrs[NL80211_ATTR_SCHED_SCAN_MATCH],
-				    tmp)
-			n_match_sets++;
+				    tmp) {
+			nla_parse(tb, NL80211_SCHED_SCAN_MATCH_ATTR_MAX,
+				  nla_data(attr), nla_len(attr),
+				  nl80211_match_policy);
+			if (tb[NL80211_SCHED_SCAN_MATCH_ATTR_SSID])
+				n_match_sets++;
+		}
+	}
 
 	if (n_match_sets > wiphy->max_match_sets)
 		return -EINVAL;
-- 
1.7.10.4

