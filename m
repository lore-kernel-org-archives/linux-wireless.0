Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.245]:10567 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbYGWTnb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 15:43:31 -0400
Received: by an-out-0708.google.com with SMTP id d40so544681and.103
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2008 12:43:30 -0700 (PDT)
Date: Wed, 23 Jul 2008 15:43:26 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rfkill: rate-limit rfkill-input workqueue usage
Message-ID: <20080723153747.ZZRA012@mailhub.coreip.homeip.net> (sfid-20080723_214337_560320_E20CAAAD)
References: <1216775046-9506-1-git-send-email-hmh@hmh.eng.br> <1216775046-9506-7-git-send-email-hmh@hmh.eng.br> <200807232046.59110.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200807232046.59110.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 23, 2008 at 08:46:58PM +0200, Ivo van Doorn wrote:
> On Wednesday 23 July 2008, Henrique de Moraes Holschuh wrote:
> > Limit the number of rfkill-input global operations per second.  It lacked
> > the limiter that non-global operations (state changes) had.  This way, a
> > rogue input event generator cannot force rfkill-input to hog the workqueue
> > too much.
> > 
> > Rework the limiter code so that newer state change requests (rfkill input
> > events) will override older ones that haven't been acted upon yet.  It used
> > to ignore new ones that were past the rate limit.

This was done to deal with potential jitter from button devices.

In the proposed implementation, if button bounces and generates 2 or
more press/release pairs and we manage to schedule and execure first
task (which is scheduled with delay 0) before the last press/release
arrives we will schedule an extra work and toggle the switch again as
far as I can see.

> >  
> > @@ -132,24 +147,22 @@ static void rfkill_schedule_toggle(struct rfkill_task *task)
> >  {
> >  	unsigned long flags;
> >  
> > -	if (unlikely(work_pending(&rfkill_global_task.work)))
> > +	if (unlikely(delayed_work_pending(&rfkill_global_task.dwork)))

What if the global task comletes executing right at this moment?

> >  		return;
> >  
> >  	spin_lock_irqsave(&task->lock, flags);
> > -
> > -	if (time_after(jiffies, task->last + msecs_to_jiffies(200))) {
> > -		task->desired_state =
> > -				rfkill_state_complement(task->desired_state);
> > +	task->desired_state = rfkill_state_complement(task->desired_state);
> > +	if (likely(!delayed_work_pending(&task->dwork))) {
> > +		schedule_delayed_work(&task->dwork,
> > +					rfkill_ratelimit(task->last));
> >  		task->last = jiffies;
> > -		schedule_work(&task->work);
> >  	}
> > -
> >  	spin_unlock_irqrestore(&task->lock, flags);
> >  }
> >  

-- 
Dmitry
