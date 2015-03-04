Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:35884 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbbCDMIu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2015 07:08:50 -0500
MIME-Version: 1.0
In-Reply-To: <CACna6rxJ_uQHmpQS9NPs9JW=zNS4oc2-_cH6nXG0Z9CWu7iW7A@mail.gmail.com>
References: <BLU436-SMTP3656F4A0610686DAE30BA1B9110@phx.gbl>
	<CACna6rxJ_uQHmpQS9NPs9JW=zNS4oc2-_cH6nXG0Z9CWu7iW7A@mail.gmail.com>
Date: Wed, 4 Mar 2015 13:08:49 +0100
Message-ID: <CACna6ryi4ACAfkYRDGTWkwGh9PQrj9zxcnaWjO56m1dyhmiFGA@mail.gmail.com> (sfid-20150304_130908_740840_AF188F44)
Subject: Re: [PATCH] bcma: Kconfig: Let it depend on PCI
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Chen Gang <xili_gchen_5257@hotmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4 March 2015 at 07:19, Rafał Miłecki <zajec5@gmail.com> wrote:
> On 3 March 2015 at 22:16, Chen Gang <xili_gchen_5257@hotmail.com> wrote:
>> bcma also needs PCI, just like IOMEM and DMA, so let it depend on PCI,
>> or will cause building break for allmodconfig under c6x:
>>
>>     CC [M]  drivers/bcma/driver_pcie2.o
>>   drivers/bcma/driver_pcie2.c: In function 'bcma_core_pcie2_up':
>>   drivers/bcma/driver_pcie2.c:196:8: error: implicit declaration of function 'pcie_set_readrq' [-Werror=implicit-function-declaration]
>>     err = pcie_set_readrq(dev, pcie2->reqsize);
>>           ^
>>
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>> ---
>>  drivers/bcma/Kconfig | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
>> index 0ee48be..8be284e 100644
>> --- a/drivers/bcma/Kconfig
>> +++ b/drivers/bcma/Kconfig
>> @@ -1,6 +1,6 @@
>>  config BCMA_POSSIBLE
>>         bool
>> -       depends on HAS_IOMEM && HAS_DMA
>> +       depends on HAS_IOMEM && HAS_DMA && PCI
>>         default y
>>
>>  menu "Broadcom specific AMBA"
>> --
>> 1.9.3
>
> Hm, I'm not sure how to ideally handle this. Cc-ing few ppl, maybe
> they have something to add.
>
> In fact there are SoCs (not using PCI host code obviously) with
> everything embedded (without any PCI host mode cores). So note
> following info about driver_pci.c and driver_pcie2.c:
> 1) For BCMA_HOST_PCI
> They are required, because of needed host-related PCI(e) core initialization.
> 2) For BCMA_HOST_SOC
> They are needed only if your SoC has PCI(e) host cores and you want to use them.
>
> So I guess in theory we could have BCMA_DRIVER_PCI and *require* it
> for BCMA_HOST_PCI only.

After thinking about this.
We already have Kconfig entries for other internal drivers, so I guess
it makes sense to do the same for PCIe.

-- 
Rafał
