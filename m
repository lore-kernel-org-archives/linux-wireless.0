Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:36190 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbbCJQAi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 12:00:38 -0400
Date: Tue, 10 Mar 2015 08:55:30 -0700
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Eliad Peller <eliad@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Sekhar Nori <nsekhar@ti.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH v5 3/3] ARM: dts: igep00x0: add wl18xx bindings
Message-ID: <20150310155529.GP5264@atomide.com> (sfid-20150310_170043_922248_9AC92526)
References: <1425915402-10012-1-git-send-email-eliad@wizery.com>
 <2223973.a64rBcZvaA@wuerfel>
 <20150310142805.GN5264@atomide.com>
 <2300824.dcEMS7aYJa@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2300824.dcEMS7aYJa@wuerfel>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Arnd Bergmann <arnd@arndb.de> [150310 08:48]:
> On Tuesday 10 March 2015 07:28:05 Tony Lindgren wrote:
> > 
> > Oops I forgot about the omap3-sbc-t3730, so yes we have to keep the
> > platform data a little bit longer. But nothing stopping us moving
> > all the other ones to use a proper device tree based configuration.
> > 
> 
> For all I can tell, the t3730 board file does not support wl12xx
> at the moment, only the dts file does.

Hmm strange, it seems to configure the wlan_rst pin. Maybe there
are variants with different WLAN module. But yeah, seems to be
unused.

That still leaves configuring all the dts users of the
pdata-quirks.c legacy_init_wl12xx() with proper dts before
removing it:

$ git grep legacy_init_wl12xx pdata-quirks.c
pdata-quirks.c:static void __init __used legacy_init_wl12xx(unsigned ref_clock,
pdata-quirks.c:static inline void legacy_init_wl12xx(unsigned ref_clock,
pdata-quirks.c: legacy_init_wl12xx(WL12XX_REFCLOCK_38, 0, 136);
pdata-quirks.c: legacy_init_wl12xx(0, 0, 177);
pdata-quirks.c: legacy_init_wl12xx(0, 0, 136);
pdata-quirks.c: legacy_init_wl12xx(WL12XX_REFCLOCK_38, 0, 149);
pdata-quirks.c: legacy_init_wl12xx(WL12XX_REFCLOCK_26, 0, 162);
pdata-quirks.c: legacy_init_wl12xx(WL12XX_REFCLOCK_38, 0, 145);
pdata-quirks.c: legacy_init_wl12xx(WL12XX_REFCLOCK_26,
pdata-quirks.c: legacy_init_wl12xx(WL12XX_REFCLOCK_38, 0, 53);
pdata-quirks.c: legacy_init_wl12xx(WL12XX_REFCLOCK_38, 0, 41);
pdata-quirks.c: legacy_init_wl12xx(WL12XX_REFCLOCK_38, 0, 31);

> If we do what Sekhar suggested and drop wl12xx support from
> the DA850 EVM board file, we can fix all wlcore users.

I guess Sekhar knows the da850 evm status the best. So up to
you guys if wl12xx is not being used on legacy da850.

Regards,

Tony
