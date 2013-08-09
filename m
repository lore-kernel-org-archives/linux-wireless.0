Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58927 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967927Ab3HIPpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Aug 2013 11:45:13 -0400
Date: Fri, 9 Aug 2013 11:34:59 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch] Hostap: copying wrong data prism2_ioctl_giwaplist()
Message-ID: <20130809153459.GH30925@tuxdriver.com> (sfid-20130809_174521_615854_068069DE)
References: <20130809095231.GD29282@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130809095231.GD29282@elgon.mountain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here I must insert the obligatory question:

	Does anyone actually still use the hostap driver??

John

On Fri, Aug 09, 2013 at 12:52:31PM +0300, Dan Carpenter wrote:
> We want the data stored in "addr" and "qual", but the extra ampersands
> mean we are copying stack data instead.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Static checker stuff.  Untested.  Should probably be applied to -stable
> as well.
> 
> diff --git a/drivers/net/wireless/hostap/hostap_ioctl.c b/drivers/net/wireless/hostap/hostap_ioctl.c
> index ac07473..e509030 100644
> --- a/drivers/net/wireless/hostap/hostap_ioctl.c
> +++ b/drivers/net/wireless/hostap/hostap_ioctl.c
> @@ -523,9 +523,9 @@ static int prism2_ioctl_giwaplist(struct net_device *dev,
>  
>  	data->length = prism2_ap_get_sta_qual(local, addr, qual, IW_MAX_AP, 1);
>  
> -	memcpy(extra, &addr, sizeof(struct sockaddr) * data->length);
> +	memcpy(extra, addr, sizeof(struct sockaddr) * data->length);
>  	data->flags = 1; /* has quality information */
> -	memcpy(extra + sizeof(struct sockaddr) * data->length, &qual,
> +	memcpy(extra + sizeof(struct sockaddr) * data->length, qual,
>  	       sizeof(struct iw_quality) * data->length);
>  
>  	kfree(addr);
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
