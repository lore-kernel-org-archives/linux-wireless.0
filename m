Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59351 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbbGWGGf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2015 02:06:35 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Arnd Bergmann <arnd@arndb.de>,
	"linux-arm-kernel\@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] bcma: populate bus DT subnodes as platform_device-s
References: <1435504633-20831-1-git-send-email-zajec5@gmail.com>
	<CACna6rzFYpwbzM+s-KzFQmTym4iLVn+Ap+DWgFmAZzhWKTQfJw@mail.gmail.com>
Date: Thu, 23 Jul 2015 09:06:28 +0300
In-Reply-To: <CACna6rzFYpwbzM+s-KzFQmTym4iLVn+Ap+DWgFmAZzhWKTQfJw@mail.gmail.com>
	(=?utf-8?Q?=22Rafa=C5=82_Mi=C5=82ecki=22's?= message of "Thu, 23 Jul 2015
 02:30:41 +0200")
Message-ID: <871tfzif17.fsf@kamboji.qca.qualcomm.com> (sfid-20150723_080638_804961_A9284B1B)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

>> +       if (bus->host_pdev) {
>> +               struct device *dev = &bus->host_pdev->dev;
>> +
>> +               of_platform_populate(dev->of_node, of_default_bus_match_table,
>> +                                    NULL, dev);
>> +       }
>> +
>
> This caused a compile error when using bcma as module:
> ERROR: "of_default_bus_match_table" [drivers/bcma/bcma.ko] undefined!
>
> There are two options I guess:
> 1) Export of_default_bus_match_table
> 2) Use some better condition like
> if (IS_BUILTIN(CONFIG_BCMA) && bus->host_pdev)
>
> Unfortunately I'm on my long holidays right now.
>
> Hauke: do you think you can find a moment to handle this?

I can cook up a patch which uses IS_BUILTIN() so that we get the build
working again. You can fix this better once you come back.

> Sorry for the problem :|

No worries, enjoy your vacation :)

-- 
Kalle Valo
