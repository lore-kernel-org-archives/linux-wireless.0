Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49414 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757635Ab2DLRov (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 13:44:51 -0400
Received: by yhmm54 with SMTP id m54so1230149yhm.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 Apr 2012 10:44:50 -0700 (PDT)
Date: Thu, 12 Apr 2012 10:44:40 -0700
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH] ath9k: fix an issue in ieee80211_tx_info count field
 management
Message-ID: <20120412174440.GA30082@tux> (sfid-20120412_194455_633336_36BA4EC0)
References: <CAA2SeN+DRnff_e-fDuFAV-vof0OEsw7VEkmxBhUivq0kSspzvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAA2SeN+DRnff_e-fDuFAV-vof0OEsw7VEkmxBhUivq0kSspzvw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 05, 2012 at 11:39:57PM +0200, Lorenzo Bianconi wrote:
> Hi all,
> 
> I noticed a possible issue in the status count field management of the
> ieee80211_tx_info data structure. In particular, when the AGGR
> processing is employed,
> ath_tx_complete_aggr() sets status.rates[].count just for the first
> frame and not for others belonging to the same burst, leading to wrong
> statistic data in the mac80211 debug file system.

Thanks for the patch! Unfortunatey this patch is not well formed.
Please review exisitng patches via git log. Also please include in the
commit log the effects of not applying the patch Vs actually applying
since you are indicating this is fix. This is important for considering
patches to be either propagated or not to the stable series of the kernel.
In this case this does not seem like a stable fix at all since it seems
you are indicating this is only a debugfs fix.

Patch review below.

> Regards
> 
> Lorenzo
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
> ---
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -58,7 +58,7 @@
>  			     struct list_head *head, bool internal);
>  static void ath_tx_rc_status(struct ath_softc *sc, struct ath_buf *bf,
>  			     struct ath_tx_status *ts, int nframes, int nbad,
> -			     int txok);
> +			     int txok, bool update_info);
>  static void ath_tx_update_baw(struct ath_softc *sc, struct ath_atx_tid *tid,
>  			      int seqno);
>  static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
> @@ -542,9 +542,12 @@
> 
>  			if (rc_update && (acked_cnt == 1 || txfail_cnt == 1)) {
>  				memcpy(tx_info->control.rates, rates, sizeof(rates));
> -				ath_tx_rc_status(sc, bf, ts, nframes, nbad, txok);
> +				ath_tx_rc_status(sc, bf, ts, nframes, nbad,
> +						 txok, true);
>  				rc_update = false;
> -			}
> +			} else
> +				ath_tx_rc_status(sc, bf, ts, nframes, nbad,
> +						 txok, false);
> 
>  			ath_tx_complete_buf(sc, bf, txq, &bf_head, ts,
>  				!txfail);
> @@ -2068,7 +2071,7 @@
> 
>  static void ath_tx_rc_status(struct ath_softc *sc, struct ath_buf *bf,
>  			     struct ath_tx_status *ts, int nframes, int nbad,
> -			     int txok)
> +			     int txok, bool update_info)
>  {
>  	struct sk_buff *skb = bf->bf_mpdu;
>  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
> @@ -2083,16 +2086,16 @@
>  	tx_rateindex = ts->ts_rateindex;
>  	WARN_ON(tx_rateindex >= hw->max_rates);
> 
> -	if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
> +	if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) && update_info) {
>  		tx_info->flags |= IEEE80211_TX_STAT_AMPDU;

You are changing the behaviour here to only add the
tx_info->flags |= IEEE80211_TX_STAT_AMPDU now only when
update_info is set. What effects does this have from
previous behaviour ?

> 
>  		BUG_ON(nbad > nframes);
> +		tx_info->status.ampdu_len = nframes;
> +		tx_info->status.ampdu_ack_len = nframes - nbad;

Same here.

>  	}
> -	tx_info->status.ampdu_len = nframes;
> -	tx_info->status.ampdu_ack_len = nframes - nbad;
> 
>  	if ((ts->ts_status & ATH9K_TXERR_FILT) == 0 &&
> -	    (tx_info->flags & IEEE80211_TX_CTL_NO_ACK) == 0) {
> +	    (tx_info->flags & IEEE80211_TX_CTL_NO_ACK) == 0 && update_info) {

and here

>  		/*
>  		 * If an underrun error is seen assume it as an excessive
>  		 * retry only if max frame trigger level has been reached
> @@ -2134,7 +2137,7 @@
>  		txq->axq_ampdu_depth--;
> 
>  	if (!bf_isampdu(bf)) {
> -		ath_tx_rc_status(sc, bf, ts, 1, txok ? 0 : 1, txok);
> +		ath_tx_rc_status(sc, bf, ts, 1, txok ? 0 : 1, txok, true);
>  		ath_tx_complete_buf(sc, bf, txq, bf_head, ts, txok);
>  	} else
>  		ath_tx_complete_aggr(sc, txq, bf, bf_head, ts, txok, true);
> 
> --

  Luis
