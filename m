Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41107 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbZKMOrS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 09:47:18 -0500
Subject: Re: R:Re: [ath9k-devel] Possible memory leak in ath9k monitor mode
  injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Matteo Croce <technoboy85@gmail.com>
Cc: Lorenzo.Bianconi83@gmail.com, linux-wireless@vger.kernel.org,
	alessandro.erta@gmail.com
In-Reply-To: <40101cc30911130642j549538cfmac13ebb320d33f7@mail.gmail.com>
References: <f74418680911130055o7d8fa94brc3fd7a0c315bb7b0@mail.gmail.com>
	 <0015174c1d0a8aa23304783ef2ae@google.com>
	 <40101cc30911130642j549538cfmac13ebb320d33f7@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-xkZ69jnKYgvDhYH00xG8"
Date: Fri, 13 Nov 2009 15:47:20 +0100
Message-ID: <1258123640.6167.24.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xkZ69jnKYgvDhYH00xG8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-11-13 at 15:42 +0100, Matteo Croce wrote:

> > - if (frame_type =3D=3D ATH9K_NOT_INTERNAL)
> > + if (frame_type =3D=3D ATH9K_NOT_INTERNAL) {
> > ieee80211_tx_status(hw, skb);
> > - else
> > + kfree(tx_info_priv);
> > + } else
> > ath9k_tx_status(hw, skb);
> > }
>=20
> What about adding that line in ieee80211_tx_status() instead of
> ath_tx_complete()?
> That will hopefully fix other drivers too.

Umm, no, this is an atheros-ism that ought to be removed anyway, but
it's not possible this particular problem affects other drivers.

johannes

--=-xkZ69jnKYgvDhYH00xG8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK/XF1AAoJEODzc/N7+QmawB8P/jK8XodQkU5+k66z7gQvZ12z
zsH3vAkl1muM5E8hPR+0a0tAAv5kD3iijpv7SGgLI42gTQzKLRDqMMJTipUIlBwM
VMKW/jbe9nxmc8y0cgE2abjn8BhJqwFCw2q9PfaCXrXq84/4l++kzSQxlphekVrO
Ciqv84t2PFdGTNlP+HwfICBcSuDZ0ut6KW5TG0U7WEGaGT35Yaxd7ciVqmlD83qh
hfjKDwTXTECSpw5uNRWDGovxPpFJX9THtWTff3S6FRguJR3iuPsGqQ2LSNHe1wao
nYEA3taR7N8oQvo4ws+DLuxoAZ70UIsIJ8Cl3OfifEJ71FDSW3W7e08FGdTzci6F
tM/u7c0SQDIlSXATIOS53RuQs0vRy2Xfvw8XXMkXz3mGIi9DfVkuCppHmoG/2Q9N
5oZ14i8k/pBL2DwksEuUzjnRmDSW2rzhYYYwtCE+ndC9o5BQSc/NgUxxBflT16AS
kgKizCcaOW2hrIb+PqozCWUgiAQYNVcQ1lrOKEssQ6i72XVV7RV4cUXvnbAKMf8P
e1RvxlQXexON/EZ8XHA254CKkDgXCDB8fNYRhdR1w1+wy5pQrZTf/J8geEBhHy7u
JCwAFsVNLEmxvPG4DlrmSalNu86Qf4ARnOEPIui6Vmn/RWZHNzL77FRHMKAARdGm
d5wikkLrr9xWn0nN3IBg
=LElo
-----END PGP SIGNATURE-----

--=-xkZ69jnKYgvDhYH00xG8--

