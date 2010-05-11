Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:54824 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757824Ab0EKU4J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 16:56:09 -0400
Received: by pxi5 with SMTP id 5so2480273pxi.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 May 2010 13:56:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1273586443.20312.14.camel@jlt3.sipsolutions.net>
References: <1273159552-5579-1-git-send-email-wey-yi.w.guy@intel.com>
	<x2z43e72e891005061458uabf4a6cxae3f5dd4067f0fbb@mail.gmail.com>
	<1273586443.20312.14.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 11 May 2010 13:55:48 -0700
Message-ID: <AANLkTikKTOOV0NA53oVcr4ltb2zon1Tu5j1iR1p9lg5a@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mac80211: add offload channel switch support
To: Johannes Berg <johannes@sipsolutions.net>,
	David Quan <David.Quan@atheros.com>,
	Michael Green <Michael.Green@atheros.com>,
	Stephen Chen <Stephen.Chen@atheros.com>,
	Dan Tian <Dan.Tian@atheros.com>,
	Kevin Hayes <kevin@atheros.com>,
	Cliff Holden <Cliff.Holden@atheros.com>
Cc: wey-yi.w.guy@intel.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 11, 2010 at 7:00 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2010-05-06 at 14:58 -0700, Luis R. Rodriguez wrote:
>> On Thu, May 6, 2010 at 8:25 AM,  <wey-yi.w.guy@intel.com> wrote:
>> > From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

>> > with this offload approach, driver has more control on how to handle the
>> > channel switch request from AP, also can provide more accurate timing
>> > calculation
>>
>> Is the current timing insufficient, and if so can you provide more
>> details. If the real reason for this callback is not timing
>> considerations is the real reason a firmware API thing? If so it
>> doesn't hurt to just say that to avoid confusing developer in deciding
>> which approach to take.
>
> The current mac80211 approach is flawed, for various reasons which I
> won't get into here, most of which we can fix. However, due to
> regulatory concerns our firmware also wants to have more control, like
> checking that the AP is beaconing again after a channel switch before
> letting us transmit frames.

OK this makes perfect sense if the channel you are switching to is
also a DFS channel, but it sounds like something we can also implement
on mac80211, unless of course firmware can make that guarantee for us
quicker. This is the sort of explanation that I think might be very
useful to the driver developer when choosing which mac80211 CSA
operation to implement -- either the standard mac80211 implementation
or a driver specific one.

I take it this tries to resolve some sort of race condition where the
AP decided to switch to another DFS channel, told the STAs, went to
the other channel, and as it does the swtich gets radar signals and
needs to quite down.

> Timing is obviously also a consideration,
> since the firmware can re-enable transmission quickly after the channel
> switch, regardless of the delay in processing the frame or the timer on
> the host.

Reason for me asking for details about this was because I was
wondering whether the reasons for you guys implementing a separate CSA
callback could be addressed by adjusting the internal existing
mac80211 CSA implementation further. Timing constraints to re-enable
TX seem to be the biggest concern here since checking whether or not
the AP is beaconing *can* certainly be done on mac80211. Is there a
measurable TX drop due to the extra latency introduced by using a host
based implementation?

If a driver developer reads the documentation it would be nice for
them to easily get enough information to decide which approach to take
and to do that the more details we can provide the better. If we
haven't tested a mac80211 enhanced approach why not try that first?

>> > The drivers like to support the channel switch offloading function
>>
>> Maybe: "The drivers that require a dedicated channel switch callback"...
>>
>> > will have
>> > to provide the mactime information (at least for mgmt and action frames)
>>
>> Might be good to specify why, or at least in the documentation code below.
>
> Actually, it's up to them. But if you implement the callback, you'll
> want to know precisely when to expect the channel switch

Right, that was my point, it was not clear that this was the reason
for having it so it might help the developer if the documentation
stated that.

> so you'll want
> to know when the frame that contained the CSA was received, which you
> have to provide to mac80211 in the "mactime" rx status field.

Right, thanks for the details, I was just hoping we could clarify that
to the driver developers a little more on the patch.

>> > +/**
>> > + * ieee80211_chswitch_done - Complete channel switch process
>> > + * @vif: &struct ieee80211_vif pointer from the add_interface callback.
>> > + * @is_seccess: make the channel switch successful or not
>>
>> Typo, is_seccess, not success. Also, I don't get what this is for, can
>> you elaborate?
>
> Channel switching could fail, for instance if the AP doesn't show up on
> the new channel. We don't have a way to handle that yet in mac80211, but
> why not let it know.

Oh definitely I agree, I was just hoping this can be explained ont he
kdoc above, it was not clear from reading the code.

>> I'd appreciate more feedback on the why this is being done. Its not
>> clear to me how we are limited by the current implementation.
>
> Ok like I said -- timing is a big thing. Regulatory enforcement in our
> firmware is another.

Regulatory enforcement is already handled by the mac80211 CSA, the
check for beaconing on the channel we move to *can* be done by
mac80211 as well, so that would only leave timing constraints.

  Luis
