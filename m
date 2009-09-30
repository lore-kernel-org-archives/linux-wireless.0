Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54842 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802AbZI3VUm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2009 17:20:42 -0400
Subject: Re: Problems with "cfg80211: fix SME connect" commit
From: Johannes Berg <johannes@sipsolutions.net>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: Albert Herranz <albert_herranz@yahoo.es>,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <3ace41890909301417j5966336dn197a45cf66c2cd1e@mail.gmail.com>
References: <505407.87957.qm@web28315.mail.ukl.yahoo.com>
	 <200909210845.51247.hs4233@mail.mn-solutions.de>
	 <4AB7A5BB.1050300@yahoo.es> <1253779538.3868.14.camel@johannes.local>
	 <3ace41890909241213q5b4992a0sffd4c34a69ac9bb6@mail.gmail.com>
	 <1253859759.3868.569.camel@johannes.local>
	 <3ace41890909250854t3062d1betf89501e5775ccdd0@mail.gmail.com>
	 <1253965154.5122.7.camel@johannes.local>
	 <3ace41890909301417j5966336dn197a45cf66c2cd1e@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Q17rfdsX7LeC2isi5Y+Q"
Date: Wed, 30 Sep 2009 23:20:39 +0200
Message-Id: <1254345639.3959.16.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Q17rfdsX7LeC2isi5Y+Q
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-09-30 at 22:17 +0100, Hin-Tak Leung wrote:
> On Sat, Sep 26, 2009 at 12:39 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>=20
> > The extra deauth is because cfg80211 already starts the auth with the
> > BSS before wpa_supplicant set the BSSID, and then when setting the BSSI=
D
> > it asks for deauth, but before we ever actually did anything... I think
> > we'll just have to live with that, since it's hard to fix in the layere=
d
> > design we have now.
>=20
> Hmm, I looked at the AP log, and the deauth is there...

Yeah. I've thought of doing a fix in mac80211, but haven't gotten around
to it yet -- should be fairly easy tho.

>  also I think
> due to recent changes, association takes longer now. Is there
> something that can be done in userland, for example?

You can use -Dnl80211 with wpa_supplicant, but other than that we may or
may not scan a few times more or less, which is somewhat unfortunate.
Though it shouldn't be taking longer due to these specific recent
changes, in fact this should make it faster, if anything, I think.

johannes

--=-Q17rfdsX7LeC2isi5Y+Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKw8ukAAoJEODzc/N7+Qmav2MQALQZXrM2NGPn1DAhDjSO7H05
Ywr8MXO5dMg8WVKJme0xTZcPCCJpBk54ptY0OXbe8Oc5EhgtfRWnR+PyilDTOW7a
oy85naZSmTF1BJMSmN7G0RUlBpIKiz8g6Oaix5OFlErS1DktaJxqXNDEZC0+KIN0
RIg0G+bF6BVImlpVPhCHtb7497419Z6IL1+pdSZq/KNUu4pmSbaGSSUlM3lwzNFS
4B5i2J4WV2RnblHJwasnQK6piyJB2F6p14/eI8JH9Hr4OTGo5AyKmqChHqgdo824
WKI8HZhrSVZhBFpe8oDp4pBABlaQo3mEvTr2RDsIIQK3oiwteXGF+nstpT6C47EA
YkSNPQ+YdP7lJ8+RIzIf6P7NeElcjb/qF5sNagxdNQZKUo0YdjWPh/xDYGMrxWV5
BYgvkZI2A5n9SmHGtdFEsntRHjaXyDhojGX04TbpMC8OW0urEs5JyC03audYoLlu
V4eta0o0ZV6Wfjp9Fcba+utgM6GkKKf+i+iD1EtHUqZSojuE0PnI4bQNNk1m7OSO
qj1O6XlRF1K6oCOgr1Lh/raV/Js5kRxJxbrE94CbOk1xw+i/9LNML5/pxbXuxKnb
ddBynK+afFbstrPdvNz7c28zMmg9WqhuRRknnMrvjH3gNOyyp/1Pu66iXvVpY8H0
+qEio8GbhU9IsWsmXE9v
=IZ80
-----END PGP SIGNATURE-----

--=-Q17rfdsX7LeC2isi5Y+Q--

