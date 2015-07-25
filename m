Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:34662 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441AbbGYVAh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2015 17:00:37 -0400
Received: by lafd3 with SMTP id d3so20233323laf.1
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2015 14:00:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55B3DB9A.9060209@hauke-m.de>
References: <1435504633-20831-1-git-send-email-zajec5@gmail.com>
	<CACna6rzFYpwbzM+s-KzFQmTym4iLVn+Ap+DWgFmAZzhWKTQfJw@mail.gmail.com>
	<871tfzif17.fsf@kamboji.qca.qualcomm.com>
	<CAGhQ9VyH4yvnU_kPAy3a7Z+80jNV8uNoTr=Nd=eV2D-iz9YVUQ@mail.gmail.com>
	<55B3DB9A.9060209@hauke-m.de>
Date: Sat, 25 Jul 2015 23:00:35 +0200
Message-ID: <CAGhQ9VyV2LuDUEjtOYgTZg3kEDr5XJs8FqjXpV7wLC2U2CBd-w@mail.gmail.com> (sfid-20150725_230736_484742_9E1A0D9A)
Subject: Re: [PATCH] bcma: populate bus DT subnodes as platform_device-s
From: Joachim Eastwood <manabian@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 July 2015 at 20:55, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> On 07/24/2015 06:11 PM, Joachim Eastwood wrote:
>> On 23 July 2015 at 08:06, Kalle Valo <kvalo@codeaurora.org> wrote:
>>> Rafał Miłecki <zajec5@gmail.com> writes:
>>>
>>>>> +       if (bus->host_pdev) {
>>>>> +               struct device *dev = &bus->host_pdev->dev;
>>>>> +
>>>>> +               of_platform_populate(dev->of_node, of_default_bus_match_table,
>>>>> +                                    NULL, dev);
>>>>> +       }
>>>>> +
>>>>
>>>> This caused a compile error when using bcma as module:
>>>> ERROR: "of_default_bus_match_table" [drivers/bcma/bcma.ko] undefined!
>>
>> I encountered the same problem with my modular memory controller driver.
>>
>>>> There are two options I guess:
>>>> 1) Export of_default_bus_match_table
>>
>> See link below for Rob Herring's take on that.
>> http://marc.info/?l=linaro-kernel&m=143766694414121&w=2
>>
>>
>> regards,
>> Joachim Eastwood
>>
> Hi Joachim,
>
> are you working on a patch which exports "of_default_bus_match_table"
> or provides a wrapper function? If not then I will look into this.

Not really, so if you could take it that would be great. Thanks.

regards,
Joachim Eastwood
