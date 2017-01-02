Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35472 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756337AbdABWMy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jan 2017 17:12:54 -0500
MIME-Version: 1.0
In-Reply-To: <1483379548.15591.1.camel@sipsolutions.net>
References: <20170102163209.2445-1-zajec5@gmail.com> <20170102163209.2445-2-zajec5@gmail.com>
 <1483379548.15591.1.camel@sipsolutions.net>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Mon, 2 Jan 2017 23:12:53 +0100
Message-ID: <CACna6ryrYY5G=Fvmsrq_sD3iX5dWreyz7R8mGEd6ogUck=twnQ@mail.gmail.com> (sfid-20170102_231320_288316_3CD99C77)
Subject: Re: [PATCH V3 2/2] cfg80211: support ieee80211-freq-limit DT property
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 January 2017 at 18:52, Johannes Berg <johannes@sipsolutions.net> wrote=
:
>> +static void wiphy_freq_limits_apply(struct wiphy *wiphy)
> [...]
>> +                     if (!wiphy_freq_limits_valid_chan(wiphy,
>> chan)) {
>> +                             pr_debug("Disabling freq %d MHz as
>> it's out of OF limits\n",
>> +                                      chan->center_freq);
>> +                             chan->flags |=3D
>> IEEE80211_CHAN_DISABLED;
>
> I think you didn't address the problem in the best way now.
>
> The problem with the channel sharing was the way you're applying the
> limits - at runtime. This is now OK since the new function shouldn't be
> called when the channel structs are shared, but hooking it all into the
> regulatory code is now no longer needed.
>
> What you can do now, when reading the OF data, is actually apply it to
> the channel flags immediately. If done *before* wiphy_register(), these
> flags will be preserved forever, so you no longer need any hooks in
> regulatory code at all - you can just set the original channel flags
> according to the OF data.
>
> I think this greatly simplifies the flow, since you can also remove
> wiphy->freq_limits (and n_freq_limits) completely, since now the only
> effect of the function would be to modify the channel list, and later
> regulatory updates would always preserve the flags.

I need some extra help understanding this :(

When driver uses custom regulatory it registers initial channels at
init but it can also react to regdom changes using reg_notifier. Is
that correct?

So I'm looking at brcmf_cfg80211_reg_notifier which calls
brcmf_setup_wiphybands which calls brcmf_construct_chaninfo.
That last one reworks all channels on every call. It first marks all
existing channels as DISABLED then queries firmware for the list of
supported channels and updates wiphy channels one by one.
So if I understand this correctly, every regdom change can result in
rebuilding channels pretty much from the scratch. That's why I
believed I need to call wiphy_freq_limits_apply on runtime, not just
during the init.

Is there some flow in my understanding?

--=20
Rafa=C5=82
