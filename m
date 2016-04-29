Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53384 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbcD2FGi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2016 01:06:38 -0400
Date: Thu, 28 Apr 2016 22:06:37 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: wilc1000: fix double unlock
Message-ID: <20160429050637.GA15672@kroah.com> (sfid-20160429_070700_067182_8E48C114)
References: <1460647129-22740-1-git-send-email-sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1460647129-22740-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 14, 2016 at 08:48:48PM +0530, Sudip Mukherjee wrote:
> The semaphore was being released twice, once at the beginning of the
> thread and then again when the thread is about to close.
> The semaphore is acquired immediately after creating the thread so we
> should be releasing it when the thread ends.
> 
> Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
> ---
>  drivers/staging/wilc1000/linux_wlan.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
> index a858552..5643a3d 100644
> --- a/drivers/staging/wilc1000/linux_wlan.c
> +++ b/drivers/staging/wilc1000/linux_wlan.c
> @@ -313,7 +313,6 @@ static int linux_wlan_txq_task(void *vp)
>  	vif = netdev_priv(dev);
>  	wl = vif->wilc;
>  
> -	up(&wl->txq_thread_started);
>  	while (1) {
>  		down(&wl->txq_event);
>  

Doesn't apply to my tree at all :(
