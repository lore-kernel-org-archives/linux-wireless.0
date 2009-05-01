Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:41752 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645AbZEAJmg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 May 2009 05:42:36 -0400
Received: by bwz7 with SMTP id 7so2237266bwz.37
        for <linux-wireless@vger.kernel.org>; Fri, 01 May 2009 02:42:35 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 1 May 2009 10:42:35 +0100
Message-ID: <9b2b86520905010242q443eb19bnc9e2c86a23605c2d@mail.gmail.com>
Subject: Re: rfkill rewrite
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/18/09, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sat, 2009-04-18 at 10:43 +0100, Alan Jenkins wrote:
>
>> >> When I looked at the code earlier, I saw no obvious replacement for
>> >> rfkill_set_default().  So I tried disabling the wireless and rebooting
>> >> to see what happened.  It didn't like that :-).
>> >>
>> >
>> > Ok that wasn't too hard -- try this on top if you get a chance:
>> >
>>
>> Great, that fixes the crash.
>>
>>
>> 1) I think we need to add a resume method to eeepc-laptop.
>>
>> Without this, funny things happen when I hibernate, disable wireless in
>> the BIOS, and resume:
>>
>>     ath5k phy0: failed to wake up the MAC chip
>>
>> It's an really stupid thing to do, but it can happen.  It's bad from a
>> UI point of view.  E.g. in network-manager, you can see a "wlan0"
>> device, but it doesn't work.
>>
>> The EEE rfkill is unusual in that it hotplugs the PCI device, making
>> eeepc-laptop something like a custom pci hotplug driver.  With your
>> rewrite, eeepc-laptop doesn't notice the state change on resume.
>> Previously, the rfkill-core would restore the pre-hibernation state,
>> which would sort everything out.  I don't think anything else does this,
>> so we can just add a resume method to eeepc-laptop.  The resume method
>> would re-check the state and do the PCI hotplug dance if necessary.
>>
>> If you agree, I can do the patch for this and send it to you.
>
> Sounds good to me, yeah.
>
> I could make the rfkill core do that at resume, but I'm not really sure
> it's what we want -- there are too many cases imho:
>  * hard rfkill might have changed
>  * soft rfkill might still be ok in hw
>  * soft rfkill might need reconfiguring
> etc. I think generally it's saner to let the driver sort it out -- it
> can always ask for the current state by using set_hw_state() or so.

I just realized or remembered something non-obvious.  This means _all_
rfkill drivers need a resume handler.  They don't at the moment, so
this would need to be fixed and documented.  In which case, it's
probably simpler for the core to do it.

You need this to handle hibernation.  If the rfkill state persists
across hibernation (which mine does, even in S5), you can always cause
the state to change, by pressing the wireless toggle key _while the
hibernation image is being written to disk_.  At that stage, all
devices are active, so that s2disk can interact with the user and
write the image wherever it chooses.  The kernel will not "remember"
the state change on resume, since it happened after the kernel image
was snapshotted.

If the rfkill state does _not_ persist over hibernation, then clearly
the state can change on resume and you will again need a resume
handler,

On my EeePC, this is just more dramatic because it can de-power a PCI
device without notifying the driver.  But the new rfkill design will
require all devices to have a resume method, because there is no
get_state() callback.  Otherwise, reading  of
/sys/class/rfkill/rfkill*/state after resume from hibernation may
return an incorrect result.  I don't think we should allow that to
happen.

Regards
Alan
