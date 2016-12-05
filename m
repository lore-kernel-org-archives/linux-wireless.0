Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:41058 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751373AbcLEPUF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 10:20:05 -0500
Message-ID: <5845827B.2000000@candelatech.com> (sfid-20161205_162035_026544_E6F88BDC)
Date: Mon, 05 Dec 2016 07:06:35 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
        Michal Kazior <michal.kazior@tieto.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH 1/2] mac80211: do not iterate active interfaces when in
 re-configure
References: <1480645800-2148-1-git-send-email-greearb@candelatech.com>   <CA+BoTQkEaC-ZSbeK=JB=q+ucF1PWcEQXkJEp6JYv4pfOf35cHg@mail.gmail.com>    (sfid-20161205_092619_855272_0854B225) <1480945950.31788.4.camel@sipsolutions.net>      <58458058.5020008@candelatech.com> <1480950054.31788.36.camel@sipsolutions.net>
In-Reply-To: <1480950054.31788.36.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 12/05/2016 07:00 AM, Johannes Berg wrote:
> On Mon, 2016-12-05 at 06:57 -0800, Ben Greear wrote:
>
>> I think clearing sdata-in-driver would fix the ath10k problem, at
>> least, but I was afraid it would break something else in mac80211 or
>> maybe in other thick firmware drivers.
>
> It's pretty much an internal thing - not sure what it'd break. OTOH,
> some drivers might actually assume that iterating finds them all, if
> they never clear the data even across a restart?
>
>> One way or another, we cannot be iterating over interfaces while
>> the interfaces are at the same time being (re)added.
>
> Well, we obviously *can* be, and we do in fact do that - it's just that
> ath10k specifically has issues with the data it's putting there, no?

It causes races that appear to be very difficult to resolve in the
driver alone.  On normal bringup of an interface, the sdata-in-driver
flag is only set at the bottom of the add-interface.  In case of re-config,
the flag is already set, and never cleared, so behaviour is different
w/regard to the iterate.

>
>> Maybe mac80211 should explicitly remove all interfaces from the
>> driver during crash recovery?
>
> I don't think that'll work. Removing them would interact with the
> firmware, which is dead, etc. That'd just cause trouble.

That issue already causes trouble and is dealt with in ath10k, I think,
but clearing the flag in mac80211 would probably be enough to fix the
iterate logic.

>> And the behaviour needs to be clearly documented somewhere
>> easy to find so that we can think about and program to the correct
>> API behaviour.
>
> We assume that the driver resets all its internal state - this whole
> interface iteration is a corner case we hadn't considered, I suppose.

Yeah, tricky beastie.  I think the txq issue is also part of this since there
are references up in mac80211 and also down in ath10k.  Part of my hack
to clean up that crash might be resolved by mac80211 doing better cleanup
API when firmware crashes.

Thanks,
Ben

>
> johannes
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
