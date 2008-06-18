Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37729 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbYFRPvk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2008 11:51:40 -0400
Subject: Re: BUG: mac80211: Some connections hanging in 2.6.26-rc6...
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Price <andy@andrewprice.me.uk>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1213803761.1312.29.camel@johannes.berg> (sfid-20080618_174323_804226_F901A061)
References: <g38o2j$1uh$1@ger.gmane.org>
	 (sfid-20080617_181742_447297_198DA5E5) <1213773749.3803.155.camel@johannes.berg>
	 <g3b7l1$t1o$1@ger.gmane.org>
	 (sfid-20080618_165548_538551_7C9BA1D8)  <1213803761.1312.29.camel@johannes.berg>
	 (sfid-20080618_174323_804226_F901A061)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HAZlpTu5bLYGPmYh3KuQ"
Date: Wed, 18 Jun 2008 17:51:03 +0200
Message-Id: <1213804263.1312.31.camel@johannes.berg> (sfid-20080618_175143_631245_5DEBE4CB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HAZlpTu5bLYGPmYh3KuQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-06-18 at 17:42 +0200, Johannes Berg wrote:
> On Wed, 2008-06-18 at 15:55 +0100, Andrew Price wrote:
> > On 18/06/08 08:22, Johannes Berg wrote:
> > >> This also affects some http requests such as loading slashdot but no=
t
> > >> others (perhaps small ones?) such as twitter API http requests. It d=
oes
> > >> not seem to affect connections to other machines on my LAN, only one=
s
> > >> over the internet.
> > >>
> > >> I've tried tcpdumping to get more info but when I run tcpdump the
> > >> connections work again (if a tiny bit slower).
> > >=20
> > > Can you try tcpdump with the -p flag? promisc mode might affect thing=
s.
> >=20
> > I tried using -p and it made the bug go away again. However, I have som=
e
> > packet captures from running tcpdump on the router while the bug was
> > occuring and from loading them into wireshark it seems there are some
> > (suspected) retransmissions with bad checksums. I've posted my packet
> > captures here:
> >=20
> > http://sucs.org/~welshbyte/lw/tcpdump_bad0.pcap
> > http://sucs.org/~welshbyte/lw/tcpdump_bad1.pcap
> > http://sucs.org/~welshbyte/lw/tcpdump_good0.pcap
> >=20
> > The two 'bad' ones were captured on the router while the bug was
> > occuring. The 'good' one is for comparison and was captured on the
> > router like the others but while running tcpdump on my laptop made the
> > bug go away (I hope that makes sense).
> >=20
> > In all cases, the test was to ssh to a remote server. The two bad cases
> > were closed before the password prompt was reached and the good case wa=
s
> > ^C'd at the password prompt.
> >=20
> > I hope this helps,
>=20
> Thanks. Unfortunately, it's very hard to tell what is causing the bug,

No, that was worded wrong, I mean, we know what is causing the bug and
we know what the bug is, but due to encryption being used it's hard to
confirm from the tcpdump you posted.

johannes

--=-HAZlpTu5bLYGPmYh3KuQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIWS7jAAoJEKVg1VMiehFY6RwQAKRGKeLeI69gxCWLReRUar4a
F9cnPmh4UsovuOEXizJBOX01xYVMtLNLgOJQHoAstiD8ouAh2Z9lmsrzr4rvyyFK
OUNjbW5XpRZFEJUvMb9XLwZ/lgHrVALujZ0oP/krnfM4tobo927FWnaR2mWMkj0X
CE3G7VYIio3MBfN8K9/mH8VT39pbnFOPjLUKYMUPPuU6ReAOrFKrYF66O1lf9RUo
U4o0t7dGSmKiP+9bodXrGW0YtUZd/TqnigTJdAVVQr+ettfOoZvV0u4KFKhhJ6lh
u15g56dz50qqCtDVh9YnjSDhBNsi3ohSoVX8hE2Qhx+uVo9ndfc5m2ZngFJD9Hlo
sS+JBVbmmlzQpwzHk2H0Zx3uyrX8MowgMOphh9UVQI8iNdSZZwPzeurO1EppQL1+
/jsSdoQw2z2RcUih1A8o8Y+332rZklwCljt2xSnywzDd7gAEBD8AvVRRJ7Yf2otm
zXHXptRgjeBEt1MmItjH4rg4uvhKW96+qoV8XbDzhja8AtMaaBqpRdu0k7pJXbLo
Kl8SGSxd+GS0pmWM1IAUqWO2Kimy9AkXHnL/+/N7WdKuw2/foYtwcFypylcxu2xC
TpNbZSB9levSzWcOsJfv1vTmOZVlXcBwpZoLqoPK+9lmOF05wHXSJw0Hhv+9jevG
WMEIyuj44rWU6iH0RsGz
=zWyy
-----END PGP SIGNATURE-----

--=-HAZlpTu5bLYGPmYh3KuQ--

