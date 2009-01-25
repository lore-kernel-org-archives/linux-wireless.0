Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:49488 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537AbZAYOO0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2009 09:14:26 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Alina Friedrichsen" <x-alina@gmx.net>
Subject: Re: [PATCH v2] b43: Accessing the TSF via mac80211
Date: Sun, 25 Jan 2009 15:13:30 +0100
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
References: <20090125140611.136280@gmx.net>
In-Reply-To: <20090125140611.136280@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901251513.30993.mb@bu3sch.de> (sfid-20090125_151445_095194_AD019567)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 25 January 2009 15:06:11 Alina Friedrichsen wrote:
> --- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-01-25 06:12:13.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/b43/main.c	2009-01-25 14:35:51.000000000 +0100
> @@ -3177,6 +3177,45 @@
>  	return 0;
>  }
>  
> +static u64 b43_op_get_tsf(struct ieee80211_hw *hw)
> +{
> +	struct b43_wl *wl = hw_to_b43_wl(hw);
> +	unsigned long flags;
> +	struct b43_wldev *dev;
> +	u64 tsf;
> +
> +	mutex_lock(&wl->mutex);
> +	spin_lock_irqsave(&wl->irq_lock, flags);

See below

> +	dev = wl->current_dev;
> +
> +	if(dev && (b43_status(dev) >= B43_STAT_INITIALIZED))

See below

> +		b43_tsf_read(dev, &tsf);
> +	else
> +		tsf = 0;
> +
> +	spin_unlock_irqrestore(&wl->irq_lock, flags);
> +	mutex_unlock(&wl->mutex);
> +
> +	return tsf;
> +}
> +
> +static void b43_op_set_tsf(struct ieee80211_hw *hw, u64 tsf)
> +{
> +	struct b43_wl *wl = hw_to_b43_wl(hw);
> +	unsigned long flags;
> +	struct b43_wldev *dev;
> +
> +	mutex_lock(&wl->mutex);
> +	spin_lock_irqsave(&wl->irq_lock, flags);

You can use spin_lock_irq, because we're guaranteed to be in process context (otherwise
the mutex_lock would horribly fail, too)

> +	dev = wl->current_dev;
> +
> +	if(dev && (b43_status(dev) >= B43_STAT_INITIALIZED))

Coding style:

	if (dev...

> +		b43_tsf_write(dev, tsf);
> +
> +	spin_unlock_irqrestore(&wl->irq_lock, flags);
> +	mutex_unlock(&wl->mutex);
> +}
> +
>  static void b43_put_phy_into_reset(struct b43_wldev *dev)
>  {
>  	struct ssb_device *sdev = dev->dev;
> @@ -4296,6 +4335,8 @@
>  	.set_key		= b43_op_set_key,
>  	.get_stats		= b43_op_get_stats,
>  	.get_tx_stats		= b43_op_get_tx_stats,
> +	.get_tsf		= b43_op_get_tsf,
> +	.set_tsf		= b43_op_set_tsf,
>  	.start			= b43_op_start,
>  	.stop			= b43_op_stop,
>  	.set_tim		= b43_op_beacon_set_tim,
> 



-- 
Greetings, Michael.
