Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57254 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbZGWKh0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 06:37:26 -0400
Subject: Re: [PATCH 2/7] mac80211: advance the state machine immediately if
 no delay is needed
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20090723101348.5147.92831.stgit@localhost.localdomain>
References: <20090723100732.5147.73989.stgit@localhost.localdomain>
	 <20090723101348.5147.92831.stgit@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-82tTJ/nQiV3cRktdyYPu"
Date: Thu, 23 Jul 2009 12:36:27 +0200
Message-Id: <1248345387.19121.20.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-82tTJ/nQiV3cRktdyYPu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-23 at 12:13 +0200, Helmut Schaa wrote:
> Instead of queueing the scan work again without delay just process the
> next state immediately.
>    =20
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>=20
>  net/mac80211/scan.c |   24 +++++++++++++++---------
>  1 files changed, 15 insertions(+), 9 deletions(-)
>=20
> diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
> index 71500f1..db122e4 100644
> --- a/net/mac80211/scan.c
> +++ b/net/mac80211/scan.c
> @@ -587,15 +587,21 @@ void ieee80211_scan_work(struct work_struct *work)
>  		return;
>  	}
> =20
> -	switch (local->scan_state) {
> -	case SCAN_SET_CHANNEL:
> -		if (ieee80211_scan_state_set_channel(local, &next_delay))
> -			return;
> -		break;
> -	case SCAN_SEND_PROBE:
> -		ieee80211_scan_state_send_probe(local, &next_delay);
> -		break;
> -	}
> +	/*
> +	 * as long as no delay is required advance immediately
> +	 * without scheduling a new work
> +	 */
> +	do {
> +		switch (local->scan_state) {
> +		case SCAN_SET_CHANNEL:
> +			if (ieee80211_scan_state_set_channel(local, &next_delay))
> +				return;
> +			break;
> +		case SCAN_SEND_PROBE:
> +			ieee80211_scan_state_send_probe(local, &next_delay);
> +			break;
> +		}
> +	} while (next_delay =3D=3D 0);
> =20
>  	queue_delayed_work(local->hw.workqueue, &local->scan_work,
>  			   next_delay);
>=20
>=20

--=-82tTJ/nQiV3cRktdyYPu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKaD0oAAoJEODzc/N7+QmaLyMP/jnE4V2jCkIPa3Ih1yMq9PDu
6IiV/XblJGXj6Hfm1Lj4dHhzSJ1JtwbY9z+XiQXStI0eP32Lcxbcl2Dhhk9wYddu
8ki/JV5s6WomXI1QyN9AK9V4HsCI0NbjSFYyG7JChi4hEraWTWd1QaeJ1QBBL2AE
rwoYnPClBynqL8+yB/Sa2LxntihWwBiNE4vfqf714w3dtmSb44nHJdef+RQI6Pdf
k3PQWarWLZAuJTF3EXS+zXz/SqSbkEWFrwTdZV73eq/aFY+zDgr0ol0tpf8zYHYs
m2CY58qrU36ZhZZantOftvaSRoEHbWH59pNs/MiN0Dg5I6v4cEatYKyAlLoIpjQB
80h5WaW2E1cSRvZKvg/5K/N15q+QRPFvU1glUo8G5L57beMSE+N37kscqIGx5VHM
9O4DZUbk8rXtoeXrllD+UBqcaug2mm6aLsuG+DlxPvFoAZIidir7FvoNoKJs6S+u
gW/CCzf8m9sg7Ctpv9k1lbVPnmyXfl45NUSY2vbs61WAyQcmDpL/1TH/OVhovtQc
yNuTwTOSuFr1VsVv8+P9HIB8toBLuEwkX14f2HxLuxDwe0Y+ncjrgbdaiV5+Nvvs
7n40IZDCqoW88l0+svsYoLnsOpdmFSNQGynO9s9K7OmuSIy5+4dKp+k/S0Z7GcAB
TZHtHWmADOhJBoxBRtBr
=lf0n
-----END PGP SIGNATURE-----

--=-82tTJ/nQiV3cRktdyYPu--

