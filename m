Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57905 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbZGWOuy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 10:50:54 -0400
Subject: [PATCH v2] mac80211: fix mlme timeouts
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Alban Browaeys <prahal@yahoo.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1248357941.17088.2.camel@johannes.local>
References: <1248357941.17088.2.camel@johannes.local>
Content-Type: text/plain
Date: Thu, 23 Jul 2009 16:50:16 +0200
Message-Id: <1248360616.24145.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Subject: mac80211: fix mlme timeouts

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
the assignment on probe response is, at least, unnecessary.

 net/mac80211/mlme.c |    2 ++
 1 file changed, 2 insertions(+)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-07-23 16:04:33.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-07-23 16:49:19.000000000 +0200
@@ -2374,6 +2374,7 @@ int ieee80211_mgd_auth(struct ieee80211_
 
 	wk->state = IEEE80211_MGD_STATE_PROBE;
 	wk->auth_alg = auth_alg;
+	wk->timeout = jiffies; /* run right away */
 
 	/*
 	 * XXX: if still associated need to tell AP that we're going
@@ -2445,6 +2446,7 @@ int ieee80211_mgd_assoc(struct ieee80211
 
 	wk->state = IEEE80211_MGD_STATE_ASSOC;
 	wk->tries = 0;
+	wk->timeout = jiffies; /* run right away */
 
 	if (req->use_mfp) {
 		ifmgd->mfp = IEEE80211_MFP_REQUIRED;


