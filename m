Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46556 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516Ab0FIPHW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jun 2010 11:07:22 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.71)
	(envelope-from <johannes@sipsolutions.net>)
	id 1OMMsD-00089x-GP
	for linux-wireless@vger.kernel.org; Wed, 09 Jun 2010 17:07:21 +0200
Message-Id: <20100609150456.191611399@sipsolutions.net>
Date: Wed, 09 Jun 2010 17:01:59 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC v2 17/22] mac80211: fix RX aggregation timer
References: <20100609150142.227469359@sipsolutions.net>
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

--- wireless-testing.orig/net/mac80211/agg-rx.c	2010-06-09 12:57:30.000000000 +0200
+++ wireless-testing/net/mac80211/agg-rx.c	2010-06-09 12:57:31.000000000 +0200
@@ -274,6 +274,10 @@ void ieee80211_process_addba_request(str
 
 	/* activate it for RX */
 	rcu_assign_pointer(sta->ampdu_mlme.tid_rx[tid], tid_agg_rx);
+
+	if (timeout)
+		mod_timer(&tid_agg_rx->session_timer, TU_TO_EXP_TIME(timeout));
+
 end:
 	spin_unlock_bh(&sta->lock);
 


