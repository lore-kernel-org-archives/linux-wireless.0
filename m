Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41597 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173AbZFCHza (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 03:55:30 -0400
Subject: [PATCH] rfkill: always init poll delayed work
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain
Date: Wed, 03 Jun 2009 09:55:29 +0200
Message-Id: <1244015729.7176.28.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rfkill core didn't initialise the poll delayed work
because it assumed that polling was always done by specifying
the poll function. cfg80211, however, would like to start
polling only later, which is a valid use case and easy to
support, so change rfkill to always initialise the poll
delayed work and thus allow starting polling by calling the
rfkill_resume_polling() function after registration.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/rfkill/core.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- wireless-testing.orig/net/rfkill/core.c	2009-06-03 09:52:39.000000000 +0200
+++ wireless-testing/net/rfkill/core.c	2009-06-03 09:53:03.000000000 +0200
@@ -909,16 +909,15 @@ int __must_check rfkill_register(struct 
 
 	rfkill->registered = true;
 
-	if (rfkill->ops->poll) {
-		INIT_DELAYED_WORK(&rfkill->poll_work, rfkill_poll);
-		schedule_delayed_work(&rfkill->poll_work,
-			round_jiffies_relative(POLL_INTERVAL));
-	}
-
+	INIT_DELAYED_WORK(&rfkill->poll_work, rfkill_poll);
 	INIT_WORK(&rfkill->uevent_work, rfkill_uevent_work);
-
 	INIT_WORK(&rfkill->sync_work, rfkill_sync_work);
+
+	if (rfkill->ops->poll)
+		schedule_delayed_work(&rfkill->poll_work,
+			round_jiffies_relative(POLL_INTERVAL));
 	schedule_work(&rfkill->sync_work);
+
 	rfkill_send_events(rfkill, RFKILL_OP_ADD);
 
 	mutex_unlock(&rfkill_global_mutex);


