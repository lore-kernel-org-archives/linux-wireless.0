Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:41808 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab1DEPeW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 11:34:22 -0400
Received: by qyg14 with SMTP id 14so346692qyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Apr 2011 08:34:21 -0700 (PDT)
Message-ID: <4D9B3679.10509@lwfinger.net>
Date: Tue, 05 Apr 2011 10:34:17 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Henry Ptasinski <henryp@broadcom.com>, dwmw2@infradead.org
CC: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	brudley@broadcom.com, arend@broadcom.com, rvossen@broadcom.com
Subject: Re: [PATCH 2/3] linux-firmware: Removed codeversion from brcm firmware
 filenames.
References: <1302015522-20601-1-git-send-email-henryp@broadcom.com> <1302015522-20601-3-git-send-email-henryp@broadcom.com>
In-Reply-To: <1302015522-20601-3-git-send-email-henryp@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/05/2011 09:58 AM, Henry Ptasinski wrote:
> The basename-apiversion-codeversion construction for firmware filenames is not
> used by most other firmware files, adds complexity, and is not providing any
> value.  Renamed the firmware files using just basename-apiversion and fixed
> WHENCE to have correct names and path to these files.
> ---
>   WHENCE                                             |   12 ++++++------
>   ...llmac-4-218-248-5.bin =>  bcm4329-fullmac-4.bin} |  Bin 269595 ->  269595 bytes
>   ...llmac-4-218-248-5.txt =>  bcm4329-fullmac-4.txt} |    0
>   brcm/{bcm43xx-0-610-809-0.fw =>  bcm43xx-0.fw}      |  Bin 97376 ->  97376 bytes
>   ...bcm43xx_hdr-0-610-809-0.fw =>  bcm43xx_hdr-0.fw} |  Bin 180 ->  180 bytes
>   5 files changed, 6 insertions(+), 6 deletions(-)
>   rename brcm/{bcm4329-fullmac-4-218-248-5.bin =>  bcm4329-fullmac-4.bin} (100%)
>   rename brcm/{bcm4329-fullmac-4-218-248-5.txt =>  bcm4329-fullmac-4.txt} (100%)
>   rename brcm/{bcm43xx-0-610-809-0.fw =>  bcm43xx-0.fw} (100%)
>   rename brcm/{bcm43xx_hdr-0-610-809-0.fw =>  bcm43xx_hdr-0.fw} (100%)
>
> diff --git a/WHENCE b/WHENCE
> index 6632b85..c81a2b4 100644
> --- a/WHENCE
> +++ b/WHENCE
> @@ -1433,19 +1433,19 @@ Licence:
>
>   --------------------------------------------------------------------------
>
> -Driver: brcm80211 - Broadcom 802.11n wireless LAN driver.
> +Driver: brcmsmac - Broadcom 802.11n softmac wireless LAN driver.
>
> -File: brcm/bcm43xx-0-610-809-0.fw
> -File: brcm/bcm43xx_hdr-0-610-809-0.fw
> +File: brcm/bcm43xx-0.fw
> +File: brcm/bcm43xx_hdr-0.fw
>
>   Licence: Redistributable. See LICENCE.broadcom_bcm43xx for details.
>
>   --------------------------------------------------------------------------
>
> -Driver: brcm80211 - Broadcom 802.11n wireless LAN driver.
> +Driver: brcmfmac - Broadcom 802.11n fullmac wireless LAN driver.
>
> -File: bcm4329-fullmac-4-218-248-5.bin
> -File: bcm4329-fullmac-4-218-248-5.txt
> +File: brcm/bcm4329-fullmac-4.bin
> +File: brcm/bcm4329-fullmac-4.txt
>
>   Licence: Redistributable. See LICENCE.broadcom_bcm43xx for details.
>
> diff --git a/brcm/bcm4329-fullmac-4-218-248-5.txt b/brcm/bcm4329-fullmac-4.txt
> similarity index 100%
> rename from brcm/bcm4329-fullmac-4-218-248-5.txt
> rename to brcm/bcm4329-fullmac-4.txt

Given all the problems we in the b43 community have had with Broadcom firmware, 
I certainly applaud every instance where the company makes firmware freely 
available and redistributable.

I also endorse removing the version number from the firmware name; however, I 
see a fundamental flaw in the present submission. Both brcmsmac and its 
predecessor brcm80211 have been included in mainline and compat-wireless, have 
been widely distributed, and have a number of users. This change will break the 
system of every one of them - including mine. My proposed solution is to do the 
rename as done in this patch, but also include links to the new name from every 
name used in any distributed version. After approximately two years, the links 
can be removed, but they are needed now.

The brcmsmac/brcm80211 driver already has a PR problem due to the instabilities 
and the system lockups. Adding this kind of system breakage would do even more 
damage to its reputation.

Larry

