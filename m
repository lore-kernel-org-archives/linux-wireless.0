Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:4500 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457AbYGaBLt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 21:11:49 -0400
Subject: Re: [PATCH 06/16] ath9k: Fix missing brace in branch on
	ath_chainmask_sel_logic()
From: Pavel Roskin <proski@gnu.org>
To: lrodriguez@atheros.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, Jouni.Malinen@Atheros.com,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
In-Reply-To: <40a067eab54b9b366002257d5be8e4577b067408.1217309551.git.lrodriguez@atheros.com>
References: <4800d552efce6350888c68b859f66767196d720b.1217309551.git.lrodriguez@atheros.com>
	 <40a067eab54b9b366002257d5be8e4577b067408.1217309551.git.lrodriguez@atheros.com>
Content-Type: text/plain
Date: Wed, 30 Jul 2008 21:11:47 -0400
Message-Id: <1217466707.3616.5.camel@dv> (sfid-20080731_031153_196233_887B4C20)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-07-28 at 22:47 -0700, lrodriguez@atheros.com wrote:
> From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> 
> diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
> index 47d4891..d9c7561 100644
> --- a/drivers/net/wireless/ath9k/core.c
> +++ b/drivers/net/wireless/ath9k/core.c
> @@ -508,9 +508,10 @@ int ath_chainmask_sel_logic(struct ath_softc *sc, struct ath_node *an)
>  	 * enabled/disabled setting
>  	 */
>  	if ((sc->sc_no_tx_3_chains == AH_FALSE) ||
> -	    (sc->sc_config.chainmask_sel == AH_FALSE))
> +	    (sc->sc_config.chainmask_sel == AH_FALSE)) {
>  		cm->cur_tx_mask = sc->sc_tx_chainmask;
>  		return cm->cur_tx_mask;
> +	}

I would prefer that all compile fixes are amended in the patches that
introduced them.  We should try to pass only correct patches upstream.
Bisection works best if one doesn't hit code that doesn't compile.

-- 
Regards,
Pavel Roskin
