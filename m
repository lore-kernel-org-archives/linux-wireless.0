Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53673 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205Ab2LMSte (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 13:49:34 -0500
Message-ID: <1355424597.9463.17.camel@jlt4.sipsolutions.net> (sfid-20121213_194937_732132_61453C42)
Subject: Re: Add a new work-queue for destructing stations?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 13 Dec 2012 19:49:57 +0100
In-Reply-To: <50CA22BC.7090008@candelatech.com>
References: <50CA1470.4030107@candelatech.com>
	     (sfid-20121213_184629_945929_240FAE82) <1355421541.9463.8.camel@jlt4.sipsolutions.net>
	    <50CA1C44.5030300@candelatech.com>
	   <1355423047.9463.9.camel@jlt4.sipsolutions.net>
	   <50CA1EB6.9030903@candelatech.com>
	  <1355423836.9463.14.camel@jlt4.sipsolutions.net>
	  <50CA20D4.90707@candelatech.com>
	 <1355424117.9463.16.camel@jlt4.sipsolutions.net>
	 <50CA22BC.7090008@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-13 at 10:47 -0800, Ben Greear wrote:
> On 12/13/2012 10:41 AM, Johannes Berg wrote:
> > On Thu, 2012-12-13 at 10:39 -0800, Ben Greear wrote:
> >
> >>>> So, near where we currently call cancel_work_sync(&sdata->work), I
> >>>> think we'd also need to cancel things like the sta->ampdu_mlme.work,
> >>>> and probably others as well.
> >>>>
> >>>> Then, when we're sure there are no more references to sdata on the
> >>>> main-work-queue, it would be safe to flush the destructor-workqueue
> >>>> (which would have the fre_sta_work() on it).
> >>>>
> >>>> Maybe?
> >>>
> >>> Huh, ok, but I don't think you'll find much that doesn't reference an
> >>> sdata?
> >>
> >> I think you are right...so just need to find all of those work items
> >> and call cancel_work_sync() on them, just like we are currently cancelling
> >> the sdata->work....
> >
> > Well the concern there is that we expose the workqueue to the driver,
> > and it might even put sdata-referencing work items on it and expect them
> > to be flushed out before stop_interface() is called?
> >
> > You'd be welcome to change the API so that isn't true, or things are
> > different, or whatever, but it'd be a lot of careful auditing (and
> > probably fixing) of drivers.
> 
> So, maybe a new driver api call to 'cancel_all_work_items(sdata)',
> and if the driver does not implement this, then we stick with the
> full flush_workqueue() in mac80211_do_stop().  But, if the driver
> does implement it, and we add code there to flush any mac80211 related
> work-items, then we could skip the flush_workqueue() call....

You don't even need the API, it can do it in remove_interface(). It's
just not ... guaranteed right now. Also, if it wants them to run,
locking may get tricky?

johannes

