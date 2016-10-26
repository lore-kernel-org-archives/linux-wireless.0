Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37924 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751129AbcJZGry (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 02:47:54 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Prameela Rani Garnepudi <prameela.garnepudi@redpinesignals.com>
Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        linux-wireless@vger.kernel.org, johannes.berg@intel.com,
        hofrat@osadl.org, xypron.glpk@gmx.de
Subject: Re: [PATCH 1/3] rsi: Fix memory leak in module unload
References: <1476357946-15460-1-git-send-email-prameela.j04cs@gmail.com>
        <87inswcs1j.fsf@kamboji.qca.qualcomm.com>
        <87bmyo1g1v.fsf@purkki.adurom.net>
        <7a4d28a2-53ac-bc81-bf2c-452434d6768e@redpinesignals.com>
Date: Wed, 26 Oct 2016 09:47:48 +0300
In-Reply-To: <7a4d28a2-53ac-bc81-bf2c-452434d6768e@redpinesignals.com>
        (Prameela Rani Garnepudi's message of "Mon, 24 Oct 2016 11:33:40
        +0530")
Message-ID: <87a8dr7giz.fsf@kamboji.qca.qualcomm.com> (sfid-20161026_084756_940073_EF6624C6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prameela Rani Garnepudi <prameela.garnepudi@redpinesignals.com> writes:

> On 10/13/2016 07:56 PM, Kalle Valo wrote: 
>> Kalle Valo <kvalo@codeaurora.org> writes: 
>> 
>>> Prameela Rani Garnepudi <prameela.j04cs@gmail.com> writes: 
>>> 
>>>> Observed crash when module is unloaded if CONFIG_RSI_DEBUGSFS is not set. 
>>>>     Fix: Debugfs entry removal moved inside CONFIG_RSI_DEBUGSFS flag in 
>>>>               function rsi_mac80211_detach() 
>>>> Memory leak found and fixed for below structures in function
> rsi_mac80211_detach() 
>>>>     * channel list for each supported band 
>>>>     * rsi debugfs info 
>>>> 
>>>> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com> 
>>> BTW, I don't see patch 2 in patchwork nor in linux-wireless, but I do 
>>> see it on my inbox. Either it's slow or there was a problem with the 
>>> delivery. 
>> It was just slow, I see it now: 
>> 
>> https://patchwork.kernel.org/patch/9374987/ 
>> 
> Hi, 
> Can you please review this patch. 

wireless-drivers-next is not open yet as I was on vacation last week,
hoping to open it today.

And instead of mailing me please check the status from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#checking_state_of_patches_from_patchwork

If you see lots of patches pending submitted around the same time as
yours it's a pretty good hint that I just haven't been able to go
through my queue:

https://patchwork.kernel.org/project/linux-wireless/list/?state=*&delegate=25621

-- 
Kalle Valo
