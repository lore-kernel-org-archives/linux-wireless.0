Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:58442 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045Ab0IPRop (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 13:44:45 -0400
Date: Thu, 16 Sep 2010 10:44:31 -0700
From: Tony Lindgren <tony@atomide.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-wireless@vger.kernel.org, linux-omap@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	linux-arm-kernel@lists.infradead.org,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Nicolas Pitre <nico@fluxnic.net>, Ido Yariv <ido@wizery.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	Russell King <linux@arm.linux.org.uk>,
	Vitaly Wool <vitalywool@gmail.com>
Subject: Re: [PATCH v6 6/7] omap: zoom: add fixed regulator device for wlan
Message-ID: <20100916174431.GC29610@atomide.com>
References: <1284593529-30100-1-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1284593529-30100-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Ohad Ben-Cohen <ohad@wizery.com> [100915 16:23]:
> Add a fixed regulator vmmc device to enable power control
> of the wl1271 wlan device.

<snip>

> +static struct fixed_voltage_config zoom_vwlan = {
> +	.supply_name = "vwl1271",
> +	.microvolts = 1800000, /* 1.8V */
> +	.gpio = OMAP_ZOOM_WLAN_PMENA_GPIO,
> +	.startup_delay = 70000, /* 70msec */
> +	.enable_high = 1,
> +	.enabled_at_boot = 0,
> +	.init_data = &zoom_vmmc3,
> +};

These are usually aligned with tabs before the = sign.

> +static struct platform_device omap_vwlan_device = {
> +	.name		= "reg-fixed-voltage",
> +	.id		= 1,
> +	.dev = {
> +		.platform_data = &zoom_vwlan,
> +	},
> +};

Like in this struct.

After that's fixed, here's my ack for these to go via the
wireless tree:

Acked-by: Tony Lindgren <tony@atomide.com>
