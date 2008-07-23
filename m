Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:15945 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbYGWUjR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 16:39:17 -0400
Received: by yw-out-2324.google.com with SMTP id 9so1135556ywe.1
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2008 13:39:15 -0700 (PDT)
Date: Wed, 23 Jul 2008 16:39:13 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rfkill: rate-limit rfkill-input workqueue usage
Message-ID: <20080723163253.ZZRA012@mailhub.coreip.homeip.net> (sfid-20080723_223921_518489_AF3C42E9)
References: <1216775046-9506-1-git-send-email-hmh@hmh.eng.br> <1216775046-9506-7-git-send-email-hmh@hmh.eng.br> <200807232046.59110.IvDoorn@gmail.com> <20080723153747.ZZRA012@mailhub.coreip.homeip.net> <20080723202755.GH11009@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080723202755.GH11009@khazad-dum.debian.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 23, 2008 at 05:27:55PM -0300, Henrique de Moraes Holschuh wrote:
> On Wed, 23 Jul 2008, Dmitry Torokhov wrote:
> > On Wed, Jul 23, 2008 at 08:46:58PM +0200, Ivo van Doorn wrote:
> > > On Wednesday 23 July 2008, Henrique de Moraes Holschuh wrote:
> > > > Limit the number of rfkill-input global operations per second.  It lacked
> > > > the limiter that non-global operations (state changes) had.  This way, a
> > > > rogue input event generator cannot force rfkill-input to hog the workqueue
> > > > too much.
> > > > 
> > > > Rework the limiter code so that newer state change requests (rfkill input
> > > > events) will override older ones that haven't been acted upon yet.  It used
> > > > to ignore new ones that were past the rate limit.
> > 
> > This was done to deal with potential jitter from button devices.
> 
> I'd argue that should be handled in the input device driver (note: I didn't
> say input layer, although it could certainly add debouncing helpers if we
> don't want to duplicate code in drivers).
> 
> IMHO, you should NOT send the result of a lack of proper debouncing to the
> input layer.  When you do, you send duplicated events to every input device
> handler, userspace, etc.
> 
> > In the proposed implementation, if button bounces and generates 2 or
> > more press/release pairs and we manage to schedule and execure first
> > task (which is scheduled with delay 0) before the last press/release
> > arrives we will schedule an extra work and toggle the switch again as
> > far as I can see.
> 
> You are correct.  I didn't know the previous behaviour was there to ignore
> rapid press of buttons.  It looked like anti-DoS standard limiting to me
> (needed, since userspace can inject events).
> 
> Well there are two possible ways to deal with this.  Three actually.  The
> first is to ignore the issue in rfkill-input and input layer, and tell
> anything that generate events for badly-behaved buttons to deal with it.
> The second, is to fix it in the input layer, so that we don't have to fix it
> in every handler.  The third is to fix it in the handlers.
> 
> I'd rather either the driver or the input layer dealt with this issue, so as
> not to propagate bogus events to the rest of the system...
> 
> Or did I misunderstand the issue?
> 

Yes, we can try to make drivers behave. Originally I was trying to be
nice to simple drivers and take care of the jitter for them.

I do not think the input core is suited to deal with the jitter since
many devices support several buttons to be pressed at the same time so
we'd need separate timers for pretty much every event possible.

> > > > @@ -132,24 +147,22 @@ static void rfkill_schedule_toggle(struct rfkill_task *task)
> > > >  {
> > > >  	unsigned long flags;
> > > >  
> > > > -	if (unlikely(work_pending(&rfkill_global_task.work)))
> > > > +	if (unlikely(delayed_work_pending(&rfkill_global_task.dwork)))
> > 
> > What if the global task comletes executing right at this moment?
> 
> If delayed_work_pending() is set, then it has not begun executing yet.  That
> bit is cleared by the workqueue stuff right before the delayed work handler
> is called.
> 
> But I missed a test. I should check delayed_work_pending() and if it is set,
> check rfkill_global_task.op_count.  If both are set, we are sure we ARE going
> to execute a global operation in the near future, and therefore we should
> clobber regular toggles.
> 
> Would that fix the issue with rfkill_schedule_toggle versus
> rfkill_global_task?
> 

Not sure... consider:

CPU1:					CPU2:
 check work pending - yes
 hardware interrupt			 start executing global work
 ....					 global work done
 return from HW handler
 return immediately from
	rfkill_schedule_toggle

-> event lost.

-- 
Dmitry
