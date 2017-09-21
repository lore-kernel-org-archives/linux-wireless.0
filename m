Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:37860 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751629AbdIUOer (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Sep 2017 10:34:47 -0400
Received: by mail-io0-f194.google.com with SMTP id 93so5592889iol.4
        for <linux-wireless@vger.kernel.org>; Thu, 21 Sep 2017 07:34:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87h8vylp59.fsf@purkki.adurom.net>
References: <1504102172-5262-1-git-send-email-amitkarwar@gmail.com> <87h8vylp59.fsf@purkki.adurom.net>
From: Amitkumar Karwar <amitkarwar@gmail.com>
Date: Thu, 21 Sep 2017 20:04:46 +0530
Message-ID: <CAEhWJFmJgWfxwWvRahz4vUQe6KQUv8RSTDgsRR=t3xM_U5dMVg@mail.gmail.com> (sfid-20170921_163450_239333_AB090E4E)
Subject: Re: [PATCH] rsi: sdio suspend and resume support
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 19, 2017 at 8:19 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>
>> From: Karun Eagalapati <karun256@gmail.com>
>>
>> SDIO suspend and resume handlers are implemented and verified
>> that device works after suspend/resume cycle.
>>
>> Signed-off-by: Karun Eagalapati <karun256@gmail.com>
>> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
>
> [...]
>
>> +static int rsi_sdio_disable_interrupts(struct sdio_func *pfunc)
>> +{
>> +     struct rsi_hw *adapter = sdio_get_drvdata(pfunc);
>> +     u8 isr_status = 0, data = 0;
>> +     int ret;
>> +
>> +     rsi_dbg(INFO_ZONE, "Waiting for interrupts to be cleared..");
>> +     do {
>> +             rsi_sdio_read_register(adapter, RSI_FN1_INT_REGISTER,
>> +                                    &isr_status);
>> +             rsi_dbg(INFO_ZONE, ".");
>> +     } while (isr_status);
>
> Never ending loops in kernel are always a bad idea, better to add a
> reasonable timeout if/when something goes wrong.

Thanks for the review. I have taken care of this in v2 patch.

Regards,
Amitkumar Karwar
