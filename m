Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56158 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab0IVRd6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 13:33:58 -0400
Received: by iwn5 with SMTP id 5so682999iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Sep 2010 10:33:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinevz-Re9z15CO5tXHygP2n4F13=QUGFsyZLdTC@mail.gmail.com>
References: <AANLkTik3_o03=m0w8XM_B-YTQrR-ibkbtTBErXfcYwGG@mail.gmail.com>
	<201009221336.14382.chunkeey@googlemail.com>
	<AANLkTim3YQ4vNyM_OA4qc+mjGJiwYoHrLB=x1sp+R8vP@mail.gmail.com>
	<201009221424.39949.chunkeey@googlemail.com>
	<AANLkTikbyQi7dJFrqJrVmr7kV==tZoLRPaufC6tJv743@mail.gmail.com>
	<AANLkTi=OF0=Ox7xoGpygL87eoxDyEgDiALi4R-pSNe+V@mail.gmail.com>
	<AANLkTinaaAp8XXbqEmA-BCEbSQ8oMV5M-BNSs2iKmyNk@mail.gmail.com>
	<AANLkTinn-nPed0nCvveBUtkY3AEHf_+bVvV=q1J=XzdY@mail.gmail.com>
	<AANLkTinevz-Re9z15CO5tXHygP2n4F13=QUGFsyZLdTC@mail.gmail.com>
Date: Wed, 22 Sep 2010 21:33:55 +0400
Message-ID: <AANLkTik7+xBVye_s6gM3XqSn+abPbAoD9RVWOhfrtkkc@mail.gmail.com>
Subject: Re: p54spi (STLC4560) with Marvel XScale CPU (kernel 2.6.25.4)
From: Alex Mihaylov <minimumlaw@gmail.com>
To: linux-wireless Mail List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/9/22 Max Filippov <jcmvbkbc@gmail.com>:
>
> Look at the code of SPI_IRQ routine:
>
> void SPI_IRQ(FunctionalState state)
> {
>    NVIC_InitTypeDef NVIC_InitStructure;
>    static FunctionalState CurrState = DISABLE;
>    // Check if we're changing states, otherwise just leave it.
>    if(state != CurrState)
>    {
>        // 5. Configure the interrupt controller for the External
> Interrupt x SPI
>        // Enable the interrupt controller for the External Interrupt
>        NVIC_InitStructure.NVIC_IRQChannel = WIFI_INT_IRQ_CHAN;
>        NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0;
>        NVIC_InitStructure.NVIC_IRQChannelSubPriority = 0;
>        NVIC_InitStructure.NVIC_IRQChannelCmd = state;
>        NVIC_Init(&NVIC_InitStructure);
>
>        if( state == ENABLE )
>        {
>            SPIDRVWriteReg32(SPI_ADRS_HOST_INT_EN, SPI_HOST_INTS_DEFAULT);
>        }
>        else
>        {
>            SPIDRVWriteReg32(SPI_ADRS_HOST_INT_EN, 0);
>        }
>        CurrState = state;
>    }
>
> }
>
> There's some activity with something unknown to me: // 5. Configure
> the interrupt controller for the External Interrupt x SPI
> And then programming of the stlc's HOST_INT_EN.
>
> It's not quite clear to me, what is that NVIC and what additional
> external interrupt configuration is going on. What's clear is that
> it's not related to the stlc chip. Looks like there's additional
> hardware on your board that conveys interrupt signal and that has to
> be configured.
>
> In nokia's N810 stlc's IRQ line seems to be connected directly to gpio
> pin. That gpio line is configured in p54spi_probe and that's enough
> for interrupts to get to us.

On my board lines IRQ and POWER (realy -SLEEPEN) also connected
directly to GPIO. (In real word they connected via interface chip.
CPUs use 3.3V voltage, STLC on this line use 1.8V - and I, and Nokia
use level-shift chip for connection). In code all simple - first off
all connect STM32 GPIO to interrupt controller and enable/disable this
IRQ source, next check requested action. If command==enable then allow
default STLC IRQ source (all source, but not CTS)
#define SPI_HOST_INT_READY                  0x00000001
#define SPI_HOST_INT_UPDATE                 0x10000000
#define SPI_HOST_INT_SW_UPDATE              0x00000004
#define SPI_HOST_INT_WR_READY               0x00000002

#define SPI_HOST_INT_CTS            0x00004000<>// clear to send
#define SPI_HOST_INT_DR>                    0x00008000<>// data ready

#define SPI_HOST_INTS_DEFAULT                   SPI_HOST_INT_UPDATE |
SPI_HOST_INT_DR | SPI_HOST_INT_SW_UPDATE | SPI_HOST_INT_WR_READY

I.e. STLC can generate IRQ request on any events. Else, disable not
only host irq handler, but disable also STLC IRQ generation for ALL
events.

Unfortunately, I not see impulse on IRQ line with my
kernel/firmware/module. I think about corruted chip, but them set bit
in chip-side DMA-enabled transfer in p54spi.c function
p54spi_write_dma():

       if (!p54spi_wait_bit(priv, SPI_ADRS_DMA_WRITE_CTRL,
HOST_ALLOWED)) {
                dev_err(&priv->spi->dev, "spi_write_dma not allowed "
                        "to DMA write.\n");
                return -EAGAIN;
        }

I realy got HOST_ALLOWED bit in contents of SPI_ADRS_DMA_WRITE_CTRL
register from STLC chip.

In Sagrad code, write data with chip-side DMA not use wait_bit mechanism:

void SPIDRVWriteDataDMA(const u8* pBuffer, u32 WriteAddr, u16
NumByteToWrite)
{
  u32 reg1 = 0;
  u32 i = 0;
  u16 address = SPI_ADRS_DMA_DATA;
  u16 *pBuf16 = (u16*)pBuffer;
  SPI_REGSET_WRITE(address); //Clear read bit (redundant because it
shouldn't be set)

  //Read DMA WRITE Control Register
  reg1 = SPIDRVReadReg32(SPI_ADRS_DMA_WRITE_CTRL);
  reg1 |= 0x1; //Set enable
  SPIDRVWriteReg32(SPI_ADRS_DMA_WRITE_CTRL, reg1); //write it back

  SPIDRVWriteReg32(SPI_ADRS_DMA_WRITE_LEN, NumByteToWrite);
  reg1 = SPIDRVReadReg32(SPI_ADRS_DMA_WRITE_LEN);

  SPIDRVWriteReg32(SPI_ADRS_DMA_WRITE_BASE, WriteAddr);
  reg1 = SPIDRVReadReg32(SPI_ADRS_DMA_WRITE_BASE);

  SPIDRV_ChipSelect(HIGH);
  SPIDRV_ChipSelect(LOW); // Start transactions to Data register
  SPI_I2S_SendHalfWord(address); // Write

  for (i = 0; i < NumByteToWrite/2; i++)
  {
      SPI_I2S_SendHalfWord(pBuf16[i]);
  }

  // Wait for busy flag to clear before indicating the end of a
transaction
  while(SPI_I2S_GetFlagStatus(SPI1, SPI_I2S_FLAG_BSY) == SET);

  SPIDRV_ChipSelect(HIGH);

  return;
}

WOW! Bingo! Unfortunately, I'm home now! Tomorroy I try make this tips:

  SPIDRV_ChipSelect(HIGH);
  SPIDRV_ChipSelect(LOW); // Start transactions to Data register

This job NOT maked by XScale SPI driver.
Hm... Is Omap SPI driver do this? How?

-- 
Sincerely,
Alex A. Mihaylov
AKA MinimumLaw
