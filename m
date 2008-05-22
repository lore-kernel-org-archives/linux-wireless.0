Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54540 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbYEVTRg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 15:17:36 -0400
Subject: Re: iwl4965 - wpa_supplicant can't see 5Ghz frequencies -
	2.6.26-rc1 kernel
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Vincent C Jones <v.jones@networkingunlimited.com>,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <egrumbach@gmail.com>
In-Reply-To: <1211480579.28022.5.camel@localhost.localdomain> (sfid-20080522_202259_554507_FBCF2252)
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
	 <1211480579.28022.5.camel@localhost.localdomain>
	 (sfid-20080522_202259_554507_FBCF2252)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hsGCpfJYnoVviYYgT9B1"
Date: Thu, 22 May 2008 21:16:19 +0200
Message-Id: <1211483779.3698.71.camel@johannes.berg> (sfid-20080522_211738_440909_9E6E0295)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hsGCpfJYnoVviYYgT9B1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >         memset(&iwe, 0, sizeof(iwe));
> >         iwe.cmd =3D SIOCGIWFREQ;
> > -       iwe.u.freq.m =3D bss->freq;
> > -       iwe.u.freq.e =3D 6;
> > +       iwe.u.freq.m =3D ieee80211_frequency_to_channel(bss->freq);
> > +       iwe.u.freq.e =3D 0;
> >         current_ev =3D iwe_stream_add_event(current_ev, end_buf, &iwe,
> >                                           IW_EV_FREQ_LEN);
> >=20
> >         memset(&iwe, 0, sizeof(iwe));
> >         iwe.cmd =3D SIOCGIWFREQ;
> > -       iwe.u.freq.m =3D ieee80211_frequency_to_channel(bss->freq);
> > -       iwe.u.freq.e =3D 0;
> > +       iwe.u.freq.m =3D bss->freq;
> > +       iwe.u.freq.e =3D 6;
> >         current_ev =3D iwe_stream_add_event(current_ev, end_buf, &iwe,
> >                                           IW_EV_FREQ_LEN);
>=20
> Wait a minute; what's mac80211 sending _two_ FREQ events for?  That's
> not right.

Why not? It has always done that, different units, one with channel and
one with freq, iwlist will show both which is very useful.

johannes

--=-hsGCpfJYnoVviYYgT9B1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDXGgaVg1VMiehFYAQInoA//cIwYvD4035HhFEMLOFZMlVwhNExTTff5
gXGrLVHJquro9QH6r3VXCdY+Ped8Jvw/x5sZw0Eua19uKD6ob62srA130lXlpsaD
AWCKtbV6leNxxLcjGs1PbmAkmiP+XnV9eLj1to4OaLzu8ybRvkxk+ROu47EcqfDS
mr6nds3AKlmjre7xrxEQImAFA7MSglUHHVziYsOKjs7rP0BE3Sd1i5TK/HxQRCjf
paLr5PGnCObqvZUjiLn7m4uTtSOqyHcCdD2X/n5Z6M0yV5IZLAvWp6sTMiw27mwl
rTPCULXywW9zAK3vVnA6OS0Emv/KhOdFp6PpkK6PtQxeogGAcJC1T1xIEbvQlX3L
Qg2zguMDl/f2PS1D73yys6ZKTKtzm4Y8q/YH0MOzRnJeQicvII8WgPKwmQNKHcXz
/z1a8HQr85vxbhlAyRKjRXLyyDEPtwMlGQrkrGJpRAXPSqTU0wzGyXYwTuwSjBHe
mMiV//db/pVLXjdD/8hLVLpy4uYpZWlaIR/nRyXCo5NKj9R3nQ6wVQ9utdJhoLaR
WsHa1YFJ0tS8aUGVdId+3d0M7ydvuFGU1KcPKvWuzjawuX1rvwtGkcj8udbM3FqK
ico8jAhQV6SWtlPUZhx9RwSmdxgj4dfglhgDRlNlGsiMBI9qUCD6x6js26i3hyio
tTcqDx4HiBQ=
=4qh4
-----END PGP SIGNATURE-----

--=-hsGCpfJYnoVviYYgT9B1--

