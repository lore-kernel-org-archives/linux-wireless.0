Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:57234 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732640AbeITUKe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 16:10:34 -0400
Subject: Re: Problem with sending pkt on a monitor port
To: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <76ce3d16-dbea-e882-63e7-2337fbc269c6@candelatech.com>
 <1537389335.10305.92.camel@sipsolutions.net>
 <d6f99a05-77a3-f18a-4e7a-083062119ce4@candelatech.com>
 <1537428695.3874.1.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <6ac68a4c-04a3-ce6e-232e-3ebb6100ee29@candelatech.com> (sfid-20180920_162712_881877_422E1006)
Date: Thu, 20 Sep 2018 07:26:43 -0700
MIME-Version: 1.0
In-Reply-To: <1537428695.3874.1.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 09/20/2018 12:31 AM, Johannes Berg wrote:
> On Wed, 2018-09-19 at 13:47 -0700, Ben Greear wrote:
>
>>> For one, the driver has no concept of the original vif, since monitor
>>> vifs aren't added to it.
>>
>> ath10k does create a monitor vif, but maybe it is not mapped directly
>> to mac80211.
>
> It's actually created by mac80211, but only once, and not directly
> mapped to each vif seen by userspace - it's an internal construction.

I'm not sure it matters, but ath10k firmware can also create a monitor vdev
itself for certain reasons.  (Maybe offchannel tx on some FW, but I haven't looked at
that code lately).

>>> Secondly, the old hostapd code before nl80211 injects frames that way,
>>> and they need to go there.
>>
>> Ok, I agree we should not break backwards compat then.  I'll poke some more
>> to see if I can get it working.
>
> We might get away with doing this only for cooked monitor mode, which it
> used there ...
>
> However, thinking about it, that also breaks userspace in other ways -
> for example if you do injection this way you actually get encryption and
> other nice things if you use the local address that matches an existing
> interface.

I'm not entirely sure of a useful use-case for this feature in user-space.
I am using it just to test sending some test frames to debug some firmware
features.  I think another user sent hand-crafted specialized beacons in this manner
using my 10.1 ath10k firmware & driver.  For whatever reason, I didn't realize monitor
vdevs were not directly used when I added that support..maybe I just got lucky
before I had to dig closely.

>
> Perhaps you should just use a different address, and then nothing of the
> sort would happen?

If I make the code in my original email be skipped, so that sdata remains the
monitor vdev, then it fails a check later in that method because there is no
chanctxt for the monitor sdata object.

I guess that changing the source MAC to something unique would cause the same
issue and no frame would be sent towards the driver.

Thanks,
Ben

>
> johannes
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
