Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from edge01.uni-rostock.de ([139.30.8.12]:19950 "EHLO
        edge01.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751360AbcKNOsk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 09:48:40 -0500
Subject: Re: [RFC] change mac80211_hwsim tx_rates to ieee80211_tx_rate
To: Johannes Berg <johannes@sipsolutions.net>,
        <linux-wireless@vger.kernel.org>
References: <dcc2ec52-abe0-3182-e7f5-d1df40fd492b@uni-rostock.de>
 <1478984929.4226.3.camel@sipsolutions.net>
 <faf081ea-18c6-8ad5-e336-aac9a79a0ce3@uni-rostock.de>
 <1479132555.12007.6.camel@sipsolutions.net>
From: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>
Message-ID: <838c443a-f8aa-ab21-61b0-9352f24442b1@uni-rostock.de> (sfid-20161114_154844_046965_F9C1696D)
Date: Mon, 14 Nov 2016 15:48:36 +0100
MIME-Version: 1.0
In-Reply-To: <1479132555.12007.6.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I agree with that, but there exist also other code in hwsim, which is
>> tightly coupled with the mac80211 API, as e.g., the usage of
>> IEEE80211_TX_MAX_RATES, which already broke older versions of
>> wmediumd or similar implementations. Maybe a review regarding such
>> things would be good to decouple the userspace daemon from the
>> special kernel version.
> Agree. It'd be better if that were using nested attributes etc.
> Although then again, to really decouple this we should make hwsim
> behave towards wmediumd more like real hardware would, and have it pass
> just a single rate to userspace, with only success/fail indication
> coming back - if it fails, it could walk down the chain of rates
> itself. Right now we let wmediumd do this, which is why we have all
> these API internals exposed to it.
Mhh, I thought also some atheros drivers implement hardware multirate
retry changes, which maps to this struct. Only one rate per frame would
introduce a extreme additional communication overhead, which will make
testing with standard wmediumd impractical. I think we need to keep such
a structure, but we should align that with other mac80211 depended drivers.
>
>>>> but I think that will break up the communication to e.g. bob
>>>> copelands
>>>> wmediumd and similar simulations. I would like to have our
>>>> Implementation working with mainline kernels and therefore ask
>>>> how we
>>>> could achieve this easily.
>>>>
>>>> Obviously, we could define another field in the hwsim messages,
>>>> but
>>>> as bob copeland already stated, significantly more information
>>>> within
>>>> the netlink messages could  intensify the timing overhead of
>>>> hwsim.
>>> I don't think we have any other choice but add the relevant fields
>>> as
>>> proper attributes.
>> I'm totally fine with that. Nonetheless,  I would suggest to add the
>> flags to "struct hwsim_tx_rate", since the flags are also tightly
>> coupled to the rates and tries of a frame. To not break up things, we
>> could add the flags as a separate attribute in the struct and not as
>> part of the bitfield like in the original. This would be possible,
>> due
>> to the "__packed" flag, but I'm also unsure, whether this is a really
>> good idea for a userspace API/ABI.
> Changing the struct size itself would break ABI though?

You are totally right ... I was a bit absent. But the point is, without
the rates and tries, the flags are useless, so I think it is better to
put them together, but I'm also fine with another attribute ;-)


Benjamin
