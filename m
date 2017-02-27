Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:47302 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751555AbdB0RQh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 12:16:37 -0500
Subject: Re: [PATCH 2/2][RFC] mac80211_hwsim: Report radio addresses in
 NEW_RADIO/GET_RADIO
To: Andrew Zaborowski <andrew.zaborowski@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>
References: <20170223120211.22358-1-andrew.zaborowski@intel.com>
 <20170223120211.22358-2-andrew.zaborowski@intel.com>
 <1488202062.28431.7.camel@sipsolutions.net>
 <CAOq732JzrGxFUa5BiuO=Sz7gscRV7PFxOOyy1xf6mtmQfUqkaA@mail.gmail.com>
Cc: linux-wireless@vger.kernel.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <2155efb0-1325-0089-fbb1-cc63cc289745@candelatech.com> (sfid-20170227_181705_859394_2696639F)
Date: Mon, 27 Feb 2017 09:10:34 -0800
MIME-Version: 1.0
In-Reply-To: <CAOq732JzrGxFUa5BiuO=Sz7gscRV7PFxOOyy1xf6mtmQfUqkaA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 02/27/2017 07:26 AM, Andrew Zaborowski wrote:
> Hi,
>
> On 27 February 2017 at 14:27, Johannes Berg <johannes@sipsolutions.net> wrote:
>>> Additionally I tried to add a HWSIM_ATTR_WIPHY to report the wiphy
>>> index directly without users going through wiphy name to index
>>> mapping, but get_wiphy_idx() is internal to cfg80211.  The index is
>>> exposed to userspace and is more useful than the name so I wonder if
>>> this function should be exported from cfg80211.
>>
>> Do you really need the address?
>
> As it turns out it can be read from /sys, but I do need it so I can
> know what to put in HWSIM_ATTR_ADDR_RECEIVER based on the destination
> addr in the frame or if I want to forward the frame to all radios.  Or
> is there another way to know that?
>
>>
>> I'd actually prefer to *only* have the wiphy index, and I don't really
>> see a problem with moving the wiphy_idx from struct
>> cfg80211_registered_device to struct wiphy.
>
> Ok, I'll try that.  get_wiphy_idx can stay in place, not sure if I
> should just drop it.
>
> By having *only* the wiphy index you don't mean dropping the radio
> names altogether?  The don't seem useful but userspace may expect
> them.

I find the name and addr more useful than an 'index', because if you remove/add
a virtual phy, then the index will probably change, even if name and MAC addr may stay
the same (and so probably be the same logical entitity).

Since phys can be renamed, you cannot assume that the phy will be called
phyX where X is the device-id.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
