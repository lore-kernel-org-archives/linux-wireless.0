Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49092 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727093AbeIGNpS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Sep 2018 09:45:18 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>, arnd@arndb.de
Subject: Re: [PATCH] net: wireless: mediatek: fix mt76 LEDS build error
References: <563c7f90-1d9f-440c-4670-8fbebc9f76b0@infradead.org>
        <20180907075612.GB2725@localhost.localdomain>
Date: Fri, 07 Sep 2018 12:05:13 +0300
In-Reply-To: <20180907075612.GB2725@localhost.localdomain> (Lorenzo Bianconi's
        message of "Fri, 7 Sep 2018 09:56:12 +0200")
Message-ID: <87d0tp65km.fsf@kamboji.qca.qualcomm.com> (sfid-20180907_110522_052835_773F0530)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:

>> From: Randy Dunlap <rdunlap@infradead.org>
>> 
>> All of the mt76 driver options use its mac80211.o component,
>> which uses led interfaces, so each of them should depend on
>> LEDS_CLASS.
>> 
>> Fixes this build error:
>> 
>> drivers/net/wireless/mediatek/mt76/mac80211.o: In function `mt76_led_init':
>> drivers/net/wireless/mediatek/mt76/mac80211.c:119: undefined
>> reference to `devm_of_led_classdev_register'
>> 
>> Fixes: 17f1de56df05 ("mt76: add common code shared between multiple chipsets")
>> 
>
> Hi Randy,
>
> a fix for it has been already proposed by Arnd here:
> https://marc.info/?l=linux-wireless&m=151628136830540&w=2
> but it has not been applied yet

Yet? Arnd's patch is not on my queue as it's from last January and Felix
had a comment for it:

https://patchwork.kernel.org/patch/10173197/

-- 
Kalle Valo
