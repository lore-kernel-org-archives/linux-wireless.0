Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38149 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbYGIOGK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 10:06:10 -0400
Subject: Re: [PATCH 1/3] mac80211: Include sequence number in IBSS and Mesh
	beacons
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <200807091600.44437.mb@bu3sch.de> (sfid-20080709_160115_282398_A7D0F576)
References: <200807091511.14288.IvDoorn@gmail.com>
	 <200807091538.09387.mb@bu3sch.de> <200807091604.50199.IvDoorn@gmail.com>
	 <200807091600.44437.mb@bu3sch.de> (sfid-20080709_160115_282398_A7D0F576)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YRtxxgXYVXMzWhANIBCu"
Date: Wed, 09 Jul 2008 16:05:22 +0200
Message-Id: <1215612322.3246.12.camel@johannes.berg> (sfid-20080709_160613_803930_1CD92E91)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YRtxxgXYVXMzWhANIBCu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-09 at 16:00 +0200, Michael Buesch wrote:
> On Wednesday 09 July 2008 16:04:50 Ivo van Doorn wrote:
> > On Wednesday 09 July 2008, Michael Buesch wrote:
> > > On Wednesday 09 July 2008 15:11:45 Ivo van Doorn wrote:
> > > > Currently only beacons generated in AP mode have the software
> > > > sequence number inserted. This means IBSS and Mesh mode are broken
> > > > for all hardware that require software sequence numbers.
> > >=20
> > > Does software seq numbering even work at all?
> > > What about packets that get sent between the driver requested the
> > > beacon and the driver does actually queue it?
> >=20
> > For rt2x00 the beacon is requested and queued within interrupt context
>=20
> Well, another CPU could be in progress of walking down the mac80211 TX co=
de
> and aquire a sequence number in the meantime before you requested the bea=
con.
> However that frame will be blocked by your driver locks, so the two seq
> numbers of the beacon and the other frame will be swapped, as the driver
> will queue the beacon first.

Indeed, I was wrong.

I wonder if we should remove the hwseq support completely. It's much
easier for the driver to do this, especially since we pass a vif pointer
with driver-private data to all relevant functions and the driver could
keep the current sequence number in there. Or, just like hwseq would,
keep a global sequence number?

How does that affect multi-bss support btw? Do we have to use sw seqno
for that?

johannes

--=-YRtxxgXYVXMzWhANIBCu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIdMWeAAoJEKVg1VMiehFYdPsP/jj2JsPm1M/c7hlQzqnk4mB3
Jca8YjrIxDJ73NVe8EicfY0kRa+xpEjY50mcK5kP5VD7ih9N4VslLyKoIIfF+q91
/j003isBAOJQrNubl6unHEwo3cSMi8S68R3IcHu+IH2XbJDMf5Iy6I/E3k4pD1WC
Nww23ZBa1Ci3uwK8i5XbhaWn2U//x237N/qVPZI+6hw/JsBAZdadhR1/yvF/dUzS
6M/O/vb3PExtc9Do4ACpcu8TrGzUJzhJ9A/gFOVSAZrCMnvJU+FG3D0JLqiIMFaM
fbObeDv3taYCdrMh7SdotxO9YXyn+Q0ay016UM7v27YM8fV0/hky/tB2G1uHRo77
DQH/FydAFAzotyuE0pXAxsHLr+21BRj/QQKRCXzdM4pFWJgk7bUicQNW1ErfZn8A
xFSvXibiJPpshLXGdmQNrIj3gVBCIHZpUAxRWgjn4/aniL83kCxmyicUAnie4/Hm
JWv4ghBV77YTFfj+mWnIzNY44P/wyfwC9yzhTSKom5eywv7zt6GRQ3vec/XR0mkD
06JlNQueDuBcOZ3lPyULqxVGF4ppi10gXh4CQuGbrE5KNSLm85GACR/+bIMGfNHE
SOAo4SuDj/3p4kaDPE5xr9eSDTHPp8oQnJGOJm6fynZqJoswCDOfPrrY2GlLLxV9
4GwzW2f7VXM51v5DWG1c
=DXO8
-----END PGP SIGNATURE-----

--=-YRtxxgXYVXMzWhANIBCu--

