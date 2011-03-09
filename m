Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55003 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855Ab1CIBH1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2011 20:07:27 -0500
Message-ID: <4D76D2C3.2000909@candelatech.com>
Date: Tue, 08 Mar 2011 17:07:15 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com, Kyungwan.Nam@atheros.com
Subject: Re: [PATCH 2.6.38] ath9k: remove support for the FIF_PROMISC_IN_BSS
 filter flag
References: <1299631692-69094-1-git-send-email-nbd@openwrt.org>
In-Reply-To: <1299631692-69094-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/08/2011 04:48 PM, Felix Fietkau wrote:
> The hardware rx filter flag triggered by FIF_PROMISC_IN_BSS is overly broad
> and covers even frames with PHY errors. When this flag is enabled, this message
> shows up frequently during scanning or hardware resets:
>
> ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
>
> Since promiscuous mode is usually not particularly useful, yet enabled by
> default by bridging (either used normally in 4-addr mode, or with hacks
> for various virtualization software), we should sacrifice it for better
> reliability during normal operation.
>
> This patch leaves it enabled if there are active monitor mode interfaces, since
> it's very useful for debugging.
>
> Signed-off-by: Felix Fietkau<nbd@openwrt.org>
> Cc: stable@kernel.org
> ---
>   drivers/net/wireless/ath/ath9k/recv.c |    4 +---
>   1 files changed, 1 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
> index cb559e3..a9c3f46 100644
> --- a/drivers/net/wireless/ath/ath9k/recv.c
> +++ b/drivers/net/wireless/ath/ath9k/recv.c
> @@ -413,9 +413,7 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
>   	 * mode interface or when in monitor mode. AP mode does not need this
>   	 * since it receives all in-BSS frames anyway.
>   	 */
> -	if (((sc->sc_ah->opmode != NL80211_IFTYPE_AP)&&
> -	     (sc->rx.rxfilter&  FIF_PROMISC_IN_BSS)) ||
> -	    (sc->sc_ah->is_monitoring))
> +	if (sc->sc_ah->is_monitoring)
>   		rfilt |= ATH9K_RX_FILTER_PROM;
>
>   	if (sc->rx.rxfilter&  FIF_CONTROL)

Should we enable this flag if we have multiple STA
interfaces?  I had to add something to ath5k recently
to put it into promisc to properly handle multiple STAs
associated with different APs, for instance.

Do you have any idea *why* enabling this flag causes the DMA error
messages?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

