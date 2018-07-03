Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:45602 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753613AbeGCEv2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jul 2018 00:51:28 -0400
Received: by mail-io0-f193.google.com with SMTP id l25-v6so547414ioh.12
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jul 2018 21:51:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87o9fp8z2o.fsf@purkki.adurom.net>
References: <20180627185845.31799-1-daniel@zonque.org> <CAPDyKFr7snWsk=194u4nKs4301tUARByuEPSFop_fzxn6HVQDQ@mail.gmail.com>
 <dac693d9-b6f4-fac6-3cfa-ccfc4a6172c6@zonque.org> <87o9fp8z2o.fsf@purkki.adurom.net>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Tue, 3 Jul 2018 06:51:26 +0200
Message-ID: <CAPDyKFo9M0jbAy=trp8NAUSRpi85P=QWpy2mTL7yzeKcbQhS7w@mail.gmail.com> (sfid-20180703_065137_766602_0A8B43AB)
Subject: Re: [PATCH v2] libertas: fix suspend and resume for SDIO connected cards
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Daniel Mack <daniel@zonque.org>, Chris Ball <chris@printf.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 July 2018 at 16:57, Kalle Valo <kvalo@codeaurora.org> wrote:
> Daniel Mack <daniel@zonque.org> writes:
>
>> On Friday, June 29, 2018 05:39 PM, Ulf Hansson wrote:
>>> On 27 June 2018 at 20:58, Daniel Mack <daniel@zonque.org> wrote:
>>>> Prior to commit 573185cc7e64 ("mmc: core: Invoke sdio func driver's PM
>>>> callbacks from the sdio bus"), the MMC core used to call into the power
>>>> management functions of SDIO clients itself and removed the card if the
>>>> return code was non-zero. IOW, the mmc handled errors gracefully and didn't
>>>> upchain them to the pm core.
>>>>
>>>> Since this change, the mmc core relies on generic power management
>>>> functions which treat all errors as a reason to cancel the suspend
>>>> immediately. This causes suspend attempts to fail when the libertas
>>>> driver is loaded.
>>>>
>>>> To fix this, power down the card explicitly in if_sdio_suspend() when we
>>>> know we're about to lose power and return success. Also set a flag in these
>>>> cases, and power up the card again in if_sdio_resume().
>>>>
>>>> Signed-off-by: Daniel Mack <daniel@zonque.org>
>>>> Cc: Ulf Hansson <ulf.hansson@linaro.org>
>>>> Cc: Chris Ball <chris@printf.net>
>>>
>>> Looks good to me! Should be a candidate for stable as well!?
>>
>> Thanks!
>>
>> Yeah, it should probably get a
>>
>> Fixes: 573185cc7e64 ("mmc: core: Invoke sdio func driver's PM
>> callbacks from the sdio bus")
>>
>> as well.
>
> So I'll queue this for wireless-drivers-next and add:
>
> Fixes: 573185cc7e64 ("mmc: core: Invoke sdio func driver's PM callbacks from the sdio bus")
> Cc: <stable@vger.kernel.org
>
> Ok?

That's fine by me.

Kind regards
Uffe
