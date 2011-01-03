Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59766 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab1ACSm1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jan 2011 13:42:27 -0500
Subject: [PATCH 2.6.37] mac80211: add missing synchronize_rcu
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Jan 2011 19:42:24 +0100
Message-ID: <1294080144.3436.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

commit ad0e2b5a00dbec303e4682b403bb6703d11dcdb2
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Tue Jun 1 10:19:19 2010 +0200

    mac80211: simplify key locking

removed the synchronization against RCU and thus
opened a race window where we can use a key for
TX while it is already freed. Put a synchronisation
into the right place to close that window.

Reported-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: stable@kernel.org [2.6.36+]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/key.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- wireless-testing.orig/net/mac80211/key.c	2011-01-03 19:04:10.000000000 +0100
+++ wireless-testing/net/mac80211/key.c	2011-01-03 19:04:20.000000000 +0100
@@ -379,6 +379,12 @@ static void __ieee80211_key_destroy(stru
 	if (!key)
 		return;
 
+	/*
+	 * Synchronize so the TX path can no longer be using
+	 * this key before we free/remove it.
+	 */
+	synchronize_rcu();
+
 	if (key->local)
 		ieee80211_key_disable_hw_accel(key);
 


