Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37767 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125AbZBDXgY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 18:36:24 -0500
Subject: Re: [PATCH RFC] mac80211: Filter scan results
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Samuel Ortiz <samuel@sortiz.org>,
	John Linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1233789837.24227.19.camel@localhost.localdomain> (sfid-20090205_002533_129658_8CBEAF4A)
References: <20090204150857.GA5069@sortiz.org>
	 <1233789837.24227.19.camel@localhost.localdomain>
	 (sfid-20090205_002533_129658_8CBEAF4A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bNSZk4ZmESHeoELVVsTa"
Date: Thu, 05 Feb 2009 00:35:39 +0100
Message-Id: <1233790539.7390.23.camel@johannes.local> (sfid-20090205_003636_507974_9A252BDE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bNSZk4ZmESHeoELVVsTa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-02-04 at 18:23 -0500, Dan Williams wrote:
> On Wed, 2009-02-04 at 16:08 +0100, Samuel Ortiz wrote:
> > From: Samuel Ortiz <samuel.ortiz@intel.com>
> >=20
> > In very dense environment, the scan result buffer can get really large,=
 mostly
> > due to the addition of proprietary IEs. iwlist fails, typically warning=
 about:
> > "print_scanning_info: Allocation failed". wpa_supplicant fails as well,=
 after
> > reallocating the scan result buffer several times, up to 132 Kbytes:
> > 	[snip]
> > 	Scan results did not fit - trying larger buffer (131072 bytes)
> > 	ioctl[SIOCGIWSCAN]: Argument list too long
> >=20
> > By adding a mac80211 module parameter, we can filter the scan results a=
nd keep
> > only the ones userspace currently worries about, i.e. WPA1, WPA2, WMM a=
nd WPS.
>=20
> A somewhat more acceptable, but still unacceptable hack would be to
> figure out when the returned scan results buffer would be too large, and
> automatically filter the IEs when it would be to large.

Nope, that doesn't even work. You'd filter even before the app decided
to no longer reallocate the scan buffer.

johannes

--=-bNSZk4ZmESHeoELVVsTa
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJiiZEAAoJEKVg1VMiehFYxXYP/A2pTkU5cWGsWCNv1Qks3+pM
DIF7eQG+sPBvXxYbk7beW0ysA75lZkj/e1RdMbl/vE1445Ol8xXUATzhX6g8ZJgc
NekgqaxqjWzLtpzmr71d/gkbkqEXmbAzCji0w5dpqa99asy78Kry5NnhT2dWOU4P
CLX3agIwefFy1OlDbDtGeqcbSFvTjhfL5GN8BvAdRABlcv9XjYsZpIEyzfTM6xit
1koa3iOt0rDsbVz9zmEen9Qp1ZChKMDaFFg7XgMKQdnWL4VkMZtbXbmQhHPTOWye
Xz6ODtpdrLDc8/sKQFgnZ2suFnHIU5BZhNJXo/7cPTjDjIgGiLYDCJ2+fwVb2pAS
unKdTnMXD5DGYSAgKuAVdfCgPCz4SRWvhiXDqYHeNIIDgoRxkyiSfQQ0TDP6kUQp
r/34brym6wACJO8j6/1CycwjjshfUw308tUQWhHJnNpylY26jFopt67MXXbBYPJP
Szvysog7O+lCu5KD505TFvSvoxGEIdSDQr5jPpT8Uhe3XDDCEAWmHnscfShiC/As
DSw7xFMk5CIwGRwLl36Aha67NTF69uZugyUzn8VhcMc7z+GAogt3w1vjR53EsG/t
Fmq99PRq+sGvdhKR951iKTf1h/jNCgkucgyYcgxh54uuZ/484WhKCNoLcksPAJyS
QCx0Z4O2c1Lc53PCxTgB
=bLPv
-----END PGP SIGNATURE-----

--=-bNSZk4ZmESHeoELVVsTa--

