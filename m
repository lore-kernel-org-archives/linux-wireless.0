Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:3442 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbXK1S7e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 13:59:34 -0500
Received: by nf-out-0910.google.com with SMTP id g13so1508721nfb
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2007 10:59:33 -0800 (PST)
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] rfkill: fix double-mutex-locking
Date: Wed, 28 Nov 2007 21:13:53 +0100
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200711281749.34572.mb@bu3sch.de>
In-Reply-To: <200711281749.34572.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711282113.53874.IvDoorn@gmail.com> (sfid-20071128_185937_916883_96CD4B95)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 28 November 2007, Michael Buesch wrote:
> rfkill_toggle_radio is called from functions where
> rfkill->mutex is already aquired.
> 
> Remove the lock from rfkill_toggle_radio() and add it to
> the only calling function that calls it without the lock held.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> Index: wireless-2.6/net/rfkill/rfkill.c
> ===================================================================
> --- wireless-2.6.orig/net/rfkill/rfkill.c	2007-11-20 19:09:35.000000000 +0100
> +++ wireless-2.6/net/rfkill/rfkill.c	2007-11-28 17:09:55.000000000 +0100
> @@ -60,11 +60,7 @@ static void rfkill_led_trigger(struct rf
>  static int rfkill_toggle_radio(struct rfkill *rfkill,
>  				enum rfkill_state state)
>  {
> -	int retval;
> -
> -	retval = mutex_lock_interruptible(&rfkill->mutex);
> -	if (retval)
> -		return retval;
> +	int retval = 0;
>  
>  	if (state != rfkill->state) {
>  		retval = rfkill->toggle_radio(rfkill->data, state);
> @@ -74,7 +70,6 @@ static int rfkill_toggle_radio(struct rf
>  		}
>  	}
>  
> -	mutex_unlock(&rfkill->mutex);
>  	return retval;
>  }
>  
> @@ -158,12 +153,13 @@ static ssize_t rfkill_state_store(struct
>  	if (!capable(CAP_NET_ADMIN))
>  		return -EPERM;
>  
> +	if (mutex_lock_interruptible(&rfkill->mutex))
> +		return -ERESTARTSYS;
>  	error = rfkill_toggle_radio(rfkill,
>  			state ? RFKILL_STATE_ON : RFKILL_STATE_OFF);
> -	if (error)
> -		return error;
> +	mutex_unlock(&rfkill->mutex);
>  
> -	return count;
> +	return error ? error : count;
>  }
>  
>  static ssize_t rfkill_claim_show(struct device *dev,
> 


