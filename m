Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40258 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932335AbaDVSDw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 14:03:52 -0400
Message-ID: <5356AEF0.1000208@candelatech.com> (sfid-20140422_200406_426272_5C64EF46)
Date: Tue, 22 Apr 2014 11:03:28 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Felix Fietkau <nbd@openwrt.org>, ath9k-devel@venema.h4ckr.net,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k:  Prevent divide by zero kernel crash.
References: <1397695240-13710-1-git-send-email-greearb@candelatech.com> <534F870E.80209@openwrt.org> <20140422175322.GA16193@tuxdriver.com>
In-Reply-To: <20140422175322.GA16193@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/22/2014 10:53 AM, John W. Linville wrote:
> Please consider Felix's comments while refactoring this for the
> current code structure...

I'm low on time, but will resend a patch when I get a chance.

If someone else wants to send in the updated patch that is fine by me.

Thanks,
Ben

> 
> John
> 
> On Thu, Apr 17, 2014 at 09:47:26AM +0200, Felix Fietkau wrote:
>> On 2014-04-17 02:40, greearb@candelatech.com wrote:
>>> From: Ben Greear <greearb@candelatech.com>
>>>
>>> Make sure we cannot ever assign beacon interval to zero.
>>>
>>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>>> ---
>>>  drivers/net/wireless/ath/ath9k/beacon.c | 4 ++++
>>>  drivers/net/wireless/ath/ath9k/recv.c   | 3 ++-
>>>  2 files changed, 6 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
>>> index 2e8bba0..5391f01 100644
>>> --- a/drivers/net/wireless/ath/ath9k/beacon.c
>>> +++ b/drivers/net/wireless/ath/ath9k/beacon.c
>>> @@ -443,6 +443,8 @@ static u32 ath9k_mod_tsf64_tu(u64 tsf, u32 div_tu)
>>>  {
>>>  	u32 tsf_mod, tsf_hi, tsf_lo, mod_hi, mod_lo;
>>>  
>>> +	if (WARN_ON_ONCE(div_tu == 0))
>>> +		div_tu = 100;
>>>  	tsf_mod = tsf & (BIT(10) - 1);
>>>  	tsf_hi = tsf >> 32;
>>>  	tsf_lo = ((u32) tsf) >> 10;
>> Why add this warning here if you already have the additions below? We
>> don't need multiple layers of defensive checks for the same thing.
>>
>>> @@ -667,6 +669,8 @@ static void ath9k_cache_beacon_config(struct ath_softc *sc,
>>>  		"Caching beacon data for BSS: %pM\n", bss_conf->bssid);
>>>  
>>>  	cur_conf->beacon_interval = bss_conf->beacon_int;
>>> +	if (WARN_ON_ONCE(cur_conf->beacon_interval == 0))
>>> +		cur_conf->beacon_interval = 100;
>>>  	cur_conf->dtim_period = bss_conf->dtim_period;
>>>  	cur_conf->listen_interval = 1;
>>>  	cur_conf->dtim_count = 1;
>>> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
>>> index b97217d..79c20c7 100644
>>> --- a/drivers/net/wireless/ath/ath9k/recv.c
>>> +++ b/drivers/net/wireless/ath/ath9k/recv.c
>>> @@ -538,7 +538,8 @@ static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)
>>>  		sc->ps_flags &= ~PS_BEACON_SYNC;
>>>  		ath_dbg(common, PS,
>>>  			"Reconfigure beacon timers based on synchronized timestamp\n");
>>> -		ath9k_set_beacon(sc);
>>> +		if (!(WARN_ON_ONCE(sc->cur_beacon_conf.beacon_interval == 0)))
>>> +			ath9k_set_beacon(sc);
>>>  	}
>>>  
>>>  	if (ath_beacon_dtim_pending_cab(skb)) {
>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

