Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:58844 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789AbZAVWjy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 17:39:54 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Artur Skawina <art.08.09@gmail.com>
Subject: Re: [RFC][RFT][PATCH] p54usb: rx refill revamp
Date: Thu, 22 Jan 2009 23:39:59 +0100
Cc: linux-wireless@vger.kernel.org
References: <200901211450.50880.chunkeey@web.de> <200901222202.48226.chunkeey@web.de> <4978EDB1.502@gmail.com>
In-Reply-To: <4978EDB1.502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901222339.59965.chunkeey@web.de> (sfid-20090122_233959_347923_59CB8E33)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 22 January 2009 23:05:37 Artur Skawina wrote:
> Christian Lamparter wrote:
> > On Thursday 22 January 2009 20:19:16 Artur Skawina wrote:
> >> This last version seems fine, just one thing: I can't convince myself
> >> that not queuing the work after an urb fails with urb->status==true is
> >> safe -- what if some temporary error condition causes the rx queue to
> >> drain? Nothing will resubmit the urbs.
> > well, the usb->status has to be "=! 0" 32 times in a row.
> > So either the device, the system, or both have more serious problem and need
> > some user attention/reset. However yes a few more unlikely paths wont hurt. ;-) 
> > 
> >> Wouldn't a usb_poison_anchored_urbs() instead of usb_kill_anchored_urbs()
> >> in p54u_free_urbs() prevent p54u_rx_refill from resubmitting, and that early
> >> return in the completion could then go? Or did i miss a case where it's
> >> needed, other than stop()?
> > size of the patch? because then we have to rewrite the p54u_start and
> > p54u_stop to go a different path for ifdown/ifup (poison/unpoison) or
> > suspend / disconnect (here we probably want kill).
> > 
> > But if you want to do that, you're welcome your post patches.
> 
> How about this? Can you see anything wrong w/ it? Survives a quick test here.
> 
> Yes, unpoisoning the urbs would make things much more complicated.
> (mostly because usb_anchor_urb() poisons the urb, while usb_unanchor_urb()
>  doesn't unpoison, so it would either have to done manually (extra locking
>  to get the state of the anchor itself) or the un-/poisoning rules become
>  quite complex)
> 
> This simple approach frees all urbs on stop() and reallocates them on open().
> All urbs go through the completion, and all are moved to the refill list,
> even the ones that failed. If they are not supposed to be resubmitted, all
> currently in flight ones are killed and poisoned, and when they arrive in 
> p54u_rx_refill() the submission will fail.
> 
> artur
> 
well, I took a quick look into the usb code...
(I know this isn't "usb_poison_anchored_urbs", or usb_kill_anchored_urbs,
but they have to use this ones!)

void usb_kill_urb(struct urb *urb)
{
        might_sleep();
        if (!(urb && urb->dev && urb->ep))
                return;
        atomic_inc(&urb->reject);

        usb_hcd_unlink_urb(urb, -ENOENT);
        wait_event(usb_kill_urb_queue, atomic_read(&urb->use_count) == 0);

        atomic_dec(&urb->reject);
}

vs.

void usb_poison_urb(struct urb *urb)
{
        might_sleep();
        if (!(urb && urb->dev && urb->ep))
                return;
        atomic_inc(&urb->reject);

        usb_hcd_unlink_urb(urb, -ENOENT);
        wait_event(usb_kill_urb_queue, atomic_read(&urb->use_count) == 0);
}

it looks like usb_poison_urb doesn't do what I though it does...
In fact the way I see it now... there's no advantage if we use it,
we can stick usb_kill_anchored_urb, right?

Well, let's make a 2nd RFC/RFT tomorrow.

Good night,
	Chr
