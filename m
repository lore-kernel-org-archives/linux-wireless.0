Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40486 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932103AbZHUISS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 04:18:18 -0400
Subject: Re: [PATCH] Implementation of the IEEE80211_RADIOTAP_RATE option
From: Johannes Berg <johannes@sipsolutions.net>
To: Rafael Laufer <rlaufer@cs.ucla.edu>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4A8DED03.2050502@cs.ucla.edu>
References: <4A8DED03.2050502@cs.ucla.edu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-gSQs2vxkJZF+6G5lWbPX"
Date: Fri, 21 Aug 2009 10:18:15 +0200
Message-Id: <1250842695.13872.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gSQs2vxkJZF+6G5lWbPX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-08-20 at 17:40 -0700, Rafael Laufer wrote:
> This patch implements the IEEE80211_RADIOTAP_RATE=20
> option when parsing radiotap headers to allow rate=20
> selection on a per-packet basis.
>=20
>=20
> Signed-off-by: Rafael Laufer <rlaufer@cs.ucla.edu>
> ---
>  Implementation of the IEEE80211_RADIOTAP_RATE=20
>  option when parsing radiotap headers to allow
>  rate selection on a per-packet basis.
>=20
>  net/mac80211/tx.c |   18 +++++++++++++++++-
>  1 files changed, 17 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 10a1099..41d636b 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -549,7 +549,10 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *t=
x)
>  	 * If we're associated with the sta at this point we know we can at
>  	 * least send the frame at the lowest bit rate.
>  	 */
> -	rate_control_get_rate(tx->sdata, tx->sta, &txrc);
> +
> +	/* in monitor mode, we already have the rate from the radiotap header *=
/
> +	if (likely(!(info->flags & IEEE80211_TX_CTL_INJECTED)))
> +		rate_control_get_rate(tx->sdata, tx->sta, &txrc);

NAK, the rate is optional in the radiotap header, and if not given then
regular rate control must be used.

johannes

--=-gSQs2vxkJZF+6G5lWbPX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKjlhEAAoJEODzc/N7+QmaBwAP/3wzbirgHo8pQgtmqNoo/SR9
oHOSeUYqgTWlK9LaR8P2XSGjax6F/aa3kQ6YLYBFlsst8Rj+jUuXDtlAiNj1baly
G95GLLLifuRGd04a+o1B85IIMEd24Ozuc1QncZ5BLLzLb2OF4EE7tN+mebBO5lQ6
9D3Xt0seFmx1WR/BEpcQJaBIINzzTV4QR1jZmBvHsLJdSRDlB01j4fQAz17/z520
fZdGH7y+q776+dt15WNHHYYUGhNZ089NHlgaTXnEeztaJTTBF/u4L7IqweqU+XAS
pSR7EhR7jb633DdI780qrBvPJCm266I0iaT55FqvnUyPZoz7XFI1G4pzRFw+m/6d
AZ9jPxpWxvqs2gt6OorsGk8ozzGn9Zf3BKsHjeKrEgQ8oNS/aKELKs8kuXF9afK/
6obq6Cu5l/SefvU/NhHvcatRX8rbm2nsLoqJwEiGn6XPfpnms2rsB2593zlHbBap
YcIuYthznBYLFc9IGjXo/oe7WFQ/zqgjjiWK3ym3zYr5ZRMPGBN5Db0FOv9Gw2Cx
6YdOZ7AA/Q6IBzzB6GcBF2h+KfgJoWX9B+sCIt462ktcWPSIXjXT0c5dtoeQoWGk
aAnBvi+OXrvr9upiEJ4dMwXUlRaJpuCSiEHLKqmbvDQY/xUwqm4U0jKzah7oKTh3
Klw85WHOcsjwK9d2lasa
=8HJA
-----END PGP SIGNATURE-----

--=-gSQs2vxkJZF+6G5lWbPX--

