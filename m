Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64414 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab1H2K1n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 06:27:43 -0400
Date: Mon, 29 Aug 2011 15:58:09 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH v4 2/3] ath9k: merge reset related functions
Message-ID: <20110829102809.GA331@vmraj-lnx.users.atheros.com> (sfid-20110829_122746_703554_838311F0)
References: <1314611896-97031-1-git-send-email-nbd@openwrt.org>
 <1314611896-97031-2-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1314611896-97031-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 29, 2011 at 11:58:15AM +0200, Felix Fietkau wrote:
> reduces unnecessary code duplication
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath9k/main.c |  258 +++++++++++++--------------------
>  1 files changed, 100 insertions(+), 158 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index 085ec20..4c3671a 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -212,83 +212,45 @@ static int ath_update_survey_stats(struct ath_softc *sc)
>  	return ret;
>  }
>  
> -/*
> - * Set/change channels.  If the channel is really being changed, it's done
> - * by reseting the chip.  To accomplish this we must first cleanup any pending
> - * DMA, then restart stuff.
> -*/
> -static int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
> -		    struct ath9k_channel *hchan)
> +static bool ath_prepare_reset(struct ath_softc *sc, bool retry_tx, bool flush)
>  {
>  	struct ath_hw *ah = sc->sc_ah;
> -	struct ath_common *common = ath9k_hw_common(ah);
> -	struct ieee80211_conf *conf = &common->hw->conf;
> -	bool fastcc = true, stopped;
> -	struct ieee80211_channel *channel = hw->conf.channel;
> -	struct ath9k_hw_cal_data *caldata = NULL;
> -	int r;
> +	bool ret;
>  
> -	if (sc->sc_flags & SC_OP_INVALID)
> -		return -EIO;
> +	ieee80211_stop_queues(sc->hw);
>  
>  	sc->hw_busy_count = 0;
> -
> -	del_timer_sync(&common->ani.timer);

ani timer never be stopped. why did you remove from ath_prepare_reset?

--
Rajkumar
