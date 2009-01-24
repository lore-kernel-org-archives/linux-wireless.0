Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:59180 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbZAXTyW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 14:54:22 -0500
Received: by ug-out-1314.google.com with SMTP id 39so62499ugf.37
        for <linux-wireless@vger.kernel.org>; Sat, 24 Jan 2009 11:54:21 -0800 (PST)
Message-ID: <497B71E9.6080703@gmail.com> (sfid-20090124_205447_331335_DE871F7B)
Date: Sat, 24 Jan 2009 20:54:17 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: Artur Skawina <art.08.09@gmail.com>,
	linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC][PATCH v2] p54usb: rx refill revamp
References: <200901232245.15216.chunkeey@web.de> <200901240215.44226.chunkeey@web.de> <497A967F.2010900@gmail.com> <200901241206.18690.chunkeey@web.de>
In-Reply-To: <200901241206.18690.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> On Saturday 24 January 2009 05:18:07 Artur Skawina wrote:
>> Christian Lamparter wrote:
>>> 4) urb_unpoison_anchored_urb is called
>>> 	1) unpoison the anchor structure
>>> 	2) tries to unpoison the anchored urbs... But there's not a single one in the anchor_list,
>>> 	     since step 2.1 (usb_hcd_giveback_urb) killed them off. 
>> I assume that's just how it's supposed to be. You could always anchor
>> the urbs to another anchor in the completion_. Or free any buffers and
>> drop the last ref before leaving the completion. (in fact, the former
>> is basically what you're doing, just using a list instead)
> true! In fact --- behold the clean up patch which uses another anchor instead of the list ---

will try to look at this tomorrow, or the day after.

>> ok. (i don't know about most wlans being always up, but it seems a
>> reasonable compromise. still, that's 100k+ wasted ram in the down
>> state.)
> 
> ??? We don't waste 100k+.
> We recycle the skbs, so the only thing left is 32 urb structures.

I need a weekend off ;), you're right, of course.

>>> well, we don't schedule the workqueue if we canceling the urbs now,
>>> ( that's what the urb->status switch is supposed to do/( or in this context )stop...)
>> yep, noticed that later, see below.

>> [My version schedules the work for every urb, even the poisoned ones]
> well, there's now a hard limit... no change of a endless loop now.

The whole point of the poisoning was to prevent resubmission when
canceling the urbs -- if you work around that manually, you could just
as well kill them, instead of poisoning.
I don't understand why want to add extra code to the rx irq just to
avoid scheduling a work when downing the i/f, and keep a nasty failure
case. The difference in down() performance is not going to be measurable,
and even if it was, it wouldn't matter.
Just four consecutive rx failures could make the device completely death,
requiring a down/up sequence to restore it to working condition. Before
you merged the emergency alloc-in-irq, even just one error could have
killed the card. Yes, it's going to be rare, but bugs that trigger once
a year during 24/7 operation are the absolutely worst kind of bugs.
And it may even be remotely exploitable, eg by flooding the card with
a large number of frames when the host experiences memory pressure or
has some cabling or power supply issues.

>> I looked at your v2 briefly yesterday and even wrote a reply, but
>> didn't send it. I really liked your v1 much better, the new version
>> makes the code much harder to follow, and still can stall the device
>> after a few consecutive urb completion or submission (this is new)
>> errors happen. Uhm, i probably should shut up now ;)
> 
> be prepared to write the reply again ;-)
> 
> Yeah, it's always easier to follow your own code, however its sometimes
> harder to find bugs, because you assumed you did everything right in the first place...

In this case it was mostly your code in _both_ cases :)
You can argue it's a matter of taste, but try to compare the old version
of p54u_rx_cb() with your new one side-by-side; probably the last patch
I sent vs your previous v2 one are the best candidates, as those are mostly
equivalent, with the difference being the work scheduling on status!=0,
which doesn't change the flow significantly.
Even though i know exactly what that completion is supposed to do, looking
at the maze of 'returns' and 'breaks', I can't immediately tell whether it
does just that or not. Gotos aren't evil.
Imagine you're looking at the code for the first time, which one would
you understand faster?...

After staring at the new function for ~ a minute, i think the new one 
does approximately the same as the old one. 'approximately' because you
changed the code to _not_ resubmit an urb from the workqueue after it
fails to be submitted in the irq. This doesn't seem right; if it failed
because of eg -ENOMEM it could succeed later. The previous version would
have deferred the work in this case. This change wasn't in the changelog,
was it intentional?

Again, feel free to ignore me, i'd just like to have a robust AP, and the
best way to achieve that is to attract more p54 developers :),  simpler,
more obvious code lowers the entry cost significantly...

artur

