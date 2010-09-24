Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36316 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757787Ab0IXTkS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 15:40:18 -0400
Message-ID: <4C9CFEA1.2080902@candelatech.com>
Date: Fri, 24 Sep 2010 12:40:17 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Richard Farina <sidhayn@gmail.com>
CC: Nick Kossifidis <mickflemm@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] This allows ath5k to support virtual STA and AP interfaces.
References: <1285272430-9617-1-git-send-email-greearb@candelatech.com> <AANLkTi=n9GDjiBxiS0cen2objz+BO9CeC-Uy5c6hVWhS@mail.gmail.com> <4C9CFD4E.10401@gmail.com>
In-Reply-To: <4C9CFD4E.10401@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/24/2010 12:34 PM, Richard Farina wrote:
> Nick Kossifidis wrote:
>> 2010/9/23 <greearb@candelatech.com>:
>>> From: Ben Greear <greearb@candelatech.com>
>>>
>>> +#define ATH5K_VIF_MAX 2048
>>
>> This is too much !!! 2048 interfaces with a total of 4 beacon buffers
>> 40 rx buffers and 200 tx buffers ? Has anyone tested this ?
>>
>> Also think about embedded devices, we don't want to waste memory like
>> this...
>>
> As a sanity check, I can say I've seen AP vendors that permit 32 SSIDs
> each with a unique BSSID/encryption, etc. I've never seen any device
> that does more than that so 32 is a pretty reasonable max vif (the user
> can always change it if desired, I'm looking at you openwrt team). Just
> my 0.02$

Many standard off-the-shelf APs seem to support more than that, and certainly
hostapd based APs can.  Maybe it could be 512 and let users on very tight
systems carry a small patch to make it smaller for their particular needs?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

