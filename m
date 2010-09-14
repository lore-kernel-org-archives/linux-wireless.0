Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57520 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab0INPqE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 11:46:04 -0400
Message-ID: <4C8F988F.7080905@candelatech.com>
Date: Tue, 14 Sep 2010 08:45:19 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [virtual-sta 3/3] mac80211:  Allow multiple STA on same BSS.
References: <1284156298-15863-1-git-send-email-greearb@candelatech.com>	 <1284156298-15863-3-git-send-email-greearb@candelatech.com> <1284469022.3704.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1284469022.3704.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/14/2010 05:57 AM, Johannes Berg wrote:
> On Fri, 2010-09-10 at 15:04 -0700, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> When adding an STA, the old code checked if there was already
>> an STA with the same BSS.  Instead, check to see if there is
>> exactly the same STA in order to allow multiple STA to be
>> associated with the same AP.
>
>
> You want this instead:
>
> ---
>   net/mac80211/sta_info.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- wireless-testing.orig/net/mac80211/sta_info.c	2010-09-14 14:53:10.000000000 +0200
> +++ wireless-testing/net/mac80211/sta_info.c	2010-09-14 14:55:44.000000000 +0200
> @@ -125,7 +125,7 @@ struct sta_info *sta_info_get_bss(struct
>   				    lockdep_is_held(&local->sta_mtx));
>   	while (sta) {
>   		if ((sta->sdata == sdata ||
> -		     sta->sdata->bss == sdata->bss)&&
> +		     (sta->sdata->bss&&  sta->sdata->bss == sdata->bss))&&
>   		memcmp(sta->sta.addr, addr, ETH_ALEN) == 0)
>   			break;
>   		sta = rcu_dereference_check(sta->hnext,

This seems to work fine.  Do you want me to respin the patch, or will you push this
in?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
