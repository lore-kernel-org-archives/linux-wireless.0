Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-3.exch022.serverdata.net ([206.225.164.186]:59122
	"EHLO HUB022-nj-3.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750803Ab2IEEpg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 00:45:36 -0400
Message-ID: <5046D8E9.3050505@posedge.com> (sfid-20120905_064604_260904_43D995BE)
Date: Wed, 5 Sep 2012 10:15:29 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [RFC] cfg80211: VHT regulatory
References: <50457491.9020604@posedge.com> <1346747134.3737.10.camel@jlt4.sipsolutions.net>
In-Reply-To: <1346747134.3737.10.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/04/2012 01:55 PM, Johannes Berg wrote:
> On Tue, 2012-09-04 at 08:55 +0530, Mahesh Palivela wrote:
>>    net/wireless/reg.c     |  104
>> ++++++++++++++++++++++++++++++++++++++++++++++++
>
> Even for an RFC patch it'd be nice to not mangle it :)
>

My email text editor issue. wrapping more than 80 char.

>> + * @center_freq2: center frequency of 2 nd frequency segment
>
> I'd add a note here that the 2nd is only used for 80+80
>

Sure

>> + * @prim_chan_freq: primary channel frequency
>
> You said you wanted to change it to be like the standard, that's not how
> it works though, the standard says (copying from your email)
>
> dot11CurrentPrimaryChannel
>         Denotes the location of the primary 20 MHz channel.
>         Valid range is 1 to 200.
>

 From that number we derive freq in kHZ. Even center freq also mentioned 
as number only. we need to use formula to derive freq in kHZ. Thought 
better hostapd convert numbers to freq value.

>> +	left_end_freq -= MHZ_TO_KHZ(10);
>> +	right_end_freq -= MHZ_TO_KHZ(10);
>
> Hmm? Shouldn't you add 10 MHz to the lower end, if anything?
>

Nope. For example 80 MHz BW, take channel 36, 40, 44 and 48. Center freq 
value is chan 42. so left end will be chan 34 and right end will be chan 
50. so I am subtracting 10MHz on both ends to get chan 36 and 48
Hope I made it clear.

>> +	/* find out all possible secondary channels */
>> +	while (left_end_freq < right_end_freq) {
>> +		chan = ieee80211_get_channel(wiphy, left_end_freq);
>
> Overall I'm not sure I'd go to the channel structs for this function at
> all though, I'd rather go to the regulatory definition, I think that
> would make more sense.
>
> OTOH, this may be needed to keep the ability for the driver to disable
> certain channels etc.
>
>> +	const struct ieee80211_reg_rule *reg_rule = NULL;
>> +	const struct ieee80211_freq_range *freq_range = NULL;
>
> Don't initialize to values you don't need.
>

Sure, will remove inits.

>> +	case IEEE80211_CHAN_WIDTH_80P80MHZ:
>> +		desired_bw_khz = MHZ_TO_KHZ(160);
>
> This is not true at all.
>

ok, will change to 80 MHz

>> +		break;
>> +	}
>
> Missing a default case with a warning/error return?
>

ok, will add default.

>> +	r = freq_reg_info_regd(wiphy,
>> +			       chan_config->prim_chan_freq,
>> +			       desired_bw_khz,
>> +			       &reg_rule,
>> +			       regd);
>> +
>> +	if (r) {
>> +		REG_DBG_PRINT("Disabling freq %d MHz as custom "
>> +			      "regd has no rule that fits a %d MHz "
>> +			      "wide channel\n",
>> +			      chan_config->prim_chan_freq,
>> +			      KHZ_TO_MHZ(desired_bw_khz));
>
> That's not a good message in this context now. Clearly it came from the
> channel flag settings, but now we don't do that so ...

OK. I will modify REG_DBG_PRINT()

>
> johannes
>
