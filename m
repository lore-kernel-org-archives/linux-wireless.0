Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:55668 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422893AbcFMNkr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2016 09:40:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Binoy Jayan <binoy.jayan@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] staging: wilc1000: Replace semaphore close_exit_sync with completion
Date: Mon, 13 Jun 2016 15:42:08 +0200
Message-ID: <3987173.lIusvGA2iF@wuerfel> (sfid-20160613_154104_397391_81EB1E70)
In-Reply-To: <1465814259-3009-6-git-send-email-binoy.jayan@linaro.org>
References: <1465814259-3009-1-git-send-email-binoy.jayan@linaro.org> <1465814259-3009-6-git-send-email-binoy.jayan@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, June 13, 2016 4:07:37 PM CEST Binoy Jayan wrote:
> @@ -31,7 +31,7 @@ static struct notifier_block g_dev_notifier = {
> 
>         .notifier_call = dev_state_ev_handler
>  
>  };
> 
> -static struct semaphore close_exit_sync;
> +static struct completion close_exit_sync;
> 
>  static int wlan_deinit_locks(struct net_device *dev);
>  static void wlan_deinitialize_threads(struct net_device *dev);
> @@ -1088,7 +1088,7 @@ int wilc_mac_close(struct net_device *ndev)
>                 WILC_WFI_deinit_mon_interface();
>         }
>  
> -       up(&close_exit_sync);
> +       complete(&close_exit_sync);
>         vif->mac_opened = 0;
>  
>         return 0;
> @@ -1232,7 +1232,8 @@ void wilc_netdev_cleanup(struct wilc *wilc)
>         }
>  
>         if (wilc && (wilc->vif[0]->ndev || wilc->vif[1]->ndev)) {
> -               wilc_lock_timeout(wilc, &close_exit_sync, 5 * 1000);
> +               wait_for_completion_timeout(&close_exit_sync,
> +                                               msecs_to_jiffies(5000));
>  
>                 for (i = 0; i < NUM_CONCURRENT_IFC; i++)
>                         if (wilc->vif[i]->ndev)
> @@ -1258,7 +1259,7 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
>         struct net_device *ndev;
>         struct wilc *wl;
>  
> -       sema_init(&close_exit_sync, 0);
> +       init_completion(&close_exit_sync);
>  
>         wl = kzalloc(sizeof(*wl), GFP_KERNEL);
>         if (!wl)

Here the original code seems wrong. Your patch doesn't make it worse, but
it also doesn't make it better.

What I see here is:

- There is a global semaphore for what should be per-device if anything

- we call up() or complete() every time we close one of the subdevices,
  but we do nothing when we open them, so the count will just go up
  over time as the device is being used.

- if the device is never used, the semaphore is locked and we end up
  having to wait for the timeout here, for no reason at all.

- if the timeout happens, this has no other consequences than running
  the following code later, we don't even warn about this.

- I don't see any reason why we even need a semaphore or completion here,
  it only blocks (or delays) the unregistering of the netdev, which
  we should always be able to unregister.

To conclude, I think we can just remove this semaphore without a replacement
(but with my findings above). Maybe the owners of the driver can shed some
more light on this question.

	Arnd
