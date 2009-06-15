Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:32982 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396AbZFOSgI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 14:36:08 -0400
Subject: Re: [PATCH 2.6.31 v2] mac80211: fix wext bssid/ssid setting
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1245082438.23912.7.camel@johannes.local>
References: <1245082185.23912.6.camel@johannes.local>
	 <1245082438.23912.7.camel@johannes.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-UF7W5gmKzoe/y6UTP9JZ"
Date: Mon, 15 Jun 2009 20:35:32 +0200
Message-Id: <1245090932.23912.8.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UF7W5gmKzoe/y6UTP9JZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-06-15 at 18:13 +0200, Johannes Berg wrote:
> When changing to a new BSSID or SSID, the code in
> ieee80211_set_disassoc() needs to have the old data
> still valid to be able to disconnect and clean up
> properly. Currently, however, the old data is thrown
> away before ieee80211_set_disassoc() is ever called,
> so fix that by calling the function _before_ the old
> data is overwritten.
>=20
> This is (one of) the issue(s) causing mac80211 to hold
> cfg80211's BSS structs forever, and them thus being
> returned in scan results after they're long gone.

Also fixes
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=3D2015

johannes

--=-UF7W5gmKzoe/y6UTP9JZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKNpRwAAoJEODzc/N7+QmaeOQP/2AV8kDIyjnyETX4IM9Wk58U
+PBko8MuMxL4E4aO9UCZIII/jsHnmi3syKQ0sSl+Uh4/0mrYZAP/WNt7djRdAukm
+hMEnckb/rCZoJw0uKoNdxBW+G2iTZjRVSH7RG+AEt2RAIyMJMEZcOBrYvYbhb1z
CMe0j375hswLPh+XfTalzsmmyB36yh7hqEfqJJXqawjI49225e26BS6nQcM0RVM5
RvlOI+hgr6nMClSTXKJV9LEHyuiHMznFhA9+NfMoPyI6SE9rzcJw0sQW6CwRVOt1
edXMW9e3R4YVdFVsFU8C6A9WHbPSQNTC0obqgs8E9Jb7PFndsj1xSf4U6rNZWqHh
QaxyWkhhYTF7nXzmiocHGRyTsMgVsSoY1Z5IDhu6q1DWMBGF6PM3vliLuuEi855T
3inCwmJCj8z+3rf6URHTI4Vnyaw9H4ugZDajYMrW5e7qcB2rJj0pchX/60qhwhzE
dyE7Zl2xdU5O1v1nNLMA5+xpUSfigvN6YSKopezX3+DTpCYOndINWSjbMFTgn6tx
xVuF2Npcw9HVn67DlAJC57UHvnWVapyClQrZIb6GsVLEcInFOZDFRSc8EMx4fcan
GUN1cd/zA3gzDnhjygZIDG3ognkUnNJKNWL8T32mOQEMMAm6c0jEaJRFH2RMqxT6
Oo+5QnM9MHLESl3Fhdnu
=wdlt
-----END PGP SIGNATURE-----

--=-UF7W5gmKzoe/y6UTP9JZ--

