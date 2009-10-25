Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48284 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815AbZJYS7R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2009 14:59:17 -0400
Subject: Re: [PATCH] mac80211: fix for incorrect sequence number on hostapd
  injected frames
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Bj=F6rn?= Smedman <bjorn.smedman@venatech.se>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni Malinen <j@w1.fi>, Joerg Pommnitz <pommnitz@yahoo.com>,
	Will Dyson <will.dyson@gmail.com>
In-Reply-To: <133e8d7e0910241155x4496b156p3c5d03450a71936a@mail.gmail.com>
References: <133e8d7e0910241155x4496b156p3c5d03450a71936a@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-PXSAMI9Om154rDRIcP0F"
Date: Sun, 25 Oct 2009 19:59:16 +0100
Message-ID: <1256497156.28230.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PXSAMI9Om154rDRIcP0F
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-10-24 at 20:55 +0200, Bj=C3=B6rn Smedman wrote:
> When hostapd injects a frame, e.g. an authentication or association
> response, mac80211 looks for a suitable access point virtual interface
> to associate the frame with based on its source address. This makes it
> possible e.g. to correctly assign sequence numbers to the frames.
>=20
> A small typo in the ethernet address comparison statement caused a
> failure to find a suitable ap interface. Sequence numbers on such
> frames where therefore left unassigned causing some clients
> (especially windows-based 11b/g clients) to reject them and fail to
> authenticate or associate with the access point. This patch fixes the
> typo in the address comparison statement.
>=20
> Signed-off-by: Bj=C3=B6rn Smedman <bjorn.smedman@venatech.se>

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

and Cc: stable@kernel.org I think

> ---
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index db4bda6..eaa4118 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1445,7 +1445,7 @@ static void ieee80211_xmit(struct
> ieee80211_sub_if_data *sdata,
>                                 if (tmp_sdata->vif.type !=3D NL80211_IFTY=
PE_AP)
>                                         continue;
>                                 if (compare_ether_addr(tmp_sdata->dev->de=
v_addr,
> -                                                      hdr->addr2)) {
> +                                                      hdr->addr2) =3D=3D=
 0) {
>                                         dev_hold(tmp_sdata->dev);
>                                         dev_put(sdata->dev);
>                                         sdata =3D tmp_sdata;
>=20


--=-PXSAMI9Om154rDRIcP0F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK5KAAAAoJEODzc/N7+QmaP/4QAK7WacrIEZeE12I8HceaFsGF
kpISHK6Tk9qTm2Q+b3tzQ7JtfEJKrlsKh44kB45lnflyCkggbPJ339kgqnemrT0Z
RJw+xbp9FlLiQjiHedXr9gpOox7n6W3igIlEXkXfC88IHqTJTV9/rkCzhS3cG141
XYZXurexcFecUDD9om5N5Owb/rNNcDQ9wfciFnI8C9Z2ga4HtMOT1UhanwKSJK/K
b9Y2GSxWM8q1fwfKEZVXovYt2FNR+SRStzGzGWYTcWRu4KEe3YLEFyvwT8I9JWcL
8Bkwe0xhNZq6ZDBuRzMze1CSE9SNzdwCdPaPCSELDSCbP7PrNkrkQCLgSRo/bIti
Cmi1oV8/HFJa8In7R5UztLFyU6vnl0m7b3MG5njs4OPaCgiWtZ22cm5nETo9alt2
pnqOriARXn66OLNIPMulvCES9iyvOJW81M38z5H3w0Lsg3FBmTdVOA8ZzhIkT9FR
8nE4OqrNlXF2sm7XLhpUOKz5qJ/1EJWm/jzLVIV41Cs74RPU93etmFsFZvycT/iN
hil3tNLZ1TjAdysfT0oOiHIplNsPiDyynLoRiRIYOd2ZysgtT7PkGHJZ8eF+eRjM
UgJSmXkaxNQChuRkIftWu8z64jUae18ShC+7wTqGJ9J1iOoh+N2Je7QuQRZJhsZI
pmmB4NZn8i5eb/ApTY+U
=Az2U
-----END PGP SIGNATURE-----

--=-PXSAMI9Om154rDRIcP0F--

