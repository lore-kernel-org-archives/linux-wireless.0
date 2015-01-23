Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35631 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605AbbAWK1i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 05:27:38 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211: suppress smatch warnings
Date: Fri, 23 Jan 2015 11:27:33 +0100
Message-Id: <1422008853-520-1-git-send-email-johannes@sipsolutions.net> (sfid-20150123_112741_953323_C06E767A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

smatch warns that we once checked request->ssids in two functions
and then unconditionally used it later again.

This is actually fine, because the code has a relationship between
attrs[NL80211_ATTR_SCAN_SSIDS], n_ssids and request->ssids, but
smatch isn't smart enough to realize that.

Suppress the warnings by always checking just n_ssids - that way
smatch won't know that request->ssids could be NULL, and since it
is only NULL when n_ssids is 0 we still check everything correctly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4542e8683beb..454d7a079d03 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5776,7 +5776,7 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		request->ssids = (void *)&request->channels[n_channels];
 	request->n_ssids = n_ssids;
 	if (ie_len) {
-		if (request->ssids)
+		if (n_ssids)
 			request->ie = (void *)(request->ssids + n_ssids);
 		else
 			request->ie = (void *)(request->channels + n_channels);
@@ -5832,7 +5832,7 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	request->n_channels = i;
 
 	i = 0;
-	if (info->attrs[NL80211_ATTR_SCAN_SSIDS]) {
+	if (n_ssids) {
 		nla_for_each_nested(attr, info->attrs[NL80211_ATTR_SCAN_SSIDS], tmp) {
 			if (nla_len(attr) > IEEE80211_MAX_SSID_LEN) {
 				err = -EINVAL;
@@ -6030,7 +6030,7 @@ nl80211_parse_sched_scan(struct wiphy *wiphy, struct wireless_dev *wdev,
 		request->ssids = (void *)&request->channels[n_channels];
 	request->n_ssids = n_ssids;
 	if (ie_len) {
-		if (request->ssids)
+		if (n_ssids)
 			request->ie = (void *)(request->ssids + n_ssids);
 		else
 			request->ie = (void *)(request->channels + n_channels);
@@ -6039,7 +6039,7 @@ nl80211_parse_sched_scan(struct wiphy *wiphy, struct wireless_dev *wdev,
 	if (n_match_sets) {
 		if (request->ie)
 			request->match_sets = (void *)(request->ie + ie_len);
-		else if (request->ssids)
+		else if (n_ssids)
 			request->match_sets =
 				(void *)(request->ssids + n_ssids);
 		else
@@ -6098,7 +6098,7 @@ nl80211_parse_sched_scan(struct wiphy *wiphy, struct wireless_dev *wdev,
 	request->n_channels = i;
 
 	i = 0;
-	if (attrs[NL80211_ATTR_SCAN_SSIDS]) {
+	if (n_ssids) {
 		nla_for_each_nested(attr, attrs[NL80211_ATTR_SCAN_SSIDS],
 				    tmp) {
 			if (nla_len(attr) > IEEE80211_MAX_SSID_LEN) {
-- 
2.1.4

