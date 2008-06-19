Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35335 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759415AbYFSSRn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 14:17:43 -0400
Subject: Re: Broken fragmentation
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240806191113nd6a221eiac9648edd3404a80@mail.gmail.com> (sfid-20080619_201352_223234_D04C033E)
References: <1ba2fa240806190220l18fe5dcdsf44fe81412a5f35d@mail.gmail.com>
	 <1213869365.1312.48.camel@johannes.berg>
	 <1ba2fa240806190446n4d931e6ara4db156900e59e0d@mail.gmail.com>
	 <1ba2fa240806190457w20dfe2d5pf06829b26d2722a3@mail.gmail.com>
	 <1213878207.8967.6.camel@johannes.berg>
	 <1ba2fa240806190608h3d833dbaua412446e8a9f560d@mail.gmail.com>
	 <1213881855.8967.19.camel@johannes.berg>
	 <1ba2fa240806190745u2fe7e435y3ca207af4156767b@mail.gmail.com>
	 <1213889200.8967.26.camel@johannes.berg>
	 <1ba2fa240806191113nd6a221eiac9648edd3404a80@mail.gmail.com>
	 (sfid-20080619_201352_223234_D04C033E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-82nonJUmvMGchHTRG5gk"
Date: Thu, 19 Jun 2008 20:16:59 +0200
Message-Id: <1213899419.8967.59.camel@johannes.berg> (sfid-20080619_201813_107016_8007C908)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-82nonJUmvMGchHTRG5gk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-06-19 at 21:13 +0300, Tomas Winkler wrote:
> On Thu, Jun 19, 2008 at 6:26 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Thu, 2008-06-19 at 17:45 +0300, Tomas Winkler wrote:
> >> On Thu, Jun 19, 2008 at 4:24 PM, Johannes Berg
> >> <johannes@sipsolutions.net> wrote:
> >> > On Thu, 2008-06-19 at 16:08 +0300, Tomas Winkler wrote:
> >> >> On Thu, Jun 19, 2008 at 3:23 PM, Johannes Berg
> >> >> <johannes@sipsolutions.net> wrote:
> >> >> >
> >> >> >> > Now it crashes in the driver...maybe the txinfo to cb changes.=
 Looking into it.
> >> >> >> > Tomas
> >> >> >> Looks like this is the second part keyconf is null
> >> >> >
> >> >> > Part? You mean fragment? What encryption algorithm? I've quickly =
looked
> >> >> > and all of them seem to do the control.hw_key assignment in their
> >> >> > respective _skb handler so it should be done for all fragments.
> >> >>
> >> >> The problem is w/o crypto
> >> >> I think this is not set on each fragment
> >> >> info->flags |=3D IEEE80211_TX_CTL_DO_NOT_ENCRYPT;
> >> >
> >> > Ouch, you're right, the whole tx info isn't properly initialised for
> >> > fragments.
> >> >
> >> > Can you try putting
> >> >
> >> > memcpy(frag->cb, first->cb, sizeof(first->cb));
> >> >
> >> > at around line 690 of tx.c where this code is?
> >> >
> >> >                frag->priority =3D first->priority;
> >> >                skb_reserve(frag, tx->local->tx_headroom +
> >> >                                  IEEE80211_ENCRYPT_HEADROOM);
> >> >
> >> >
> >> > [now I know what the cause is. I had another patch that used skb_seg=
ment
> >> > to do the fragmentation, but that was dropped and skb_segment does c=
opy
> >> > skb->cb while our code doesn't]
> >>
> >> No crash but still not at home. No fragmented traffic on the air...grr=
r.
> >
> > Hmm, ok. I'll give it a try later.
>=20
> Fragments are in the air but the peer is not able to reassemble them.
> Something is wrong with the first fragment but I'm not sure yet.

Hm, ok. got a packet capture? Maybe that was broken before, I remember
having problems with fragmentation but putting it down to the
known-to-be-completely-broken AP I was using.

johannes

--=-82nonJUmvMGchHTRG5gk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIWqKXAAoJEKVg1VMiehFYHZsP/2aji1bMSLcPIsM4ge+UvW0W
qdzyfMFzYstlu2jDAxj7zrB4GIfxL+XgudMTztJdCNfjGgxnfNa1BmgKoEDvEpzV
lscCFa29gtnTZlnwcm4oAUV416nP023I3Hf8ox8IgG3R2sIAh9G+56UF6aV3CHJa
OE0a1iq3TFN65mqDjgeUbNQBrVEKxSZsI7eMZTuIs/biJmfEF1g7UmSWT+X4ronR
vvZwDUN3ZzJADcZ48MaON7s6S4fBCob88La77WnKx5gZaavN4zpyn2tQ86DHrtLx
Vpd1N5C4BMdkVV0DvzA4r96knISNo2pgGiNss58tRRODo9rwH3KuBb+53p5j6Xj2
amExK4Q3CcO4nvUZOTqjVeodawc51Egy44Sib9Nrv8hm2/J1Ls2uu1doS1KfKunb
OuM1TJl1Kmiy85atYup67dwMnsvEMjGgZHiyED+yq4sazACbV55MhuasXfSK6lW8
TZnkRyfPp5KywP2nAmdACSJwkdGkh8IaHdKhvpzobDLR80kZbLL+1Y8C87EmTHOt
wRwDxb+d7p+ZXu9bL8D2eE6idcggp6v9n/xTUk/ByqVR8DqXBVUprp+jAlWiX0zn
1WNJuoEObgpg9WORNjb1/iiahYbSGEdC0qOTGirWVl38Wug702FMvx3/J4OYyccq
qyj0L8ix9b8ZACD1fzWm
=rhUz
-----END PGP SIGNATURE-----

--=-82nonJUmvMGchHTRG5gk--

