Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38989 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbbJYTMy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 15:12:54 -0400
Date: Mon, 26 Oct 2015 04:12:49 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Punit Vara <punitvara@gmail.com>
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] staging: wilc1000: Remove reference preceded by free
Message-ID: <20151025191249.GB23928@kroah.com> (sfid-20151025_201335_775087_F67F8FC8)
References: <1445725885-25995-1-git-send-email-punitvara@gmail.com>
 <1445725885-25995-2-git-send-email-punitvara@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1445725885-25995-2-git-send-email-punitvara@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 25, 2015 at 04:01:23AM +0530, Punit Vara wrote:
> This patch is to the wilc_wfi_cfgoperations.c file that fixes up
> following error reported by coccicheck:
> 
> ERROR: reference preceded by free on line 1219
> 
> For (params->seq_len) <= 0 memory is already freed when
> (params->seq_len) >0 then memory was alloted. So there is no need to use
> kfree whenever params->seq_len <=0 remove it and place kfree inside
> (params->seq_len) >0 condition.
> 
> Signed-off-by: Punit Vara <punitvara@gmail.com>
> ---
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> index bcbf1bd..9b3cf04 100644
> --- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> +++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> @@ -1216,11 +1216,10 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
>  
>  				priv->wilc_ptk[key_index]->key = kmalloc(params->key_len, GFP_KERNEL);
>  
> -				kfree(priv->wilc_ptk[key_index]->seq);
> -
> -				if ((params->seq_len) > 0)
> +				if ((params->seq_len) > 0) {
> +					kfree(priv->wilc_ptk[key_index]->seq);
>  					priv->wilc_ptk[key_index]->seq = kmalloc(params->seq_len, GFP_KERNEL);
> -
> +				}

Are you sure about this?  It seems like you are changing the logic
here...

