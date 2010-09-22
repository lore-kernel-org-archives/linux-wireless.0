Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49882 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab0IVQ7p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 12:59:45 -0400
Message-ID: <4C9A35FD.8060201@candelatech.com>
Date: Wed, 22 Sep 2010 09:59:41 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [mac80211] mac80211:  Support multiple VIFS per AP in debugfs.
References: <1285071310-11440-1-git-send-email-greearb@candelatech.com>	 <4C98DC5D.2000108@candelatech.com>	 <1285086618.12764.3.camel@jlt3.sipsolutions.net>	 <4C98E05B.8050609@candelatech.com>	 <1285088605.12764.5.camel@jlt3.sipsolutions.net> <1285091341.12764.7.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285091341.12764.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/21/2010 10:49 AM, Johannes Berg wrote:
> On Tue, 2010-09-21 at 19:03 +0200, Johannes Berg wrote:
>
>>>>>> -	snprintf(mac, sizeof(mac), "%pM", sta->sta.addr);
>>>>>> +	snprintf(mac, sizeof(mac), "%pM-%s",
>>>>>> +		 sta->sta.addr, sta->sdata->name);
>>>>>>
>>>>>>     	/*
>>>>>>     	 * This might fail due to a race condition:
>>>>>
>>>>> I got to thinking:  Is there any reason to put the sta.addr in there?
>>>>>
>>>>> Maybe just use sta->sdata->name?  Seems it might be easier for
>>>>> scripts to deal with?
>>>>
>>>> APs have many STAs
>>>
>>> So, when in STA mode, sta_info are related to local VIFs, but
>>> in AP mode, they represent the remote wireless devices, with sdata pointing
>>> to the local AP interface?
>>
>> No, there's a sta_info for each peer, which in STA mode is only the AP.
>
> maybe the stations should be moved from phy0/stations/ to
> phy0/wlan0/stations/ instead?

It doesn't matter either way to me, but I'd like to get one or another
patch upstream.

If you want me to change it to put stations under netdev:wlan0/ instead,
please just let me know.

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

