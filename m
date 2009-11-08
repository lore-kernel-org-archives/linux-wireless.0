Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:22011 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807AbZKHTJW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 14:09:22 -0500
Received: by ey-out-2122.google.com with SMTP id 25so40116eya.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 11:09:26 -0800 (PST)
Message-ID: <4AF71764.2050408@gmail.com>
Date: Sun, 08 Nov 2009 20:09:24 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 5/9] rt2800: prepare for rt2800*_probe_hw_mode() unification
References: <20091108133854.23584.86842.sendpatchset@localhost.localdomain> <20091108133925.23584.37879.sendpatchset@localhost.localdomain> <4AF6D727.6000100@gmail.com> <200911081848.06556.bzolnier@gmail.com>
In-Reply-To: <200911081848.06556.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/08/09 18:48, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 08 November 2009 15:35:19 Gertjan van Wingerde wrote:
>> On 11/08/09 14:39, Bartlomiej Zolnierkiewicz wrote:
>>> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>> Subject: [PATCH] rt2800: prepare for rt2800*_probe_hw_mode() unification
>>>
>>> Enclose interface specific code in rt2800[pci,usb]_probe_hw_mode()
>>> with rt2x00_intf_is_[pci,usb]() checks.
>>>
>>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> [ please remove needles parts of mails, thanks! ]
> 
>>> @@ -800,17 +804,18 @@ static int rt2800usb_probe_hw_mode(struc
>>>  	spec->supported_bands = SUPPORT_BAND_2GHZ;
>>>  	spec->supported_rates = SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
>>>  
>>> -	if (rt2x00_rf(&rt2x00dev->chip, RF2820) ||
>>> -	    rt2x00_rf(&rt2x00dev->chip, RF2720)) {
>>> +	if (rt2x00_rf(chip, RF2820) ||
>>> +	    rt2x00_rf(chip, RF2720)) {
>>>  		spec->num_channels = 14;
>>>  		spec->channels = rf_vals;
>>> -	} else if (rt2x00_rf(&rt2x00dev->chip, RF2850) ||
>>> -		   rt2x00_rf(&rt2x00dev->chip, RF2750)) {
>>> +	} else if (rt2x00_rf(chip, RF2850) ||
>>> +		   rt2x00_rf(chip, RF2750)) {
>>>  		spec->supported_bands |= SUPPORT_BAND_5GHZ;
>>>  		spec->num_channels = ARRAY_SIZE(rf_vals);
>>>  		spec->channels = rf_vals;
>>> -	} else if (rt2x00_rf(&rt2x00dev->chip, RF3020) ||
>>> -		   rt2x00_rf(&rt2x00dev->chip, RF2020)) {
>>> +	} else if (rt2x00_intf_is_usb(rt2x00dev) &&
>>> +		    (rt2x00_rf(chip, RF3020) ||
>>> +		     rt2x00_rf(chip, RF2020))) {
>>>  		spec->num_channels = ARRAY_SIZE(rf_vals_3070);
>>>  		spec->channels = rf_vals_3070;
>>>  	}
>>>
>>
>> Hmm, another one where we can benefit from decoupling RF chipset code from the actual interface (USB or PCI) used. I do not see the need to check for
>> USB or PCI support, we just need to unify on the RF chipset level.
>>
>> BTW this rf_vals_3070 initialization looks weird. It doesn't resemble any other rf_channel initializations we have. I'd say we can go with the rt2800pci variant of the initialization here.
> 
> IIRC from the vendor driver rf_vals_3070 is needed so by working
> in the incremental way I prefer to leave it as it is before somebody
> verifies this with the vendor driver, also it should be a separate
> patch for better bisectability anyway.
> 

The vendor driver does this in a slightly different way. I was caught off-guard on the complexity of this code.
I'll look at that myself. So, on second thought,

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

---
Gertjan. 
