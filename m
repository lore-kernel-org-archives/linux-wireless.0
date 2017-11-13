Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:55680 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753801AbdKMRFb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 12:05:31 -0500
Subject: Re: Setting single rate in ath10k broken by "reject/clear user rate
 mask if not usable"
To: Johannes Berg <johannes@sipsolutions.net>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>, kirtika@google.com
References: <13895fa0-3685-dd2b-583d-2d6469d23cfe@candelatech.com>
 <1507708948.1998.15.camel@sipsolutions.net>
 <2c293255-aa79-75a0-1c28-994f864cddf4@candelatech.com>
 <1508312033.2674.9.camel@sipsolutions.net>
 <2ad42671-59c4-80ed-4bca-f874eb53d653@candelatech.com>
 <8c2e0e98-f3f4-6e0c-1bf0-43dfa6e97275@rempel-privat.de>
 <1508358869.2674.55.camel@sipsolutions.net>
 <9791c86a-a15f-4c99-ab84-ce00b242d70f@candelatech.com>
 <1508360527.2674.61.camel@sipsolutions.net>
 <0bfb289d-a9fa-03d9-f9c7-cc0d01b0bd43@candelatech.com>
 <1508944670.2421.49.camel@sipsolutions.net>
 <db23762d-3e65-7707-ca78-ad7e7bc7dfa6@candelatech.com>
 <1509135311.2283.12.camel@sipsolutions.net>
 <a1adb2ea-44c4-67ae-1044-08c4dc16bb9a@candelatech.com>
 <1510567783.30497.33.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <d2caa97d-50b0-94bd-9ee1-349e44cee1c8@candelatech.com> (sfid-20171113_180535_253826_D9521AD4)
Date: Mon, 13 Nov 2017 09:05:28 -0800
MIME-Version: 1.0
In-Reply-To: <1510567783.30497.33.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/13/2017 02:09 AM, Johannes Berg wrote:
> On Fri, 2017-10-27 at 13:41 -0700, Ben Greear wrote:
>
>> ath10k ignores the tx rateset pretty much entirely when sending management
>> frames, so even if you set the tx rateset to have only VHT MCS 8,
>> management frames are still sent with legacy ratesets.
>
> So that's a driver bug.

The firmware gives the ability to set a single fixed rate for
multicast, and another for management frames.  It is possibly to
set the tx-data frame rate to another fixed rate, or to a more
normal rateset.  But, you do not have full control over setting
tx-data rates (no way to tell stock firmware to use 6Mbps /g rate and
mcs 8 (only), for instance).  The multicast and mgt frame API is not hooked up in the
stock driver as far as I know.

But even if they were, I don't see a good way to make this fit
with the mac80211 txrate setting framework.

What is the suggested approach to propagate a rateset set with
'iw' to a firmware with these limitations?

For the Intel firmware NICs, how do they set management and bcast
tx rates?

>> My end goal about this part is to be able to configure a single tx rate
>> and have that be allowed again, at least with ath10k.
>>
>> Maybe a new flag for drivers like ath10k that at least somewhat ignore
>> the tx-rateset for management frames, and this flag would allow us to
>> bypass the cannot-set-single-rate check?
>
> What? No, I'm not going to put a driver bug into the API like that!

Thanks for the constructive feedback.

--Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
