Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:35342 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbbGXQLs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2015 12:11:48 -0400
Received: by lblf12 with SMTP id f12so18286948lbl.2
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2015 09:11:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <871tfzif17.fsf@kamboji.qca.qualcomm.com>
References: <1435504633-20831-1-git-send-email-zajec5@gmail.com>
	<CACna6rzFYpwbzM+s-KzFQmTym4iLVn+Ap+DWgFmAZzhWKTQfJw@mail.gmail.com>
	<871tfzif17.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 24 Jul 2015 18:11:47 +0200
Message-ID: <CAGhQ9VyH4yvnU_kPAy3a7Z+80jNV8uNoTr=Nd=eV2D-iz9YVUQ@mail.gmail.com> (sfid-20150724_181151_903550_717B14CD)
Subject: Re: [PATCH] bcma: populate bus DT subnodes as platform_device-s
From: Joachim Eastwood <manabian@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 July 2015 at 08:06, Kalle Valo <kvalo@codeaurora.org> wrote:
> Rafał Miłecki <zajec5@gmail.com> writes:
>
>>> +       if (bus->host_pdev) {
>>> +               struct device *dev = &bus->host_pdev->dev;
>>> +
>>> +               of_platform_populate(dev->of_node, of_default_bus_match_table,
>>> +                                    NULL, dev);
>>> +       }
>>> +
>>
>> This caused a compile error when using bcma as module:
>> ERROR: "of_default_bus_match_table" [drivers/bcma/bcma.ko] undefined!

I encountered the same problem with my modular memory controller driver.

>> There are two options I guess:
>> 1) Export of_default_bus_match_table

See link below for Rob Herring's take on that.
http://marc.info/?l=linaro-kernel&m=143766694414121&w=2


regards,
Joachim Eastwood
