Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42591 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbZCNPTB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 11:19:01 -0400
Subject: Re: [PATCH] mac80211: don't drop null frames during software scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090314144405.670.16447.stgit@tikku>
References: <20090314144405.670.16447.stgit@tikku>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XuGaEgnAPdvejzTbizzv"
Date: Sat, 14 Mar 2009 16:18:51 +0100
Message-Id: <1237043931.5235.67.camel@johannes.local> (sfid-20090314_161906_135050_25275FC9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XuGaEgnAPdvejzTbizzv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-03-14 at 16:44 +0200, Kalle Valo wrote:
> ieee80211_tx_h_check_assoc() was dropping everything else than probe
> requests during software scan. So the null frame with the power save
> bit was dropped and AP never received it. This meant that AP never
> buffered any frames for the station during software scan.
>=20
> Fix this by allowing to transmit both probe request and null frames
> during software scan. Tested with stlc45xx.

Would it make sense to reorder the scan code instead?

johannes

> Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
> ---
>=20
>  net/mac80211/tx.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index c3f0e95..f2494fc 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -193,7 +193,8 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *=
tx)
>  		return TX_CONTINUE;
> =20
>  	if (unlikely(tx->local->sw_scanning) &&
> -	    !ieee80211_is_probe_req(hdr->frame_control))
> +	    !ieee80211_is_probe_req(hdr->frame_control) &&
> +	    !ieee80211_is_nullfunc(hdr->frame_control))
>  		return TX_DROP;
> =20
>  	if (tx->sdata->vif.type =3D=3D NL80211_IFTYPE_MESH_POINT)
>=20
>=20

--=-XuGaEgnAPdvejzTbizzv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJu8rXAAoJEKVg1VMiehFYwHkQAI0G3WWvlpKLWFnnUgad9w9w
YqHDYmJ9ah5doa3PXOGIl5ho9Pvcs//bKfn1oiaQJAyVnX8yRWoCJOKfffi7VqUE
Dl1YR9KSiPDFWR8UEDgWj4NvydnjLKbx6GuUXI4PELGmBTFPz55j9qt1P/Dc86fx
QqYvnRIAtrUKPr45vFnllczH9E4t3XDXqQbXaN55s5s9db9RO9V9dbEsUMz9hSgS
RA3X2fAfRn3s5BRSmYh8VsHrhIlHWqJ2xYrCwwKLc5YTL4e520OK2aQPxjVLpuYI
gm/Jevc0Pe+f6LoGTqBtOcnH1vVA6cF+6+aCS5Q2bgGuFMzkcXaMpNtfzaEbiFHl
vzxyIRD+uj+AeWUZuCMOvZ2MVIN56hPzv1896zpG7Nk+JxHmwfU4OFFzzMRgzdqy
VuDcrd19hBs3eQPNjhjWVBqmnlmRiVU6nykDXUk33fbUn1hqoyiAh334hmShscOt
enyz6+NJ2MdGcaZa5aKgJ1BSfmsy0KUy7fdpjyCoFv/hwoOKikGWZARSQoBf7OA6
1dyfXpawmYMmBAsCnAmKOSfnUCsOX4sP0Om7VrubJsOeVuFF7/bA3ic2jo3Ah6uS
kFw6M5x2Lt0o0GnJnnoO/YxI3t/ZvANhjiDNo9fVqchjMCAuzbSv7Gsk316SWT68
Joxk3mrG4LgtA3nrskpw
=UdCM
-----END PGP SIGNATURE-----

--=-XuGaEgnAPdvejzTbizzv--

