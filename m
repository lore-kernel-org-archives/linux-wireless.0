Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59332 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbZCPKx1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 06:53:27 -0400
Subject: Re: [PATCH v2] mac80211: Tear down aggregation sessions for
 suspend/resume
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	"me@bobcopeland.com" <me@bobcopeland.com>
In-Reply-To: <18878.11082.119745.2048@gargle.gargle.HOWL>
References: <18878.8417.960342.116534@gargle.gargle.HOWL>
	 <1237198307.27769.8.camel@johannes.local>
	 <18878.11082.119745.2048@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-s0DVjkfo/3NInabvVUIK"
Date: Mon, 16 Mar 2009 11:53:22 +0100
Message-Id: <1237200802.27769.17.camel@johannes.local> (sfid-20090316_115346_363963_CE7DD83B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-s0DVjkfo/3NInabvVUIK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-16 at 16:04 +0530, Sujith wrote:
> Johannes Berg wrote:
> > On Mon, 2009-03-16 at 15:20 +0530, Sujith wrote:
> > > When the driver has been notified with a STA_REMOVE, it tears down
> > > the internal ADDBA state. On resume, trying to initiate aggregation w=
ould
> > > fail because mac80211 has not cleared the operational state for that =
<TID,STA>.
> > > This can be fixed by tearing down the existing sessions on a suspend.
> > >=20
> > > Also, the driver can initiate a new BA session when suspend is in pro=
gress.
> > > This is fixed by marking the station as being in suspend state and
> > > denying ADDBA requests for such STAs.
> > >=20
> > > Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> >=20
> > Looks good to me, thanks. Should we really set a per-station flag
> > though? It seems a "local->suspended" would be sufficient and much
> > cheaper?
>=20
> I did consider it, but then was unsure of the locking required.
> If that can be clarified, I will change this to be a ieee80211_local vari=
able.

Good catch, that does seem a little complicated. This way is good
anyway, so let's stick to it, at least for now.

johannes

--=-s0DVjkfo/3NInabvVUIK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJvi+gAAoJEKVg1VMiehFY80YP/0Qh7bCJmW8+wg6sjPvkGQyZ
q942UHBN3E3gt3NvOX1/nRe5dLqxa+12eEz/RArsMtAfxz4xBgM1EjONb+Vc0TWL
flGNBZcJxNLwT+Fa3Mrtc1HIw/wi+ovPhjCzUR1vj4OFuWOtc6reExYd749i/xxF
a3IKeeE7OVsBIlqUQx3HGUn1Ink10BvcXXqCLvEU7cLiWkCApMBGz8RPSMIKuLxb
3Y4cQqPWeYnut4F1jxtFBSPmg2u+KU3AQve1X98JqJAoqEwPwzBKwluyAdjOar3l
sRWPt1i5Z8ZoThouADOslb0/eii/uMo/2QY+DI2ssgcsQ6noCPRAJExIMC9xO8qm
7ZJyvc0clHGs+j0MBs84IxOPby4whPc4dqNd2PrcxR77/4hwjT2DFa64/6RKYbZY
rYsfV5u7+6ar2i5eYLRbQrfbn0R7BZzsSr3Q1WBrUdWrpxTFi2mQbMmC3pWnEMyP
0u86143cn+/LHdzIBCOnEnrQxkF+iM0bJPVHA0BaLMQxaHZnbEBQJAw5fMkyam+l
PGZz8GFkvv3WVlsYBojkE1kRUKON4DtPv/F9qPVj6gj4USvCF11g7lpmkO3+BTRz
qc+OQRqp9rYgOm4zbriLd3JtQCVqCnuaEw7UguyrUao/K6Y28SBgNTYdiX9+iMh5
qNlQ66K7VTBjmm2RPO+E
=4AaV
-----END PGP SIGNATURE-----

--=-s0DVjkfo/3NInabvVUIK--

