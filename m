Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:45517 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaJJEcn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2014 00:32:43 -0400
Date: Fri, 10 Oct 2014 00:32:38 -0400 (EDT)
Message-Id: <20141010.003238.851779524160284732.davem@davemloft.net> (sfid-20141010_063309_275731_ADCDA1E8)
To: julian.calaby@gmail.com
Cc: linux@roeck-us.net, sparclinux@vger.kernel.org, arend@broadcom.com,
	zajec5@gmail.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, hauke@hauke-m.de, arnd@arndb.de
Subject: Re: [PATCH] bcma: Add dependency on OF_ADDRESS
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAGRGNgWWSX8rYatphNAmx+j3wZ7RAXgucUzi_7M6-3NeUjQDEg@mail.gmail.com>
References: <5436C2B4.6030801@broadcom.com>
	<20141009172120.GB2410@roeck-us.net>
	<CAGRGNgWWSX8rYatphNAmx+j3wZ7RAXgucUzi_7M6-3NeUjQDEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=euc-kr
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 10 Oct 2014 11:24:53 +1100

> Hi,
> 
> On Fri, Oct 10, 2014 at 4:21 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>> On Thu, Oct 09, 2014 at 07:15:32PM +0200, Arend van Spriel wrote:
>>> On 10/09/14 18:54, Rafa©© Mi©©ecki wrote:
>>> >On 9 October 2014 18:41, Guenter Roeck<linux@roeck-us.net>  wrote:
>>> >>Commit 2101e533f41a ("bcma: register bcma as device tree driver")
>>> >>introduces a hard dependency on OF_ADDRESS into the bcma driver.
>>> >>OF_ADDRESS is specifically disabled for the sparc architecture.
>>> >>This results in the following error when building sparc64:allmodconfig.
>>>
>>> Does this mean on sparc (using allmodconfig) you will get CONFIG_OF
>>> and !CONFIG_OF_ADDRESS? Does that makes sense?
>>>
>>
>> You tell me. From drivers/of/Kconfig:
>>
>> config OF_ADDRESS
>>         def_bool y
>>         depends on !SPARC
>>         select OF_ADDRESS_PCI if PCI
>>
>> Presumably there is a reason to disable OF_ADDRESS for sparc.
> 
> Why not ask the sparclinux list? (CC'd)

On sparc, at boot time we precompute all of the addresses provided in
the OF device tree.

So we need none of this OF_ADDRESS infrastructure.

Frankly, I've always believed that this is how address computation
should be done on OF platforms, and it simplifies drivers massively.
You really only need to implement 2 or 3 bus translators to make it
work.  Others have disagreed with me.
