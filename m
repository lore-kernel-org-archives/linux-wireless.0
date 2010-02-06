Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50819 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822Ab0BFOKS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Feb 2010 09:10:18 -0500
Subject: [PATCH] mac80211: fix deauth race
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 06 Feb 2010 15:10:15 +0100
Message-ID: <1265465415.4041.25.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When userspace requests a deauth while the
authentication work is pending in the auth
(not probe) state, we do not properly abort
the work and then things get confused.

Fix that and also improve the checks here
to include the correct virtual interface,
just in case two virtual interfaces would
ever try to connect to the same BSS.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2010-02-06 15:07:37.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2010-02-06 15:07:43.000000000 +0100
@@ -2007,11 +2007,17 @@ int ieee80211_mgd_deauth(struct ieee8021
 
 		mutex_lock(&local->work_mtx);
 		list_for_each_entry(wk, &local->work_list, list) {
-			if (wk->type != IEEE80211_WORK_DIRECT_PROBE)
+			if (wk->sdata != sdata)
 				continue;
+
+			if (wk->type != IEEE80211_WORK_DIRECT_PROBE &&
+			    wk->type != IEEE80211_WORK_AUTH)
+				continue;
+
 			if (memcmp(req->bss->bssid, wk->filter_ta, ETH_ALEN))
 				continue;
-			not_auth_yet = true;
+
+			not_auth_yet = wk->type == IEEE80211_WORK_DIRECT_PROBE;
 			list_del(&wk->list);
 			free_work(wk);
 			break;


