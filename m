Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:35596 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881Ab0IUKmu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 06:42:50 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 21 Sep 2010 03:42:43 -0700
Date: Tue, 21 Sep 2010 16:12:41 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath9k: Kick start paprd calibration whenever
	operating channel changes
Message-ID: <20100921104241.GC4229@vasanth-laptop>
References: <1285048487-16795-1-git-send-email-vasanth@atheros.com> <1285048487-16795-2-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1285048487-16795-2-git-send-email-vasanth@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 21, 2010 at 11:24:47AM +0530, Vasanthakumar Thiagarajan wrote:
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/hw.h   |    1 +
>  drivers/net/wireless/ath/ath9k/main.c |   18 +++++++++++++++++-
>  2 files changed, 18 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
> index df47f79..c1b4962 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.h
> +++ b/drivers/net/wireless/ath/ath9k/hw.h
> @@ -645,6 +645,7 @@ struct ath_hw {
>  	struct ath9k_hw_capabilities caps;
>  	struct ath9k_channel channels[38];
>  	struct ath9k_channel *curchan;
> +	struct ath9k_channel prev_paprd_chan;
>  
>  	union {
>  		struct ar5416_eeprom_def def;
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index a133878..9150788 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -266,6 +266,20 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
>  	return r;
>  }
>  
> +static bool is_paprd_done(struct ath_hw *ah)
> +{
> +	struct ath9k_channel *curchan, *paprd_chan;
> +
> +	curchan = ah->curchan;
> +	paprd_chan = &ah->prev_paprd_chan;
> +
> +	if ((paprd_chan->channel == curchan->channel) &&
> +	    paprd_chan->chanmode == curchan->chanmode)
> +		return true;
> +
> +	return false;
> +}
> +
>  static void ath_paprd_activate(struct ath_softc *sc)
>  {
>  	struct ath_hw *ah = sc->sc_ah;
> @@ -375,6 +389,8 @@ void ath_paprd_calibrate(struct work_struct *work)
>  
>  	if (chain_ok) {
>  		caldata->paprd_done = true;
> +		memcpy(&ah->prev_paprd_chan, ah->curchan,
> +		       sizeof(struct ath9k_channel));
>  		ath_paprd_activate(sc);
>  	}
>  
> @@ -489,7 +505,7 @@ set_timer:
>  
>  	mod_timer(&common->ani.timer, jiffies + msecs_to_jiffies(cal_interval));
>  	if ((sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_PAPRD) && ah->caldata) {
> -		if (!ah->caldata->paprd_done)
> +		if (!is_paprd_done(ah))
>  			ieee80211_queue_work(sc->hw, &sc->paprd_work);
>  		else
>  			ath_paprd_activate(sc);

Please drop this particular one as it looks redundant.

Vasanth
