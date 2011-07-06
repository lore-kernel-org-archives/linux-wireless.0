Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36367 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014Ab1GFPwl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 11:52:41 -0400
Received: by pzk9 with SMTP id 9so49023pzk.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jul 2011 08:52:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110706174046.0ae24b6d@maggie>
References: <1309902848-3141-1-git-send-email-zajec5@gmail.com>
	<1309902848-3141-2-git-send-email-zajec5@gmail.com>
	<20110706174046.0ae24b6d@maggie>
Date: Wed, 6 Jul 2011 17:52:40 +0200
Message-ID: <CACna6ryHRNLNPrPam2dAWLysqtFLtE8bcu4A26A4xFj2ui2eNg@mail.gmail.com> (sfid-20110706_175245_100375_20780194)
Subject: Re: [PATCH 2/2] b43: implement BCMA bus ops
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 6 lipca 2011 17:40 użytkownik Michael Büsch <m@bues.ch> napisał:
> On Tue,  5 Jul 2011 23:54:08 +0200
> Rafał Miłecki <zajec5@gmail.com> wrote:
>
>>
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>>  drivers/net/wireless/b43/bus.c  |  100 +++++++++++++++++++++++++++++++++++++++
>>  drivers/net/wireless/b43/bus.h  |    3 +
>>  drivers/net/wireless/b43/main.c |    7 +++
>>  3 files changed, 110 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/net/wireless/b43/bus.c b/drivers/net/wireless/b43/bus.c
>> index 4200713..f56604f 100644
>> --- a/drivers/net/wireless/b43/bus.c
>> +++ b/drivers/net/wireless/b43/bus.c
>> @@ -23,6 +23,106 @@
>>  #include "b43.h"
>>  #include "bus.h"
>>
>> +/* BCMA */
>> +#ifdef CONFIG_B43_BCMA
>> +static inline int b43_bus_bcma_bus_may_powerdown(struct b43_bus_dev *dev)
>> +{
>> +     return 0; /* bcma_bus_may_powerdown(dev->bdev->bus); */
>> +}
>
> Why is this inline?
> You can't inline and take a pointer of the function at the same time.
> (The compiler will workaround this by generating multiple versions of
> the function, of which at least one is not inline).
> So remove it, please. Same below...

I didn't know about any such a limitation.

Just for sure: did you really mean "pointer of the function"? Cause my
function is taking pointer of the struct, not pointer of function.

-- 
Rafał
