Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3727 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab1H3PAY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 11:00:24 -0400
Date: Tue, 30 Aug 2011 20:30:07 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/4] ath6kl: cleanup diagnose window read and write
	functions
Message-ID: <20110830150006.GA32378@vasanth-laptop> (sfid-20110830_170028_004839_57902797)
References: <20110830134432.21543.89808.stgit@localhost6.localdomain6> <20110830134450.21543.40524.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <20110830134450.21543.40524.stgit@localhost6.localdomain6>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 30, 2011 at 04:44:50PM +0300, Kalle Valo wrote:
> Just to make them a bit easier to read and unify naming. 32 suffix
> in the function name means that it will be a 32 bit transfer. If there's
> no number a buffer is transfered instead.
> 
> Use void pointers to get rid of ugly casts.
> 
> Don't provide target address as a pointer, pass it by value. Same for
> the value used in write32().
> 
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath6kl/core.h |    6 +-
>  drivers/net/wireless/ath/ath6kl/init.c |   16 ++---
>  drivers/net/wireless/ath/ath6kl/main.c |   94 ++++++++++++++++++--------------
>  3 files changed, 61 insertions(+), 55 deletions(-)

<--snip-->

> +int ath6kl_diag_write(struct ath6kl *ar, u32 address, void *data, u32 length)
> +{
> +	u32 count, *buf = data;
> +	int ret;
> +
> +	if (WARN_ON(length % 4))
> +		return -EINVAL;
> +
> +	for (count = 0; count < length / 4; count++, address += 4) {
> +		ret = ath6kl_diag_write32(ar, address, buf[count]);
> +		if (ret)
> +			return ret;
>  	}
>  
> -	return status;
> +	return ret;

drivers/net/wireless/ath/ath6kl/main.c: In function ‘ath6kl_diag_write’:
drivers/net/wireless/ath/ath6kl/main.c:297: warning: ‘ret’ may be
used uninitialized in this function

Vasanth
>  }
>  
>  /* FIXME: move to a better place, target.h? */
> @@ -327,7 +337,7 @@ static void ath6kl_reset_device(struct ath6kl *ar, u32 target_type,
>  		break;
>  	}
>  
> -	status = ath6kl_write_reg_diag(ar, &address, &data);
> +	status = ath6kl_diag_write32(ar, address, data);
>  
>  	if (status)
>  		ath6kl_err("failed to reset target\n");
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
