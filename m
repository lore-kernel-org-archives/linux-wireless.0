Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33196 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab1GSVzV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 17:55:21 -0400
Subject: Re: Kernel oops in code added by "cfg80211: allow userspace to
 control supported rates in scan"
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4E25FA60.7040807@gnu.org> (sfid-20110719_234302_063697_7FDE84C7)
References: <4E25FA60.7040807@gnu.org>
	 (sfid-20110719_234302_063697_7FDE84C7)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jul 2011 23:55:17 +0200
Message-ID: <1311112517.3872.0.camel@jlt3.sipsolutions.net> (sfid-20110719_235524_355940_29A3B4CF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-07-19 at 17:42 -0400, Pavel Roskin wrote:

> for (i = 0; i < IEEE80211_NUM_BANDS; i++)
>        request->rates[i] = (1 << wiphy->bands[i]->n_bitrates) - 1;

Ah crap, I didn't pay attention and never tested a single-band card.
Below change should fix it.

johannes
---
 net/wireless/nl80211.c |    4 +++-
 net/wireless/scan.c    |    3 ++-
 net/wireless/util.c    |    3 +++
 3 files changed, 8 insertions(+), 2 deletions(-)

--- a/net/wireless/nl80211.c	2011-07-19 23:52:44.000000000 +0200
+++ b/net/wireless/nl80211.c	2011-07-19 23:53:26.000000000 +0200
@@ -3454,7 +3454,9 @@ static int nl80211_trigger_scan(struct s
 	}
 
 	for (i = 0; i < IEEE80211_NUM_BANDS; i++)
-		request->rates[i] = (1 << wiphy->bands[i]->n_bitrates) - 1;
+		if (wiphy->bands[i])
+			request->rates[i] =
+				(1 << wiphy->bands[i]->n_bitrates) - 1;
 
 	if (info->attrs[NL80211_ATTR_SCAN_SUPP_RATES]) {
 		nla_for_each_nested(attr,
--- a/net/wireless/scan.c	2011-07-19 23:52:45.000000000 +0200
+++ b/net/wireless/scan.c	2011-07-19 23:53:21.000000000 +0200
@@ -864,7 +864,8 @@ int cfg80211_wext_siwscan(struct net_dev
 	}
 
 	for (i = 0; i < IEEE80211_NUM_BANDS; i++)
-		creq->rates[i] = (1 << wiphy->bands[i]->n_bitrates) - 1;
+		if (wiphy->bands[i])
+			creq->rates[i] = (1 << wiphy->bands[i]->n_bitrates) - 1;
 
 	rdev->scan_req = creq;
 	err = rdev->ops->scan(wiphy, dev, creq);
--- a/net/wireless/util.c	2011-07-19 23:53:39.000000000 +0200
+++ b/net/wireless/util.c	2011-07-19 23:53:57.000000000 +0200
@@ -1013,6 +1013,9 @@ int ieee80211_get_ratemask(struct ieee80
 {
 	int i, j;
 
+	if (!sband)
+		return -EINVAL;
+
 	if (n_rates == 0 || n_rates > NL80211_MAX_SUPP_RATES)
 		return -EINVAL;
 


