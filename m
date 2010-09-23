Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53999 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab0IWQ01 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 12:26:27 -0400
Message-ID: <4C9B7FA3.6040402@candelatech.com>
Date: Thu, 23 Sep 2010 09:26:11 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: greearb@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211/ath9k:  Support AMPDU with multiple VIFs.
References: <1285250054-32035-1-git-send-email-greearb@candelatech.com> <1285250906.3770.114.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285250906.3770.114.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/23/2010 07:08 AM, Johannes Berg wrote:
> On Thu, 2010-09-23 at 06:54 -0700, greearb@gmail.com wrote:
>
>>    *
>> - * NOTE: This function should not be used! When mac80211 is converted
>> - *	 internally to properly keep track of stations on multiple
>> - *	 virtual interfaces, it will not always know which station to
>> - *	 return here since a single address might be used by multiple
>> - *	 logical stations (e.g. consider a station connecting to another
>> - *	 BSSID on the same AP hardware without disconnecting first).
>> - *
>> - * DO NOT USE THIS FUNCTION.
>
> Also, I'm not sure you really should remove this comment, since it still
> applies when you pass NULL, and I'm still not convinced that ath9k
> couldn't keep track of the virtual interface accurately?

It seems ath9k would have to selectively remove buffers from it's tx queues
with vifs dissappeared. I had a previous patch that flushed all when interfaces
came and went, but it seems I would also have to do something similar
for AP mode when remote stations came and went.  And for remote stations,
Felix didn't like flushing the queues entirely, so it would have to be for
just pkts belonging to that VIF.

That would mean quite a bit of re-write of the buffer flush logic as
far as I can tell.

As for the by_hw() method, it's only used in ath9k, and the only time
it gets passed a NULL is in the ath9k_process_rssi code when the
destination address is multicast (so we cannot reliably match on
a destination interface).

I'll update the warning comment to mention about passing in NULL
as localaddr.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
