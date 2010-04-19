Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39483 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab0DSIsk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 04:48:40 -0400
Subject: [PATCH 2.6.34] mac80211: remove bogus TX agg state assignment
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Apr 2010 10:48:38 +0200
Message-ID: <1271666918.3873.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the addba timer expires but has no work to do,
it should not affect the state machine. If it does,
TX will not see the successfully established and we
can also crash trying to re-establish the session.

Cc: stable@kernel.org [2.6.32, 2.6.33]
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/agg-tx.c |    1 -
 1 file changed, 1 deletion(-)

--- wireless-testing.orig/net/mac80211/agg-tx.c	2010-04-19 10:42:55.000000000 +0200
+++ wireless-testing/net/mac80211/agg-tx.c	2010-04-19 10:43:12.000000000 +0200
@@ -183,7 +183,6 @@ static void sta_addba_resp_timer_expired
 		       HT_AGG_STATE_REQ_STOP_BA_MSK)) !=
 						HT_ADDBA_REQUESTED_MSK) {
 		spin_unlock_bh(&sta->lock);
-		*state = HT_AGG_STATE_IDLE;
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "timer expired on tid %d but we are not "
 				"(or no longer) expecting addBA response there",


