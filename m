Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f42.google.com ([74.125.83.42]:33098 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab0LLP2a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Dec 2010 10:28:30 -0500
Received: by gwb20 with SMTP id 20so4401286gwb.1
        for <linux-wireless@vger.kernel.org>; Sun, 12 Dec 2010 07:28:29 -0800 (PST)
Message-ID: <4D04EA37.50309@lwfinger.net>
Date: Sun, 12 Dec 2010 09:28:55 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <mb@bu3sch.de>
CC: John W Linville <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ssb: Save sprom image for dump of device at alternate
 location
References: <4d044307.Ipm73VWEgifFrF0m%Larry.Finger@lwfinger.net>	 (sfid-20101212_043513_712988_FFFFFFFF9320429C) <1292144592.11817.7.camel@maggie>
In-Reply-To: <1292144592.11817.7.camel@maggie>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/12/2010 03:03 AM, Michael Büsch wrote:
> On Sat, 2010-12-11 at 21:35 -0600, Larry Finger wrote: 
>> @@ -1013,6 +1013,7 @@ void ssb_pci_exit(struct ssb_bus *bus)
>>  	if (bus->bustype != SSB_BUSTYPE_PCI)
>>  		return;
>>  
>> +	kfree(bus->sprom_data);
>>  	pdev = bus->host_pci;
>>  	device_remove_file(&pdev->dev, &dev_attr_ssb_sprom);
>>  }
> 
> Need to put kfree after removing the sprom file. Otherwise there's
> a race condition with userspace.

Will do. Thanks.

>> Index: wireless-testing/drivers/ssb/sprom.c
>> ===================================================================
>> --- wireless-testing.orig/drivers/ssb/sprom.c
>> +++ wireless-testing/drivers/ssb/sprom.c
>> @@ -72,24 +72,29 @@ ssize_t ssb_attr_sprom_show(struct ssb_b
>>  	ssize_t count = 0;
>>  	size_t sprom_size_words = bus->sprom_size;
>>  
>> -	sprom = kcalloc(sprom_size_words, sizeof(u16), GFP_KERNEL);
>> -	if (!sprom)
>> -		goto out;
>> -
>> -	/* Use interruptible locking, as the SPROM write might
>> -	 * be holding the lock for several seconds. So allow userspace
>> -	 * to cancel operation. */
>> -	err = -ERESTARTSYS;
>> -	if (mutex_lock_interruptible(&bus->sprom_mutex))
>> -		goto out_kfree;
>> -	err = sprom_read(bus, sprom);
>> -	mutex_unlock(&bus->sprom_mutex);
>> -
>> +	if (bus->sprom_data) {
>> +		sprom = bus->sprom_data;
>> +		err = 0;
>> +	} else {
> 
> This branch is dead now, or do I miss something?

I kept it for those devices with SPROMs that are not PCI. If there are none,
then it can de removed.

>> +		sprom = kcalloc(sprom_size_words, sizeof(u16), GFP_KERNEL);
>> +		if (!sprom)
>> +			goto out;
>> +
>> +		/* Use interruptible locking, as the SPROM write might
>> +		 * be holding the lock for several seconds. So allow userspace
>> +		 * to cancel operation. */
>> +		err = -ERESTARTSYS;
>> +		if (mutex_lock_interruptible(&bus->sprom_mutex))
>> +			goto out_kfree;
>> +		err = sprom_read(bus, sprom);
>> +		mutex_unlock(&bus->sprom_mutex);
>> +	}
>>  	if (!err)
>>  		count = sprom2hex(sprom, buf, PAGE_SIZE, sprom_size_words);
>>  
>>  out_kfree:
>> -	kfree(sprom);
>> +	if (!bus->sprom_data)
>> +		kfree(sprom);
>>  out:
>>  	return err ? err : count;
>>  }
> 
> I agree that caching the SPROM probably is easier than reading it from
> the wireless core at sysfs read time. There are a few concurrency issues
> that are hard to solve with the current ssb-pci MMIO access code.
> Most notably is that the SPROM read would race with wireless interrupts.

As it was easy and adds very little to the memory footprint, it seems the way to go.

Larry



