Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:56162 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751915AbdJROug (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Oct 2017 10:50:36 -0400
Subject: Re: Setting single rate in ath10k broken by "reject/clear user rate
 mask if not usable"
To: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>, kirtika@google.com
References: <13895fa0-3685-dd2b-583d-2d6469d23cfe@candelatech.com>
 <1507708948.1998.15.camel@sipsolutions.net>
 <2c293255-aa79-75a0-1c28-994f864cddf4@candelatech.com>
 <1508312033.2674.9.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <2ad42671-59c4-80ed-4bca-f874eb53d653@candelatech.com> (sfid-20171018_165040_398739_B2F82E11)
Date: Wed, 18 Oct 2017 07:50:26 -0700
MIME-Version: 1.0
In-Reply-To: <1508312033.2674.9.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 10/18/2017 12:33 AM, Johannes Berg wrote:
> Hi,
>
>> The call to set the rate in the driver comes before the error
>> check.
>>
>> 	if (ieee80211_hw_check(&local->hw, HAS_RATE_CONTROL)) {
>> 		ret = drv_set_bitrate_mask(local, sdata, mask);
>> 		if (ret) {
>> 			pr_err("%s: drv-set-bitrate-mask had error
>> return: %d\n",
>> 			       sdata->dev->name, ret);
>> 			return ret;
>> 		}
>> 	}
>>
>> 	/*
>> 	 * If active validate the setting and reject it if it doesn't
>> leave
>> 	 * at least one basic rate usable, since we really have to be
>> able
>> 	 * to send something, and if we're an AP we have to be able to
>> do
>> 	 * so at a basic rate so that all clients can receive it.
>> 	 */
>> 	if (rcu_access_pointer(sdata->vif.chanctx_conf) &&
>> 	    sdata->vif.bss_conf.chandef.chan) {
>> 		u32 basic_rates = sdata->vif.bss_conf.basic_rates;
>> 		enum nl80211_band band = sdata-
>>> vif.bss_conf.chandef.chan->band;
>>
>> 		if (!(mask->control[band].legacy & basic_rates)) {
>> 			#### I changed this code so I could set a
>> single rate... --Ben
>> 			pr_err("%s:  WARNING: no legacy rates for
>> band[%d] in set-bitrate-mask.\n",
>> 			       sdata->dev->name, band);
>> 		}
>> 	}
>
> Heh, that's just dumb. I guess I'll fix that by putting the test first,
> no idea how that happened.
>
>>>
>>>> So, I think we should relax this check, at least for ath10k.
>>>
>>> Well, yes and no. I don't think we should make ath10k special here,
>>> and
>>> this fixes a real problem - namely that you can set up the system
>>> so
>>> that you have no usable rates at all, and then you just get a
>>> WARN_ON
>>> and start using the lowest possible rate...
>>
>> Well, there are a million ways to set up a broken system,
>
> True, but this one actually happened in practice, for some reason, and
> stopping the user from constantly shooting themselves in the foot seems
> like a good idea to me. Especially if the user (or application) can't
> really even know what they're getting into.
>
> Now, the case in question was _client_ mode, but still.
>
>> and setting a single rate has a useful purpose, especially with
>> ath10k since it has such limited rate-setting capabilities.
>
> You're stretching the definition of "useful purpose" a bit here though,
> you're about the only one who's ever going to need to set a single
> rate.

People trying to do regulatory testing want this feature, and other people
that are not me also like to test with specific rates.  Still a small-ish set
of people, but bigger than just me at least.

This used to work, and now is broken, so it is a regression of at least somewhat
useful feature.  I think we need a way to re-enable this, even if it requires
poking some sysfs or debugfs file to allow this check to be relaxed.

And for that matter, it might be nice to allow purposefully broken ratesets
(with part of basic missing, for instance), in order to test peer devices (including
other Linux stacks).

>> There is basically never going to be a case where setting a single
>> tx-rate on an AP is a good idea in a general production environment,
>> so maybe a possible WARN-ON is fine?
>
> A WARN_ON() for a user configuration is never fine.
>
> You're assuming that there's actually a user sitting there and doing
> this, which is not necessarily the case.
>
> Even rejecting a single rate setting wouldn't be enough because you can
> get into problems even when you enable multiple rates, e.g. if you
> enable all the CCK rates while connected on 5 GHz.
>
>> If you *do* set up an AP with a limited rateset, then it should
>> simply fail to allow a station to connect if it does not have any
>> matching rates.
>
> That's what requiring at least one basic rate to remain does. If you
> want to have basic rates 6,9,12 and then configure only 18, how would
> the client get rejected? Just configure basic rates differently
> beforehand, and then you can do this easily, and the right thing with
> rejecting clients will happen automatically (in fact, clients might not
> even attempt to connect - even better!)
>
>> This might go back to a previous idea I had (and patches I posted and
>> carry in my tree) to allow setting a different advertise rateset vs
>> usable tx-rateset.
>
> You still have the same problem with which clients support them and
> require them etc.

For regulatory testing purposes:  You can advertise normal basic rateset,
and you can accept those (and even transmit mgt and bcast frames on them),
but for data tx, you use a single fixed rate.  That is one reason it is nice
to have the advertised rateset different from the tx rateset.


>> For existing stations that might not match the new fixed rate, we
>> could purposefully kick them off I guess, but seems like a lot of
>> work for a case that seems pretty irrelevant.
>
> For better or worse, there are people using this API programmatically
> without a user baby-sitting it, so we need to make it work in all
> cases. We can let the user shoot themselves in the foot and have only a
> single usable rate left, but we can't let them hang themselves and have
> no rate left at all.

Out of curiosity, couldn't 'iw' do the same checks?  It is a lot easier to
return a useful error code/message from a user-space app anyway, in case that
can work.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
