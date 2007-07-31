Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:48577
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758061AbXGaM57 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 08:57:59 -0400
From: Michael Buesch <mb@bu3sch.de>
To: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] softmac: Fix deadlock of wx_set_essid with assoc work
Date: Tue, 31 Jul 2007 14:57:33 +0200
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200707311457.33723.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The essid wireless extension does deadlock against the assoc mutex,
as we don't unlock the assoc mutex.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

--

David, please test if this fixes your deadlock.

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
