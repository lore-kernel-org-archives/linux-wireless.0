Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:52108 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbcDSOfd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2016 10:35:33 -0400
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
Date: Tue, 19 Apr 2016 14:35:24 +0000
Message-ID: <8665E2433BC68541A24DFFCA87B70F5B360C0C5D@DFRE01.ent.ti.com> (sfid-20160419_163558_806862_5DD055C2)
References: <1460273570-12298-1-git-send-email-eyalr@ti.com>
 <1463330011.BhWEcYYuGD@wuerfel>
 <8665E2433BC68541A24DFFCA87B70F5B360C0745@DFRE01.ent.ti.com>
 <4133521.UUI3B1RTyv@wuerfel>
In-Reply-To: <4133521.UUI3B1RTyv@wuerfel>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > > > It is also part of the generic spi.h (include/Linux/spi/spi.h),
> > > > already part of " struct spi_device" So it seemed redundant adding
> > > > another mechanism for implementing the same.
> > > > Platform that interact with a wilink need to use it, and platforms
> > > > that don't have this capability will probably not interact with a
> > > > wilink device
> > > using SPI.
> > >
> > > The cs_gpio field in spi_device belongs to the spi host controller,
> > > no other slave driver uses it.
> > >
> > > I wasn't asking for a duplication of this mechanism, but an
> > > interface to use it properly. Internally, the spi core uses the spi_set_cs()
> function to pick a CS.
> > > Find a way to use that rather than reimplementing it incorrectly.
> > >
> >
> > Understood. As this special CS manipulation is unique to wspi (wilink
> > spi)  I think the best option is to move this gpio allocation into
> > wlcore_spi as a new device tree entry used only by this driver.
> > If you agree I will submit a v3.
> 
> I don't think that can work either: aside of not solving the problem of wilink
> devices on spi controllers that don't use gpio, it also doesn't solve the
> problem of what happens when the driver manually triggers the gpio to hold
> the CS signal while another driver talks to a different device using another CS
> on the same controller.
> 
Ok, understood. Will look into it.

Best Regards,
Eyal
