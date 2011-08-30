Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15399 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab1H3GZv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 02:25:51 -0400
Date: Tue, 30 Aug 2011 11:56:20 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH v7 2/4] ath9k: always call ath_reset from workqueue
 context
Message-ID: <20110830062619.GA2097@vmraj-lnx.users.atheros.com> (sfid-20110830_082554_366200_BE20AA0A)
References: <1314643245-59142-1-git-send-email-nbd@openwrt.org>
 <1314643245-59142-2-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1314643245-59142-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 29, 2011 at 08:40:43PM +0200, Felix Fietkau wrote:
> This makes it much easier to add further rework to avoid race conditions
> between reset and other work items.
> Move other functions to make ath_reset static.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> +	INIT_WORK(&sc->hw_reset_work, ath_reset_work);
>  	INIT_WORK(&sc->hw_check_work, ath_hw_check);
>  	INIT_WORK(&sc->paprd_work, ath_paprd_calibrate);
>  	INIT_DELAYED_WORK(&sc->hw_pll_work, ath_hw_pll_work);

work never be cancelled at ath9k_stop.
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index 085ec20..76fcd4f 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -595,74 +595,6 @@ static void ath_node_detach(struct ath_softc *sc, struct ieee80211_sta *sta)
>  		ath_tx_node_cleanup(sc, an);
>  }
>  

> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index 49b93c2..f60706b 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -582,7 +582,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
>  	rcu_read_unlock();
>  
>  	if (needreset)
> -		ath_reset(sc, false);
> +		ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
>  }
Once you decide to do reset, do not continue with tx process.
>  
>  static bool ath_lookup_legacy(struct ath_buf *bf)
> @@ -2234,9 +2234,7 @@ static void ath_tx_complete_poll_work(struct work_struct *work)
>  	if (needreset) {
>  		ath_dbg(ath9k_hw_common(sc->sc_ah), ATH_DBG_RESET,
>  			"tx hung, resetting the chip\n");
> -		spin_lock_bh(&sc->sc_pcu_lock);
> -		ath_reset(sc, true);
> -		spin_unlock_bh(&sc->sc_pcu_lock);
> +		ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
>  	}
This is already in work thread. why don't you use ath_reset here like
ath_hw_pll_rx_hang_check.

--
Rajkumar
