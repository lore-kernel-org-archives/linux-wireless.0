Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:48317 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756408Ab1KHVGJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 16:06:09 -0500
Message-ID: <4EB999BE.8050909@candelatech.com> (sfid-20111108_220613_688483_083D57C5)
Date: Tue, 08 Nov 2011 13:06:06 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v8 2/2] mac80211:  Support ht-cap over-rides.
References: <1320780995-30483-1-git-send-email-greearb@candelatech.com>  <1320780995-30483-2-git-send-email-greearb@candelatech.com>  (sfid-20111108_203659_989707_E33ECA13) <1320782949.24797.45.camel@jlt3.sipsolutions.net>  <4EB994A1.1020808@candelatech.com> <1320785889.24797.75.camel@jlt3.sipsolutions.net>
In-Reply-To: <1320785889.24797.75.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/08/2011 12:58 PM, Johannes Berg wrote:
> On Tue, 2011-11-08 at 12:44 -0800, Ben Greear wrote:
>> On 11/08/2011 12:09 PM, Johannes Berg wrote:
>>> On Tue, 2011-11-08 at 11:36 -0800, greearb@candelatech.com wrote:
>>>
>>>> +			/*
>>>> +			 * We always need to advert at least MCS0-7, to
>>>> +			 * be a compliant HT station, for instance
>>>> +			 */
>>>> +			if (((i * 8 + q)>= min_rates)&&
>>>
>>> This is a little misleading -- why min_rates when the comment says
>>> MCS0-7?
>>
>> I let caller determine the min, but comment was to tell why
>> the min might be set.  In APs, the min supported rates are 16, evidently...not
>> that this code supports APs at the moment...
>
> About APs: that can't be right, there certainly will be 1x1 APs.

Section 20.1.1 again:

"An HT non-AP STA shall support all equal modulation (EQM) rates for one spatial stream (MCSs 0 through
7) using 20 MHz channel width. An HT AP shall support all EQM rates for one and two spatial streams
(MCSs 0 through 15) using 20 MHz channel width."

Again, I think the requirement is lame, and maybe everyone will just ignore it,
but it is there...


>> When this is about local use instead of advertising, then any minimum
>> is OK.
>>
>> Want me to just remove the comment entirely?
>
> Well, so, I think the logic there is a little odd anyway -- why aren't
> you doing it byte-wise, if the only thing that can possibly happen is
> that the first byte is masked or not? Maybe change the parameter to
> "bool allow_single_stream_mask" or something like that and adjust the
> algorithm like:
>
> start = allow_single_stream_mask ? 0 : 1;
>
> for (i = start; i<  IEEE80211_HT_MCS_MASK_LEN; i++) {
> 	u8 val = smask[i]&  scaps[i];
> 	val |= ht_cap->mcs.rx_mask[i]&  ~smask[i];
> 	ht_cap->mcs.rx_mask[i] val;
> }
>
> or so. right? Much simpler?

Depends on whether we want to honour the AP part of 20.1.1.
Since we don't support AP mode anyway right now,
I'm fine with your suggestion.  Let me know if you want
me to proceed with your suggested changes.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

