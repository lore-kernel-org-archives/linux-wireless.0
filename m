Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50915 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbaANOlf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 09:41:35 -0500
Date: Tue, 14 Jan 2014 16:41:30 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: net: rfkill: gpio: convert to descriptor-based GPIO interface
Message-ID: <20140114144130.GC21169@xps8300> (sfid-20140114_154138_837110_8737A349)
References: <20140108152837.GA3017@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140108152837.GA3017@elgon.mountain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Wed, Jan 08, 2014 at 06:28:38PM +0300, Dan Carpenter wrote:
> Hello Heikki Krogerus,
> 
> This is a semi-automatic email about new static checker warnings.
> 
> The patch 2111cad655e3: "net: rfkill: gpio: convert to
> descriptor-based GPIO interface" from Nov 26, 2013, leads to the
> following Smatch complaint:
> 
> net/rfkill/rfkill-gpio.c:144 rfkill_gpio_probe()
> 	 warn: variable dereferenced before check 'rfkill->name' (see line 144)
> 
> net/rfkill/rfkill-gpio.c
>    111          len = strlen(rfkill->name);
>                              ^^^^^^^^^^^^
> Dereference.
> 
>    112          rfkill->reset_name = devm_kzalloc(&pdev->dev, len + 7, GFP_KERNEL);
>    113          if (!rfkill->reset_name)
>    114                  return -ENOMEM;
>    115  
>    116          rfkill->shutdown_name = devm_kzalloc(&pdev->dev, len + 10, GFP_KERNEL);
>    117          if (!rfkill->shutdown_name)
>    118                  return -ENOMEM;
>    119  
>    120          snprintf(rfkill->reset_name, len + 6 , "%s_reset", rfkill->name);
>    121          snprintf(rfkill->shutdown_name, len + 9, "%s_shutdown", rfkill->name);
>    122  
>    123          rfkill->clk = devm_clk_get(&pdev->dev, clk_name);
>    124  
>    125          gpio = devm_gpiod_get_index(&pdev->dev, rfkill->reset_name, 0);
>    126          if (!IS_ERR(gpio)) {
>    127                  ret = gpiod_direction_output(gpio, 0);
>    128                  if (ret)
>    129                          return ret;
>    130                  rfkill->reset_gpio = gpio;
>    131          }
>    132  
>    133          gpio = devm_gpiod_get_index(&pdev->dev, rfkill->shutdown_name, 1);
>    134          if (!IS_ERR(gpio)) {
>    135                  ret = gpiod_direction_output(gpio, 0);
>    136                  if (ret)
>    137                          return ret;
>    138                  rfkill->shutdown_gpio = gpio;
>    139          }
>    140  
>    141          /* Make sure at-least one of the GPIO is defined and that
>    142           * a name is specified for this instance
>    143		 */
>    144		if ((!rfkill->reset_gpio && !rfkill->shutdown_gpio) || !rfkill->name) {
>                                                                         ^^^^^^^^^^^^
> The check was originally before the dereference, but the patch moves it
> after the dereference.
> 
>    145			dev_err(&pdev->dev, "invalid platform data\n");
>    146			return -EINVAL;

OK, this needs to be fixed.

Thanks!

-- 
heikki
