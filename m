Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:9186 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752523AbeF3Gav (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 30 Jun 2018 02:30:51 -0400
Subject: Re: [PATCH] atmel: using strlcpy() to avoid possible buffer overflows
To: Andy Shevchenko <andy.shevchenko@gmail.com>
References: <20180629025135.12236-1-yuehaibing@huawei.com>
 <CAHp75Vet-vTz_Ld=Lturmm8NSpK1etvoj-7Wzn4-h=bM2FQgZg@mail.gmail.com>
 <CAHp75VcTVtzLuwH=Ff6DBKJyQE4t=HT7hB2O=gvgN+V-38LH5g@mail.gmail.com>
CC: <simon@thekelleys.org.uk>, Kalle Valo <kvalo@codeaurora.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
From: YueHaibing <yuehaibing@huawei.com>
Message-ID: <1639a6d7-622a-99fc-9321-989661e4b923@huawei.com> (sfid-20180630_083124_066722_C59FBA0B)
Date: Sat, 30 Jun 2018 14:30:34 +0800
MIME-Version: 1.0
In-Reply-To: <CAHp75VcTVtzLuwH=Ff6DBKJyQE4t=HT7hB2O=gvgN+V-38LH5g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 2018/6/30 5:51, Andy Shevchenko wrote:
> On Sat, Jun 30, 2018 at 12:47 AM, Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
>> On Fri, Jun 29, 2018 at 5:51 AM, YueHaibing <yuehaibing@huawei.com> wrote:
>>> 'firmware' is a module param which may been longer than firmware_id,
>>> so using strlcpy() to guard against overflows
>>
>> strncat() is against overflow, this does a bit more.
>>
>>>         priv->firmware_id[0] = '\0';
>> ...
>>>         if (firmware) /* module parameter */
>>> -               strcpy(priv->firmware_id, firmware);
>>> +               strlcpy(priv->firmware_id, firmware, sizeof(priv->firmware_id));
>>
>> In either case the above '\0' is not needed.
>> But it looks like the intention was to use strncat() / strlcat().
> 
> Ah, this is under condition, yes. If no parameter supplied, this needs
> to be clean, but
> priv is allocated with zeroed memory
> https://elixir.bootlin.com/linux/latest/source/net/core/dev.c#L8369

so just remove this line:
	 priv->firmware_id[0] = '\0';

and using strlcpy while 'firmware' NOT null is enough.

Will send v2.

> 
