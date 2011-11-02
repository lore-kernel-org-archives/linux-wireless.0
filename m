Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:48996 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933375Ab1KBQeQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Nov 2011 12:34:16 -0400
Message-ID: <4EB17103.70506@candelatech.com> (sfid-20111102_173421_916822_20314BAF)
Date: Wed, 02 Nov 2011 09:34:11 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [wireless-next PATCH 1/5] mac80211: Support forcing station to
 disable 11n.
References: <1319778680-11405-1-git-send-email-greearb@candelatech.com>  (sfid-20111028_071135_777672_88A08497) <1319789318.3914.10.camel@jlt3.sipsolutions.net>  <4EAAFAA7.8090403@candelatech.com> (sfid-20111028_205543_472872_4928ADE0) <1320220415.3950.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1320220415.3950.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/02/2011 12:53 AM, Johannes Berg wrote:
> On Fri, 2011-10-28 at 11:55 -0700, Ben Greear wrote:
>
>>> This should be a parameter to connect() and assoc(), not a generic
>>> netdev parameter, since it applies to the connection.
>>>
>>> Also, it would be good to have a capability check for it etc. since a
>>> lot of fullmac drivers will likely never implement this.
>>
>> The existing code always sets the IEEE80211_STA_DISABLE_11N flag in u.mgd if
>> WEP or TKIP is configured, without any capability checks, and my patch
>> sets that flag in the same location.
>>
>> So, maybe it is OK as is?
>>
>> If not, I will add a new capability bit and just enable
>> it in ath9k (and let others enable it in their drivers as they wish).
>
> You misunderstood -- I said fullmac drivers, not differences between
> ath9k, iwlwifi etc. Other cfg80211 drivers, not other mac80211 drivers.

Can you at least point me to some existing code that does a similar
check?  I have no idea of what a fullmac driver even does.  I can test
and eventually somewhat understand the paths for ath9k, but I have no
ability to test fullmac (as far as I know).

If you don't have time to explain in more detail, then I will just
carry these patches in my own tree.  That is a total pain in
the arse when dealing with new netlink commands, but I just do not
have enough understanding of the entire wifi stack to make much
progress with a lot of your suggestions.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

