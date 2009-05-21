Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49631 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbZEUJWL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 05:22:11 -0400
Subject: Re: [PATCH 1/2] wireless: move some utility functions from
 mac80211 to cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: drago01 <drago01@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Ortiz, Samuel" <samuel.ortiz@intel.com>
In-Reply-To: <1242889781.24825.611.camel@debian>
References: <1242872340-27417-1-git-send-email-yi.zhu@intel.com>
	 <1242872340-27417-2-git-send-email-yi.zhu@intel.com>
	 <f6ca9fed0905210012t2b494db5w3169ef2e8db2b04b@mail.gmail.com>
	 <1242889781.24825.611.camel@debian>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4e+iICh1bhcR33gDmts1"
Date: Thu, 21 May 2009 11:21:59 +0200
Message-Id: <1242897719.5471.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4e+iICh1bhcR33gDmts1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-05-21 at 15:09 +0800, Zhu Yi wrote:

> > Isn't lib80211 a better place for those ?
> > Its purpose is sharing code between fullmac and softmac drivers.
>=20
> These functions are moved from mac80211 which currently doesn't link
> with lib80211. Johannes might have more to comment.

Yeah, lib80211's stated purpose is to share code, but on the other hand
code that mac80211 and fullmac drivers may need seems better suited in
cfg80211 since lib80211 also ships a large code bit of crypto routines
etc. that are just useless for this and mac80211.

johannes

--=-4e+iICh1bhcR33gDmts1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKFR0uAAoJEODzc/N7+QmahQEP/RGugb4OXoB0xPao+TvnjpV/
ukY7HM0DYezDj1aRLZEgBLA3h17ttVG4KwytN6nS+Z+uycIJ+PrH5m8sb4FFFHye
7/UwGf8KLaJBNe1vRYigX1t8iW77EgPvbVd/T3x6Y0GYMw1Hyo+5xBnf3IltyzKt
gDulLUCL1BzY3r45II6A2JRkQ5u7/ldq+1mnuWta0kTkyTyhjNBPZJIHoDVE0M+M
OLXVYoeoAtEZZfG45iVr6cT3L653e2SFJyWt1GBsbiQ9CNPBOAto46jwv/Vxsaci
X04e+Jf/DfPf30YuVf0UfttnjToCU5JcZilh/amrRHw3C54yCfTtVexjHTsYDNAr
xAlSyDwoo+ugHrqSCmI6EpySPhFojBQT0kM/UJWCzzhNFMPNa6b9gA4jLlttegSI
IK7ApQf9ycD/V9PZvB1ScoX23qqPoedF9hNS0IOVbt4h1j9OqoqY56ZWGG61bkpf
sqo1ietJc3gLEx5weHeFVLRqKtZ6V4jXuY13hU3dt8oRSlHjtlCnjyUE8EwHAZTj
JqU2mljld//LCc6gwZ/EVvd1QUwMrYVah2vmORu/cOpL9uEb0NO4vahF794P91uK
BCzszC8pQYOqMMtYl1d6HpIJufM0OtKiJvo2Y7WaNdzuzdsKZ8zCMYAYNS3U1pp7
9nSnQfgEzDFklETAQLsr
=RsjN
-----END PGP SIGNATURE-----

--=-4e+iICh1bhcR33gDmts1--

