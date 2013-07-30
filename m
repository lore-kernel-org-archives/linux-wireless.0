Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:59238 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757987Ab3G3Wfj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jul 2013 18:35:39 -0400
Received: by mail-pb0-f49.google.com with SMTP id xb4so2288260pbc.8
        for <linux-wireless@vger.kernel.org>; Tue, 30 Jul 2013 15:35:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>, <linux-wireless@vger.kernel.org>,
	<tony@atomide.com>, <nsekhar@ti.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1375189476-21557-7-git-send-email-coelho@ti.com>
Cc: <coelho@ti.com>, <luca@coelho.fi>, <mark.rutland@arm.com>,
	<balbi@ti.com>, <grant.likely@linaro.org>,
	<rob.herring@calxeda.com>, <devicetree-discuss@lists.ozlabs.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-omap@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <nm@ti.com>,
	<martinez.javier@gmail.com>
References: <1375189476-21557-1-git-send-email-coelho@ti.com>
 <1375189476-21557-7-git-send-email-coelho@ti.com>
Message-ID: <20130730223535.5270.39864@quantum> (sfid-20130731_003555_570908_4168DCA6)
Subject: Re: [PATCH v4 6/8] wlcore: sdio: add wilink clock providers
Date: Tue, 30 Jul 2013 15:35:35 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Luciano Coelho (2013-07-30 06:04:34)
> +static const struct of_device_id wlcore_sdio_of_clk_match_table[] = {
> +       { .compatible = "ti,wilink-clock" },
> +};
> +
>  static struct wl12xx_platform_data *wlcore_get_pdata_from_of(struct device *dev)
>  {
>         struct wl12xx_platform_data *pdata;
>         struct device_node *np = dev->of_node;
> +       struct device_node *clock_node;
>  
>         if (!np) {
>                 np = of_find_matching_node(NULL, dev->driver->of_match_table);
> @@ -241,6 +247,9 @@ static struct wl12xx_platform_data *wlcore_get_pdata_from_of(struct device *dev)
>                 goto out_free;
>         }
>  
> +       for_each_matching_node(clock_node, wlcore_sdio_of_clk_match_table)
> +               of_fixed_clk_setup(clock_node);

Hi Luciano,

Any reason for establishing your own compatible string if you just plan
to use the fixed rate clock? You could just use "fixed-clock" compatible
in your DTS.

I will be posting patches this week which makes the fixed-rate clock a
proper driver and matches that compatible string to instantiate those
clocks. That means that your driver could probably remove the clock
setup code completely.

Regards,
Mike

> +
>         goto out;
>  
>  out_free:
> -- 
> 1.8.3.2
