Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45081 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab1CQAeH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 20:34:07 -0400
Received: by wya21 with SMTP id 21so2266058wya.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2011 17:34:05 -0700 (PDT)
Message-ID: <4D8156F9.8020609@gmail.com>
Date: Thu, 17 Mar 2011 00:34:01 +0000
From: Dave Kilroy <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Joe Gunn <armadefuego@yahoo.com>
CC: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2.6.38-rc8-wl 1/1] orinoco:  Reduce lock contention by
 reporting static errors before locking
References: <297417.86150.qm@web57403.mail.re1.yahoo.com>
In-Reply-To: <297417.86150.qm@web57403.mail.re1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15/03/2011 15:53, Joe Gunn wrote:
> Check for static error issues before obtaining lock to reduce lock contention
> Signed-off-by: Joseph J. Gunn<armadefuego@yahoo.com>
> ---
> diff --git a/drivers/net/wireless/orinoco/wext.c b/drivers/net/wireless/orinoco/wext.c
> index e793679..c1fe0b5 100644
> --- a/drivers/net/wireless/orinoco/wext.c
> +++ b/drivers/net/wireless/orinoco/wext.c
> @@ -161,36 +161,17 @@ static int orinoco_ioctl_setwap(struct net_device *dev,
>   	static const u8 off_addr[] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
>   	static const u8 any_addr[] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
>
> -	if (orinoco_lock(priv,&flags) != 0)
> -		return -EBUSY;
> -
> -	/* Enable automatic roaming - no sanity checks are needed */
> -	if (memcmp(&ap_addr->sa_data, off_addr, ETH_ALEN) == 0 ||
> -	    memcmp(&ap_addr->sa_data, any_addr, ETH_ALEN) == 0) {
> -		priv->bssid_fixed = 0;
> -		memset(priv->desired_bssid, 0, ETH_ALEN);
> -
> -		/* "off" means keep existing connection */
> -		if (ap_addr->sa_data[0] == 0) {
> -			__orinoco_hw_set_wap(priv);
> -			err = 0;
> -		}
> -		goto out;
> -	}
> -
>   	if (priv->firmware_type == FIRMWARE_TYPE_AGERE) {
>   		printk(KERN_WARNING "%s: Lucent/Agere firmware doesn't "
>   		       "support manual roaming\n",
>   		       dev->name);
> -		err = -EOPNOTSUPP;
> -		goto out;
> +		return(-EOPNOTSUPP);
>   	}
>
>   	if (priv->iw_mode != NL80211_IFTYPE_STATION) {
>   		printk(KERN_WARNING "%s: Manual roaming supported only in "
>   		       "managed mode\n", dev->name);
> -		err = -EOPNOTSUPP;
> -		goto out;
> +		return(-EOPNOTSUPP);
>   	}
>
>   	/* Intersil firmware hangs without Desired ESSID */
> @@ -198,10 +179,27 @@ static int orinoco_ioctl_setwap(struct net_device *dev,
>   	    strlen(priv->desired_essid) == 0) {

I avoided changing the locking too much when I was modifying this driver 
as I wasn't clear on whether the locks needed to protect concurrent wext 
calls from each other. Since all the wext calls hold the lock over the 
entirety of the callback, I assumed that is what they were doing.

In this particular change, the strlen here may give you one result, but 
it may have been changed by the time you take the lock. Also the test on 
priv->iw_mode above may have been invalidated as well.


Dave.

>   		printk(KERN_WARNING "%s: Desired ESSID must be set for "
>   		       "manual roaming\n", dev->name);
> -		err = -EOPNOTSUPP;
> +		return(-EOPNOTSUPP);
> +	}
> +
> +	if (orinoco_lock(priv,&flags) != 0)
> +		return -EBUSY;
> +
> +	/* Enable automatic roaming - no sanity checks are needed */
> +	if (memcmp(&ap_addr->sa_data, off_addr, ETH_ALEN) == 0 ||
> +	    memcmp(&ap_addr->sa_data, any_addr, ETH_ALEN) == 0) {
> +		priv->bssid_fixed = 0;
> +		memset(priv->desired_bssid, 0, ETH_ALEN);
> +
> +		/* "off" means keep existing connection */
> +		if (ap_addr->sa_data[0] == 0) {
> +			__orinoco_hw_set_wap(priv);
> +			err = 0;
> +		}
>   		goto out;
>   	}
>
> +
>   	/* Finally, enable manual roaming */
>   	priv->bssid_fixed = 1;
>   	memcpy(priv->desired_bssid,&ap_addr->sa_data, ETH_ALEN);

