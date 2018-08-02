Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60034 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbeHBJYJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Aug 2018 05:24:09 -0400
Date: Thu, 2 Aug 2018 09:34:15 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        venkateswara.kaja@microchip.com, ganesh.krishna@microchip.com,
        adham.abozaeid@microchip.com, aditya.shankar@microchip.com
Subject: Re: [PATCH 7/8] staging: wilc1000: replace udelay with usleep_range
Message-ID: <20180802073415.GB14107@kroah.com> (sfid-20180802_093421_231161_C460760C)
References: <1532844417-3192-1-git-send-email-ajay.kathat@microchip.com>
 <1532844417-3192-8-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1532844417-3192-8-git-send-email-ajay.kathat@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 29, 2018 at 11:36:56AM +0530, Ajay Singh wrote:
> Cleanup patch to avoid the below checkpatch reported issue.
> 
> "usleep_range is preferred over udelay; see
> Documentation/timers/timers-howto.txt".
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/wilc_wlan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
> index 6bac3f7..655952a 100644
> --- a/drivers/staging/wilc1000/wilc_wlan.c
> +++ b/drivers/staging/wilc1000/wilc_wlan.c
> @@ -425,7 +425,7 @@ void chip_wakeup(struct wilc *wilc)
>  		} while (wilc_get_chipid(wilc, true) == 0);
>  	} else if ((wilc->io_type & 0x1) == HIF_SDIO) {
>  		wilc->hif_func->hif_write_reg(wilc, 0xfa, 1);
> -		udelay(200);
> +		usleep_range(200, 201);

Hah, that's funny.

No, do it right, don't try to game checkpatch here.

greg k-h
