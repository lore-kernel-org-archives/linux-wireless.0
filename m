Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41384 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755131Ab1KCPLy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 11:11:54 -0400
Message-ID: <4EB2AF36.9070608@openwrt.org> (sfid-20111103_161157_544150_B3821F63)
Date: Thu, 03 Nov 2011 16:11:50 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com
Subject: Re: [RFC v2 2/2] ath9k: integrate initial DFS module
References: <1320328553-28066-1-git-send-email-zefir.kurtisi@neratec.com> <1320328553-28066-3-git-send-email-zefir.kurtisi@neratec.com>
In-Reply-To: <1320328553-28066-3-git-send-email-zefir.kurtisi@neratec.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-11-03 2:55 PM, Zefir Kurtisi wrote:
> This patch integrates the DFS module into ath9k, including
>   * building the module into ath9k_hw
>   * setting up DFS debugfs
>   * defining HW capability flag for DFS support
>   * setting this flag by DFS supporting devices
>     (so far: AR_SREV_9280_20_OR_LATER, TBC)
>   * setting PHYRADAR rx filter flag to enable radar
>     pulse reporting
>   * forward radar PHY errors to dfs module
>
> This is WIP and at its current stage is limited to test ath9k
> pulse detection capabilities. The DFS pattern matching is
> TBD in the higher layers and is not part of this patch.
>
> CONFIG_ATH9K_DFS must be set to enable pulse detection.
>
> Signed-off-by: Zefir Kurtisi<zefir.kurtisi@neratec.com>
> ---
>   drivers/net/wireless/ath/ath9k/Makefile |    2 ++
>   drivers/net/wireless/ath/ath9k/debug.c  |    3 +++
>   drivers/net/wireless/ath/ath9k/debug.h  |    2 ++
>   drivers/net/wireless/ath/ath9k/hw.c     |   12 ++++++++++++
>   drivers/net/wireless/ath/ath9k/hw.h     |    1 +
>   drivers/net/wireless/ath/ath9k/main.c   |   17 +++++++++++++++++
>   drivers/net/wireless/ath/ath9k/recv.c   |   18 +++++++++++++-----
>   7 files changed, 50 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index d3b92ce..4d70aab 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -305,6 +305,23 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
>   		ath9k_hw_antdiv_comb_conf_set(ah,&div_ant_conf);
>   	}
>
> +	if (ah->caps.hw_caps&&  ATH9K_HW_CAP_DFS) {
> +		/**
> +		 * enable radar pulse detection
> +		 *
> +		 * TODO: do this only for DFS channels
> +		 */
> +		ah->private_ops.set_radar_params(ah,&ah->radar_conf);
> +		ath9k_hw_setrxfilter(ah,
> +			ath9k_hw_getrxfilter(ah) | ATH9K_RX_FILTER_PHYRADAR);
> +		ath_dbg(common, ATH_DBG_DFS,
> +			"DFS radar detection enabled for channel %d\n",
> +			ah->curchan->channel);
> +	} else {
> +		ath9k_hw_setrxfilter(ah,
> +			ath9k_hw_getrxfilter(ah)&  ~ATH9K_RX_FILTER_PHYRADAR);
> +	}
> +
Please drop this chunk of code and move the check to ath_calcrxfilter, 
which gets called after every reset anyway. Also, use a separate flag in 
sc->flags for actually enabling DFS. Even if the chip has DFS support, 
we don't always want to enable it - especially not on 2.4 GHz or indoor 
5 GHz channels.

- Felix

