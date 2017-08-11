Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f178.google.com ([209.85.216.178]:33960 "EHLO
        mail-qt0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753181AbdHKSoD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Aug 2017 14:44:03 -0400
Received: by mail-qt0-f178.google.com with SMTP id s6so25990966qtc.1
        for <linux-wireless@vger.kernel.org>; Fri, 11 Aug 2017 11:44:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1502303131.9777.7.camel@redhat.com>
References: <9645388a-2350-8fa0-ca34-e2289743888b@nurealm.net>
 <1502228547.24881.5.camel@redhat.com> <3a24351b-6875-fe65-58f1-f624c9f1832f@candelatech.com>
 <5f4422cc-2943-7863-bef3-c2c2653bde24@nurealm.net> <5a5cb91f-443c-8cc1-ea1f-50de4d07cb25@candelatech.com>
 <3d16a276-0e15-c722-483c-c17d715ebb5e@nurealm.net> <598AD624.1060003@broadcom.com>
 <318f60de-5589-1218-9848-d3514724e9c1@nurealm.net> <1502303131.9777.7.camel@redhat.com>
From: Andy Gospodarek <andy@greyhouse.net>
Date: Fri, 11 Aug 2017 14:43:41 -0400
Message-ID: <CAHashqDypwFtpXbP0Mw+XRWAbSiar8ozepmHF3r0fGs3nrsu_g@mail.gmail.com> (sfid-20170811_204407_971064_68223DCE)
Subject: Re: wireless drivers fail to report link speed?
To: Dan Williams <dcbw@redhat.com>
Cc: James Feeney <james@nurealm.net>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Ben Greear <greearb@candelatech.com>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 9, 2017 at 2:25 PM, Dan Williams <dcbw@redhat.com> wrote:
> On Wed, 2017-08-09 at 11:01 -0600, James Feeney wrote:
>> @ Dan Williams
>>
>> > I'm not really arguing against updating mac80211 to report this
>> > information if somebody actually wants to do the patch.  I'm only
>> > saying that even with the patch, it's not going to do exactly what
>> > you
>> > want it to do, and even if it works for you 90% of the time, it's
>> > not
>> > going to work for others that much of the time, and thus it gives a
>> > false sense of "correctness" which is just wrong.
>>
>> Hey - don't put this on me!  This is not about "what I want it to
>> do".  I'm only
>
> I had a whole email written out, but it wasn't very constructive.
>
> To be clear: I am not putting anything on you, or blaming you for
> anything :)  Sorry if my tone implied that to you.  I feel like the
> tone of this thread is becoming contentious and that's not my desire.
>
> There is clearly a problem.  That problem was exposed by a patch to the
> bonding driver that newly requires information that the WiFi drivers
> don't provide.
>
> The relevant questions, in my view, are:
>
> 1) why does the bonding driver now require this information?
>
> 2) is this information reasonable to request from WiFi drivers?
>
> 3) how would this information affect the operation of the bonding
> driver if it doesn't mean the same thing as it means for wired devices?
>
> My answers are:
>
> 1) I have no idea, though to continue being constructive to this
> discussion, I should probably go find out.  We should also get the
> bonding module patch authors to weigh in.  But the core point is that
> it used to work, and now it doesn't work, and the WiFi drivers have not
> changed in this area.

I actually reached out to Mahesh a while ago to get more details on
what exactly he was trying to fix with c4adfc822bf5 ("bonding: make
speed, duplex setting consistent with link state") and 3f3c278c94d
("bonding: fix active-backup transition") but did not get a response.

I've been AFK for quite a bit of August, so unfortunately I haven't
had a change to dig into this deeply.  I'll pledge to look at this in
detail before the end of next week.  I even put it on my calendar so I
do not forget!

>
> 2) ethtool's API doesn't say much about semantics.  It is likely
> reasonable to request this information from WiFi drivers, but
> unfortunately WiFi has some different semantics for the information
> than ethernet devices do.
>
> 3) The bonding module is interpreting the speed in a certain way that
> can hugely affect its operation, and ethernet devices don't change
> speed very frequently.  But wifi devices do.  This may well cause
> unexpected operation from bonding, and we should be well aware of that
> before we do anything to fix this problem.
>
> I'd also like to point out the various virtual devices (veth, virtio,
> etc) and how they report speed.  They lock the speed to a certain
> value, but that doesn't actually mean anything because they are not
> hardware based and their throughput is more a function of current CPU
> load rather than actual wire speed.  The 'tun' driver locks the rate to
> 10Mb/s with no capability to change.  These are another case of
> mismatch in expectations between bonding and reported speeds.
>
> Again, there is a problem that should be solved.  I am only advocating
> that instead of simply adding ethtool get_settings support to WiFi
> drivers and washing our hands of it, which may have unintended
> consequences, we gather all the information first, and discuss whether
> the bonding driver may need to adjust its expectations before this kind
> of change is made.

Thanks for thoughtfully weighing in on this, Dan.  I do think that if
support for this is as significant as suggested by the many concerned
users in this thread, you are correct it is worth examining to make
sure that bonding and wireless can work happily together.

