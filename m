Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:48344 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756510AbZAVWvi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 17:51:38 -0500
Received: by nf-out-0910.google.com with SMTP id d3so749792nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 14:51:37 -0800 (PST)
Message-ID: <4978F877.2070609@gmail.com> (sfid-20090122_235143_431612_4CAE589E)
Date: Thu, 22 Jan 2009 23:51:35 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: Artur Skawina <art.08.09@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: [RFC][RFT][PATCH] p54usb: rx refill revamp
References: <200901211450.50880.chunkeey@web.de> <200901222202.48226.chunkeey@web.de> <4978EDB1.502@gmail.com> <200901222339.59965.chunkeey@web.de>
In-Reply-To: <200901222339.59965.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> well, I took a quick look into the usb code...
> (I know this isn't "usb_poison_anchored_urbs", or usb_kill_anchored_urbs,
> but they have to use this ones!)
> 
> void usb_kill_urb(struct urb *urb)
> {
>         might_sleep();
>         if (!(urb && urb->dev && urb->ep))
>                 return;
>         atomic_inc(&urb->reject);
> 
>         usb_hcd_unlink_urb(urb, -ENOENT);
>         wait_event(usb_kill_urb_queue, atomic_read(&urb->use_count) == 0);
> 
>         atomic_dec(&urb->reject);
> }
> 
> vs.
> 
> void usb_poison_urb(struct urb *urb)
> {
>         might_sleep();
>         if (!(urb && urb->dev && urb->ep))
>                 return;
>         atomic_inc(&urb->reject);
> 
>         usb_hcd_unlink_urb(urb, -ENOENT);
>         wait_event(usb_kill_urb_queue, atomic_read(&urb->use_count) == 0);
> }
> 
> it looks like usb_poison_urb doesn't do what I though it does...
> In fact the way I see it now... there's no advantage if we use it,
> we can stick usb_kill_anchored_urb, right?

the difference is that after an urb is killed it can be resubmitted;
after it's poisoned it will always fail w/ -EPERM.

usb_poison_anchored_urbs() will not only poison all anchored urbs
but also mark the anchor itself -- and the usb_anchor_urb() call will
then also poison every urb it anchors.

So once you have called usb_poison_anchored_urbs(A), you can count
on every single urb that either already was or is subsequently
anchored to A to always fail on submission.
And any urbs that were already submitted at the time of the
usb_poison_anchored_urbs(A) call will have gone through the completion.

artur
