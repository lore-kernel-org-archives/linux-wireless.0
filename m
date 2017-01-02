Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wj0-f181.google.com ([209.85.210.181]:36840 "EHLO
        mail-wj0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932887AbdABUML (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jan 2017 15:12:11 -0500
Received: by mail-wj0-f181.google.com with SMTP id c11so226118494wjx.3
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jan 2017 12:12:10 -0800 (PST)
Subject: Re: [PATCH V3 2/2] cfg80211: support ieee80211-freq-limit DT property
To: Johannes Berg <johannes@sipsolutions.net>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        linux-wireless@vger.kernel.org
References: <20170102163209.2445-1-zajec5@gmail.com>
 <20170102163209.2445-2-zajec5@gmail.com>
 <1483379548.15591.1.camel@sipsolutions.net>
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <e194b980-1048-8da6-624b-26f824ff655d@broadcom.com> (sfid-20170102_211327_953206_E3CB8D5C)
Date: Mon, 2 Jan 2017 21:12:07 +0100
MIME-Version: 1.0
In-Reply-To: <1483379548.15591.1.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 02-01-17 18:52, Johannes Berg wrote:
>> +static void wiphy_freq_limits_apply(struct wiphy *wiphy)
> [...]
>> +			if (!wiphy_freq_limits_valid_chan(wiphy,
>> chan)) {
>> +				pr_debug("Disabling freq %d MHz as
>> it's out of OF limits\n",
>> +					 chan->center_freq);
>> +				chan->flags |=
>> IEEE80211_CHAN_DISABLED;
> 
> I think you didn't address the problem in the best way now.
> 
> The problem with the channel sharing was the way you're applying the
> limits - at runtime. This is now OK since the new function shouldn't be
> called when the channel structs are shared, but hooking it all into thes 
> regulatory code is now no longer needed.
> 
> What you can do now, when reading the OF data, is actually apply it to
> the channel flags immediately. If done *before* wiphy_register(), these
> flags will be preserved forever, so you no longer need any hooks in
> regulatory code at all - you can just set the original channel flags
> according to the OF data.

I suppose this then can also be done early in the wiphy_register()
function itself, right?

> I think this greatly simplifies the flow, since you can also remove
> wiphy->freq_limits (and n_freq_limits) completely, since now the only
> effect of the function would be to modify the channel list, and later
> regulatory updates would always preserve the flags.

So does it mean the function can go in core.c again :-p If it is likely
there will be other properties being added it might justify adding a new
source file, eg. of.c, and only compile it when CONFIG_OF is set. Just a
thought.

Regards,
Arend
