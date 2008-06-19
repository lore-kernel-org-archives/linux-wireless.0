Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33521 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615AbYFSNY4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 09:24:56 -0400
Subject: Re: Broken fragmentation
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240806190608h3d833dbaua412446e8a9f560d@mail.gmail.com> (sfid-20080619_150803_298582_5210094B)
References: <1ba2fa240806190220l18fe5dcdsf44fe81412a5f35d@mail.gmail.com>
	 <1213869365.1312.48.camel@johannes.berg>
	 <1ba2fa240806190446n4d931e6ara4db156900e59e0d@mail.gmail.com>
	 <1ba2fa240806190457w20dfe2d5pf06829b26d2722a3@mail.gmail.com>
	 <1213878207.8967.6.camel@johannes.berg>
	 <1ba2fa240806190608h3d833dbaua412446e8a9f560d@mail.gmail.com>
	 (sfid-20080619_150803_298582_5210094B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tOyVlUzFH0Ef86K1sU1f"
Date: Thu, 19 Jun 2008 15:24:15 +0200
Message-Id: <1213881855.8967.19.camel@johannes.berg> (sfid-20080619_152529_164824_B17C9821)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tOyVlUzFH0Ef86K1sU1f
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-06-19 at 16:08 +0300, Tomas Winkler wrote:
> On Thu, Jun 19, 2008 at 3:23 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> >
> >> > Now it crashes in the driver...maybe the txinfo to cb changes. Looki=
ng into it.
> >> > Tomas
> >> Looks like this is the second part keyconf is null
> >
> > Part? You mean fragment? What encryption algorithm? I've quickly looked
> > and all of them seem to do the control.hw_key assignment in their
> > respective _skb handler so it should be done for all fragments.
>=20
> The problem is w/o crypto
> I think this is not set on each fragment
> info->flags |=3D IEEE80211_TX_CTL_DO_NOT_ENCRYPT;

Ouch, you're right, the whole tx info isn't properly initialised for
fragments.

Can you try putting

memcpy(frag->cb, first->cb, sizeof(first->cb));

at around line 690 of tx.c where this code is?

                frag->priority =3D first->priority;
                skb_reserve(frag, tx->local->tx_headroom +
                                  IEEE80211_ENCRYPT_HEADROOM);


[now I know what the cause is. I had another patch that used skb_segment
to do the fragmentation, but that was dropped and skb_segment does copy
skb->cb while our code doesn't]

johannes

--=-tOyVlUzFH0Ef86K1sU1f
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIWl37AAoJEKVg1VMiehFYH9gP/jBuTpEztyBY3gxtgOCtZa4u
VuSRrKj7FM0b6Tupnc4t+2JzE1ZKcf9OicztMWA/Ly9xwGO33AqeMsWgeiUhQljR
Dh/q6yoknFsZuWdqALEBm4+qFTrHSfb2ou24kQhIo7ezotQfpyco06cy2TtUYyBg
IZo3H/o79yuxFNzz5ME1orhUrRTQ2x8QjZjlYd6PFVPv2FK4MWsuC3BNk5OyL06H
qjVCR+YnVVzVRVU7h5rWqrEh8XbFJtDV7m6lCYoL5R8uQC6fe7fwG4oSr4A1bKcw
5LPGlFaQwu99ZLnnqy6/v2EXY325bL3UgqcI8Q1s8SPTfDZv16BGapthi8Ompcx4
3c+atrvt3Tg1pSodvE91NvtJuTFANm1477B7vzaN7wQxn5VT2GSLN5TboUneLegq
ogDlPkm9pO4hLhK8ChvEBONtDR2gu8FQ6mKFUxgW1mnq70sNe6p7pV3Lm+bpuJN6
AwB4755Sanj2+I3RK8z+6JqRV28KVSZNj5PtGD9IDop/5/uXRuSCFgEGsk4wGkej
5rbueROpvl+RMgyyfvjc9QX0awJf73kGTZSGGZWkwIBMx2/WUKzPdGQRs4R4ncSI
Id1EFcaWegdnM648m1EO2Wfle34hW03JuSwTXqe94YZK+yl7UuBIMgyftaZOK5lO
D6TNbCQ6GnNM0aSy7ORB
=7mhI
-----END PGP SIGNATURE-----

--=-tOyVlUzFH0Ef86K1sU1f--

