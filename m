Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3667 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab3GHJ3l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 05:29:41 -0400
Message-ID: <51DA867A.4040704@broadcom.com> (sfid-20130708_112944_546468_F6AAD310)
Date: Mon, 8 Jul 2013 11:29:30 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Ben Hutchings" <ben@decadent.org.uk>
cc: "Linux Wireless" <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>,
	"David Woodhouse" <dwmw2@infradead.org>,
	"Stephen Warren" <swarren@wwwdotorg.org>
Subject: Re: [PATCH] brcm: add brcmfmac sdio firmware for bcm43241
References: <1369833235-3642-1-git-send-email-arend@broadcom.com>
 <1372904558.22888.50.camel@deadeye.wl.decadent.org.uk>
 <51D54FD2.6090107@broadcom.com>
 <1373125142.22888.113.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1373125142.22888.113.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/06/2013 05:39 PM, Ben Hutchings wrote:
> On Thu, 2013-07-04 at 12:34 +0200, Arend van Spriel wrote:
>> On 07/04/2013 04:22 AM, Ben Hutchings wrote:
>>> On Wed, 2013-05-29 at 15:13 +0200, Arend van Spriel wrote:
> [...]
>>>> --- a/WHENCE
>>>> +++ b/WHENCE
>>>> @@ -1652,6 +1652,7 @@ Driver: brcmfmac - Broadcom 802.11n fullmac wireless LAN driver.
>>>>
>>>>    File: brcm/bcm4329-fullmac-4.bin
>>>>    File: brcm/brcmfmac43236b.bin
>>>> +File: brcm/brcmfmac43241.bin
>>>>    File: brcm/brcmfmac4329.bin
>>>>    File: brcm/brcmfmac4330.bin
>>>>    File: brcm/brcmfmac4334.bin
>>> [...]
>>>
>>> Unless you're doing something very clever with macros, I don't believe
>>> you've posted any driver code that uses this file... or several of the
>>> others.  The current driver in net-next (I don't know what you've sent
>>> to Nvidia) appears to request only these files:
>>
>> Hi, Ben
>>
>> Nvidia was just using the upstream brcmfmac driver. The "clever" thing
>> we are doing for the SDIO part of our brcmfmac driver is that the
>> firmware filename requested by the driver is always brcmfmac-sdio.bin.
>> We explain on wireless.kernel.org that people should link/copy the
>> firmware file for their device to brcmfmac-sdio.bin
>
> Not a great idea, but I think you recognise that now.
>
>> and get
>> brcmfmac-sdio.txt from their board supplier as it is very board specific
>> initialization data.
>
> What if someone wants to put more than one of these devices in the same
> system?

It is the same issue as the firmware.

> [...]
>>> So I think, before this patch is applied, you owe me and David patches
>>> to:
>>>
>>> 1. Add brcm/brcmfmac43143.bin, brcm/brcmfmac43242a.bin and
>>> brcm/brcmfmac-sdio.txt.
>>
>> The 43143 and 43242 bin files will be submitted, but these firmwares
>> have not yet been released. I have to wait for a green light on that.
>>
>>> 2. Rename brcm/bcm4329-fullmac-4.bin to brcm/brcmfmac-sdio.bin.
>>
>> That file is there for brcmfmac in older kernels (< v3.3) as the
>> replacement brcmfmac4329.bin does not work with brcmfmac in those older
>> kernels.
>
> OK.
>
>>> 3. Add symlinks from all the old names to the new names.  (As
>>> linux-firmware should support old in-tree drivers indefinitely.)
>>
>> I will look into this to see what names were used by brcmfmac since it
>> was mainlined.
>
> As I said, all the names that have been used should be supported.  So
> either provide multiple versions of the firmware or add symlinks, as
> appropriate.

Will do.

>>> and you owe linux-wireless some driver patches.
>>>
>>> linux-firmware.git is not the appropriate place to send firmware used
>>> only by out-of-tree code, and any firmware blob that has never been
>>> referenced by in-tree code is subject to removal.
>>
>> I am aware and none of the firmwares we released are for out-of-tree
>> code. We actually got feedback that using the same firmware filename for
>> multiple devices was not very user-friendly. Therefore we will get rid
>> of this quirky approach in the next kernel and the firmware files in
>> linux-firmware will be listed in brcmfmac using the MODULE_FIRMWARE() macro.
>
> Thanks for clearing this up.
>
> Please re-send the new firmware, and include the firmware version in
> WHENCE.

I will prepare patches to address item #3 above and to add the new firmware.

Thanks,
Arend


