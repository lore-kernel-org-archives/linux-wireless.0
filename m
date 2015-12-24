Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:39963 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbbLXDCq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2015 22:02:46 -0500
Message-ID: <567B6140.1090907@atmel.com> (sfid-20151224_040319_957609_2FA68981)
Date: Thu, 24 Dec 2015 12:06:40 +0900
From: glen lee <glen.lee@atmel.com>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tony Cho <tony.cho@atmel.com>, <leo.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: Re: [PATCH] staging: wilc1000: remove wilc_sdio_init
References: <1450838003-24379-1-git-send-email-glen.lee@atmel.com> <CAGRGNgWrFdRYXg+912stL9fcYE2ZqbEzNoOiHnyjYvX+5BHR=A@mail.gmail.com>
In-Reply-To: <CAGRGNgWrFdRYXg+912stL9fcYE2ZqbEzNoOiHnyjYvX+5BHR=A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2015년 12월 24일 11:39, Julian Calaby wrote:
> Hi Glen,
>
> On Wed, Dec 23, 2015 at 1:33 PM, Glen Lee <glen.lee@atmel.com> wrote:
>> wilc_sdio_init return always 1. It is needless, so just remove it and it's
>> related codes also.
>>
>> Signed-off-by: Glen Lee <glen.lee@atmel.com>
>> ---
>>   drivers/staging/wilc1000/wilc_sdio.c | 12 ------------
>>   1 file changed, 12 deletions(-)
>>
>> diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
>> index e961b50..caad876 100644
>> --- a/drivers/staging/wilc1000/wilc_sdio.c
>> +++ b/drivers/staging/wilc1000/wilc_sdio.c
>> @@ -185,11 +185,6 @@ static void wilc_sdio_disable_interrupt(struct wilc *dev)
>>          dev_info(&func->dev, "wilc_sdio_disable_interrupt OUT\n");
>>   }
>>
>> -static int wilc_sdio_init(void)
>> -{
>> -       return 1;
>> -}
>> -
>>   /********************************************
>>    *
>>    *      Function 0
>> @@ -611,13 +606,6 @@ static int sdio_init(struct wilc *wilc)
>>
>>          g_sdio.irq_gpio = (wilc->dev_irq_num);
>>
>> -       if (!wilc_sdio_init()) {
>> -               dev_err(&func->dev, "Failed io init bus...\n");
>> -               return 0;
>> -       } else {
>> -               return 0;
>> -       }
>> -
> This isn't equivalent code as both arms of the if statement eventually
> call return 0.

Hi julian,

Yes, you are correct.
Actually, The original code was like this before It is patched wrongly.
-       if (!wilc_sdio_init()) {
-               dev_err(&func->dev, "Failed io init bus...\n");
-               return 0;
-       }
I could fix this first and then remove wilc_sdio_init().
But I thought that this can be fixed by removing wilc_sdio_init which also fixes always return 0 error.

Do you think I should fix "always return 0 error" first and then remove wilc_sdio_init()?
Or update change log about the error which cause this?

regards,
glen lee.

>
> Thanks,
>

