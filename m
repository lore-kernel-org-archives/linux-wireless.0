Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:50137 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453Ab0LLJDY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Dec 2010 04:03:24 -0500
Subject: Re: [PATCH 2/2] ssb: Save sprom image for dump of device at
 alternate location
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <4d044307.Ipm73VWEgifFrF0m%Larry.Finger@lwfinger.net> (sfid-20101212_043513_712988_FFFFFFFF9320429C)
References: <4d044307.Ipm73VWEgifFrF0m%Larry.Finger@lwfinger.net>
	 (sfid-20101212_043513_712988_FFFFFFFF9320429C)
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 12 Dec 2010 10:03:12 +0100
Message-ID: <1292144592.11817.7.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-12-11 at 21:35 -0600, Larry Finger wrote: 
> @@ -1013,6 +1013,7 @@ void ssb_pci_exit(struct ssb_bus *bus)
>  	if (bus->bustype != SSB_BUSTYPE_PCI)
>  		return;
>  
> +	kfree(bus->sprom_data);
>  	pdev = bus->host_pci;
>  	device_remove_file(&pdev->dev, &dev_attr_ssb_sprom);
>  }

Need to put kfree after removing the sprom file. Otherwise there's
a race condition with userspace.

> Index: wireless-testing/drivers/ssb/sprom.c
> ===================================================================
> --- wireless-testing.orig/drivers/ssb/sprom.c
> +++ wireless-testing/drivers/ssb/sprom.c
> @@ -72,24 +72,29 @@ ssize_t ssb_attr_sprom_show(struct ssb_b
>  	ssize_t count = 0;
>  	size_t sprom_size_words = bus->sprom_size;
>  
> -	sprom = kcalloc(sprom_size_words, sizeof(u16), GFP_KERNEL);
> -	if (!sprom)
> -		goto out;
> -
> -	/* Use interruptible locking, as the SPROM write might
> -	 * be holding the lock for several seconds. So allow userspace
> -	 * to cancel operation. */
> -	err = -ERESTARTSYS;
> -	if (mutex_lock_interruptible(&bus->sprom_mutex))
> -		goto out_kfree;
> -	err = sprom_read(bus, sprom);
> -	mutex_unlock(&bus->sprom_mutex);
> -
> +	if (bus->sprom_data) {
> +		sprom = bus->sprom_data;
> +		err = 0;
> +	} else {

This branch is dead now, or do I miss something?

> +		sprom = kcalloc(sprom_size_words, sizeof(u16), GFP_KERNEL);
> +		if (!sprom)
> +			goto out;
> +
> +		/* Use interruptible locking, as the SPROM write might
> +		 * be holding the lock for several seconds. So allow userspace
> +		 * to cancel operation. */
> +		err = -ERESTARTSYS;
> +		if (mutex_lock_interruptible(&bus->sprom_mutex))
> +			goto out_kfree;
> +		err = sprom_read(bus, sprom);
> +		mutex_unlock(&bus->sprom_mutex);
> +	}
>  	if (!err)
>  		count = sprom2hex(sprom, buf, PAGE_SIZE, sprom_size_words);
>  
>  out_kfree:
> -	kfree(sprom);
> +	if (!bus->sprom_data)
> +		kfree(sprom);
>  out:
>  	return err ? err : count;
>  }

I agree that caching the SPROM probably is easier than reading it from
the wireless core at sysfs read time. There are a few concurrency issues
that are hard to solve with the current ssb-pci MMIO access code.
Most notably is that the SPROM read would race with wireless interrupts.

-- 
Greetings Michael.

