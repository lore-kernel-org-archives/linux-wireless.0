Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57682 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933556Ab2JXQbc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 12:31:32 -0400
Message-ID: <508817E0.5050504@candelatech.com> (sfid-20121024_183135_759709_5F34D773)
Date: Wed, 24 Oct 2012 09:31:28 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/4] multi-channel/interface TX power handling
References: <1351073603-11616-1-git-send-email-johannes@sipsolutions.net>  <50880BD0.6080603@candelatech.com> <1351093332.10709.5.camel@jlt4.sipsolutions.net>
In-Reply-To: <1351093332.10709.5.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/24/2012 08:42 AM, Johannes Berg wrote:
> On Wed, 2012-10-24 at 08:40 -0700, Ben Greear wrote:
>> On 10/24/2012 03:13 AM, Johannes Berg wrote:
>>> This was the remaining work I had to do in mac80211, but it
>>> got a little larger because cfg80211 wasn't doing per-vif
>>> TX power ...
>>>
>>> I disallowed setting TX power per hardware now, we could in
>>> theory do something like set all interfaces in that case, but
>>> it seemed like a lot of work for very little gain. If someone
>>> needs it, we can do it later :-)
>>
>> Is there any good way for user-space to know if kernel supports
>> old or new version?  Maybe just try to set per wiphy and if that fails,
>> try to set per vif?
>
> Yeah that'd be the only way, most scripts I've seen always just use the
> interface anyway though? I'm not totally happy about this, maybe we
> should iterate all interfaces? Not really sure ...

Well, I think we should make setting the wiphy work...just iterate
all interfaces.  Breaking backwards compatibility just causes too
much problems for user-space, and many users may either not notice,
or not be able to change whatever software is screwing up.

But, I think we also need some way to know if we can set individual
vifs to different tx-power successfully.

Maybe a /sys/class/netdev/wlan0/tx-power file to read current power could
be added in this patch series?  Then user-space could key off of it's
existence, and it would give a simple way to read the current tx-power
settings (and possibly set it as well)...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

