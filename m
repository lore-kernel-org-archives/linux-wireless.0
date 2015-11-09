Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:36093 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbbKIIvU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2015 03:51:20 -0500
MIME-Version: 1.0
In-Reply-To: <20151109081842.GR18797@mwanda>
References: <1447018310-4524-1-git-send-email-punitvara@gmail.com>
	<20151108215953.GO18797@mwanda>
	<563FFEEB.1090307@atmel.com>
	<56405328.4040004@atmel.com>
	<20151109081842.GR18797@mwanda>
Date: Mon, 9 Nov 2015 14:21:19 +0530
Message-ID: <CABXAfNKVB1X6zj+XD1rwTuFqFzcgfoXFRRb-F66yHBjcAfVCOg@mail.gmail.com> (sfid-20151109_095137_698018_19F20E57)
Subject: Re: [PATCH V2] Staging: wilc1000: Fix build break due to undeclared
 *wilc and implicit declaration of init_irq
From: punit vara <punitvara@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: glen lee <glen.lee@atmel.com>, devel@driverdev.osuosl.org,
	chris.park@atmel.com, Austin Shin <austin.shin@atmel.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	linux-kernel@vger.kernel.org, tony.cho@atmel.com, leo.kim@atmel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 9, 2015 at 1:48 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Mon, Nov 09, 2015 at 05:02:48PM +0900, glen lee wrote:
>> Hi Punit Vara,
>>
>> I cannot find build errors on my build machines.
>>
>> According the log which you have posted before says *wilc is undeclared in the function init_wilc_driver,
>> which means WILC_SPI is selected because one of SPI or SDIO should be chosen at the moment.
>> Hence, struct wilc *wilc should be compiled together.
>> It looks like wilc1000 is compiled without SPI or SDIO.
>>
>> Of course, there are many cases that I don't know, so you could let me know the wilc1000 build configuration?
>>
>> static int __init init_wilc_driver(void)
>> {
>> #ifdef WILC_SPI
>
> This should be #ifndef WILC_SDIO
>
>
>>       struct wilc *wilc;
>> #endif
>
> But the large question remains of why do we have this variable here any
> way?
>
> regards,
> dan carpenter
>
I do not know why it is there .that is why I did not touch it first
my proposed patch was like
#if (defined WILC_SPI) || (!defined WILC_SDIO)
struct wilc *wilc;
#endif
