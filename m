Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36935 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765Ab0LGVAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 16:00:12 -0500
Date: Tue, 7 Dec 2010 15:58:30 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Javier Cardona <javier@cozybit.com>
Cc: Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH 2/3] ath5k: Prevent mesh interfaces from being counted as
 ad-hoc
Message-ID: <20101207205829.GL2700@tuxdriver.com>
References: <1291169919-3867-1-git-send-email-javier@cozybit.com>
 <1291169919-3867-3-git-send-email-javier@cozybit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1291169919-3867-3-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Missing Signed-off-by...

On Tue, Nov 30, 2010 at 06:18:38PM -0800, Javier Cardona wrote:
> This results in an erroneus num_adhoc_vifs count, as the this counter
> was incremented but not decremented for mesh interfaces.
> ---
>  drivers/net/wireless/ath/ath5k/base.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index 73c7118..44f3050 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -2847,7 +2847,7 @@ static int ath5k_add_interface(struct ieee80211_hw *hw,
>  		sc->bslot[avf->bslot] = vif;
>  		if (avf->opmode == NL80211_IFTYPE_AP)
>  			sc->num_ap_vifs++;
> -		else
> +		else if (avf->opmode == NL80211_IFTYPE_ADHOC)
>  			sc->num_adhoc_vifs++;
>  	}
>  
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
