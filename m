Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43196 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab1A1TWh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 14:22:37 -0500
Message-ID: <4D431778.1000604@candelatech.com>
Date: Fri, 28 Jan 2011 11:22:32 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC v3] mac80211:  Optimize scans on current operating channel.
References: <1296074238-4012-1-git-send-email-greearb@candelatech.com>	 <1296136347.3622.55.camel@jlt3.sipsolutions.net>	 <4D41BA91.30608@candelatech.com> <1296220846.5118.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1296220846.5118.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/28/2011 05:20 AM, Johannes Berg wrote:
> On Thu, 2011-01-27 at 10:33 -0800, Ben Greear wrote:
>
>>>> @@ -396,10 +397,14 @@ ieee80211_rx_h_passive_scan(struct ieee80211_rx_data *rx)
>>>>    		return ieee80211_scan_rx(rx->sdata, skb);
>>>>
>>>>    	if (test_bit(SCAN_SW_SCANNING,&local->scanning)) {
>>>> -		/* drop all the other packets during a software scan anyway */
>>>> -		if (ieee80211_scan_rx(rx->sdata, skb) != RX_QUEUED)
>>>> +		ret = ieee80211_scan_rx(rx->sdata, skb);
>>>> +		/* drop all the other packets while scanning off channel */
>>>> +		if (ret != RX_QUEUED&&
>>>> +		    test_bit(SCAN_OFF_CHANNEL,&local->scanning)) {
>>>>    			dev_kfree_skb(skb);
>>>> -		return RX_QUEUED;
>>>> +			return RX_QUEUED;
>>>> +		}
>>>> +		return ret;
>>>
>>> Alright -- but does the mlme.c code know not to expect beacons during an
>>> on-channel scan?
>>
>> I have a more basic question on this:
>>
>> Should we just pass all packets on up the stack, regardless of whether we are
>> offchannel or not?  I think that would simplify things here,
>> and if/when we ever support things other than just scanning on
>> different off-channels, that code would just work.
>
> I'm not really exactly sure why we don't.
>
> However -- I was thinking of something else, not data packets. While
> scanning, all received beacons will be handed to the scan code. But if
> the mlme code isn't told to stop looking for them, it'll still expect to
> see the beacons.

Currently, it seems mlme timers are stopped when we start scanning,
and then started when scanning is complete.

However, I don't see any similar effort in the work_work() method
when it goes off-channel.

Should we move the timer pause & restart logic into the offchannel_stop_vifs
and offchannel_return methods?

If that seems like a good idea, I'll attempt that as a follow on patch.

I don't think my changes make this any worse, so not critical to add this
to the current patch I'm working on.

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

