Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:35420 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866AbZAYMwp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2009 07:52:45 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Alina Friedrichsen" <x-alina@gmx.net>
Subject: Re: [PATCH] b43: Accessing the TSF via mac80211
Date: Sun, 25 Jan 2009 13:51:50 +0100
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
References: <20090125124151.115210@gmx.net>
In-Reply-To: <20090125124151.115210@gmx.net>
MIME-Version: 1.0
Message-Id: <200901251351.50230.mb@bu3sch.de> (sfid-20090125_135250_145759_EA6BD6F4)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 25 January 2009 13:41:51 Alina Friedrichsen wrote:
> This allows the mac80211 high level code to access the TSF. This is e.g. needed for BSSID merges in the IBSS mode.

Thanks, can you also remove our private debugfs hook?

> Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
> ---
> diff -urN wireless-testing.orig/drivers/net/wireless/b43/main.c wireless-testing/drivers/net/wireless/b43/main.c
> --- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-01-25 06:12:13.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/b43/main.c	2009-01-25 13:09:35.000000000 +0100
> @@ -3177,6 +3177,25 @@
>  	return 0;
>  }
>  
> +static u64 b43_op_get_tsf(struct ieee80211_hw *hw)
> +{
> +	struct b43_wl *wl = hw_to_b43_wl(hw);
> +	struct b43_wldev *dev = wl->current_dev;
> +	u64 tsf;
> +

You must add a check and locking here.

	if (dev && (b43_status(dev) >= B43_STAT_INITIALIZED)) {
		mutex_lock(&wl->mutex);
		spin_lock_irq(&wl->irq_lock);

> +	b43_tsf_read(dev, &tsf);

		spin_unlock_irq(&wl->irq_lock);
		mutex_unlock(&wl->mutex);
	} else
		tsf = 0; //FIXME what to do on error?

> +	return tsf;
> +}
> +
> +static void b43_op_set_tsf(struct ieee80211_hw *hw, u64 tsf)
> +{
> +	struct b43_wl *wl = hw_to_b43_wl(hw);
> +	struct b43_wldev *dev = wl->current_dev;

Same check and locking goes here.

> +	b43_tsf_write(dev, tsf);
> +}
> +
>  static void b43_put_phy_into_reset(struct b43_wldev *dev)
>  {
>  	struct ssb_device *sdev = dev->dev;
> @@ -4296,6 +4315,8 @@
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
