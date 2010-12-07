Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36937 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079Ab0LGVAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 16:00:12 -0500
Date: Tue, 7 Dec 2010 15:58:12 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Javier Cardona <javier@cozybit.com>
Cc: Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH 1/3] ath5k: Fix beaconing in mesh mode
Message-ID: <20101207205812.GK2700@tuxdriver.com>
References: <1291169919-3867-1-git-send-email-javier@cozybit.com>
 <1291169919-3867-2-git-send-email-javier@cozybit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1291169919-3867-2-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Missing Signed-off-by...

On Tue, Nov 30, 2010 at 06:18:37PM -0800, Javier Cardona wrote:
> This patch fixes the oops below when attempting to bring up a mesh
> interface on ath5k hardware.
> 
> [  128.933099] kernel BUG at drivers/net/wireless/ath/ath5k/base.c:197!
> [  128.933099] invalid opcode: 0000 [#1]
> (...)
> [  128.933099] Call Trace:
> [  128.933099]  [<c83b77fa>] ? ath5k_beacon_update+0x57/0x1f8 [ath5k]
> [  128.933099]  [<c02d9a40>] ? __sysfs_add_one+0x28/0x76
> [  128.933099]  [<c83b830e>] ? ath5k_bss_info_changed+0x13f/0x173
> [ath5k]
> [  128.933099]  [<c82ff629>] ? ieee80211_config_beacon+0xc0/0x17e
> [mac80211]
> [  128.933099]  [<c82f073e>] ?
> ieee80211_bss_info_change_notify+0x182/0x18b [mac80211]
> [  128.933099]  [<c83b81cf>] ? ath5k_bss_info_changed+0x0/0x173 [ath5k]
> [  128.933099]  [<c82ff6d6>] ? ieee80211_config_beacon+0x16d/0x17e
> [mac80211]
> [  128.933099]  [<c82ff753>] ? ieee80211_add_beacon+0x34/0x39 [mac80211]
> [  128.933099]  [<c830a4ed>] ? ieee80211s_init+0xf8/0x10f [mac80211]
> [  128.933099]  [<c830a5df>] ? ieee80211_mesh_init_sdata+0xdb/0x154 [mac80211]
> ---
>  drivers/net/wireless/ath/ath5k/base.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index a8d380a..73c7118 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -1921,8 +1921,9 @@ ath5k_beacon_send(struct ath5k_softc *sc)
>  		/* NB: hw still stops DMA, so proceed */
>  	}
>  
> -	/* refresh the beacon for AP mode */
> -	if (sc->opmode == NL80211_IFTYPE_AP)
> +	/* refresh the beacon for AP or MESH mode */
> +	if (sc->opmode == NL80211_IFTYPE_AP ||
> +			sc->opmode == NL80211_IFTYPE_MESH_POINT)
>  		ath5k_beacon_update(sc->hw, vif);
>  
>  	ath5k_hw_set_txdp(ah, sc->bhalq, bf->daddr);
> @@ -2826,7 +2827,8 @@ static int ath5k_add_interface(struct ieee80211_hw *hw,
>  
>  	/* Assign the vap/adhoc to a beacon xmit slot. */
>  	if ((avf->opmode == NL80211_IFTYPE_AP) ||
> -	    (avf->opmode == NL80211_IFTYPE_ADHOC)) {
> +	    (avf->opmode == NL80211_IFTYPE_ADHOC) ||
> +	    (avf->opmode == NL80211_IFTYPE_MESH_POINT)) {
>  		int slot;
>  
>  		WARN_ON(list_empty(&sc->bcbuf));
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
