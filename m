Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38299 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbbGWPva (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2015 11:51:30 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Jonas Gorski <jogo@openwrt.org>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] bcma: fix linking problem with of_default_bus_match_table
References: <1437633104-23373-1-git-send-email-kvalo@codeaurora.org>
	<CAOiHx=k=p=0HJewHcVoKaypyrpbpyswes20jX6t3tha+OMf9aQ@mail.gmail.com>
Date: Thu, 23 Jul 2015 18:51:23 +0300
In-Reply-To: <CAOiHx=k=p=0HJewHcVoKaypyrpbpyswes20jX6t3tha+OMf9aQ@mail.gmail.com>
	(Jonas Gorski's message of "Thu, 23 Jul 2015 12:02:47 +0200")
Message-ID: <87k2tqhnyc.fsf@kamboji.qca.qualcomm.com> (sfid-20150723_175133_623621_9AFB45AD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jonas Gorski <jogo@openwrt.org> writes:

> Hi,
>
> On Thu, Jul 23, 2015 at 8:31 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
>
>> diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
>> index 59128478a90f..6b7d54622058 100644
>> --- a/drivers/bcma/main.c
>> +++ b/drivers/bcma/main.c
>> @@ -410,7 +410,7 @@ int bcma_bus_register(struct bcma_bus *bus)
>>                 bcma_core_pci_early_init(&bus->drv_pci[0]);
>>         }
>>
>> -       if (bus->host_pdev) {
>> +       if (IS_BUILTIN(CONFIG_BCMA) && bus->host_pdev) {
>>                 struct device *dev = &bus->host_pdev->dev;
>>
>>                 of_platform_populate(dev->of_node, of_default_bus_match_table,
>
> I think this isn't enough, AFAICT this needs IS_BUILTIN(CONFIG_BCMA)
> && IS_ENABLED(CONFIG_OF), else it will break with OF=n and BCMA=y, as
> of_default_bus_match_table is only defined/built-in when OF=y.

I just tested and OF=n and BCMA=y case built succesfully for me. I think
it's because of_default_bus_match_table is created even when CONFIG_OF
is n. Can you double check, please?

-- 
Kalle Valo
