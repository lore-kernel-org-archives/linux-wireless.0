Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:36965 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030334AbbCMPcv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 11:32:51 -0400
Date: Fri, 13 Mar 2015 08:27:52 -0700
From: Tony Lindgren <tony@atomide.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Arnd Bergmann <arnd@arndb.de>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	=?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Javier Martinez Canillas <javier@dowhile0.org>,
	Sekhar Nori <nsekhar@ti.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH v6 5/6] ARM: dts: add wl12xx/wl18xx bindings
Message-ID: <20150313152751.GK5264@atomide.com> (sfid-20150313_163325_004552_AEA039E2)
References: <1426162154-8716-1-git-send-email-eliad@wizery.com>
 <1426162154-8716-6-git-send-email-eliad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1426162154-8716-6-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Eliad Peller <eliad@wizery.com> [150312 05:09]:
> --- a/arch/arm/mach-omap2/pdata-quirks.c
> +++ b/arch/arm/mach-omap2/pdata-quirks.c
>  
> -static void __init omap3_evm_legacy_init(void)
> -{
> -	legacy_init_wl12xx(38400000, 0, 149);
> -}

FYI, at least this part conflicts with the fixes in the arm-soc
tree for the v4.0-rc series as omap3 evm also needs the copy clock
quirk.

> @@ -419,20 +351,9 @@ static struct pdata_init pdata_quirks[] __initdata = {
>  	{ "nokia,omap3-n950", hsmmc2_internal_input_clk, },
>  	{ "isee,omap3-igep0020-rev-f", omap3_igep0020_rev_f_legacy_init, },
>  	{ "isee,omap3-igep0030-rev-g", omap3_igep0030_rev_g_legacy_init, },
> -	{ "ti,omap3-evm-37xx", omap3_evm_legacy_init, },

So this function cannot be yet removed.

With that fixed, I was able to iw dev wlan0 scan with series on
omap3 evm :)

Regards,

Tony
