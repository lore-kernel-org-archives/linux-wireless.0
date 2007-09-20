Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59955 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbXITNu0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 09:50:26 -0400
Subject: [PATCH] fix softmac lockdep reports
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Daniel Drake <dsd@gentoo.org>
Content-Type: text/plain
Date: Thu, 20 Sep 2007 14:27:17 +0200
Message-Id: <1190291237.18521.40.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It seems I was actually able to hit this deadlock, on my quad G5 softmac
locks up more often than not. This fixes it by using an own workqueue
that can safely be flushed under RTNL.

Not sure if the patch is correct with the workqueue naming. And don't
think with the patch it doesn't continually lock up. It still does, just
doesn't invoke lockdep warnings all the time.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/net/ieee80211softmac.h                  |    2 ++
 net/ieee80211/softmac/ieee80211softmac_assoc.c  |    8 ++++----
 net/ieee80211/softmac/ieee80211softmac_auth.c   |    8 ++++----
 net/ieee80211/softmac/ieee80211softmac_event.c  |    2 +-
 net/ieee80211/softmac/ieee80211softmac_module.c |   10 ++++++++--
 net/ieee80211/softmac/ieee80211softmac_scan.c   |    4 ++--
 net/ieee80211/softmac/ieee80211softmac_wx.c     |    8 ++++----
 7 files changed, 25 insertions(+), 17 deletions(-)

