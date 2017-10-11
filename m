Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:48390 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751811AbdJKOvq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2017 10:51:46 -0400
Subject: Re: Setting single rate in ath10k broken by "reject/clear user rate
 mask if not usable"
To: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>, kirtika@google.com,
        Johannes Berg <johannes.berg@intel.com>
References: <13895fa0-3685-dd2b-583d-2d6469d23cfe@candelatech.com>
 <1507708948.1998.15.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <2c293255-aa79-75a0-1c28-994f864cddf4@candelatech.com> (sfid-20171011_165301_928671_9EBC0DB5)
Date: Wed, 11 Oct 2017 07:51:44 -0700
MIME-Version: 1.0
In-Reply-To: <1507708948.1998.15.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 10/11/2017 01:02 AM, Johannes Berg wrote:
> Hi,
>
>> #iw dev vap206 set bitrates legacy-5 ht-mcs-5 0 vht-mcs-5
>> command failed: Invalid argument (-22)
>>
>> But, it actually *does* successfully set the rate in the driver
>> first, which is confusing at best.
>
> Huh?

The call to set the rate in the driver comes before the error
check.

	if (ieee80211_hw_check(&local->hw, HAS_RATE_CONTROL)) {
		ret = drv_set_bitrate_mask(local, sdata, mask);
		if (ret) {
			pr_err("%s: drv-set-bitrate-mask had error return: %d\n",
			       sdata->dev->name, ret);
			return ret;
		}
	}

	/*
	 * If active validate the setting and reject it if it doesn't leave
	 * at least one basic rate usable, since we really have to be able
	 * to send something, and if we're an AP we have to be able to do
	 * so at a basic rate so that all clients can receive it.
	 */
	if (rcu_access_pointer(sdata->vif.chanctx_conf) &&
	    sdata->vif.bss_conf.chandef.chan) {
		u32 basic_rates = sdata->vif.bss_conf.basic_rates;
		enum nl80211_band band = sdata->vif.bss_conf.chandef.chan->band;

		if (!(mask->control[band].legacy & basic_rates)) {
			#### I changed this code so I could set a single rate... --Ben
			pr_err("%s:  WARNING: no legacy rates for band[%d] in set-bitrate-mask.\n",
			       sdata->dev->name, band);
		}
	}

>
>> So, I think we should relax this check, at least for ath10k.
>
> Well, yes and no. I don't think we should make ath10k special here, and
> this fixes a real problem - namely that you can set up the system so
> that you have no usable rates at all, and then you just get a WARN_ON
> and start using the lowest possible rate...

Well, there are a million ways to set up a broken system, and setting a single
rate has a useful purpose, especially with ath10k since it has such limited
rate-setting capabilities.

There is basically never going to be a case where setting a single tx-rate on an
AP is a good idea in a general production environment, so maybe a possible WARN-ON is fine?

If you *do* set up an AP with a limited rateset, then it should simply fail to
allow a station to connect if it does not have any matching rates.  This might go
back to a previous idea I had (and patches I posted and carry in my tree) to allow setting a different
advertise rateset vs usable tx-rateset.

For existing stations that might not match the new fixed rate, we could purposefully kick
them off I guess, but seems like a lot of work for a case that seems pretty irrelevant.

>
>> commit e8e4f5280ddd0a7b43a795f90a0758e3c99df6a6
>> Author: Johannes Berg <johannes.berg@intel.com>
>> Date:   Wed Mar 8 11:12:10 2017 +0100
>>
>>      mac80211: reject/clear user rate mask if not usable
>>
>>      If the user rate mask results in no (basic) rates being usable,
>>      clear it. Also, if we're already operating when it's set, reject
>>      it instead.
>>
>>      Technically, selecting basic rates as the criterion is a bit too
>>      restrictive, but calculating the usable rates over all stations
>>      (e.g. in AP mode) is harder, and all stations must support the
>>      basic rates. Similarly, in client mode, the basic rates will be
>>      used anyway for control frames.
>
> I guess you could implement this part? I.e. iterating the clients and
> checking that they all support the rate that is set. However, then you
> also need to implement that this gets reset when a new client that
> doesn't support this rate connects.
>
> Overall, this isn't very well defined for AP mode...
>
> Perhaps it'd be better - as you pointed out in the other thread - to
> have API to force a rate per station? We already have that for iwlwifi
> in debugfs, so perhaps that'd be something to consider for this too,
> I'm not sure there would be a real need to have it in nl80211?

I looked closely at the ath10k firmware yesterday, and it has no way to set a specific
single rate per peer.  Sure, I could hack something into my CT firmware, but that
still leaves all the stock driver/firmware people out of luck, and my patches
won't make it upstream in the main kernel...

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
