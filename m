Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757680Ab3CHOZr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Mar 2013 09:25:47 -0500
Date: Fri, 8 Mar 2013 15:26:08 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: Re: [PATCH 2/6] mac80211: sync suspend and stop interface
Message-ID: <20130308142607.GA3842@redhat.com> (sfid-20130308_152551_442760_A936B616)
References: <1361793008-2857-1-git-send-email-sgruszka@redhat.com>
 <1361793008-2857-2-git-send-email-sgruszka@redhat.com>
 <1361911440.8440.12.camel@jlt4.sipsolutions.net>
 <20130227145410.GA8202@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130227145410.GA8202@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 27, 2013 at 03:54:10PM +0100, Stanislaw Gruszka wrote:
> On Tue, Feb 26, 2013 at 09:44:00PM +0100, Johannes Berg wrote:
> > More generally, does this really make much sense? There are other things
> > here, e.g. ieee80211_configure_filter(), ieee80211_recalc_ps(),
> > ieee80211_hw_config() and probably more that can be executed in this
> > function -- I don't think protecting these two calls is really
> > sufficient?
> > 
> > I think it'd be smarter to delay the down until resumed, or so.
> 
> I'm thinking how to do this nicely. For now I'll skip this change
> from my patch set.

Unfortunately delay down after resume approach has problem, if driver
was removed during suspend, ieee8011_do_stop will never happen and we
leak resources.

I changed patch to do more calls conditionally if down during suspend,
some work is still needed. For example I don't know how handle roc, 
add_virtual_monitor and channel context stuff.

Anyway I hope we could apply something like below, so some warnings
we have reported will get fix.

Stanislaw

---
 net/mac80211/iface.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index dfe9cb9..7a0d9ce 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -419,7 +419,8 @@ static void ieee80211_del_virtual_monitor(struct ieee80211_local *local)
 
 	ieee80211_vif_release_channel(sdata);
 
-	drv_remove_interface(local, sdata);
+	if (!local->suspended)
+		drv_remove_interface(local, sdata);
 
 	kfree(sdata);
  out_unlock:
@@ -744,8 +745,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 				 sdata->dev->addr_len);
 		spin_unlock_bh(&local->filter_lock);
 		netif_addr_unlock_bh(sdata->dev);
-
-		ieee80211_configure_filter(local);
+		/* configure filter latter (if not suspended) */
 	}
 
 	del_timer_sync(&local->dynamic_ps_timer);
@@ -810,10 +810,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		}
 
 		ieee80211_adjust_monitor_flags(sdata, -1);
-		ieee80211_configure_filter(local);
-		mutex_lock(&local->mtx);
-		ieee80211_recalc_idle(local);
-		mutex_unlock(&local->mtx);
+		/* tell driver latter (if not suspended) */
 		break;
 	case NL80211_IFTYPE_P2P_DEVICE:
 		/* relies on synchronize_rcu() below */
@@ -844,26 +841,29 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	case NL80211_IFTYPE_AP:
 		skb_queue_purge(&sdata->skb_queue);
 
-		if (going_down)
+		if (going_down && !local->suspended)
 			drv_remove_interface(local, sdata);
 	}
 
 	sdata->bss = NULL;
 
-	ieee80211_recalc_ps(local, -1);
+	if (!local->suspended) {
+		if (local->open_count == 0) {
+			ieee80211_clear_tx_pending(local);
+			ieee80211_stop_device(local);
+		} else {
+			ieee80211_configure_filter(local);
+			ieee80211_recalc_ps(local, -1);
 
-	if (local->open_count == 0) {
-		ieee80211_clear_tx_pending(local);
-		ieee80211_stop_device(local);
+			mutex_lock(&local->mtx);
+			ieee80211_recalc_idle(local);
+			mutex_unlock(&local->mtx);
 
-		/* no reconfiguring after stop! */
-		hw_reconf_flags = 0;
+			if (hw_reconf_flags)
+				ieee80211_hw_config(local, hw_reconf_flags);
+		}
 	}
 
-	/* do after stop to avoid reconfiguring when we stop anyway */
-	if (hw_reconf_flags)
-		ieee80211_hw_config(local, hw_reconf_flags);
-
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 	for (i = 0; i < IEEE80211_MAX_QUEUES; i++) {
 		skb_queue_walk_safe(&local->pending[i], skb, tmp) {
-- 
1.7.11.7