>
> Dan
>
>> trying to make my wireless bonding work again.  But I also don't want
>> to simply
>> "slap down" Mahesh, by only reverting his patch, which addressed
>> another, real,
>> problem.  This needs to be a cooperative effort.  How do *we all*
>> address the
>> problem that Mahesh was trying to resolve, and, at the same time,
>> continue to
>> support wireless bonding?  Please, don't just "kick the can down the
>> road".  It
>> seems to me that Mahesh must have been pretty upset about the
>> wireless drivers
>> not reporting speed, to have written a patch that just disables the
>> wireless
>> interface when the reporting fails.  Think about it.
>>
>> If there is a long-standing screw-up with the wireless drivers
>> failing to
>> properly support 'section 11.46 ("Estimated throughput") of
>> IEEE802.11-2016',
>> then let's start-off by admitting that.  *Then* everyone can argue
>> about what to
>> do about it.  And, if that's not the underlying problem, let's make
>> that
>> determination.  I'm just trying to find a way forward.
>>
>> > No, it's not a fault of ethtool.  Ethtool only reports something,
>> > it's
>> > up to the thing that interprets that data (eg, bonding) to do the
>> > right
>> > thing with it.
>>
>> It has not yet been established that there is anything - "Estimated
>> throughput"
>> - being provided universally by the wireless drivers for the kernel
>> ethtool to
>> report.  So, you cannot blame this immediately upon "the thing that
>> interprets
>> the data (eg, bonding)", when there *is no data* to interpret.  That
>> was the
>> original question and issue.  There first *has* to be some data to
>> interpret!
>>
>> I will say that it is no more appropriate that the wireless drivers
>> generate a
>> "piss-off" error on a get_settings() request than that the bonding
>> module
>> respond with a "screw-you", disabling the wireless interface when it
>> returns
>> that error.  This has turned into some kind of nasty lovers
>> quarrel.  Or like a
>> couple of children having temper tantrums and retaliations.
>>
>> > Likely every wireless driver, except that for mac80211-based
>> > drivers it
>> > would only take updating the mac80211 stack.
>>
>> Ok.  That sounds positive.  Then there is a possibility to both
>> update the
>> mac80211 stack, to provide "Estimated throughput", and also for the
>> bonding
>> module to fall-back to a work-around for those wireless drivers that
>> do not use
>> the mac80211 stack.
>>
>> > I'm only
>> > saying that even with the patch, it's not going to do exactly what
>> > you
>> > want it to do, and even if it works for you 90% of the time, it's
>> > not
>> > going to work for others that much of the time, and thus it gives a
>> > false sense of "correctness" which is just wrong.
>>
>> Ok.  So what *is* the "right thing" to do here?
>>
>> The current, actual, in-place, "solution", implemented now, in the
>> linux kernel,
>> is to simply "nuke" all wireless network interfaces that try to use
>> the bonding
>> module.  I'd say that is a "rude, slap in the face" solution, but it
>> suggests to
>> me that there is a sense of "hopelessness" in trying to get some
>> support from
>> the wireless driver people, to actually fix the wireless speed
>> reporting issue.
>> We could say that a patch "nuking" all wireless network interfaces is
>> really a
>> desperate cry for help.  And this patch was signed-off by David
>> Miller.
>>
>> > When I did 'iw dev wlp4s0 link' with a 2.4GHz baby monitor on in
>> > the
>> > next room, my device flipped continuously between ~70Mb/s and
>> > 130Mb/s
>> > every couple seconds. YMMV.  It's gonna be the same anywhere near a
>> > microwave.
>>
>> It appears to me to be absolutely certain that both 70Mb/s and
>> 130Mb/s are
>> greater link speeds than, for instance, 10Mb/s wired ethernet, or
>> 54Mb/s 802.11g
>> wireless.  You see?
>>
>> > There is no "stable" link speed.  The link selects the maximum
>> > speed
>> > that produces as few errors as possible, and adjusts that speed
>> > continuously due to the radio environment.  Again, many external
>> > factors that you have no control over affect link speed.
>>
>> It is *not* the responsibility of the wireless driver to determine
>> the policy of
>> the bonding module!  It is only the responsibility of the wireless
>> driver to
>> *report* the speed of the wireless link.  Don't try to "second-guess"
>> the
>> bonding module people!
>>
>> I imagine that a huge step forward would be made if only the kernel
>> ethtool did
>> not just report an error in response to a wireless driver
>> get_settings() request!
>>
>> > I'm suggesting that if the bonding driver is expecting a
>> > *continuous*
>> > stable link rate from any kind of radio device, whether that's
>> > WiFi,
>> > WWAN, Bluetooth, or whatever, it's being unreasonable.
>> >
>> > It's not necessarily unreasonable to add speed/duplex reporting to
>> > the
>> > ethtool hooks for wifi drivers.  But before that happens, we should
>> > understand what other bits will use that information, how they use
>> > it,
>> > and if they are going to use it incorrectly and thus do something
>> > that
>> > users don't expect and consider a bug itself.
>>
>> I really appreciate that you are engaging this topic - because lots
>> of people
>> have not responded at all.  So, what do you suggest, with respect to
>> addressing
>> the issue that Mahesh's patch was trying to address?  Do we ridicule
>> Mahesh for
>> his "slap in the face" patch?  And David Miller for signing-off on
>> it?  Or do we
>> update speed reporting in the wireless drivers, and provide some
>> support for the
>> bonding module people, to make the bonding module do what they want?
>>
>> Because, right now, wireless bonding is absolutely, and purposefully,
>> "broken".
>>
>>
>> James
