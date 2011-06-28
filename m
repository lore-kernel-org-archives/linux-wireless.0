Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:41166 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756425Ab1F1GTj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2011 02:19:39 -0400
Received: by vxd2 with SMTP id 2so5724031vxd.21
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jun 2011 23:19:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E0942CA.9010402@boundarydevices.com>
References: <4E0942CA.9010402@boundarydevices.com>
Date: Tue, 28 Jun 2011 09:19:24 +0300
Message-ID: <BANLkTikp+58Ae14a1OXr0F_OSsip69++yQ@mail.gmail.com> (sfid-20110628_082535_624781_E6860897)
Subject: Re: WL1271: WLAN_IRQ not working
From: "Levi, Shahar" <shahar_levi@ti.com>
To: Troy Kisky <troy.kisky@boundarydevices.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 28, 2011 at 5:56 AM, Troy Kisky
<troy.kisky@boundarydevices.com> wrote:
> Hi
Hi Troy,

>
> I trying to get an LSR WL1271 sdio module to work. Everything seems to
> work fine until the WLAN_IRQ pin should go high, but it never does. Checking
> with a scope shows constant low. proc/interrupts also says 0. I'm using
> 3.0.0-rc4 with patches for non-mainline board. If I make the interrupt
> gp a high output, I can raise the level of the WLAN_IRQ pin slightly,
> but it is still a logic 0.
>
>
> tiwi_r2_datasheet.pdf says interrupts are "active-low or falling-edge"
>
> So, why does the driver request an active high interrupt? I'm guessing
> datasheet bug.
>
> Anyway, here are the messages I'm getting with most debugging turned on,
> if someone is willing to take a look.
>
> Thanks
> Troy
Could you possibly check the irq pin setting fit to your platform? It
is read via wl12xx_get_platform_data().
The driver irq is HIGH polarity level. In case your platform not
support level you can switch to edge via
WL12XX_PLATFORM_QUIRK_EDGE_IRQ.

All the best,
Shahar
