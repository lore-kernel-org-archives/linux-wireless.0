Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:54067 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932739AbcJTJSK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Oct 2016 05:18:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Binoy Jayan <binoy.jayan@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: wilc1000: Remove unused function wilc_lock_timeout
Date: Thu, 20 Oct 2016 11:17:59 +0200
Message-ID: <2246433.KuShhtzXUN@wuerfel> (sfid-20161020_111832_074707_16F0FF63)
In-Reply-To: <1476953672-2198-1-git-send-email-binoy.jayan@linaro.org>
References: <1476953672-2198-1-git-send-email-binoy.jayan@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, October 20, 2016 2:24:32 PM CEST Binoy Jayan wrote:
> Semaphore are going away in the future, so remove the unused function
> wilc_lock_timeout which calls a semaphore api but has no users.
> 
> Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
> ---
> 
> They following is a patch which removes semaphores from wilc1000.
> Its part of a bigger effort to eliminate all semaphores
> from the linux kernel.

Good catch!

>  drivers/staging/wilc1000/linux_wlan.c | 11 -----------
>  1 file changed, 11 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
> index 6370a5e..470d59f 100644
> --- a/drivers/staging/wilc1000/linux_wlan.c
> +++ b/drivers/staging/wilc1000/linux_wlan.c
> @@ -218,17 +218,6 @@ static void deinit_irq(struct net_device *dev)
>         }
>  }
>  
> -int wilc_lock_timeout(struct wilc *nic, void *vp, u32 timeout)
> -{
> -       /* FIXME: replace with mutex_lock or wait_for_completion */
> -       int error = -1;
> -
> -       if (vp)
> -               error = down_timeout(vp,
> -                                    msecs_to_jiffies(timeout));
> -       return error;
> -}

You need to remove the prototype from wilc_wfi_netdevice.h
as well. Once you do that, please add

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
