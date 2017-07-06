Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:4664 "EHLO
        alexa-out-lv-01.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752660AbdGFHt4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 03:49:56 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Matthias Frei <mf@frei.media>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: set a-mpdu reference number in ath10k (receiver)
Date: Thu, 6 Jul 2017 07:42:48 +0000
Message-ID: <87o9syf1uf.fsf@kamboji.qca.qualcomm.com> (sfid-20170706_095005_649453_C4943163)
References: <B8D63297-0A88-42A3-B789-3849895CF201@frei.media>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matthias Frei <mf@frei.media> writes:

> Set the a-mpdu reference number in ath10k to make it accessible in the re=
ceivers radiotap header. Implemented as in ath9k.=20
> The reference number is needed for troubleshooting and research at the re=
ceivers site (e.g. to identify mpdu's that were aggregated in an a-mpdu)
>
> Signed-off-by: Matthias Frei <mf@frei.media>

I did some changes in pending branch, please review them:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=3Dp=
ending&id=3Df722728460a5c9e9200a7f1362fa605a714c1968

> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -989,6 +989,9 @@ struct ath10k {
>  		u32 reg_ack_cts_timeout_orig;
>  	} fw_coverage;
> =20
> +	/* AMPDU */
> +	u32 ampdu_ref;

The comment is not providing any extra value, I'll remove that.

What about locking? How is this protected or doesn't it need anything?

Also I renamed this to ampdu_reference just to be consistent with the
mac80211 name.

> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
> @@ -877,16 +877,24 @@ static void ath10k_htt_rx_h_ppdu(struct ath10k *ar,
>  		status->nss =3D 0;
>  		status->encoding =3D RX_ENC_LEGACY;
>  		status->bw =3D RATE_INFO_BW_20;
> -		status->flag &=3D ~RX_FLAG_MACTIME_END;
> -		status->flag |=3D RX_FLAG_NO_SIGNAL_VAL;
> +		status->flag &=3D ~(RX_FLAG_MACTIME_END | RX_FLAG_AMPDU_IS_LAST);
> +		status->flag |=3D RX_FLAG_NO_SIGNAL_VAL | RX_FLAG_AMPDU_DETAILS | RX_F=
LAG_AMPDU_LAST_KNOWN;

This added a new warning:

drivers/net/wireless/ath/ath10k/htt_rx.c:894: line over 90 characters

I fixed that by separating the setting of ampdu flags.

> +		/* set ampdu ref */
> +		status->ampdu_reference =3D ar->ampdu_ref;

The comment is not telling anything new so removed it.

> -	if (is_last_ppdu)
> +	if (is_last_ppdu) {
>  		ath10k_htt_rx_h_mactime(ar, status, rxd);
> +
> +		/* set ampdu last segment flag */
> +		status->flag |=3D RX_FLAG_AMPDU_IS_LAST;
> +		ar->ampdu_ref++;
> +	}

So this counter is per wiphy, not per vdev. Is that ok?

--=20
Kalle Valo=
