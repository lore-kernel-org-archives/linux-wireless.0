Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36948 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522AbYGIN7j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 09:59:39 -0400
Subject: Re: [PATCH 1/3] mac80211: Include sequence number in IBSS and Mesh
	beacons
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <200807091604.50199.IvDoorn@gmail.com> (sfid-20080709_155602_061102_EFE27B91)
References: <200807091511.14288.IvDoorn@gmail.com>
	 <200807091511.45779.IvDoorn@gmail.com> <200807091538.09387.mb@bu3sch.de>
	 <200807091604.50199.IvDoorn@gmail.com>
	 (sfid-20080709_155602_061102_EFE27B91)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ngurhD+aE89nVH7aBrsr"
Date: Wed, 09 Jul 2008 15:58:51 +0200
Message-Id: <1215611931.3246.8.camel@johannes.berg> (sfid-20080709_155943_030466_82676368)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ngurhD+aE89nVH7aBrsr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-09 at 16:04 +0200, Ivo van Doorn wrote:
> On Wednesday 09 July 2008, Michael Buesch wrote:
> > On Wednesday 09 July 2008 15:11:45 Ivo van Doorn wrote:
> > > Currently only beacons generated in AP mode have the software
> > > sequence number inserted. This means IBSS and Mesh mode are broken
> > > for all hardware that require software sequence numbers.
> >=20
> > Does software seq numbering even work at all?
> > What about packets that get sent between the driver requested the
> > beacon and the driver does actually queue it?
>=20
> For rt2x00 the beacon is requested and queued within interrupt context
> or during resume when it doesn't allow mac80211 to send any frames yet.

Ok, in interrupt context definitely works.

> The problem would be when the config_interface() is called, if during tha=
t
> call mac80211 also sends out TX frames, then you get problems in the
> sequence counting.

Well, if you care about the beacon in config_interface() you're
implementing hwseq since otherwise you'd only request it when you need
it, no?

johannes

--=-ngurhD+aE89nVH7aBrsr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIdMQYAAoJEKVg1VMiehFYJz8QAKY+TAq9DPG29Snw1p/4y8qg
LE8W1yokBQGu6P7YIORwlqEG2MsWpZklWt8e5tlCJiNMKqZykObcSlKTErtLHCIq
+TCCIZC75eHHqZyFd1lreskrGfmGWhQiqotKgLVuKm5mZCXB2MikqC8Qib1gLf+m
XBZ+J7Xrn4vOSLYVoN/WQ16hrzOeQaQSZhg8Kor6pzlsNC4jgDgEJZ6Y3rwQJW7e
NQ3BuFp/7MBoU9zcYG2RWvPtn0GiAELqF12W4TLddemrM+zccdTIx8oJAR0VJhqm
ZkXPH9Q23ZPZhon0mGzKRblHmtKtfsh1Ga2ysgRhIPeVZ67v84Ueshyv2IUE2Kjx
1HANF9TQIHZqmp89bIiR8lV3uZYg/sNQKHs8qyAVfyjHVsopblXsqa2pr7V0rPhH
DANVePflx/XnWWNuYgqfn76EHt3qJY547I0s5HoxO8k9oH2KU3WGjB26pkubvCY9
QNQMc0hH8a7ds3jCDI1iSCFtmJ68juOc4I69DReiRMc8EpK8K+nlNgJVyJlGaWmG
rTRp/O9OG3zzcYBySSSOsPgn27cuFTqRaQ0PSWf9zEqD84t6rj4LgziP04+VcUBW
rSczcKePnVdzVcqjU0LRkzIy/0pKr32TMhnU+ELkw+/fpJ9lHAIf+alqRgf1xbTu
cm15914sFs5lzw+flxdA
=wJht
-----END PGP SIGNATURE-----

--=-ngurhD+aE89nVH7aBrsr--

