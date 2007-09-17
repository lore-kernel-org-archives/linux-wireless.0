Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3997 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbXIQPko (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2007 11:40:44 -0400
Date: Mon, 17 Sep 2007 11:03:58 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] b43legacy: Don't cancel the restart workqueue in  wireless_core_exit
Message-ID: <20070917150358.GC9282@tuxdriver.com>
References: <46e577e8.J3sSMKsbv5F0EAQY%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <46e577e8.J3sSMKsbv5F0EAQY%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is this the correct patch?  The first hunk conflicts with an earlier
patch ("b43legacy: Fix cancellation of work queues").

John

On Mon, Sep 10, 2007 at 11:59:20AM -0500, Larry Finger wrote:
> From: Michael Buesch <mb@bu3sch.de>
> 
> The wq must be canceled later on rmmod. It's nonfatal, if
> the wq runs on a device that's not started or down. It will
> handle these cases.
> But syncing in wireless_core_exit() will cause a deadlock with
> the restart_work. (restart work cancels itself)
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> Signed-off-by: Larry Finger <larry.finger@lwfinger.net>
> ---
> 
> John,
> 
> Sorry, but I sent the bare patch in the first version.
> 
> Larry
> 
>  drivers/net/wireless/b43legacy/main.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: wireless-dev/drivers/net/wireless/b43legacy/main.c
> ===================================================================
> --- wireless-dev.orig/drivers/net/wireless/b43legacy/main.c
> +++ wireless-dev/drivers/net/wireless/b43legacy/main.c
> @@ -3021,6 +3021,7 @@ static void b43legacy_wireless_core_exit
>  	B43legacy_WARN_ON(b43legacy_status(dev) > B43legacy_STAT_INITIALIZED);
>  	if (b43legacy_status(dev) != B43legacy_STAT_INITIALIZED)
>  		return;
> +	b43legacy_set_status(dev, B43legacy_STAT_UNINIT);
>  
>  	b43legacy_rng_exit(dev->wl);
>  	b43legacy_pio_free(dev);
> @@ -3520,6 +3521,7 @@ static void b43legacy_one_core_detach(st
>  
>  	wldev = ssb_get_drvdata(dev);
>  	wl = wldev->wl;
> +	cancel_work_sync(&wldev->restart_work);
>  	b43legacy_debugfs_remove_device(wldev);
>  	b43legacy_wireless_core_detach(wldev);
>  	list_del(&wldev->list);
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
John W. Linville
linville@tuxdriver.com
