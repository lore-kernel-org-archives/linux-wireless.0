Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:55032 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab3FYPcY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jun 2013 11:32:24 -0400
Received: by mail-ob0-f175.google.com with SMTP id xn12so12393228obc.34
        for <linux-wireless@vger.kernel.org>; Tue, 25 Jun 2013 08:32:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQnda59qziwwjVfH7zCmQipED7TuxsDg0RgWA7ZK78gALQ@mail.gmail.com>
References: <1372171926-2686-1-git-send-email-zajec5@gmail.com>
	<CA+BoTQnda59qziwwjVfH7zCmQipED7TuxsDg0RgWA7ZK78gALQ@mail.gmail.com>
Date: Tue, 25 Jun 2013 17:32:23 +0200
Message-ID: <CACna6rxHNko8i_CxnNNSV9kZCFgUENsaoaz93Pb8WJr24vJUfg@mail.gmail.com> (sfid-20130625_173227_085362_2EE7FB70)
Subject: Re: [RFH][PATCH] bcma: add support for BCM43142
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/6/25 Michal Kazior <michal.kazior@tieto.com>:
> On 25 June 2013 16:52, Rafał Miłecki <zajec5@gmail.com> wrote:
>> I got following problem with the patch:
>>   CC [M]  drivers/bcma/driver_chipcommon_pmu.o
>> drivers/bcma/driver_chipcommon_pmu.c: In function ‘bcma_pmu2_pll_init0’:
>> drivers/bcma/driver_chipcommon_pmu.c:128:5: warning: large integer implicitly truncated to unsigned type [-Woverflow]
>>
>> This is caused by:
>> mask = ~(BCMA_RES_4314_HT_AVAIL |
>>          BCMA_RES_4314_MACPHY_CLK_AVAIL);
>>
>> Any idea why
>> u32 mask = ~(BIT(28) | BIT(29))
>> causes that? :|
>>
>> I could expect that in case of using BIT(31), but not 28/29...
>
> Are you perhaps compiling for a 64bit target? If so then I you're
> dealing with a 64bit bitmask here. Negating ends up as an overflow as
> you try to cram it into the 32bit var.

Ahh, thanks!

Is there any preferred solution for that?
u32 mask = (u32)~(BIT(28) | BIT(29))
u32 mask = ~(BIT(28) | BIT(29)) & 0xFFFF
? I guess the first one looks nicer?

-- 
Rafał
