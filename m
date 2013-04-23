Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:63545 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755538Ab3DWOZt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Apr 2013 10:25:49 -0400
Message-ID: <1366727135.7932.133.camel@smile> (sfid-20130423_163407_717193_D501A18F)
Subject: Re: [PATCH] wireless: ath6kl: re-use native helper to parse MAC
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Tue, 23 Apr 2013 17:25:35 +0300
In-Reply-To: <1366723941-23920-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1366723941-23920-1-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-04-23 at 16:32 +0300, Andy Shevchenko wrote: 
> There is native mac_pton() function which helps to parse MAC.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/net/wireless/ath/ath6kl/debug.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
> index fe38b83..9824cb0 100644
> --- a/drivers/net/wireless/ath/ath6kl/debug.c
> +++ b/drivers/net/wireless/ath/ath6kl/debug.c
> @@ -1241,19 +1241,14 @@ static ssize_t ath6kl_force_roam_write(struct file *file,
>  	size_t len;
>  	u8 bssid[ETH_ALEN];
>  	int i;

It seems i shall be removed as well.

> -	int addr[ETH_ALEN];
>  
>  	len = min(count, sizeof(buf) - 1);
>  	if (copy_from_user(buf, user_buf, len))
>  		return -EFAULT;
>  	buf[len] = '\0';
>  
> -	if (sscanf(buf, "%02x:%02x:%02x:%02x:%02x:%02x",
> -		   &addr[0], &addr[1], &addr[2], &addr[3], &addr[4], &addr[5])
> -	    != ETH_ALEN)
> +	if (!mac_pton(buf, bssid))
>  		return -EINVAL;
> -	for (i = 0; i < ETH_ALEN; i++)
> -		bssid[i] = addr[i];
>  
>  	ret = ath6kl_wmi_force_roam_cmd(ar->wmi, bssid);
>  	if (ret)

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
