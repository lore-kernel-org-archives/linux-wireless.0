Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hupie.dyndns.org ([80.101.237.101]:59918 "EHLO hupie.dyndns.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752316AbcKUJHr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Nov 2016 04:07:47 -0500
Subject: Re: [ath9k-devel] [RFC v2 2/2] ath9k: Reset chip on potential deaf
 state
To: Sven Eckelmann <sven.eckelmann@open-mesh.com>,
        ath9k-devel@lists.ath9k.org
References: <20161117083614.19188-1-sven.eckelmann@open-mesh.com>
 <20161117083614.19188-2-sven.eckelmann@open-mesh.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        Simon Wunderlich <simon.wunderlich@open-mesh.com>
From: Ferry Huberts <mailings@hupie.com>
Message-ID: <d23407cb-a1c0-860a-3436-5e72402a080b@hupie.com> (sfid-20161121_100751_387744_A768E836)
Date: Mon, 21 Nov 2016 10:07:43 +0100
MIME-Version: 1.0
In-Reply-To: <20161117083614.19188-2-sven.eckelmann@open-mesh.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 17/11/16 09:36, Sven Eckelmann wrote:
> From: Simon Wunderlich <simon.wunderlich@open-mesh.com>
>
> The chip is switching seemingly random into a state which can be described
> as "deaf". No or nearly no interrupts are generated anymore for incoming
> packets. Existing links either break down after a while and new links will
> not be established.
>
> The driver doesn't know if there is no other device available or if it
> ended up in an "deaf" state. Resetting the chip proactively avoids
> permanent problems in case the chip really was in its "deaf" state but
> maybe causes unnecessary resets in case it wasn't "deaf".
>
> Signed-off-by: Simon Wunderlich <simon.wunderlich@open-mesh.com>
> [sven.eckelmann@open-mesh.com: port to recent ath9k, add commit message]
> Signed-off-by: Sven Eckelmann <sven.eckelmann@open-mesh.com>
> ---
> v2:
>  - reduce amount of possible goto-raptor attacks by one (thanks Kalle Valo)
>
> This problem was discovered in mesh setups. It was noticed that some nodes


What kind of setup?
Using 802.11s?

I ask this because I have almost completed a patch for authsae that 
checks rekey.

The problems there might show as the behaviour described here.


> were not able to see their neighbors (mostly after running for a while) -
> even when those neighbors received data from them via IBSS. A simple `iw
> dev wlan0 scan` fixed the problem for them. But the problem seems to
> reappear after while(tm) in a large enough(tm) mesh.
>
> This patch is a little bit obscure because it requires CONFIG_ATH9K_DEBUGFS
> to actually work. But there still seems to be potential interest in
> Freifunk communities or Freifunk meta-projects (e.g. freifunk-gluon). It is
> currently not known if it helps them but publishing this to allow them to
> test and play around with it will not hurt :)
> ---
>  drivers/net/wireless/ath/ath9k/ath9k.h |  3 +++
>  drivers/net/wireless/ath/ath9k/debug.c |  1 +
>  drivers/net/wireless/ath/ath9k/debug.h |  1 +
>  drivers/net/wireless/ath/ath9k/link.c  | 48 +++++++++++++++++++++++++++++++++-
>  4 files changed, 52 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
> index 9c6fee7..3987ad5 100644
> --- a/drivers/net/wireless/ath/ath9k/ath9k.h
> +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
> @@ -996,6 +996,9 @@ struct ath_softc {
>  	short nbcnvifs;
>  	unsigned long ps_usecount;
>
> +	unsigned long last_check_time;
> +	u32 last_check_interrupts;
> +
>  	struct ath_rx rx;
>  	struct ath_tx tx;
>  	struct ath_beacon beacon;
> diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
> index 608b370..6d5c253 100644
> --- a/drivers/net/wireless/ath/ath9k/debug.c
> +++ b/drivers/net/wireless/ath/ath9k/debug.c
> @@ -768,6 +768,7 @@ static int read_file_reset(struct seq_file *file, void *data)
>  		[RESET_TX_DMA_ERROR] = "Tx DMA stop error",
>  		[RESET_RX_DMA_ERROR] = "Rx DMA stop error",
>  		[RESET_TYPE_DEADBEEF] = "deadbeef hang",
> +		[RESET_TYPE_DEAF] = "deaf hang",
>  	};
>  	int i;
>
> diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
> index 0d77abbf6..6f186bd 100644
> --- a/drivers/net/wireless/ath/ath9k/debug.h
> +++ b/drivers/net/wireless/ath/ath9k/debug.h
> @@ -53,6 +53,7 @@ enum ath_reset_type {
>  	RESET_TX_DMA_ERROR,
>  	RESET_RX_DMA_ERROR,
>  	RESET_TYPE_DEADBEEF,
> +	RESET_TYPE_DEAF,
>  	__RESET_TYPE_MAX
>  };
>
> diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
> index 04195d5..ae99c02 100644
> --- a/drivers/net/wireless/ath/ath9k/link.c
> +++ b/drivers/net/wireless/ath/ath9k/link.c
> @@ -158,13 +158,59 @@ static bool ath_hw_hang_deadbeef(struct ath_softc *sc)
>  	return true;
>  }
>
> +static bool ath_hw_hang_deaf(struct ath_softc *sc)
> +{
> +#ifndef CONFIG_ATH9K_DEBUGFS
> +	return false;
> +#else
> +	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
> +	u32 interrupts, interrupt_per_s;
> +	unsigned int interval;
> +
> +	/* get historic data */
> +	interval = jiffies_to_msecs(jiffies - sc->last_check_time);
> +	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
> +		interrupts = sc->debug.stats.istats.rxlp;
> +	else
> +		interrupts = sc->debug.stats.istats.rxok;
> +
> +	interrupts -= sc->last_check_interrupts;
> +
> +	/* save current data */
> +	sc->last_check_time = jiffies;
> +	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
> +		sc->last_check_interrupts = sc->debug.stats.istats.rxlp;
> +	else
> +		sc->last_check_interrupts = sc->debug.stats.istats.rxok;
> +
> +	/* sanity check, should be 30 seconds */
> +	if (interval > 40000 || interval < 20000)
> +		return false;
> +
> +	/* should be at least one interrupt per second */
> +	interrupt_per_s = interrupts / (interval / 1000);
> +	if (interrupt_per_s >= 1)
> +		return false;
> +
> +	ath_dbg(common, RESET,
> +		"RX deaf hang is detected. Schedule chip reset\n");
> +	ath9k_queue_reset(sc, RESET_TYPE_DEAF);
> +
> +	return true;
> +#endif
> +}
> +
>  void ath_hw_hang_work(struct work_struct *work)
>  {
>  	struct ath_softc *sc = container_of(work, struct ath_softc,
>  					    hw_hang_work.work);
>
> -	ath_hw_hang_deadbeef(sc);
> +	if (ath_hw_hang_deadbeef(sc))
> +		goto requeue_worker;
> +
> +	ath_hw_hang_deaf(sc);
>
> +requeue_worker:
>  	ieee80211_queue_delayed_work(sc->hw, &sc->hw_hang_work,
>  				     msecs_to_jiffies(ATH_HANG_WORK_INTERVAL));
>  }
>

-- 
Ferry Huberts
