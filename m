Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:35027 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751468AbdB1BYZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 20:24:25 -0500
Received: by mail-it0-f66.google.com with SMTP id 203so38451ith.2
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2017 17:23:28 -0800 (PST)
Received: from mail-io0-f172.google.com (mail-io0-f172.google.com. [209.85.223.172])
        by smtp.gmail.com with ESMTPSA id 10sm2255948itm.12.2017.02.27.17.23.26
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Feb 2017 17:23:26 -0800 (PST)
Received: by mail-io0-f172.google.com with SMTP id g18so308036ioe.0
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2017 17:23:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2155efb0-1325-0089-fbb1-cc63cc289745@candelatech.com>
References: <20170223120211.22358-1-andrew.zaborowski@intel.com>
 <20170223120211.22358-2-andrew.zaborowski@intel.com> <1488202062.28431.7.camel@sipsolutions.net>
 <CAOq732JzrGxFUa5BiuO=Sz7gscRV7PFxOOyy1xf6mtmQfUqkaA@mail.gmail.com> <2155efb0-1325-0089-fbb1-cc63cc289745@candelatech.com>
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
Date: Tue, 28 Feb 2017 02:23:26 +0100
Message-ID: <CAOq732+MZt=mytXrZko0uw=EsBWvQpZ49wg3CxFPVn0uGGNyog@mail.gmail.com> (sfid-20170228_022540_786896_92DE16A0)
Subject: Re: [PATCH 2/2][RFC] mac80211_hwsim: Report radio addresses in NEW_RADIO/GET_RADIO
To: Ben Greear <greearb@candelatech.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 27 February 2017 at 18:10, Ben Greear <greearb@candelatech.com> wrote:
> On 02/27/2017 07:26 AM, Andrew Zaborowski wrote:
>> As it turns out it can be read from /sys, but I do need it so I can
>> know what to put in HWSIM_ATTR_ADDR_RECEIVER based on the destination
>> addr in the frame or if I want to forward the frame to all radios.  Or
>> is there another way to know that?
>>
>>>
>>> I'd actually prefer to *only* have the wiphy index, and I don't really
>>> see a problem with moving the wiphy_idx from struct
>>> cfg80211_registered_device to struct wiphy.
>>
>>
>> Ok, I'll try that.  get_wiphy_idx can stay in place, not sure if I
>> should just drop it.
>>
>> By having *only* the wiphy index you don't mean dropping the radio
>> names altogether?  The don't seem useful but userspace may expect
>> them.
>
>
> I find the name and addr more useful than an 'index', because if you
> remove/add
> a virtual phy, then the index will probably change, even if name and MAC

I don't think you can remove/add a phy without removing the hwsim
radio.  A hwsim radio is tied to some wiphy at all times.

> addr may stay
> the same (and so probably be the same logical entitity).

They may stay the same or not, you can't assume either.  Sorry I don't
understand your point.

Best regards
