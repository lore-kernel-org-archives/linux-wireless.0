Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38708 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab2ATMxw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jan 2012 07:53:52 -0500
Message-Id: <20120120125313.111967515@sipsolutions.net> (sfid-20120120_135356_463968_8998E77B)
Date: Fri, 20 Jan 2012 13:52:37 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] cfg80211: fix a few -Wshadow warnings
References: <20120120125235.243434836@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It seems that -Wshadow is no longer default in
sparse runs, but let's fix the warnings anyway.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/net/wireless/nl80211.c	2012-01-20 13:49:32.000000000 +0100
+++ b/net/wireless/nl80211.c	2012-01-20 13:51:00.000000000 +0100
@@ -427,10 +427,9 @@ static int nl80211_parse_key_new(struct
 
 	if (tb[NL80211_KEY_DEFAULT_TYPES]) {
 		struct nlattr *kdt[NUM_NL80211_KEY_DEFAULT_TYPES];
-		int err = nla_parse_nested(kdt,
-					   NUM_NL80211_KEY_DEFAULT_TYPES - 1,
-					   tb[NL80211_KEY_DEFAULT_TYPES],
-					   nl80211_key_default_policy);
+		err = nla_parse_nested(kdt, NUM_NL80211_KEY_DEFAULT_TYPES - 1,
+				       tb[NL80211_KEY_DEFAULT_TYPES],
+				       nl80211_key_default_policy);
 		if (err)
 			return err;
 
@@ -4781,7 +4780,6 @@ static int nl80211_join_ibss(struct sk_b
 			nla_len(info->attrs[NL80211_ATTR_BSS_BASIC_RATES]);
 		struct ieee80211_supported_band *sband =
 			wiphy->bands[ibss.channel->band];
-		int err;
 
 		err = ieee80211_get_ratemask(sband, rates, n_rates,
 					     &ibss.basic_rates);


