Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49923 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538Ab3BVUPP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 15:15:15 -0500
Date: Fri, 22 Feb 2013 15:01:38 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, c_manoha@qca.qualcomm.com
Subject: Re: [PATCH 3.9] ath9k_htc: fix signal strength handling issues
Message-ID: <20130222200138.GB23235@tuxdriver.com> (sfid-20130222_211520_786260_3BC7ACBA)
References: <1361548432-83349-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1361548432-83349-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CC      drivers/net/wireless/ath/ath9k/htc_drv_txrx.o
drivers/net/wireless/ath/ath9k/htc_drv_txrx.c: In function ‘ath9k_rx_prepare’:
drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:1071:6: error: implicit declaration of function ‘is_zero_ether_addr’ [-Werror=implicit-function-declaration]
drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:1072:6: error: implicit declaration of function ‘ether_addr_equal’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

On Fri, Feb 22, 2013 at 04:53:52PM +0100, Felix Fietkau wrote:
> The ath9k commit 2ef167557c0a26c88162ecffb017bfcc51eb7b29
> (ath9k: fix signal strength reporting issues) fixed an issue where the
> reported per-frame signal strength reported to mac80211 was being
> overwritten with an internal average. The same issue is also present
> in ath9k_htc.
> In addition to preventing the driver from overwriting the value, this
> commit also ensures that the internal average (which is used for ANI)
> only tracks beacons of the AP that we're connected to.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Cc: stable@vger.kernel.org
> ---
>  drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
> index b6a5a08..8788621 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
> @@ -1067,15 +1067,19 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
>  
>  	last_rssi = priv->rx.last_rssi;
>  
> -	if (likely(last_rssi != ATH_RSSI_DUMMY_MARKER))
> -		rxbuf->rxstatus.rs_rssi = ATH_EP_RND(last_rssi,
> -						     ATH_RSSI_EP_MULTIPLIER);
> +	if (ieee80211_is_beacon(hdr->frame_control) &&
> +	    !is_zero_ether_addr(common->curbssid) &&
> +	    ether_addr_equal(hdr->addr3, common->curbssid)) {
> +		s8 rssi = rxbuf->rxstatus.rs_rssi;
>  
> -	if (rxbuf->rxstatus.rs_rssi < 0)
> -		rxbuf->rxstatus.rs_rssi = 0;
> +		if (likely(last_rssi != ATH_RSSI_DUMMY_MARKER))
> +			rssi = ATH_EP_RND(last_rssi, ATH_RSSI_EP_MULTIPLIER);
>  
> -	if (ieee80211_is_beacon(fc))
> -		priv->ah->stats.avgbrssi = rxbuf->rxstatus.rs_rssi;
> +		if (rssi < 0)
> +			rssi = 0;
> +
> +		priv->ah->stats.avgbrssi = rssi;
> +	}
>  
>  	rx_status->mactime = be64_to_cpu(rxbuf->rxstatus.rs_tstamp);
>  	rx_status->band = hw->conf.channel->band;
> -- 
> 1.8.0.2
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
