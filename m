Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39032 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab0IVJob (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 05:44:31 -0400
Received: by iwn5 with SMTP id 5so398536iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Sep 2010 02:44:31 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 22 Sep 2010 13:44:30 +0400
Message-ID: <AANLkTik3_o03=m0w8XM_B-YTQrR-ibkbtTBErXfcYwGG@mail.gmail.com>
Subject: p54spi (STLC4560) with Marvel XScale CPU (kernel 2.6.25.4)
From: Alex Mihaylov <minimumlaw@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

I have Toradex Colibri module ( PXA270 and PXA320 based -
http://www.toradex.com/Products/Colibri_Modules ) and want connect
them to Sagrad SG901-1028 module (
http://www.sagrad.com/index.php?option=com_content&view=article&id=55&Itemid=66
) based on STLC450 chip.

Now I add next code to plaform file (kernel 2.6.35.4):

static mfp_cfg_t colibri_pxa320_ssp_pin_config[] __initdata = {
    GPIO83_SSP1_SCLK,
    GPIO85_SSP1_TXD,
    GPIO86_SSP1_RXD,
    GPIO84_GPIO,
    GPIO94_GPIO | MFP_LPM_EDGE_RISE, // IRQ
    GPIO95_GPIO,                     // SLEEP
};

static struct pxa2xx_spi_master colibri_pxa320_spi_master = {
    .clock_enable = CKEN_SSP1,
    .num_chipselect = 1,
    .enable_dma = 0,
};

static struct pxa2xx_spi_chip sagrad_spi_tuning = {
    .gpio_cs    = 84,
};

static struct spi_board_info colibri_pxa320_spi_chips[] = {
    { // Sagrad SG901-1028 or SG901-1039 - module p54spi, but... Joke
from Nokia =)
        .modalias       = "cx3110x",
        .max_speed_hz   = 13000000,
        .mode           = SPI_MODE_0,
        .bus_num        = 1,
        .chip_select    = 0,
        .controller_data = &sagrad_spi_tuning,
    },
};

static inline void colibri_pxa320_init_spi ( void ) {
    pxa3xx_mfp_config( ARRAY_AND_SIZE( colibri_pxa320_ssp_pin_config ) );
    pxa2xx_set_spi_info(1,&colibri_pxa320_spi_master);
    spi_register_board_info( ARRAY_AND_SIZE( colibri_pxa320_spi_chips ) );
}

and pach p54spi.c for proper SPI speed (XScale have maximum SPI rate
13Mhz) with addition module parameter:

static long p54spi_max_rate = 24000000;
module_param(p54spi_max_rate, long, 0444);
MODULE_PARM_DESC(p54spi_max_rate, "maximum spi bus frequency");

and replace string with
       spi->max_speed_hz = 24000000;
to
       spi->max_speed_hz = p54spi_max_rate;

Also i got firmware  2.13.0.0.a.13.14.arm from linux-wireles. After
loading module with proper command line, I see message

cx3110x spi1.0: firmware boot failed

and no other error/warning message presents. SPI signals like good.


phy0: p54 detected a LM20 firmware
p54: rx_mtu reduced from 3240 to 2376
phy0: FW rev 2.13.0.0.a.13.14 - Softmac protocol 5.6
phy0: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
cx3110x spi1.0: loading user eeprom...
phy0: hwaddr 00:02:ee:c0:ff:ee, MAC:isl3820 RF:Longbc
x3110x spi1.0: firmware boot failed

What's trouble? Incorrect firmware? Unsupported (so slow) SPI rate?

I try load another firmware from 2.13... series - result: firmware
boot failed. I also try load firmware cutted from Sagrad source
(version 2.19....) result is same: firmware boot failed.

What is my next step for this idea?

-- 
Sincerely,
Alex A. Mihaylov
AKA MinimumLaw
