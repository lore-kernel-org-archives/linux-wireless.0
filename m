Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40032 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030298AbbKFWGT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 17:06:19 -0500
Date: Sat, 7 Nov 2015 01:06:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Punit Vara <punitvara@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: wilc1000: Declare *wilc in init_wilc_driver to
 fix build error
Message-ID: <20151106220603.GD18797@mwanda> (sfid-20151106_230634_527693_F63DE5A9)
References: <1446847163-9643-1-git-send-email-punitvara@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1446847163-9643-1-git-send-email-punitvara@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 07, 2015 at 03:29:23AM +0530, Punit Vara wrote:
> This patch is to the linux_wlan.c file that fixes declaration of *wilc
> to remove following error while building it.
> 
> make drivers/staging/wilc1000/linux_wlan.o
> drivers/staging/wilc1000/linux_wlan.c:1824:24: error: ‘wilc’ undeclared
> 

Which patch broke the build?  Use a Fixes tag.

> Signed-off-by: Punit Vara <punitvara@gmail.com>
> ---
>  drivers/staging/wilc1000/linux_wlan.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
> index 2a5b36f..0805050 100644
> --- a/drivers/staging/wilc1000/linux_wlan.c
> +++ b/drivers/staging/wilc1000/linux_wlan.c
> @@ -1780,6 +1780,7 @@ int wilc_netdev_init(struct wilc **wilc)
>  /*The 1st function called after module inserted*/
>  static int __init init_wilc_driver(void)
>  {
> +	struct wilc *wilc;
>  #ifdef WILC_SPI
>  	struct wilc *wilc;
>  #endif

No that doesn't work at all.  You should be testing these patches better
so you don't introduce more build breakages when you fix a different
build breakage.  Sending this patch is a sign that something is wrong in
your test infrastructure.

regards,
dan carpenter

