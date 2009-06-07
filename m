Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:51088 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbZFGP0I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 11:26:08 -0400
Subject: Re: [PATCH] rfkill: print events when input handler is
 disabled/enabled
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1244370412.2907.2.camel@johannes.local>
References: <1244370412.2907.2.camel@johannes.local>
Content-Type: text/plain
Date: Sun, 07 Jun 2009 17:25:31 +0200
Message-Id: <1244388331.23850.85.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> It is useful for debugging when we know if something disabled
> the in-kernel rfkill input handler.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  net/rfkill/core.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> --- wireless-testing.orig/net/rfkill/core.c	2009-06-07 11:46:05.000000000 +0200
> +++ wireless-testing/net/rfkill/core.c	2009-06-07 11:53:40.000000000 +0200
> @@ -1134,7 +1134,8 @@ static int rfkill_fop_release(struct ino
>  
>  #ifdef CONFIG_RFKILL_INPUT
>  	if (data->input_handler)
> -		atomic_dec(&rfkill_input_disabled);
> +		if (atomic_dec_return(&rfkill_input_disabled) == 0)
> +			printk(KERN_DEBUG "rfkill: input handler enabled\n");
>  #endif
>  
>  	kfree(data);
> @@ -1157,7 +1158,8 @@ static long rfkill_fop_ioctl(struct file
>  	mutex_lock(&data->mtx);
>  
>  	if (!data->input_handler) {
> -		atomic_inc(&rfkill_input_disabled);
> +		if (atomic_inc_return(&rfkill_input_disabled) == 1)
> +			printk(KERN_DEBUG "rfkill: input handler disabled\n");
>  		data->input_handler = true;
>  	}

do you really think the == 1 is the correct thing here. I think that
should be a > 0.

Regards

Marcel


