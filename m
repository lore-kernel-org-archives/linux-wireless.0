Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43148 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788Ab0IUQmH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 12:42:07 -0400
Message-ID: <4C98E05B.8050609@candelatech.com>
Date: Tue, 21 Sep 2010 09:42:03 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [mac80211] mac80211:  Support multiple VIFS per AP in debugfs.
References: <1285071310-11440-1-git-send-email-greearb@candelatech.com>	 <4C98DC5D.2000108@candelatech.com> <1285086618.12764.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285086618.12764.3.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/21/2010 09:30 AM, Johannes Berg wrote:
> On Tue, 2010-09-21 at 09:25 -0700, Ben Greear wrote:
>
>>> -	snprintf(mac, sizeof(mac), "%pM", sta->sta.addr);
>>> +	snprintf(mac, sizeof(mac), "%pM-%s",
>>> +		 sta->sta.addr, sta->sdata->name);
>>>
>>>    	/*
>>>    	 * This might fail due to a race condition:
>>
>> I got to thinking:  Is there any reason to put the sta.addr in there?
>>
>> Maybe just use sta->sdata->name?  Seems it might be easier for
>> scripts to deal with?
>
> APs have many STAs

So, when in STA mode, sta_info are related to local VIFs, but
in AP mode, they represent the remote wireless devices, with sdata pointing
to the local AP interface?

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