--- wireless-dev.orig/include/net/ieee80211softmac.h	2007-08-29 21:08:28.892054940 +0200
+++ wireless-dev/include/net/ieee80211softmac.h	2007-09-20 14:14:48.041572701 +0200
@@ -229,6 +229,8 @@ struct ieee80211softmac_device {
 	/* this lock protects this structure */
 	spinlock_t lock;
 
+	struct workqueue_struct *wq;
+
 	u8 running; /* SoftMAC started? */
 	u8 scanning;
 
--- wireless-dev.orig/net/ieee80211/softmac/ieee80211softmac_module.c	2007-08-29 21:08:46.832054940 +0200
+++ wireless-dev/net/ieee80211/softmac/ieee80211softmac_module.c	2007-09-20 14:15:48.911562664 +0200
@@ -36,8 +36,13 @@ struct net_device *alloc_ieee80211softma
 	dev = alloc_ieee80211(sizeof(*softmac) + sizeof_priv);
 	if (!dev)
 		return NULL;
-
 	softmac = ieee80211_priv(dev);
+	softmac->wq = create_freezeable_workqueue("softmac");
+	if (!softmac->wq) {
+		free_ieee80211(dev);
+		return NULL;
+	}
+
 	softmac->dev = dev;
 	softmac->ieee = netdev_priv(dev);
 	spin_lock_init(&softmac->lock);
@@ -105,7 +110,7 @@ ieee80211softmac_clear_pending_work(stru
 		cancel_delayed_work(&eventptr->work);
 
 	spin_unlock_irqrestore(&sm->lock, flags);
-	flush_scheduled_work();
+	flush_workqueue(sm->wq);
 
 	/* now we should be save and no longer need locking... */
 	spin_lock_irqsave(&sm->lock, flags);
@@ -139,6 +144,7 @@ void free_ieee80211softmac(struct net_de
 	ieee80211softmac_clear_pending_work(sm);
 	kfree(sm->scaninfo);
 	kfree(sm->wpa.IE);
+	destroy_workqueue(sm->wq);
 	free_ieee80211(dev);
 }
 EXPORT_SYMBOL_GPL(free_ieee80211softmac);
--- wireless-dev.orig/net/ieee80211/softmac/ieee80211softmac_wx.c	2007-08-29 21:08:46.862054940 +0200
+++ wireless-dev/net/ieee80211/softmac/ieee80211softmac_wx.c	2007-09-20 14:14:48.041572701 +0200
@@ -103,7 +103,7 @@ check_assoc_again:
 			/* We must unlock to avoid deadlocks with the assoc workqueue
 			 * on the associnfo.mutex */
 			mutex_unlock(&sm->associnfo.mutex);
-			flush_scheduled_work();
+			flush_workqueue(sm->wq);
 			/* Avoid race! Check assoc status again. Maybe someone started an
 			 * association while we flushed. */
 			goto check_assoc_again;
@@ -127,7 +127,7 @@ check_assoc_again:
 
 	sm->associnfo.associating = 1;
 	/* queue lower level code to do work (if necessary) */
-	schedule_delayed_work(&sm->associnfo.work, 0);
+	queue_delayed_work(sm->wq, &sm->associnfo.work, 0);
 out:
 	mutex_unlock(&sm->associnfo.mutex);
 
@@ -362,7 +362,7 @@ ieee80211softmac_wx_set_wap(struct net_d
 		/* force reassociation */
 		mac->associnfo.bssvalid = 0;
 		if (mac->associnfo.associated)
-			schedule_delayed_work(&mac->associnfo.work, 0);
+			queue_delayed_work(mac->wq, &mac->associnfo.work, 0);
 	} else if (is_zero_ether_addr(data->ap_addr.sa_data)) {
 		/* the bssid we have is no longer fixed */
 		mac->associnfo.bssfixed = 0;
@@ -379,7 +379,7 @@ ieee80211softmac_wx_set_wap(struct net_d
 		/* tell the other code that this bssid should be used no matter what */
 		mac->associnfo.bssfixed = 1;
 		/* queue associate if new bssid or (old one again and not associated) */
-		schedule_delayed_work(&mac->associnfo.work, 0);
+		queue_delayed_work(mac->wq, &mac->associnfo.work, 0);
 	}
 
  out:
--- wireless-dev.orig/net/ieee80211/softmac/ieee80211softmac_assoc.c	2007-08-29 21:08:46.802054940 +0200
+++ wireless-dev/net/ieee80211/softmac/ieee80211softmac_assoc.c	2007-09-20 14:14:48.051571725 +0200
@@ -53,7 +53,7 @@ ieee80211softmac_assoc(struct ieee80211s
 	/* Set a timer for timeout */
 	/* FIXME: make timeout configurable */
 	if (likely(mac->running))
-		schedule_delayed_work(&mac->associnfo.timeout, 5 * HZ);
+		queue_delayed_work(mac->wq, &mac->associnfo.timeout, 5 * HZ);
 	spin_unlock_irqrestore(&mac->lock, flags);
 }
 
@@ -419,7 +419,7 @@ ieee80211softmac_handle_assoc_response(s
 				network->authenticated = 0;
 				/* we don't want to do this more than once ... */
 				network->auth_desynced_once = 1;
-				schedule_delayed_work(&mac->associnfo.work, 0);
+				queue_delayed_work(mac->wq, &mac->associnfo.work, 0);
 				break;
 			}
 		default:
@@ -441,7 +441,7 @@ ieee80211softmac_try_reassoc(struct ieee
 
 	spin_lock_irqsave(&mac->lock, flags);
 	mac->associnfo.associating = 1;
-	schedule_delayed_work(&mac->associnfo.work, 0);
+	queue_delayed_work(mac->wq, &mac->associnfo.work, 0);
 	spin_unlock_irqrestore(&mac->lock, flags);
 }
 
@@ -483,7 +483,7 @@ ieee80211softmac_handle_reassoc_req(stru
 		dprintkl(KERN_INFO PFX "reassoc request from unknown network\n");
 		return 0;
 	}
-	schedule_delayed_work(&mac->associnfo.work, 0);
+	queue_delayed_work(mac->wq, &mac->associnfo.work, 0);
 
 	return 0;
 }
--- wireless-dev.orig/net/ieee80211/softmac/ieee80211softmac_auth.c	2007-08-29 21:08:46.812054940 +0200
+++ wireless-dev/net/ieee80211/softmac/ieee80211softmac_auth.c	2007-09-20 14:14:48.051571725 +0200
@@ -61,7 +61,7 @@ ieee80211softmac_auth_req(struct ieee802
 
 	/* add to list */
 	list_add_tail(&auth->list, &mac->auth_queue);
-	schedule_delayed_work(&auth->work, 0);
+	queue_delayed_work(mac->wq, &auth->work, 0);
 	spin_unlock_irqrestore(&mac->lock, flags);
 
 	return 0;
@@ -95,7 +95,7 @@ ieee80211softmac_auth_queue(struct work_
 		}
 		net->authenticated = 0;
 		/* add a timeout call so we eventually give up waiting for an auth reply */
-		schedule_delayed_work(&auth->work, IEEE80211SOFTMAC_AUTH_TIMEOUT);
+		queue_delayed_work(mac->wq, &auth->work, IEEE80211SOFTMAC_AUTH_TIMEOUT);
 		auth->retry--;
 		spin_unlock_irqrestore(&mac->lock, flags);
 		if (ieee80211softmac_send_mgt_frame(mac, auth->net, IEEE80211_STYPE_AUTH, auth->state))
@@ -238,7 +238,7 @@ ieee80211softmac_auth_resp(struct net_de
 			 * request. */
 			cancel_delayed_work(&aq->work);
 			INIT_DELAYED_WORK(&aq->work, &ieee80211softmac_auth_challenge_response);
-			schedule_delayed_work(&aq->work, 0);
+			queue_delayed_work(mac->wq, &aq->work, 0);
 			spin_unlock_irqrestore(&mac->lock, flags);
 			return 0;
 		case IEEE80211SOFTMAC_AUTH_SHARED_PASS:
@@ -403,6 +403,6 @@ ieee80211softmac_deauth_resp(struct net_
 	ieee80211softmac_deauth_from_net(mac, net);
 
 	/* let's try to re-associate */
-	schedule_delayed_work(&mac->associnfo.work, 0);
+	queue_delayed_work(mac->wq, &mac->associnfo.work, 0);
 	return 0;
 }
--- wireless-dev.orig/net/ieee80211/softmac/ieee80211softmac_event.c	2007-08-29 21:08:46.812054940 +0200
+++ wireless-dev/net/ieee80211/softmac/ieee80211softmac_event.c	2007-09-20 14:14:48.081563858 +0200
@@ -172,7 +172,7 @@ ieee80211softmac_call_events_locked(stru
 				/* User may have subscribed to ANY event, so
 				 * we tell them which event triggered it. */
 				eventptr->event_type = event;
-				schedule_delayed_work(&eventptr->work, 0);
+				queue_delayed_work(mac->wq, &eventptr->work, 0);
 			}
 		}
 }
--- wireless-dev.orig/net/ieee80211/softmac/ieee80211softmac_scan.c	2007-08-29 21:08:46.842054940 +0200
+++ wireless-dev/net/ieee80211/softmac/ieee80211softmac_scan.c	2007-09-20 14:14:48.081563858 +0200
@@ -123,7 +123,7 @@ void ieee80211softmac_scan(struct work_s
 				spin_unlock_irqrestore(&sm->lock, flags);
 				break;
 			}
-			schedule_delayed_work(&si->softmac_scan, IEEE80211SOFTMAC_PROBE_DELAY);
+			queue_delayed_work(sm->wq, &si->softmac_scan, IEEE80211SOFTMAC_PROBE_DELAY);
 			spin_unlock_irqrestore(&sm->lock, flags);
 			return;
 		} else {
@@ -190,7 +190,7 @@ int ieee80211softmac_start_scan_implemen
 	sm->scaninfo->started = 1;
 	sm->scaninfo->stop = 0;
 	INIT_COMPLETION(sm->scaninfo->finished);
-	schedule_delayed_work(&sm->scaninfo->softmac_scan, 0);
+	queue_delayed_work(sm->wq, &sm->scaninfo->softmac_scan, 0);
 	spin_unlock_irqrestore(&sm->lock, flags);
 	return 0;
 }


