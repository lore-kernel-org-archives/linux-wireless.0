Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:37940 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbcDRFz7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 01:55:59 -0400
From: "Reizer, Eyal" <eyalr@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Kalle Valo <kvalo@codeaurora.org>,
	Eyal Reizer <eyalreizer@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>
Subject: RE: [PATCHv2] wlcore: spi: add wl18xx support
Date: Mon, 18 Apr 2016 05:55:51 +0000
Message-ID: <8665E2433BC68541A24DFFCA87B70F5B360BF614@DFRE01.ent.ti.com> (sfid-20160418_075623_534859_C692DC7D)
References: <1460273570-12298-1-git-send-email-eyalr@ti.com>
 <8665E2433BC68541A24DFFCA87B70F5B360B6C90@DFRE01.ent.ti.com>
 <14313437.cDJIgY3kzo@wuerfel>
In-Reply-To: <14313437.cDJIgY3kzo@wuerfel>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >
> > - all wilink family needs special init command for entering wspi mode.
> >   extra clock cycles should be sent after the spi init command while the
> >   cs pin is high.
> > - switch to controling the cs pin from the spi driver for achieveing the
> >   above.
> > - the selected cs gpio is read from the spi device-tree node using the
> >   cs-gpios field and setup as a gpio.
> > - See the example below for specifying the cs gpio using the cs-gpios entry
> > &spi0   {
> >         ...
> >         cs-gpios = <&gpio0 5 0>;
> >         ...
> >         wlcore: wlcore@0 {
> >                 compatible = "ti,wl1835";
> >         ...
> >         ...
> >         };
> > };
> >
> > Signed-off-by: Eyal Reizer <eyalr@ti.com>
> 
> I don't think this can work in general: not all SPI hosts uses GPIOs for
> controlling CS, so the logic can't work, and it's also a layering violation for the
> driver to look at the parent.
> 
> I would suggest fixing this using a new API function from the SPI core, if we
> don't already have a generic way to do it.
>
Originally this is what I have done until I was pointed to the generic cs-gpio mechanism 
in the SPI core. 
It is a generic mechanism already in the SPI core driver.
See: Documentation/devicetree/bindings/spi/spi-bus.txt

It is also part of the generic spi.h (include/Linux/spi/spi.h), already part of 
" struct spi_device" So it seemed redundant adding another mechanism for 
implementing the same.
Platform that interact with a wilink need to use it, and platforms that don't  
have this capability will probably not interact with a wilink device using SPI.

Best Regards,
Eyal



