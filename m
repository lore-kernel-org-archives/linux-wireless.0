Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:38067
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbXIDTAB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2007 15:00:01 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] bcm43xx: Fix cancellation of work queues crashes
Date: Tue, 4 Sep 2007 20:59:29 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <46dda9ae.rVFA3HPOna+bGyWP%Larry.Finger@lwfinger.net>
In-Reply-To: <46dda9ae.rVFA3HPOna+bGyWP%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200709042059.29433.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 04 September 2007, Larry Finger wrote:
> A crash upon booting that is caused by bcm43xx has been reported [1] and
> found to be due to a work queue being reinitialized while work on that
> queue is still pending. This fix modifies the shutdown of work queues and
> prevents periodic work from being requeued during shutdown. With this patch,
> no more crashes on reboot were observed by the original reporter. I do not
> get that particular failure on my system; however, when running a large
> number of ifdown/ifup sequences, my system would kernel panic with the
> 'caps lock' light blinking at roughly a 1 Hz rate. In addition, there were
> infrequent failures in the firmware that resulted in 'IRQ READY TIMEOUT'
> errors. With this patch, no more of the first type of failure occur, and
> incidence of the second type is greatly reduced.
> 
> [1] http://bugzilla.kernel.org/show_bug.cgi?id=8937
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> John,
> 
> This fix should be sent to 2.6.23. Once it it there, I'll send it on to
> -stable.
> 
> Larry
> 
> 
>  drivers/net/wireless/bcm43xx/bcm43xx_main.c  |   28 +++++++++++++++++++--------
>  drivers/net/wireless/bcm43xx/bcm43xx_main.h  |    2 -
>  drivers/net/wireless/bcm43xx/bcm43xx_sysfs.c |    3 +-
>  3 files changed, 23 insertions(+), 10 deletions(-)
> 
> Index: linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
> ===================================================================
> --- linux-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_main.c
> +++ linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
> @@ -3197,6 +3197,9 @@ static void bcm43xx_periodic_work_handle
>  	unsigned long orig_trans_start = 0;
>  
>  	mutex_lock(&bcm->mutex);
> +	/* keep from doing and rearming periodic work if shutting down */
> +	if (bcm43xx_status(bcm) == BCM43xx_STAT_UNINIT)
> +		goto unlock_mutex;
>  	if (unlikely(bcm->periodic_state % 60 == 0)) {
>  		/* Periodic work will take a long time, so we want it to
>  		 * be preemtible.
> @@ -3242,14 +3245,10 @@ static void bcm43xx_periodic_work_handle
>  	mmiowb();
>  	bcm->periodic_state++;
>  	spin_unlock_irqrestore(&bcm->irq_lock, flags);
> +unlock_mutex:
>  	mutex_unlock(&bcm->mutex);
>  }
>  
> -void bcm43xx_periodic_tasks_delete(struct bcm43xx_private *bcm)
> -{
> -	cancel_rearming_delayed_work(&bcm->periodic_work);
> -}
> -
>  void bcm43xx_periodic_tasks_setup(struct bcm43xx_private *bcm)
>  {
>  	struct delayed_work *work = &bcm->periodic_work;
> @@ -3299,6 +3298,14 @@ static int bcm43xx_rng_init(struct bcm43
>  	return err;
>  }
>  
> +void bcm43xx_cancel_work(struct bcm43xx_private *bcm)
> +{
> +	/* The system must be unlocked when this routine is entered.
> +	 * If not, the next 2 steps may deadlock */
> +	cancel_work_sync(&bcm->restart_work);
> +	cancel_delayed_work_sync(&bcm->periodic_work);
> +}
> +
>  static int bcm43xx_shutdown_all_wireless_cores(struct bcm43xx_private *bcm)
>  {
>  	int ret = 0;
> @@ -3335,7 +3342,12 @@ static void bcm43xx_free_board(struct bc
>  {
>  	bcm43xx_rng_exit(bcm);
>  	bcm43xx_sysfs_unregister(bcm);
> -	bcm43xx_periodic_tasks_delete(bcm);
> +
> +	mutex_lock(&(bcm)->mutex);
> +	bcm43xx_set_status(bcm, BCM43xx_STAT_UNINIT);
> +	mutex_unlock(&(bcm)->mutex);
> +
> +	bcm43xx_cancel_work(bcm);
>  
>  	mutex_lock(&(bcm)->mutex);
>  	bcm43xx_shutdown_all_wireless_cores(bcm);
> @@ -4030,7 +4042,7 @@ static int bcm43xx_net_stop(struct net_d
>  	err = bcm43xx_disable_interrupts_sync(bcm);
>  	assert(!err);
>  	bcm43xx_free_board(bcm);
> -	flush_scheduled_work();
> +	bcm43xx_cancel_work(bcm);
>  
>  	return 0;
>  }
> @@ -4162,9 +4174,9 @@ static void bcm43xx_chip_reset(struct wo
>  	struct bcm43xx_phyinfo *phy;
>  	int err = -ENODEV;
>  
> +	bcm43xx_cancel_work(bcm);
>  	mutex_lock(&(bcm)->mutex);
>  	if (bcm43xx_status(bcm) == BCM43xx_STAT_INITIALIZED) {
> -		bcm43xx_periodic_tasks_delete(bcm);
>  		phy = bcm43xx_current_phy(bcm);
>  		err = bcm43xx_select_wireless_core(bcm, phy->type);
>  		if (!err)
> Index: linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.h
> ===================================================================
> --- linux-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_main.h
> +++ linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.h
> @@ -122,7 +122,7 @@ void bcm43xx_wireless_core_reset(struct 
>  void bcm43xx_mac_suspend(struct bcm43xx_private *bcm);
>  void bcm43xx_mac_enable(struct bcm43xx_private *bcm);
>  
> -void bcm43xx_periodic_tasks_delete(struct bcm43xx_private *bcm);
> +void bcm43xx_cancel_work(struct bcm43xx_private *bcm);
>  void bcm43xx_periodic_tasks_setup(struct bcm43xx_private *bcm);
>  
>  void bcm43xx_controller_restart(struct bcm43xx_private *bcm, const char *reason);
> Index: linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_sysfs.c
> ===================================================================
> --- linux-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_sysfs.c
> +++ linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_sysfs.c
> @@ -327,8 +327,9 @@ static ssize_t bcm43xx_attr_phymode_stor
>  		goto out;
>  	}
>  
> -	bcm43xx_periodic_tasks_delete(bcm);
> +	bcm43xx_cancel_work(bcm);
>  	mutex_lock(&(bcm)->mutex);
> +	bcm43xx_set_status(bcm, BCM43xx_STAT_UNINIT);

Don't change the status here. That is _wrong_.
The rest of the patch is OK.

>  	err = bcm43xx_select_wireless_core(bcm, phytype);
>  	if (!err)
>  		bcm43xx_periodic_tasks_setup(bcm);


