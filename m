Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from resqmta-po-01v.sys.comcast.net ([96.114.154.160]:45986 "EHLO
        resqmta-po-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754181AbdHIRCi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Aug 2017 13:02:38 -0400
Reply-To: james@nurealm.net
Subject: Re: wireless drivers fail to report link speed?
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Ben Greear <greearb@candelatech.com>,
        Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
References: <9645388a-2350-8fa0-ca34-e2289743888b@nurealm.net>
 <1502228547.24881.5.camel@redhat.com>
 <3a24351b-6875-fe65-58f1-f624c9f1832f@candelatech.com>
 <5f4422cc-2943-7863-bef3-c2c2653bde24@nurealm.net>
 <5a5cb91f-443c-8cc1-ea1f-50de4d07cb25@candelatech.com>
 <3d16a276-0e15-c722-483c-c17d715ebb5e@nurealm.net>
 <598AD624.1060003@broadcom.com>
From: James Feeney <james@nurealm.net>
Cc: Andy Gospodarek <andy@greyhouse.net>
Message-ID: <318f60de-5589-1218-9848-d3514724e9c1@nurealm.net> (sfid-20170809_190244_602632_CDB9A985)
Date: Wed, 9 Aug 2017 11:01:52 -0600
MIME-Version: 1.0
In-Reply-To: <598AD624.1060003@broadcom.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 08/09/2017 03:30 AM, Arend van Spriel wrote:
>> That seems a little over-broad, at least certainly with respect to "half
>> duplex".  If the link is known to be half duplex, then the kernel ethtool can
>> simply report that the link is "half duplex".  I am not hearing a good
>> justification, or a necessity, for the kernel ethtool to return an error,
>> instead.> > There is nothing "over-board" about it. Whhy asking a question if
you already> know the answer.
Sorry - I do not understand to what "answer" you are referring.  Are you saying
that the kernel ethtool should *not* return an error?  Or are you saying that
the kernel ethtool *should* return an error, because the "wifi duplex" is
*always* half duplex?  Or are you referring to something else?  The kernel
ethtool functions need to work with *all* network interface types, wired,
wireless, and virtual.

Or, are you saying that the bonding module should not be using the kernel
ethtool functions?

> Actually what the bonding module could rely on would be what is described in
> section 11.46 ("Estimated throughput") of IEEE802.11-2016 as it seems to address
> exactly the bonding use-case. However, I am not aware of any devices in the
> field carrying that feature (but I am not all knowing ;-) ).

Ah!  That sounds like a useful focus.

I would like to discover a consensus among the wireless driver community about
what the "correct" resolution would be, with respect to the bonding module's
need to determine the link speed of an interface.

Should there be a "push" for, as you reference, proper reporting of "Estimated
throughput"?  Should there be a "wireless will never report link speed", because
- hey - it requires too much work to change all the wireless drivers?

What should the wireless group say to the bonding module group?

@ Kalle Valo

> Have you reported this on netdev (CCing linux-wireless, David Miller and
> the patch authors)? I think the offending bonding patch should be
> reverted but first it needs to be properly reported on the mailing list.
> Most people don't really follow bugzilla.

I have not.  I first contacted David Miller and the patch authors personally, to
see what sort of tact they might want to take.  They have been notified.  There
has been no response from anyone except Andy.  I can only make-up stories, based
upon no information, about why they are ignoring this issue.  I have been
following an ever-expanding sequence of suggestions about where to discuss this
issue - privately, Arch Linux, kernel bugzilla, linux-wireless - and now,
netdev.  I may do that next, but then, there may be so many different forums
where this topic is being introduced, that no one anywhere will want to track it
at all, or participate.

Really, who's responsibility is it, and who should have the authority, deciding
what functionality wireless drivers "must" provide for functionality like
"wireless bonding"?  I'd like to hear some kind of consensus on that.  So far,
no one is "owning" anything, not the wireless driver people, not the bonding
module people, not the kernel ethtool people.  So far, there are only a
developing set of "attitudes" and opinions.  I appreciate that some people are
willing to express opinions.

@ Dan Williams

> I'm not really arguing against updating mac80211 to report this
> information if somebody actually wants to do the patch.  I'm only
> saying that even with the patch, it's not going to do exactly what you
> want it to do, and even if it works for you 90% of the time, it's not
> going to work for others that much of the time, and thus it gives a
> false sense of "correctness" which is just wrong.

