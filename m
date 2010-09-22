Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55822 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab0IVQnP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 12:43:15 -0400
Received: by gxk9 with SMTP id 9so232004gxk.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Sep 2010 09:43:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinn-nPed0nCvveBUtkY3AEHf_+bVvV=q1J=XzdY@mail.gmail.com>
References: <AANLkTik3_o03=m0w8XM_B-YTQrR-ibkbtTBErXfcYwGG@mail.gmail.com>
	<201009221336.14382.chunkeey@googlemail.com>
	<AANLkTim3YQ4vNyM_OA4qc+mjGJiwYoHrLB=x1sp+R8vP@mail.gmail.com>
	<201009221424.39949.chunkeey@googlemail.com>
	<AANLkTikbyQi7dJFrqJrVmr7kV==tZoLRPaufC6tJv743@mail.gmail.com>
	<AANLkTi=OF0=Ox7xoGpygL87eoxDyEgDiALi4R-pSNe+V@mail.gmail.com>
	<AANLkTinaaAp8XXbqEmA-BCEbSQ8oMV5M-BNSs2iKmyNk@mail.gmail.com>
	<AANLkTinn-nPed0nCvveBUtkY3AEHf_+bVvV=q1J=XzdY@mail.gmail.com>
Date: Wed, 22 Sep 2010 20:43:13 +0400
Message-ID: <AANLkTinevz-Re9z15CO5tXHygP2n4F13=QUGFsyZLdTC@mail.gmail.com>
Subject: Re: p54spi (STLC4560) with Marvel XScale CPU (kernel 2.6.25.4)
From: Max Filippov <jcmvbkbc@gmail.com>
To: Alex Mihaylov <minimumlaw@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>> This code from Sagrad:
>>>
>>>        SPI_IRQ(DISABLE);
>>>
>>> [skiped]
>>
>> If you look closer into the skipped part you'll see
>>
>>        // 13. Enable host interrupts (EHostIntEnable1 = KIrqReady |
>> KIrqWrReady | KHwUpdate | KSwUpdate)
>>        TempReg = (SPI_HOST_INT_READY | SPI_HOST_INT_UPDATE |
>> SPI_HOST_INT_SW_UPDATE| SPI_HOST_INT_WR_READY);
>>        SPIDRVWriteReg32(SPI_ADRS_HOST_INT_EN, TempReg);
>>
>> which actually enables interrupts, exactly as SPI_IRQ(ENABLE); does.
>>
>>>
>>>       // 14. Wait for the READY interrupt (100 ms timeout).
>>>        // Loop while waiting for SPI device to respond with
>>> interrupt, max timeout is WIFI_BOOT_TIMEOUT
>>>        for ( i = 0 ; i < WIFI_BOOT_TIMEOUT ; i++)
>>>        {
>>>                TempReg = SPIDRVReadReg32(SPI_ADRS_HOST_INTERRUPTS);
>>>                if( TempReg && SPI_HOST_INT_READY)
>>>                {
>>>                        // 15. Acknowledge the READY interrupt.
>>>                        SPIDRVWriteReg32(SPI_ADRS_HOST_INT_ACK,
>>> SPI_HOST_INT_READY);
>>>                        // 16. Issue the SLEEP interrupt.
>>>                        SPIDRVWriteReg32(SPI_ADRS_ARM_INTERRUPTS,
>>> SPI_ARM_INT_SLEEP);
>>>                        break;
>>>                }
>>>
>>>                Delay(1);
>>>        }
>>>
>>>        SPI_IRQ(ENABLE);
>
> OK. Chip (STLC4560) have some reasons to make IRQ reqest to host
> (XScale or Omap). In code:
>
> SPIDRVWriteReg32(SPI_ADRS_HOST_INT_EN, TempReg);
>
> we set IRQ mask for chip. So, chip CAN generate IRQ request to host
> (make pulse on host IRQ GPIO line). But host NOT serve this interrupt
> request ( SPI_IRQ(DISABLE) ). Host wait for event by pool interrupt
> reason register. In linux kernel (p54spi.c) host serve this IRQ.
> SPI_IRQ(ENABLE/DISABLE) used for enable/disable host handler, but
> SPIDRVWriteReg32(SPI_ADRS_HOST_INT_EN, TempReg) used for device IRQ
> reason control. I think so.

Look at the code of SPI_IRQ routine:

void SPI_IRQ(FunctionalState state)
{
    NVIC_InitTypeDef NVIC_InitStructure;
    static FunctionalState CurrState = DISABLE;
    // Check if we're changing states, otherwise just leave it.
    if(state != CurrState)
    {
        // 5. Configure the interrupt controller for the External
Interrupt x SPI
        // Enable the interrupt controller for the External Interrupt
        NVIC_InitStructure.NVIC_IRQChannel = WIFI_INT_IRQ_CHAN;
        NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0;
        NVIC_InitStructure.NVIC_IRQChannelSubPriority = 0;
        NVIC_InitStructure.NVIC_IRQChannelCmd = state;
        NVIC_Init(&NVIC_InitStructure);

        if( state == ENABLE )
        {
            SPIDRVWriteReg32(SPI_ADRS_HOST_INT_EN, SPI_HOST_INTS_DEFAULT);
        }
        else
        {
            SPIDRVWriteReg32(SPI_ADRS_HOST_INT_EN, 0);
        }
        CurrState = state;
    }

}

There's some activity with something unknown to me: // 5. Configure
the interrupt controller for the External Interrupt x SPI
And then programming of the stlc's HOST_INT_EN.

It's not quite clear to me, what is that NVIC and what additional
external interrupt configuration is going on. What's clear is that
it's not related to the stlc chip. Looks like there's additional
hardware on your board that conveys interrupt signal and that has to
be configured.

In nokia's N810 stlc's IRQ line seems to be connected directly to gpio
pin. That gpio line is configured in p54spi_probe and that's enough
for interrupts to get to us.

-- 
Max
