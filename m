Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:15771 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbaCIHK4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2014 03:10:56 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Joe Perches <joe@perches.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl@lists.infradead.org>
Subject: Re: [PATCH 5/6] ath6kl: remove a warning on a macro
References: <20140309065606.10793.67068.stgit@x230>
	<20140309065735.10793.45835.stgit@x230>
Date: Sun, 9 Mar 2014 09:10:50 +0200
In-Reply-To: <20140309065735.10793.45835.stgit@x230> (Kalle Valo's message of
	"Sun, 09 Mar 2014 08:57:35 +0200")
Message-ID: <87iornn8xx.fsf@kamboji.qca.qualcomm.com> (sfid-20140309_081100_577863_9B92EFEE)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joe,

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Fixes checkpatch warning:
>
> WARNING: Single statement macros should not use a do {} while (0) loop

I would need help with this checkpatch warning:

> --- a/drivers/net/wireless/ath/ath6kl/debug.c
> +++ b/drivers/net/wireless/ath/ath6kl/debug.c
> @@ -798,12 +798,10 @@ static ssize_t ath6kl_endpoint_stats_read(struct file *file,
>  		return -ENOMEM;
>  
>  #define EPSTAT(name)							\
> -	do {								\
> -		len = print_endpoint_stat(target, buf, buf_len, len,	\
> -					  offsetof(struct htc_endpoint_stats, \
> -						   name),		\
> -					  #name);			\
> -	} while (0)
> +	(len = print_endpoint_stat(target, buf, buf_len, len,		\
> +				   offsetof(struct htc_endpoint_stats,	\
> +					    name),			\
> +				   #name))

I wasn't quite able to figure out what is the preferred style here. I
don't see how the () style is any better, but checkpatch didn't complain
at least.

-- 
Kalle Valo
