Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33572 "EHLO
        mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754731AbcIESe2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Sep 2016 14:34:28 -0400
Received: by mail-pa0-f50.google.com with SMTP id cm16so15992460pac.0
        for <linux-wireless@vger.kernel.org>; Mon, 05 Sep 2016 11:34:28 -0700 (PDT)
Subject: Re: [v2] bcma: use of_dma_configure() to set initial dma mask
To: Arnd Bergmann <arnd@arndb.de>, Kalle Valo <kvalo@codeaurora.org>
References: <20160903140819.245F06216C@smtp.codeaurora.org>
 <6123998.NAlOfyAp5F@wuerfel>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <ba2307b6-e139-0dfb-94c1-ea69548868b4@broadcom.com> (sfid-20160905_203432_877441_178BC5DB)
Date: Mon, 5 Sep 2016 20:34:08 +0200
MIME-Version: 1.0
In-Reply-To: <6123998.NAlOfyAp5F@wuerfel>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 5-9-2016 17:26, Arnd Bergmann wrote:
> On Saturday, September 3, 2016 2:08:19 PM CEST Kalle Valo wrote:
>> Arnd Bergmann <arnd@arndb.de> wrote:
>>> While fixing another bug, I noticed that bcma manually sets up
>>> a dma_mask pointer for its child devices. We have a generic
>>> helper for that now, which should be able to cope better with
>>> any variations that might be needed to deal with cache coherency,
>>> unusual DMA address offsets, iommus, or limited DMA masks, none
>>> of which are currently handled here.
>>>
>>> This changes the core to use the of_dma_configure(), like
>>> we do for platform devices that are probed directly from
>>> DT.
>>>
>>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>>
>> Nobody tested this, so I'll drop the patch.
>>
> 
> Should I resend it? I think it's still required.

Maybe you should request some bcma users (Rafał?) explicitly to test
this. I have no equipment with CONFIG_OF enabled over here.

Regards,
Arend
