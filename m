Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58517 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbYFQG53 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2008 02:57:29 -0400
Subject: [PATCH 2.6.26] mac80211: detect driver tx bugs
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
In-Reply-To: <1213534540.3803.5.camel@johannes.berg> (sfid-20080615_145613_932431_D2E4E6A8)
References: <1213534025.3803.2.camel@johannes.berg>
	 (sfid-20080615_144745_622030_910244B5)  <1213534540.3803.5.camel@johannes.berg>
	 (sfid-20080615_145613_932431_D2E4E6A8)
Content-Type: text/plain; charset=UTF-8
Date: Tue, 17 Jun 2008 08:56:37 +0200
Message-Id: <1213685797.3803.65.camel@johannes.berg> (sfid-20080617_085743_609581_1AC580C7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a driver rejects a frame in it's ->tx() callback, it must also
stop queues, otherwise mac80211 can go into a loop here. Detect this
situation and abort the loop after five retries, warning about the
driver bug.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
This is a port of the patch to 2.6.26 which seems to suffer from the
same problem and could well be the cause of all the mac80211 softlockup
warnings on kerneloops.org.

Dave, with John on vacation until the 22nd, would you push this to Linu=
s
with the next net update instead of it going through John's tree first?

Ideally we'd fix the driver bugs, but that'd need an audit and this at
least lets the system continue and work, a b43 bugfix was posted too to
just drop frames if they come in at inopportune times.

 net/mac80211/tx.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a=EF=BB=BF/net/mac80211/tx.c	2008-06-17 08:45:25.096294488 +0200
+++ b/=EF=BB=BFnet/mac80211/tx.c	2008-06-17 08:47:02.106291721 +0200
@@ -1132,7 +1132,7 @@ static int ieee80211_tx(struct net_devic
 	ieee80211_tx_handler *handler;
 	struct ieee80211_tx_data tx;
 	ieee80211_tx_result res =3D TX_DROP, res_prepare;
-	int ret, i;
+	int ret, i, retries =3D 0;
=20
 	WARN_ON(__ieee80211_queue_pending(local, control->queue));
=20
@@ -1216,6 +1216,13 @@ retry:
 		if (!__ieee80211_queue_stopped(local, control->queue)) {
 			clear_bit(IEEE80211_LINK_STATE_PENDING,
 				  &local->state[control->queue]);
+			retries++;
+			/*
+			 * Driver bug, it's rejecting packets but
+			 * not stopping queues.
+			 */
+			if (WARN_ON_ONCE(retries > 5))
+				goto drop;
 			goto retry;
 		}
 		memcpy(&store->control, control,


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
