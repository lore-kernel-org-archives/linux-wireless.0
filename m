Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34652 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751468AbdB1B60 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 20:58:26 -0500
Subject: Re: [PATCH 2/2][RFC] mac80211_hwsim: Report radio addresses in
 NEW_RADIO/GET_RADIO
To: Andrew Zaborowski <andrew.zaborowski@intel.com>
References: <20170223120211.22358-1-andrew.zaborowski@intel.com>
 <20170223120211.22358-2-andrew.zaborowski@intel.com>
 <1488202062.28431.7.camel@sipsolutions.net>
 <CAOq732JzrGxFUa5BiuO=Sz7gscRV7PFxOOyy1xf6mtmQfUqkaA@mail.gmail.com>
 <2155efb0-1325-0089-fbb1-cc63cc289745@candelatech.com>
 <CAOq732+MZt=mytXrZko0uw=EsBWvQpZ49wg3CxFPVn0uGGNyog@mail.gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <4549b209-df6c-0eaa-65e6-72562c61bf4b@candelatech.com> (sfid-20170228_025909_000034_B8153D6C)
Date: Mon, 27 Feb 2017 17:57:34 -0800
MIME-Version: 1.0
In-Reply-To: <CAOq732+MZt=mytXrZko0uw=EsBWvQpZ49wg3CxFPVn0uGGNyog@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 02/27/2017 05:23 PM, Andrew Zaborowski wrote:
> Hi,
>
> On 27 February 2017 at 18:10, Ben Greear <greearb@candelatech.com> wrote:
>> On 02/27/2017 07:26 AM, Andrew Zaborowski wrote:
>>> As it turns out it can be read from /sys, but I do need it so I can
>>> know what to put in HWSIM_ATTR_ADDR_RECEIVER based on the destination
>>> addr in the frame or if I want to forward the frame to all radios.  Or
>>> is there another way to know that?
>>>
>>>>
>>>> I'd actually prefer to *only* have the wiphy index, and I don't really
>>>> see a problem with moving the wiphy_idx from struct
>>>> cfg80211_registered_device to struct wiphy.
>>>
>>>
>>> Ok, I'll try that.  get_wiphy_idx can stay in place, not sure if I
>>> should just drop it.
>>>
>>> By having *only* the wiphy index you don't mean dropping the radio
>>> names altogether?  The don't seem useful but userspace may expect
>>> them.
>>
>>
>> I find the name and addr more useful than an 'index', because if you
>> remove/add
>> a virtual phy, then the index will probably change, even if name and MAC
>
> I don't think you can remove/add a phy without removing the hwsim
> radio.  A hwsim radio is tied to some wiphy at all times.

You can specify the MAC address and name (ie, wiphy0) when creating a hwsim radio.
You cannot specify the index.  So, from a user-space perspective,
I think the name and MAC is more important than the index.

Anyway, I think you are correct to pay attention to the MAC address and use
that as the identifying key.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
