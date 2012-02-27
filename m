Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3242 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab2B0GcS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 01:32:18 -0500
Message-ID: <4F4B236D.4020504@qca.qualcomm.com> (sfid-20120227_073222_060613_D4C7B1AD)
Date: Mon, 27 Feb 2012 08:32:13 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Ruthy Zaphir <ruthyz@siano-ms.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: ath6kl latest git returns SDIo err -84 at init time
References: <D945C405928A9949A0F33C69E64A1A3B010BCA73@s-mail.siano-ms.ent>
In-Reply-To: <D945C405928A9949A0F33C69E64A1A3B010BCA73@s-mail.siano-ms.ent>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ruthy,

Sorry for the late reply, I was sick.

On 02/20/2012 12:47 PM, Ruthy Zaphir wrote:

>  I am using a SD45 finger evaluation board & cloned yesterday the latest
>  ath6kl git and tested it on my linux laptop(with kernel 2.6.35 but I
> also tried with a newer one with linux 3.0 ) that has
>  an SDIO slot.
> 
>  I am getting the below errors after few first read/write and I am
> starving
>  to understand what is the cause of it.
> 
>  We are building a product with AR6103 integrated and I would like to
>  overcome that issue.
> 
>  Thanks in advance for any support,
> 
>  Hope to get good news :-)
>  Ruthy
> 
>>
>> [39668.250460] mmc0: new SDIO card at address 0001
>> [39668.250726] sdio new func 1 vendor 0x271 device 0x301 block
> 0x800/0x200
>> [39668.250814] 4-bit async irq mode enabled
>> [39668.357814] rd addr 0x450 buf 0xf5f082d0 len 4 ret 0
>> [39668.367833] wr addr 0xff4 buf 0xf5cc0000 len 12 ret 0
>> [39668.377722] rd addr 0x450 buf 0xf5f082d0 len 4 ret 0
>> [39668.387733] wr addr 0xff4 buf 0xf5cc0000 len 12 ret 0
>> [39668.397629] rd addr 0x450 buf 0xf5f082d0 len 4 ret -84
>> [39668.407572] ath6kl_sdio: probe of mmc0:0001:1 failed with error -84

-84 is -EILSEQ and the SDIO subsystm returns that error when we read
from address 0x450. I don't know why that happens, but my first thought
was that there's a problem with the SDIO bus. On what platform are you
testing this? Can you slow down the SDIO bus just to test if that helps?

I haven't tested SD45 myself, so this can be also SD45 specific problem.
Can you enable full logs (0xffffffff) so that we can see packet contents?

Kalle
