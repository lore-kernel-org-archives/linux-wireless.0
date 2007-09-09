Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:43611
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbXIIMOY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Sep 2007 08:14:24 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] b43: Simplify and cleanup debugfs infrastructure
Date: Sun, 9 Sep 2007 14:12:22 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Larry Finger <larry.finger@lwfinger.net>
References: <200709091353.52002.mb@bu3sch.de>
In-Reply-To: <200709091353.52002.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200709091412.22672.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 09 September 2007 13:53:51 Michael Buesch wrote:
> Index: wireless-dev/drivers/net/wireless/b43/main.c
> ===================================================================
> --- wireless-dev.orig/drivers/net/wireless/b43/main.c	2007-09-07 16:36:00.000000000 +0200
> +++ wireless-dev/drivers/net/wireless/b43/main.c	2007-09-09 13:27:14.000000000 +0200
> @@ -762,7 +762,6 @@ static void keymac_write(struct b43_wlde
>  		 */
>  		if (index < 8) {
>  			/* TODO write to RCM 16, 19, 22 and 25 */
> -			TODO();
>  		} else {
>  			b43_shm_write32(dev, B43_SHM_SHARED,
>  					B43_SHM_SH_PSM + (index * 6) + 0,
> @@ -3593,19 +3592,23 @@ static void b43_chip_reset(struct work_s
>  
>  	mutex_lock(&wl->mutex);
>  
> +printk("RESTART\n");
>  	prev_status = b43_status(dev);
>  	/* Bring the device down... */
>  	if (prev_status >= B43_STAT_STARTED)
>  		b43_wireless_core_stop(dev);
> +printk("exit\n");
>  	if (prev_status >= B43_STAT_INITIALIZED)
>  		b43_wireless_core_exit(dev);
>  
> +printk("init\n");
>  	/* ...and up again. */
>  	if (prev_status >= B43_STAT_INITIALIZED) {
>  		err = b43_wireless_core_init(dev);
>  		if (err)
>  			goto out;
>  	}
> +printk("start\n");
>  	if (prev_status >= B43_STAT_STARTED) {
>  		err = b43_wireless_core_start(dev);
>  		if (err) {
> @@ -3613,6 +3616,7 @@ static void b43_chip_reset(struct work_s
>  			goto out;
>  		}
>  	}
> +printk("done\n");
>        out:
>  	mutex_unlock(&wl->mutex);
>  	if (err)

Whoopsy. Seems like I should remove debugging code before submission :)


-- 
Greetings Michael.
