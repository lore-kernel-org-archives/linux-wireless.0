Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50086 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934724AbdAENqH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jan 2017 08:46:07 -0500
Message-ID: <1483623882.4394.20.camel@sipsolutions.net> (sfid-20170105_144611_242781_0D24AB73)
Subject: Re: [PATCH] RFC: Universal scan proposal
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Dmitry Shmidt <dimitrysh@google.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 05 Jan 2017 14:44:42 +0100
In-Reply-To: <cd31be64-579a-a702-c642-b80690aac5b2@broadcom.com> (sfid-20170105_143917_672465_FE638C05)
References: <94eb2c110db85c2379054172dad0@google.com>
         <1480948100.31788.15.camel@sipsolutions.net>
         <CAH7ZN-wcvoJLTr_zYMwpbjuvMBGwmNhuVYx-MuNU1pOPTf9HEA@mail.gmail.com>
         <1481093061.4092.17.camel@sipsolutions.net>
         <CAH7ZN-wP+9AGrXFUS4RY65-RyfP-J46svBvLdytP2c=QPtiaug@mail.gmail.com>
         <93d4475c-58bd-d497-3347-a988d551f374@broadcom.com>
         <CAH7ZN-wGseBVzV3Vuq+6=kgaSL7e0UnndGXPdu4PQKZw8H47YQ@mail.gmail.com>
         <1481645205.20412.32.camel@sipsolutions.net>
         <CAH7ZN-zm-CUv=QzoUojdyrcONRAHtTG18PiwGZ4sYY0qqft1BA@mail.gmail.com>
         <1483536510.7312.5.camel@sipsolutions.net>
         <CAH7ZN-zenL8SsqUAzMH5-Hb1RmUDDwgqqUKWEbPX=qaPV7e3TA@mail.gmail.com>
         <1483616763.4394.8.camel@sipsolutions.net>
         <cd31be64-579a-a702-c642-b80690aac5b2@broadcom.com>
         (sfid-20170105_143917_672465_FE638C05)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-01-05 at 14:39 +0100, Arend Van Spriel wrote:

> Today we already have roaming offload, right? 

I guess - you defined the BSS selection stuff for it :)

> Roaming scan would indeed
> be the same if roaming offload is not used unless you would want
> cfg80211 to make the decision, but then I would expect parameters for
> making that decision in the request. Same/similar for autojoin.

Right.

> > Actually I think I'm just misinterpreting your wording - you mean
> > that we can use the different final actions for the different scan
> > types, not that we should actually say - in driver/firmware/... -
> > "this is a history scan because the action is to report buffer
> > full", right?
> 
> Do we care? The scan engine in our firmware does have use a scan type
> concept, but that is hidden by the firmware api. I guess your point
> would be that if user-space would prefer scan types and
> driver/firmware uses that as well, we might do the same in
> cfg80211/mac80211. How can we assure the scan types we come up with
> match those employed in any and all wireless devices/firmwares.

To be clear: I *don't* like having scan types in the APIs. I think it
muddies the waters and makes it less likely people will implement it
precisely as requested, because they'll argue "this is only for roam,
we'll implement our own magic there" etc.

> As Johannes points out it needs to be clear to user-space what its
> next step should be in obtaining results. Does it make sense to have
> a separate notification for the history scan results (not calling it
> that of course :-p ) triggered by the action "Report when buffer is
> full / almost full" or should user-space determine what to do based
> on request id that would be included in the (scheduled) scan results
> notification.

Yeah, that's a good question - based on the current behaviours etc. I
was assuming it'd be a new notification/result type.

> > There's a bit more complication wrt. the level of detail in results
> > though - sometimes the result may include all IEs (normal/sched
> > scan),
> > sometimes it may not ("history scan") - are we sure we really only
> > need
> > one new get_scan_results()?
> 
> So could the "all IEs" case not be handled by the existing BSS
> storage? Is it still our intention to handle normal scan (no interval
> provided?) as well in the universal scan approach.

Yes, the "all IEs" (essentially "all information") case is handled by
the existing storage/dump methods/etc. but obviously the other cases
can't be - so my question was if there's really only one more other
case, or if we might have more new cases - or something that's flexible
wrt. the data we get?

johannes
