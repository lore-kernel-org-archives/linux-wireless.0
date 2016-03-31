Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:35452 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757251AbcCaWEz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2016 18:04:55 -0400
Received: by mail-io0-f176.google.com with SMTP id g185so131876673ioa.2
        for <linux-wireless@vger.kernel.org>; Thu, 31 Mar 2016 15:04:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1728313528.26642.1459388027120.JavaMail.yahoo@mail.yahoo.com>
References: <CAJ-Vmomxbp4j3kmHOwf8AXB+s7jEDZGSR0j2Da=TjU324eHvNg@mail.gmail.com>
	<1728313528.26642.1459388027120.JavaMail.yahoo@mail.yahoo.com>
Date: Thu, 31 Mar 2016 15:04:54 -0700
Message-ID: <CAJ-VmonT5AWXzstdxbR+R6p4ia-ui6WFaQ9Tq28TzLd-uh4dUw@mail.gmail.com> (sfid-20160401_000458_396063_4045A9B0)
Subject: Re: Bonjour mDNS broacast can be lost during BT-WLAN coexistence schemes?
From: Adrian Chadd <adrian@freebsd.org>
To: sandeep suresh <sandeep.suresh@yahoo.co.in>
Cc: Ath9k-devel <ath9k-devel@lists.ath9k.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30 March 2016 at 18:33, sandeep suresh <sandeep.suresh@yahoo.co.in> wrote:
> Hello Adrian,
> Thanks for the response. Regarding your comment, "I don't think you can get
> interrupts based on that, but you can poll the gpio pin yourself "
> In any MCU, we should be able generate an interrupt on rising/falling edge
> of GPIO and execute the ISR. Simillary, isn't it possible in ath9k to
> trigger a rising edge interrupt on BT_ACTIVE and in the respective ISR send
> a packet with power save management mode bit set. Similarly on the falling
> edge send a packet with power save management mode bit reset? Because
> polling for GPIOs every milliseconds will consume too much of CPU and not
> performance friendly for any system.

I know. There's apparently GPIO interrupt support in the ath9k
hardware but I've never used it. All of the register definition should
be there though!

I just don't know if you'll get them if it's being wired as a
BT_ACTIVE pin instead of a GPIO pin..


-adrian

> Regards
> Sandeep.
>
>
> On Thursday, 31 March 2016 1:32 AM, Adrian Chadd <adrian@freebsd.org> wrote:
>
>
> Hi!
>
> I don't know if you can do simulaneous wlan and BT RX - especially
> since WLAN RX sometimes requires ACKs to be sent. :) But for
> multicast, sure. You'd have to check the NIC schematic and antenna
> switch programming to see if you can do simultaneous wlan RX (with no
> TXing, eg RTS/CTS, ACK, etc) whilst also doing BT RX.
>
> As for BT_ACTIVE -> powersave; I don't think you can get interrupts
> based on that, but you can poll the gpio pin yourself and then tell
> the driver to not transmit and/or enter sleep state. Entering sleep
> state requires that you send some frame anyway to tell the AP you're
> going to sleep.
>
>
>
> -a
>
>
