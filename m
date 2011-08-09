Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329Ab1HIPaS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 11:30:18 -0400
Date: Tue, 9 Aug 2011 17:30:17 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: fix resuming when device is gone
Message-ID: <20110809152935.GA2302@redhat.com> (sfid-20110809_173023_596721_722B2C21)
References: <1312819106.4372.37.camel@jlt3.sipsolutions.net>
 <20110809092314.GA2152@redhat.com>
 <1312882082.4109.2.camel@jlt3.sipsolutions.net>
 <20110809093909.GB2152@redhat.com>
 <1312883113.4109.5.camel@jlt3.sipsolutions.net>
 <20110809113620.GA2488@redhat.com>
 <1312890237.4109.22.camel@jlt3.sipsolutions.net>
 <1312890325.4109.23.camel@jlt3.sipsolutions.net>
 <1312890402.4109.24.camel@jlt3.sipsolutions.net>
 <1312890463.4109.25.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1312890463.4109.25.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 09, 2011 at 01:47:43PM +0200, Johannes Berg wrote:
> On Tue, 2011-08-09 at 13:46 +0200, Johannes Berg wrote:
> > On Tue, 2011-08-09 at 13:45 +0200, Johannes Berg wrote:
> > > On Tue, 2011-08-09 at 13:43 +0200, Johannes Berg wrote:
> > > 
> > > > > Yes, but __ieee80211_resume() calls directly ieee80211_reconfig().
> > > > 
> > > > Sure. Just trying to make sure I understand where it's coming from. So
> > > > wiphy_unregister() is still running, before device_del(), but then we
> > > > get the resume from the core...
> > > > 
> > > > Shouldn't we implement this logic you just did in cfg80211 instead?
> > > 
> > > Although I guess until wiphy_unregister() returns, drivers must still
> > > expect callbacks, which clearly mac80211 didn't handle correctly here
> > > with the timer...
> > 
> > Actually...
> > 
> > Doesn't that just mean we need to reorder the code in _free_hw()?
> 
> I mean ieee80211_unregister_hw().
> 
> >  If we
> > do the timer stuff after wiphy_unregister(), we should be OK, and
> > prevent other, similar problems in the future too.

There are some debugfs dependencies, so moving wiphy_unregister() before
del_timer_sync(&local->work_timer); in ieee80211_unregister_hw() gave me
a crash. I moved sta_info_stop(local); after
wiphy_unregister(local->hw.wiphy); but this alone do not solve the
problem, ->resume callback can be called after wiphy_unregister().
Below patch fixes the problem (it also protect ->suspend, in case device
gone during suspend process):

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 866f269..acb4423 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1012,7 +1012,6 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 	cancel_work_sync(&local->reconfig_filter);
 
 	ieee80211_clear_tx_pending(local);
-	sta_info_stop(local);
 	rate_control_deinitialize(local);
 
 	if (skb_queue_len(&local->skb_queue) ||
@@ -1024,6 +1023,7 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 
 	destroy_workqueue(local->workqueue);
 	wiphy_unregister(local->hw.wiphy);
+	sta_info_stop(local);
 	ieee80211_wep_free(local);
 	ieee80211_led_exit(local);
 	kfree(local->int_scan_req);
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 645437c..453fcc6 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -616,6 +616,9 @@ int wiphy_register(struct wiphy *wiphy)
 	if (res)
 		goto out_rm_dev;
 
+	rtnl_lock();
+	rdev->wiphy.registered = true;
+	rtnl_unlock();
 	return 0;
 
 out_rm_dev:
@@ -647,6 +650,10 @@ void wiphy_unregister(struct wiphy *wiphy)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 
+	rtnl_lock();
+	rdev->wiphy.registered = false;
+	rtnl_unlock();
+
 	rfkill_unregister(rdev->rfkill);
 
 	/* protect the device list */
@@ -690,6 +697,7 @@ void wiphy_unregister(struct wiphy *wiphy)
 	reg_device_remove(wiphy);
 
 	cfg80211_rdev_list_generation++;
+	rdev->wiphy.registered = false;
 	device_del(&rdev->wiphy.dev);
 
 	mutex_unlock(&cfg80211_mutex);
diff --git a/net/wireless/sysfs.c b/net/wireless/sysfs.c
index c6e4ca6..107516b 100644
--- a/net/wireless/sysfs.c
+++ b/net/wireless/sysfs.c
@@ -93,7 +93,10 @@ static int wiphy_suspend(struct device *dev, pm_message_t state)
 
 	if (rdev->ops->suspend) {
 		rtnl_lock();
-		ret = rdev->ops->suspend(&rdev->wiphy, rdev->wowlan);
+		if (rdev->wiphy.registered)
+			ret = rdev->ops->suspend(&rdev->wiphy, rdev->wowlan);
+		else
+			ret = -ENODEV;
 		rtnl_unlock();
 	}
 
@@ -112,7 +115,10 @@ static int wiphy_resume(struct device *dev)
 
 	if (rdev->ops->resume) {
 		rtnl_lock();
-		ret = rdev->ops->resume(&rdev->wiphy);
+		if (rdev->wiphy.registered)
+			ret = rdev->ops->resume(&rdev->wiphy);
+		else
+			ret = -ENODEV;
 		rtnl_unlock();
 	}
 



