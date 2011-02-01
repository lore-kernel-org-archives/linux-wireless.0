Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38059 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916Ab1BAOfj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 09:35:39 -0500
Subject: [PATCH] mac80211: allow GO to scan like AP
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 15:35:36 +0100
Message-ID: <1296570936.3989.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no point in disallowing scanning for a
GO interface when it's not beaconing yet.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/mac80211/cfg.c	2011-02-01 15:33:04.000000000 +0100
+++ wireless-testing/net/mac80211/cfg.c	2011-02-01 15:33:43.000000000 +0100
@@ -1274,8 +1274,11 @@ static int ieee80211_scan(struct wiphy *
 	case NL80211_IFTYPE_P2P_GO:
 		if (sdata->local->ops->hw_scan)
 			break;
-		/* FIXME: implement NoA while scanning in software */
-		return -EOPNOTSUPP;
+		/*
+		 * FIXME: implement NoA while scanning in software,
+		 * for now fall through to allow scanning only when
+		 * beaconing hasn't been configured yet
+		 */
 	case NL80211_IFTYPE_AP:
 		if (sdata->u.ap.beacon)
 			return -EOPNOTSUPP;


