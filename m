Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:58279 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbZBURCl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2009 12:02:41 -0500
Received: by nf-out-0910.google.com with SMTP id d21so195693nfb.21
        for <linux-wireless@vger.kernel.org>; Sat, 21 Feb 2009 09:02:39 -0800 (PST)
Message-ID: <49A033A8.4070006@gmail.com> (sfid-20090221_180252_221364_34EAB40D)
Date: Sat, 21 Feb 2009 17:02:32 +0000
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Subject: Re: [PATCH] orinoco: firmware: consistently compile out fw cache
 support if not requested
References: <20090215100902.7895.2670.stgit@cooker.net> <49984F0F.3090401@gmail.com> <200902211911.25718.arvidjaar@mail.ru>
In-Reply-To: <200902211911.25718.arvidjaar@mail.ru>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrey Borzenkov wrote:
> Currently part of support for FW caching is unconditionally compiled
> in even if it is never used. Consistently remove caching support if
> not requested by user.
> 
> Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
> --- a/drivers/net/wireless/orinoco/fw.h
> +++ b/drivers/net/wireless/orinoco/fw.h
> @@ -10,7 +10,12 @@ struct orinoco_private;
>  
> -void orinoco_cache_fw(struct orinoco_private *priv, int ap);
> -void orinoco_uncache_fw(struct orinoco_private *priv);
> +#if defined(CONFIG_HERMES_CACHE_FW_ON_INIT) || defined(CONFIG_PM_SLEEP)
> +extern void orinoco_cache_fw(struct orinoco_private *priv, int ap);
> +extern void orinoco_uncache_fw(struct orinoco_private *priv);

Please remove the explicit externs.

> --- a/drivers/net/wireless/orinoco/main.c
> +++ b/drivers/net/wireless/orinoco/main.c
> @@ -2580,8 +2580,10 @@ struct net_device
>  
> -	priv->cached_pri_fw = NULL;
> +#if defined(CONFIG_HERMES_CACHE_FW_ON_INIT) || defined(CONFIG_PM_SLEEP)
>  	priv->cached_fw = NULL;
> +	priv->cached_pri_fw = NULL;
> +#endif

Please leave the orderring alone.

These just minimize the changes and reduce potential for conflicts
during rebases/merges.

Acked-by: David Kilroy <kilroyd@googlemail.com>
