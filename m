Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:45155 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756186Ab3CYLeg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Mar 2013 07:34:36 -0400
Message-ID: <1364211205.23210.18.camel@cumari.coelho.fi> (sfid-20130325_123439_528549_4A0BD7A3)
Subject: Re: [PATCH] wlcore: move handling from hardirq to the irq thread
 function
From: Luciano Coelho <coelho@ti.com>
To: <balbi@ti.com>
CC: <linux-wireless@vger.kernel.org>, <ido@wizery.com>,
	<gregoire@alwaysinnovating.com>
Date: Mon, 25 Mar 2013 13:33:25 +0200
In-Reply-To: <20130325111101.GD25656@arwen.pp.htv.fi>
References: <1364208824-18751-1-git-send-email-coelho@ti.com>
	 <20130325111101.GD25656@arwen.pp.htv.fi>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-03-25 at 13:11 +0200, Felipe Balbi wrote:
> On Mon, Mar 25, 2013 at 12:53:44PM +0200, Luciano Coelho wrote:
> > Spin locks and completions are expensive in hard IRQ context and cause
> > problems with RT kernels.  In RT kernels, both spin locks and
> > completions can schedule(), so we can't use them in hard irq context.
> > 
> > Move handling code into the irq thread function to avoid that.
> > 
> > Reported-by: Gregoire Gentil <gregoire@alwaysinnovating.com>
> > Signed-off-by: Luciano Coelho <coelho@ti.com>
> > ---
> >  drivers/net/wireless/ti/wlcore/main.c |   53 +++++++++++++--------------------
> >  1 file changed, 21 insertions(+), 32 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
> > index 248daa9..c2730a7 100644
> > --- a/drivers/net/wireless/ti/wlcore/main.c
> > +++ b/drivers/net/wireless/ti/wlcore/main.c
> > @@ -651,6 +651,25 @@ static irqreturn_t wlcore_irq(int irq, void *cookie)
> >  	unsigned long flags;
> >  	struct wl1271 *wl = cookie;
> >  
> > +	/* complete the ELP completion */
> > +	spin_lock_irqsave(&wl->wl_lock, flags);
> > +	set_bit(WL1271_FLAG_IRQ_RUNNING, &wl->flags);
> > +	if (wl->elp_compl) {
> > +		complete(wl->elp_compl);
> > +		wl->elp_compl = NULL;
> > +	}
> > +
> > +	if (test_bit(WL1271_FLAG_SUSPENDED, &wl->flags)) {
> > +		/* don't enqueue a work right now. mark it as pending */
> > +		set_bit(WL1271_FLAG_PENDING_WORK, &wl->flags);
> > +		wl1271_debug(DEBUG_IRQ, "should not enqueue work");
> > +		disable_irq_nosync(wl->irq);
> > +		pm_wakeup_event(wl->dev, 0);
> > +		spin_unlock_irqrestore(&wl->wl_lock, flags);
> > +		return IRQ_HANDLED;
> > +	}
> > +	spin_unlock_irqrestore(&wl->wl_lock, flags);
> 
> I still think _irqrestore() here is wrong, since it will reenable the
> IRQ line... other than that, it looks alright.

As we discussed earlier, it won't re-enable, since it was not enabled
when we saved.  But, in any case, as we agreed, I'll send a separate
patch removing it.  Don't want to mix two things in the same patch.


-- 
Luca.

