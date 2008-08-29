Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35752 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbYH2Hb1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2008 03:31:27 -0400
Subject: Re: iwl5000 oopses
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Ian Schram <ischram@telenet.be>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240808281715u7a0a5bc6w286e3905afe181ac@mail.gmail.com> (sfid-20080829_021547_632727_8E29836D)
References: <1217937364.3603.37.camel@johannes.berg>
	 <1217938927.3603.40.camel@johannes.berg>
	 <1ba2fa240808050820j1aa0ae7cj11f2758caa5ba4df@mail.gmail.com>
	 <1219919760.8434.5.camel@johannes.berg>
	 <1ba2fa240808280439m3524d17cm63deebdfc0d5b9dd@mail.gmail.com>
	 <1219925859.25321.10.camel@johannes.berg>
	 <1ba2fa240808280752t4b41996au43bf4cb1a61b7967@mail.gmail.com>
	 <48B6C7EA.7080606@telenet.be>
	 <1ba2fa240808281430q7be3bb1eg8724af7247372efb@mail.gmail.com>
	 <48B73BB8.7000302@telenet.be>
	 <1ba2fa240808281715u7a0a5bc6w286e3905afe181ac@mail.gmail.com>
	 (sfid-20080829_021547_632727_8E29836D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4UXS983LG0qAnYIEzOKd"
Date: Fri, 29 Aug 2008 09:30:49 +0200
Message-Id: <1219995049.25321.20.camel@johannes.berg> (sfid-20080829_093131_067052_F8B6AB69)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4UXS983LG0qAnYIEzOKd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >> ' Error wrong command queue 43 command id ___0x6B___'  6b looks more
> >> like slub poison -- accessing already freed skb
> >>
>=20
> >
> > hmm, 0x6B indeed is not a documented command ID...
> > Only triggering under load must point to some overflow or race i guess.
> >
> Yep.

Though the queue number actually keeps varying, it wasn't always 43, but
you're right, 0x6b sounds like poison.

Have you enabled poison on your test machines?

> > I should get myself a new laptop to be able to play with this...
> > The best i can do now, is wonder if this patch
> > "[PATCH 08/10] iwlwifi: decrement rx skb counter in scan abort handler"
> > might be responsible, but that's just fuzzy string matching "recent pat=
ches"
> > with
> > "freed skb" ;-)
>=20
> No, that's a good patch.. Johannes failure looks like he got it right
> in the begining before scanning.
> We need open more logs and check what slub allocator is in use

Indeed, I'm using slub on a 6.5G 64-bit powerpc box with IOMMU so
there's lots of room for differences...

johannes

--=-4UXS983LG0qAnYIEzOKd
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIt6WlAAoJEKVg1VMiehFYUZkP/jGBmOqQM5z0Dt2ia7PBujki
941tio9wtxfDKSCYoMw2yor6jZfzUxkXl7/5X+jCj1LLc6OM4cFlQaVEYSYFoiYG
EfCB4wafQki/8tF6R9xOh2Ont1zgtLeCy6nS2+kw5xn82IXjkEflW1JycOfFBL+2
ufjt96TpqFqJzYkrBKokvEnZfYqyHgbO22nLMoVhZWmAzTrsIrUbgojt+cK6Mh3j
riqmY9yDhcyiwkqz30vQPjo0ykYDJKMY/y6EsLqPWTIebRtyrEjy17xK/fQ++kqz
eFxrAyU8oav6kdLSC84dEVshUxeAihBicefaFTSimgK2dj57eBuWdDKtH8pUOTn4
hBbeJDDKtmMxPWdj4pkULPwxvwEWTjs5w2Nqrj+DUqEPcdZi1mStmXnWveqtdnCt
l5m7jRnhUip2FefhczJgMZsucF2FLKAkdVXnrgfTcf8t6o+qkTGuNaUH5iRE97dD
x9oiKp9g+oUb/PyI5Cwix3p7k6ie7vV+1nMHlzJCwjFS5ziaIStPCMvXotpW4SsM
t2cafGtMWo1x2H8n/YM8DlfmK5XFFzuL7/RoPDPEqFxpG19DRXlaiNCFF6oTpyN9
iaIbuatafhugrGwHCCDENwTgAyK0F2Z/LzJamfjf+0oMyncm4L3GiqPAjXibg0mH
mEB/z53vP20lOOzYov/i
=t206
-----END PGP SIGNATURE-----

--=-4UXS983LG0qAnYIEzOKd--

