Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:57814 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751647AbdCAPgE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Mar 2017 10:36:04 -0500
Subject: Re: [PATCH 2/2][RFC] mac80211_hwsim: Report radio addresses in
 NEW_RADIO/GET_RADIO
To: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>,
        Andrew Zaborowski <andrew.zaborowski@intel.com>
References: <20170223120211.22358-1-andrew.zaborowski@intel.com>
 <20170223120211.22358-2-andrew.zaborowski@intel.com>
 <1488202062.28431.7.camel@sipsolutions.net>
 <CAOq732JzrGxFUa5BiuO=Sz7gscRV7PFxOOyy1xf6mtmQfUqkaA@mail.gmail.com>
 <2155efb0-1325-0089-fbb1-cc63cc289745@candelatech.com>
 <CAOq732+MZt=mytXrZko0uw=EsBWvQpZ49wg3CxFPVn0uGGNyog@mail.gmail.com>
 <4549b209-df6c-0eaa-65e6-72562c61bf4b@candelatech.com>
 <4efcd470-86ee-2f3d-bbe2-1d82874edffd@uni-rostock.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <4d3505b9-9714-8ad0-5159-794cb566dc3b@candelatech.com> (sfid-20170301_163621_602053_E55E80BC)
Date: Wed, 1 Mar 2017 07:35:47 -0800
MIME-Version: 1.0
In-Reply-To: <4efcd470-86ee-2f3d-bbe2-1d82874edffd@uni-rostock.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 03/01/2017 06:33 AM, Benjamin Beichler wrote:
>> You can specify the MAC address and name (ie, wiphy0) when creating a
>> hwsim radio.
>> You cannot specify the index.  So, from a user-space perspective,
>> I think the name and MAC is more important than the index.
>>
> That is actually not possible. The permanent MAC-Addresses of hwsim
> radios are directly created by there internal ID, which is only
> increased for new radios and definitely not reassigned.
>
> But I would be happy, if this were possible, since it would make some
> simulation related stuff easier (currently we need to unload and load
> the hwsim module over and over again for every run).

Ahh, you are right.  But you can specify the wiphy name, and then you
can use that to query the debugfs to find the MAC addr, and then sync
your user-space with that info.

It should also be easy enough to specify the MAC address when creating
the radio.

And, you should be able to create virtual STA, AP, etc, with any specified
MAC address, so the MAC of the radio really should not matter much?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
