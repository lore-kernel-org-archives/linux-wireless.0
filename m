Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42767 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770Ab0BAT1p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2010 14:27:45 -0500
Subject: RE: [PATCH 1/1] cfg80211: wext: set bssid to NULL in SIOCIWESSID
From: Johannes Berg <johannes@sipsolutions.net>
To: "Zhao, Shanyu" <shanyu.zhao@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <380B2771CDD78E46856E6B788D9F199750233886@orsmsx503.amr.corp.intel.com>
References: <1264808376-8003-1-git-send-email-shanyu.zhao@intel.com>
	 <1264840626.3546.181.camel@johannes.local>
	 <380B2771CDD78E46856E6B788D9F199750233886@orsmsx503.amr.corp.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-mxQ9yYjI2fJqxQaB7y28"
Date: Mon, 01 Feb 2010 20:27:40 +0100
Message-ID: <1265052460.29119.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mxQ9yYjI2fJqxQaB7y28
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-02-01 at 10:57 -0800, Zhao, Shanyu wrote:
> Actually I don't think my patch disables that functionality. If
> there're multiple AP with the same essid "foo" and one of them has MAC
> "00:...:ff", then:
>=20
> iwconfig wlan0 essid "foo"
> This will make the station associate with the first AP with essid
> "foo".
>=20
> iwconfig wlan0 ap "00:...:ff"
> This will disassociate from the previous AP, and then associate with
> the first AP with MAC "00:...:ff".
>=20
> Am I missing anything here?

No, I missed something. The problem will only occur when the SSID is
hidden as well, because the connect code will not have the SSID and not
know what to scan for, or which SSID to choose (there are Cisco APs that
use the same BSSID for multiple hidden SSIDs).

johannes

--=-mxQ9yYjI2fJqxQaB7y28
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLZysmAAoJEODzc/N7+QmabQIP/0zrQvwyW9AIA0zVm4x33O9k
+A0So4WPT8b3Z2jQETE2l7034m3vhhQsz13L5w0kSz736kniXoH04E3wVaY79dGD
P/tM3Gfn5dDS4xiEelJ0Swi921B0JZcRA5tApNzpSQZklZj5EAmHEkexFZ1XnhNr
6IRpeCGWJwDjKU6KdwKSQJjeSTvZsqHbYpKqBcUFVr3jD4bfl252fC5KEkxRr5+i
ph+nInx3P2SXy6tOT4s3o5VrpTzqGjkvNV47U0WMya0HnkhVZ1Z04KN64CDw9xTz
8Zx6mfiztw9b6WyA9m4IeK9vKfM//0tWJR6FV7tTJ+tg91RZIwpQZbMiznEh7F/v
Jrt87H7HAxMtOEJdpb45+L/lvLXeZ9Jg8WI5n28lIFOy6aEMN7aL1530XJJB3uGS
J5y/meWlh8ksuXQq75pttghjsM5XY/zfc+DHvpV2z9Qb94ixSUlvQzzs+PgXnmn3
b3O3nvruucHAulVoCOnXBb9mshK0V/HbOeznEGuPw8MELwZtoSDs2qrav5FPHgDg
K0nPKL4oo7Wb5lTfhhtUkMIYUjdDKKqUPSRKqTtEYOTjdSjLOZOK3UcZCMXCEgLh
xtw9gNbinwCJv7wjJtdrTOvi5IG1jteq7aabTj++ihOfvFmbwrZNuXtaGdr1EvJ8
bDXAlyuFA2/DwNurH52W
=5jM9
-----END PGP SIGNATURE-----

--=-mxQ9yYjI2fJqxQaB7y28--

