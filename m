Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48769 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbZBDPKi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 10:10:38 -0500
Subject: Re: [PATCH RFC] mac80211: Filter scan results
From: Johannes Berg <johannes@sipsolutions.net>
To: Samuel Ortiz <samuel@sortiz.org>
Cc: John Linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090204150857.GA5069@sortiz.org> (sfid-20090204_160640_465532_8378EED5)
References: <20090204150857.GA5069@sortiz.org>
	 (sfid-20090204_160640_465532_8378EED5)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jOsAaXEukROMRoifvahV"
Date: Wed, 04 Feb 2009 16:10:01 +0100
Message-Id: <1233760201.3992.20.camel@johannes.local> (sfid-20090204_161044_782961_6D7B361C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jOsAaXEukROMRoifvahV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-02-04 at 16:08 +0100, Samuel Ortiz wrote:
> From: Samuel Ortiz <samuel.ortiz@intel.com>
>=20
> In very dense environment, the scan result buffer can get really large, m=
ostly
> due to the addition of proprietary IEs. iwlist fails, typically warning a=
bout:
> "print_scanning_info: Allocation failed". wpa_supplicant fails as well, a=
fter
> reallocating the scan result buffer several times, up to 132 Kbytes:
> 	[snip]
> 	Scan results did not fit - trying larger buffer (131072 bytes)
> 	ioctl[SIOCGIWSCAN]: Argument list too long
>=20
> By adding a mac80211 module parameter, we can filter the scan results and=
 keep
> only the ones userspace currently worries about, i.e. WPA1, WPA2, WMM and=
 WPS.
>=20
> To activate this feature, 1 has to be written to
> /sys/module/mac80211/parameters/ieee80211_scan_ie_filter

Module parameter, hard-coded filter, just to work around wext crap. Eww.
NACK.

Go for
http://johannes.sipsolutions.net/patches/kernel/all/LATEST/028-cfg80211-sca=
n.patch
instead.

johannes

--=-jOsAaXEukROMRoifvahV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJia/GAAoJEKVg1VMiehFYSqsQALCSOjclNP8WxVuf3vnpylPy
KsipdHWnofz/KljQLXu68CbRZdFUa/j+DrHkOOQyUfdSx7dvBMeLmIhsYHahnNS3
GDSGS/heLfeug6DNFZAOUn3ayUgAIFL8nSpDbtogV7zGMApjs8mgsbevpa1vdsjN
AyAXU4a/dV7t4IKX+dAv3UnodxyFa2cN2ZO79KsSgD3YzoVIlK6fEsVf43mFhljE
ksovLqCvHpzwk/95p+zuitnw4J4IHOCSZVj+uOh2BA1IUFjh6S8cTP9HqqjLhsZI
R9RxRF2KW1vKBhYmRFr4QfOub2in3EQLV5jGQuhn65kpoE3VoHlwR58xVKdq6wGM
mDFrLKcJaDQF3SM3syGOEWYHku4OuAB5A870KbybPjXpkA75B9tNy1ZUdU23R/2N
RGhcHeaQXQXOXfv28Qco8jWQyzZqiCFsaf9R/+GzqU63m2THQILjTcUrUJ3q9jju
IWxdUPVhw7yZxXU7PvfClldqwSeEDnxKPUExyedux0CbDjrG2S1qo47z0B2lbVa3
ItAaQin+CSoVQUKuqtI79TCO0wl8lQ/L6P2Azd5QF9WQMPGRZmvaoj/H03ExLpEc
xufT8bvZ/9KEAtqSPWZZGrJItzHm1jZUO2thWuny6QIGHlmrS/TE6BN1OTlmhBw8
2GxNkPrDk84Kvgv/wdmy
=BrUQ
-----END PGP SIGNATURE-----

--=-jOsAaXEukROMRoifvahV--

