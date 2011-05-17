Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:33965 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754624Ab1EQNAb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 09:00:31 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 17 May 2011 06:00:01 -0700
Date: Tue, 17 May 2011 18:30:27 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH] ath9k: implement .tx_last_beacon()
Message-ID: <20110517130027.GA14266@vmraj-lnx.users.atheros.com> (sfid-20110517_150045_590724_8E28CB14)
References: <1305630711-99631-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1305630711-99631-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 17, 2011 at 04:41:51PM +0530, Felix Fietkau wrote:
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath9k/ath9k.h  |    3 ++
>  drivers/net/wireless/ath/ath9k/beacon.c |   12 +++++++++
>  drivers/net/wireless/ath/ath9k/main.c   |   38 +++++++++++++++++++++++++++++++
>  3 files changed, 53 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
> index 03b37d7..d6e7825 100644
> --- a/drivers/net/wireless/ath/ath9k/ath9k.h
> +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
> @@ -397,6 +397,9 @@ struct ath_beacon {
>  	struct ath_descdma bdma;
>  	struct ath_txq *cabq;
>  	struct list_head bbuf;
> +
> +	bool tx_processed;
> +	bool tx_last;
>  };
>  
>  void ath_beacon_tasklet(unsigned long data);
> diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
> index 0199af0..e8756c5 100644
> --- a/drivers/net/wireless/ath/ath9k/beacon.c
> +++ b/drivers/net/wireless/ath/ath9k/beacon.c
> @@ -18,6 +18,12 @@
>  
>  #define FUDGE 2
>  
> +static void ath9k_reset_beacon_status(struct ath_softc *sc)
> +{
> +	sc->beacon.tx_processed = false;
> +	sc->beacon.tx_last = false;
> +}
> +
>  /*
>   *  This function will modify certain transmit queue properties depending on
>   *  the operating mode of the station (AP or AdHoc).  Parameters are AIFS
> @@ -72,6 +78,8 @@ static void ath_beacon_setup(struct ath_softc *sc, struct ath_vif *avp,
>  	struct ieee80211_supported_band *sband;
>  	u8 rate = 0;
>  
> +	ath9k_reset_beacon_status(sc);
> +
>  	ds = bf->bf_desc;
>  	flags = ATH9K_TXDESC_NOACK;
>  
> @@ -134,6 +142,8 @@ static struct ath_buf *ath_beacon_generate(struct ieee80211_hw *hw,
>  	struct ieee80211_tx_info *info;
>  	int cabq_depth;
>  
> +	ath9k_reset_beacon_status(sc);
> +
>  	avp = (void *)vif->drv_priv;
>  	cabq = sc->beacon.cabq;
>  
> @@ -644,6 +654,8 @@ static void ath_beacon_config_adhoc(struct ath_softc *sc,
>  	struct ath_common *common = ath9k_hw_common(ah);
>  	u32 tsf, delta, intval, nexttbtt;
>  
> +	ath9k_reset_beacon_status(sc);
> +
>  	tsf = ath9k_hw_gettsf32(ah) + TU_TO_USEC(FUDGE);
>  	intval = TU_TO_USEC(conf->beacon_interval & ATH9K_BEACON_PERIOD);
>  
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index 17ebdf1..576b87d 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -2332,6 +2332,43 @@ static bool ath9k_tx_frames_pending(struct ieee80211_hw *hw)
>  	return false;
>  }
>  
> +int ath9k_tx_last_beacon(struct ieee80211_hw *hw)
> +{
> +	struct ath_softc *sc = hw->priv;
> +	struct ath_hw *ah = sc->sc_ah;
> +	struct ieee80211_vif *vif;
> +	struct ath_vif *avp;
> +	struct ath_buf *bf;
> +	struct ath_tx_status ts;
> +	int status;
> +
> +	if (ah->opmode != NL80211_IFTYPE_ADHOC)
> +		return 0;
> +
opmode check is not needed. tx_last_beacon is called only on ibss mode.

> +	vif = sc->beacon.bslot[0];
> +	if (!vif)
> +		return 0;
> +

> +	avp = (void *)vif->drv_priv;
> +	if (!avp->is_bslot_active)
> +		return 0;
> +
> +	if (!sc->beacon.tx_processed) {
> +		bf = avp->av_bcbuf;
> +		if (!bf || !bf->bf_mpdu)
> +			return 0;
> +
> +		status = ath9k_hw_txprocdesc(ah, bf->bf_desc, &ts);
> +		if (status == -EINPROGRESS)
> +			return 0;
> +
This could be racy with beacon tasklet. Process beacon descriptor
and update tx_last for every beacon in the beacon tasklet. In such case,
reset tx_processed alone in ath9k_reset_beacon_status.

> +		sc->beacon.tx_processed = true;
> +		sc->beacon.tx_last = !(ts.ts_status & ATH9K_TXERR_FILT);
> +	}
What about other TXERR_* status?
> +
> +	return sc->beacon.tx_last;
> +}
> +
--
Rajkumar
