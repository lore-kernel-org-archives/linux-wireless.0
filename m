Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2358 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799Ab1EJTEo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 15:04:44 -0400
Message-ID: <4DC98C3F.8070107@broadcom.com> (sfid-20110510_210447_788062_5F5F1EB7)
Date: Tue, 10 May 2011 21:04:31 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Greg KH" <greg@kroah.com>
cc: "gregkh@suse.de" <gregkh@suse.de>,
	"Julian Calaby" <julian.calaby@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH 9/9] staging: brcm80211: move utility functions into
 new module
References: <1304951590-2411-1-git-send-email-arend@broadcom.com>
 <1304951590-2411-10-git-send-email-arend@broadcom.com>
 <BANLkTimvWnhJDSdn+fhGw=WAZDU4RPEKmg@mail.gmail.com>
 <4DC91A4C.7020305@broadcom.com> <20110510180449.GE2335@kroah.com>
In-Reply-To: <20110510180449.GE2335@kroah.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/10/2011 08:04 PM, Greg KH wrote:
> On Tue, May 10, 2011 at 12:58:20PM +0200, Arend van Spriel wrote:
>> On 05/10/2011 06:18 AM, Julian Calaby wrote:
>>> Arend, Henry,
>>>
>>> One problem I noticed with your patch:
>>>
>>> On Tue, May 10, 2011 at 00:33, Arend van Spriel<arend@broadcom.com>   wrote:
>>>> From: Henry Ptasinski<henryp@broadcom.com>
>>>>
>>>> Move utility functions shared by the brcmsmac and brcmfmac drivers into a new
>>>> module, brcmutil.ko.  This eliminates the need to compile and link the shared
>>>> functions into both drivers.  Prefix all exported symbols with "bcm_".
>>>>
>>>> Cc: devel@linuxdriverproject.org
>>>> Cc: linux-wireless@vger.kernel.org
>>>> Reviewed-by: Brett Rudley<brudley@broadcom.com>
>>>> Signed-off-by: Arend van Spriel<arend@broadcom.com>
>>>> ---
>>>>   drivers/staging/brcm80211/Makefile                |    1 +
>>>>
>>>> diff --git a/drivers/staging/brcm80211/Makefile b/drivers/staging/brcm80211/Makefile
>>>> index c064cdf..287ad0e 100644
>>>> --- a/drivers/staging/brcm80211/Makefile
>>>> +++ b/drivers/staging/brcm80211/Makefile
>>>> @@ -19,5 +19,6 @@
>>>>   subdir-ccflags-y                                       := -DBCMDMA32
>>>>   subdir-ccflags-$(CONFIG_BRCMDBG)       += -DBCMDBG -DBCMDBG_ASSERT
>>>>
>>>> +obj-m                  += util/
>>>>   obj-$(CONFIG_BRCMFMAC) += brcmfmac/
>>>>   obj-$(CONFIG_BRCMSMAC) += brcmsmac/
>>> You should not use obj-m directly - the way this is set up, if module
>>> support is disabled, then the driver will fail as the brcmutil module
>>> will not be built. This might also happen if the drivers are built
>>> into the kernel ('y' rather than 'm')
>>>
>>> You should create a new Kconfig variable (say BRCMWLUTIL) and use some
>>> Kconfig trickery to ensure that it's built properly for the drivers
>>> that need it, then replace this line with something like
>>>
>>> obj-$(CONFIG_BRCMWLUTIL)
>>>
>>> The LIB80211 symbol used by the Intel 2x00 (old non-mac80211) wireless
>>> drivers uses similar trickery to ensure that everything is built
>>> properly.
>> Hi Greg,
>>
>> We were informed about this potential problem. Should I resend this
>> patch or fix it with a separate patch?
> Resend it with a fixed version, I'll just not apply this one in the
> series for now.
Will do that.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


