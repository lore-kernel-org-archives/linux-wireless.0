Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from li271-223.members.linode.com ([178.79.152.223]:40617 "EHLO
	mail.mleia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755586Ab2HFTjR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 15:39:17 -0400
Message-ID: <50201D62.2020701@mleia.com>
Date: Mon, 06 Aug 2012 22:39:14 +0300
From: Vladimir Zapolskiy <vz@mleia.com>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH] brcm80211: smac: set interface down on reset
References: <1344115747-25627-1-git-send-email-vz@mleia.com>
In-Reply-To: <1344115747-25627-1-git-send-email-vz@mleia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

what do you think about the proposed change? For me the problem is
quite severe, for the last several months I had to patch the kernel
to have functional BCM43225 on my laptop, hopefully the fix should go to the
stable branches as well.

On 05.08.2012 00:29, Vladimir Zapolskiy wrote:
> This change marks interface as down on reset, otherwise the driver can't
> reinitialize itself properly.
>
> Without the change a transient problem turns out to be critical and leads
> to inavailability to reset the driver without brcmsmac module unload/load
> cycle:

s/inavailability/unavailability/

>      ieee80211 phy0: wl0: PSM microcode watchdog fired at 5993 (seconds). Resetting.
>      brcms_c_dpc : PSM Watchdog, chipid 0xa8d9, chiprev 0x1
>      ieee80211 phy0: wl0: fatal error, reinitializing
>      ieee80211 phy0: Hardware restart was requested
>      ieee80211 phy0: brcms_ops_start: brcms_up() returned -19
>
> Signed-off-by: Vladimir Zapolskiy<vz@mleia.com>
> Cc: Arend van Spriel<arend@broadcom.com>
> ---
>   drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c |    3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> index 192ad5c..a5edebe 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> @@ -1233,6 +1233,9 @@ uint brcms_reset(struct brcms_info *wl)
>   	/* dpc will not be rescheduled */
>   	wl->resched = false;
>
> +	/* inform publicly that interface is down */
> +	wl->pub->up = false;
> +
>   	return 0;
>   }
>

-- 
With best wishes,
Vladimir
