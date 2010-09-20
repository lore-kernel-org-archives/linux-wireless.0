Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:60282 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755954Ab0ITMnD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Sep 2010 08:43:03 -0400
Message-ID: <4C9756CE.1060908@openwrt.org>
Date: Mon, 20 Sep 2010 14:42:54 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanoharan@atheros.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k_htc: Fix beacon distribution in IBSS mode
References: <1284985872-31021-1-git-send-email-rmanoharan@atheros.com>
In-Reply-To: <1284985872-31021-1-git-send-email-rmanoharan@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-09-20 2:31 PM, Rajkumar Manoharan wrote:
> This patch ensures fair beacon distribution in IBSS mode
> by configuring proper CWmin based on slot time.
> 
> Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |    9 +++++-
>  drivers/net/wireless/ath/ath9k/hw.c             |   32 +++++++++++++++++++++++
>  drivers/net/wireless/ath/ath9k/hw.h             |    1 +
>  3 files changed, 41 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
> index bd1506e..3e699a5 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
> @@ -235,7 +235,14 @@ void ath9k_htc_beaconq_config(struct ath9k_htc_priv *priv)
>  	ath9k_hw_get_txq_props(ah, qnum, &qi_be);
>  
>  	qi.tqi_aifs = qi_be.tqi_aifs;
> -	qi.tqi_cwmin = 4*qi_be.tqi_cwmin;
> +	/* For WIFI Beacon Distribution
> +	 * Long slot time  : 2x cwmin
> +	 * Short slot time : 4x cwmin
> +	 */
> +	if (ath9k_hw_getslottime(ah) == ATH9K_SLOT_TIME_20)
I'd recommend using ah->slottime here and dropping all of those ath9k_hw
changes.

- Felix
