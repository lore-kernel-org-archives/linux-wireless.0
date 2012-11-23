Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54296 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202Ab2KWXTI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2012 18:19:08 -0500
Message-ID: <1353712774.5908.15.camel@jlt4.sipsolutions.net> (sfid-20121124_001923_938111_E322397C)
Subject: Re: Badness at net/mac80211/offchannel.c:264
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Liao <Felix.Liao@watchguard.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ocean Su <Ocean.Su@watchguard.com>,
	Joe Qiao <Joe.Qiao@watchguard.com>,
	Bryan Phillippe <Bryan.Phillippe@watchguard.com>
Date: Sat, 24 Nov 2012 00:19:34 +0100
In-Reply-To: <1AA9BD91549CF94C901B05C32D2B081101E00C99@ES02Ch.wgti.net> (sfid-20121123_113037_122856_FE2675E8)
References: <1AA9BD91549CF94C901B05C32D2B081101E00C99@ES02Ch.wgti.net>
	 (sfid-20121123_113037_122856_FE2675E8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Felix,

Thanks for the report and the detailed description and analysis.

> hostapd->ieee80211_start_roc_work[2146] local->roc_list: <empty>
> hostapd->ieee80211_start_roc_work[2300] local->roc_list: <1>
>     roc d90e7480 started 0 abrt 0 hw_beg 0 notified 0 hw_start 0 dur 60(60)
> phy0->ieee80211_sw_roc_work[333] local->roc_list: <1>
>     roc d90e7480 started 0 abrt 0 hw_beg 0 notified 0 hw_start 0 dur 60(60)
> phy0->ieee80211_sw_roc_work[392] local->roc_list: <1>
>     roc d90e7480 started 1 abrt 0 hw_beg 0 notified 1 hw_start 0 dur 60(60)
> hostapd->ieee80211_roc_purge[465] local->roc_list: <1>
>     roc d90e7480 started 1 abrt 0 hw_beg 0 notified 1 hw_start 0 dur 60(60)
> hostapd->ieee80211_start_next_roc[264] roc d90e7480 cause call trace!
> hostapd->ieee80211_roc_purge[480] local->roc_list: <1>
>     roc d90e7480 started 1 abrt 0 hw_beg 0 notified 1 hw_start 0 dur 60(60)

I think it would have been instrumental here to print out the different
interfaces. It seems to me that the roc_purge() is called for a
different interface, and doesn't actually remove any ROC work item at
all.

> I suspect the root cause of this issue is after ieee80211_sw_roc_work
> set roc->start to true and queue it again, the hostapd just call
> linux_set_iface_flags right now.

Yes and no, hostapd is changing an interface to be down, but it would
appear to be some other interface, not the one that's executing the ROC.

>   I just increase the delay time to magnify the probability of this
> issue, then it is more easier to reproduce this issue. 

Makes sense.

> So I think we should schedule the work as soon as possible, and should
> set the delay time to zero, that is,

> @@ -367,7 +367,7 @@ void ieee80211_sw_roc_work(struct work_struct *work)
>  
>                 roc->started = true;
> -               ieee80211_queue_delayed_work(&local->hw, &roc->work,
> -                                            msecs_to_jiffies(roc->duration));
> +               ieee80211_queue_delayed_work(&local->hw, &roc->work, 0);

definitely not, no, this would defeat the purpose of the ROC, to stay on
the given channel for the given time -- now you've cut the time to zero
which isn't what we want at all.

> At last, to be save I think we should use a static tmp_list or a
> global tmp_list to save the abort roc in ieee80211_roc_purge.

No, that totally doesn't seem right, a static list here would completely
break if the function was called on two CPUs at the same time (this
can't happen right now, but still)


> I had test this patch using the same testcase above 10 times, it runs
> very well and never dump the warning calltrace,

I can believe that, but it totally defeats the purpose of the ACS patch
you're using :-)

I think the root cause of the issue is that in ieee80211_roc_purge() we
unconditionally call ieee80211_start_next_roc(), even if nothing was
removed.

So I think what happens overall is this:

* roc is added on, e.g., wlan0
* roc starts running (roc->started becomes true)
* hostapd decides to turn off some other interface (say moni.wlan0?)
* therefore, ieee80211_roc_purge() is called _for that other interface_
* the loop in ieee80211_roc_purge() does nothing since there's no roc
  for the other interface and the original roc stays at the front of the
  list
* we call ieee80211_start_next_roc() and it (correctly) warns

So the first thing that comes to mind is that we must not call
ieee80211_start_next_roc() when there was no ROC item removed from the
list. However, it turns out we can completely remove the call, since the
second loop (over the tmp_list) will actually clear all the ROC items,
and run ieee80211_sw_roc_work() for each item. If the ROC was started,
then this function will call ieee80211_start_next_roc().

So this simple patch should fix your issue:

diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 635c325..2138dc3 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -453,8 +453,6 @@ void ieee80211_roc_purge(struct ieee80211_sub_if_data *sdata)
 		list_move_tail(&roc->list, &tmp_list);
 		roc->abort = true;
 	}
-
-	ieee80211_start_next_roc(local);
 	mutex_unlock(&local->mtx);
 
 	list_for_each_entry_safe(roc, tmp, &tmp_list, list) {


Please let me know if it doesn't, that would mean my analysis is
completely wrong.

johannes

