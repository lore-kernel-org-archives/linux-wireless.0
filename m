Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:62938 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbXJ1OoL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2007 10:44:11 -0400
Received: by ug-out-1314.google.com with SMTP id z38so884619ugc
        for <linux-wireless@vger.kernel.org>; Sun, 28 Oct 2007 07:44:10 -0700 (PDT)
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] rfkill: Use mutex_lock() at register and add sanity check
Date: Sun, 28 Oct 2007 16:03:48 +0100
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200710281516.51356.mb@bu3sch.de>
In-Reply-To: <200710281516.51356.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710281603.48603.IvDoorn@gmail.com> (sfid-20071028_144417_534116_58ED99BE)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 28 October 2007, Michael Buesch wrote:
> Replace mutex_lock_interruptible() by mutex_lock() in rfkill_register(),
> as interruptible doesn't make sense there.
> 
> Add a sanity check for rfkill->type, as that's used for an unchecked dereference
> in an array and might cause hard to debug crashes if the driver sets this
> to an invalid value.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

> Index: wireless-2.6/net/rfkill/rfkill.c
> ===================================================================
> --- wireless-2.6.orig/net/rfkill/rfkill.c	2007-10-28 14:27:30.000000000 +0100
> +++ wireless-2.6/net/rfkill/rfkill.c	2007-10-28 15:07:11.000000000 +0100
> @@ -276,21 +276,17 @@ static struct class rfkill_class = {
>  
>  static int rfkill_add_switch(struct rfkill *rfkill)
>  {
> -	int retval;
> -
> -	retval = mutex_lock_interruptible(&rfkill_mutex);
> -	if (retval)
> -		return retval;
> +	int error;
>  
> -	retval = rfkill_toggle_radio(rfkill, rfkill_states[rfkill->type]);
> -	if (retval)
> -		goto out;
> +	mutex_lock(&rfkill_mutex);
>  
> -	list_add_tail(&rfkill->node, &rfkill_list);
> +	error = rfkill_toggle_radio(rfkill, rfkill_states[rfkill->type]);
> +	if (!error)
> +		list_add_tail(&rfkill->node, &rfkill_list);
>  
> - out:
>  	mutex_unlock(&rfkill_mutex);
> -	return retval;
> +
> +	return error;
>  }
>  
>  static void rfkill_remove_switch(struct rfkill *rfkill)
> @@ -387,6 +383,8 @@ int rfkill_register(struct rfkill *rfkil
>  
>  	if (!rfkill->toggle_radio)
>  		return -EINVAL;
> +	if (rfkill->type >= RFKILL_TYPE_MAX)
> +		return -EINVAL;
>  
>  	snprintf(dev->bus_id, sizeof(dev->bus_id),
>  		 "rfkill%ld", (long)atomic_inc_return(&rfkill_no) - 1);
> 


