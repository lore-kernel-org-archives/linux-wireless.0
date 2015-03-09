Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:59444 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbbCITuN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 15:50:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 3/3] ARM: dts: igep00x0: add wl18xx bindings
Date: Mon, 09 Mar 2015 20:50:09 +0100
Message-ID: <9217056.Z3urqp19oZ@wuerfel> (sfid-20150309_205019_581461_73FEC143)
In-Reply-To: <1425915402-10012-3-git-send-email-eliad@wizery.com>
References: <1425915402-10012-1-git-send-email-eliad@wizery.com> <1425915402-10012-3-git-send-email-eliad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 09 March 2015 17:36:42 Eliad Peller wrote:
> --- a/arch/arm/boot/dts/omap3-igep0030-rev-g.dts
> +++ b/arch/arm/boot/dts/omap3-igep0030-rev-g.dts
> @@ -64,4 +64,13 @@
>         vmmc-supply = <&lbep5clwmc_wlen>;
>         bus-width = <4>;
>         non-removable;
> +
> +       #address-cells = <1>;
> +       #size-cells = <0>;
> +       wlcore: wlcore@2 {
> +               compatible = "ti,wl1835";
> +               reg = <2>;
> +               interrupt-parent = <&gpio5>;
> +               interrupts = <8 IRQ_TYPE_NONE>;
> +       };
> 

Why IRQ_TYPE_NONE?

I was expecting you to remove all calls to legacy_init_wl12xx from this file,
including the ones for wl12xx aside from the wl18xx ones you removed, but
if that's enough to clean out the platform_data handling from the wlcore
driver, it's good enough as a start.

	Arnd
