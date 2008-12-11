Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39603 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564AbYLKRRI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 12:17:08 -0500
Subject: Re: [RFC] mac80211: Add HT rates into RX status reporting
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org,
	Henning Rogge <hrogge@googlemail.com>
In-Reply-To: <20081211161741.GA27460@jm.kir.nu> (sfid-20081211_171755_461467_12BBE0E8)
References: <20081211161741.GA27460@jm.kir.nu>
	 (sfid-20081211_171755_461467_12BBE0E8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8ZnNl159wPK0grCcmmMg"
Date: Thu, 11 Dec 2008 18:16:29 +0100
Message-Id: <1229015789.8081.40.camel@johannes.berg> (sfid-20081211_181713_399863_7DE10B72)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8ZnNl159wPK0grCcmmMg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-12-11 at 18:17 +0200, Jouni Malinen wrote:

> Radiotap code gets some of the additional knowledge so that it can
> determine the used bitrate for HT rates, too (though, the rate field
> is not large enough to fit all rates). It would be useful to add MCS
> index, HT20/HT40, and short GI information into radiotap definition at
> some point, too, and the needed information for filling in those field
> is now available in mac80211.

Can we leave the rate calculation out here? I don't think we should do
that much in this case, and we can extend radiotap later to include HT
information.

> The ath9k change fixes and cleans up the RX status reporting by
> getting rid of code that used internal rate tables and ratekbps
> calculation. The correct value is now reported with MCS index instead
> of the old mechanism that defaulted to using the highest legacy rate.

Yay. This is the last step for generic HT rate control with ath9k, I
think.

> --- wireless-testing.orig/include/net/mac80211.h	2008-12-11 16:25:19.0000=
00000 +0200
> +++ wireless-testing/include/net/mac80211.h	2008-12-11 16:30:33.000000000=
 +0200
> @@ -436,6 +436,9 @@ ieee80211_tx_info_clear_status(struct ie
>   *	is valid. This is useful in monitor mode and necessary for beacon fra=
mes
>   *	to enable IBSS merging.
>   * @RX_FLAG_SHORTPRE: Short preamble was used for this frame
> + * @RX_FLAG_HT20: HT20 MCS was used and rate_idx is MCS index
> + * @RX_FLAG_HT40: HT40 MCS was used and rate_idx is MCS index
> + * @RX_FLAG_SHORT_GI: Short guard interval was used

I think we should do RX_FLAG_HT and RX_FLAG_40MHZ so that=20

> - * @rate_idx: index of data rate into band's supported rates
> + * @rate_idx: index of data rate into band's supported rates or MCS inde=
x if
> + *	HT rates are use (RX_FLAG_HT20 or RX_FLAG_HT40)

this becomes just checking for RATE_FLAG_HT instead of both, what do you
think?

> --- wireless-testing.orig/net/mac80211/mlme.c	2008-12-11 16:48:40.0000000=
00 +0200
> +++ wireless-testing/net/mac80211/mlme.c	2008-12-11 16:59:01.000000000 +0=
200
> @@ -1629,8 +1629,13 @@ static void ieee80211_rx_bss_info(struct
>  			 * e.g: at 1 MBit that means mactime is 192 usec earlier
>  			 * (=3D24 bytes * 8 usecs/byte) than the beacon timestamp.
>  			 */
> -			int rate =3D local->hw.wiphy->bands[band]->
> +			int rate;
> +			if (rx_status->flag & (RX_FLAG_HT20 | RX_FLAG_HT40)) {
> +				rate =3D 65; /* TODO: HT rates */
> +			} else {
> +				rate =3D local->hw.wiphy->bands[band]->
>  					bitrates[rx_status->rate_idx].bitrate;
> +			}
>  			rx_timestamp =3D rx_status->mactime + (24 * 8 * 10 / rate);
>  		} else if (local && local->ops && local->ops->get_tsf)
>  			/* second best option: get current TSF */

Ick, ok, I give up, I guess we do need a function to calculate the raw
bitrate after all. Let's put that into cfg80211 though, and then just
call it here. Henning's function is nice, although it might be too
expensive due to divisions...

> --- wireless-testing.orig/net/mac80211/rx.c	2008-12-11 16:48:43.000000000=
 +0200
> +++ wireless-testing/net/mac80211/rx.c	2008-12-11 18:05:31.000000000 +020=
0
> @@ -149,7 +149,41 @@ ieee80211_add_rx_radiotap_header(struct=20
>  	pos++;
> =20
>  	/* IEEE80211_RADIOTAP_RATE */
> -	*pos =3D rate->bitrate / 5;
> +	if (status->flag & (RX_FLAG_HT20 | RX_FLAG_HT40)) {
> +		int mcs_idx =3D status->rate_idx;
> +		if (mcs_idx >=3D 16) {
> +			/* TODO: MCS index 16.. */
> +			*pos =3D 0;
> +		} else {
> +			int mcs2rate_ht40[16] =3D {
> +				13500, 27500, 40500, 54000,
> +				81500, 108000, 121500, 135000,
> +				27000, 54000, 81000, 108000,
> +				162000, 216000, 243000, 270000
> +			};
> +			int mcs2rate[16] =3D {
> +				6500, 13000, 19500, 26000,
> +				39000, 52000, 58500, 65000,
> +				13000, 26000, 39000, 52000,
> +				78000, 104000, 117000, 130000
> +			};
> +			int rate;
> +			if (status->flag & RX_FLAG_HT40)
> +				rate =3D mcs2rate_ht40[mcs_idx];
> +			else
> +				rate =3D mcs2rate[mcs_idx];
> +
> +			if (status->flag & RX_FLAG_SHORT_GI)
> +				rate =3D rate * 10 / 9;
> +
> +			rate /=3D 500;
> +			if (rate > 255)
> +				rate =3D 255;
> +
> +			*pos =3D rate;
> +		}
> +	} else
> +		*pos =3D rate->bitrate / 5;
>  	pos++;
> =20
>  	/* IEEE80211_RADIOTAP_CHANNEL */

Can we just leave off the bitrate for HT for now?

> @@ -1863,10 +1897,16 @@ static int prepare_for_handlers(struct i
>  			if (!(sdata->dev->flags & IFF_PROMISC))
>  				return 0;
>  			rx->flags &=3D ~IEEE80211_RX_RA_MATCH;
> -		} else if (!rx->sta)
> +		} else if (!rx->sta) {
> +			int rate_idx;
> +			if (rx->status->flag & (RX_FLAG_HT20 | RX_FLAG_HT40))
> +				rate_idx =3D 0; /* TODO: HT rates */
> +			else
> +				rate_idx =3D rx->status->rate_idx;
>  			rx->sta =3D ieee80211_ibss_add_sta(sdata, rx->skb,
>  						bssid, hdr->addr2,
> -						BIT(rx->status->rate_idx));
> +						BIT(rate_idx));
> +		}
>  		break;
>  	case NL80211_IFTYPE_MESH_POINT:
>  		if (!multicast &&

Ok, that's icky, but you can at least use rate_idx =3D <mandatory rates>
if you actually receive an HT frame for an IBSS peer, no? Of course,
that is expensive to calculate, we might want to precalculate it...

> @@ -2072,7 +2112,14 @@ static u8 ieee80211_sta_manage_reorder_b
>  					tid_agg_rx->reorder_buf[index]->cb,
>  					sizeof(status));
>  				sband =3D local->hw.wiphy->bands[status.band];
> -				rate =3D &sband->bitrates[status.rate_idx];
> +				if (status.flag &
> +				    (RX_FLAG_HT20 | RX_FLAG_HT40)) {
> +					/* TODO: HT rates */
> +					rate =3D sband->bitrates;
> +				} else {
> +					rate =3D &sband->bitrates
> +						[status.rate_idx];
> +				}
>  				__ieee80211_rx_handle_packet(hw,
>  					tid_agg_rx->reorder_buf[index],
>  					&status, rate);

I think we need to change the internal rate representation... Or review
it and see if we can allow NULL values. I.e. in struct ieee80211_rx_data
we need to do MCS stuff too instead of using the first rate here.

> @@ -2116,7 +2163,10 @@ static u8 ieee80211_sta_manage_reorder_b
>  		memcpy(&status, tid_agg_rx->reorder_buf[index]->cb,
>  			sizeof(status));
>  		sband =3D local->hw.wiphy->bands[status.band];
> -		rate =3D &sband->bitrates[status.rate_idx];
> +		if (status.flag & (RX_FLAG_HT20 | RX_FLAG_HT40))
> +			rate =3D sband->bitrates; /* TODO: HT rates */
> +		else
> +			rate =3D &sband->bitrates[status.rate_idx];
>  		__ieee80211_rx_handle_packet(hw, tid_agg_rx->reorder_buf[index],
>  					     &status, rate);
>  		tid_agg_rx->stored_mpdu_num--;

I suppose that's what you mean by those TODOs though, and the one below
too:

> @@ -2204,15 +2254,24 @@ void __ieee80211_rx(struct ieee80211_hw=20
>  	}
> =20
>  	sband =3D local->hw.wiphy->bands[status->band];
> -
> -	if (!sband ||
> -	    status->rate_idx < 0 ||
> -	    status->rate_idx >=3D sband->n_bitrates) {
> +	if (!sband) {
>  		WARN_ON(1);
>  		return;
>  	}
> =20
> -	rate =3D &sband->bitrates[status->rate_idx];
> +	if (status->flag & (RX_FLAG_HT20 | RX_FLAG_HT40)) {
> +		/* HT rates are not in the table - use the highest legacy rate
> +		 * for now since other parts of mac80211 may not yet be fully
> +		 * MCS aware. */
> +		rate =3D &sband->bitrates[sband->n_bitrates - 1];

That's inconsistent, you're using the highest here but the lowest after
the reorder buffer, no?

> +	} else {
> +		if (status->rate_idx < 0 ||
> +		    status->rate_idx >=3D sband->n_bitrates) {
> +			WARN_ON(1);
> +			return;
> +		}

Could change to if(WARN_ON(...)) return :)

johannes

--=-8ZnNl159wPK0grCcmmMg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQUrqAAoJEKVg1VMiehFY9yQQAKUalhAO5kTgXxjQbeNJJLI2
Rf/LRIeOZrNIzZ0MlUgEMFjnyZo7JsJ6BfHxwE9bsgguo5U39N9Q9gB6uKNTv9me
LmQWTa8u/r+WIF3NZYi+qnISicfnaDEjFuJAzjIunKJr8nzgMaSlgEgyYSC/ONNw
m18n1gJgylbTNAX167sM1RGUDD106G6I1v9OF0CvltArWaZGITsTmBAqYKpd5Qj6
h/znhWCQoFEjLB60/VJL0TR+h23UBAn49UvopBNZbAZIpsNHGQkobcu+Xyk7nuKL
0+9ELzWuXMOGc6i0LfUvWtLnrVXCnNOJPzK3SjR7VauYNM8wd5J2dM0GqMsM/YJF
MUz9jV5vfQc8wuUoJ4jmJNnUr7LIfQG3rH7PqvJSdl8DLuWffJaRYUN4FZzLloT9
A3BQvcHgjLFQvdpmHxTdiO3cAd+UINr2YbRhvME0uuMrBvt0Ds/WVoZa4+s0moLi
wwltNwxrsrHUZNNXpQuLPFSRvWjqQkoRfl4lwnE3uzPDtf8mSZZyjQP6d/4SO0cl
nxYcErcgRVIO1NQCoN5MykFTYLTxrISAfKM8KYSBvjsgIhiZIu+oDudzDDBP7S/3
6RZuJ7OBaDKWNVTr2BGFdAc6BGu/jXu8H1zwruHfcIGH12j7IMJ+JsmFjj4BUjpS
9cYwjvfYhIt8IsH0kzT9
=exLd
-----END PGP SIGNATURE-----

--=-8ZnNl159wPK0grCcmmMg--

