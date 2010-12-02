Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757295Ab0LBQjG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 11:39:06 -0500
Subject: Re: [PATCH 1/2] libertas: fix memory corruption in lbs_remove_card()
From: Dan Williams <dcbw@redhat.com>
To: Daniel Drake <dsd@laptop.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	hs4233@mail.mn-solutions.de, libertas-dev@lists.infradead.org
Date: Thu, 02 Dec 2010 10:38:18 -0600
In-Reply-To: <20101124160049.8058D9D401B@zog.reactivated.net>
References: <20101124160049.8058D9D401B@zog.reactivated.net>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1291307900.3156.7.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-11-24 at 16:00 +0000, Daniel Drake wrote:
> "priv" is stored at the end of the wiphy structure, which is freed
> during the call to lbs_cfg_free(). It must not be touched afterwards.
> 
> Remove the unnecessary NULL assignment causing this memory corruption.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/main.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> Please apply for 2.6.37
> 
> diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
> index 46b88b1..fcd1bbf 100644
> --- a/drivers/net/wireless/libertas/main.c
> +++ b/drivers/net/wireless/libertas/main.c
> @@ -915,8 +915,6 @@ void lbs_remove_card(struct lbs_private *priv)
>  
>  	lbs_free_adapter(priv);
>  	lbs_cfg_free(priv);
> -
> -	priv->dev = NULL;
>  	free_netdev(dev);
>  
>  	lbs_deb_leave(LBS_DEB_MAIN);


