Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:33963 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751423Ab1A0TXD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 14:23:03 -0500
From: Kevin Hilman <khilman@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Ohad Ben-Cohen <ohad@wizery.com>,
	<linux-pm@lists.linux-foundation.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
	Ido Yariv <ido@wizery.com>
Subject: Re: [linux-pm] subtle pm_runtime_put_sync race and sdio functions
References: <Pine.LNX.4.44L0.1101271158530.2090-100000@iolanthe.rowland.org>
Date: Thu, 27 Jan 2011 11:22:58 -0800
In-Reply-To: <Pine.LNX.4.44L0.1101271158530.2090-100000@iolanthe.rowland.org>
	(Alan Stern's message of "Thu, 27 Jan 2011 13:13:33 -0500 (EST)")
Message-ID: <87hbcum9rh.fsf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alan Stern <stern@rowland.harvard.edu> writes:

> On Wed, 26 Jan 2011, Kevin Hilman wrote:
>
>> >> Consider this instead:  Since A is required to be functional before B
>> >> can be used, A must be registered before B and hence B gets suspended
>> >> before A.  Therefore during the prepare phase we can runtime-resume A
>> >> and leave it powered up; when B needs to suspend, it won't matter that
>> >> the runtime-PM calls are ineffective.
>> >
>> > We don't really need to do that, because the runtime resume _is_ functional
>> > during system suspend.
>
> Not asynchronous runtime resume, because the workqueue is frozen.  But 
> that's not the issue here.
>
>> >  The only thing missing is a ->suspend() callback for A
>> > (and a corresponding ->resume() callback to make sure A will be available to
>> > B during system resume).
>> >
>> 
>> OK, I'm finally back to debugging this problem and looking for a final
>> solution.
>> 
>> I agree that what is needed is ->suspend() and ->resume() callbacks for
>> A, but the question remains how to implement them.
>> 
>> In my case, A doesn't need runtime callbacks, but *does* require that
>> the subsystem callbacks are called because the subsystem actually does
>> all the real PM work.  On OMAP, the device PM code (clock mgmt, device
>> low-power states, etc.) is common for all on-chip devices, so is handled
>> in common code at the subsystem level (in this case, platform_bus.)
>> 
>> Therefore, what is ideally needed is the ability for A's suspend to
>> simply call pm_runtime_suspend() so the subsystem can do the work.
>> However, since runtime transitions are locked out by this time, that
>> doesn't work.  IOW, what is needed is a way for a system suspend to say
>> "please finish the runtime suspend that was already requested."
>
> Calling the runtime_suspend method directly is the way to do it.
>

Do you mean the driver's runtime_suspend method, or the subsystem's
runtime_suspend method?  In my case, the driver has no runtime_suspend
method since the subystem methods are doing the heavy lifting.

>> What I've done to work around this in driver A is to manually check
>> pm_runtime_suspended() and directly call the subsystem's runtime
>> suspend/resume (patch below[1].  NOTE, I've used the _noirq methods to
>> ensure device A is available when device B needs it.)
>
> Hmm.  The pm_runtime_suspended() check may not be needed (if A were
> suspended already then B would have encountered problems).  But
> including it doesn't hurt.
>
> Using the _noirq method isn't a good idea, unless you know for certain 
> that the runtime_suspend handler doesn't need to sleep.  
> Using the normal suspend method should work okay, because B always has
> to suspend before A.

I do know that it doesn't need to sleep, but I think I can use the
normal methods anyways in case that changes in the future.

>> While this works, I'm not crazy about it since it requires the driver
>> know about the subsystem (in this case the bus) where the real PM work
>> is done.  IMO, it would be much more intuitive (and readable) if the
>> driver's suspend hooks could simply trigger a runtime suspend (either a
>> new one, or one already requested.)
>
> This isn't clear to me.  Isn't the driver registered on the bus in 
> question?  Can't the driver therefore call the bus's runtime_suspend 
> routine directly, instead of dereferencing the bus->pm->runtime_suspend 
> pointer?

Not sure what you mean by directly.  The platform_bus doesn't expose
its runtime PM methods since they can be customized at runtime, so they
have to be called via bus->pm.

Or do you mean using dev->driver instead of dev->bus?

Kevin
