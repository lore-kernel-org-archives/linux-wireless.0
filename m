Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36936 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab0LGVAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 16:00:12 -0500
Date: Tue, 7 Dec 2010 15:57:51 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Javier Cardona <javier@cozybit.com>
Cc: Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH 3/3] ath5k: Put the right tsf value in mesh beacons
Message-ID: <20101207205751.GJ2700@tuxdriver.com>
References: <1291169919-3867-1-git-send-email-javier@cozybit.com>
 <1291169919-3867-4-git-send-email-javier@cozybit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1291169919-3867-4-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Missing Signed-off-by...

On Tue, Nov 30, 2010 at 06:18:39PM -0800, Javier Cardona wrote:
> ---
>  drivers/net/wireless/ath/ath5k/base.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index 44f3050..6b06754 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -1889,7 +1889,8 @@ ath5k_beacon_send(struct ath5k_softc *sc)
>  		sc->bmisscount = 0;
>  	}
>  
> -	if (sc->opmode == NL80211_IFTYPE_AP && sc->num_ap_vifs > 1) {
> +	if ((sc->opmode == NL80211_IFTYPE_AP && sc->num_ap_vifs > 1) ||
> +			sc->opmode == NL80211_IFTYPE_MESH_POINT) {
>  		u64 tsf = ath5k_hw_get_tsf64(ah);
>  		u32 tsftu = TSF_TO_TU(tsf);
>  		int slot = ((tsftu % sc->bintval) * ATH_BCBUF) / sc->bintval;
> -- 
> 1.7.1
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
