Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39214 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab2DAUxq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Apr 2012 16:53:46 -0400
Message-ID: <4F78C056.4080307@candelatech.com> (sfid-20120401_225349_388622_92AB641F)
Date: Sun, 01 Apr 2012 13:53:42 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211:  Support on-channel scan option.
References: <1333233041-3246-1-git-send-email-greearb@candelatech.com>   (sfid-20120401_003057_469452_61057064) <1333305916.3703.2.camel@jlt3.sipsolutions.net>  <4F78BE67.8090609@candelatech.com> <1333313357.22977.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1333313357.22977.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/01/2012 01:49 PM, Johannes Berg wrote:
> On Sun, 2012-04-01 at 13:45 -0700, Ben Greear wrote:
>> On 04/01/2012 11:45 AM, Johannes Berg wrote:
>>> On Sat, 2012-03-31 at 15:30 -0700, greearb@candelatech.com wrote:
>>>
>>>
>>>>    static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
>>>>    				  struct cfg80211_scan_request *req)
>>>> @@ -438,6 +461,33 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
>>>>    	local->scan_req = req;
>>>>    	local->scan_sdata = sdata;
>>>>
>>>> +	/* If we are scanning only on the current channel, then
>>>> +	 * we do not need to stop normal activities
>>>> +	 */
>>>> +	if ((req->n_channels == 1)&&
>>>> +	    (req->channels[0]->center_freq ==
>>>> +	     local->hw.conf.channel->center_freq)) {
>>> ...
>>>> +		return 0;
>>>> +	}
>>>> +
>>>>    	if (local->ops->hw_scan)
>>>>    		__set_bit(SCAN_HW_SCANNING,&local->scanning);
>>>
>>> Clearly, you're joking.
>>
>> That is worthless feedback and gives me no idea what you
>> think should be fixed about it.
>>
>> If you hate the entire idea of optimizing scanning on channel,
>> just say so plainly.
>
> I did quote only the relevant pieces -- you're completely ignoring hw
> scan. Why should I care about this patch then?

Well, I was hoping that a simple scan-on-channel wouldn't need to
care about the hw-scan logic.

But, I can change it so that the optimized scan-on-channel only
is supported on NICs that do software-scan?

The patch does have a small bug in the scan-complete logic,
but aside from that, it appears to work on ath9k.

Thanks,
Ben

>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
