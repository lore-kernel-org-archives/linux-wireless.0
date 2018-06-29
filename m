Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:33460 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932377AbeF2TBH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 15:01:07 -0400
Subject: Re: [PATCH] cfg80211: use IDA to allocate wiphy indeces
To: Brian Norris <briannorris@chromium.org>,
        Johannes Berg <johannes@sipsolutions.net>
References: <20180621012945.185705-1-briannorris@chromium.org>
 <1530258140.3481.4.camel@sipsolutions.net>
 <20180629184847.GA251207@ban.mtv.corp.google.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <278cfd54-204b-2ff7-a8d2-575a01151667@candelatech.com> (sfid-20180629_210139_781985_2802A3A6)
Date: Fri, 29 Jun 2018 12:01:04 -0700
MIME-Version: 1.0
In-Reply-To: <20180629184847.GA251207@ban.mtv.corp.google.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/29/2018 11:48 AM, Brian Norris wrote:
> Hi Johannes,
>
> On Fri, Jun 29, 2018 at 09:42:20AM +0200, Johannes Berg wrote:
>> On Wed, 2018-06-20 at 18:29 -0700, Brian Norris wrote:
>>> It's annoying to see the phy index increase arbitrarily, just because a
>>> device got removed and re-probed (e.g., during a device reset, or due to
>>> probe testing). We can use the in-kernel index allocator for this,
>>> instead of just an increasing counter.
>>
>> I can understand that it's somewhat annoying to people, but it was
>> actually done on purpose to avoid userspace talking to the wrong device.
>
> Hmm, interesting. I'm not dead-set on this patch, so if there are good
> reasons to reject it, I won't fret.
>
>> Imagine you have some userspace process running that has remembered the
>> wiphy index to use it to talk to nl80211, and now underneath the device
>> goes away and reappears. This process should understand that situation,
>> and handle it accordingly, rather than being blind to the reset.
>
> How is this different from the wlan (netdev) device naming? We allow
> 'wlan0' to leave and return under the same name. Isn't the right answer
> that user space should be listening for udev and/or netlink events?
>
> Brian
>

For what it is worth, we use udev to rename the phyX to wiphyZ devices based on
their MAC address, and that seems to work OK.

I can't think of any reason why user-space would need the phy index number
to increase as modules are loaded/unloaded though.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
