Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35139 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933434AbdABWQN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jan 2017 17:16:13 -0500
MIME-Version: 1.0
In-Reply-To: <e194b980-1048-8da6-624b-26f824ff655d@broadcom.com>
References: <20170102163209.2445-1-zajec5@gmail.com> <20170102163209.2445-2-zajec5@gmail.com>
 <1483379548.15591.1.camel@sipsolutions.net> <e194b980-1048-8da6-624b-26f824ff655d@broadcom.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Mon, 2 Jan 2017 23:16:12 +0100
Message-ID: <CACna6rx5fMFVyjB=4=ZeXhfXWGPQmKiEQuJRY+mz2OFMLYx_HA@mail.gmail.com> (sfid-20170102_231658_135030_9C3C5B0C)
Subject: Re: [PATCH V3 2/2] cfg80211: support ieee80211-freq-limit DT property
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 January 2017 at 21:12, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 02-01-17 18:52, Johannes Berg wrote:
>>> +static void wiphy_freq_limits_apply(struct wiphy *wiphy)
>> [...]
>>> +                    if (!wiphy_freq_limits_valid_chan(wiphy,
>>> chan)) {
>>> +                            pr_debug("Disabling freq %d MHz as
>>> it's out of OF limits\n",
>>> +                                     chan->center_freq);
>>> +                            chan->flags |=3D
>>> IEEE80211_CHAN_DISABLED;
>>
>> I think you didn't address the problem in the best way now.
>>
>> The problem with the channel sharing was the way you're applying the
>> limits - at runtime. This is now OK since the new function shouldn't be
>> called when the channel structs are shared, but hooking it all into thes
>> regulatory code is now no longer needed.
>>
>> What you can do now, when reading the OF data, is actually apply it to
>> the channel flags immediately. If done *before* wiphy_register(), these
>> flags will be preserved forever, so you no longer need any hooks in
>> regulatory code at all - you can just set the original channel flags
>> according to the OF data.
>
> I suppose this then can also be done early in the wiphy_register()
> function itself, right?

When driver calls wiphy_apply_custom_regulatory I need to already have
limits read from the DT (at least in my current implementation, it may
change, but I need help understanding flow first). As
wiphy_apply_custom_regulatory has to be called before wiphy_register,
I can't read DT so late (in wiphy_register).

--=20
Rafa=C5=82
