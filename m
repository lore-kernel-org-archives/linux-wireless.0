Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:45280
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757526AbXHGKEG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2007 06:04:06 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Greg KH <greg@kroah.com>
Subject: [PATCH] softmac: Fix deadlock of wx_set_essid with assoc work
Date: Tue, 7 Aug 2007 12:02:58 +0200
Cc: stable@kernel.org, "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	David Woodhouse <dwmw2@infradead.org>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200708071202.58452.mb@bu3sch.de>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The essid wireless extension does deadlock against the assoc mutex,
as we don't unlock the assoc mutex.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

--

This is included in John's wireless-2.6 tree.

This doesn't fix the whole issue completely, as we shouldn't
flush the workqueue while we are holding the rtnl lock.
But, it turns this bug from a "will 100% always deadlock" into
a "it might deadlock" bug.
A followup patch will come (if someone has some time to do so)
to fix this crap code completely.

Index: bu3sch-wireless-dev/net/ieee80211/softmac/ieee80211softmac_wx.c
===================================================================
--- bu3sch-wireless-dev.orig/net/ieee80211/softmac/ieee80211softmac_wx.c	2007-03-05 18:42:18.000000000 +0100
+++ bu3sch-wireless-dev/net/ieee80211/softmac/ieee80211softmac_wx.c	2007-07-31 14:51:46.000000000 +0200
@@ -98,9 +98,12 @@ ieee80211softmac_wx_set_essid(struct net
 				cancel_delayed_work(&authptr->work);
 			sm->associnfo.bssvalid = 0;
 			sm->associnfo.bssfixed = 0;
-			flush_scheduled_work();
 			sm->associnfo.associating = 0;
 			sm->associnfo.associated = 0;
+			/* Unlock mutex, otherwise we deadlock with the assoc work handler. */
+			mutex_unlock(&sm->associnfo.mutex);
+			flush_scheduled_work();
+			mutex_lock(&sm->associnfo.mutex);
 		}
 	}
 


-- 
Greetings Michael.
