Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:42338 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbZAVVCp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 16:02:45 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Artur Skawina <art.08.09@gmail.com>
Subject: Re: [RFC][RFT][PATCH] p54usb: rx refill revamp
Date: Thu, 22 Jan 2009 22:02:48 +0100
Cc: linux-wireless@vger.kernel.org
References: <200901211450.50880.chunkeey@web.de> <200901221701.59190.chunkeey@web.de> <4978C6B4.80601@gmail.com>
In-Reply-To: <4978C6B4.80601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901222202.48226.chunkeey@web.de> (sfid-20090122_220252_350524_DB611AF8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 22 January 2009 20:19:16 Artur Skawina wrote:
> Christian Lamparter wrote:
> > On Thursday 22 January 2009 16:52:44 Artur Skawina wrote:
> >> Christian Lamparter wrote:
> >>> On Thursday 22 January 2009 06:40:56 Artur Skawina wrote:
> >>> was this with your patch to use rx_refills urb pool for tx, or without?
> >> just your patch plus the fixes that i needed to get it to work, all
> >> of them were in that email. The subject said RFT... ;)
> >> [the line #s were off, because of some extra printks logging the queue len]
> >>
> > all right, could you please put a commit message in your mail as well?
> 
> I thought you had already merged the changes, but i see you only took the
> first hunk. There's no point in splitting the commit, as the intermediate
> result wouldn't work. You can add my s-o-b, if you feel that's necessary.
> This last version seems fine, just one thing: I can't convince myself
> that not queuing the work after an urb fails with urb->status==true is
> safe -- what if some temporary error condition causes the rx queue to
> drain? Nothing will resubmit the urbs.
well, the usb->status has to be "=! 0" 32 times in a row.
So either the device, the system, or both have more serious problem and need
some user attention/reset. However yes a few more unlikely paths wont hurt. ;-) 

> Wouldn't a usb_poison_anchored_urbs() instead of usb_kill_anchored_urbs()
> in p54u_free_urbs() prevent p54u_rx_refill from resubmitting, and that early
> return in the completion could then go? Or did i miss a case where it's
> needed, other than stop()?
size of the patch? because then we have to rewrite the p54u_start and
p54u_stop to go a different path for ifdown/ifup (poison/unpoison) or
suspend / disconnect (here we probably want kill).

But if you want to do that, you're welcome your post patches.

Regards,
	Chr
