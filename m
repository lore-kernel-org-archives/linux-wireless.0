Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:38010 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbbBXO2G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 09:28:06 -0500
Message-ID: <54EC8A74.2080700@candelatech.com> (sfid-20150224_152810_024971_91B91AF9)
Date: Tue, 24 Feb 2015 06:28:04 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211-hwsim:  Don't enqueue pkts that do not want
 txstatus.
References: <1423592732-17256-1-git-send-email-greearb@candelatech.com>	 <1424707739.3075.19.camel@sipsolutions.net>	 <54EB6589.6040803@candelatech.com> <1424772854.2192.19.camel@sipsolutions.net>
In-Reply-To: <1424772854.2192.19.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 02/24/2015 02:14 AM, Johannes Berg wrote:
> On Mon, 2015-02-23 at 09:38 -0800, Ben Greear wrote:
>
>>> This doesn't really seem right - essentially it means that whatever you
>>> just gave to userspace is now completely useless?
>>>
>>> It seems skb_orphan() could/should be put here.
>>
>> I don't understand your complaint, why is what I gave to user-space useless?
>
> userspace is supposed to give back the SKB pointer as a cookie when it
> reports whether or not it was transmitted correctly, and then we will
> free the SKB afterwards.

If there is no status to return, then why would user-space call back at all?

Should user-space *always* return a status even when not requested to?

Thanks,
Ben


> Note that I also just merged a patch from Bob in this area.
>
>> If we just orphan them, does that clean up the skb memory properly?
>
> No, of course not, but it removes it from socket accounting. This may be
> what you want, although I'm not really sure it's the right thing to do
> since it would make this behave differently than other drivers which
> also don't orphan the SKB (and shouldn't - you can consider the SKB on
> this queue as being on the HW DMA queue where it should still be
> accounted for correctly)
>
> I think perhaps you just want Bob's patch to fix the case of too slow
> userspace.
>
>> If not, what eventually frees the skb?
>
> The tx status path does.
>
> johannes
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
