Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59722 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960AbZGGCAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 22:00:14 -0400
Message-Id: <20090707015708.702314416@sipsolutions.net>
References: <20090707015604.369008211@sipsolutions.net>
Date: Tue, 07 Jul 2009 03:56:08 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/9] cfg80211: warn again on spurious deauth
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The original code in mac80211 could send a deauth
frame under certain circumstances even if nothing
had ever requested an authentication. This has been
fixed with the rework there, so cfg80211 can now
warn again about spurious events to catch possible
future drivers or mac80211 regressions.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/mlme.c |    6 ------
 1 file changed, 6 deletions(-)

--- wireless-testing.orig/net/wireless/mlme.c	2009-07-07 03:37:04.000000000 +0200
+++ wireless-testing/net/wireless/mlme.c	2009-07-07 03:37:05.000000000 +0200
@@ -122,15 +122,9 @@ void cfg80211_send_deauth(struct net_dev
 			break;
 		}
 	}
-/*
- * mac80211 currently triggers this warning,
- * so disable for now (it's harmless, just
- * means that we got a spurious event)
 
 	WARN_ON(!done);
 
- */
-
 	if (wdev->sme_state == CFG80211_SME_CONNECTED) {
 		u16 reason_code;
 		bool from_ap;

-- 

