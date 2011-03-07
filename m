Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:44346 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715Ab1CGMJQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 07:09:16 -0500
Subject: [PATCH] mac80211: Add log message to ieee80211_restart_hw()
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Mar 2011 13:09:12 +0100
Message-ID: <1299499752.5665.8.camel@marge>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a log message to ieee80211_restart_hw() to highlight
that special codepath in the logs. This helps debugging
bugs in the rarely tested restart code.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Index: compat-wireless-2011-02-25/net/mac80211/main.c
===================================================================
--- compat-wireless-2011-02-25.orig/net/mac80211/main.c	2011-03-07 12:58:14.996968980 +0100
+++ compat-wireless-2011-02-25/net/mac80211/main.c	2011-03-07 13:03:26.732273903 +0100
@@ -384,6 +384,9 @@ void ieee80211_restart_hw(struct ieee802
 
 	trace_api_restart_hw(local);
 
+	wiphy_info(hw->wiphy,
+		   "Hardware restart was requested\n");
+
 	/* use this reason, ieee80211_reconfig will unblock it */
 	ieee80211_stop_queues_by_reason(hw,
 		IEEE80211_QUEUE_STOP_REASON_SUSPEND);

-- 
Greetings, Michael.

