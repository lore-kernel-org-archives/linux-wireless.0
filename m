Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43611 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756830Ab1KROLL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 09:11:11 -0500
Subject: Re: [patch] ath6kl: use a larger buffer for debug output
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <20111118140906.GA9685@elgon.mountain> (sfid-20111118_150942_354029_4789F63D)
References: <20111118140906.GA9685@elgon.mountain>
	 (sfid-20111118_150942_354029_4789F63D)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 15:11:01 +0100
Message-ID: <1321625461.10266.57.camel@jlt3.sipsolutions.net> (sfid-20111118_151115_858255_C0615604)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-11-18 at 17:09 +0300, Dan Carpenter wrote:
> This function makes the static checkers grumble.  The return value of
> snprintf() is the number of bytes which would have been copied if
> there was enough space.  In theory, a %u can take take 10 digits so
> len could be larger than 16 and it would be a small information
> leak.
> 
> We may as well make the buffer larger as well since that is very
> easy to do.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
> index 9eff0d0..e632008 100644
> --- a/drivers/net/wireless/ath/ath6kl/debug.c
> +++ b/drivers/net/wireless/ath/ath6kl/debug.c
> @@ -1551,11 +1551,12 @@ static ssize_t ath6kl_listen_int_read(struct file *file,
>  						size_t count, loff_t *ppos)
>  {
>  	struct ath6kl *ar = file->private_data;
> -	char buf[16];
> +	char buf[32];
>  	int len;
>  
>  	len = snprintf(buf, sizeof(buf), "%u %u\n", ar->listen_intvl_t,
>  					ar->listen_intvl_b);
> +	len = min(sizeof(buf), len);

Maybe that should be scnprintf instead then?

johannes

