Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43550 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab0IVMdz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 08:33:55 -0400
Received: by iwn5 with SMTP id 5so528269iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Sep 2010 05:33:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201009221424.39949.chunkeey@googlemail.com>
References: <AANLkTik3_o03=m0w8XM_B-YTQrR-ibkbtTBErXfcYwGG@mail.gmail.com>
	<201009221336.14382.chunkeey@googlemail.com>
	<AANLkTim3YQ4vNyM_OA4qc+mjGJiwYoHrLB=x1sp+R8vP@mail.gmail.com>
	<201009221424.39949.chunkeey@googlemail.com>
Date: Wed, 22 Sep 2010 16:33:54 +0400
Message-ID: <AANLkTikbyQi7dJFrqJrVmr7kV==tZoLRPaufC6tJv743@mail.gmail.com>
Subject: Re: p54spi (STLC4560) with Marvel XScale CPU (kernel 2.6.25.4)
From: Alex Mihaylov <minimumlaw@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/9/22 Christian Lamparter <chunkeey@googlemail.com>:
> why polling? They even say "14. Wait for the READY interrupt".

This code from Sagrad:

        SPI_IRQ(DISABLE);

        // Turn the device Off and then On again.
        SPIDRV_Pwr(FALSE);
        SPIDRV_Pwr(TRUE);

        // 1. Power up
        // 2. Wait 240 ms.
        Delay(480);

[skiped]

       // 14. Wait for the READY interrupt (100 ms timeout).
        // Loop while waiting for SPI device to respond with
interrupt, max timeout is WIFI_BOOT_TIMEOUT
        for ( i = 0 ; i < WIFI_BOOT_TIMEOUT ; i++)
        {
                TempReg = SPIDRVReadReg32(SPI_ADRS_HOST_INTERRUPTS);
                if( TempReg && SPI_HOST_INT_READY)
                {
                        // 15. Acknowledge the READY interrupt.
                        SPIDRVWriteReg32(SPI_ADRS_HOST_INT_ACK,
SPI_HOST_INT_READY);
                        // 16. Issue the SLEEP interrupt.
                        SPIDRVWriteReg32(SPI_ADRS_ARM_INTERRUPTS,
SPI_ARM_INT_SLEEP);
                        break;
                }

                Delay(1);
        }

        SPI_IRQ(ENABLE);

        if (i == WIFI_BOOT_TIMEOUT)
        {
                ret = FALSE;
        }
        else
        {
                ret = TRUE;
                SET_WIFI_ACTIVE();
        }

SPIDRVReadReg32(SPI_ADRS_HOST_INTERRUPTS) - poll SPI register. IRQ
from STLC chip disabled.

> Have you checked if the module parameters for power + irq are correct?

Yes. I check this in code and on osciloscope.

> Also, on power_on the driver currently waits just 10 and not 240 ms,
> maybe this could just be the problem...

OK. I try change this.

-- 
Sincerely,
Alex A. Mihaylov
AKA MinimumLaw
