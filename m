Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:46272 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759211Ab1F1SUH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2011 14:20:07 -0400
Message-ID: <4E0A1B4F.8080700@boundarydevices.com> (sfid-20110628_203844_531788_1234E3A8)
Date: Tue, 28 Jun 2011 11:19:59 -0700
From: Troy Kisky <troy.kisky@boundarydevices.com>
MIME-Version: 1.0
To: "Levi, Shahar" <shahar_levi@ti.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: WL1271: WLAN_IRQ not working
References: <4E0942CA.9010402@boundarydevices.com> <BANLkTikp+58Ae14a1OXr0F_OSsip69++yQ@mail.gmail.com>
In-Reply-To: <BANLkTikp+58Ae14a1OXr0F_OSsip69++yQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/27/2011 11:19 PM, Levi, Shahar wrote:
> On Tue, Jun 28, 2011 at 5:56 AM, Troy Kisky
> <troy.kisky@boundarydevices.com> wrote:
>> Hi
> Hi Troy,
> 
>>
>> I trying to get an LSR WL1271 sdio module to work. Everything seems to
>> work fine until the WLAN_IRQ pin should go high, but it never does. Checking
>> with a scope shows constant low. proc/interrupts also says 0. I'm using
>> 3.0.0-rc4 with patches for non-mainline board. If I make the interrupt
>> gp a high output, I can raise the level of the WLAN_IRQ pin slightly,
>> but it is still a logic 0.
>>
>>
>> tiwi_r2_datasheet.pdf says interrupts are "active-low or falling-edge"
>>
>> So, why does the driver request an active high interrupt? I'm guessing
>> datasheet bug.
>>
>> Anyway, here are the messages I'm getting with most debugging turned on,
>> if someone is willing to take a look.
>>
>> Thanks
>> Troy
> Could you possibly check the irq pin setting fit to your platform? It
> is read via wl12xx_get_platform_data().
> The driver irq is HIGH polarity level. In case your platform not
> support level you can switch to edge via
> WL12XX_PLATFORM_QUIRK_EDGE_IRQ.
> 
> All the best,
> Shahar
> 

Thanks for taking a look. I'm pretty sure it is a hardware problem and
not software. proc/interrupts is showing the correct irq as claimed.
Looking at a scope, I'm just getting no activity on the WLAN_IRQ pin.


The datasheet says that the slow clock is 32768 HZ +/- 150 ppm. Mine
currently measures 32650. This needs fixed, but is unlikely to be my
problem isn't it?

Perhaps I have a power up sequence problem ?


wbr
Troy

