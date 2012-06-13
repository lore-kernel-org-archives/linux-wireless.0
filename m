Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41180 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab2FMJIM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 05:08:12 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.77)
	(envelope-from <johannes@sipsolutions.net>)
	id 1SejYg-00016X-9q
	for linux-wireless@vger.kernel.org; Wed, 13 Jun 2012 11:08:10 +0200
Message-ID: <1339578489.4519.21.camel@jlt3.sipsolutions.net> (sfid-20120613_110815_937855_E25C00EE)
Subject: [PATCH] nl80211: fix sched scan match attribute name
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 13 Jun 2012 11:08:09 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It should be NL80211_SCHED_SCAN_MATCH_ATTR_SSID as
documented, not NL80211_ATTR_SCHED_SCAN_MATCH_SSID.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/nl80211.h |    5 ++++-
 net/wireless/nl80211.c  |    4 ++--
 2 files changed, 6 insertions(+), 3 deletions(-)

--- a/include/linux/nl80211.h	2012-06-13 10:57:25.000000000 +0200
+++ b/include/linux/nl80211.h	2012-06-13 10:58:24.000000000 +0200
@@ -1959,7 +1959,7 @@ enum nl80211_reg_rule_attr {
 enum nl80211_sched_scan_match_attr {
 	__NL80211_SCHED_SCAN_MATCH_ATTR_INVALID,
 
-	NL80211_ATTR_SCHED_SCAN_MATCH_SSID,
+	NL80211_SCHED_SCAN_MATCH_ATTR_SSID,
 
 	/* keep last */
 	__NL80211_SCHED_SCAN_MATCH_ATTR_AFTER_LAST,
@@ -1967,6 +1967,9 @@ enum nl80211_sched_scan_match_attr {
 		__NL80211_SCHED_SCAN_MATCH_ATTR_AFTER_LAST - 1
 };
 
+/* only for backward compatibility */
+#define NL80211_ATTR_SCHED_SCAN_MATCH_SSID NL80211_SCHED_SCAN_MATCH_ATTR_SSID
+
 /**
  * enum nl80211_reg_rule_flags - regulatory rule flags
  *
--- a/net/wireless/nl80211.c	2012-06-13 10:55:02.000000000 +0200
+++ b/net/wireless/nl80211.c	2012-06-13 10:58:05.000000000 +0200
@@ -250,7 +250,7 @@ nl80211_rekey_policy[NUM_NL80211_REKEY_D
 
 static const struct nla_policy
 nl80211_match_policy[NL80211_SCHED_SCAN_MATCH_ATTR_MAX + 1] = {
-	[NL80211_ATTR_SCHED_SCAN_MATCH_SSID] = { .type = NLA_BINARY,
+	[NL80211_SCHED_SCAN_MATCH_ATTR_SSID] = { .type = NLA_BINARY,
 						 .len = IEEE80211_MAX_SSID_LEN },
 };
 
@@ -4190,7 +4190,7 @@ static int nl80211_start_sched_scan(stru
 			nla_parse(tb, NL80211_SCHED_SCAN_MATCH_ATTR_MAX,
 				  nla_data(attr), nla_len(attr),
 				  nl80211_match_policy);
-			ssid = tb[NL80211_ATTR_SCHED_SCAN_MATCH_SSID];
+			ssid = tb[NL80211_SCHED_SCAN_MATCH_ATTR_SSID];
 			if (ssid) {
 				if (nla_len(ssid) > IEEE80211_MAX_SSID_LEN) {
 					err = -EINVAL;


