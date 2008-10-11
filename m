Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:1687 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbYJKNxz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Oct 2008 09:53:55 -0400
Received: by ug-out-1314.google.com with SMTP id k3so143244ugf.37
        for <linux-wireless@vger.kernel.org>; Sat, 11 Oct 2008 06:53:52 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 1/5] rfkill: use killable locks instead of interruptible
Date: Sat, 11 Oct 2008 15:53:46 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <1223586933-17753-1-git-send-email-hmh@hmh.eng.br> <1223586933-17753-2-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1223586933-17753-2-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200810111553.46170.IvDoorn@gmail.com> (sfid-20081011_155415_603099_2A931E2F)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 09 October 2008, Henrique de Moraes Holschuh wrote:
> Apparently, many applications don't expect to get EAGAIN from fd read/write
> operations, since POSIX doesn't mandate it.
> 
> Use mutex_lock_killable instead of mutex_lock_interruptible, which won't
> cause issues.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  net/rfkill/rfkill.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> index f949a48..08be968 100644
> --- a/net/rfkill/rfkill.c
> +++ b/net/rfkill/rfkill.c
> @@ -431,8 +431,9 @@ static ssize_t rfkill_state_store(struct device *dev,
>  	    state != RFKILL_STATE_SOFT_BLOCKED)
>  		return -EINVAL;
>  
> -	if (mutex_lock_interruptible(&rfkill->mutex))
> -		return -ERESTARTSYS;
> +	error = mutex_lock_killable(&rfkill->mutex);
> +	if (error)
> +		return error;
>  	error = rfkill_toggle_radio(rfkill, state, 0);
>  	mutex_unlock(&rfkill->mutex);
>  
> @@ -472,7 +473,7 @@ static ssize_t rfkill_claim_store(struct device *dev,
>  	 * Take the global lock to make sure the kernel is not in
>  	 * the middle of rfkill_switch_all
>  	 */
> -	error = mutex_lock_interruptible(&rfkill_global_mutex);
> +	error = mutex_lock_killable(&rfkill_global_mutex);
>  	if (error)
>  		return error;
>  


