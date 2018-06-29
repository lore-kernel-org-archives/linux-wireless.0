Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:38905 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934086AbeF2Vvu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 17:51:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAHp75Vet-vTz_Ld=Lturmm8NSpK1etvoj-7Wzn4-h=bM2FQgZg@mail.gmail.com>
References: <20180629025135.12236-1-yuehaibing@huawei.com> <CAHp75Vet-vTz_Ld=Lturmm8NSpK1etvoj-7Wzn4-h=bM2FQgZg@mail.gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Sat, 30 Jun 2018 00:51:49 +0300
Message-ID: <CAHp75VcTVtzLuwH=Ff6DBKJyQE4t=HT7hB2O=gvgN+V-38LH5g@mail.gmail.com> (sfid-20180629_235206_897682_17994FAB)
Subject: Re: [PATCH] atmel: using strlcpy() to avoid possible buffer overflows
To: YueHaibing <yuehaibing@huawei.com>
Cc: simon@thekelleys.org.uk, Kalle Valo <kvalo@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 30, 2018 at 12:47 AM, Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Fri, Jun 29, 2018 at 5:51 AM, YueHaibing <yuehaibing@huawei.com> wrote:
>> 'firmware' is a module param which may been longer than firmware_id,
>> so using strlcpy() to guard against overflows
>
> strncat() is against overflow, this does a bit more.
>
>>         priv->firmware_id[0] = '\0';
> ...
>>         if (firmware) /* module parameter */
>> -               strcpy(priv->firmware_id, firmware);
>> +               strlcpy(priv->firmware_id, firmware, sizeof(priv->firmware_id));
>
> In either case the above '\0' is not needed.
> But it looks like the intention was to use strncat() / strlcat().

Ah, this is under condition, yes. If no parameter supplied, this needs
to be clean, but
priv is allocated with zeroed memory
https://elixir.bootlin.com/linux/latest/source/net/core/dev.c#L8369

-- 
With Best Regards,
Andy Shevchenko
