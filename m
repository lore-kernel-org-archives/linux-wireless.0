Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60995 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbYFSP1S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 11:27:18 -0400
Subject: Re: Broken fragmentation
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240806190745u2fe7e435y3ca207af4156767b@mail.gmail.com> (sfid-20080619_164537_995526_78112986)
References: <1ba2fa240806190220l18fe5dcdsf44fe81412a5f35d@mail.gmail.com>
	 <1213869365.1312.48.camel@johannes.berg>
	 <1ba2fa240806190446n4d931e6ara4db156900e59e0d@mail.gmail.com>
	 <1ba2fa240806190457w20dfe2d5pf06829b26d2722a3@mail.gmail.com>
	 <1213878207.8967.6.camel@johannes.berg>
	 <1ba2fa240806190608h3d833dbaua412446e8a9f560d@mail.gmail.com>
	 <1213881855.8967.19.camel@johannes.berg>
	 <1ba2fa240806190745u2fe7e435y3ca207af4156767b@mail.gmail.com>
	 (sfid-20080619_164537_995526_78112986)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zB5ddMPLRMeELdNu7/gX"
Date: Thu, 19 Jun 2008 17:26:40 +0200
Message-Id: <1213889200.8967.26.camel@johannes.berg> (sfid-20080619_172738_926688_C31293FC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zB5ddMPLRMeELdNu7/gX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-06-19 at 17:45 +0300, Tomas Winkler wrote:
> On Thu, Jun 19, 2008 at 4:24 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Thu, 2008-06-19 at 16:08 +0300, Tomas Winkler wrote:
> >> On Thu, Jun 19, 2008 at 3:23 PM, Johannes Berg
> >> <johannes@sipsolutions.net> wrote:
> >> >
> >> >> > Now it crashes in the driver...maybe the txinfo to cb changes. Lo=
oking into it.
> >> >> > Tomas
> >> >> Looks like this is the second part keyconf is null
> >> >
> >> > Part? You mean fragment? What encryption algorithm? I've quickly loo=
ked
> >> > and all of them seem to do the control.hw_key assignment in their
> >> > respective _skb handler so it should be done for all fragments.
> >>
> >> The problem is w/o crypto
> >> I think this is not set on each fragment
> >> info->flags |=3D IEEE80211_TX_CTL_DO_NOT_ENCRYPT;
> >
> > Ouch, you're right, the whole tx info isn't properly initialised for
> > fragments.
> >
> > Can you try putting
> >
> > memcpy(frag->cb, first->cb, sizeof(first->cb));
> >
> > at around line 690 of tx.c where this code is?
> >
> >                frag->priority =3D first->priority;
> >                skb_reserve(frag, tx->local->tx_headroom +
> >                                  IEEE80211_ENCRYPT_HEADROOM);
> >
> >
> > [now I know what the cause is. I had another patch that used skb_segmen=
t
> > to do the fragmentation, but that was dropped and skb_segment does copy
> > skb->cb while our code doesn't]
>=20
> No crash but still not at home. No fragmented traffic on the air...grrr.

Hmm, ok. I'll give it a try later.

johannes

--=-zB5ddMPLRMeELdNu7/gX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIWnqsAAoJEKVg1VMiehFYDesP/3CF2tfsTTdqPHJdyBo+gMS3
R/MSLi7lpTmjHTTlcAJxQUAUjUfZhjwcIsyN3FdLn6e+NV1tCOS2PWQm+leYkjcg
jWtGZlPji3sY56QgrnMf6pfzDZOvQN9s//gplfAdFhye1A5wre0EPrKNlA/n9Jes
T/nYKetym4mN80snl8xpAwFC3RPPorQmllUo+KFYomQWS8rSjJkWYF9hZqD8aM9q
Ejxa6tpK7xfIKyWsj79Le6AYueTXzkAlnGsbSMtplNWEK+vDRaph5XNHFynL768k
NA4fGPxI9WIrunvYiwxP4YH1DTKaeRx58e50JL4VpfKz7RA5Qaa136g2pO0XhPYm
I5aTz0POGVyulTV7g/jZdBtSGgLwRFHrCIAXwOcKDLLbadPXak2Xe3vgO/UQcmPH
0cgLcSrp98KsBXXqIIn0aUKgMUaUNP19wUeyY30RiRiNIoZJY/aLbhU+iugOb1Pa
oOS1Zt+IYCYxrNS23KmaN+YKP1x3gaScVQ1+ATKf7Skw6x5cLdvkU24o0PlKwjU8
fGNSpzlpGsG0EFx2+RrtckrQsO4zVU+xSEBoN7I7eDRshy0vtQ8eIJRSfdtXXY3J
s7QCJA+Y1sOIBFrS3fw8TixWLsnQVHZSllaQ5xr5ye36U1CPZuU6cbmpOu1pLI52
575XDACNV2fCTEL2/7gZ
=95gY
-----END PGP SIGNATURE-----

--=-zB5ddMPLRMeELdNu7/gX--

