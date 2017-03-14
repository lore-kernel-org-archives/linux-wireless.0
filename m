Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:37536 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750788AbdCNMlG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Mar 2017 08:41:06 -0400
Received: by mail-wm0-f46.google.com with SMTP id n11so62781831wma.0
        for <linux-wireless@vger.kernel.org>; Tue, 14 Mar 2017 05:41:05 -0700 (PDT)
Subject: Re: brcmfmac and WIPHY_FLAG_NETNS_OK
To: Johannes Berg <johannes@sipsolutions.net>,
        Mark Asselstine <mark.asselstine@windriver.com>
References: <2253234.njokx7NVYT@yow-masselst-lx1>
 <df16691e-62f7-4c95-0534-48d1dea4f5ba@broadcom.com>
 <1489490906.28373.3.camel@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <6d879e70-b75a-4708-78fc-ee25c0ffa67c@broadcom.com> (sfid-20170314_134123_874978_C2D4D73E)
Date: Tue, 14 Mar 2017 13:41:02 +0100
MIME-Version: 1.0
In-Reply-To: <1489490906.28373.3.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14-3-2017 12:28, Johannes Berg wrote:
> 
>> It never came up with any projects so far. I doubt that the patch
>> below is sufficient. I suspect something more is needed. Using git
>> blame I ended up finding these commits:
>>
>> a272a72 mac80211: allow using network namespaces
> 
> This is needed in brcm drivers.
> 
>> 463d018 cfg80211: make aware of net namespaces
> 
> This has no impact on brcm drivers :)
> 
>> 5061b0c mac80211: cooperate more with network namespaces
> 
> This shouldn't be needed, you're not referring to init_net in brcm
> drivers.
> 
>> I think what is required from brcmfmac is to set netns for each
>> netdev that we create to the same netns as the wiphy instance using
>> wiphy_net().
> 
> Yes, like the mac80211 patch above.
> 
>> Not sure if there is more to consider, but hopefully Johannes can
>> comment on this although the mentioned commits have been around for a
>> while.
> 
> I don't think there's anything else.
> 
>>>         wiphy->flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT |
>>>                         WIPHY_FLAG_OFFCHAN_TX |
>>> -                       WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
>>> +                       WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
>>> +                       WIPHY_FLAG_NETNS_OK;
> 
> This is not sufficient, you still have to set the netns for newly
> created netdevs.

Thanks for confirming my suspicion.

Regards,
Arend
