Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52166 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab0FKKmC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jun 2010 06:42:02 -0400
Subject: Re: [PATCH] ath5k: disable all tasklets while resetting
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <20100611101221.26538.46913.stgit@tt-desk>
References: <20100611101221.26538.46913.stgit@tt-desk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Jun 2010 12:41:53 +0200
Message-ID: <1276252913.3640.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-06-11 at 19:12 +0900, Bruno Randolf wrote:
> Make sure no tasklets can run concurrently to a reset.
> 
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> ---
>  drivers/net/wireless/ath/ath5k/base.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index 9d37c1a..585c517 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -2908,6 +2908,12 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan)
>  
>  	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "resetting\n");
>  
> +	tasklet_disable(&sc->rxtq);		/* ath5k_tasklet_rx */
> +	tasklet_disable(&sc->txtq);		/* ath5k_tasklet_tx */
> +	tasklet_disable(&sc->calib);		/* ath5k_tasklet_calibrate */
> +	tasklet_disable(&sc->beacontq);		/* ath5k_tasklet_beacon */
> +	tasklet_disable(&sc->ani_tasklet);	/* ath5k_tasklet_ani */

I have no idea how long a reset can take, but this means that all these
tasklets will spin while your reset is running if they were scheduled.

johannes

