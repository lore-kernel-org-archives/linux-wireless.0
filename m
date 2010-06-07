Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35577 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667Ab0FGLDY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 07:03:24 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.71)
	(envelope-from <johannes@sipsolutions.net>)
	id 1OLa71-0007EU-7Z
	for linux-wireless@vger.kernel.org; Mon, 07 Jun 2010 13:03:23 +0200
Message-Id: <20100607110202.206072320@sipsolutions.net>
Date: Mon, 07 Jun 2010 13:01:50 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 17/21] mac80211: fix RX aggregation timer
References: <20100607110133.472649120@sipsolutions.net>
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

--- wireless-testing.orig/net/mac80211/agg-rx.c	2010-06-06 13:22:28.000000000 +0200
+++ wireless-testing/net/mac80211/agg-rx.c	2010-06-06 13:22:29.000000000 +0200
@@ -274,6 +274,10 @@ void ieee80211_process_addba_request(str
 
 	/* activate it for RX */
 	rcu_assign_pointer(sta->ampdu_mlme.tid_rx[tid], tid_agg_rx);
+
+	if (timeout)
+		mod_timer(&tid_agg_rx->session_timer, TU_TO_EXP_TIME(timeout));
+
 end:
 	spin_unlock_bh(&sta->lock);
 


