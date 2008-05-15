Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55884 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbYEOLXV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2008 07:23:21 -0400
Subject: Re: [PATCH 5/5] mac80211: move TX info into skb->cb
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
In-Reply-To: <200805151332.35758.IvDoorn@gmail.com> (sfid-20080515_132012_242142_393CACB2)
References: <20080515105524.359863000@sipsolutions.net>
	 <20080515105948.820956000@sipsolutions.net>
	 <1210849867.8709.0.camel@johannes.berg>
	 <200805151332.35758.IvDoorn@gmail.com>
	 (sfid-20080515_132012_242142_393CACB2)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qETPJop0hMcTdeeKo7in"
Date: Thu, 15 May 2008 13:22:24 +0200
Message-Id: <1210850544.8709.3.camel@johannes.berg> (sfid-20080515_132325_363668_CCD87F94)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qETPJop0hMcTdeeKo7in
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > > A number of fixes were done by Ivo, as well as the rt2x00 part
> > > of this patch.
> >=20
> > I mangled it a bit though so you may want to check it, mac80211 now set=
s
> > REQ_TX_STATUS so you can use that for status reporting, but you can't
> > use it for queue kicking at least not in the future when mac80211 might
> > not set it on all frames.
>=20
> Well queue kicking from driver to mac80211 is in rt2x00 based on txdone
> events on a particular queue. (When frame was succesfully transmitted
> and is no longer full, then the queue will be awakened by rt2x00).

Yeah, but the patch you had sent me was removing the "driver generated"
flag, and I kept that around now for this purpose.

I have thought about this a bit, you may want to wait wrt. fragments
because I'm going to rewrite fragmentation, and then we could change the
mac80211/driver API to hand the driver an skb with all the fragments at
once instead of handing it each fragment one by one, thoughts?

johannes

--=-qETPJop0hMcTdeeKo7in
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCwc76Vg1VMiehFYAQJDChAAsciqjw8DnpU7d8N/HXp/gtInRhoDx9jk
dEsfiOo63XJl6QzzgWWclUVBrkpkVCFujPJZCP3qxhwD6U1nqc5+vv2Np9RlJpD6
dbb6vzPCteM30ic/dUujyJR5y/4/w1Psby8sVSAiADN7cP0NCMDHAUn/7F5EhytB
rh0aM99BpTeJPu1DDHnXmjAD4o4LLRF0p7Zk4fvYlyKTJbjQikTeU3wWnO+4gMtz
pyQGYdDfdJzfT3V96HAZzPpSSWoSmrMbV/gIp7Zets60g3zEijDcr15aI0sYN7RY
A8Nay8l16TKY7HybahzS8adIgVFGpwhk6NZKtWVx2q1oSIytUMNAEXYXS7VVu5/0
j0iLAjXs9WgYemIzjF+dPqcrSJDjuH7YDesj9YcfRJqGF6kq+rExZchutkj5O6SO
5OgD2tuRb1cMBpH/+Q1/4q80RjzslI5N04kTR2AnpVJ6UBi8MF+S95+F72wfy/Wb
QRzVxVqxvqfOomKluca4FjQbwRaWWMQOdJHFxrNxRJX4Cbd80zMqUED5BAMMObt3
2XjZJ6+21xtdg1TeSlIeOK8klCthvC+/EXgxHHuCDtDZyR5BM0hRGNqpFN4/AAZ6
Saphshf9CmXpPA+yH7+WMvLJI1WpCa5cKB0pWM3bZslHwYHyvxIWflhh9UMIEb66
czWAyTCqT4E=
=TJAm
-----END PGP SIGNATURE-----

--=-qETPJop0hMcTdeeKo7in--

