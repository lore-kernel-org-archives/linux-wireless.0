Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46348 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbXJHJzJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Oct 2007 05:55:09 -0400
Subject: Re: Mode selection in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Adam Baker <linux@baker-net.org.uk>
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <200710052319.10600.linux@baker-net.org.uk> (sfid-20071005_231916_055041_CD49F30E)
References: <200710052319.10600.linux@baker-net.org.uk>
	 (sfid-20071005_231916_055041_CD49F30E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CZfSutoKlT7JZ0CFBq99"
Date: Mon, 08 Oct 2007 11:55:39 +0200
Message-Id: <1191837339.4063.25.camel@johannes.berg> (sfid-20071008_105523_182608_B8F8BB3E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CZfSutoKlT7JZ0CFBq99
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-10-05 at 23:19 +0100, Adam Baker wrote:
> I've observed an undesirable change in behaviour of rt2x00 as a result of=
=20
> Johannes Berg's patch 3d4803379613c763f5a7863e8249b63d190af5e6
> (remove all prism2 ioctls).

> It used to consistently default to 802.11g mode on g capable hardware. Be=
cause=20
> that patch removed the lines
>=20
> -                               /* Use next_mode as the mode preference t=
o
> -                                * resolve non-unique channel numbers. */
> -                               if (set && mode->mode !=3D local->next_mo=
de)
> -                                       continue;
>=20
> in ieee80211_set_channel it now defaults to 11b unless I change the code =
that=20
> calls ieee80211_register_hwmode. (I realise that the next_mode test is no=
=20
> longer "right").
>=20
> This is because ieee80211_set_channel will now prefer to select whichever=
 was=20
> the last mode for which the driver called ieee80211_register_hwmode where=
as=20
> the previous behaviour preferred the first registered mode. It seems as=20
> though if there was a way to avoid calling Iieee80211_set_channel then th=
e=20
> setting of oper_hw_mode in ieee80211_register_hwmode would still prefer t=
he=20
> first registered mode.

Yeah, you're right, it was too much to remove the whole conditional and
the continue, I should've just removed the && mode stuff. Will post a
patch to add it back.

> Is it intended that the order of calling ieee80211_register_hwmode should=
=20
> determine which mode should be preferred when multiple modes exist on the=
=20
> same channel or is there either already or planned a better option for dr=
iver=20
> writers? If calling order should determine preference should it be first =
or=20
> last registered?

That's actually a can of worms. Luis is working (I hope) on resolving
these issues with mode vs. frequency selection. However, I'm not
entirely convinced that mode selection should be done by userspace when
we are acting as a client. I think we should simply exploit hardware
capabilities as much as possible and then use the set that the AP
advertised (or rather as much as we can support of that).

Hence, for these questions it'd be good to know whether the ralink
drivers do anything different based on the selected mode, and if they do
(I assume they do because they register B *and* G modes) what it is.
It'd probably help a lot with the design of the interface if you could
answer that. I feel that mode selection should not be necessary since in
G mode a device needs to have the capability to talk to B-only stations
and hence must be able to "fall back" to B mode, we should therefore be
able to exploit that capability without the driver ever registering
different modes.

In fact, I think that the driver can probably simply register the
modulations/bitrates it can support orthogonally to the frequencies it
supports, and the frequencies consist of only information about the
frequency and possibly hardware value used to select it. This was part
of what I posted a while ago when Luis was posting his regulatory stuff,
and I think should be addressed while cleaning up that whole mess.

Thanks,
johannes

--=-CZfSutoKlT7JZ0CFBq99
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARwn+mqVg1VMiehFYAQIwuw/9GGlq9KZyTOq+dkTcZtiLa/UaPNO6kwQX
UT1/ZcRr3O07EMuFKpyG26WDJGV/wC49XmRd1amPxiLLjIh8BDwTzDeDubICHVVA
Fu5+1v3b2PlzFo6EWCGXCWExf4Nj5GHYM+Uctg4lUEm/zytigdEwU6PPkSP8ChVr
+GM2pt8vwWK2z4EjdMgWHm7+QM7mBkGXnYZXaFC/mro59NE0OOr4s5N86tJKdBY9
BWVdTtFt8jNlNe/Po5mVGXZuRUPnM9C6vxUoZoMT2Bao4RnhheR9SUYwe5BFwDIc
w4GNYo6ljQyje+8oB9v76/sj/fdonIIRBKs3fwjcSNch0bR/pRrrDBoZSCg0GGsq
2Hm6Bmmd6FyDFqlf8VjflOyhWBmqz/QLCOpMyc3LdDkZ3gmg8jhd3UFcNsv+1Pql
NimHoqBNZhTiuSdUR33VXukDt+teGvCZ8/K4SbIHu/PajM1VbLeG+dGYGMFtxUdb
TvEXW4tJ7ypvfFqxOUZP4/0uGaCshOtJUNTEWVtFRScUetCfA7v/3ea1WuUUiXHM
4tIytrgbXdkzR8BKhhoQE+bTTgTlhNxY+BBqbG+qGBZHyX7L1TFRZiusruCHSXvk
gFyrNInEZvXnQDRTy0Zul4En90/Uu67+Qt0HX90VlRT1PFhAwpinEoDCvEwf4wMV
dxIguwHfFnU=
=vx+b
-----END PGP SIGNATURE-----

--=-CZfSutoKlT7JZ0CFBq99--

