Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42778 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab0FJI0U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 04:26:20 -0400
Message-Id: <20100610082231.910424119@sipsolutions.net>
Date: Thu, 10 Jun 2010 10:21:45 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 17/23] mac80211: fix RX aggregation timer
References: <20100610082128.641664439@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

I noticed that when there was _no_ traffic at
all on a given aggregation session, it would
never time out. This won't happen unless you
forced creating a session, but fix it anyway.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-rx.c |    4 ++++
 1 file changed, 4 insertions(+)

--- wireless-testing.orig/net/mac80211/agg-rx.c	2010-06-09 17:21:15.000000000 +0200
+++ wireless-testing/net/mac80211/agg-rx.c	2010-06-09 17:21:15.000000000 +0200
@@ -274,6 +274,10 @@ void ieee80211_process_addba_request(str
 
 	/* activate it for RX */
 	rcu_assign_pointer(sta->ampdu_mlme.tid_rx[tid], tid_agg_rx);
+
+	if (timeout)
+		mod_timer(&tid_agg_rx->session_timer, TU_TO_EXP_TIME(timeout));
+
 end:
 	spin_unlock_bh(&sta->lock);
 


