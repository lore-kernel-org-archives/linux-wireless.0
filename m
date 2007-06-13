Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49533 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758263AbXFMPqg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2007 11:46:36 -0400
Subject: Re: [PATCH Try#11 3/4] cfg80211: Radiotap parser
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: andy@warmcat.com, linux-wireless@vger.kernel.org
In-Reply-To: <200706122242.08045.flamingice@sourmilk.net>
References: <20070612130435.896010304@warmcat.com>
	 <20070612130502.157979021@warmcat.com>
	 <200706122242.08045.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-EwyvQ/2KSzxPKJ3IbgXB"
Date: Wed, 13 Jun 2007 17:46:36 +0200
Message-Id: <1181749596.29767.82.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EwyvQ/2KSzxPKJ3IbgXB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-06-12 at 22:42 -0700, Michael Wu wrote:
> On Tuesday 12 June 2007 06:04, andy@warmcat.com wrote:
> > +typedef enum  {
> > +       RADIOTAP_PARSER_OK =3D 0,
> > +       RADIOTAP_PARSER_DONE,
> > +       RADIOTAP_PARSER_INVALID
> > +} ieee80211_radiotap_parser_retcode_t;

> Yuck. I much prefer the standard error codes used in the previous version=
..

I would as well, but as I outlined before we basically have four things
that can happen
 * we found a next item we understood
 * we have a parser error
 * we reached the end
 * we found an item we can't support (and thus we don't support any
   further ones either assuming we add support sequentially)

I would like to be able to distinguish all these cases, the previous
version couldn't distinguish between the last two. However, I'm not
convinced that error codes are reasonable for something that isn't an
error (i.e. reaching the end)

johannes

--=-EwyvQ/2KSzxPKJ3IbgXB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGcBFb/ETPhpq3jKURAo1kAJoDjtJHBjfbf85WIOSbz0Y3E8J/kwCghGYK
tRCEVKtOpyBtqfDRh5N6Kw8=
=STG5
-----END PGP SIGNATURE-----

--=-EwyvQ/2KSzxPKJ3IbgXB--

