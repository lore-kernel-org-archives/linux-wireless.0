Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:64191 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbaEPEJF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2014 00:09:05 -0400
Received: by mail-we0-f170.google.com with SMTP id u57so2016833wes.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 21:09:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5374F638.6000505@dewberryfields.co.uk>
References: <5346DED8.2030704@free.fr>
	<CAJwzM1k=OOBa7C3u0+TzmRUBwMYfJSMgB+smbORfKmPE6KnF2g@mail.gmail.com>
	<53480138.2080805@free.fr>
	<53733AB4.7010500@free.fr>
	<20140514215126.GA15419@us.netrek.org>
	<CAJwzM1k+75qRJaONyehMNPaOqOHyBhryMGBtZ4NpD6jGHk-cHQ@mail.gmail.com>
	<5374F638.6000505@dewberryfields.co.uk>
Date: Fri, 16 May 2014 09:39:03 +0530
Message-ID: <CAJwzM1mvK1i3ENrQyVZNoiwYFiopWGRaOVe5iGTr61TQVXdaMQ@mail.gmail.com> (sfid-20140516_060917_264601_819B7D09)
Subject: Re: Mwifiex driver on Globalscale Mirabox
From: Avinash Patil <avinashapatil@gmail.com>
To: Michael Howard <mike@dewberryfields.co.uk>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Michael,

This is different issue. We are trying to download 11AC_CFG command on
SD8787 where 11ac is not supported.
Thanks for reporting this; we are looking into it.

Thanks,
Avinash

On Thu, May 15, 2014 at 10:45 PM, Michael Howard
<mike@dewberryfields.co.uk> wrote:
>
> On 15/05/2014 15:06, Avinash Patil wrote:
>>
>> Hi James/Anthony,
>>
>> If an unsupported command is downloaded to FW, it results into command
>> response not supported - code 0x2.
>> It wouldnt result into command timeout.
>> According to our internal discussions, this issue is seen only on
>> Globalscale mirabox where SDIO controller is mvsdio.
>>
>> "On Mirabox the SDIO controller is mvsdio. It polls for interrupts but
>> polling itself doesn’t seem to be the problem.
>> In the log, I got from another person it seems that there is no
>> SDIO_INT bit in controller “intr” register after scan command is sent.
>> Other commands are fine, only scan commands fail. I don’t why scan
>> (0x06 or 0x107) is special in this case."
>>
>> Hi Anthony,
>>
>> Could you please enable dynamic debug on mwifiex, mwifiex_sdio &
>> mvsdio driver; this will confirm if this is same issue.
>>
>> Thanks,
>> Avinash.
>>
> Using kernel 3.15.0-rc5, starting hostapd results in;
>
> May 15 17:11:04 mirabox kernel: mwifiex_sdio mmc0:0001:1: CMD_RESP: cmd
> 0x112 error, result=0x2
>
> hostapd runs but there in no AP.
>
> If I can be of any help testing/debugging just say so.
>
> Cheers,
> Mike.
>
> --
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
