Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53541 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615AbYJNVNs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 17:13:48 -0400
Subject: Re: [RFC] make ieee80211 invisible
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200810142309.00479.mb@bu3sch.de>
References: <1224006562.10113.47.camel@johannes.berg>
	 <200810142309.00479.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cxiJsz11pAuHkoLJV7hI"
Date: Tue, 14 Oct 2008 23:13:13 +0200
Message-Id: <1224018793.3027.7.camel@johannes.berg> (sfid-20081014_231352_868880_57BF696F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cxiJsz11pAuHkoLJV7hI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-14 at 23:09 +0200, Michael Buesch wrote:
> On Tuesday 14 October 2008 19:49:22 Johannes Berg wrote:
> >=20
> > This makes CONFIG_IEEE80211 invisible. The drivers that require it
> > (ipw2100, ipw2200, hostap) select it, and everybody else really
> > shouldn't even think about using it. Also, since there really is
> > no point in compiling anything without crypto support these days,
> > remove the crypto options and just enable them, leaving only the
> > debugging option which only shows up when a driver is select that
> > requires it. This makes it hard to enable, but most people wouldn't
> > want to anyway.
>=20
> I think in the long term we should also rename it to ipw-ieee80211
> and move it into another directory like drivers/net/wireless/ipw-ieee8021=
1.
> This way it's a lot less confusing for new developers joining the wireles=
s developers.

True. Also, imho we should reorganise:

net/ieee80211/* ->           drivers/net/wireless/ipw2x00/*
drivers/net/wireless/ipw* -> drivers/net/wireless/ipw2x00/*

but as long as the hostap drivers still needs this stuff...

> (Probably also rename the symbols. I'm not sure if it's worth it, however=
)

Heh, at least ieee80211_rx would be nice so it doesn't clash with
mac80211 any more (though we do have the header file trick which makes
ieee80211_rx usable in mac80211 drivers by virtue of being a static
inline)

johannes

--=-cxiJsz11pAuHkoLJV7hI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI9QtkAAoJEKVg1VMiehFYzeIP/2IEwqfrIqU37w5q1l8Jc2K2
CNVoDnHAyuVu7ijH3DroScI6R8EZxjC2ZDsByGHAeOIrNQ5tPvJqdcoxb+3V+ZhB
uPjOIh198Wu87/OewekiLYyLs8NMTMxmSrnM1961wOpm2jOJu43qyMR7NNfpPcZI
2nahZXdaI8x+Bq+wXFncl2DdcepNHz7iMhbLK0lMvtpvwTacFBHmdeygaDDGE4I4
/vz8vmskN8xMqFEZMmwEmDRFWRKUazxmQsLmmDbXfPI5BD3GQg2DityuKf58pN23
DjRB7fan+So97iDIAg27DIH1POiU66A0g58K3ZVun+iWILeUMJyHsDmZ8wIGqdPf
D/n/XP0xO0pfls36jDmAohbg86kkhJr57Uj0/0wre/2ioI2AuU7H/1gglBBz7+5b
ZJgz0zGtms+WTnsrRZ7bT/LKvztq3nx5HYrQxaBIf8qjECJ0vmRD0b8dVjVgJBDT
OkVGAWsYinxK+I3CkniBf+qcEebVigyY5HpNueF4C9hwI1Ef0UQQFD/6NkylybND
V0ivloiDGnmIr9l+5EkR9aOqXq2SM4fP9D319WjcauVcTKoLNOB7PRHKHo5kgJ4i
n5HxbsMttwj9TGIevyQIaYA9m8kNtDlywHyVjP/5cY77SLFx5U/EVrcwFaQVBGvl
fj1aBLcHHRfoAV2n2LQt
=UTTt
-----END PGP SIGNATURE-----

--=-cxiJsz11pAuHkoLJV7hI--

