Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:41434 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752547AbeF2R5r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 13:57:47 -0400
Subject: Re: [PATCH v2] libertas: fix suspend and resume for SDIO connected
 cards
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Chris Ball <chris@printf.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
References: <20180627185845.31799-1-daniel@zonque.org>
 <CAPDyKFr7snWsk=194u4nKs4301tUARByuEPSFop_fzxn6HVQDQ@mail.gmail.com>
From: Daniel Mack <daniel@zonque.org>
Message-ID: <dac693d9-b6f4-fac6-3cfa-ccfc4a6172c6@zonque.org> (sfid-20180629_195757_926335_3D925424)
Date: Fri, 29 Jun 2018 19:57:45 +0200
MIME-Version: 1.0
In-Reply-To: <CAPDyKFr7snWsk=194u4nKs4301tUARByuEPSFop_fzxn6HVQDQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, June 29, 2018 05:39 PM, Ulf Hansson wrote:
> On 27 June 2018 at 20:58, Daniel Mack <daniel@zonque.org> wrote:
>> Prior to commit 573185cc7e64 ("mmc: core: Invoke sdio func driver's PM
>> callbacks from the sdio bus"), the MMC core used to call into the power
>> management functions of SDIO clients itself and removed the card if the
>> return code was non-zero. IOW, the mmc handled errors gracefully and didn't
>> upchain them to the pm core.
>>
>> Since this change, the mmc core relies on generic power management
>> functions which treat all errors as a reason to cancel the suspend
>> immediately. This causes suspend attempts to fail when the libertas
>> driver is loaded.
>>
>> To fix this, power down the card explicitly in if_sdio_suspend() when we
>> know we're about to lose power and return success. Also set a flag in these
>> cases, and power up the card again in if_sdio_resume().
>>
>> Signed-off-by: Daniel Mack <daniel@zonque.org>
>> Cc: Ulf Hansson <ulf.hansson@linaro.org>
>> Cc: Chris Ball <chris@printf.net>
> 
> Looks good to me! Should be a candidate for stable as well!?

Thanks!

Yeah, it should probably get a

Fixes: 573185cc7e64 ("mmc: core: Invoke sdio func driver's PM
callbacks from the sdio bus")

as well.

> I have some additional related changes in mind for the libertas SDIO
> driver, however let me post patches for us to discuss around instead.

I currently have access to such hardware, so I can test patches :)


Thanks,
Daniel
