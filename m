Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:53683 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754441Ab2ITMBe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2012 08:01:34 -0400
Message-ID: <1348142775.2388.10.camel@sauron.fi.intel.com> (sfid-20120920_140144_429034_0B789F16)
Subject: Re: regression: tethering fails in 3.5 with iwlwifi
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: "Berg, Johannes" <johannes.berg@intel.com>,
	Eric Dumazet <edumazet@google.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 20 Sep 2012 15:06:15 +0300
In-Reply-To: <1347892887.7112.9.camel@sauron.fi.intel.com>
References: <1347361823.26457.3.camel@sauron.fi.intel.com>
	 <1DC40B07CD6EC041A66726C271A73AE6195AE9C8@IRSMSX102.ger.corp.intel.com>
	 <1347631355.5263.19.camel@sauron.fi.intel.com>
	 <1347640763.5263.24.camel@sauron.fi.intel.com>
	 <1347892887.7112.9.camel@sauron.fi.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-ElP4RciqeH00w5NgTeUQ"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ElP4RciqeH00w5NgTeUQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, some updates.

On Mon, 2012-09-17 at 17:41 +0300, Artem Bityutskiy wrote:
> OK, finally I got it. After 3 days of hardcore intelligent bisecting
>         I've found out that tethering in 3.5 works for me if I revert
> these 2
>         patches:
>        =20
>             56138f5 iwlwifi: dont pull too much payload in skb head
>             3edaf3e mac80211: manage AP netdev carrier state

The second patch (AP carrier state) actually exposed a connman issue
which I fixed and submitted a connman patch:
http://lists.connman.net/pipermail/connman/2012-September/011232.html

However, Eric's patch still causes tethering problems to me.

--=20
Best Regards,
Artem Bityutskiy

--=20
Best Regards,
Artem Bityutskiy

--=-ElP4RciqeH00w5NgTeUQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQWwa3AAoJECmIfjd9wqK0C50P/iAv3/523StzcfVsbeh0x3dE
Vh+Dyuu6w0IP15PayPUSddVbXUlEJfJnX1YdAvvDec6SZP/GvIQG1vdOEI+J8rzG
sbtbIokeeAwVJWDORUpG4DIVPE86sjLIQmIoNElWkDXkd0uCAQqiKF/NOOFAYJlH
CwJ/lvyH2Lg56Ms1rJZ0Xi5zl1+BWxPHPOS2eWOzw5Izqrkwaix1d4bzXLE1QQ1h
+i6X2gh0JDWEJKMu0nx5RpUkXqmOG157PXQa0ohUNTihUcwVybQZ68t0iJzWeXPq
93wJnQ2Wnhacm542kwNabF858p+yCUsKgPddyuJwogRDQdTeI2UPuu28ky0kDEDF
k4b+J9QXr2I8+OfB6QDu1FhV7DjXn10j/15MJZerg+Jhgl47NjwJt+quegpiaHq+
yKMoH7EiTPU5V2rCXKXB4w62/qEG0HsdjatkDIPUbNnUPcgcVDOKzYbK17N+xOcU
PluUk4KI/l1GXa0BO3pjz38zuhnjlM47MVLWeSHJMwi9Au9JxoyOdlTqtJFhiYm0
opsYk8occJpktmJ35Y2SZJIkQZebZevGymEA7RCxnFMOOeMJYIqLRP4HEJGN2gBX
4Fgjt9MfcFWkd0oWlj/FWjIuraFxX38+MGPLuqd1LtkdzXoXsS+TdwqhEle3Utnf
Vt+gFbHBlYAIsOMHAzfS
=psEr
-----END PGP SIGNATURE-----

--=-ElP4RciqeH00w5NgTeUQ--

