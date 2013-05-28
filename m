Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:55167 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933612Ab3E1Iri convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 May 2013 04:47:38 -0400
Message-ID: <1369730853.29283.222.camel@smile> (sfid-20130528_104741_671094_1DEA05FA)
Subject: Re: [PATCH v2] wireless: ath6kl: re-use native helper to parse MAC
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>
Date: Tue, 28 May 2013 11:47:33 +0300
In-Reply-To: <1366896682-2023-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1366896682-2023-1-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-04-25 at 16:31 +0300, Andy Shevchenko wrote: 
> There is native mac_pton() function which helps to parse MAC.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/net/wireless/ath/ath6kl/debug.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
> index fe38b83..dbfd17d 100644
> --- a/drivers/net/wireless/ath/ath6kl/debug.c
> +++ b/drivers/net/wireless/ath/ath6kl/debug.c
> @@ -1240,20 +1240,14 @@ static ssize_t ath6kl_force_roam_write(struct file *file,
>  	char buf[20];
>  	size_t len;
>  	u8 bssid[ETH_ALEN];
> -	int i;
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

John, do you have any comment on this one?

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
