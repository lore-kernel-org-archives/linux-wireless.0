Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:43549 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbaAWE1R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 23:27:17 -0500
From: Raja Mani <rmani@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH] nl80211: Count only ssid attr to know number of match sets
Date: Thu, 23 Jan 2014 09:57:09 +0530
Message-ID: <1390451229-3308-1-git-send-email-rmani@qti.qualcomm.com> (sfid-20140123_052721_677350_857D5D7A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

NL80211_ATTR_SCHED_SCAN_MATCH can have NL80211_SCHED_SCAN_MATCH_ATTR_SSID
as well as NL80211_SCHED_SCAN_MATCH_ATTR_RSSI in it. Each nested attributes
which are part of NL80211_ATTR_SCHED_SCAN_MATCH are counted to find out
number of match sets in nl80211_start_sched_scan().

This is the problem if NL80211_SCHED_SCAN_MATCH_ATTR_RSSI also part of
NL80211_ATTR_SCHED_SCAN_MATCH. Fix this incorrect calculation by considering
only NL80211_SCHED_SCAN_MATCH_ATTR_SSID to know match set count.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
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