Hey - don't put this on me!  This is not about "what I want it to do".  I'm only
trying to make my wireless bonding work again.  But I also don't want to simply
"slap down" Mahesh, by only reverting his patch, which addressed another, real,
problem.  This needs to be a cooperative effort.  How do *we all* address the
problem that Mahesh was trying to resolve, and, at the same time, continue to
support wireless bonding?  Please, don't just "kick the can down the road".  It
seems to me that Mahesh must have been pretty upset about the wireless drivers
not reporting speed, to have written a patch that just disables the wireless
interface when the reporting fails.  Think about it.

If there is a long-standing screw-up with the wireless drivers failing to
properly support 'section 11.46 ("Estimated throughput") of IEEE802.11-2016',
then let's start-off by admitting that.  *Then* everyone can argue about what to
do about it.  And, if that's not the underlying problem, let's make that
determination.  I'm just trying to find a way forward.

> No, it's not a fault of ethtool.  Ethtool only reports something, it's
> up to the thing that interprets that data (eg, bonding) to do the right
> thing with it.

It has not yet been established that there is anything - "Estimated throughput"
- being provided universally by the wireless drivers for the kernel ethtool to
report.  So, you cannot blame this immediately upon "the thing that interprets
the data (eg, bonding)", when there *is no data* to interpret.  That was the
original question and issue.  There first *has* to be some data to interpret!

I will say that it is no more appropriate that the wireless drivers generate a
"piss-off" error on a get_settings() request than that the bonding module
respond with a "screw-you", disabling the wireless interface when it returns
that error.  This has turned into some kind of nasty lovers quarrel.  Or like a
couple of children having temper tantrums and retaliations.

> Likely every wireless driver, except that for mac80211-based drivers it
> would only take updating the mac80211 stack.

Ok.  That sounds positive.  Then there is a possibility to both update the
mac80211 stack, to provide "Estimated throughput", and also for the bonding
module to fall-back to a work-around for those wireless drivers that do not use
the mac80211 stack.

> I'm only
> saying that even with the patch, it's not going to do exactly what you
> want it to do, and even if it works for you 90% of the time, it's not
> going to work for others that much of the time, and thus it gives a
> false sense of "correctness" which is just wrong.

Ok.  So what *is* the "right thing" to do here?

The current, actual, in-place, "solution", implemented now, in the linux kernel,
is to simply "nuke" all wireless network interfaces that try to use the bonding
module.  I'd say that is a "rude, slap in the face" solution, but it suggests to
me that there is a sense of "hopelessness" in trying to get some support from
the wireless driver people, to actually fix the wireless speed reporting issue.
We could say that a patch "nuking" all wireless network interfaces is really a
desperate cry for help.  And this patch was signed-off by David Miller.

> When I did 'iw dev wlp4s0 link' with a 2.4GHz baby monitor on in the
> next room, my device flipped continuously between ~70Mb/s and 130Mb/s
> every couple seconds. YMMV.  It's gonna be the same anywhere near a
> microwave.

It appears to me to be absolutely certain that both 70Mb/s and 130Mb/s are
greater link speeds than, for instance, 10Mb/s wired ethernet, or 54Mb/s 802.11g
wireless.  You see?

> There is no "stable" link speed.  The link selects the maximum speed
> that produces as few errors as possible, and adjusts that speed
> continuously due to the radio environment.  Again, many external
> factors that you have no control over affect link speed.

It is *not* the responsibility of the wireless driver to determine the policy of
the bonding module!  It is only the responsibility of the wireless driver to
*report* the speed of the wireless link.  Don't try to "second-guess" the
bonding module people!

I imagine that a huge step forward would be made if only the kernel ethtool did
not just report an error in response to a wireless driver get_settings() request!

> I'm suggesting that if the bonding driver is expecting a *continuous*
> stable link rate from any kind of radio device, whether that's WiFi,
> WWAN, Bluetooth, or whatever, it's being unreasonable.
>
> It's not necessarily unreasonable to add speed/duplex reporting to the
> ethtool hooks for wifi drivers.  But before that happens, we should
> understand what other bits will use that information, how they use it,
> and if they are going to use it incorrectly and thus do something that
> users don't expect and consider a bug itself.

I really appreciate that you are engaging this topic - because lots of people
have not responded at all.  So, what do you suggest, with respect to addressing
the issue that Mahesh's patch was trying to address?  Do we ridicule Mahesh for
his "slap in the face" patch?  And David Miller for signing-off on it?  Or do we
update speed reporting in the wireless drivers, and provide some support for the
bonding module people, to make the bonding module do what they want?

Because, right now, wireless bonding is absolutely, and purposefully, "broken".


James
