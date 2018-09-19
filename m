Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55778 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731368AbeISVqW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 17:46:22 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>, arnd@arndb.de
Subject: Re: [PATCH] net: wireless: mediatek: fix mt76 LEDS build error
References: <563c7f90-1d9f-440c-4670-8fbebc9f76b0@infradead.org>
        <20180907075612.GB2725@localhost.localdomain>
        <87d0tp65km.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 19 Sep 2018 19:07:43 +0300
In-Reply-To: <87d0tp65km.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
        of "Fri, 07 Sep 2018 12:05:13 +0300")
Message-ID: <874lelsc6o.fsf@purkki.adurom.net> (sfid-20180919_180749_603989_1BAB776D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
>
>>> From: Randy Dunlap <rdunlap@infradead.org>
>>> 
>>> All of the mt76 driver options use its mac80211.o component,
>>> which uses led interfaces, so each of them should depend on
>>> LEDS_CLASS.
>>> 
>>> Fixes this build error:
>>> 
>>> drivers/net/wireless/mediatek/mt76/mac80211.o: In function `mt76_led_init':
>>> drivers/net/wireless/mediatek/mt76/mac80211.c:119: undefined
>>> reference to `devm_of_led_classdev_register'
>>> 
>>> Fixes: 17f1de56df05 ("mt76: add common code shared between multiple chipsets")
>>> 
>>
>> Hi Randy,
>>
>> a fix for it has been already proposed by Arnd here:
>> https://marc.info/?l=linux-wireless&m=151628136830540&w=2
>> but it has not been applied yet
>
> Yet? Arnd's patch is not on my queue as it's from last January and Felix
> had a comment for it:
>
> https://patchwork.kernel.org/patch/10173197/

So what should we do? Arnd hasn't submitted a new patch so should we
take this one instead?

-- 
Kalle Valo
