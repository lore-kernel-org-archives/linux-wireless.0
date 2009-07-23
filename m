Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60524 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbZGWOGQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 10:06:16 -0400
Subject: [PATCH] mac80211: fix mlme timeouts
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Alban Browaeys <prahal@yahoo.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 23 Jul 2009 16:05:41 +0200
Message-Id: <1248357941.17088.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a new MLME work is created, its timeout is initialised
to 0. This is wrong, it could then be thought of as having
an actual timeout in the future (time_is_after_jiffies() can
return true). Instead, it should be initialised to jiffies
so that it will run right away as soon as the mlme work is
executed.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Reported-by: Luciano Roth Coelho <luciano.coelho@nokia.com>
Reported-by: Alban Browaeys <prahal@yahoo.com>
---
This time CC to the list, sorry.

 net/mac80211/mlme.c |    3 +++
 1 file changed, 3 insertions(+)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-07-23 15:56:48.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-07-23 16:03:45.000000000 +0200
@@ -1657,6 +1657,7 @@ static void ieee80211_rx_mgmt_probe_resp
 		       sdata->dev->name);
 		wk->tries = 0;
 		wk->state = IEEE80211_MGD_STATE_AUTH;
+		wk->timeout = jiffies; /* run again right away */
 		WARN_ON(ieee80211_authenticate(sdata, wk) != RX_MGMT_NONE);
 	}
 
@@ -2374,6 +2375,7 @@ int ieee80211_mgd_auth(struct ieee80211_
 
 	wk->state = IEEE80211_MGD_STATE_PROBE;
 	wk->auth_alg = auth_alg;
+	wk->timeout = jiffies; /* run right away */
 
 	/*
 	 * XXX: if still associated need to tell AP that we're going
@@ -2445,6 +2447,7 @@ int ieee80211_mgd_assoc(struct ieee80211
 
 	wk->state = IEEE80211_MGD_STATE_ASSOC;
 	wk->tries = 0;
+	wk->timeout = jiffies; /* run right away */
 
 	if (req->use_mfp) {
 		ifmgd->mfp = IEEE80211_MFP_REQUIRED;


