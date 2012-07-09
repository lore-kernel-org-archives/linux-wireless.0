Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55723 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566Ab2GIVfS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 17:35:18 -0400
Message-ID: <4FFB4E8F.4020900@hauke-m.de> (sfid-20120709_233523_292950_139A254D)
Date: Mon, 09 Jul 2012 23:35:11 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC][PATCH] bcma: support alternative (BCM4706) ChipCommon core
 id
References: <1341864848-9707-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1341864848-9707-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rafał,

Could you add some info why you haven't replaced all places where
BCMA_CORE_CHIPCOMMON was used with this functions in the commit message.

By the way, why is bcma_find_core() beeing called in bcma_bus_resume()?
The code should better check for bus->drv_cc.core and not for core.

On 07/09/2012 10:14 PM, Rafał Miłecki wrote:
> ---
>  drivers/bcma/main.c |   14 +++++++++++---
>  1 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
> index 173a0b4..61ac6cf 100644
> --- a/drivers/bcma/main.c
> +++ b/drivers/bcma/main.c
> @@ -61,6 +61,13 @@ static struct bus_type bcma_bus_type = {
>  	.dev_attrs	= bcma_device_attrs,
>  };
>  
> +static u16 bcma_cc_core_id(struct bcma_bus *bus)
> +{
> +	if (bus->chipinfo.id == BCMA_CHIP_ID_BCM4706)
> +		return BCMA_CORE_4706_CHIPCOMMON;
> +	return BCMA_CORE_CHIPCOMMON;
> +}
> +
>  struct bcma_device *bcma_find_core(struct bcma_bus *bus, u16 coreid)
>  {
>  	struct bcma_device *core;
> @@ -91,6 +98,7 @@ static int bcma_register_cores(struct bcma_bus *bus)
>  	list_for_each_entry(core, &bus->cores, list) {
>  		/* We support that cores ourself */
>  		switch (core->id.id) {
> +		case BCMA_CORE_4706_CHIPCOMMON:
>  		case BCMA_CORE_CHIPCOMMON:
>  		case BCMA_CORE_PCI:
>  		case BCMA_CORE_PCIE:
> @@ -157,7 +165,7 @@ int __devinit bcma_bus_register(struct bcma_bus *bus)
>  	}
>  
>  	/* Init CC core */
> -	core = bcma_find_core(bus, BCMA_CORE_CHIPCOMMON);
> +	core = bcma_find_core(bus, bcma_cc_core_id(bus));
>  	if (core) {
>  		bus->drv_cc.core = core;
>  		bcma_core_chipcommon_init(&bus->drv_cc);
> @@ -215,7 +223,7 @@ int __init bcma_bus_early_register(struct bcma_bus *bus,
>  	bcma_init_bus(bus);
>  
>  	match.manuf = BCMA_MANUF_BCM;
> -	match.id = BCMA_CORE_CHIPCOMMON;
> +	match.id = bcma_cc_core_id(bus);
>  	match.class = BCMA_CL_SIM;
>  	match.rev = BCMA_ANY_REV;
>  
> @@ -239,7 +247,7 @@ int __init bcma_bus_early_register(struct bcma_bus *bus,
>  	}
>  
>  	/* Init CC core */
> -	core = bcma_find_core(bus, BCMA_CORE_CHIPCOMMON);
> +	core = bcma_find_core(bus, bcma_cc_core_id(bus));
>  	if (core) {
>  		bus->drv_cc.core = core;
>  		bcma_core_chipcommon_init(&bus->drv_cc);
> 


