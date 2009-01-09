Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52835 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbZAIMoa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 07:44:30 -0500
Subject: Re: [PATCH v2 04/11] ath9k: introduce bus specific cleanup routine
From: Johannes Berg <johannes@sipsolutions.net>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Christoph Hellwig <hch@infradead.org>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Imre Kaloz <kaloz@openwrt.org>
In-Reply-To: <1231504438.3703.11.camel@johannes> (sfid-20090109_133337_686480_7E68BD54)
References: <1231503868-29226-1-git-send-email-juhosg@openwrt.org>
	 <1231503868-29226-5-git-send-email-juhosg@openwrt.org>
	 <1231504438.3703.11.camel@johannes> (sfid-20090109_133337_686480_7E68BD54)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-F2coAK163uZgaLF/D18N"
Date: Fri, 09 Jan 2009 13:44:57 +0100
Message-Id: <1231505097.3703.13.camel@johannes> (sfid-20090109_134434_537829_0F905C1E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-F2coAK163uZgaLF/D18N
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-09 at 13:33 +0100, Johannes Berg wrote:
> On Fri, 2009-01-09 at 13:24 +0100, Gabor Juhos wrote:
>=20
> > +static void ath_cleanup(struct ath_softc *sc)
> > +{
> > +	ath_detach(sc);
> > +	free_irq(sc->irq, sc);
> > +	ath_bus_cleanup(sc);
> > +	ieee80211_free_hw(sc->hw);
> > +}
>=20
> Umm...

Wait. I got confused, this is ok of course. The original ust had
ath_pci_cleanup doing all this. Sorry!

johannes

--=-F2coAK163uZgaLF/D18N
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJZ0bGAAoJEKVg1VMiehFYIs4P/1sjig2jnHRhsaUuUE0U7D6p
5Y7fhjyGgmk9aWJJAg//91MZoNZ3zgTWOC1IjtXNrJLyYlxuzXiUg7TqaEy9RmRY
OJkTsP0+5FWf0D9Ar0YctuMZL2Wh4HT3hcpwHza07+OATykvfS3JurEKA3I5VnZ+
ut8UpYj3mbpZ+WtoWerhawX/Mei5Uh97IxuqaoYwvUKP8SPiciumA/JIJYSh+585
Lj3w9CUA8tYl1uxa7iM1VuSAA6olbllJJAkCjNmN6ou0eaMJBKuhCSQamrigset/
RcgjHNJ7Dj6OvNAe4tYkYaFE0Bth3xzUEBhAIemZWtSF75qbK6qP90AWjIWlhiHk
uNrKLU9tcxmeIS9ZNyYzJk0Lob/MJjWjgAijzcS1HG+k3q64FM18w1vRDYtCbjtr
HOKx6XqqBM14Xyn+OQSEHLPTbUQynYnBhJhQapBuuJh8kMEqu8aDfo30r+XcKncs
iUNjpzO1cfYRpsKnuuvJZdn6v6DuxhwV4oe+swDVoYNm/Oau9TR10Bb6ZgHuRIkT
j3PkYp7baau0GX7fTHMYdv4O0B27BcS2WXgdZm11pA6W9iLinQAcpKw5HvYszNT5
oTvjbWlQc9robXcvGEc2vWD/tiPQsEOczI/DK9BXCnNDDVn/aSrznMyHPW5LjZym
NOKvIC7u3L6GW+RRQAQE
=8XTB
-----END PGP SIGNATURE-----

--=-F2coAK163uZgaLF/D18N--

