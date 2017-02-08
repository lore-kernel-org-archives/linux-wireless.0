Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:36121 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752923AbdBHMBD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 07:01:03 -0500
Received: by mail-it0-f65.google.com with SMTP id f200so15298907itf.3
        for <linux-wireless@vger.kernel.org>; Wed, 08 Feb 2017 04:00:14 -0800 (PST)
Received: from mail-it0-f47.google.com (mail-it0-f47.google.com. [209.85.214.47])
        by smtp.gmail.com with ESMTPSA id e62sm11181431ioj.2.2017.02.08.03.26.13
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Feb 2017 03:26:13 -0800 (PST)
Received: by mail-it0-f47.google.com with SMTP id d9so33056646itc.0
        for <linux-wireless@vger.kernel.org>; Wed, 08 Feb 2017 03:26:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1486547933.24745.2.camel@sipsolutions.net>
References: <20170125114344.8179-1-andrew.zaborowski@intel.com>
 <20170125114344.8179-3-andrew.zaborowski@intel.com> <1486547933.24745.2.camel@sipsolutions.net>
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
Date: Wed, 8 Feb 2017 12:26:12 +0100
Message-ID: <CAOq732KyMG26f7X4NiOdChyF3Qq=X9YgvCunecai+UrQAByByA@mail.gmail.com> (sfid-20170208_130111_487190_4E1284B0)
Subject: Re: [PATCH v4 3/5] cfg80211: Accept multiple RSSI thresholds for CQM
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 8 February 2017 at 10:58, Johannes Berg <johannes@sipsolutions.net> wrote:
>
>> This method doesn't have a hysteresis parameter because there's no
>> benefit to the cfg80211 code from having the hysteresis be handled by
>> hardware/driver in terms of the number of wakeups.  At the same time
>> it would likely be less consistent between drivers if offloaded or
>> done in the drivers.
>
> I'm not really sure I buy this.
>
> What if I configure a few ranges, and let's say one of the boundaries
> is -50dBm. Now if I sit just on that value of -50dBm and thus my signal
> fluctuates say -48..-52, I'd have to continuously wake up the host.
>
> You try to avoid that here, I think:
>
> +       if (low > (s32) (last - hyst))
> +               low = last - hyst;
> +       if (high < (s32) (last + hyst))
> +               high = last + hyst;
>
> but it's not clear to me that this is effective?
>
> Let's see. last is -52, so low will be -60 and high will be -50.
>
> Let's say hyst is 3 since I chose the ranges so closely. I'm guessing a
> higher hysteresis and larger ranges would actually be better, but let's
> stick to this for the sake of the example.
>
> last-hyst = -55, so low isn't > that, low = -60
> last+hyst = -49, so high = -49
>
> but now it still fluctuates around -50, so if I next hit -48 you do the
> same dance again with -50/-40, getting -51/-40 and never really
> applying a full hysteresis, no?
>
> I'll probably see an intermediate value of -50 at some point, but I'll
> never actually *report* it, so "last" can switch between -48 and -52
> constantly in this scenario, no?

Yes, sounds like this could happen.

>
>
> I think it would make sense to unconditionally apply the hysteresis to
> low/high, i.e. always set
>  low = low - hyst
>  high = high + hyst
>
> so that you get "sticky" ranges once you're in them?

Yes, maybe that's better, I guess I want to avoid just adding a lag /
delay in reporting changes that are not due to measurement error or
temporary.  Could also do something in between, e.g. use "low - hyst"
if signal is close to low, otherwise just "low".

The question is how the current hysteresis parameter is defined, what
is expected of the firmware and how do driver authors decide whether
their firmware/hardware implements the same mechanism as expected by
the kernel.  Would the same thing happen with firmware implementations
if the hysteresis value is 3 and the rssi fluctuates by +/- 2?  Or
would it have to be +/- 3 or +/- 4 before this starts to happen.  (If
this isn't well specified then it makes more sense to try to do it in
one place for consistency.)

>
>
>
>> +     if (!wiphy_ext_feature_isset(&rdev->wiphy,
>> +
>>            NL80211_EXT_FEATURE_CQM_RSSI_LIST))
>> +             return
>> -EOPNOTSUPP;
>
>
> That check should be earlier in the function
> cfg80211_cqm_rssi_update(), no?

Oh looks like it can actually be removed in the current code because
nl80211_set_cqm_rssi already has this check and wdev->cqm_config can't
be set outside that function.

Best regards
