Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-01.rdc-kc.rr.com ([24.94.166.115]:34173 "EHLO
	ms-smtp-01.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbXISDBX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2007 23:01:23 -0400
Date: Tue, 18 Sep 2007 22:00:52 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] softmac: Fix inability to associate with WEP networks,  and the inability to change essid
Message-ID: <46f090e4.wi04CrQ11sG6gLcC%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 4cf92a3c was submitted as a fix for bug #8686 at bugzilla.kernel.org
(http://bugzilla.kernel.org/show_bug.cgi?id=8686). Unfortunately, the fix led to
a new bug, reported by Yoshifuji Hideaki, that prevented association for WEP
encrypted networks that use ifconfig to control the device. This patch effectively
reverts the earlier commit and does a proper fix for bug #8686.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This fix replaces my earlier request for reversion of commit 4cf92a3c. As stated
above, it effectively does the reversion, but it also fixes the original bug.

Larry
---

 net/ieee80211/softmac/ieee80211softmac_assoc.c |    2
 net/ieee80211/softmac/ieee80211softmac_wx.c    |   54 +++++++++----------------
 2 files changed, 20 insertions(+), 36 deletions(-)

Index: linux-2.6/net/ieee80211/softmac/ieee80211softmac_assoc.c
===================================================================
--- linux-2.6.orig/net/ieee80211/softmac/ieee80211softmac_assoc.c
+++ linux-2.6/net/ieee80211/softmac/ieee80211softmac_assoc.c
@@ -273,8 +273,6 @@ ieee80211softmac_assoc_work(struct work_
 			ieee80211softmac_notify(mac->dev, IEEE80211SOFTMAC_EVENT_SCAN_FINISHED, ieee80211softmac_assoc_notify_scan, NULL);
 			if (ieee80211softmac_start_scan(mac)) {
 				dprintk(KERN_INFO PFX "Associate: failed to initiate scan. Is device up?\n");
-				mac->associnfo.associating = 0;
-				mac->associnfo.associated = 0;
 			}
 			goto out;
 		} else {
Index: linux-2.6/net/ieee80211/softmac/ieee80211softmac_wx.c
===================================================================
--- linux-2.6.orig/net/ieee80211/softmac/ieee80211softmac_wx.c
+++ linux-2.6/net/ieee80211/softmac/ieee80211softmac_wx.c
@@ -70,44 +70,30 @@ ieee80211softmac_wx_set_essid(struct net
 			      char *extra)
 {
 	struct ieee80211softmac_device *sm = ieee80211_priv(net_dev);
-	struct ieee80211softmac_network *n;
 	struct ieee80211softmac_auth_queue_item *authptr;
 	int length = 0;
 
 check_assoc_again:
 	mutex_lock(&sm->associnfo.mutex);
-	/* Check if we're already associating to this or another network
-	 * If it's another network, cancel and start over with our new network
-	 * If it's our network, ignore the change, we're already doing it!
-	 */
 	if((sm->associnfo.associating || sm->associnfo.associated) &&
 	   (data->essid.flags && data->essid.length)) {
-		/* Get the associating network */
-		n = ieee80211softmac_get_network_by_bssid(sm, sm->associnfo.bssid);
-		if(n && n->essid.len == data->essid.length &&
-		   !memcmp(n->essid.data, extra, n->essid.len)) {
-			dprintk(KERN_INFO PFX "Already associating or associated to "MAC_FMT"\n",
-				MAC_ARG(sm->associnfo.bssid));
-			goto out;
-		} else {
-			dprintk(KERN_INFO PFX "Canceling existing associate request!\n");
-			/* Cancel assoc work */
-			cancel_delayed_work(&sm->associnfo.work);
-			/* We don't have to do this, but it's a little cleaner */
-			list_for_each_entry(authptr, &sm->auth_queue, list)
-				cancel_delayed_work(&authptr->work);
-			sm->associnfo.bssvalid = 0;
-			sm->associnfo.bssfixed = 0;
-			sm->associnfo.associating = 0;
-			sm->associnfo.associated = 0;
-			/* We must unlock to avoid deadlocks with the assoc workqueue
-			 * on the associnfo.mutex */
-			mutex_unlock(&sm->associnfo.mutex);
-			flush_scheduled_work();
-			/* Avoid race! Check assoc status again. Maybe someone started an
-			 * association while we flushed. */
-			goto check_assoc_again;
-		}
+		dprintk(KERN_INFO PFX "Canceling existing associate request!\n");
+		/* Cancel assoc work */
+		cancel_delayed_work(&sm->associnfo.work);
+		/* We don't have to do this, but it's a little cleaner */
+		list_for_each_entry(authptr, &sm->auth_queue, list)
+			cancel_delayed_work(&authptr->work);
+		sm->associnfo.bssvalid = 0;
+		sm->associnfo.bssfixed = 0;
+		sm->associnfo.associating = 0;
+		sm->associnfo.associated = 0;
+		/* We must unlock to avoid deadlocks with the assoc workqueue
+		 * on the associnfo.mutex */
+		mutex_unlock(&sm->associnfo.mutex);
+		flush_scheduled_work();
+		/* Avoid race! Check assoc status again. Maybe someone started an
+		 * association while we flushed. */
+		goto check_assoc_again;
 	}
 
 	sm->associnfo.static_essid = 0;
@@ -153,13 +139,13 @@ ieee80211softmac_wx_get_essid(struct net
 		data->essid.length = sm->associnfo.req_essid.len;
 		data->essid.flags = 1;  /* active */
 		memcpy(extra, sm->associnfo.req_essid.data, sm->associnfo.req_essid.len);
-	}
-
+		dprintk(KERN_INFO PFX "Getting essid from req_essid\n");
+	} else if (sm->associnfo.associated || sm->associnfo.associating) {
 	/* If we're associating/associated, return that */
-	if (sm->associnfo.associated || sm->associnfo.associating) {
 		data->essid.length = sm->associnfo.associate_essid.len;
 		data->essid.flags = 1;  /* active */
 		memcpy(extra, sm->associnfo.associate_essid.data, sm->associnfo.associate_essid.len);
+		dprintk(KERN_INFO PFX "Getting essid from associate_essid\n");
 	}
 	mutex_unlock(&sm->associnfo.mutex);
 
