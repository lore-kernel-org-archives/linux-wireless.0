Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43211 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbZJWREE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 13:04:04 -0400
Subject: Re: [PATCH 17/19] [RFC, v2] libertas: Kconfig entry for
 libertas+cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1256316776.2164.54.camel@localhost.localdomain>
References: <20091022133043.185554096@mail.mn-solutions.de>
	 <20091022133425.317619132@mail.mn-solutions.de>
	 <1256307572.12174.33.camel@johannes.local>
	 <1256312995.2164.7.camel@localhost.localdomain>
	 <1256313851.12174.131.camel@johannes.local>
	 <1256315335.2164.44.camel@localhost.localdomain>
	 <1256315496.2164.47.camel@localhost.localdomain>
	 <1256315972.12174.168.camel@johannes.local>
	 <1256316179.2164.53.camel@localhost.localdomain>
	 <1256316535.12174.186.camel@johannes.local>
	 <1256316776.2164.54.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-twW6urzsVAvQJYo9MFdj"
Date: Fri, 23 Oct 2009 19:04:04 +0200
Message-Id: <1256317444.12174.203.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-twW6urzsVAvQJYo9MFdj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-10-23 at 09:52 -0700, Dan Williams wrote:

> > > Yeah, I think it's best to handle the mesh WEXT ioctls separately for
> > > now.  There are really only 4 of them (get/set SSID, set channel, get
> > > mode) that matter for mesh.  The rest of the ioctls that the mesh
> > > interface supports get redirected to the cfg80211 handlers because th=
ey
> > > aren't specific to mesh.
> >=20
> > So why can't we simply do
> >=20
> > set_ssid()
> > {
> > 	if (mesh)
> > 		return mesh_set_ssid();
> > 	else
> > 		return cfg80211_wext_iwessid()
> > }
>=20
> The mesh interface is a completely separate netdev, with its own WEXT
> handler struct.  So we'd never be in that situation.

Ah right. Yes then it makes sense to just remove all the non-mesh WEXT
stuff.

johannes

--=-twW6urzsVAvQJYo9MFdj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK4eIAAAoJEODzc/N7+QmajcoP/08WgVdS8APnxvjN0eJaZICD
empZ4Fl37ZlDHPOLuViX0xFUzM9X9IWXTH4aK531CMe+7PGelVPcFNRzpJaiQAdD
onwO/kkUjmlObw2DGsTfG8jaj9+aWGyeJJO8nDRyonKmvkzYR3ObwromKu7rbY8K
iyZHIuoEvB+oY1MfiBFsjeuOkc58Px7D+/Uns0wE0o7PLh3VCAoZjV9gzeGD2ym/
akUZJ1FkhzFPnZhZ69JPwhVLdNN9ro/wuiFH+cHYZeqgcaXYuQa12jIlwaULBBXO
R2bfhhNav8lbMJ7RH3hJgkZZ7rvRHYwooLMX4tNFMCArqVmbqW4m5N0PqXSU1jN7
Ja/zdk40UUO2Nk04oy2qEQa8cBivORHpQgOE5K8JyZ2mwVJns6GljDaFnr8vZfO5
hJVP9cCxpI++tfmiL8TWEuDQM9XxZh1+Rfi5Z/eup3SkhBpggVkW/7rWCjrcgosk
Hwilf/8Ma5jYsZCzSwTMT8x/Tm6zo9wFJP0mYY4gF12/3DDtS1bJhUgVLYmOXXy5
09GUXsu5Bbu87uW5TjMayEkE3yIeqVfgCkttLGI0hnfwaSqNHeeI8YRTEW59TJhp
znRCh7sWzYZL3Wlv4Z0fVe0zfthyGWXwtDsnst1mXNR8BkMHPODweBG/TSJ64jFl
REx9wYu2bfMuIln6tl3p
=byvo
-----END PGP SIGNATURE-----

--=-twW6urzsVAvQJYo9MFdj--

