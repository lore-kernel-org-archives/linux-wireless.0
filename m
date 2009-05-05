Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:42964 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbZEEOEz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2009 10:04:55 -0400
Received: by fxm2 with SMTP id 2so4622794fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 05 May 2009 07:04:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1241511307.25807.6.camel@johannes.local>
References: <9b2b86520905010242q443eb19bnc9e2c86a23605c2d@mail.gmail.com>
	 <1241511307.25807.6.camel@johannes.local>
Date: Tue, 5 May 2009 15:04:53 +0100
Message-ID: <9b2b86520905050704p34e87d38gccfe78940ee95c2e@mail.gmail.com>
Subject: Re: rfkill rewrite
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/5/09, Johannes Berg <johannes@sipsolutions.net> wrote:
> Hi,
>
> Sorry for the long wait.
>
>> > I could make the rfkill core do that at resume, but I'm not really sure
>> > it's what we want -- there are too many cases imho:
>> >  * hard rfkill might have changed
>> >  * soft rfkill might still be ok in hw
>> >  * soft rfkill might need reconfiguring
>> > etc. I think generally it's saner to let the driver sort it out -- it
>> > can always ask for the current state by using set_hw_state() or so.
>>
>> I just realized or remembered something non-obvious.  This means _all_
>> rfkill drivers need a resume handler.  They don't at the moment, so
>> this would need to be fixed and documented.  In which case, it's
>> probably simpler for the core to do it.
>
> Only those that have a hard-rfkill line, which I think isn't all.

My scenario quoted below affects soft-rfkill only.

> But yes. However, how would the core handle it?

I was thinking of calling set_block() on resume to restore the
pre-suspend state.  That's what the old rfkill does, and why
eeepc-laptop got away without a resume handler.

>> You need this to handle hibernation.  If the rfkill state persists
>> across hibernation (which mine does, even in S5), you can always cause
>> the state to change, by pressing the wireless toggle key _while the
>> hibernation image is being written to disk_.  At that stage, all
>> devices are active, so that s2disk can interact with the user and
>> write the image wherever it chooses.  The kernel will not "remember"
>> the state change on resume, since it happened after the kernel image
>> was snapshotted.
>
> Good scenario, yes, it's definitely possible.
>
>> If the rfkill state does _not_ persist over hibernation, then clearly
>> the state can change on resume and you will again need a resume
>> handler,
>>
>> On my EeePC, this is just more dramatic because it can de-power a PCI
>> device without notifying the driver.  But the new rfkill design will
>> require all devices to have a resume method, because there is no
>> get_state() callback.  Otherwise, reading  of
>> /sys/class/rfkill/rfkill*/state after resume from hibernation may
>> return an incorrect result.  I don't think we should allow that to
>> happen.
>
> So we would need to add a query_resume() method like query that is
> called at resume time, and needs to call rfkill_set{,_hw,_sw}_state as
> appopriate. Thoughts? We can enforce that much easier by making it a
> required method.

That would certainly follow your existing model.  (BTW the kerneldoc
for "query" is out of sync in v8; it says "return true for blocked"
even though the prototype returns void :-).

It's debatable as to what behaviour is more user-friendly for my nasty
corner-case.  query_resume() would allow the radio to always come back
in the same state as it was in the moment the laptop went to sleep, if
the hardware supports it.  But the _global_ rfkill state will then be
out of sync, and that means the next time you press the wireless
toggle key it does nothing, which is disconcerting.  Plus, it means
the corner-case behaviour varies depending on whether the soft-rfkill
line state survives over hibernation - which may even vary on the same
machine (S5 versus S4? whether you remove the laptop's battery? weird
firmware bugs?).

All I'm trying to do is selfishly preserve eeepc-laptop across this
re-write, for which purpose it seems easier to have set_block() called
on resume :-).  I don't know if that makes rfkill more awkward in
wireless drivers (as opposed to platform drivers), or drivers which
have a hardware rfkill line.

Alan
