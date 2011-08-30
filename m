Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57644 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab1H3F0T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 01:26:19 -0400
Date: Tue, 30 Aug 2011 10:56:01 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<rodrigue@qca.qualcomm.com>, <rmanohar@qca.qualcomm.com>
Subject: Re: [PATCH v7 2/4] ath9k: always call ath_reset from workqueue
	context
Message-ID: <20110830052559.GB31187@vasanth-laptop> (sfid-20110830_072628_133135_182C77DD)
References: <1314643245-59142-1-git-send-email-nbd@openwrt.org> <1314643245-59142-2-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1314643245-59142-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 29, 2011 at 08:40:43PM +0200, Felix Fietkau wrote:
> This makes it much easier to add further rework to avoid race conditions
> between reset and other work items.
> Move other functions to make ath_reset static.

Can you please explain where you'll run into race during
ath_reset()?. It's always called with pcu_lock held.

> @@ -386,9 +386,7 @@ void ath_beacon_tasklet(unsigned long data)
>  			ath_dbg(common, ATH_DBG_BSTUCK,
>  				"beacon is officially stuck\n");
>  			sc->sc_flags |= SC_OP_TSF_RESET;
> -			spin_lock(&sc->sc_pcu_lock);
> -			ath_reset(sc, true);
> -			spin_unlock(&sc->sc_pcu_lock);
> +			ieee80211_queue_work(sc->hw, &sc->hw_reset_work);

We'll expect a reset happening as soon possible here. Handling this
in a work item may not be appropriate.

>  void ath9k_tasklet(unsigned long data)
>  {
> @@ -675,9 +607,7 @@ void ath9k_tasklet(unsigned long data)
>  
>  	if ((status & ATH9K_INT_FATAL) ||
>  	    (status & ATH9K_INT_BB_WATCHDOG)) {
> -		spin_lock(&sc->sc_pcu_lock);
> -		ath_reset(sc, true);
> -		spin_unlock(&sc->sc_pcu_lock);
> +		ieee80211_queue_work(sc->hw, &sc->hw_reset_work);

Above comment applies here as well.

Vasanth
