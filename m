Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:34156 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbZJPHwx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 03:52:53 -0400
Received: by ewy4 with SMTP id 4so1329035ewy.37
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2009 00:52:17 -0700 (PDT)
To: "John Willis" <John.Willis@Distant-earth.com>
Cc: <me@bobcopeland.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] WL1251: Very crude EEPROM reading support for the WL1251 driver
References: <01c901ca4daf$6e3d7f20$4ab87d60$@Willis@Distant-earth.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 16 Oct 2009 10:52:15 +0300
In-Reply-To: <01c901ca4daf$6e3d7f20$4ab87d60$@Willis@Distant-earth.com> (John Willis's message of "Thu\, 15 Oct 2009 16\:51\:49 +0100")
Message-ID: <87r5t3n5cg.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"John Willis" <John.Willis@Distant-earth.com> writes:

> Gents,
>
> Attached are some very hacky (even after a quick cleanup) patches that add
> something like support for reading the EEPROM NVS calibration data into the
> WL1251 driver. It seems just good enough to get the driver up and playing
> nicely. 

Thanks a lot, this is good stuff. Now we have all hardware
configurations (known by me) supported in wl1251: SPI, SDIO, without
EEPROM and with EEPROM.

> I quickly rebased the patches on the top of wireless-testing, with any luck
> they still work however I can't test as there is something badly borked for
> OMAP3 in the mainline tree feeding WT at the moment. I have left out a lot
> of my development chaff and rubbish from the patches.

In cases like this I usually merge linux-omap to wireless-testing,
it's quite simple and fast thing to do. That way I get the omap
hardware booting with latest wireless stuff.

> They have only been tested on OMAP3 OpenPandora boards using SDIO. I still
> think timing needs tweaking but I have not had a chance to look into that.

I have few comments about the patch. I think it's better to configure
EEPROM support runtime and not via Kconfig. Also I don't like
hungarian notation :)

Is it okay if I clean it up a bit and then send it to John Linville?
Better to have the patch in the tree as early as possible, as long as it
doesn't break existing functionality. We can always fix it later if
there's something broken.

Thanks again for your patches and please keep on sending them :)

-- 
Kalle Valo
