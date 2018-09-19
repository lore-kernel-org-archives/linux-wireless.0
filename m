Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:39094 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727623AbeITC0l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 22:26:41 -0400
Subject: Re: Problem with sending pkt on a monitor port
To: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <76ce3d16-dbea-e882-63e7-2337fbc269c6@candelatech.com>
 <1537389335.10305.92.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <d6f99a05-77a3-f18a-4e7a-083062119ce4@candelatech.com> (sfid-20180919_224705_761808_22A0D3C7)
Date: Wed, 19 Sep 2018 13:47:00 -0700
MIME-Version: 1.0
In-Reply-To: <1537389335.10305.92.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/19/2018 01:35 PM, Johannes Berg wrote:
> On Wed, 2018-09-19 at 13:33 -0700, Ben Greear wrote:
>> This is with a modified 4.16.18+ kernel, though the code in question
>> is from 2011, so this is not new...
>>
>> I am attempting to use radiotap packet injection on a monitor port.
>>
>> In the ieee80211_monitor_start_xmit method, before this code below
>> runs, sdata is 'moni6a', my monitor port.  But, since I have a
>> station wlan1 with the same MAC address, then when this code is
>> completed, stdata becomes wlan1.
>>
>> Ath10k has all sorts of issues transmitting raw frames, and sending on
>> the wrong vdev only makes it even more broken!
>>
>> If user-space binds a socket to a monitor vdev and transmits a frame,
>> why would we want to change the vdev here?
>
> For one, the driver has no concept of the original vif, since monitor
> vifs aren't added to it.

ath10k does create a monitor vif, but maybe it is not mapped directly
to mac80211.

> Secondly, the old hostapd code before nl80211 injects frames that way,
> and they need to go there.

Ok, I agree we should not break backwards compat then.  I'll poke some more
to see if I can get it working.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
