Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54784 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699Ab2KJJQA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Nov 2012 04:16:00 -0500
Message-ID: <509E1B47.3050107@openwrt.org> (sfid-20121110_101605_505708_4DA129B8)
Date: Sat, 10 Nov 2012 10:15:51 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Bernhard Urban <lewurm@gmail.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	c_manoha@qca.qualcomm.com, Sujith.Manoharan@atheros.com,
	linville@tuxdriver.com, markus@indoo.rs
Subject: Re: [PATCH] ath9k_htc: update RSSI values only when the device is
 associated
References: <1352480966-17462-1-git-send-email-lewurm@gmail.com>
In-Reply-To: <1352480966-17462-1-git-send-email-lewurm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-11-09 6:09 PM, Bernhard Urban wrote:
> add an if-guard, otherwise iw(8) reports weird signal strengths.
> 
> The behaviour was fine before this commit:
> 7c277349ecbd66e19fad3d949fa6ef6c131a3b62
> This patch is therefore a partially revert of it.
> 
> Tested with "TP-Link TL-WN722N"
> 
> Thanks to indoo.rs http://indoo.rs/ for sponsoring
> 
> Reported-by: Markus Krainz <markus@indoo.rs>
> Tested-by: Markus Krainz <markus@indoo.rs>
> Signed-off-by: Bernhard Urban <lewurm@gmail.com>
> ---
>  drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |   27 ++++++++++++++-----------
>  1 file changed, 15 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
> index 47e61d0..d0d329c 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
> @@ -1060,22 +1060,25 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
>  	ath9k_process_rate(hw, rx_status, rxbuf->rxstatus.rs_rate,
>  			   rxbuf->rxstatus.rs_flags);
>  
> -	if (rxbuf->rxstatus.rs_rssi != ATH9K_RSSI_BAD &&
> -	    !rxbuf->rxstatus.rs_moreaggr)
> -		ATH_RSSI_LPF(priv->rx.last_rssi,
> -			     rxbuf->rxstatus.rs_rssi);
> +	if (priv->num_sta_assoc_vif != 0) {
> +		if (rxbuf->rxstatus.rs_rssi != ATH9K_RSSI_BAD &&
> +		    !rxbuf->rxstatus.rs_moreaggr)
> +			ATH_RSSI_LPF(priv->rx.last_rssi,
> +				     rxbuf->rxstatus.rs_rssi);
>  
> -	last_rssi = priv->rx.last_rssi;
> +		last_rssi = priv->rx.last_rssi;
>  
> -	if (likely(last_rssi != ATH_RSSI_DUMMY_MARKER))
> -		rxbuf->rxstatus.rs_rssi = ATH_EP_RND(last_rssi,
> -						     ATH_RSSI_EP_MULTIPLIER);
> +		if (likely(last_rssi != ATH_RSSI_DUMMY_MARKER)) {
> +			s8 rssi = ATH_EP_RND(last_rssi, ATH_RSSI_EP_MULTIPLIER);
> +			rxbuf->rxstatus.rs_rssi = rssi;
> +		}
>  
> -	if (rxbuf->rxstatus.rs_rssi < 0)
> -		rxbuf->rxstatus.rs_rssi = 0;
> +		if (rxbuf->rxstatus.rs_rssi < 0)
> +			rxbuf->rxstatus.rs_rssi = 0;
>  
> -	if (ieee80211_is_beacon(fc))
> -		priv->ah->stats.avgbrssi = rxbuf->rxstatus.rs_rssi;
> +		if (ieee80211_is_beacon(fc))
> +			priv->ah->stats.avgbrssi = rxbuf->rxstatus.rs_rssi;
> +	}
>  
>  	rx_status->mactime = be64_to_cpu(rxbuf->rxstatus.rs_tstamp);
>  	rx_status->band = hw->conf.channel->band;
> 
Please check how RSSI is handled in ath9k, and use that as reference.
The per-packet RSSI should not be set from some internal average, it
should contain the real RSSI value of the packet. This change disables
RSSI reporting for anything but station mode, which is not a good idea.

- Felix
