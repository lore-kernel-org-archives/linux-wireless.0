Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:59955 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932104AbbGYSzZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2015 14:55:25 -0400
Message-ID: <55B3DB9A.9060209@hauke-m.de> (sfid-20150725_205528_168797_1C6ED0F7)
Date: Sat, 25 Jul 2015 20:55:22 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Joachim Eastwood <manabian@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] bcma: populate bus DT subnodes as platform_device-s
References: <1435504633-20831-1-git-send-email-zajec5@gmail.com>	<CACna6rzFYpwbzM+s-KzFQmTym4iLVn+Ap+DWgFmAZzhWKTQfJw@mail.gmail.com>	<871tfzif17.fsf@kamboji.qca.qualcomm.com> <CAGhQ9VyH4yvnU_kPAy3a7Z+80jNV8uNoTr=Nd=eV2D-iz9YVUQ@mail.gmail.com>
In-Reply-To: <CAGhQ9VyH4yvnU_kPAy3a7Z+80jNV8uNoTr=Nd=eV2D-iz9YVUQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/24/2015 06:11 PM, Joachim Eastwood wrote:
> On 23 July 2015 at 08:06, Kalle Valo <kvalo@codeaurora.org> wrote:
>> Rafał Miłecki <zajec5@gmail.com> writes:
>>
>>>> +       if (bus->host_pdev) {
>>>> +               struct device *dev = &bus->host_pdev->dev;
>>>> +
>>>> +               of_platform_populate(dev->of_node, of_default_bus_match_table,
>>>> +                                    NULL, dev);
>>>> +       }
>>>> +
>>>
>>> This caused a compile error when using bcma as module:
>>> ERROR: "of_default_bus_match_table" [drivers/bcma/bcma.ko] undefined!
> 
> I encountered the same problem with my modular memory controller driver.
> 
>>> There are two options I guess:
>>> 1) Export of_default_bus_match_table
> 
> See link below for Rob Herring's take on that.
> http://marc.info/?l=linaro-kernel&m=143766694414121&w=2
> 
> 
> regards,
> Joachim Eastwood
> 
Hi Joachim,

are you working on a patch which exports "of_default_bus_match_table"
or provides a wrapper function? If not then I will look into this. My
current plan for bcma is just to deactivate this when it is build as a
module as a temporary workaround

Hauke
