Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:46454 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754465AbcKURTc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Nov 2016 12:19:32 -0500
Subject: Re: Break-it testing for wifi
To: Steve deRosier <derosier@gmail.com>
References: <a60dac22-655e-ea93-61c2-73db05a47572@candelatech.com>
 <CALLGbR+q=QKLgXj6jYJ_jUdvrh2GcOk_3NkndTf2JWZsOqzecQ@mail.gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <2b45f426-0451-0c8b-49fe-4c50adb03514@candelatech.com> (sfid-20161121_181936_534575_EF250D30)
Date: Mon, 21 Nov 2016 09:19:31 -0800
MIME-Version: 1.0
In-Reply-To: <CALLGbR+q=QKLgXj6jYJ_jUdvrh2GcOk_3NkndTf2JWZsOqzecQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/21/2016 08:55 AM, Steve deRosier wrote:
>
>
> On Mon, Nov 21, 2016 at 8:10 AM, Ben Greear <greearb@candelatech.com <mailto:greearb@candelatech.com>> wrote:
>
>     Hello!
>
>     I am thinking about adding some sort of framework to wpa_supplicant and/or the
>     mac80211 stack to allow purposefully creating bad station behaviour in order to
>     test robustness of APs.
>
>     Some ideas so far:
>
>     1)  Allow supplicant to do bad state-machine transitions (start 4-way before associating, for instance).
>
>     2)  Randomly corrupt mgt frames in driver and/or mac80211 stack and/or supplicant.
>
>     3)  Possibly allow user to make specific corruptions.  This would probably be in supplicant
>         only, and I am not sure how this would be configured.  Maybe allow user to over-ride
>         existing IEs and add bogus ones of their own choosing.
>
>     4)  Maybe some specific tests like putting in over-flow sized lengths of IEs.
>
>     Has anyone done anything similar they would like to share?
>
>     Johannes:  Any interest in having such a framework in upstream kernels?
>
>     Any other ideas for how to improve this feature set?
>
>     Thanks,
>     Ben
>
>
> Hi Ben,
>
> I did something related to this many years ago using the radiotap interface and based on Andy Green's work.  It's very limited but might be interesting.
>
> https://github.com/derosier/packetvector
>
> I would absolutely welcome such a tool. I'd like it to be useful for testing clients and mesh nodes in addition to APs, but I don't think that's a big stretch.
>
> I guess my only comment is if it's possible for this to be in userspace, that's where'd like to see it. If not, some sort of framework we all could use would be
> nice. All in one place would also be nice, but as you've got multiple independent components that cooperate that might be difficult to achieve.

[re-added linux-wireless to CC]

Some things, like probe requests, are created as far down as the firmware (ath10k, for instance).
Some IEs are made in mac80211 as well.

And, ath10k (and likely other thick-firmware implementations) is crap for packet injection.

I think the closer I can be to 'real' supplicant, stack & driver behaviour, the better chance I have of finding
more interesting bugs.

So, I don't think a pure user-space app is that useful for my desired testing scenario.

My specific goal is testing APs, but I think it should work fine for testing other
connection types.

If I made some generic code to mangle management frames, including parsing IEs and re-writing
them and such (as well as randomly bit-flipping as requested), maybe it could be called from
tx logic in mac80211.  Corrupting things in the stack might help harden the drivers (and firmware)
a bit on the sending path, and might work for generic network devices.  Possibly I would need to add hooks in the
driver as well if frames were actually generated there.  For probe requests, I might have to
really hack all the way down into the firmware to have full control for corrupting that.

Since probe requests don't require much state, possibly that is a place where a relatively
dumb user-space packet injection would be best.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
