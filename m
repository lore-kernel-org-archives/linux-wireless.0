Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:53095 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360Ab0FUILS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 04:11:18 -0400
Received: by pxi12 with SMTP id 12so1271415pxi.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jun 2010 01:11:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1277002793.18385.6.camel@100.103.161.25.in-addr.arpa>
References: <AANLkTik5z5SL_JB2-_elmbdyt1rDSxY3IHVEi2V_4uLD@mail.gmail.com>
	<1277002793.18385.6.camel@100.103.161.25.in-addr.arpa>
Date: Mon, 21 Jun 2010 10:11:18 +0200
Message-ID: <AANLkTimwSH0Xy92KBZRicLUVBU3uyCvAjwapM9M0jOAk@mail.gmail.com>
Subject: Re: Bad performance for libertas on Murata combo.
From: =?UTF-8?Q?Enric_Balletb=C3=B2_i_Serra?= <eballetbo@gmail.com>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

2010/6/20 Dan Williams <dcbw@redhat.com>:
> On Sat, 2010-06-19 at 15:53 +0200, Enric Balletbò i Serra wrote:
>> Hi all,
>>
>> Maybe someone can help me ...
>>
>> I am in the process of enabling WLAN for a target board. It has a WLAN
>> Bluetooth (WLAN-BT) combo module from MuRata which has a Marvell WLAN
>> (88W8686) + CSR Bluetooth chipset.
>
> What SDIO host controller?  Does the host controller support interrupts
> and 4-bit mode?  We've always been able to get good performance out of
> laptop host controllers (Ricoh mostly) and the largest source of
> performance issues has always been quirky hardware or non-optimized SDHC
> drivers.  Are there any errata for your SDHC that you're aware of?

I'm using the OMAP controller (omap_hsmmc). The controller is using
4-bit mode but does not support interrupts. Exist some experimental
patches to add support for IRQ to controller which increases the
performance but still is not good.

On the other hand, I'm a bit puzzled with excessive 'Rx invalid crypt'
, 'Invalid misc' and 'Tx excessive retries' reported by iwconfig. Just
going to one web page produces more than 100K "Invalid Misc" errors.
I'm not sure what this means but I think is not a good thing.

Anyone can explain me what exactly means 'Rx invalid crypt' , 'Invalid
misc' and 'Tx excessive retries'  ? What could be wrong? Or how can I
investigate more ?

Thanks in advance,

Enric

>
> If you also turn on kernel MMC debugging and the 'dmesg' output of the
> controller and the libertas device being recognized, that can sometimes
> help determine where the problem lies.
>
> Dan
>
>
>> I can connect to an AP, but the performance is too low. Pinging my AP
>> I see a lot of 'Rx invalid crypt' and 'Invalid misc' packets.
>>
>> I'm using the libertas driver from mainline kernel (2.6.35-rc3) with
>> SDIO interface and these errors are reported using the iwconfig
>> command.
>>
>> I also tested with 2.6.34 and 2.6.33 with same result.
>>
>> Any idea about what this means ? What could be wrong? Or how can I
>> investigate more ?
>>
>> Thanks in advance,
>>
>> Enric
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
