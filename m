Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:51383
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349AbXFAJa1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2007 05:30:27 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH] mac80211: Update stop_queues kdoc
Date: Fri, 1 Jun 2007 11:29:12 +0200
Cc: Jiri Benc <jbenc@suse.cz>, John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200706011129.12432.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This updates stop_queue(s) kdoc as currently there's
a undocumented dependency.

Stopping the queue from anywhere else than the ops->tx()
callback will result in a hard to debug deadlock and
system freeze (on UP).

Here's an example stacktrace that has been captured only
by special debugging patches to the PPC-decrementer to
detect this machine freeze.
http://bu3sch.de/misc/freeze1.jpg
http://bu3sch.de/misc/freeze2.jpg

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: mac80211/include/net/mac80211.h
===================================================================
--- mac80211.orig/include/net/mac80211.h	2007-06-01 11:20:32.000000000 +0200
+++ mac80211/include/net/mac80211.h	2007-06-01 11:23:02.000000000 +0200
@@ -967,6 +967,10 @@ void ieee80211_wake_queue(struct ieee802
  * @queue: queue number (counted from zero).
  *
  * Drivers should use this function instead of netif_stop_queue.
+ *
+ * It's currently only safe to call this function from the
+ * ops->tx() callback. Calls from elsewhere will result in
+ * hard to debug deadlocks (freezes the system on UP).
  */
 void ieee80211_stop_queue(struct ieee80211_hw *hw, int queue);
 
@@ -983,6 +987,10 @@ void ieee80211_start_queues(struct ieee8
  * @hw: pointer as obtained from ieee80211_alloc_hw().
  *
  * Drivers should use this function instead of netif_stop_queue.
+ *
+ * It's currently only safe to call this function from the
+ * ops->tx() callback. Calls from elsewhere will result in
+ * hard to debug deadlocks (freezes the system on UP).
  */
 void ieee80211_stop_queues(struct ieee80211_hw *hw);
 


--

I'd still prefer someone fixes the issue. I don't understand
the code well enough to fix it.


-- 
Greetings Michael.
