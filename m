Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52609 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366Ab0IVMBr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 08:01:47 -0400
Received: by gyd8 with SMTP id 8so114616gyd.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Sep 2010 05:01:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201009221336.14382.chunkeey@googlemail.com>
References: <AANLkTik3_o03=m0w8XM_B-YTQrR-ibkbtTBErXfcYwGG@mail.gmail.com>
	<AANLkTi=M9zSKkckxqs6XwBg3290L9yijmCbRn9_E93xJ@mail.gmail.com>
	<AANLkTinLbpycwLjVpHhx+ZdTzXkxC4jQ6iqrOOF6Fsc4@mail.gmail.com>
	<201009221336.14382.chunkeey@googlemail.com>
Date: Wed, 22 Sep 2010 16:01:46 +0400
Message-ID: <AANLkTim3YQ4vNyM_OA4qc+mjGJiwYoHrLB=x1sp+R8vP@mail.gmail.com>
Subject: Re: p54spi (STLC4560) with Marvel XScale CPU (kernel 2.6.25.4)
From: Alex Mihaylov <minimumlaw@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/9/22 Christian Lamparter <chunkeey@googlemail.com>:
> their GPL driver looks funny. (Max, it's really worth a look)
> anyway found this:
>        /*
>           Sequence taken from STLC4560 DataSheet
>           This sequence can be run with the maximum SPI clock frequency (that is, 48 MHz).
>           1. Power up.
>           2. Wait 240 ms.
>           3. Halt processor (EHostDeviceCntrl2 = KSetHostOverride | KSetHostCPUEn=0).
>           4. Wait 1 us.
>           5. Enable DMA TX (EHostDmaTxCntrl, KDmaTxCntrlEnable).
>           6. Write DMA TX length (EHostDmaTxLength).
>           7. Write DMA TX base (EHostDmaTxBase1).
>           8. Wait 1 ìs.
>           9. Write firmware image (EHostDmaData).
>           10. RAM reset (EHostDeviceCntrl2 = KSetHostOverride | KSetHostReset | KSetRamBoot).
>           11. Wait 40 ms.
>           12. RAM boot (EHostDeviceCntrl2 = KSetHostOverride | KSetRamBoot),
>           13. Enable host interrupts (EHostIntEnable1 = KIrqReady | KIrqWrReady | KHwUpdate | KSwUpdate).
>           14. Wait for the READY interrupt (100 ms timeout).
>           15. Acknowledge the READY interrupt.
>           16. Issue the SLEEP interrupt.
>         */
>
> maybe it helps

Yes. I see this code. But in p54spi.c I found sequence from 1 to 13.
Sagrad make this steps with disabler interrupt from card (poll chip
register). But p54spi wait hardware READY IRQ from chip in 14 (and in
IRQ routine send acknowledge from 15).

I think about rewrite this driver complete, but... This solution not so pretty.


// stage 13
       /* enable host interrupts */
        p54spi_write32(priv, SPI_ADRS_HOST_INT_EN,
                       cpu_to_le32(SPI_HOST_INTS_DEFAULT));
// stage 10
        /* boot the device */
        p54spi_write16(priv, SPI_ADRS_DEV_CTRL_STAT, cpu_to_le16(
                       SPI_CTRL_STAT_HOST_OVERRIDE | SPI_CTRL_STAT_HOST_RESET |
                       SPI_CTRL_STAT_RAM_BOOT));

        msleep(TARGET_BOOT_SLEEP);
//stage 12
        p54spi_write16(priv, SPI_ADRS_DEV_CTRL_STAT, cpu_to_le16(
                       SPI_CTRL_STAT_HOST_OVERRIDE | SPI_CTRL_STAT_RAM_BOOT));
        msleep(TARGET_BOOT_SLEEP);

May be after RAM BOOT interrupts in chip disabled?

-- 
Sincerely,
Alex A. Mihaylov
AKA MinimumLaw
