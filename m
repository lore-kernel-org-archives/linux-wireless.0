Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39049 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab1GSWwX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 18:52:23 -0400
Subject: [PATCH] cfg80211: fix scan crash on single-band cards
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jul 2011 00:52:16 +0200
Message-ID: <1311115936.3872.3.camel@jlt3.sipsolutions.net> (sfid-20110720_005226_048022_378572D2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

commit 58389c69150e6032504dfcd3edca6b1975c8b5bc
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Mon Jul 18 18:08:35 2011 +0200

     cfg80211: allow userspace to control supported rates in scan

made single-band cards crash since it would always
access all wiphy->bands[]. Fix this and reject any
attempts in the new helper ieee80211_get_ratemask()
to do the same, rejecting rates configuration for
unsupported bands.

Reported-by: Pavel Roskin <proski@gnu.org>
Tested-by: Pavel Roskin <proski@gnu.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c |    4 +++-
 net/wireless/scan.c    |    3 ++-
 net/wireless/util.c    |    3 +++
 3 files changed, 8 insertions(+), 2 deletions(-)

--- a/net/wireless/nl80211.c	2011-07-20 00:50:57.000000000 +0200
+++ b/net/wireless/nl80211.c	2011-07-20 00:51:00.000000000 +0200
@@ -3454,7 +3454,9 @@ static int nl80211_trigger_scan(struct s
 	}
 
 	for (i = 0; i < IEEE80211_NUM_BANDS; i++)
-		request->rates[i] = (1 << wiphy->bands[i]->n_bitrates) - 1;
+		if (wiphy->bands[i])
+			request->rates[i] =
+				(1 << wiphy->bands[i]->n_bitrates) - 1;
 
 	if (info->attrs[NL80211_ATTR_SCAN_SUPP_RATES]) {
 		nla_for_each_nested(attr,
--- a/net/wireless/scan.c	2011-07-20 00:50:57.000000000 +0200
+++ b/net/wireless/scan.c	2011-07-20 00:51:00.000000000 +0200
@@ -864,7 +864,8 @@ int cfg80211_wext_siwscan(struct net_dev
 	}
 
 	for (i = 0; i < IEEE80211_NUM_BANDS; i++)
-		creq->rates[i] = (1 << wiphy->bands[i]->n_bitrates) - 1;
+		if (wiphy->bands[i])
+			creq->rates[i] = (1 << wiphy->bands[i]->n_bitrates) - 1;
 
 	rdev->scan_req = creq;
 	err = rdev->ops->scan(wiphy, dev, creq);
--- a/net/wireless/util.c	2011-07-20 00:50:57.000000000 +0200
+++ b/net/wireless/util.c	2011-07-20 00:51:00.000000000 +0200
@@ -1013,6 +1013,9 @@ int ieee80211_get_ratemask(struct ieee80
 {
 	int i, j;
 
+	if (!sband)
+		return -EINVAL;
+
 	if (n_rates == 0 || n_rates > NL80211_MAX_SUPP_RATES)
 		return -EINVAL;
 


