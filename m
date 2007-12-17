Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49791 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbXLQSSq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 13:18:46 -0500
Subject: Re: [PATCH 5/8] mac80211: A-MPDU Rx handling aggregation reordering
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <11979070782762-git-send-email-ron.rindjunsky@intel.com>
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
	 <11979070782762-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Qq24WVXunY8OyRGHhIuN"
Date: Mon, 17 Dec 2007 19:18:35 +0100
Message-Id: <1197915515.4885.86.camel@johannes.berg> (sfid-20071217_181851_948257_A5255F9E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Qq24WVXunY8OyRGHhIuN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


>  struct ieee80211_rx_status {
> @@ -388,6 +389,7 @@ struct ieee80211_rx_status {
>  	int noise;
>  	int antenna;
>  	int rate;
> +	int ordered;

That's not an int, and it's only used internally. Can we somehow avoid
putting it into the rx status, have it in the txrx status structure
instead and give it the proper type (txrx result)? More of a question
than a suggestion, I'd like to have that but I'm not sure it's doable.
=20
> @@ -1252,6 +1254,20 @@ void ieee80211_sta_stop_rx_BA_session(struct net_d=
evice *dev, u8 *ra, u16 tid,
>  		ieee80211_send_delba(dev, ra, tid, 0, reason);
> =20
>  	/* free the reordering buffer */
> +	for (i =3D 0; i < sta->ampdu_mlme.tid_rx[tid].buf_size; i++) {
> +		if (sta->ampdu_mlme.tid_rx[tid].reorder_buf[i]) {
> +			/* release the reordered frames to stack,
> +			 * but drop them there */
> +			memcpy(&status, sta->ampdu_mlme.tid_rx[tid].
> +				reorder_buf[i]->cb, sizeof(status));
> +			status.ordered =3D TXRX_DROP;
> +			__ieee80211_rx(hw, sta->ampdu_mlme.
> +				       tid_rx[tid].reorder_buf[i],
> +				       &status);

This is strange. Why are they even passed to __ieee80211_rx?

> +#define SEQ_MODULO 0x1000
> +#define SEQ_MASK   0xfff
> +
> +static inline int seq_less(u16 sq1, u16 sq2)
> +{
> +	return (((sq1 - sq2) & SEQ_MASK) > (SEQ_MODULO >> 1));

Is it really correct to subtract before masking?

> +static inline u16 seq_sub(u16 sq1, u16 sq2)
> +{
> +	return ((sq1 - sq2) & SEQ_MASK);
> +}

Same here. And maybe seq_less should use seq_sub and the SEQ_MODULO
define should be (SEQ_MASK+1)?

I think I need to take a second look at this patch to even understand
the problem it solves.

johannes

--=-Qq24WVXunY8OyRGHhIuN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2a9eqVg1VMiehFYAQIl8w/7BYpVH6Npu6Eoas1Knw7qi1rPmVVftjWo
9L9w6vkTi2pitbl0EnxE/4yv7wJU6LshRuIumUF5WI+Kw+2/iDI4J1u4bNnoXGfX
FDPMcJl1vA7lRZzCEOkFkEhtHivQFYV+gwqWHfJPL5MH+/lP4wx+ZHTLyu8S5+Nc
FOOUJRwahk4mOSbbOP3Z1o7ITza0h8auEjxTEZFokraPy8a5I0mxeTYOm/EnTaJI
v3OMe/aWjmCrkcUegZCudSYEgIaMC6MV0hYwuHJbNbRRxb079XN+MF4V02U/Npgi
M9MOyhxJU1z5zeWZuB1Mv0FCFkqCbpsV4jb8NnOgM94DyNdmf/KX61rhxdCP76qp
N99PCFiFoA4pPAhAhNwSOrWvAZRNsbvtavc5DhiVEUjfjyRSONJ4CNReX7l2Mg8X
65Css49x3roIWFWahcYue550UKV9qoGNZRoLk5dUL7DvkbQJZMXqJXMA4rBTiqLu
z567whVSI+dywAH4lW92zGGOb3zc+CjL3ujMiyLRgBjP4MEbec+iMec7ZqGpP9nc
wvsXAs7fcJakSC/exYTH71OHPEXgqf1g7nrgmgjYDWJFkB2zB6lL6itaNXsluTgJ
Cp+2rv3byF2j/+7zXp8VnXXU5fiGAZ4DUud75o7zpd06sVOvZdC1ASaW92SpDTQ1
+kkhhbs+85A=
=UXjf
-----END PGP SIGNATURE-----

--=-Qq24WVXunY8OyRGHhIuN--

