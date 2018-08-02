Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60036 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbeHBJYt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Aug 2018 05:24:49 -0400
Date: Thu, 2 Aug 2018 09:34:54 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        venkateswara.kaja@microchip.com, ganesh.krishna@microchip.com,
        adham.abozaeid@microchip.com, aditya.shankar@microchip.com
Subject: Re: [PATCH 8/8] staging: wilc1000: added parentheses in macro to
 avoid checkpatch issue
Message-ID: <20180802073454.GC14107@kroah.com> (sfid-20180802_093500_916899_03929298)
References: <1532844417-3192-1-git-send-email-ajay.kathat@microchip.com>
 <1532844417-3192-9-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1532844417-3192-9-git-send-email-ajay.kathat@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 29, 2018 at 11:36:57AM +0530, Ajay Singh wrote:
> Cleanup patch to fix below checkpatch reported issue:
> 
> Macro argument 'id' may be better as '(id)' to avoid precedence issues
> 
> Also updated the TODO file to remove the below item
>  'rework comments and function headers(also coding style)'
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/TODO        | 1 -
>  drivers/staging/wilc1000/wilc_wlan.h | 2 +-
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/TODO b/drivers/staging/wilc1000/TODO
> index 6fd3a4c..862e9ea 100644
> --- a/drivers/staging/wilc1000/TODO
> +++ b/drivers/staging/wilc1000/TODO
> @@ -1,4 +1,3 @@
>  TODO:
> -- rework comments and function headers(also coding style)
>  - support soft-ap and p2p mode
>  - support resume/suspend function
> diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
> index 696cf1f..cd1ff85 100644
> --- a/drivers/staging/wilc1000/wilc_wlan.h
> +++ b/drivers/staging/wilc1000/wilc_wlan.h
> @@ -4,7 +4,7 @@
>  
>  #include <linux/types.h>
>  
> -#define ISWILC1000(id)			((id & 0xfffff000) == 0x100000 ? 1 : 0)
> +#define ISWILC1000(id)		(((id) & 0xfffff000) == 0x100000 ? 1 : 0)

Even better, make this an inline function that returns a boolean to
avoid any potental problems.

thanks,

greg k-h
