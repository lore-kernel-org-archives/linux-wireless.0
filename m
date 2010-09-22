Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33509 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab0IVLgT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 07:36:19 -0400
Received: by fxm3 with SMTP id 3so198620fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Sep 2010 04:36:17 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Alex Mihaylov <minimumlaw@gmail.com>
Subject: Re: p54spi (STLC4560) with Marvel XScale CPU (kernel 2.6.25.4)
Date: Wed, 22 Sep 2010 13:36:13 +0200
Cc: linux-wireless@vger.kernel.org
References: <AANLkTik3_o03=m0w8XM_B-YTQrR-ibkbtTBErXfcYwGG@mail.gmail.com> <AANLkTi=M9zSKkckxqs6XwBg3290L9yijmCbRn9_E93xJ@mail.gmail.com> <AANLkTinLbpycwLjVpHhx+ZdTzXkxC4jQ6iqrOOF6Fsc4@mail.gmail.com>
In-Reply-To: <AANLkTinLbpycwLjVpHhx+ZdTzXkxC4jQ6iqrOOF6Fsc4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201009221336.14382.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 22 September 2010 13:25:55 Alex Mihaylov wrote:
> 2010/9/22 Max Filippov <jcmvbkbc@gmail.com>:
> 
> >> loading module with proper command line, I see message
> >> cx3110x spi1.0: firmware boot failed
> >> phy0: p54 detected a LM20 firmware
> >> p54: rx_mtu reduced from 3240 to 2376
> >> phy0: FW rev 2.13.0.0.a.13.14 - Softmac protocol 5.6
> >> phy0: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
> >> cx3110x spi1.0: loading user eeprom...
> 
> > Looks like you have custom eeprom image...
> > ...and this eeprom image has wrong format.
> 
> >> What is my next step for this idea?
> > I'd suggest removing file 3826.eeprom and trying to boot without it.
> 
> eeprom image was created from p54spi_eeprom.h file. I try to delete
> this file and load different fimware - result some:
> 
> 
> cx3110x spi1.0: 13000000 Hz actual, PIO
> cx3110x spi1.0: setup mode 0, 16 bits/w, 13000000 Hz max --> 0
> phy0: p54 detected a LM20 firmware
> p54: rx_mtu reduced from 3240 to 2376
> phy0: FW rev 2.13.0.0.a.13.14 - Softmac protocol 5.6
> phy0: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
> cx3110x spi1.0: loading default eeprom...
> phy0: hwaddr 00:02:ee:c0:ff:ee, MAC:isl3820 RF:Longbow
> phy0: Selected rate control algorithm 'minstrel'
> cx3110x spi1.0: is registered as 'phy0'
> cx3110x spi1.0: firmware boot failed
> 
> and with Sagrad firmware:
> 
> cx3110x spi1.0: 13000000 Hz actual, PIO
> cx3110x spi1.0: setup mode 0, 16 bits/w, 13000000 Hz max --> 0
> phy0: p54 detected a LM20 firmware
> p54: rx_mtu reduced from 3240 to 2376
> phy0: FW rev 2.19.0.0.A.14 Private - Softmac protocol 5.6
> phy0: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
> cx3110x spi1.0: loading default eeprom...
> phy0: hwaddr 00:02:ee:c0:ff:ee, MAC:isl3820 RF:Longbow
> phy0: Selected rate control algorithm 'minstrel'
> cx3110x spi1.0: is registered as 'phy0'
> cx3110x spi1.0: firmware boot failed
> 
> IRQ line not change state after firmware loaded into chip (stay low).
> Is this normal?
> SPI_CS line switch to low, and stay low all time. May be I need SPI_CS
> pulse after firmware loaded into chip? I try use SPI_CS as controller
> specific pin (not gpio_cs in platform file) - in this case I have next
> error:
> 
> cx3110x: spi_write_dma not allowed to dma write.
> 
> and no firmware load into chip. SPI_CS in this case, make pulse on
> each SPI transaction. After switch to gpio_cs firmware try to load,
> but:
> 
>         timeout = msecs_to_jiffies(2000);
>         timeout =
> wait_for_completion_interruptible_timeout(&priv->fw_comp, timeout);
>         if (!timeout) {
>                 dev_err(&priv->spi->dev, "firmware boot failed");
>                 p54spi_power_off(priv);
>                 ret = -1;
>                 goto out;
>         }
> 
> 
> Not starting?

their GPL driver looks funny. (Max, it's really worth a look)


anyway found this:
	/*
	   Sequence taken from STLC4560 DataSheet
	   This sequence can be run with the maximum SPI clock frequency (that is, 48 MHz).
	   1. Power up.
	   2. Wait 240 ms.
	   3. Halt processor (EHostDeviceCntrl2 = KSetHostOverride | KSetHostCPUEn=0).
	   4. Wait 1 us.
	   5. Enable DMA TX (EHostDmaTxCntrl, KDmaTxCntrlEnable).
	   6. Write DMA TX length (EHostDmaTxLength).
	   7. Write DMA TX base (EHostDmaTxBase1).
	   8. Wait 1 ìs.
	   9. Write firmware image (EHostDmaData).
	   10. RAM reset (EHostDeviceCntrl2 = KSetHostOverride | KSetHostReset | KSetRamBoot).
	   11. Wait 40 ms.
	   12. RAM boot (EHostDeviceCntrl2 = KSetHostOverride | KSetRamBoot),
	   13. Enable host interrupts (EHostIntEnable1 = KIrqReady | KIrqWrReady | KHwUpdate | KSwUpdate).
	   14. Wait for the READY interrupt (100 ms timeout).
	   15. Acknowledge the READY interrupt.
	   16. Issue the SLEEP interrupt.
	 */

maybe it helps
