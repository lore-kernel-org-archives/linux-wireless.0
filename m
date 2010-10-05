Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37179 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab0JETkd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 15:40:33 -0400
Subject: [PATCH wireless-2.6] mac80211: delete AddBA response timer
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 21:40:33 +0200
Message-ID: <1286307633.3641.29.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We never delete the addBA response timer, which
is typically fine, but if the station it belongs
to is deleted very quickly after starting the BA
session, before the peer had a chance to reply,
the timer may fire after the station struct has
been freed already. Therefore, we need to delete
the timer in a suitable spot -- best when the
session is being stopped (which will happen even
then) in which case the delete will be a no-op
most of the time.

I've reproduced the scenario and tested the fix.

Cc: stable@kernel.org
Reported-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
This might be applicable to stable, but the code
has changed significantly, I'd appreciate any help
analysing and backporting it.

 net/mac80211/agg-tx.c |    2 ++
 1 file changed, 2 insertions(+)

--- wireless-testing.orig/net/mac80211/agg-tx.c	2010-10-05 21:00:59.000000000 +0200
+++ wireless-testing/net/mac80211/agg-tx.c	2010-10-05 21:01:11.000000000 +0200
@@ -176,6 +176,8 @@ int ___ieee80211_stop_tx_ba_session(stru
 
 	set_bit(HT_AGG_STATE_STOPPING, &tid_tx->state);
 
+	del_timer_sync(&tid_tx->addba_resp_timer);
+
 	/*
 	 * After this packets are no longer handed right through
 	 * to the driver but are put onto tid_tx->pending instead,


