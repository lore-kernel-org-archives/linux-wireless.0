Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43373 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756954AbYEMIkN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 04:40:13 -0400
Subject: Re: [RFT/C 7/7] mac80211: move TX info into skb->cb
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org
In-Reply-To: <200805121426.12656.IvDoorn@gmail.com> (sfid-20080512_141529_851292_7D1477CC)
References: <20080510221845.340428000@sipsolutions.net>
	 <20080510221908.875473000@sipsolutions.net>
	 <20080512.021145.265455571.davem@davemloft.net>
	 <200805121426.12656.IvDoorn@gmail.com>
	 (sfid-20080512_141529_851292_7D1477CC)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-O3FC4E8jI5tmes6rnP/D"
Date: Tue, 13 May 2008 10:40:01 +0200
Message-Id: <1210668001.3646.39.camel@johannes.berg> (sfid-20080513_104018_689554_C8FEE2C0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-O3FC4E8jI5tmes6rnP/D
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-05-12 at 14:26 +0200, Ivo van Doorn wrote:
> On Monday 12 May 2008, David Miller wrote:
> > From: Johannes Berg <johannes@sipsolutions.net>
> > Date: Sun, 11 May 2008 00:18:52 +0200
> >=20
> > > This patch converts mac80211 and all drivers to have transmit
> > > information and status in skb->cb rather than allocating extra
> > > memory for it and copying all the data around. To make it fit,
> > > a union is used where only data that is necessary for all steps
> > > is kept outside of the union.
> > >=20
> > > A number of fixes were done by Ivo, as well as the rt2x00 part
> > > of this patch.
> > >=20
> > > Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> > > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> >=20
> > Please create an IEEE80211_SKB_CB() or similar macro to wrap
> > these casts around with, like all other SKB CB users do.
>=20
> Johannes, I have such a function in rt2x00queue.h:
>=20
> static inline struct ieee80211_tx_info* get_skb_tx_info(struct sk_buff *s=
kb)
> {
> 	return (struct ieee80211_tx_info *)skb->cb;
> }
>=20
> You could rename it and move that one into mac80211.h

Yeah, I suppose that's what I'll do, thanks Dave, Ivo.

johannes

--=-O3FC4E8jI5tmes6rnP/D
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASClT4KVg1VMiehFYAQKmWw/+PZ8hVhC626R/MTiAkECj9ds7PrSamkqn
nOX1r0W2nZu+NZCON3diLWd7dURi5QCC76hCDTvmpScBO9yerBVps4bi5cUC2Rka
q7h6zhA8cDBayiWuHphAb/3Uk7KqJSuYiqJcj88A1LqGrMEepf4ZSN6daLUWdDbg
uO7NTl9ZH3FxDH1IhI1f0Tbb8PM4aheHw2UVjqmQGWNrVNMUjpfqhL/RrlC5WgK3
bfvtKSe9We1yAWIdu2c7SiDXjZxTBAfpmMnvmPWJTVb71eJfR6pUwLeJ5uZmOpCs
IvFQWVpEfNAJRRri39dmH8MCojLNIcAWkQsqRhrKRwcOBgh22bDeFGqFwh7pnuYw
uQ80sXvruWlje9XaLp6yYwua9PUHc2iQLvHEOr1eYT2WBtGHuxF26/CRazYULZFL
fcsVcCsAX/aGXeZxyKvkswJRXV4U18GbGwC7DBx8cmGjk0AOtVkclNrP9bzFPwXx
MvMCNLaDQBguPT0bvZj1PEGSvUaSb2fqumBrHPKgPrpd4le4KLIRxXBQOL+xPM2h
5AWTnsAVmpymuiR+oqToBn3HP2YA0DLyo3ODb2WAs8tOT5QB2WLbanyqfXiLuanI
9PbvuzQOw4OrEySUs+TvVTVtT1ikaRne/mig9LMS1TVw1wIoVnauWSLF9F74k+GZ
6W2m4xqbdoo=
=xsAq
-----END PGP SIGNATURE-----

--=-O3FC4E8jI5tmes6rnP/D--

