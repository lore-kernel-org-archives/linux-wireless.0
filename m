Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:33959 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbaBBWRN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Feb 2014 17:17:13 -0500
Received: by mail-ee0-f42.google.com with SMTP id b15so1466868eek.15
        for <linux-wireless@vger.kernel.org>; Sun, 02 Feb 2014 14:17:11 -0800 (PST)
Message-ID: <52EEC3E6.5040601@gmail.com> (sfid-20140202_231716_090465_72F56062)
Date: Sun, 02 Feb 2014 23:17:10 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org
CC: users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH] rt2800: disable PS by default on USB
References: <1391013757-13078-1-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1391013757-13078-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/29/14 17:42, Stanislaw Gruszka wrote:
> We have disabled it currently on other buses. PS can cause some issues,
> not necessarily with our driver but on AP, that are not easy to debug.
> Since behaviour differs on rt2800usb and rt2800pci, user usually blame
> for malfunction rt2800usb driver, whereas issue is on AP side.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Looks a bit drastic to me, but if it helps users:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 776aff3..510dde0 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -7453,10 +7453,9 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  	u32 reg;
>  
>  	/*
> -	 * Disable powersaving as default on PCI devices.
> +	 * Disable powersaving as default.
>  	 */
> -	if (rt2x00_is_pci(rt2x00dev) || rt2x00_is_soc(rt2x00dev))
> -		rt2x00dev->hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
> +	rt2x00dev->hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
>  
>  	/*
>  	 * Initialize all hw fields.
> 


-- 
---
Gertjan
