Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63156 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab0IVO5Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 10:57:16 -0400
Received: by iwn5 with SMTP id 5so612263iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Sep 2010 07:57:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTikbyQi7dJFrqJrVmr7kV==tZoLRPaufC6tJv743@mail.gmail.com>
References: <AANLkTik3_o03=m0w8XM_B-YTQrR-ibkbtTBErXfcYwGG@mail.gmail.com>
	<201009221336.14382.chunkeey@googlemail.com>
	<AANLkTim3YQ4vNyM_OA4qc+mjGJiwYoHrLB=x1sp+R8vP@mail.gmail.com>
	<201009221424.39949.chunkeey@googlemail.com>
	<AANLkTikbyQi7dJFrqJrVmr7kV==tZoLRPaufC6tJv743@mail.gmail.com>
Date: Wed, 22 Sep 2010 18:57:15 +0400
Message-ID: <AANLkTi=OF0=Ox7xoGpygL87eoxDyEgDiALi4R-pSNe+V@mail.gmail.com>
Subject: Re: p54spi (STLC4560) with Marvel XScale CPU (kernel 2.6.25.4)
From: Max Filippov <jcmvbkbc@gmail.com>
To: Alex Mihaylov <minimumlaw@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> This code from Sagrad:
>
>        SPI_IRQ(DISABLE);
>
>        // Turn the device Off and then On again.
>        SPIDRV_Pwr(FALSE);
>        SPIDRV_Pwr(TRUE);
>
>        // 1. Power up
>        // 2. Wait 240 ms.
>        Delay(480);
>
> [skiped]

If you look closer into the skipped part you'll see

	// 13. Enable host interrupts (EHostIntEnable1 = KIrqReady |
KIrqWrReady | KHwUpdate | KSwUpdate)
	TempReg = (SPI_HOST_INT_READY | SPI_HOST_INT_UPDATE |
SPI_HOST_INT_SW_UPDATE| SPI_HOST_INT_WR_READY);
	SPIDRVWriteReg32(SPI_ADRS_HOST_INT_EN, TempReg);

which actually enables interrupts, exactly as SPI_IRQ(ENABLE); does.

>
>       // 14. Wait for the READY interrupt (100 ms timeout).
>        // Loop while waiting for SPI device to respond with
> interrupt, max timeout is WIFI_BOOT_TIMEOUT
>        for ( i = 0 ; i < WIFI_BOOT_TIMEOUT ; i++)
>        {
>                TempReg = SPIDRVReadReg32(SPI_ADRS_HOST_INTERRUPTS);
>                if( TempReg && SPI_HOST_INT_READY)
>                {
>                        // 15. Acknowledge the READY interrupt.
>                        SPIDRVWriteReg32(SPI_ADRS_HOST_INT_ACK,
> SPI_HOST_INT_READY);
>                        // 16. Issue the SLEEP interrupt.
>                        SPIDRVWriteReg32(SPI_ADRS_ARM_INTERRUPTS,
> SPI_ARM_INT_SLEEP);
>                        break;
>                }
>
>                Delay(1);
>        }
>
>        SPI_IRQ(ENABLE);
>
>        if (i == WIFI_BOOT_TIMEOUT)
>        {
>                ret = FALSE;
>        }
>        else
>        {
>                ret = TRUE;
>                SET_WIFI_ACTIVE();
>        }
>

-- 
Max
