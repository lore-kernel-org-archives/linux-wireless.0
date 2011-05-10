Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4150 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679Ab1EJLAw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 07:00:52 -0400
Message-ID: <4DC91A4C.7020305@broadcom.com> (sfid-20110510_130055_870504_D95DD8D4)
Date: Tue, 10 May 2011 12:58:20 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "gregkh@suse.de" <gregkh@suse.de>
cc: "Julian Calaby" <julian.calaby@gmail.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 9/9] staging: brcm80211: move utility functions into
 new module
References: <1304951590-2411-1-git-send-email-arend@broadcom.com>
 <1304951590-2411-10-git-send-email-arend@broadcom.com>
 <BANLkTimvWnhJDSdn+fhGw=WAZDU4RPEKmg@mail.gmail.com>
In-Reply-To: <BANLkTimvWnhJDSdn+fhGw=WAZDU4RPEKmg@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/10/2011 06:18 AM, Julian Calaby wrote:
> Arend, Henry,
>
> One problem I noticed with your patch:
>
> On Tue, May 10, 2011 at 00:33, Arend van Spriel<arend@broadcom.com>  wrote:
>> From: Henry Ptasinski<henryp@broadcom.com>
>>
>> Move utility functions shared by the brcmsmac and brcmfmac drivers into a new
>> module, brcmutil.ko.  This eliminates the need to compile and link the shared
>> functions into both drivers.  Prefix all exported symbols with "bcm_".
>>
>> Cc: devel@linuxdriverproject.org
>> Cc: linux-wireless@vger.kernel.org
>> Reviewed-by: Brett Rudley<brudley@broadcom.com>
>> Signed-off-by: Arend van Spriel<arend@broadcom.com>
>> ---
>>   drivers/staging/brcm80211/Makefile                |    1 +
>>
>> diff --git a/drivers/staging/brcm80211/Makefile b/drivers/staging/brcm80211/Makefile
>> index c064cdf..287ad0e 100644
>> --- a/drivers/staging/brcm80211/Makefile
>> +++ b/drivers/staging/brcm80211/Makefile
>> @@ -19,5 +19,6 @@
>>   subdir-ccflags-y                                       := -DBCMDMA32
>>   subdir-ccflags-$(CONFIG_BRCMDBG)       += -DBCMDBG -DBCMDBG_ASSERT
>>
>> +obj-m                  += util/
>>   obj-$(CONFIG_BRCMFMAC) += brcmfmac/
>>   obj-$(CONFIG_BRCMSMAC) += brcmsmac/
> You should not use obj-m directly - the way this is set up, if module
> support is disabled, then the driver will fail as the brcmutil module
> will not be built. This might also happen if the drivers are built
> into the kernel ('y' rather than 'm')
>
> You should create a new Kconfig variable (say BRCMWLUTIL) and use some
> Kconfig trickery to ensure that it's built properly for the drivers
> that need it, then replace this line with something like
>
> obj-$(CONFIG_BRCMWLUTIL)
>
> The LIB80211 symbol used by the Intel 2x00 (old non-mac80211) wireless
> drivers uses similar trickery to ensure that everything is built
> properly.
Hi Greg,

We were informed about this potential problem. Should I resend this 
patch or fix it with a separate patch?

Gr. AvS

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


