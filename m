Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:34191 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751901AbdCNN2D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Mar 2017 09:28:03 -0400
Received: by mail-wr0-f177.google.com with SMTP id l37so124145707wrc.1
        for <linux-wireless@vger.kernel.org>; Tue, 14 Mar 2017 06:28:02 -0700 (PDT)
Subject: Re: brcmfmac and WIPHY_FLAG_NETNS_OK
To: Mark Asselstine <mark.asselstine@windriver.com>
References: <2253234.njokx7NVYT@yow-masselst-lx1>
 <1489490906.28373.3.camel@sipsolutions.net>
 <6d879e70-b75a-4708-78fc-ee25c0ffa67c@broadcom.com>
 <4310845.fn2SnuB68N@yow-masselst-lx1>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <97ddefbb-12a8-50e6-faf3-001271ac669e@broadcom.com> (sfid-20170314_142830_399589_43D744B3)
Date: Tue, 14 Mar 2017 14:27:53 +0100
MIME-Version: 1.0
In-Reply-To: <4310845.fn2SnuB68N@yow-masselst-lx1>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14-3-2017 14:21, Mark Asselstine wrote:
> On Tuesday, March 14, 2017 1:41:02 PM EDT Arend Van Spriel wrote:
>> On 14-3-2017 12:28, Johannes Berg wrote:
>>>> It never came up with any projects so far. 
> 
> Myself and one of my colleagues had thought that this might be the case. On 
> the bright side this matches my inability to find any discussions on the 
> matter and that there is the possibility to get this functionality added.
> 
>>>> I doubt that the patch
>>>> below is sufficient. I suspect something more is needed. Using git
>>>> blame I ended up finding these commits:
>>>>
>>>> a272a72 mac80211: allow using network namespaces
>>>
>>> This is needed in brcm drivers.
> 
> I will have a closer look, thanks for the pointer to this patch.
> 
>>>
>>>> 463d018 cfg80211: make aware of net namespaces
>>>
>>> This has no impact on brcm drivers :)
>>>
>>>> 5061b0c mac80211: cooperate more with network namespaces
>>>
>>> This shouldn't be needed, you're not referring to init_net in brcm
>>> drivers.
>>>
>>>> I think what is required from brcmfmac is to set netns for each
>>>> netdev that we create to the same netns as the wiphy instance using
>>>> wiphy_net().
>>>
>>> Yes, like the mac80211 patch above.
>>>
>>>> Not sure if there is more to consider, but hopefully Johannes can
>>>> comment on this although the mentioned commits have been around for a
>>>> while.
>>>
>>> I don't think there's anything else.
>>>
>>>>>         wiphy->flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT |
>>>>>         
>>>>>                         WIPHY_FLAG_OFFCHAN_TX |
>>>>>
>>>>> -                       WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
>>>>> +                       WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
>>>>> +                       WIPHY_FLAG_NETNS_OK;
>>>
>>> This is not sufficient, you still have to set the netns for newly
>>> created netdevs.
> 
> Ah, that is something I had not tested out. I moved an existing phy and its 
> associated vif and things worked as expected and also destroying the NS had 
> things move back as expected. I did not however create any new vifs
> 
>>
>> Thanks for confirming my suspicion.
>>
>> Regards,
>> Arend
> 
> Thanks for the quick pointers, not being all that familiar with the wireless 
> code I appreciate the discussion. I will have a closer look and see if I can 
> get a patch out for review.

Hi Mark,

I looked at it and preparing a patch. Will send it out shortly to give
it a try.

Regards,
Arend
