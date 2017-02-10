Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:35752 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750966AbdBJJsZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Feb 2017 04:48:25 -0500
Received: by mail-io0-f177.google.com with SMTP id j18so45727241ioe.2
        for <linux-wireless@vger.kernel.org>; Fri, 10 Feb 2017 01:48:25 -0800 (PST)
Received: from mail-it0-f46.google.com (mail-it0-f46.google.com. [209.85.214.46])
        by smtp.gmail.com with ESMTPSA id f42sm800535ioj.35.2017.02.10.01.39.45
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Feb 2017 01:39:45 -0800 (PST)
Received: by mail-it0-f46.google.com with SMTP id k200so43632545itb.1
        for <linux-wireless@vger.kernel.org>; Fri, 10 Feb 2017 01:39:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1486557177.24745.8.camel@sipsolutions.net>
References: <20170125114344.8179-1-andrew.zaborowski@intel.com>
 <20170125114344.8179-3-andrew.zaborowski@intel.com> <1486547933.24745.2.camel@sipsolutions.net>
 <CAOq732KyMG26f7X4NiOdChyF3Qq=X9YgvCunecai+UrQAByByA@mail.gmail.com> <1486557177.24745.8.camel@sipsolutions.net>
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
Date: Fri, 10 Feb 2017 10:39:45 +0100
Message-ID: <CAOq732LLG0UwwdUAimhosjVS+P98tiY=MsGAPFFkbtH1PNj_+A@mail.gmail.com> (sfid-20170210_104840_558244_1E64BCCE)
Subject: Re: [PATCH v4 3/5] cfg80211: Accept multiple RSSI thresholds for CQM
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 February 2017 at 13:32, Johannes Berg <johannes@sipsolutions.net> wrote:
>> > I think it would make sense to unconditionally apply the hysteresis
>> > to low/high, i.e. always set
>> >  low = low - hyst
>> >  high = high + hyst
>> >
>> > so that you get "sticky" ranges once you're in them?
>>
>> Yes, maybe that's better, I guess I want to avoid just adding a lag /
>> delay in reporting changes that are not due to measurement error or
>> temporary.  Could also do something in between, e.g. use "low - hyst"
>> if signal is close to low, otherwise just "low".
>
> That's sort of what you had, but except for the precise definition of
> "close", no?
>
> Actually, no, because you used "last - hyst" rather than "low - hyst"
> it's different. I think we can live with checking if it's close, say
> setting to "low - hyst" when it's within low + hyst - that avoids the
> problem I outlined above and gets a bit more responsiveness, I guess.

I sent a version with this logic but came up with values that would
still cause the continous events as in your example, specifically with
a hyst of 3 and the reported RSSI values jumping between -51 and -47.
This could be avoided by changing operators between "less than" and
"less or equal" but I eventually sent a version with the "sticky"
ranges you suggested, I think that is just as good.

Best regards
