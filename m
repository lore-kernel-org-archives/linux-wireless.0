Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:18503 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaJIRSe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 13:18:34 -0400
Message-ID: <5436C367.5080908@broadcom.com> (sfid-20141009_191856_240781_E5944169)
Date: Thu, 9 Oct 2014 19:18:31 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Guenter Roeck <linux@roeck-us.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	"Arnd Bergmann" <arnd@arndb.de>
Subject: Re: [PATCH] bcma: Add dependency on OF_ADDRESS
References: <1412872877-1771-1-git-send-email-linux@roeck-us.net> <CACna6rzOeGcKrrftLx_3uWe_bAXQaQMmWb3wWHP0CjtdO8D0eg@mail.gmail.com> <5436C2B4.6030801@broadcom.com>
In-Reply-To: <5436C2B4.6030801@broadcom.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/09/14 19:15, Arend van Spriel wrote:
> On 10/09/14 18:54, Rafał Miłecki wrote:
>> On 9 October 2014 18:41, Guenter Roeck<linux@roeck-us.net> wrote:
>>> Commit 2101e533f41a ("bcma: register bcma as device tree driver")
>>> introduces a hard dependency on OF_ADDRESS into the bcma driver.
>>> OF_ADDRESS is specifically disabled for the sparc architecture.
>>> This results in the following error when building sparc64:allmodconfig.
>
> Does this mean on sparc (using allmodconfig) you will get CONFIG_OF and
> !CONFIG_OF_ADDRESS? Does that makes sense?

Is CONFIG_OF is used on sparc to access OpenBoot information?

Regards,
Arend

> btw. the OF_ADDRESS dependency was introduced by commit "bcma: get IRQ
> numbers from dt".
>
> Regards,
> Arend
>
>> Won't this make bcma im-POSSIBLE on MIPS? And maybe x86(_64), or at
>> least add an unneeded dependency? I think we should somehow limit this
>> to BCM5301X arch.
>> --
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at http://www.tux.org/lkml/
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at http://www.tux.org/lkml/

