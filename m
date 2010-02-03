Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46491 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757235Ab0BCM5v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2010 07:57:51 -0500
Subject: [PATCH] mac80211: don't probe if we have probe response
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Feb 2010 13:57:46 +0100
Message-ID: <1265201866.29119.90.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can now easily determine whether we already
have probe response information for the BSS we
are asked to connect to, in which case there's
little point in probing the BSS again.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2010-02-03 13:52:43.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2010-02-03 13:53:08.000000000 +0100
@@ -27,10 +27,6 @@
 #include "rate.h"
 #include "led.h"
 
-#define IEEE80211_AUTH_TIMEOUT (HZ / 5)
-#define IEEE80211_AUTH_MAX_TRIES 3
-#define IEEE80211_ASSOC_TIMEOUT (HZ / 5)
-#define IEEE80211_ASSOC_MAX_TRIES 3
 #define IEEE80211_MAX_PROBE_TRIES 5
 
 /*
@@ -1844,7 +1840,11 @@ int ieee80211_mgd_auth(struct ieee80211_
 	wk->probe_auth.algorithm = auth_alg;
 	wk->probe_auth.privacy = req->bss->capability & WLAN_CAPABILITY_PRIVACY;
 
-	wk->type = IEEE80211_WORK_DIRECT_PROBE;
+	/* if we already have a probe, don't probe again */
+	if (req->bss->proberesp_ies)
+		wk->type = IEEE80211_WORK_AUTH;
+	else
+		wk->type = IEEE80211_WORK_DIRECT_PROBE;
 	wk->chan = req->bss->channel;
 	wk->sdata = sdata;
 	wk->done = ieee80211_probe_auth_done;


