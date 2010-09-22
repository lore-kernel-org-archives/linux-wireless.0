Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51178 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635Ab0IVMYo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 08:24:44 -0400
Received: by fxm3 with SMTP id 3so220538fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Sep 2010 05:24:43 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Alex Mihaylov <minimumlaw@gmail.com>
Subject: Re: p54spi (STLC4560) with Marvel XScale CPU (kernel 2.6.25.4)
Date: Wed, 22 Sep 2010 14:24:39 +0200
Cc: linux-wireless@vger.kernel.org
References: <AANLkTik3_o03=m0w8XM_B-YTQrR-ibkbtTBErXfcYwGG@mail.gmail.com> <201009221336.14382.chunkeey@googlemail.com> <AANLkTim3YQ4vNyM_OA4qc+mjGJiwYoHrLB=x1sp+R8vP@mail.gmail.com>
In-Reply-To: <AANLkTim3YQ4vNyM_OA4qc+mjGJiwYoHrLB=x1sp+R8vP@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201009221424.39949.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 22 September 2010 14:01:46 Alex Mihaylov wrote:
> 2010/9/22 Christian Lamparter <chunkeey@googlemail.com>:
> > their GPL driver looks funny. (Max, it's really worth a look)
> > anyway found this:
> >        /*
> >           Sequence taken from STLC4560 DataSheet
> >           This sequence can be run with the maximum SPI clock frequency (that is, 48 MHz).
> >           1. Power up.
> >           2. Wait 240 ms.
> >           3. Halt processor (EHostDeviceCntrl2 = KSetHostOverride | KSetHostCPUEn=0).
> >           4. Wait 1 us.
> >           5. Enable DMA TX (EHostDmaTxCntrl, KDmaTxCntrlEnable).
> >           6. Write DMA TX length (EHostDmaTxLength).
> >           7. Write DMA TX base (EHostDmaTxBase1).
> >           8. Wait 1 ìs.
> >           9. Write firmware image (EHostDmaData).
> >           10. RAM reset (EHostDeviceCntrl2 = KSetHostOverride | KSetHostReset | KSetRamBoot).
> >           11. Wait 40 ms.
> >           12. RAM boot (EHostDeviceCntrl2 = KSetHostOverride | KSetRamBoot),
> >           13. Enable host interrupts (EHostIntEnable1 = KIrqReady | KIrqWrReady | KHwUpdate | KSwUpdate).
> >           14. Wait for the READY interrupt (100 ms timeout).
> >           15. Acknowledge the READY interrupt.
> >           16. Issue the SLEEP interrupt.
> >         */
> >
> > maybe it helps
> 
> Yes. I see this code. But in p54spi.c I found sequence from 1 to 13.
> Sagrad make this steps with disabler interrupt from card (poll chip
> register). But p54spi wait hardware READY IRQ from chip in 14 (and in
> IRQ routine send acknowledge from 15).

why polling? They even say "14. Wait for the READY interrupt".

Have you checked if the module parameters for power + irq are correct?

static int p54spi_gpio_power = 97;
MODULE_PARM_DESC(p54spi_gpio_power, "gpio number for power line");

static int p54spi_gpio_irq = 87;
MODULE_PARM_DESC(p54spi_gpio_irq, "gpio number for irq line");

Also, on power_on the driver currently waits just 10 and not 240 ms,
maybe this could just be the problem...
