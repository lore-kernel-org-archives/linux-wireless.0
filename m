Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3515 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932137Ab3KFN3l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 08:29:41 -0500
Message-ID: <527A443B.9090500@broadcom.com> (sfid-20131106_142945_534425_133A2ED7)
Date: Wed, 6 Nov 2013 14:29:31 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: "Dan Carpenter" <dan.carpenter@oracle.com>,
	brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org
Subject: Re: How to get BRCM to work?
References: <20131104115111.GM26669@mwanda>
 <52778D30.6030605@hauke-m.de> <20131104130728.GA20521@mwanda>
 <5277B7AD.6000309@broadcom.com> <20131105222537.GF20521@mwanda>
 <527A0F8D.1050409@broadcom.com> <527A389E.9050701@hauke-m.de>
In-Reply-To: <527A389E.9050701@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/06/13 13:39, Hauke Mehrtens wrote:
> On 11/06/2013 10:44 AM, Arend van Spriel wrote:
>> On 11/05/2013 11:25 PM, Dan Carpenter wrote:
>>> It's working.  I think it was just a problem with the random old
>>> linux-next kernel I was testing.  Sorry for the noise.
>>>
>>> I do think it should be "select BCMA" instead of "depends on BCMA".  Is
>>> there something I have missed?
>>
>> I agree that most users would be unaware that they need BCMA. However,
>> the usual problem with 'select' is that the dependencies of the selected
>> item are not selected. I believe Kconfig will fire off a warning for it,
>> but the aforementioned users may only raise an eyebrow and continue.
>>
>> If there are Kconfig wizards out there, please feel free to make any
>> suggestions.
>
> Currently CONFIG_BCMA does not select anything else, it just depends on
> CONFIG_BCMA_POSSIBLE, when CONFIG_BCMA is selected CONFIG_BCMA_HOST_PCI
> will be activated automatically, so for the case of a PCIe card it
> should work with "select BCMA" in brcmsmac, CONFIG_BCMA_POSSIBLE is set
> for all normal PCs.

I remember vaguely some issues with selecting GPIOLIB. Anyway, I guess I 
should go for:

depends BCMA_POSSIBLE
select BCMA if BCMA_POSSIBLE

The first makes sure brcmsmac can only be selected on platforms where 
BCMA is possible and the second for the BCMA selection. Does that make 
sense?

Regards,
Arend

> In b43 we do the same with CONFIG_SSB and I do not know of any problems.
>
> Hauke
>


