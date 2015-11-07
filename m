Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54985 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757921AbbKGCkA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 21:40:00 -0500
Date: Fri, 6 Nov 2015 16:57:03 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Punit Vara <punitvara@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: wilc1000: Declare *wilc in init_wilc_driver to
 fix build error
Message-ID: <20151107005702.GA4296@kroah.com> (sfid-20151107_034137_038618_7B8267C5)
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

Breaks the build :(
