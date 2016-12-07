Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33508 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751254AbcLGGoX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 01:44:23 -0500
Message-ID: <1481093061.4092.17.camel@sipsolutions.net> (sfid-20161207_074425_616101_F6F8909E)
Subject: Re: [PATCH] RFC: Universal scan proposal
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Shmidt <dimitrysh@google.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 07 Dec 2016 07:44:21 +0100
In-Reply-To: <CAH7ZN-wcvoJLTr_zYMwpbjuvMBGwmNhuVYx-MuNU1pOPTf9HEA@mail.gmail.com> (sfid-20161205_193240_598287_71B9DE73)
References: <94eb2c110db85c2379054172dad0@google.com>
         <1480948100.31788.15.camel@sipsolutions.net>
         <CAH7ZN-wcvoJLTr_zYMwpbjuvMBGwmNhuVYx-MuNU1pOPTf9HEA@mail.gmail.com>
         (sfid-20161205_193240_598287_71B9DE73)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Indeed, results are results. I just want to take care of two things:
> 1) Memory consumption - we can clear stale scan results for
> connection, but not for location if we are using history scan.

Well eventually we also have to clear for location if we run out of
memory, that usually means dumping them out to the host, no?

> 2) Use of insufficient results for connection - in case we had
> history or hotlist scan only for very limited amount of channels,
> then we may not have enough APs in our result for "sterling"
> connection decision.

I'm not entirely sure about this case - surely noticing "we can do
better now" is still better than waiting for being able to make the
perfect decision?

> > > Report: none / batch / immediate
> > 
> > Not sure I see much point in "none"??
> > 
> > Can you define these more clearly? Do you think "batch" reporting
> > should be like the gscan buckets? Or actually have full
> > information?
> 
> None - means that there is not need to report. It can be useful
> in case of roaming scan, scheduling or hotlist scan - you didn't find
> anything suitable - don't report that there is no scan results.

But that seems more of a filtering thing, combined with "immediate" for
anything passing the filter?

> > >    Request may have priority and can be inserted into
> > > the head of the queue.
> > >    Types of scans:
> > > - Normal scan
> > > - Scheduled scan
> > > - Hotlist (BSSID scan)
> > > - Roaming
> > > - AutoJoin
> > 
> > I think somebody else said this but I didn't find it now - I think
> > this would make more sense to define in terms of expected behaviour
> > than use cases for each type of scan.
> 
> I think Luca made this statement. 

Yeah - I just couldn't find it again on re-reading the thread :)

> It is totally ok from SW point of
> view - especially due to the fact that scan is scan. However,
> I suspect it will be harder to handle from user experience. I mean
> at the end wireless framework / driver / FW will convert special
> scan type to usual scan with special params and response, but why
> to put this burden on user?

I just think it's more flexible and open-ended. The actual definition
of the resulting parameters needs to be somewhere anyway - putting it
into driver/firmware (vs. wifi framework or so) seems to duplicate it
and certainly makes it harder to modify/extend in the future, no?

johannes
