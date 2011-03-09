Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:57529 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117Ab1CIC40 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2011 21:56:26 -0500
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 08 Mar 2011 18:56:03 -0800
Date: Wed, 9 Mar 2011 08:26:45 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Kyungwan Nam <Kyungwan.Nam@Atheros.com>
Subject: Re: [PATCH 2.6.38] ath9k: remove support for the FIF_PROMISC_IN_BSS
 filter flag
Message-ID: <20110309025645.GA4975@vmraj-lnx.users.atheros.com>
References: <1299631692-69094-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1299631692-69094-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 09, 2011 at 06:18:12AM +0530, Felix Fietkau wrote:
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
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Cc: stable@kernel.org
> ---
>  drivers/net/wireless/ath/ath9k/recv.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
> index cb559e3..a9c3f46 100644
> --- a/drivers/net/wireless/ath/ath9k/recv.c
> +++ b/drivers/net/wireless/ath/ath9k/recv.c
> @@ -413,9 +413,7 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
>  	 * mode interface or when in monitor mode. AP mode does not need this
>  	 * since it receives all in-BSS frames anyway.
>  	 */
> -	if (((sc->sc_ah->opmode != NL80211_IFTYPE_AP) &&
> -	     (sc->rx.rxfilter & FIF_PROMISC_IN_BSS)) ||
> -	    (sc->sc_ah->is_monitoring))
> +	if (sc->sc_ah->is_monitoring)
>  		rfilt |= ATH9K_RX_FILTER_PROM;

Assume there are 2 vifs (STA + MON) and both running. Doing a scan on STA vif, dumps dma messages.

--
Rajkumar
