Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:35796 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752516Ab1A0UPR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 15:15:17 -0500
From: Kevin Hilman <khilman@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Ohad Ben-Cohen <ohad@wizery.com>,
	<linux-pm@lists.linux-foundation.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
	Ido Yariv <ido@wizery.com>
Subject: Re: [linux-pm] subtle pm_runtime_put_sync race and sdio functions
References: <Pine.LNX.4.44L0.1101271439020.2090-100000@iolanthe.rowland.org>
Date: Thu, 27 Jan 2011 12:15:12 -0800
In-Reply-To: <Pine.LNX.4.44L0.1101271439020.2090-100000@iolanthe.rowland.org>
	(Alan Stern's message of "Thu, 27 Jan 2011 14:49:01 -0500 (EST)")
Message-ID: <87tyguje7j.fsf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alan Stern <stern@rowland.harvard.edu> writes:

> On Thu, 27 Jan 2011, Kevin Hilman wrote:
>
>> > Calling the runtime_suspend method directly is the way to do it.
>> >
>> 
>> Do you mean the driver's runtime_suspend method, or the subsystem's
>> runtime_suspend method?
>
> The subsystem's.  If the driver has a runtime_suspend method then the 
> subsystem's method will call it.

Yes.  Thanks for the clarification.

>> >> While this works, I'm not crazy about it since it requires the driver
>> >> know about the subsystem (in this case the bus) where the real PM work
>> >> is done.  IMO, it would be much more intuitive (and readable) if the
>> >> driver's suspend hooks could simply trigger a runtime suspend (either a
>> >> new one, or one already requested.)
>> >
>> > This isn't clear to me.  Isn't the driver registered on the bus in 
>> > question?  Can't the driver therefore call the bus's runtime_suspend 
>> > routine directly, instead of dereferencing the bus->pm->runtime_suspend 
>> > pointer?
>> 
>> Not sure what you mean by directly.  The platform_bus doesn't expose
>> its runtime PM methods since they can be customized at runtime, so they
>> have to be called via bus->pm.
>> 
>> Or do you mean using dev->driver instead of dev->bus?
>
> You're doing all of this for OMAP, right?  What is the subsystem's
> runtime_suspend routine?  Is it omap_pm_runtime_suspend()?

Yes.

> If it is, then you can call omap_pm_runtime_suspend() directly instead
> of calling dev->bus->pm->runtime_suspend().

Personally, I prefer going through dev->bus as we try to avoid SoC
specific calls in the driver.

This same HW block might be re-used on non-OMAP SoCs (e.g. TI DaVinci)
that would have different PM at the susbystem level.

So, to summarize, as long as folks are OK with drivers directly calling
the subsystem runtime PM callbacks, I'll go this route.

Kevin

