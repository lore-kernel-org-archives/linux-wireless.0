Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57796 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab1ATSGd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 13:06:33 -0500
Message-ID: <4D3879A6.2060909@candelatech.com>
Date: Thu, 20 Jan 2011 10:06:30 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC 2/3] mac80211: Support scanning only current active channel.
References: <1295544750-6704-1-git-send-email-greearb@candelatech.com>	 <1295544750-6704-2-git-send-email-greearb@candelatech.com> <1295545143.3693.44.camel@jlt3.sipsolutions.net>
In-Reply-To: <1295545143.3693.44.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/20/2011 09:39 AM, Johannes Berg wrote:
> On Thu, 2011-01-20 at 09:32 -0800, greearb@candelatech.com wrote:
>
>> -	ieee80211_offchannel_stop_beaconing(local);
>> +	if (local->ops->sw_scan_start_cur&&
>> +	    local->scan_req->n_channels == 1&&
>> +	    local->scan_req->channels[0] == local->hw.conf.channel) {
>> +		__set_bit(SCAN_ON_CUR_CHANNEL,&local->scanning);
>> +		drv_sw_scan_start_cur(local, true);
>> +	} else
>> +		drv_sw_scan_start(local);
>
> This doesn't seem to make much sense either -- even if we do a scan over
> multiple channels we should be able to optimise the part on the current
> channel (maybe put it at the beginning or end too).

Maybe..but user-space can specify the channels it wants to scan,
and I assume that means what order to scan them in.  I have no
idea if changing that order would confuse some application.

It seems to me that it would take quite a bit of re-work of the
mac80211 scanning logic to deal with scanning on the current
channel w/out affecting other tx/rx packets (as my patch attempts
to do), without setting some explicit flag before you enter
the scan state machine.

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

