Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756368Ab0BJSqp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Feb 2010 13:46:45 -0500
Subject: Re: [PATCH] Add Station and AdHoc mode support to libertas_tf
From: Dan Williams <dcbw@redhat.com>
To: dsaxena@plexity.net
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <20100209213543.GA31890@plexity.net>
References: <20100209213543.GA31890@plexity.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Feb 2010 10:46:36 -0800
Message-ID: <1265827596.19692.36.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-02-09 at 13:35 -0800, Deepak Saxena wrote:
> Add support for using the libertas_tf driver on a managed 
> or ad-hoc network.

Most of the libertas-tf stuff should probably get sent to
linux-wireless@ since there's a ton more people on that list that know
about mac80211/cfg80211 specifics there, which I'm honestly not as good
with.

Dan

> Signed-off-by: Deepak Saxena <dsaxena@laptop.org>
> 
> ---
> Ran basic network tests on an OLPC XO-1 laptop. Suspend/resume causes a 
> crash but w/o this patch, the driver does not present a configureable 
> interface.  (wmaster0 appears but is listed as having no "wireless 
> extensions". Fixing this is on my queue).
> 
> diff --git a/drivers/net/wireless/libertas_tf/main.c b/drivers/net/wireless/libertas_tf/main.c
> index 26a1abd..9123d86 100644
> --- a/drivers/net/wireless/libertas_tf/main.c
> +++ b/drivers/net/wireless/libertas_tf/main.c
> @@ -555,6 +555,9 @@ struct lbtf_private *lbtf_add_card(void *card, struct device *dmdev)
>  	priv->band.n_channels = ARRAY_SIZE(lbtf_channels);
>  	priv->band.channels = priv->channels;
>  	hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->band;
> +        hw->wiphy->interface_modes =
> +                BIT(NL80211_IFTYPE_STATION) |
> +                BIT(NL80211_IFTYPE_ADHOC);
>  	skb_queue_head_init(&priv->bc_ps_buf);
>  
>  	SET_IEEE80211_DEV(hw, dmdev);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


