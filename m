Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3167 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725Ab3KYJZS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 04:25:18 -0500
Message-ID: <52931772.30407@broadcom.com> (sfid-20131125_102522_749524_BA1FCAC5)
Date: Mon, 25 Nov 2013 10:25:06 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>, linville@tuxdriver.com
cc: brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] brcmsmac: remove dependency on CRC8 and CRC_CCITT
References: <1385327021-26851-1-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1385327021-26851-1-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/24/2013 10:03 PM, Hauke Mehrtens wrote:
> There is no code in brcmsmac that uses a function from CRC8 or
> CRC_CCITT any more. Building brcmsmac with these two disabled works
> without any problems. This was probably only used by the bus code which
> was replaced by bcma some time ago.

True. These could be removed when using bcma. Thanks for cleaning that up.

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>   drivers/net/wireless/brcm80211/Kconfig |    2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/drivers/net/wireless/brcm80211/Kconfig b/drivers/net/wireless/brcm80211/Kconfig
> index b00a7e9..ce0add3 100644
> --- a/drivers/net/wireless/brcm80211/Kconfig
> +++ b/drivers/net/wireless/brcm80211/Kconfig
> @@ -7,8 +7,6 @@ config BRCMSMAC
>   	depends on BCMA
>   	select BRCMUTIL
>   	select FW_LOADER
> -	select CRC_CCITT
> -	select CRC8
>   	select CORDIC
>   	---help---
>   	  This module adds support for PCIe wireless adapters based on Broadcom
>


