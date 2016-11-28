Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:36100 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755100AbcK1Urk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 15:47:40 -0500
Received: by mail-qk0-f173.google.com with SMTP id n21so153463005qka.3
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2016 12:47:39 -0800 (PST)
Subject: Re: [RFC V2 4/5] nl80211: add support for gscan
To: Johannes Berg <johannes@sipsolutions.net>
References: <1479388726-3288-1-git-send-email-arend.vanspriel@broadcom.com>
 <1479388726-3288-5-git-send-email-arend.vanspriel@broadcom.com>
 <1480343886.8107.55.camel@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <81830cfc-306a-f3f5-da7a-bef258c62e84@broadcom.com> (sfid-20161128_214743_559742_927A4779)
Date: Mon, 28 Nov 2016 21:47:33 +0100
MIME-Version: 1.0
In-Reply-To: <1480343886.8107.55.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28-11-2016 15:38, Johannes Berg wrote:
> 
>>   *	the nl80211 feature flags for the device.
>> + * @NL80211_SCAN_FLAGS_IE_DATA: request the device to supply IE data
>> in the
>> + *	request.
> 
> What does that mean?

I meant "supply IE data in the result". So it informs the driver that
user-space is interested in IE data, but I guess it does not need to be
explicit. It is not today.

The result reporting is still something I am not sure about. I would
prefer to use the bss list in cfg80211 like all other scan functions,
but I am not sure if that is sufficient for user-space functionality. I
did not get a clear answer on that for Android.

>> + * @NL80211_GSCAN_CHAN_ATTR_NO_IR: scanning should be done passive.
> 
> why not call that passive? No-IR is something we use in regulatory code
> to be more generic than "passive" (since it's also about beaconing
> etc.) but here?

Ok. Makes sense as we are talking just probe requests here and passive
scanning is familiar term.

>> + * @NL80211_GSCAN_CHAN_ATTR_MAX: highest GScan channel attribute.
> 
> Generally, you should also document the attribute types here (and
> everywhere else really)

Will do.

>> +	NL80211_BUCKET_BAND_2GHZ	= (1 << 0),
> 
> no need for parentheses with enums :)

Ok.

>> +	if (tb[NL80211_GSCAN_CHAN_ATTR_DWELL_TIME])
>> +		chan->dwell_time =
>> nla_get_u32(tb[NL80211_GSCAN_CHAN_ATTR_DWELL_TIME]);
> 
> Maybe that should have some kind of "reasonable range" limit?

Agree.
> So I mostly looked at this from a pure code POV - need to compare with
> our implementation, but I guess the basis is the same ...

Given its origin I would guess so too. What I propose here is minimal
behavior so just the logic around the buckets. I wanted to add features
like BSS hotlist and ePNO stuff in separate patches.

Apart from that the iwlwifi implementation has some differences in
details like attribute validation and there is no base period attribute
as that must be the gcd of the bucket periods. So I might drop that as well.

Regards,
Arend
