Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:44324 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159AbXI2Qwr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Sep 2007 12:52:47 -0400
Subject: Re: [PATCH] b43: Use input-polldev for the rfkill switch
From: David Woodhouse <dwmw2@infradead.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <200709281422.34434.mb@bu3sch.de>
References: <200709281422.34434.mb@bu3sch.de>
Content-Type: text/plain
Date: Sat, 29 Sep 2007 17:52:48 +0100
Message-Id: <1191084768.8203.10.camel@shinybook.infradead.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-09-28 at 14:22 +0200, Michael Buesch wrote:
> This removes the direct call to rfkill on an rfkill event
> and replaces it with an input device. This way userspace is also
> notified about the event.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>

...

>  static void do_periodic_work(struct b43_wldev *dev)
>  {
>  	unsigned int state;
>  
>  	state = dev->periodic_state;
> -	if (state % 120 == 0)
> +	if (state % 8 == 0)
>  		b43_periodic_every120sec(dev);
> -	if (state % 60 == 0)
> +	if (state % 4 == 0)
>  		b43_periodic_every60sec(dev);
> -	if (state % 30 == 0)
> +	if (state % 2 == 0)
>  		b43_periodic_every30sec(dev);
> -	if (state % 15 == 0)
> -		b43_periodic_every15sec(dev);
> -	b43_periodic_every1sec(dev);
> +	b43_periodic_every15sec(dev);
>  }
>  
>  /* Estimate a "Badness" value based on the periodic work
> @@ -2429,13 +2400,11 @@ static int estimate_periodic_work_badnes
>  {
>  	int badness = 0;
>  
> -	if (state % 120 == 0)	/* every 120 sec */
> +	if (state % 8 == 0)	/* every 120 sec */
>  		badness += 10;
> -	if (state % 60 == 0)	/* every 60 sec */
> +	if (state % 4 == 0)	/* every 60 sec */
>  		badness += 5;
> -	if (state % 30 == 0)	/* every 30 sec */
> -		badness += 1;
> -	if (state % 15 == 0)	/* every 15 sec */
> +	if (state % 2 == 0)	/* every 30 sec */
>  		badness += 1;
>  
>  #define BADNESS_LIMIT	4
> @@ -2486,13 +2455,13 @@ static void b43_periodic_work_handler(st
>  		spin_unlock_irqrestore(&dev->wl->irq_lock, flags);
>  	}
>  	dev->periodic_state++;
> -      out_requeue:
> +out_requeue:
>  	if (b43_debug(dev, B43_DBG_PWORK_FAST))
>  		delay = msecs_to_jiffies(50);
>  	else
> -		delay = round_jiffies(HZ);
> +		delay = round_jiffies(HZ * 15);
>  	queue_delayed_work(dev->wl->hw->workqueue, &dev->periodic_work, delay);
> -      out:
> +out:
>  	mutex_unlock(&dev->wl->mutex);
>  }

Does this bit belong to your other patch?


-- 
dwmw2

