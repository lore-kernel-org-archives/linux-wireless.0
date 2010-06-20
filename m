Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755200Ab0FTC7L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jun 2010 22:59:11 -0400
Subject: Re: Bad performance for libertas on Murata combo.
From: Dan Williams <dcbw@redhat.com>
To: Enric =?ISO-8859-1?Q?Balletb=F2?= i Serra <eballetbo@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTik5z5SL_JB2-_elmbdyt1rDSxY3IHVEi2V_4uLD@mail.gmail.com>
References: <AANLkTik5z5SL_JB2-_elmbdyt1rDSxY3IHVEi2V_4uLD@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 19 Jun 2010 19:59:53 -0700
Message-ID: <1277002793.18385.6.camel@100.103.161.25.in-addr.arpa>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-06-19 at 15:53 +0200, Enric Balletbò i Serra wrote:
> Hi all,
> 
> Maybe someone can help me ...
> 
> I am in the process of enabling WLAN for a target board. It has a WLAN
> Bluetooth (WLAN-BT) combo module from MuRata which has a Marvell WLAN
> (88W8686) + CSR Bluetooth chipset.

What SDIO host controller?  Does the host controller support interrupts
and 4-bit mode?  We've always been able to get good performance out of
laptop host controllers (Ricoh mostly) and the largest source of
performance issues has always been quirky hardware or non-optimized SDHC
drivers.  Are there any errata for your SDHC that you're aware of?

If you also turn on kernel MMC debugging and the 'dmesg' output of the
controller and the libertas device being recognized, that can sometimes
help determine where the problem lies.

Dan


> I can connect to an AP, but the performance is too low. Pinging my AP
> I see a lot of 'Rx invalid crypt' and 'Invalid misc' packets.
> 
> I'm using the libertas driver from mainline kernel (2.6.35-rc3) with
> SDIO interface and these errors are reported using the iwconfig
> command.
> 
> I also tested with 2.6.34 and 2.6.33 with same result.
> 
> Any idea about what this means ? What could be wrong? Or how can I
> investigate more ?
> 
> Thanks in advance,
> 
> Enric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


