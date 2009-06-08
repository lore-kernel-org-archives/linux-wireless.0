Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43257 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788AbZFHKha (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 06:37:30 -0400
Subject: Re: [PATCH] sony-laptop: no need to unblock rfkill on load
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Mattia Dongili <malattia@linux.it>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linux acpi <linux-acpi@vger.kernel.org>
In-Reply-To: <4A2CE86F.9040209@tuffmail.co.uk>
References: <4A2CE86F.9040209@tuffmail.co.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Flzcq0yO0lFY1h0+Admj"
Date: Mon, 08 Jun 2009 12:36:58 +0200
Message-Id: <1244457418.18863.8.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Flzcq0yO0lFY1h0+Admj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-06-08 at 11:31 +0100, Alan Jenkins wrote:
> The re-written rfkill core ensures rfkill devices are initialized to
> the system default state.  The core calls set_block after registration
> so the driver shouldn't need to.
>=20
> Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>

Good catch, thanks.

> ---
>=20
> This patch applies on top of the rfkill rewrite in the wireless-testing t=
ree.
>=20
> diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/so=
ny-laptop.c
> index aec0b27..c1b21a4 100644
> --- a/drivers/platform/x86/sony-laptop.c
> +++ b/drivers/platform/x86/sony-laptop.c
> @@ -1114,7 +1114,6 @@ static int sony_nc_setup_rfkill(struct acpi_device =
*device,
>  		return err;
>  	}
>  	sony_rfkill_devices[nc_type] =3D rfk;
> -	sony_nc_rfkill_set((void *)nc_type, false);
>  	return err;
>  }
> =20
>=20
>=20

--=-Flzcq0yO0lFY1h0+Admj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKLOnHAAoJEODzc/N7+QmacVsP/3sa0lRqRIWWET7G2oGyV24q
PE+elMKUu8fZp+WOGgMsUhbyAOFwCSd92eNQ4YIEV1dpiNgfi1du4zGe5/e1I7BN
K7P6Y42LyFfU+T/Pb7Hx49AKbh3woy5bhcD7WajnPagAlP41Vnx9jglvjJMdQqYJ
u+sw1omOwA9MYYuT1kETfg8W/joo+tpk2UIBd9J9lwAZZ7WSTA/OAwv5TOJmP2/5
qeGY8Ga58kBCPPLeid3T6vVPLwLiOKWj27MGR1evu2MpklmlYW+U5wNoG1AfJ9zk
fyt7osuRxEURKd5VvlUBZVJNgKOGKjcQ3/7RPCNGnKCIehh3hgsTQhnJ2ZO3f1Su
xYZucAY6Afa2QxLYjuC7i3/FkvRRaojUGFwKJVnrzdSYMRFmn3Bc9YTliWdDryXg
mjIKHELlBPA5PyNpdnpmil0SR6KlO7BsCeaOgN/fFzlSg5mLwfmD7mIjkMYOPSYX
Oo2nC4IDajJPslh/bi2Slcv+p5j29uL8+2mtUjoEw2WT4SpToad0Uh8e33mQF2Ze
jDXAQFgo0Ypv4NLSoXqEis1TcYqveMqFW1lp8RkKhbYSwAAlxKJID/GU7bzkK71p
sJOodohkw0IonPanYQI91N68bspSycuE+k/XfX4dy4NnjTh/s8Ii6jt4O/2d9Wvc
i4huYi7Lt3i26a1adnuu
=4yk4
-----END PGP SIGNATURE-----

--=-Flzcq0yO0lFY1h0+Admj--

