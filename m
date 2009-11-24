Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59301 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933603AbZKXR7F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 12:59:05 -0500
Subject: Re: [PATCH 2/2] mac80211: minstrel try all rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Adam Wozniak <awozniak@irobot.com>
Cc: Derek Smithies <derek@indranet.co.nz>,
	Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <4B0C1E0A.9020003@irobot.com>
References: <4AF0D54D.4090303@irobot.com>	 <4AFC655A.5020706@irobot.com>
	 <200911122103.27455.chunkeey@googlemail.com>	 <4AFC8E4F.5090307@irobot.com>
	 <4AFC8F0D.5020700@irobot.com>	 <1258097352.3899.75.camel@johannes.local>
	 <4AFDDF19.8060202@irobot.com>	 <1258191039.6167.40.camel@johannes.local>
	 <4B018B26.2070008@irobot.com>	 <1258392453.32159.28.camel@johannes.local>
	 <4B0192A6.9050808@irobot.com>
	 <alpine.DEB.2.00.0911170938380.3829@kauri.acheron.indranet.co.nz>
	 <4B01D4A5.7060204@irobot.com>
	 <alpine.DEB.2.00.0911171156210.3829@kauri.acheron.indranet.co.nz>
	 <4B01E298.3030602@irobot.com>
	 <alpine.DEB.2.00.0911171314470.3829@kauri.acheron.indranet.co.nz>
	 <1258443484.1375.8.camel@johannes.local> <4B02DFE3.9040602@irobot.com>
	 <4B0AEEE3.2050808@irobot.com> <1259018866.7094.189.camel@johannes.local>
	 <4B0B2F6E.7050907@irobot.com> <1259025067.7094.208.camel@johannes.local>
	 <4B0C1527.60305@irobot.com> <1259084493.3491.21.camel@johannes.local>
	 <4B0C1E0A.9020003@irobot.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-mq8bODj+X7sx106vIvGu"
Date: Tue, 24 Nov 2009 18:58:38 +0100
Message-ID: <1259085518.3491.24.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mq8bODj+X7sx106vIvGu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-11-24 at 09:55 -0800, Adam Wozniak wrote:
> Johannes Berg wrote:
> > On Tue, 2009-11-24 at 09:17 -0800, Adam Wozniak wrote:
> >  =20
> >> I do not believe 1/2 was a hack.  It really was possible to get to the=
=20
> >> end of that function and use that variable without it being assigned t=
he=20
> >> correct value.  Also, it is important to reinitialize the rate control=
=20
> >> layer when the list of usable rates changes.
> >>    =20
> > Ah, indeed. But I still don't think the rate control _init() function
> > should be called again.
> >  =20
> My first thought was to use rate_control_ops.rate_update (via rate.h's=20
> rate_control_rate_update() function).
>=20
> However, neither minstrel nor pid_algo implement it, and the only place=20
> it is actually used  is from ieee80211_enable_ht() (in mlme.c) when the=20
> channel type changes.
>=20
> So the only way (currently) to "update" is call _init() again.

I think I'd rather require that they implement it then, and add a new
flag that says "got new info on supported rates".

Or you can probably call rate_exit and rate_init but I don't know how
the algorithms would react if you actually ask it for a rate during that
race window?

johannes

--=-mq8bODj+X7sx106vIvGu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLDB7KAAoJEODzc/N7+QmaMRYP/AhU+gII30K44GFYJNXcKSrl
nUcaGrSWFt4deN9ETqeQb0slmG+5dXLvkBwyOMsc0GiwuFaL4zseuYNYCjyXTOX/
S+lPjoSfi933XArVrl/jXXr2PegIF5nkgxKiSsmd+piTY8XLUrLvjg0KfNprJJKa
2E8+pNtlPjF8A7pdVYAJquPyCjpurV1Bx19Ma5e5gioyIT90uMgA3WFTw7Lkk7j2
kNZ/YTG5Imk2UdFZci7+VnODv9zUg5XQwAWSFwXdnybwu6Gdizv0vb5GITIxqfmd
2X60KxdRqXZ5GOXEuuHHG+hJOh2HMeerN7UQW0S9Kqsw6pMnq2FvkhplfRMjbegS
EqwbelAOQncIK7Tklj9wzrSyX+bBDKUD46IxuajP8PyyZFiEee1bVGF6nrxQQgWm
tSgk7jVwwKkvDygsKiWVizwj4A3inKbySQpVJWLjrDIlU8syWxQNgxBE7kKt3Y4R
SgJzMia2u7cY6WK6bgScF+OkuRLxgti4mXLg3iHWn+zJuDtnjt6zojbqyLalF3xm
5Nt+8GZAAAO5HwxZ4pIKCuqIfcGz8NXISiRXmIRwLqqdkWchUMdyDLw3FPu0zymH
UXNNc8zcllgHuoU9SEpnV0lK2eb3tcLgeiLqwrZTghv9nA1wW28D29IjUb9i7NKz
Rp2DJFHE9JtvffDd9kaI
=szIp
-----END PGP SIGNATURE-----

--=-mq8bODj+X7sx106vIvGu--

