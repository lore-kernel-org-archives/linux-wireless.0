Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45680 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab1A0Sd6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 13:33:58 -0500
Message-ID: <4D41BA91.30608@candelatech.com>
Date: Thu, 27 Jan 2011 10:33:53 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC v3] mac80211:  Optimize scans on current operating channel.
References: <1296074238-4012-1-git-send-email-greearb@candelatech.com> <1296136347.3622.55.camel@jlt3.sipsolutions.net>
In-Reply-To: <1296136347.3622.55.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/27/2011 05:52 AM, Johannes Berg wrote:

>> @@ -396,10 +397,14 @@ ieee80211_rx_h_passive_scan(struct ieee80211_rx_data *rx)
>>   		return ieee80211_scan_rx(rx->sdata, skb);
>>
>>   	if (test_bit(SCAN_SW_SCANNING,&local->scanning)) {
>> -		/* drop all the other packets during a software scan anyway */
>> -		if (ieee80211_scan_rx(rx->sdata, skb) != RX_QUEUED)
>> +		ret = ieee80211_scan_rx(rx->sdata, skb);
>> +		/* drop all the other packets while scanning off channel */
>> +		if (ret != RX_QUEUED&&
>> +		    test_bit(SCAN_OFF_CHANNEL,&local->scanning)) {
>>   			dev_kfree_skb(skb);
>> -		return RX_QUEUED;
>> +			return RX_QUEUED;
>> +		}
>> +		return ret;
>
> Alright -- but does the mlme.c code know not to expect beacons during an
> on-channel scan?

I have a more basic question on this:

Should we just pass all packets on up the stack, regardless of whether we are
offchannel or not?  I think that would simplify things here,
and if/when we ever support things other than just scanning on
different off-channels, that code would just work.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

