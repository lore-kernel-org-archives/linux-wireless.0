Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49458 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036AbYEVR5P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 13:57:15 -0400
Subject: Re: iwl4965 - wpa_supplicant can't see 5Ghz frequencies -
	2.6.26-rc1 kernel
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Vincent C Jones <v.jones@networkingunlimited.com>,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <egrumbach@gmail.com>
In-Reply-To: <1ba2fa240805220953u746d3429q50faa1885104cadb@mail.gmail.com> (sfid-20080522_185359_028598_D17C0097)
References: <1210352234.3763.23.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805091712gccaec9cibdab621e8d1c9ba7@mail.gmail.com>
	 <1210430367.3778.9.camel@X61.NetworkingUnlimited.com>
	 <1210434402.3787.7.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805101156q4dc52c2bt47d2f6e51b611eea@mail.gmail.com>
	 <1210456110.3787.26.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805101506p78c3eeb6q6e980ac4200fd56f@mail.gmail.com>
	 <1210474179.3787.31.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805120950mf983e97qac4cdfa2c84b6662@mail.gmail.com>
	 <1210617467.3792.4.camel@X61.DFGI.com>
	 <1ba2fa240805220953u746d3429q50faa1885104cadb@mail.gmail.com>
	 (sfid-20080522_185359_028598_D17C0097)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cVD9spdQyhhxo5M15/oM"
Date: Thu, 22 May 2008 19:56:09 +0200
Message-Id: <1211478969.3698.56.camel@johannes.berg> (sfid-20080522_195718_726818_E6B27568)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cVD9spdQyhhxo5M15/oM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


>         memset(&iwe, 0, sizeof(iwe));
>         iwe.cmd =3D SIOCGIWFREQ;
> -       iwe.u.freq.m =3D bss->freq;
> -       iwe.u.freq.e =3D 6;
> +       iwe.u.freq.m =3D ieee80211_frequency_to_channel(bss->freq);
> +       iwe.u.freq.e =3D 0;
>         current_ev =3D iwe_stream_add_event(current_ev, end_buf, &iwe,
>                                           IW_EV_FREQ_LEN);
>=20
>         memset(&iwe, 0, sizeof(iwe));
>         iwe.cmd =3D SIOCGIWFREQ;
> -       iwe.u.freq.m =3D ieee80211_frequency_to_channel(bss->freq);
> -       iwe.u.freq.e =3D 0;
> +       iwe.u.freq.m =3D bss->freq;
> +       iwe.u.freq.e =3D 6;
>         current_ev =3D iwe_stream_add_event(current_ev, end_buf, &iwe,
>                                           IW_EV_FREQ_LEN);

That doesn't make any sense, can you explain?

johannes

--=-cVD9spdQyhhxo5M15/oM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDWzuKVg1VMiehFYAQKQqQ//b+UsWONLJZgNFVDRcefaVuGeyvg2ftk8
+fUWgw7HOvay4qG456tp/qVgwji3ESOKdQyCmnP5/ul0iAtrRoilBAYTMuLnyua2
Y4Nw3cOXgLv9U/NVb0uKu4tjD28pSiTOfEeRpgF1vcGJlX26zDsTjL+zfPJZTTRT
+qxgw6nWaDFRthkbgoKl28EcdXfX56OHMevF765rP5HN0vpLXnZMi6O+MNv4EnPy
RRSzs/Y8H4gXx9ALKwCZv3vrUGEl6i0VLZv4AOwewQEUEejswnYH2JtNJt11JPFn
6cZAji+iFseICutP9Y6aLa0JA6/pl/r9tBmSiE5b4/RNz8L62+gcGriVQZ3S34UW
6/r+zHtrFvcSmIziAU7rDoh/ROEYmIQbVMvI0TP5VcNlt2sA9hLowtHX4naL1S6H
SD6AZ2q0HsmKRGd1mWvIbO1fljpj9j/bgdf8y2ZCgnOf7fanXtBJdZu1jEg7zO2b
wPcOHIXcAGB3rwkPaRMpUGHWWMcaD6VTIeHhMHjv5TpAWQg3uqVw3NssmKvcI5f6
d7h/supYEAxLxrw2RA6bDQ3LPnpxOlVUwWPm1gxSy3Np7b4an0phoh8x01IGcom5
A489Ehch7qUS0ARC5JvXXkl9WfxmdYxIS+FFYjpfJQFicbL967iSlrOtFw3jWJnR
Y5e+wHB0s0Y=
=VSeU
-----END PGP SIGNATURE-----

--=-cVD9spdQyhhxo5M15/oM--

