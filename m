Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:16924 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbbJWHvb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 03:51:31 -0400
Subject: Re: [PATCH 00/19] staging/wilc1000 cleanups
To: glen lee <glen.lee@atmel.com>, Arnd Bergmann <arnd@arndb.de>
References: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
 <562763BC.5030107@atmel.com> <4948909.qZ1ebjqtXf@wuerfel>
 <56298F43.7000909@atmel.com>
CC: <linux-wireless@vger.kernel.org>,
	Rachel Kim <rachel.kim@atmel.com>,
	<devel@driverdev.osuosl.org>, Chris Park <chris.park@atmel.com>,
	<gregkh@linuxfoundation.org>,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	<linux-kernel@vger.kernel.org>, Leo Kim <leo.kim@atmel.com>
From: Tony Cho <tony.cho@atmel.com>
Message-ID: <5629E6F1.502@atmel.com> (sfid-20151023_095148_278902_187D1E9F)
Date: Fri, 23 Oct 2015 16:51:13 +0900
MIME-Version: 1.0
In-Reply-To: <56298F43.7000909@atmel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arnd,
First of all, I would like to say "thank you" for your efforts and 
contributions.
We are updating the driver because new revision came up and making new 
patches
to make it stable and elegant as Linux driver. In these days, we are 
sending big changes
while testing such patches and also doing updates at once.

As you did, we are scheduled to provide the patches making device tree 
and delete all of platform
dependencies as you removed WILC_SDIO_IRQ_GPIO as well as other things. 
So, I would like to
discuss with you for your series of patch.

In this time, I think it's important to make the driver to be compiled 
even if the link problem
happens as you reported. So, how about deleting all of SPI related files 
from source tree and
even from Kconfig for the time being because new bus driver will come or 
revert
the Kconfig and then can we expect the best patch in the near feature?

I respect your efforts and patches, so your opinion is very important to me.

Thanks,
Tony.

On 2015년 10월 23일 10:37, glen lee wrote:
>
> On 2015년 10월 22일 21:23, Arnd Bergmann wrote:
>> On Wednesday 21 October 2015 19:06:52 glen lee wrote:
>>> Hi arnd,
>>>
>>> Thanks for the all the patches.
>>> About the patch ( use proper naming for global symbols ),
>>> We are planning to use this driver not only for wilc1000 but also for
>>> other atmel wireless driver. I'd appreciate if you could use wl 
>>> instead of wilc1000.
>>>
>>> And the global variable g_linux_wlan will be placed in netdevice 
>>> private data
>>> and finally it will be removed. I already posted some of those patches.
>> I couldn't find the patches anywhere, but I've updated my series now
>> to rename the symbols to wilc_* and to remove most but not all 
>> references to
>> g_linux_wlan (or wilc_dev after my rename). Do you want me to post those
>> so you can integrate them, or should I have a look at what you sent 
>> first
>> (please send me a copy then).
>
> Hi arnd,
>
> I have tested with all the patches you have posted but it does not 
> works. firmware start timed out
> in the function wilc1000_start_firmware.
> I also have tested with all the patched without last one, [RFC] one, 
> but it shows
> Segmentation fault when insmod driver.
> For now, I can't rebase the patches. I'd appreciate if you could help us.
>
> The title of my first patch is,
> [PATCH 01/13] staging: wilc1000: add wilc to netdev private data 
> structure
> and also refer to [PATCH 00/12] WILC1000 V2 for the g_linux_wlan
> ( The patches posted by tony.cho@atmel.com )
>
> By the way, deleting feature COMPLEMENT_BOOT patch already posted but 
> not yet accepted.
>
> Thank you.
> Glen.
>
>>     Arnd
>

