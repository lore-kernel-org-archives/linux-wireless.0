Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:39167 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbbGWQEV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2015 12:04:21 -0400
Subject: Re: [PATCH] bcma: fix linking problem with of_default_bus_match_table
To: Kalle Valo <kvalo@codeaurora.org>
References: <1437633104-23373-1-git-send-email-kvalo@codeaurora.org>
 <CAOiHx=k=p=0HJewHcVoKaypyrpbpyswes20jX6t3tha+OMf9aQ@mail.gmail.com>
 <87k2tqhnyc.fsf@kamboji.qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Jonas Gorski <jogo@openwrt.org>
Message-ID: <55B11085.5040909@openwrt.org> (sfid-20150723_180425_061373_9ED3E6EE)
Date: Thu, 23 Jul 2015 18:04:21 +0200
MIME-Version: 1.0
In-Reply-To: <87k2tqhnyc.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23.07.2015 17:51, Kalle Valo wrote:
> Jonas Gorski <jogo@openwrt.org> writes:
> 
>> Hi,
>>
>> On Thu, Jul 23, 2015 at 8:31 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
>>
>>> diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
>>> index 59128478a90f..6b7d54622058 100644
>>> --- a/drivers/bcma/main.c
>>> +++ b/drivers/bcma/main.c
>>> @@ -410,7 +410,7 @@ int bcma_bus_register(struct bcma_bus *bus)
>>>                 bcma_core_pci_early_init(&bus->drv_pci[0]);
>>>         }
>>>
>>> -       if (bus->host_pdev) {
>>> +       if (IS_BUILTIN(CONFIG_BCMA) && bus->host_pdev) {
>>>                 struct device *dev = &bus->host_pdev->dev;
>>>
>>>                 of_platform_populate(dev->of_node, of_default_bus_match_table,
>>
>> I think this isn't enough, AFAICT this needs IS_BUILTIN(CONFIG_BCMA)
>> && IS_ENABLED(CONFIG_OF), else it will break with OF=n and BCMA=y, as
>> of_default_bus_match_table is only defined/built-in when OF=y.
> 
> I just tested and OF=n and BCMA=y case built succesfully for me. I think
> it's because of_default_bus_match_table is created even when CONFIG_OF
> is n. Can you double check, please?
> 

Thinking more about it, I know/remember why it complies even if it
shouldn't: the inline prototype for !OF of of_platform_populate does not
use any of the arguments so the compiler optimises the reference out.
So unless you compile with -O0, you are fine.

I always forget that this works, so sorry for the noise.


Jonas
