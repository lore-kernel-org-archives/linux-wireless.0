Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44049 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab2LESCM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 13:02:12 -0500
Message-ID: <50BF8C18.9060504@candelatech.com> (sfid-20121205_190216_008710_2BCD3F78)
Date: Wed, 05 Dec 2012 10:02:00 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless:  Fix ethtool stats and other ops.
References: <1354729192-22945-1-git-send-email-greearb@candelatech.com> <87a9ts4c1q.fsf@nemi.mork.no>
In-Reply-To: <87a9ts4c1q.fsf@nemi.mork.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/05/2012 09:57 AM, Bjørn Mork wrote:
> Ben Greear <greearb@candelatech.com> writes:
>
>> net/core/dev.c now assigns a default ethtool ops, so
>> the net/wireless/core.c check for existing ops is always true
>> so the wireless ops would never be assigned.
>>
>> Simply remove the check for existing ops and always assign
>> the wireless ops.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>> ---
>>   net/wireless/core.c |    3 +--
>>   1 files changed, 1 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/wireless/core.c b/net/wireless/core.c
>> index 4e6fe62..6309699 100644
>> --- a/net/wireless/core.c
>> +++ b/net/wireless/core.c
>> @@ -863,8 +863,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
>>   		/* allow mac80211 to determine the timeout */
>>   		wdev->ps_timeout = -1;
>>
>> -		if (!dev->ethtool_ops)
>> -			dev->ethtool_ops = &cfg80211_ethtool_ops;
>> +		dev->ethtool_ops = &cfg80211_ethtool_ops;
>>
>>   		if ((wdev->iftype == NL80211_IFTYPE_STATION ||
>>   		     wdev->iftype == NL80211_IFTYPE_P2P_CLIENT ||
>
>
> Won't this break drivers which for some reason have their own
> ethtool_ops?

I guess it will.  What a mess.

Maybe we could assign individual method pointers in the ethtool_ops
struct if it already exists (and if those pointers are NULL)?

Thanks,
Ben

>
> bjorn@nemi:/usr/local/src/git/linux$ git grep -- "->ethtool_ops" drivers/net/wireless/
> drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c:    ndev->ethtool_ops = &brcmf_ethtool_ops;
> drivers/net/wireless/ipw2x00/ipw2100.c: dev->ethtool_ops = &ipw2100_ethtool_ops;
> drivers/net/wireless/ipw2x00/ipw2200.c: net_dev->ethtool_ops = &ipw_ethtool_ops;
> drivers/net/wireless/libertas/main.c:   dev->ethtool_ops = &lbs_ethtool_ops;
> drivers/net/wireless/libertas/mesh.c:   mesh_dev->ethtool_ops = &lbs_ethtool_ops;
> drivers/net/wireless/prism54/islpci_dev.c:      ndev->ethtool_ops = &islpci_ethtool_ops;
>
>
>
> Bjørn
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

