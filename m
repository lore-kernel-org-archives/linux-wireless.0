Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759963AbYDCDfS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 23:35:18 -0400
Subject: Re: [PATCH] libertas: move lbs_update_channel out of assoc.c
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200804021652.19572.hs4233@mail.mn-solutions.de>
References: <200804021652.19572.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 23:33:28 -0400
Message-Id: <1207193608.9435.8.camel@localhost.localdomain> (sfid-20080403_043522_280081_B699BEF8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-04-02 at 16:52 +0200, Holger Schurig wrote:
> ... as it has nothing to do with pure association
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> Index: wireless-testing/drivers/net/wireless/libertas/assoc.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/assoc.c	2008-04-02 14:49:22.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/libertas/assoc.c	2008-04-02 14:50:25.000000000 +0200
> @@ -583,23 +583,6 @@ done:
>  	return ret;
>  }
>  
> -
> -int lbs_update_channel(struct lbs_private *priv)
> -{
> -	int ret;
> -
> -	/* the channel in f/w could be out of sync; get the current channel */
> -	lbs_deb_enter(LBS_DEB_ASSOC);
> -
> -	ret = lbs_get_channel(priv);
> -	if (ret > 0) {
> -		priv->curbssparams.channel = ret;
> -		ret = 0;
> -	}
> -	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
> -	return ret;
> -}
> -
>  static int assoc_helper_channel(struct lbs_private *priv,
>                                  struct assoc_request * assoc_req)
>  {
> Index: wireless-testing/drivers/net/wireless/libertas/cmd.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/cmd.c	2008-04-02 14:50:03.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/libertas/cmd.c	2008-04-02 14:50:22.000000000 +0200
> @@ -826,6 +826,22 @@ out:
>  	return ret;
>  }
>  
> +int lbs_update_channel(struct lbs_private *priv)
> +{
> +	int ret;
> +
> +	/* the channel in f/w could be out of sync; get the current channel */
> +	lbs_deb_enter(LBS_DEB_ASSOC);
> +
> +	ret = lbs_get_channel(priv);
> +	if (ret > 0) {
> +		priv->curbssparams.channel = ret;
> +		ret = 0;
> +	}
> +	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
> +	return ret;
> +}
> +
>  /**
>   *  @brief Set the radio channel
>   *

