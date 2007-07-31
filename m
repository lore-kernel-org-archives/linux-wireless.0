Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:47789
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932907AbXGaSnR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 14:43:17 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH final] softmac: Fix deadlock of wx_set_essid with assoc work
Date: Tue, 31 Jul 2007 20:41:04 +0200
Cc: David Woodhouse <dwmw2@infradead.org>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200707312041.04987.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The essid wireless extension does deadlock against the assoc mutex,
as we don't unlock the assoc mutex when flushing the workqueue, which
also holds the lock.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

--

David, please stresstest this.
John, please apply this, if David reports success from his tests.
John, please notify me when you applied this, so I can immediately
send it to -stable.

Index: bu3sch-wireless-dev/net/ieee80211/softmac/ieee80211softmac_wx.c
===================================================================
--- bu3sch-wireless-dev.orig/net/ieee80211/softmac/ieee80211softmac_wx.c	2007-07-14 18:18:06.000000000 +0200
+++ bu3sch-wireless-dev/net/ieee80211/softmac/ieee80211softmac_wx.c	2007-07-31 20:30:08.000000000 +0200
@@ -74,8 +74,8 @@ ieee80211softmac_wx_set_essid(struct net
 	struct ieee80211softmac_auth_queue_item *authptr;
 	int length = 0;
 
+check_assoc_again:
 	mutex_lock(&sm->associnfo.mutex);
-
 	/* Check if we're already associating to this or another network
 	 * If it's another network, cancel and start over with our new network
 	 * If it's our network, ignore the change, we're already doing it!
@@ -98,13 +98,18 @@ ieee80211softmac_wx_set_essid(struct net
 				cancel_delayed_work(&authptr->work);
 			sm->associnfo.bssvalid = 0;
 			sm->associnfo.bssfixed = 0;
-			flush_scheduled_work();
 			sm->associnfo.associating = 0;
 			sm->associnfo.associated = 0;
+			/* We must unlock to avoid deadlocks with the assoc workqueue
+			 * on the associnfo.mutex */
+			mutex_unlock(&sm->associnfo.mutex);
+			flush_scheduled_work();
+			/* Avoid race! Check assoc status again. Maybe someone started an
+			 * association while we flushed. */
+			goto check_assoc_again;
 		}
 	}
 
-
 	sm->associnfo.static_essid = 0;
 	sm->associnfo.assoc_wait = 0;
 
