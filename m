Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45226 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757387AbYDALss (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 07:48:48 -0400
Message-Id: <20080331172436.991660000@sipsolutions.net> (sfid-20080401_124916_222191_B13B8D92)
References: <20080331172258.541914000@sipsolutions.net>
Date: Mon, 31 Mar 2008 19:23:04 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Vladimir Koutny <vlado@work.ksp.sk>
Subject: [PATCH 6/6] mac80211: fix sparse complaint in
	ieee80211_sta_def_wmm_params
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A variable 'i' is being shadowed by another one, but the second
one can just be removed.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Vladimir Koutny <vlado@work.ksp.sk>
---
 net/mac80211/ieee80211_sta.c |    1 -
 1 file changed, 1 deletion(-)

--- everything.orig/net/mac80211/ieee80211_sta.c	2008-03-31 18:22:26.000000000 +0200
+++ everything/net/mac80211/ieee80211_sta.c	2008-03-31 18:22:26.000000000 +0200
@@ -244,7 +244,6 @@ static void ieee80211_sta_def_wmm_params
 
 	if (local->ops->conf_tx) {
 		struct ieee80211_tx_queue_params qparam;
-		int i;
 
 		memset(&qparam, 0, sizeof(qparam));
 

-- 

