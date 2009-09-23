Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58656 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262AbZIWHVw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2009 03:21:52 -0400
Subject: Re: [RFC] nl80211: introduce NL80211_ATTR_SCAN_EXPIRE
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: Dan Williams <dcbw@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John W Linville <linville@tuxdriver.com>
In-Reply-To: <200909230912.57417.hs4233@mail.mn-solutions.de>
References: <200909181849.22302.hs4233@mail.mn-solutions.de>
	 <200909210946.19675.hs4233@mail.mn-solutions.de>
	 <1253662172.2510.60.camel@localhost.localdomain>
	 <200909230912.57417.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-WrR2JOkOPoZPXaSNOYwT"
Date: Wed, 23 Sep 2009 09:21:45 +0200
Message-Id: <1253690505.4458.29.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WrR2JOkOPoZPXaSNOYwT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-09-23 at 09:12 +0200, Holger Schurig wrote:

> There's just one case: if there is no BSS in the scan list.
> Then any app doing a "get scan results" call wouldn't know
> if the last scan is ages ago or if there is really no AP
> in the vincinity, doing an immediate re-scan. This can be
> harmful for battery-driven devices. So maybe a timestamp
> "last scan was at timestamp XXX" besides the individual
> BSS timestamps would be helpful here.
>=20
> This way apps can synchronize themselfes and, even if
> different apps do scanning, they can say "We don't scan
> more often than every N seconds".

You can monitor nl80211 events for scan completion already, so this
isn't really an issue. In fact, adding a "last scan" thing would not be
a good idea since the scan might have been different, only contained a
subset of channels, etc.

johannes

--=-WrR2JOkOPoZPXaSNOYwT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKucyFAAoJEODzc/N7+QmaragQALR5lFDklG1ss5ACb6MXsOly
EiMmeLAjP4sQPs+lv6fkIYg6CakUFenRwiVPeXV1HDpze9z9EOw59DBtMoZ7MnI2
yXJ9gKvjt9cbFLeeAzcTZhzzxlntrADJ8yUF9YRBiZerWA1wm+wzdl2ker1f049n
8Pvvl6oGH34RabClyS/8u5tib2JhWDSPZXyf9ZlxJ7KYt9rX0O1RvfFlAl6JxPrH
S6zhTFMUzzA/4x3llAybj8mJLZ+uukdsNduxVdNcSaV27+iNX15weMkIckzWk3q/
CtX2DUkquc+Sc0TL5q/RLwtLc48rja57gc4+BA52l4G5XuVo2H2//wp84qVKNkPX
gH0Tt3vBkowBrmvbwrlMLMWV9wlFOL1PRVTnA+k/IUMNgCnUyzM7P7h9zomGyQth
t1Y8a/sZXiZ4CzMbuKvsvmzgewbob1cty2MdcfTjz56O4F8RLGrwOjQzV+TFnLBG
LCx+CsfYTYuEchBhp3oZ8TjCqRey7nT1iNEQ6kPvICRXVGNn7L2VTkxsltQrtTAL
D5zaNYE20LZ0+M3OnRPnM3Ks6evdoZTyccytDBpYcu27AQ9RhaSDsA3sClZS1qOI
tQEUed4yKuzvq7qpID76xVK9GFsdOlCZf2T7F+tzYSH7g1yB8hFG2uxyy8QZUUHQ
31IanHBqyuH9KPvdtn5O
=C1ZX
-----END PGP SIGNATURE-----

--=-WrR2JOkOPoZPXaSNOYwT--

