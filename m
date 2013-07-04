Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1471 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799Ab3GDKfJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jul 2013 06:35:09 -0400
Message-ID: <51D54FD2.6090107@broadcom.com> (sfid-20130704_123515_159251_E22D8B88)
Date: Thu, 4 Jul 2013 12:34:58 +0200
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
In-Reply-To: <1372904558.22888.50.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/04/2013 04:22 AM, Ben Hutchings wrote:
> On Wed, 2013-05-29 at 15:13 +0200, Arend van Spriel wrote:
>> From: Franky Lin <frankyl@broadcom.com>
>>
>> Add missing firmware file for the BCM43241 SDIO device. The firmware
>> version is v6.10.170.4
>>
>> Reported-by: Alex Courbot <acourbot@nvidia.com>
>> Signed-off-by: Franky Lin <frankyl@broadcom.com>
>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>> ---
>> Hi Ben,
>>
>> Somehow this firmware got forgotten although brcmfmac has support for
>> the device for a while now.
>>
>> Regards,
>> Arend
>> ---
>>   WHENCE                 |    1 +
>>   brcm/brcmfmac43241.bin |  Bin 0 -> 414238 bytes
>>   2 files changed, 1 insertion(+)
>>   create mode 100644 brcm/brcmfmac43241.bin
>>
>> diff --git a/WHENCE b/WHENCE
>> index ef64612..5eca1d0 100644
>> --- a/WHENCE
>> +++ b/WHENCE
>> @@ -1652,6 +1652,7 @@ Driver: brcmfmac - Broadcom 802.11n fullmac wireless LAN driver.
>>
>>   File: brcm/bcm4329-fullmac-4.bin
>>   File: brcm/brcmfmac43236b.bin
>> +File: brcm/brcmfmac43241.bin
>>   File: brcm/brcmfmac4329.bin
>>   File: brcm/brcmfmac4330.bin
>>   File: brcm/brcmfmac4334.bin
> [...]
>
> Unless you're doing something very clever with macros, I don't believe
> you've posted any driver code that uses this file... or several of the
> others.  The current driver in net-next (I don't know what you've sent
> to Nvidia) appears to request only these files:

Hi, Ben

Nvidia was just using the upstream brcmfmac driver. The "clever" thing 
we are doing for the SDIO part of our brcmfmac driver is that the 
firmware filename requested by the driver is always brcmfmac-sdio.bin. 
We explain on wireless.kernel.org that people should link/copy the 
firmware file for their device to brcmfmac-sdio.bin and get 
brcmfmac-sdio.txt from their board supplier as it is very board specific 
initialization data. I understand this complicates your job in finding 
out where the firmware is actually used and I apologize.

> - brcm/brcmfmac43143.bin
> - brcm/brcmfmac43236b.bin
> - brcm/brcmfmac43242a.bin

These are used by USB part of brcmfmac and

> - brcm/brcmfmac-sdio.bin
> - brcm/brcmfmac-sdio.txt
>
> Looking through the git history, I can see that various other names have
> been used:
>
> - brcm/bcm4329-fullmac-4.bin (renamed to brcm/brcmfmac-sdio.bin)
> - brcm/bcm4329-fullmac-4.txt (renamed to brcm/brcmfmac-sdio.txt)
> - brcm/brcmfmac-usb.bin (renamed to brcm/brcmfmac43236b.bin)
> - brcm/brcmfmac.bin (renamed to brcm/brcmfmac-sdio.bin)
> - brcm/brcmfmac.txt (renamed to brcm/brcmfmac-sdio.txt)
>
> So I think, before this patch is applied, you owe me and David patches
> to:
>
> 1. Add brcm/brcmfmac43143.bin, brcm/brcmfmac43242a.bin and
> brcm/brcmfmac-sdio.txt.

The 43143 and 43242 bin files will be submitted, but these firmwares 
have not yet been released. I have to wait for a green light on that.

> 2. Rename brcm/bcm4329-fullmac-4.bin to brcm/brcmfmac-sdio.bin.

That file is there for brcmfmac in older kernels (< v3.3) as the 
replacement brcmfmac4329.bin does not work with brcmfmac in those older 
kernels.

> 3. Add symlinks from all the old names to the new names.  (As
> linux-firmware should support old in-tree drivers indefinitely.)

I will look into this to see what names were used by brcmfmac since it 
was mainlined.

> and you owe linux-wireless some driver patches.
>
> linux-firmware.git is not the appropriate place to send firmware used
> only by out-of-tree code, and any firmware blob that has never been
> referenced by in-tree code is subject to removal.

I am aware and none of the firmwares we released are for out-of-tree 
code. We actually got feedback that using the same firmware filename for 
multiple devices was not very user-friendly. Therefore we will get rid 
of this quirky approach in the next kernel and the firmware files in 
linux-firmware will be listed in brcmfmac using the MODULE_FIRMWARE() macro.

Regards,
Arend

