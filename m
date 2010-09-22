Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59012 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab0IVLZ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 07:25:56 -0400
Received: by iwn5 with SMTP id 5so473839iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Sep 2010 04:25:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=M9zSKkckxqs6XwBg3290L9yijmCbRn9_E93xJ@mail.gmail.com>
References: <AANLkTik3_o03=m0w8XM_B-YTQrR-ibkbtTBErXfcYwGG@mail.gmail.com>
	<AANLkTi=M9zSKkckxqs6XwBg3290L9yijmCbRn9_E93xJ@mail.gmail.com>
Date: Wed, 22 Sep 2010 15:25:55 +0400
Message-ID: <AANLkTinLbpycwLjVpHhx+ZdTzXkxC4jQ6iqrOOF6Fsc4@mail.gmail.com>
Subject: Re: p54spi (STLC4560) with Marvel XScale CPU (kernel 2.6.25.4)
From: Alex Mihaylov <minimumlaw@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/9/22 Max Filippov <jcmvbkbc@gmail.com>:

>> loading module with proper command line, I see message
>> cx3110x spi1.0: firmware boot failed
>> phy0: p54 detected a LM20 firmware
>> p54: rx_mtu reduced from 3240 to 2376
>> phy0: FW rev 2.13.0.0.a.13.14 - Softmac protocol 5.6
>> phy0: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
>> cx3110x spi1.0: loading user eeprom...

> Looks like you have custom eeprom image...
> ...and this eeprom image has wrong format.

>> What is my next step for this idea?
> I'd suggest removing file 3826.eeprom and trying to boot without it.

eeprom image was created from p54spi_eeprom.h file. I try to delete
this file and load different fimware - result some:


cx3110x spi1.0: 13000000 Hz actual, PIO
cx3110x spi1.0: setup mode 0, 16 bits/w, 13000000 Hz max --> 0
phy0: p54 detected a LM20 firmware
p54: rx_mtu reduced from 3240 to 2376
phy0: FW rev 2.13.0.0.a.13.14 - Softmac protocol 5.6
phy0: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
cx3110x spi1.0: loading default eeprom...
phy0: hwaddr 00:02:ee:c0:ff:ee, MAC:isl3820 RF:Longbow
phy0: Selected rate control algorithm 'minstrel'
cx3110x spi1.0: is registered as 'phy0'
cx3110x spi1.0: firmware boot failed

and with Sagrad firmware:

cx3110x spi1.0: 13000000 Hz actual, PIO
cx3110x spi1.0: setup mode 0, 16 bits/w, 13000000 Hz max --> 0
phy0: p54 detected a LM20 firmware
p54: rx_mtu reduced from 3240 to 2376
phy0: FW rev 2.19.0.0.A.14 Private - Softmac protocol 5.6
phy0: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
cx3110x spi1.0: loading default eeprom...
phy0: hwaddr 00:02:ee:c0:ff:ee, MAC:isl3820 RF:Longbow
phy0: Selected rate control algorithm 'minstrel'
cx3110x spi1.0: is registered as 'phy0'
cx3110x spi1.0: firmware boot failed

IRQ line not change state after firmware loaded into chip (stay low).
Is this normal?
SPI_CS line switch to low, and stay low all time. May be I need SPI_CS
pulse after firmware loaded into chip? I try use SPI_CS as controller
specific pin (not gpio_cs in platform file) - in this case I have next
error:

cx3110x: spi_write_dma not allowed to dma write.

and no firmware load into chip. SPI_CS in this case, make pulse on
each SPI transaction. After switch to gpio_cs firmware try to load,
but:

        timeout = msecs_to_jiffies(2000);
        timeout =
wait_for_completion_interruptible_timeout(&priv->fw_comp, timeout);
        if (!timeout) {
                dev_err(&priv->spi->dev, "firmware boot failed");
                p54spi_power_off(priv);
                ret = -1;
                goto out;
        }


Not starting?

---
Sincerely,
Alex A. Mihaylov
AKA MinimumLaw
