Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2390 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753737Ab2F2A7N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 20:59:13 -0400
Message-ID: <4FECFDD8.5060105@broadcom.com> (sfid-20120629_025919_759944_5B3E68E6)
Date: Thu, 28 Jun 2012 17:59:04 -0700
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Jon Hunter" <jon-hunter@ti.com>
cc: "Kevin Hilman" <khilman@ti.com>, b-cousson@ti.com,
	tony@atomide.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	grant.likely@secretlab.ca, santosh.shilimkar@ti.com,
	linux-omap@vger.kernel.org, tarun.kanti@ti.com,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Panda ES board hang when using GPIO as interrupt
References: <4FE8CF77.5080400@broadcom.com> <87txxxs9we.fsf@ti.com>
 <4FEBA854.5010508@broadcom.com> <4FEC7B48.8040402@ti.com>
 <4FECCB91.7090609@broadcom.com> <4FECD2E5.1060603@ti.com>
 <4FECE067.7000809@broadcom.com> <4FECE1BD.80906@ti.com>
 <4FECE45E.6040506@broadcom.com> <4FECEE9A.5070300@ti.com>
In-Reply-To: <4FECEE9A.5070300@ti.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/28/2012 04:54 PM, Jon Hunter wrote:
> I am wondering if this could be the bug ... on start-up I see that we do
> a context restore on bank1 during the probe which is before we have done
> the first suspend! In other words, we could restore a bad/uninitialised
> context for bank1. In the case of bank1, the loss count starts at 1 and
> not 0 and so we falsely think we need to perform a restore :-(
>
> [    0.176269] omap_gpio_runtime_resume: bank @ 0xfc310000
> [    0.177276] omap_gpio_runtime_resume: count 0, now 1
> [    0.177276] gpiochip_add: registered GPIOs 0 to 31 on device: gpio
> [    0.177642] omap_gpio_runtime_suspend: bank @ 0xfc310000
>
> Can you try ...
>
> diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
> index c4ed172..9623408 100644
> --- a/drivers/gpio/gpio-omap.c
> +++ b/drivers/gpio/gpio-omap.c
> @@ -1086,6 +1086,9 @@ static int __devinit omap_gpio_probe(struct
> platform_device *pdev)
>   #ifdef CONFIG_OF_GPIO
>          bank->chip.of_node = of_node_get(node);
>   #endif
> +       if (bank->get_context_loss_count)
> +               bank->context_loss_count =
> +                               bank->get_context_loss_count(bank->dev);
>
>          bank->irq_base = irq_alloc_descs(-1, 0, bank->width, 0);
>          if (bank->irq_base < 0) {
>

Looks like you found the culprit. :) It does fix the problem.

Franky

